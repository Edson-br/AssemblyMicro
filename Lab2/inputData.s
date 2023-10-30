
    AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB
	
		EXPORT	pressedStart
		EXPORT	RoundNumberHEXLCD
		EXPORT	whichKey
		EXPORT	decipherMxChar
		EXPORT	actionKey
		EXPORT	compareData
		EXPORT	preparaLED
		
		IMPORT 	LEDsequence
		IMPORT 	displayLeft
		IMPORT 	displayRight
		IMPORT 	actLed
		IMPORT	limpaLCD
		IMPORT	ruReadyScreen
		IMPORT	SysTick_Wait1ms
		IMPORT	roundScreen
		IMPORT	writeNumbScreen
		IMPORT	escreverDadoLCD
		IMPORT	gameOverScreen
		
constTime	EQU		25;
constTime1	EQU		100;
rdSeed		EQU		0x20000A00
; -------------------------------------------------------------------------------
;Função responsável pela etapa final das boas vindas
pressedStart
	LDR		R8, =randList
	LDR		R4, =rdSeed
	STRB	R3, [R4]
	BL	limpaLCD
	BL 	ruReadyScreen
	BL	preparaLED
	B	roundScreen
	
	
preparaLED
	MOV R1,	#2_10101010
	MOV R12, #0
	MOV	R4,	#2
	MOV	R10, #0
acendeLED
	MOV	R0, R1
	PUSH{R1}
	PUSH	{LR}
	BL	LEDsequence
	BL	actLed
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
	IT		EQ
	BXEQ	LR
	B	acendeLED

;Conjunto de funções responsaveis pela exibição do número do round atual
;e também encarregado do próx número a ser lembrado
RoundNumberHEXLCD
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
	MOV		R7, #0	
	LDR		R8, =randList

displayTheLastOnes
	MOV		R9, #0
	LDRB 	R6,	[R8], #1
	BL		applyrdSeed
displayNumbIn7Segs
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
	CMP		R7, R5
	ITT		LO
	ADDLO	R7, #1
	BLO		displayTheLastOnes
	POP{LR}
	ADD R5, #1
	
	BX LR

;Conjunto de Funções que leêm o dado de Mx
whichKey
	ORR	R6, R2, R0
	LDR	R4, =mxToChar
	MOV	R0, #0
FO_WhichKey	
	LDRB	R10, [R4]
	CMP	R6, R10
	ADDNE	R0,#1
	ADDNE	R4, #1
	BNE		FO_WhichKey
	IT		EQ
	BXEQ	LR
	
decipherMxChar
	CMP	R0, #10
	IT	LO
	ADDLO	R0, #0x30
	BLO		escreverDadoLCD	
	
	IT	HS
	BLHS	gameCommands
	
	BX	LR

actionKey
	CMP	R0, #12
	IT		GE
	BLGE	writeNumbScreen
	BX	LR

compareData
	PUSH{R3}
	BL	limpaLCD
	POP{R3}
	CMP		R9, #0
	IT		EQ
	LDREQ	R8, =randList
	LDRB	R6, [R8], #1
	BL		applyrdSeed
	CMP		R7, R6
	IT		EQ
	BLEQ	preparaLED
	BEQ		isItLastnumb
	BNE		gameOverScreen
	
isItLastnumb
	ADD		R9, #1
	CMP		R9, R5
	BGE		roundScreen
	B		writeNumbScreen

;Para proporcionar uma lista mais randomica.
applyrdSeed
	MOV		R0, #100
	LDR		R4, =rdSeed
	LDRB	R2, [R4]
	MUL		R1, R2, R6
	UDIV	R3, R1, R0
	MLS		R6, R3, R0, R1
	BX		LR


;Função que converte numero para 7segmentos
numbSelector
	LDR R1, =ListDisplayPattern
	MOV R0, #0				;zera o R0 para fazer utliza-lo como contador

slRightPattern
	CMP R0, R3
	
	ITEET LO
	ADDLO 	R0, #1
	ADDHS 	R1, R0
	LDRBHS 	R0, [R1]
	BLO		slRightPattern
	PUSH{LR}
	BL	LEDsequence
	POP{LR}
	BX		LR
	
gameCommands
	BL	acende7segs
	
	B	gameCommands

mxToChar	DCB		0xEB, 0x77, 0x7B, 0x7D, 0xB7, 0xBB,0xBD, 0xD7, 0xDB, 0xDD,0x7E, 0xBE, 0xDE, 0xEE, 0xE7 , 0xED
randList	DCB		24, 83, 92, 19, 50, 35, 22, 80, 44, 0, 60, 61, 32, 37, 70, 98, 93, 15, 79, 11, 59, 54, 10, 6, 30, 27, 52, 18, 64, 46, 8, 47, 81, 74, 87, 38, 99, 16, 0, 62, 69, 40, 72, 33, 94, 43, 13, 2, 77, 42, 17, 78, 48, 55, 39, 7, 29, 86, 45, 49, 63, 56, 14, 89, 90, 75, 65, 23, 25, 34, 88, 4, 9, 20, 66, 95, 26, 5, 73, 58, 53, 76, 21, 68, 28, 97, 51, 12, 71, 3, 31, 91, 57, 41, 84, 67, 85, 36, 1, 96
ListDisplayPattern DCB 2_00111111, 2_00110000, 2_01011011, 2_01111001, 2_01110100, 2_01101101, 2_01101111, 2_00111000, 2_01111111, 2_01111100

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo