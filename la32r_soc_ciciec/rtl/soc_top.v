/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Copyright (c) 2016, Loongson Technology Corporation Limited.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of Loongson Technology Corporation Limited nor the names of 
its contributors may be used to endorse or promote products derived from this 
software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL LOONGSON TECHNOLOGY CORPORATION LIMITED BE LIABLE
TO ANY PARTY FOR DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

`include "config.h"

module soc_top #(parameter SIMULATION=1'b0)
(
    input           clk,                //50MHz 时钟输入
    input           reset,              //BTN6手动复位按钮开关，带消抖电路，按下时为1

    //图像输出信号
    output [2:0]    video_red,          //红色像素，3位
    output [2:0]    video_green,        //绿色像素，3位
    output [1:0]    video_blue,         //蓝色像素，2位
    output          video_hsync,        //行同步（水平同步）信号
    output          video_vsync,        //场同步（垂直同步）信号
    output          video_clk,          //像素时钟输出
    output          video_de,           //行数据有效信号，用于区分消隐区

    input           clock_btn,          //BTN5手动时钟按钮开关，带消抖电路，按下时为1
    input  [3:0]    touch_btn,          //BTN1~BTN4，按钮开关，按下时为1
    input  [31:0]   dip_sw,             //32位拨码开关，拨到“ON”时为1
    output [15:0]   leds,               //16位LED，输出时1点亮
    output [7:0]    dpy0,               //数码管低位信号，包括小数点，输出1点亮
    output [7:0]    dpy1,               //数码管高位信号，包括小数点，输出1点亮

    //BaseRAM信号
    inout  [31:0]   base_ram_data,      //BaseRAM数据，低8位与CPLD串口控制器共享
    output [19:0]   base_ram_addr,      //BaseRAM地址
    output [ 3:0]   base_ram_be_n,      //BaseRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output          base_ram_ce_n,      //BaseRAM片选，低有效
    output          base_ram_oe_n,      //BaseRAM读使能，低有效
    output          base_ram_we_n,      //BaseRAM写使能，低有效
    //ExtRAM信号
    inout  [31:0]   ext_ram_data,       //ExtRAM数据
    output [19:0]   ext_ram_addr,       //ExtRAM地址
    output [ 3:0]   ext_ram_be_n,       //ExtRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output          ext_ram_ce_n,       //ExtRAM片选，低有效
    output          ext_ram_oe_n,       //ExtRAM读使能，低有效
    output          ext_ram_we_n,       //ExtRAM写使能，低有效

    //Flash存储器信号，参考 JS28F640 芯片手册
    output [22:0]   flash_a,            //Flash地址，a0仅在8bit模式有效，16bit模式无意义
    inout  [15:0]   flash_d,            //Flash数据
    output          flash_rp_n,         //Flash复位信号，低有效
    output          flash_vpen,         //Flash写保护信号，低电平时不能擦除、烧写
    output          flash_ce_n,         //Flash片选信号，低有效
    output          flash_oe_n,         //Flash读使能信号，低有效
    output          flash_we_n,         //Flash写使能信号，低有效
    output          flash_byte_n,       //Flash 8bit模式选择，低有效。在使用flash的16位模式时请设为1

    //------uart-------
    inout           UART_RX,            //串口RX接收
    inout           UART_TX             //串口TX发送
);

wire cpu_clk;
wire cpu_resetn;
wire sys_clk;
wire sys_resetn;

generate if(SIMULATION) begin: sim_clk
    //simulation clk.
    reg clk_sim;
    initial begin
        clk_sim = 1'b0;
    end
    always #15 clk_sim = ~clk_sim;

    assign cpu_clk = clk_sim;
    assign sys_clk = clk;
    rst_sync u_rst_sys(
        .clk(sys_clk),
        .rst_n_in(~reset),
        .rst_n_out(sys_resetn)
    );
    rst_sync u_rst_cpu(
        .clk(cpu_clk),
        .rst_n_in(sys_resetn),
        .rst_n_out(cpu_resetn)
    );
end
else begin: pll_clk
    clk_pll u_clk_pll(
        .cpu_clk    (cpu_clk),
        .sys_clk    (sys_clk),
        .resetn     (~reset),
        .locked     (pll_locked),
        .clk_in1    (clk)
    );
    rst_sync u_rst_sys(
        .clk(sys_clk),
        .rst_n_in(pll_locked),
        .rst_n_out(sys_resetn)
    );
    rst_sync u_rst_cpu(
        .clk(cpu_clk),
        .rst_n_in(sys_resetn),
        .rst_n_out(cpu_resetn)
    );
end
endgenerate

//TODO: add your code

//CPU端口声明
    wire   [ 3:0] cpu_arid;
    wire   [31:0] cpu_araddr;
    wire   [ 7:0] cpu_arlen;
    wire   [ 2:0] cpu_arsize;
    wire   [ 1:0] cpu_arburst;
    wire   [ 1:0] cpu_arlock;
    wire   [ 3:0] cpu_arcache;
    wire   [ 2:0] cpu_arprot;
    wire          cpu_arvalid;
    wire          cpu_arready;

    wire    [ 3:0] cpu_rid;
    wire    [31:0] cpu_rdata;
    wire    [ 1:0] cpu_rresp;
    wire           cpu_rlast;
    wire           cpu_rvalid;
    wire           cpu_rready;

    wire   [ 3:0] cpu_awid;
    wire   [31:0] cpu_awaddr;
    wire   [ 7:0] cpu_awlen;
    wire   [ 2:0] cpu_awsize;
    wire   [ 1:0] cpu_awburst;
    wire   [ 1:0] cpu_awlock;
    wire   [ 3:0] cpu_awcache;
    wire   [ 2:0] cpu_awprot;
    wire          cpu_awvalid;
    wire          cpu_awready;

    wire   [ 3:0] cpu_wid;
    wire   [31:0] cpu_wdata;
    wire   [ 3:0] cpu_wstrb;
    wire          cpu_wlast;
    wire          cpu_wvalid;
    wire          cpu_wready;

    wire    [ 3:0] cpu_bid;
    wire    [ 1:0] cpu_bresp;
    wire           cpu_bvalid;
    wire           cpu_bready;

    wire [31:0] debug0_wb_pc;
    wire [ 3:0] debug0_wb_rf_wen;
    wire [ 4:0] debug0_wb_rf_wnum;
    wire [31:0] debug0_wb_rf_wdata;
    wire [31:0] debug0_wb_instwire;


core_top u_cpu(
    //外部中断信号
    .intrpt(8'h0),

    .aclk(cpu_clk ),
    .aresetn (cpu_resetn ),

    //读地址通道
    .arid(cpu_arid),
    .araddr(cpu_araddr),
    .arlen(cpu_arlen),
    .arsize(cpu_arsize),
    .arburst(cpu_arburst),
    .arlock(cpu_arlock),
    .arcache(cpu_arcache),
    .arprot(cpu_arprot),
    .arvalid(cpu_arvalid),
    .arready(cpu_arready),

    //读数据通道
    .rid(cpu_rid),
    .rdata(cpu_rdata),
    .rresp(cpu_rresp),
    .rlast(cpu_rlast),
    .rvalid(cpu_rvalid),
    .rready(cpu_rready),

    //写地址通道
    .awid(cpu_awid),
    .awaddr(cpu_awaddr),
    .awlen(cpu_awlen),
    .awsize(cpu_awsize),
    .awburst(cpu_awburst),
    .awlock(cpu_awlock),
    .awcache(cpu_awcache),
    .awprot(cpu_awprot),
    .awvalid(cpu_awvalid),
    .awready(cpu_awready),

    //写数据通道
    .wid(cpu_wid),
    .wdata(cpu_wdata),
    .wstrb(cpu_wstrb),
    .wlast(cpu_wlast),
    .wvalid(cpu_wvalid),
    .wready(cpu_wready),

    //写响应通道
    .bid(cpu_bid),
    .bresp(cpu_bresp),
    .bvalid(cpu_bvalid),
    .bready(cpu_bready),

    //已弃用
    .break_point(1'b0),
    .infor_flag(1'b0),
    .reg_num(5'b0),
    .ws_valid(),
    .rf_rdata(),

    //写回阶段提供的调试信息
    .debug0_wb_pc(debug0_wb_pc),
    .debug0_wb_rf_wen(debug0_wb_rf_wen),
    .debug0_wb_rf_wnum(debug0_wb_rf_wnum),
    .debug0_wb_rf_wdata(debug0_wb_rf_wdata),
    .debug0_wb_inst(debug0_wb_instwire)
);


//CDC端口声明
wire          cpu_sync_awvalid;
wire          cpu_sync_awready;
wire [31:0]   cpu_sync_awaddr;
wire [3:0]    cpu_sync_awid;
wire [7:0]    cpu_sync_awlen;
wire [2:0]    cpu_sync_awsize;
wire [1:0]    cpu_sync_awburst;
wire [0:0]    cpu_sync_awlock;
wire [3:0]    cpu_sync_awcache;
wire [2:0]    cpu_sync_awprot;
wire          cpu_sync_wvalid;
wire          cpu_sync_wready;
wire [31:0]   cpu_sync_wdata;
wire [3:0]    cpu_sync_wstrb;
wire          cpu_sync_wlast;
wire          cpu_sync_bvalid;
wire          cpu_sync_bready;
wire [3:0]    cpu_sync_bid;
wire [1:0]    cpu_sync_bresp;
wire          cpu_sync_arvalid;
wire          cpu_sync_arready;
wire [31:0]   cpu_sync_araddr;
wire [3:0]    cpu_sync_arid;
wire [7:0]    cpu_sync_arlen;
wire [2:0]    cpu_sync_arsize;
wire [1:0]    cpu_sync_arburst;
wire [0:0]    cpu_sync_arlock;
wire [3:0]    cpu_sync_arcache;
wire [2:0]    cpu_sync_arprot;
wire          cpu_sync_rvalid;
wire          cpu_sync_rready;
wire [31:0]   cpu_sync_rdata;
wire [3:0]    cpu_sync_rid;
wire [1:0]    cpu_sync_rresp;
wire          cpu_sync_rlast;




Axi_CDC u_Axi_CDC(
    .axiInClk(cpu_clk),
    .axiInRst(cpu_resetn),
    .axiOutClk(sys_clk),
    .axiOutRst(sys_resetn),

    .axiIn_awvalid(cpu_awvalid),
    .axiIn_awready(cpu_awready),
    .axiIn_awaddr(cpu_awaddr),
    .axiIn_awid(cpu_awid),
    .axiIn_awlen(cpu_awlen),
    .axiIn_awsize(cpu_awsize),
    .axiIn_awburst(cpu_awburst),
    .axiIn_awlock(cpu_awlock),
    .axiIn_awcache(cpu_awcache),
    .axiIn_awprot(cpu_awprot),
    .axiIn_wvalid(cpu_wvalid),
    .axiIn_wready(cpu_wready),
    .axiIn_wdata(cpu_wdata),
    .axiIn_wstrb(cpu_wstrb),
    .axiIn_wlast(cpu_wlast),
    .axiIn_bvalid(cpu_bvalid),
    .axiIn_bready(cpu_bready),
    .axiIn_bid(cpu_bid),
    .axiIn_bresp(cpu_bresp),
    .axiIn_arvalid(cpu_arvalid),
    .axiIn_arready(cpu_arready),
    .axiIn_araddr(cpu_araddr),
    .axiIn_arid(cpu_arid),
    .axiIn_arlen(cpu_arlen),
    .axiIn_arsize(cpu_arsize),
    .axiIn_arburst(cpu_arburst),
    .axiIn_arlock(cpu_arlock),
    .axiIn_arcache(cpu_arcache),
    .axiIn_arprot(cpu_arprot),
    .axiIn_rvalid(cpu_rvalid),
    .axiIn_rready(cpu_rready),
    .axiIn_rdata(cpu_rdata),
    .axiIn_rid(cpu_rid),
    .axiIn_rresp(cpu_rresp),
    .axiIn_rlast(cpu_rlast),

    .axiOut_awvalid(cpu_sync_awvalid),
    .axiOut_awready(cpu_sync_awready),
    .axiOut_awaddr(cpu_sync_awaddr),
    .axiOut_awid(cpu_sync_awid),
    .axiOut_awlen(cpu_sync_awlen),
    .axiOut_awsize(cpu_sync_awsize),
    .axiOut_awburst(cpu_sync_awburst),
    .axiOut_awlock(cpu_sync_awlock),
    .axiOut_awcache(cpu_sync_awcache),
    .axiOut_awprot(cpu_sync_awprot),
    .axiOut_wvalid(cpu_sync_wvalid),
    .axiOut_wready(cpu_sync_wready),
    .axiOut_wdata(cpu_sync_wdata),
    .axiOut_wstrb(cpu_sync_wstrb),
    .axiOut_wlast(cpu_sync_wlast),
    .axiOut_bvalid(cpu_sync_bvalid),
    .axiOut_bready(cpu_sync_bready),
    .axiOut_bid(cpu_sync_bid),
    .axiOut_bresp(cpu_sync_bresp),
    .axiOut_arvalid(cpu_sync_arvalid),
    .axiOut_arready(cpu_sync_arready),
    .axiOut_araddr(cpu_sync_araddr),
    .axiOut_arid(cpu_sync_arid),
    .axiOut_arlen(cpu_sync_arlen),
    .axiOut_arsize(cpu_sync_arsize),
    .axiOut_arburst(cpu_sync_arburst),
    .axiOut_arlock(cpu_sync_arlock),
    .axiOut_arcache(cpu_sync_arcache),
    .axiOut_arprot(cpu_sync_arprot),
    .axiOut_rvalid(cpu_sync_rvalid),
    .axiOut_rready(cpu_sync_rready),
    .axiOut_rdata(cpu_sync_rdata),
    .axiOut_rid(cpu_sync_rid),
    .axiOut_rresp(cpu_sync_rresp),
    .axiOut_rlast(cpu_sync_rlast)
);


//SRAM 控制器变量声明

//ar
    wire [4 :0] ram_arid   ;
    wire [31:0] ram_araddr ;
    wire [7 :0] ram_arlen  ;
    wire [2 :0] ram_arsize ;
    wire [1 :0] ram_arburst;
    wire [1 :0] ram_arlock ;
    wire [3 :0] ram_arcache;
    wire [2 :0] ram_arprot ;
    wire        ram_arvalid;
    wire        ram_arready;
   
    wire [4 :0] ram_rid    ;
    wire [31:0] ram_rdata  ;
    wire [1 :0] ram_rresp  ;
    wire        ram_rlast  ;
    wire        ram_rvalid ;
    wire        ram_rready ;
   
    wire [4 :0] ram_awid   ;
    wire [31:0] ram_awaddr ;
    wire [7 :0] ram_awlen  ;
    wire [2 :0] ram_awsize ;
    wire [1 :0] ram_awburst;
    wire [1 :0] ram_awlock ;
    wire [3 :0] ram_awcache;
    wire [2 :0] ram_awprot ;
    wire        ram_awvalid;
    wire        ram_awready;
   
    wire [31:0] ram_wdata  ;
    wire [3 :0] ram_wstrb  ;
    wire        ram_wlast  ;
    wire        ram_wvalid ;
    wire        ram_wready ;
   
    wire [4 :0] ram_bid    ;
    wire [1 :0] ram_bresp  ;
    wire        ram_bvalid ;
    wire        ram_bready ;



axi_wrap_ram_sp_ext u_axi_ram(
    .aclk(sys_clk),
    .aresetn(sys_resetn),

    .axi_arid(ram_arid),
    .axi_araddr(ram_araddr),
    .axi_arlen(ram_arlen),  
    .axi_arsize (ram_arsize),
    .axi_arburst(ram_arburst),
    .axi_arlock(ram_arlock), 
    .axi_arcache(ram_arcache),
    .axi_arprot(ram_arprot), 
    .axi_arvalid(ram_arvalid),
    .axi_arready(ram_arready),

    .axi_rid(ram_rid),   
    .axi_rdata(ram_rdata), 
    .axi_rresp(ram_rresp), 
    .axi_rlast (ram_rlast),
    .axi_rvalid(ram_rvalid),
    .axi_rready(ram_rready),

    .axi_awid   (ram_awid),
    .axi_awaddr (ram_awaddr),
    .axi_awlen  (ram_awlen),
    .axi_awsize (ram_awsize),
    .axi_awburst(ram_awburst),
    .axi_awlock (ram_awlock),
    .axi_awcache(ram_awcache),
    .axi_awprot (ram_awprot),
    .axi_awvalid(ram_awvalid),
    .axi_awready(ram_awready),

    .axi_wdata (ram_wdata),
    .axi_wstrb (ram_wstrb),
    .axi_wlast (ram_wlast),
    .axi_wvalid(ram_wvalid),
    .axi_wready(ram_wready),

    .axi_bid   (ram_bid),
    .axi_bresp (ram_bresp),
    .axi_bvalid(ram_bvalid),
    .axi_bready(ram_bready),

    .base_ram_data(base_ram_data),
    .base_ram_addr(base_ram_addr),
    .base_ram_be_n(base_ram_be_n),
    .base_ram_ce_n(base_ram_ce_n),
    .base_ram_oe_n(base_ram_oe_n),
    .base_ram_we_n(base_ram_we_n),

    .ext_ram_data(ext_ram_data),
    .ext_ram_addr(ext_ram_addr),
    .ext_ram_be_n(ext_ram_be_n),
    .ext_ram_ce_n(ext_ram_ce_n),
    .ext_ram_oe_n(ext_ram_oe_n),
    .ext_ram_we_n(ext_ram_we_n)
);


    //uart
    wire[4 : 0] uart_awid;
    wire[31: 0] uart_awaddr;
    wire[7:0] uart_awlen;
    wire[2:0] uart_awsize;
    wire[1:0] uart_awburst;
    wire[1:0] uart_awlock;
    wire[3:0] uart_awcache;
    wire[2:0] uart_awprot;
    wire uart_awvalid;
    wire uart_awready;

    wire[4:0] uart_wid;
    wire[31:0] uart_wdata;
    wire[3:0] uart_wstrb;
    wire uart_wlast;
    wire uart_wvalid;
    wire uart_wready;

    wire[4:0] uart_bid;
    wire[1:0] uart_bresp;
    wire uart_bvalid;
    wire uart_bready;

    wire[4:0] uart_arid;
    wire[31:0] uart_araddr;
    wire[7:0] uart_arlen;
    wire[2:0] uart_arsize;
    wire[1:0] uart_arburst;
    wire[1:0] uart_arlock;
    wire[3:0] uart_arcache;
    wire[2:0] uart_arprot;
    wire uart_arvalid;
    wire uart_arready;

    wire[4:0] uart_rid;
    wire[31:0] uart_rdata;
    wire[1:0] uart_rresp;
    wire uart_rlast;
    wire uart_rvalid;
    wire uart_rready;




    wire UART_CTS, UART_RTS;
    wire UART_DTR, UART_DSR;
    wire UART_RI, UART_DCD;
    assign UART_CTS = 1'b0;
    assign UART_DSR = 1'b0;
    assign UART_DCD = 1'b0;
    assign UART_RI = 1'b0;
    wire uart0_int;
    wire uart0_txd_o;
    wire uart0_txd_i;
    wire uart0_txd_oe;
    wire uart0_rxd_o;
    wire uart0_rxd_i;
    wire uart0_rxd_oe;
    wire uart0_rts_o;
    wire uart0_cts_i;
    wire uart0_dsr_i;
    wire uart0_dcd_i;
    wire uart0_dtr_o;
    wire uart0_ri_i;
    assign UART_RX = uart0_rxd_oe ? 1'bz : uart0_rxd_o ;
    assign UART_TX = uart0_txd_oe ? 1'bz : uart0_txd_o ;
    assign UART_RTS = uart0_rts_o ;
    assign UART_DTR = uart0_dtr_o ;
    assign uart0_txd_i = UART_TX;
    assign uart0_rxd_i = UART_RX;
    assign uart0_cts_i = UART_CTS;
    assign uart0_dcd_i = UART_DCD;
    assign uart0_dsr_i = UART_DSR;
    assign uart0_ri_i = UART_RI ;

    axi_uart_controller u_axi_uart_controller(
        .clk(sys_clk),
        .rst_n(sys_resetn),

        .axi_s_awid(uart_awid),
        .axi_s_awaddr(uart_awaddr),
        .axi_s_awlen(uart_awlen),
        .axi_s_awsize(uart_awsize),
        .axi_s_awburst(uart_awburst),
        .axi_s_awlock(uart_awlock),
        .axi_s_awcache(uart_awcache),
        .axi_s_awprot(uart_awprot),
        .axi_s_awvalid(uart_awvalid),
        .axi_s_awready(uart_awready),
        .axi_s_wid(uart_wid),//修改
        .axi_s_wdata(uart_wdata),
        .axi_s_wstrb(uart_wstrb),
        .axi_s_wlast(uart_wlast),
        .axi_s_wvalid(uart_wvalid),
        .axi_s_wready(uart_wready),
        .axi_s_bid(uart_bid),
        .axi_s_bresp(uart_bresp),
        .axi_s_bvalid(uart_bvalid),
        .axi_s_bready(uart_bready),
        .axi_s_arid(uart_arid),
        .axi_s_araddr(uart_araddr),
        .axi_s_arlen(uart_arlen),
        .axi_s_arsize(uart_arsize),
        .axi_s_arburst(uart_arburst),
        .axi_s_arlock(uart_arlock),
        .axi_s_arcache(uart_arcache),
        .axi_s_arprot(uart_arprot),
        .axi_s_arvalid(uart_arvalid),
        .axi_s_arready(uart_arready),
        .axi_s_rid(uart_rid),
        .axi_s_rdata(uart_rdata),
        .axi_s_rresp(uart_rresp),
        .axi_s_rlast(uart_rlast),
        .axi_s_rvalid(uart_rvalid),
        .axi_s_rready(uart_rready),

        .apb_rw_dma(1'b0),
        .apb_psel_dma(1'b0),
        .apb_enab_dma(1'b0),
        .apb_addr_dma(20'b0),
        .apb_valid_dma(1'b0),
        .apb_wdata_dma(32'b0),
        .apb_rdata_dma(),
        .apb_ready_dma(),
        .dma_grant(),

        .dma_req_o(),
        .dma_ack_i(1'b0),

        //UART0
        .uart0_txd_i(uart0_txd_i),
        .uart0_txd_o(uart0_txd_o),
        .uart0_txd_oe(uart0_txd_oe),
        .uart0_rxd_i(uart0_rxd_i),
        .uart0_rxd_o(uart0_rxd_o),
        .uart0_rxd_oe(uart0_rxd_oe),
        .uart0_rts_o(uart0_rts_o),
        .uart0_dtr_o(uart0_dtr_o),
        .uart0_cts_i(uart0_cts_i),
        .uart0_dsr_i(uart0_dsr_i),
        .uart0_dcd_i(uart0_dcd_i),
        .uart0_ri_i(uart0_ri_i),

        .uart0_int(uart0_int) 
    );


    //confreg

    wire [4 :0]   confreg_awid;
    wire [31:0]   confreg_awaddr;
    wire [7 :0]   confreg_awlen;
    wire [2 :0]   confreg_awsize;
    wire [1 :0]   confreg_awburst;
    wire          confreg_awlock;
    wire [3 :0]   confreg_awcache;
    wire [2 :0]   confreg_awprot;
    wire          confreg_awvalid;
    wire          confreg_awready;
    wire [4 :0]   confreg_wid;
    wire [31:0]   confreg_wdata;
    wire [3 :0]   confreg_wstrb;
    wire          confreg_wlast;
    wire          confreg_wvalid;
    wire          confreg_wready;
    wire [4 :0]   confreg_bid;
    wire [1 :0]   confreg_bresp;
    wire          confreg_bvalid;
    wire          confreg_bready;
    wire [4 :0]   confreg_arid;
    wire [31:0]   confreg_araddr;
    wire [7 :0]   confreg_arlen;
    wire [2 :0]   confreg_arsize;
    wire [1 :0]   confreg_arburst;
    wire          confreg_arlock;
    wire [3 :0]   confreg_arcache;
    wire [2 :0]   confreg_arprot;
    wire          confreg_arvalid;
    wire          confreg_arready;
    wire [4 :0]   confreg_rid;
    wire [31:0]   confreg_rdata;
    wire [1 :0]   confreg_rresp;
    wire          confreg_rlast;
    wire          confreg_rvalid;
    wire          confreg_rready;


    confreg #(.SIMULATION(SIMULATION)) u_confreg(
        .aclk(sys_clk),
        .aresetn(sys_resetn),
        .cpu_clk(cpu_clk),
        .cpu_resetn(cpu_resetn),

        .s_awid   ( confreg_awid),
        .s_awaddr (   confreg_awaddr),
        .s_awlen  (  confreg_awlen),
        .s_awsize (   confreg_awsize),
        .s_awburst(    confreg_awburst),
        .s_awlock (   confreg_awlock),
        .s_awcache(    confreg_awcache),
        .s_awprot (   confreg_awprot),
        .s_awvalid(    confreg_awvalid),
        .s_awready(    confreg_awready),
        .s_wid    (confreg_wid),//修改
        .s_wdata  (  confreg_wdata),
        .s_wstrb  (  confreg_wstrb),
        .s_wlast  (  confreg_wlast),
        .s_wvalid (   confreg_wvalid),
        .s_wready (   confreg_wready),
        .s_bid    (confreg_bid),
        .s_bresp  (  confreg_bresp),
        .s_bvalid (   confreg_bvalid),
        .s_bready (   confreg_bready),
        .s_arid   ( confreg_arid),
        .s_araddr (   confreg_araddr),
        .s_arlen  (  confreg_arlen),
        .s_arsize (   confreg_arsize),
        .s_arburst(    confreg_arburst),
        .s_arlock (   confreg_arlock),
        .s_arcache(    confreg_arcache),
        .s_arprot (   confreg_arprot),
        .s_arvalid(    confreg_arvalid),
        .s_arready(    confreg_arready),
        .s_rid    (confreg_rid),
        .s_rdata  (  confreg_rdata),
        .s_rresp  (  confreg_rresp),
        .s_rlast  (  confreg_rlast),
        .s_rvalid (   confreg_rvalid),
        .s_rready (   confreg_rready),

        .switch(dip_sw),
        .touch_btn(touch_btn),
        .led(leds),
        .dpy0(dpy0),
        .dpy1(dpy1),
        .confreg_int()
    );


    AxiCrossbar_1x4 u_AxiCrossbar_1x4(
        .clk(sys_clk),
        .resetn(sys_resetn),

        //master 0
        .axiIn_awvalid(cpu_sync_awvalid),
        .axiIn_awready(cpu_sync_awready),
        .axiIn_awaddr(cpu_sync_awaddr),
        .axiIn_awid(cpu_sync_awid),
        .axiIn_awlen(cpu_sync_awlen),
        .axiIn_awsize(cpu_sync_awsize),
        .axiIn_awburst(cpu_sync_awburst),
        .axiIn_awlock(cpu_sync_awlock),
        .axiIn_awcache(cpu_sync_awcache),
        .axiIn_awprot(cpu_sync_awprot),

        .axiIn_wvalid(cpu_sync_wvalid),
        .axiIn_wready(cpu_sync_wready),
        .axiIn_wdata(cpu_sync_wdata),
        .axiIn_wstrb(cpu_sync_wstrb),
        .axiIn_wlast(cpu_sync_wlast),

        .axiIn_bvalid(cpu_sync_bvalid),
        .axiIn_bready(cpu_sync_bready),
        .axiIn_bid(cpu_sync_bid),
        .axiIn_bresp(cpu_sync_bresp),

        .axiIn_arvalid(cpu_sync_arvalid),
        .axiIn_arready(cpu_sync_arready),
        .axiIn_araddr(cpu_sync_araddr),
        .axiIn_arid(cpu_sync_arid),
        .axiIn_arlen(cpu_sync_arlen),
        .axiIn_arsize(cpu_sync_arsize),
        .axiIn_arburst(cpu_sync_arburst),
        .axiIn_arlock(cpu_sync_arlock),
        .axiIn_arcache(cpu_sync_arcache),
        .axiIn_arprot(cpu_sync_arprot),

        .axiIn_rvalid(cpu_sync_rvalid),
        .axiIn_rready(cpu_sync_rready),
        .axiIn_rdata(cpu_sync_rdata),
        .axiIn_rid(cpu_sync_rid),
        .axiIn_rresp(cpu_sync_rresp),
        .axiIn_rlast(cpu_sync_rlast),

        //slave 0
        .axiOut_0_awvalid(ram_awvalid),
        .axiOut_0_awready(ram_awready),
        .axiOut_0_awaddr(ram_awaddr),
        .axiOut_0_awid(ram_awid),
        .axiOut_0_awlen(ram_awlen),
        .axiOut_0_awsize(ram_awsize),
        .axiOut_0_awburst(ram_awburst),
        .axiOut_0_awlock(ram_awlock),
        .axiOut_0_awcache(ram_awcache),
        .axiOut_0_awprot(ram_awprot),

        .axiOut_0_wvalid(ram_wvalid),
        .axiOut_0_wready(ram_wready),
        .axiOut_0_wdata(ram_wdata),
        .axiOut_0_wstrb(ram_wstrb),
        .axiOut_0_wlast(ram_wlast),

        .axiOut_0_bvalid(ram_bvalid),
        .axiOut_0_bready(ram_bready),
        .axiOut_0_bid(ram_bid),
        .axiOut_0_bresp(ram_bresp),

        .axiOut_0_arvalid(ram_arvalid),
        .axiOut_0_arready(ram_arready),
        .axiOut_0_araddr(ram_araddr),
        .axiOut_0_arid(ram_arid),
        .axiOut_0_arlen(ram_arlen),
        .axiOut_0_arsize(ram_arsize),
        .axiOut_0_arburst(ram_arburst),
        .axiOut_0_arlock(ram_arlock),
        .axiOut_0_arcache(ram_arcache),
        .axiOut_0_arprot(ram_arprot),

        .axiOut_0_rvalid(ram_rvalid),
        .axiOut_0_rready(ram_rready),
        .axiOut_0_rdata(ram_rdata),
        .axiOut_0_rid(ram_rid),
        .axiOut_0_rresp(ram_rresp),
        .axiOut_0_rlast(ram_rlast),

        //slave 1
        .axiOut_1_awvalid(uart_awvalid),
        .axiOut_1_awready(uart_awready),
        .axiOut_1_awaddr(uart_awaddr),
        .axiOut_1_awid(uart_awid),
        .axiOut_1_awlen(uart_awlen),
        .axiOut_1_awsize(uart_awsize),
        .axiOut_1_awburst(uart_awburst),
        .axiOut_1_awlock(uart_awlock),
        .axiOut_1_awcache(uart_awcache),
        .axiOut_1_awprot(uart_awprot),

        .axiOut_1_wvalid(uart_wvalid),
        .axiOut_1_wready(uart_wready),
        .axiOut_1_wdata(uart_wdata),
        .axiOut_1_wstrb(uart_wstrb),
        .axiOut_1_wlast(uart_wlast),

        .axiOut_1_bvalid(uart_bvalid),
        .axiOut_1_bready(uart_bready),
        .axiOut_1_bid(uart_bid),
        .axiOut_1_bresp(uart_bresp),

        .axiOut_1_arvalid(uart_arvalid),
        .axiOut_1_arready(uart_arready),
        .axiOut_1_araddr(uart_araddr),
        .axiOut_1_arid(uart_arid),
        .axiOut_1_arlen(uart_arlen),
        .axiOut_1_arsize(uart_arsize),
        .axiOut_1_arburst(uart_arburst),
        .axiOut_1_arlock(uart_arlock),
        .axiOut_1_arcache(uart_arcache),
        .axiOut_1_arprot(uart_arprot),

        .axiOut_1_rvalid(uart_rvalid),
        .axiOut_1_rready(uart_rready),
        .axiOut_1_rdata(uart_rdata),
        .axiOut_1_rid(uart_rid),
        .axiOut_1_rresp(uart_rresp),
        .axiOut_1_rlast(uart_rlast),

         //slave 2
        .axiOut_2_awvalid(),
        .axiOut_2_awready(1'b1),
        .axiOut_2_awaddr(),
        .axiOut_2_awid(),
        .axiOut_2_awlen(),
        .axiOut_2_awsize(),
        .axiOut_2_awburst(),
        .axiOut_2_awlock(),
        .axiOut_2_awcache(),
        .axiOut_2_awprot(),

        .axiOut_2_wvalid(),
        .axiOut_2_wready(1'b1),
        .axiOut_2_wdata(),
        .axiOut_2_wstrb(),
        .axiOut_2_wlast(),

        .axiOut_2_bvalid(1'b0),
        .axiOut_2_bready(),
        .axiOut_2_bid(5'b0),
        .axiOut_2_bresp(2'b0),

        .axiOut_2_arvalid(),
        .axiOut_2_arready(1'b1),
        .axiOut_2_araddr(),
        .axiOut_2_arid(),
        .axiOut_2_arlen(),
        .axiOut_2_arsize(),
        .axiOut_2_arburst(),
        .axiOut_2_arlock(),
        .axiOut_2_arcache(),
        .axiOut_2_arprot(),

        .axiOut_2_rvalid(1'b0),
        .axiOut_2_rready(),
        .axiOut_2_rdata(32'b0),
        .axiOut_2_rid(5'b0),
        .axiOut_2_rresp(2'b0),
        .axiOut_2_rlast(1'b0),

        //slave 3
        .axiOut_3_awvalid(confreg_awvalid),
        .axiOut_3_awready(confreg_awready),
        .axiOut_3_awaddr(confreg_awaddr),
        .axiOut_3_awid(confreg_awid),
        .axiOut_3_awlen(confreg_awlen),
        .axiOut_3_awsize(confreg_awsize),
        .axiOut_3_awburst(confreg_awburst),
        .axiOut_3_awlock(confreg_awlock),
        .axiOut_3_awcache(confreg_awcache),
        .axiOut_3_awprot(confreg_awprot),

        .axiOut_3_wvalid(confreg_wvalid),
        .axiOut_3_wready(confreg_wready),
        .axiOut_3_wdata(confreg_wdata),
        .axiOut_3_wstrb(confreg_wstrb),
        .axiOut_3_wlast(confreg_wlast),

        .axiOut_3_bvalid(confreg_bvalid),
        .axiOut_3_bready(confreg_bready),
        .axiOut_3_bid(confreg_bid),
        .axiOut_3_bresp(confreg_bresp),

        .axiOut_3_arvalid(confreg_arvalid),
        .axiOut_3_arready(confreg_arready),
        .axiOut_3_araddr(confreg_araddr),
        .axiOut_3_arid(confreg_arid),
        .axiOut_3_arlen(confreg_arlen),
        .axiOut_3_arsize(confreg_arsize),
        .axiOut_3_arburst(confreg_arburst),
        .axiOut_3_arlock(confreg_arlock),
        .axiOut_3_arcache(confreg_arcache),
        .axiOut_3_arprot(confreg_arprot),

        .axiOut_3_rvalid(confreg_rvalid),
        .axiOut_3_rready(confreg_rready),
        .axiOut_3_rdata(confreg_rdata),
        .axiOut_3_rid(confreg_rid),
        .axiOut_3_rresp(confreg_rresp),
        .axiOut_3_rlast(confreg_rlast)

    );




endmodule

