
    AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB
	
		EXPORT	pressedStart
		EXPORT	RoundNumberHEX
			
			
		IMPORT 	LEDsequence
		IMPORT 	actLed
		IMPORT	limpaLCD
		IMPORT	ruReadyScreen
		IMPORT	SysTick_Wait1ms
		IMPORT	roundScreen
		IMPORT	escreverDadoLCD

constTime	EQU		50;
; -------------------------------------------------------------------------------
; Função numbSelector
; Parâmetro de entrada: R6 --> Numero a ser impresso
; Parâmetro de saída: nao tem
pressedStart
	ORR	R6, R2, R0
	BL	limpaLCD
	BL 	ruReadyScreen
	
preparaLED
	MOV R9,	#2_10101010
	MOV R12, #0
	MOV	R4,	#2
	MOV	R7, #0
acendeLED
	MOV	R0, R9
	BL	LEDsequence
	BL	actLed
	PUSH	{LR}
	MOV 	R0, #5
	BL		SysTick_Wait1ms					;Espera 5ms
	POP		{LR}
	CMP	R12, #constTime
	ITET	LO
	ADDLO	R12, #1
	MOVHS	R12, #0
	BLO		acendeLED
	
	UDIV 	R11, R9, R4					;R10 <= floor(R9/R1), basicamente muda o padrão do LED
	MLS R3, R11, R4, R9					;R3 <= R3 - R1*R10, verifica a paridade de R9
	CMP 	R3, #0
	
	ITE		EQ
	UDIVEQ 	R9, R4						;Responsavel pelo padrão 01010101
	MULNE 	R9, R4						;Responsavel pelo padrão 10101010
	
	ADD 	R7, #1
	CMP		R7, #5
	BEQ		roundScreen
	B	acendeLED

RoundNumberHEX
	MOV	R11, #10
	PUSH{LR}
	UDIV R7, R5, R11						;R7 recebe(<=) floor(R5/R11)
	ADD		R7, #0x30
	MOV		R0, R7
	SUB		R7, #0x30
	BL		escreverDadoLCD
	
	CMP R7, #0							
	
	ITE EQ
	MOVEQ R0, R5							;Move o count p/ o "registrador de exibição" somente quando coun<10
	MLSNE R0, R7, R11, R5					;R3 <= R5 - R7*R11
	ADD		R0, #0x30	
	BL		escreverDadoLCD
	POP{LR}
	ADD R5, #1
	
	BX LR
	
	
mxToChar	DCB		0x77, 0x7B, 0x7D, 0x7E, 0xB7, 0xBB,0xBD, 0xBE, 0xD7, 0xDB, 0xDD, 0xDE, 0xE7, 0xEB, 0xED, 0xEE
	
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo