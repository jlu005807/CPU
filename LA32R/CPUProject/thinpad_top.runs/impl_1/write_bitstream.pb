
o
Command: %s
1870*	planAhead2:
&open_checkpoint thinpad_top_routed.dcp2default:defaultZ12-2866h px� 
^

Starting %s Task
103*constraints2#
open_checkpoint2default:defaultZ18-103h px� 
�

%s
*constraints2r
^Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.019 . Memory (MB): peak = 309.906 ; gain = 0.0002default:defaulth px� 
W
Loading part %s157*device2$
xc7a200tfbg676-22default:defaultZ21-403h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0182default:default2
769.7702default:default2
0.0002default:defaultZ17-268h px� 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
1862default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px� 
x
Netlist was created with %s %s291*project2
Vivado2default:default2
2019.22default:defaultZ1-479h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
L
*Restoring timing data from binary archive.264*timingZ38-478h px� 
F
$Binary timing data restore complete.265*timingZ38-479h px� 
L
*Restoring constraints from binary archive.481*projectZ1-856h px� 
E
#Binary constraint restore complete.478*projectZ1-853h px� 
?
Reading XDEF placement.
206*designutilsZ20-206h px� 
D
Reading placer database...
1602*designutilsZ20-1892h px� 
=
Reading XDEF routing.
207*designutilsZ20-207h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2$
Read XDEF File: 2default:default2
00:00:002default:default2 
00:00:00.1882default:default2
1450.3712default:default2
7.6452default:defaultZ17-268h px� 
�
7Restored from archive | CPU: %s secs | Memory: %s MB |
1612*designutils2
0.0000002default:default2
0.0000002default:defaultZ20-1924h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common20
Finished XDEF File Restore: 2default:default2
00:00:002default:default2 
00:00:00.1882default:default2
1450.3712default:default2
7.6452default:defaultZ17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0012default:default2
1450.3712default:default2
0.0002default:defaultZ17-268h px� 
�
!Unisim Transformation Summary:
%s111*project2�
�  A total of 67 instances were transformed.
  IOBUF => IOBUF (IBUF, OBUFT): 32 instances
  LDCP => LDCP (GND, LDCE, LUT3(x2), VCC): 1 instance 
  RAM32M => RAM32M (RAMD32(x6), RAMS32(x2)): 12 instances
  RAM64M => RAM64M (RAMD64E(x4)): 22 instances
2default:defaultZ1-111h px� 
�
'Checkpoint was created with %s build %s378*project2+
Vivado v2019.2 (64-bit)2default:default2
27088762default:defaultZ1-604h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2%
open_checkpoint: 2default:default2
00:00:212default:default2
00:00:232default:default2
1450.3712default:default2
1140.4652default:defaultZ17-268h px� 
k
Command: %s
53*	vivadotcl2:
&write_bitstream -force thinpad_top.bit2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7a200t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7a200t2default:defaultZ17-349h px� 
x
,Running DRC as a precondition to command %s
1349*	planAhead2#
write_bitstream2default:defaultZ12-1349h px� 
>
Refreshing IP repositories
234*coregenZ19-234h px� 
G
"No user IP repositories specified
1154*coregenZ19-1704h px� 
|
"Loaded Vivado IP repository '%s'.
1332*coregen23
D:/Vivado/Vivado/2019.2/data/ip2default:defaultZ19-2313h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2L
 "6
cpu/alu/result0	cpu/alu/result02default:default2default:default2V
 "@
cpu/alu/result0/A[29:0]cpu/alu/result0/A2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2L
 "6
cpu/alu/result0	cpu/alu/result02default:default2default:default2V
 "@
cpu/alu/result0/B[17:0]cpu/alu/result0/B2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2R
 "<
cpu/alu/result0__0	cpu/alu/result0__02default:default2default:default2\
 "F
cpu/alu/result0__0/A[29:0]cpu/alu/result0__0/A2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2R
 "<
cpu/alu/result0__0	cpu/alu/result0__02default:default2default:default2\
 "F
cpu/alu/result0__0/B[17:0]cpu/alu/result0__0/B2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2R
 "<
cpu/alu/result0__1	cpu/alu/result0__12default:default2default:default2\
 "F
cpu/alu/result0__1/A[29:0]cpu/alu/result0__1/A2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2R
 "<
cpu/alu/result0__1	cpu/alu/result0__12default:default2default:default2\
 "F
cpu/alu/result0__1/B[17:0]cpu/alu/result0__1/B2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
�PREG Output pipelining: DSP %s output %s is not pipelined (PREG=0). Pipelining the DSP48 output will improve performance and often saves power so it is suggested whenever possible to fully pipeline this function.  If this DSP48 function was inferred, it is suggested to describe an additional register stage after this function.  If the DSP48 was instantiated in the design, it is suggested to set the PREG attribute to 1.%s*DRC2L
 "6
cpu/alu/result0	cpu/alu/result02default:default2default:default2V
 "@
cpu/alu/result0/P[47:0]cpu/alu/result0/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-1h px� 
�
�PREG Output pipelining: DSP %s output %s is not pipelined (PREG=0). Pipelining the DSP48 output will improve performance and often saves power so it is suggested whenever possible to fully pipeline this function.  If this DSP48 function was inferred, it is suggested to describe an additional register stage after this function.  If the DSP48 was instantiated in the design, it is suggested to set the PREG attribute to 1.%s*DRC2R
 "<
cpu/alu/result0__0	cpu/alu/result0__02default:default2default:default2\
 "F
cpu/alu/result0__0/P[47:0]cpu/alu/result0__0/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-1h px� 
�
�PREG Output pipelining: DSP %s output %s is not pipelined (PREG=0). Pipelining the DSP48 output will improve performance and often saves power so it is suggested whenever possible to fully pipeline this function.  If this DSP48 function was inferred, it is suggested to describe an additional register stage after this function.  If the DSP48 was instantiated in the design, it is suggested to set the PREG attribute to 1.%s*DRC2R
 "<
cpu/alu/result0__1	cpu/alu/result0__12default:default2default:default2\
 "F
cpu/alu/result0__1/P[47:0]cpu/alu/result0__1/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-1h px� 
�
�MREG Output pipelining: DSP %s multiplier stage %s is not pipelined (MREG=0). Pipelining the multiplier function will improve performance and will save significant power so it is suggested whenever possible to fully pipeline this function.  If this multiplier was inferred, it is suggested to describe an additional register stage after this function.  If there is no registered adder/accumulator following the multiply function, two pipeline stages are suggested to allow both the MREG and PREG registers to be used.  If the DSP48 was instantiated in the design, it is suggested to set both the MREG and PREG attributes to 1 when performing multiply functions.%s*DRC2L
 "6
cpu/alu/result0	cpu/alu/result02default:default2default:default2V
 "@
cpu/alu/result0/P[47:0]cpu/alu/result0/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-2h px� 
�
�MREG Output pipelining: DSP %s multiplier stage %s is not pipelined (MREG=0). Pipelining the multiplier function will improve performance and will save significant power so it is suggested whenever possible to fully pipeline this function.  If this multiplier was inferred, it is suggested to describe an additional register stage after this function.  If there is no registered adder/accumulator following the multiply function, two pipeline stages are suggested to allow both the MREG and PREG registers to be used.  If the DSP48 was instantiated in the design, it is suggested to set both the MREG and PREG attributes to 1 when performing multiply functions.%s*DRC2R
 "<
cpu/alu/result0__0	cpu/alu/result0__02default:default2default:default2\
 "F
cpu/alu/result0__0/P[47:0]cpu/alu/result0__0/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-2h px� 
�
�MREG Output pipelining: DSP %s multiplier stage %s is not pipelined (MREG=0). Pipelining the multiplier function will improve performance and will save significant power so it is suggested whenever possible to fully pipeline this function.  If this multiplier was inferred, it is suggested to describe an additional register stage after this function.  If there is no registered adder/accumulator following the multiply function, two pipeline stages are suggested to allow both the MREG and PREG registers to be used.  If the DSP48 was instantiated in the design, it is suggested to set both the MREG and PREG attributes to 1 when performing multiply functions.%s*DRC2R
 "<
cpu/alu/result0__1	cpu/alu/result0__12default:default2default:default2\
 "F
cpu/alu/result0__1/P[47:0]cpu/alu/result0__1/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-2h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2d
 "N
cpu/control/RegWrite_reg/G0cpu/control/RegWrite_reg/G02default:default2default:default2l
 "V
cpu/control/RegWrite_reg/L3_2/Ocpu/control/RegWrite_reg/L3_2/O2default:default2default:default2h
 "R
cpu/control/RegWrite_reg/L3_2	cpu/control/RegWrite_reg/L3_22default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2Y
 "C
cpu/id_ex_register/E[0]cpu/id_ex_register/E2default:default2default:default2~
 "h
(cpu/id_ex_register/ALU_ctrl_reg[3]_i_2/O(cpu/id_ex_register/ALU_ctrl_reg[3]_i_2/O2default:default2default:default2z
 "d
&cpu/id_ex_register/ALU_ctrl_reg[3]_i_2	&cpu/id_ex_register/ALU_ctrl_reg[3]_i_22default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2p
 "Z
!cpu/id_ex_register/PCsrc_reg[2]_2!cpu/id_ex_register/PCsrc_reg[2]_22default:default2default:default2�
 "j
)cpu/id_ex_register/branch_taken_reg_i_2/O)cpu/id_ex_register/branch_taken_reg_i_2/O2default:default2default:default2|
 "f
'cpu/id_ex_register/branch_taken_reg_i_2	'cpu/id_ex_register/branch_taken_reg_i_22default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2Y
 "C
cpu/if_id_register/E[0]cpu/if_id_register/E2default:default2default:default2x
 "b
%cpu/if_id_register/PCsrc_reg[2]_i_2/O%cpu/if_id_register/PCsrc_reg[2]_i_2/O2default:default2default:default2t
 "^
#cpu/if_id_register/PCsrc_reg[2]_i_2	#cpu/if_id_register/PCsrc_reg[2]_i_22default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "k
+cpu/if_id_register/instruction_reg[18]_0[0](cpu/if_id_register/instruction_reg[18]_02default:default2default:default2x
 "b
%cpu/if_id_register/ALUop_reg[3]_i_2/O%cpu/if_id_register/ALUop_reg[3]_i_2/O2default:default2default:default2t
 "^
#cpu/if_id_register/ALUop_reg[3]_i_2	#cpu/if_id_register/ALUop_reg[3]_i_22default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2~
 "h
(cpu/if_id_register/instruction_reg[30]_0(cpu/if_id_register/instruction_reg[30]_02default:default2default:default2v
 "`
$cpu/if_id_register/RegRead_reg_i_2/O$cpu/if_id_register/RegRead_reg_i_2/O2default:default2default:default2r
 "\
"cpu/if_id_register/RegRead_reg_i_2	"cpu/if_id_register/RegRead_reg_i_22default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
g
DRC finished with %s
1905*	planAhead2)
0 Errors, 18 Warnings2default:defaultZ12-3199h px� 
i
BPlease refer to the DRC report (report_drc) for more information.
1906*	planAheadZ12-3200h px� 
i
)Running write_bitstream with %s threads.
1750*designutils2
22default:defaultZ20-2272h px� 
?
Loading data files...
1271*designutilsZ12-1165h px� 
>
Loading site data...
1273*designutilsZ12-1167h px� 
?
Loading route data...
1272*designutilsZ12-1166h px� 
?
Processing options...
1362*designutilsZ12-1514h px� 
<
Creating bitmap...
1249*designutilsZ12-1141h px� 
7
Creating bitstream...
7*	bitstreamZ40-7h px� 
f
%Bitstream compression saved %s bits.
26*	bitstream2
681613442default:defaultZ40-26h px� 
b
Writing bitstream %s...
11*	bitstream2%
./thinpad_top.bit2default:defaultZ40-11h px� 
F
Bitgen Completed Successfully.
1606*	planAheadZ12-1842h px� 
�
�WebTalk data collection is mandatory when using a WebPACK part without a full Vivado license. To see the specific WebTalk data collected for your design, open the usage_statistics_webtalk.html or usage_statistics_webtalk.xml file in the implementation directory.
120*projectZ1-120h px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
222default:default2
182default:default2
02default:default2
02default:defaultZ4-41h px� 
a
%s completed successfully
29*	vivadotcl2#
write_bitstream2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2%
write_bitstream: 2default:default2
00:00:102default:default2
00:00:122default:default2
1997.2072default:default2
546.8362default:defaultZ17-268h px� 


End Record