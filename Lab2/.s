
    AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB
	
		EXPORT	pressedStart
		EXPORT	RoundNumberHEX
			
			
		IMPORT 	LEDsequence
		IMPORT 	displayLeft
		IMPORT 	displayRight
		IMPORT 	actLed
		IMPORT	limpaLCD
		IMPORT	ruReadyScreen
		IMPORT	SysTick_Wait1ms
		IMPORT	roundScreen
		IMPORT	escreverDadoLCD

constTime	EQU		50;
constTime1	EQU		100;
; -------------------------------------------------------------------------------
; Função numbSelector
; Parâmetro de entrada: R6 --> Numero a ser impresso
; Parâmetro de saída: nao tem
pressedStart
;	ORR	R6, R2, R0
	BL	limpaLCD
	BL 	ruReadyScreen
	
preparaLED
	MOV R1,	#2_10101010
	MOV R12, #0
	MOV	R4,	#2
	MOV	R10, #0
acendeLED
	MOV	R0, R1
	PUSH{R1}
	BL	LEDsequence
	BL	actLed
	PUSH	{LR}
	MOV 	R0, #5
	BL		SysTick_Wait1ms					;Espera 5ms
	POP		{LR}
	POP		{R1}
	CMP	R12, #constTime
	ITET	LO
	ADDLO	R12, #1
	MOVHS	R12, #0
	BLO		acendeLED
	
	UDIV 	R11, R1, R4					;R10 <= floor(R1/R1), basicamente muda o padrão do LED
	MLS R3, R11, R4, R1					;R3 <= R3 - R1*R10, verifica a paridade de R1
	CMP 	R3, #0
	
	ITE		EQ
	UDIVEQ 	R1, R4						;Responsavel pelo padrão 01010101
	MULNE 	R1, R4						;Responsavel pelo padrão 10101010
	
	ADD 	R10, #1
	CMP		R10, #5
	BEQ		roundScreen
	B	acendeLED

RoundNumberHEX
	MOV	R11, #10
	PUSH{LR}
	UDIV R10, R5, R11						;R10 recebe(<=) floor(R5/R11)
	ADD		R10, #0x30
	MOV		R0, R10
	SUB		R10, #0x30
	BL		escreverDadoLCD
	CMP	 	R10, #0							
	ITE EQ
	MOVEQ 	R0, R5							;Move o count p/ o "registrador de exibição" somente quando coun<10
	MLSNE 	R0, R10, R11, R5					;R3 <= R5 - R10*R11
	ADD		R0, #0x30	
	BL		escreverDadoLCD

;Displaying numb in 7segs
	LDR		R4, =randomList
	LDRB 	R6,[R4] 
	MOV R12, #0
	MOV	R11, #10
acende7segs	
	UDIV R10, R6, R11						;R10 recebe(<=) floor(R5/R11)
	MOV		R3, R10
	BL		numbSelector
	BL		displayRight
	CMP	 	R10, #0							
	ITE EQ
	MOVEQ 	R3, R6							;Move o count p/ o "registrador de exibição" somente quando coun<10
	MLSNE 	R3, R10, R11, R6					;R3 <= R5 - R10*R11
	BL		numbSelector
	BL		displayLeft
	CMP	R12, #constTime1
	ITET	LO
	ADDLO	R12, #1
	MOVHS	R12, #0
	BLO		acende7segs	
	
	
	POP{LR}
	ADD R5, #1
	
	BX LR
	
	
numbSelector
	LDR R1, =ListDisplayPattern
	MOV R0, #0				;zera o R0 para fazer utliza-lo como contador

AGAIN
	CMP R0, R3
	
	ITEET LO
	ADDLO 	R0, #1
	ADDHS 	R1, R0
	LDRBHS 	R0, [R1]
	BLO		AGAIN
	PUSH{LR}
	BL	LEDsequence
	POP{LR}
	BX		LR
	
	
mxToChar	DCB		0x77, 0x7B, 0x7D, 0x7E, 0xB7, 0xBB,0xBD, 0xBE, 0xD7, 0xDB, 0xDD, 0xDE, 0xE7, 0xEB, 0xED, 0xEE
randomList	DCB		78, 58, 6, 33, 90
ListDisplayPattern DCB 2_00111111, 2_00110000, 2_01011011, 2_01111001, 2_01110100, 2_01101101, 2_01101111, 2_00111000, 2_01111111, 2_01111100

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo