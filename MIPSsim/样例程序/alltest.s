
# load��storeָ��
.text
main:
ADDIU $r8, $r0, DATA
LB $r1, 0($r8)
LW $r1, 0($r8)
LBU $r1, 0($r8)
ADDIU $r8, $r0, BUFFER
SW $r1,0($r8)
BEQ $r0, $r0, PROG2
NOP

# ��������ָ��
PROG2:
DADD $r3, $r1, $r2 
DMULT $r1, $r2
BEQ $r0, $r0, PROG3
NOP

# �߼�����ָ��
PROG3:
AND $r3, $r1, $r2 
ANDI $r3, $r1,0xFFFF0000
BEQ $r0, $r0, PROG4
NOP

# ����ת��ָ��   
PROG4:
BEQ $r1,$r2,LABEL1
NOP
NOP

LABEL1:
BGEZ $r1,LABEL2
NOP
NOP

LABEL2:
BGEZAL $r1,LABEL3
NOP
NOP

LABEL3:
ADDIU $r1, $r0, LABEL4
JALR $r3, $r1
NOP
NOP

LABEL4:
TEQ $r0, $r0
NOP

# ����
.data
.align 2
DATA:
.word 128
BUFFER:
.word 300
