
	.equ COEF1, 3483
	.equ COEF2, 11718
	.equ COEF3, 1183

	.text


	.global rgb2gray
	.global div16384

rgb2gray:
	
	MUL R2,R0,COEF1
	ADDI R0,R0,#1
	MUL R3,R0,COEF2
	ADD R2,R3,R2
	ADDI R0,R0,#1
	MUL R3,R0,COEF3
	ADD R2,R3,R2
	DESPLR R2,#15
	MOV R0,R2
	MOV PC,LR

apply_gaussian:
	SUB SP,SP,#24
	STR R4,[SP,#0]
	STR R5,[SP,#4]
	STR R6,[SP,#8]
	STR R7,[SP,#12]
	STR R8,[SP,#16]
	STR LR,[SP,#20]
	ADD FP,SP,#12


	MOV R4,#0	
fr1:
	CMP R4,R2
	BGE fin_for_1
	MOV R5,#0
fr2:
	CMP R5,R3
	BGE fin_for_2
	MUL R6,R4,#4
	MUL R7,R5,#4
	MUL R8,R7,R2		
	ADD R6,R7,R8
	PUSH {R0-R3}
	PUSH {R4-R5}
	MOV R1,R2
	MOV R2,R3
	MOV R3,R4
	MOV R4,R5
	
	BL gaussian

	MOV R8,R0
	POP {RO-R3}
	POP {R4-R5}

	MOV [R2,R6],R8

	ADD R5,R5,#1
	B fr2



fin_for_1:
	LDR LR,[SP,#20]
	LDR R8,[SP,#16]
	LDR R7,[SP,#12]
	LDR R6,[SP,#8]
	LDR R5,[SP,#4]
	LDR R4,[SP,#0]
	ADD SP,SP,#24
	MOV PC,LR

fin_for_2:
	ADD R4,R4,#1
	B fr1

  		.end


