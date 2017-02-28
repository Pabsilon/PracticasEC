
	.equ COEF1, 3483
	.equ COEF2, 11718
	.equ COEF3, 1183

	.text

	.global MediaGris
	//.global rgb2gray
	.global div16384

rgb2gray:
	PUSH {R4-R10,LR}

	MOV R10,#0
	LDRB R1,[R0]
	LDRB R2,[R0,R10,LSL#1]
	LDRB R3,[R0,R10,LSL#2]

	LDR R4,=COEF1
	LDR R5,=COEF2
	LDR R6,=COEF3

	MUL R7,R1,R4

	MUL R8,R2,R5

	MUL R9,R3,R6

	ADD R0,R7,R8
	ADD R0,R0,R9

	BL div16384

	POP {R4-R10,LR}
	
	MOV PC,LR


div16384:
			MOV R2,#0

while:		CMP R0,#16384
			BLT fin_while

			SUB R0,R0,#16384
			ADD R2,R2,#1

			B while

fin_while:	MOV R0,R2

			MOV PC,LR


apply_gaussian:
	PUSH {R4-R7,LR}

	MOV R4,#0

for_1:
	CMP R4,R3
	BGE fin_for_1

	MOV R5,#0

for_2:
	CMP R5,R2
	BGE fin_for_2

	MUL R7,R4,R2
	ADD R7,R7,R5

	PUSH {R0-R3}

	MOV R1,R2
	MOV R2,R3
	MOV R3,R4

	PUSH {R5}

	BL gaussian
	MOV R6,R0

	ADD SP,SP,#4

	POP {R0-R3}

	STRB R6,[R1,R7]

	ADD R5,R5,#1
	B for_2
fin_for_2:

	ADD R4,R4,#1
	MOV R5,#0
	B for_1

fin_for_1:
		POP {R4-R7,LR}
		MOV PC,LR


MediaGris:

	PUSH {R4-R8,LR}

	//r0 array gris
	//r1 N
	//r2 M
	//r3 Array a actualizar

	//aux = 0
	//For1 i = 0; i<m, i++
	//for2 j=0;j<N, j++

	//aux = aux + gris[]
	//fin for1
	//aux = aux / m

	MOV R8, #0 //DESP
	MOV R4, #0 //I
for1:
	CMP R4,R1
	BGE fin1

	MOV R5, #0 //J
	MOV R6, #0 //AUX
for2:
	CMP R5,R2
	BGE fin2

	ADD R8,R8,#1
	LDRB R7,[R0,R8]
	ADD R6,R6,R7

	ADD R5,R5,#1

	B for2

fin2://R7,R5


	STR R3,[R6]
	ADD R3,R3,#1
	ADD R4,R4,#1

	B for1

fin1:
	SUB R3,R3,R4
	POP {R4-R8,LR}
	MOV PC,LR


div512:
			MOV R5,#0

while512:
			CMP R6,#512
			BLT fin_while512

			SUB R6,R6,#512
			ADD R5,R5,#1

			B while512

fin_while512:
			MOV R6,R5

			MOV PC,LR



	.end
