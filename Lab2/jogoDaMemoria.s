; Contador
; Desenvolvido para a placa EK-TM4C1294XL
; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Definições de Valores


; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
		EXPORT	ruReadyScreen
		EXPORT	roundScreen
		EXPORT	writeNumbScreen
		EXPORT	gameOverScreen
			
		IMPORT  PLL_Init
		IMPORT  SysTick_Init				
		IMPORT  GPIO_Init
		IMPORT	GPIO_InitLED
		IMPORT	SysTick_Wait1ms
		;Operações referentes ao LCD
		IMPORT 	limpaLCD
		IMPORT	positionCursor
		IMPORT	escreverDadoLCD
		IMPORT	controleLCD
		IMPORT	modoLCD
		IMPORT  moveCursor
		IMPORT	resetCursorPosition
		; Dados referenes a exibição
		IMPORT	RoundNumberHEXLCD
		IMPORT	preparaLED
		; Operações referentes ao teclado matricial
		IMPORT 	checkMxKey
		IMPORT 	pressedStart
		; Interação	
		IMPORT	whichKey
		IMPORT	decipherMxChar
		IMPORT	actionKey
		IMPORT	compareData
		; Good Job Screen
		IMPORT	LEDsequence
		IMPORT	displayLeft
		IMPORT	displayRight
			
numbOfRounds EQU	4
; -------------------------------------------------------------------------------
; Função main()
Start
	BL 	PLL_Init                  		;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL 	SysTick_Init              		;Chama a subrotina para inicializar o SysTick
	BL	GPIO_Init                		;Chama a subrotina que inicializa os GPIO
	BL	GPIO_InitLED
	BL	limpaLCD
	BL	controleLCD
	BL 	modoLCD
	BL	resetCursorPosition
; -------------------------------------------------------------------------------
;Funções que fazem a exibição dos textos
boasVindas
	MOV R5, #0
	LDR	R4, =boasVindasHEX
	MOV		R10, 	#11						;num de hex da primeira linha - 1 (p/ pular para próxima linha)
	MOV		R11, 	#0x1C					;numb de hex das duas linhas + 1
	BL		loopHEXLCD
	
PressButtonScreen
	MOV 	R0, #2000
	BL		SysTick_Wait1ms					;Espera 2s
	BL		limpaLCD
	LDR		R4, =pressButtonHEX
	MOV 	R10, #12						;num de hex da primeira linha - 1 (p/ pular para próxima linha)
	MOV		R11, #0x16						;num de hex das duas linhas + 1
	BL		loopHEXLCD
	BL		dtBtPress
	B		pressedStart

ruReadyScreen
	PUSH{LR}
	MOV 	R0, #500
	BL		SysTick_Wait1ms					;Espera 500ms
	BL		limpaLCD
	LDR	R4, =ruReadyHEX
	MOV 	R10, #14						
	MOV		R11, #14						
	BL		loopHEXLCD
	POP{LR}
	BX		LR
	
roundScreen
	CMP		R5, #numbOfRounds
	BEQ		goodJobScreen
	BL		limpaLCD
	LDR	R4, =roundHEX
	MOV 	R10, #6
	MOV		R11, #6
	BL		loopHEXLCD
	BL		RoundNumberHEXLCD
	
writeNumbScreen
	MOV 	R0, #250
	BL		SysTick_Wait1ms					
	BL		limpaLCD
	LDR	R4, =writeNumbHEX
	MOV 	R10, #7
	MOV		R11, #16
	BL		loopHEXLCD
escreveDezenas
	BL		ALtoDetectPress
	MOV		R7, R0
	CMP		R7, #10
	BGE		escreveDezenas
	MOV		R10, #10
	MUL		R7, R10
	BL		decipherMxChar
	MOV 	R0, #250
	BL		SysTick_Wait1ms					
escreveUnidades	
	BL		ALtoDetectPress
	CMP		R0, #10
	BGE		escreveUnidades
	ADD		R7, R0
	BL		decipherMxChar
	MOV 	R0, #150
	BL		SysTick_Wait1ms					
whichAction
	BL		ALtoDetectPress
	CMP		R0, #10
	BLO		whichAction
	B		compareData


ALtoDetectPress
	PUSH{LR}
	BL		dtBtPress
	BL		whichKey
	CMP		R0, #10
	IT		GE
	BLGE	actionKey
	POP{LR}
	BX		LR

goodJobScreen
	BL		limpaLCD
	LDR	R4, =goodJobHEX
	MOV 	R10, #12
	MOV		R11, #25
	BL		loopHEXLCD
	MOV		R8,	#0
	BL		goodJobLEDloop
	BL		limpaLCD
	LDR	R4, =congratsHEX
	MOV 	R10, #14
	MOV		R11, #19
	BL		loopHEXLCD
	MOV		R2, #100
	UDIV	R1, R5, R2
	MOV		R0, R1
	ADD		R0, #0x30
	PUSH{R1}
	BL		escreverDadoLCD
	POP{R1}
	MLS		R12, R1, R2, R5
	MOV		R2, #10
	UDIV	R5, R12, R2
	MOV		R0, R5
	ADD		R0, #0x30
	BL		escreverDadoLCD
	MLS		R0, R5, R2, R12	
	ADD		R0, #0x30
	BL		escreverDadoLCD
	LDR	R4, =vitoriasHEX
	MOV 	R10, #10
	MOV		R11, #10
	BL		loopHEXLCD
	MOV		R5, #0
	BL		bigWINLoop
	B		Start

goodJobLEDloop
	PUSH{LR}
	BL		preparaLED
	CMP	R8, #2
	ITT	LO
	ADDLO	R8, #1
	BLO		goodJobLEDloop
	POP{LR}
	BX		LR

goodJob7segsloop
	PUSH{LR}
	MOV	R0, #2_01111111
goodJob7segsloop1	
	BL	LEDsequence
	PUSH{R0}
	BL		displayLeft
	BL		displayRight
	CMP	R8, #26
	POP{R0}
	ITT	LO
	ADDLO	R8, #1
	BLO		goodJob7segsloop
	CMP	R9, #7
	MOV		R2, #2
	ITT LO
	ADDLO	R9, #1
	MULLO	R0, R2
	BLO		goodJob7segsloop1
	POP{LR}
	BX	LR
	
bigWINLoop
	PUSH{LR}
	MOV		R8,	#0
	MOV		R9, #0
	BL		goodJob7segsloop
	MOV		R8,	#2	
	BL		goodJobLEDloop
	CMP		R5, #3
	ITT		LO
	ADDLO	R5, #1
	BLO		bigWINLoop
	POP{LR}
	BX		LR
	
gameOverScreen
	MOV 	R0, #250
	BL		SysTick_Wait1ms					
	BL		limpaLCD
	LDR	R4, =gameOverHEX
	MOV 	R10, #12
	MOV		R11, #13
	BL		loopHEXLCD
	MOV 	R0, #1500
	BL		SysTick_Wait1ms
	BL		limpaLCD
	LDR	R4, =scoreHEX
	MOV 	R10, #13
	MOV		R11, #22
	BL		loopHEXLCD
	MOV		R12, #10
	SUB		R5, #1
	UDIV	R11, R5, R12
	MOV		R0, R11
	ADD		R0, #0x30
	BL		escreverDadoLCD
	MLS		R0, R12, R11, R5
	ADD		R0, #0x30
	BL		escreverDadoLCD
	BL		preparaLED
	B		Start

;loop para  inserir os caracteres (HEX das listas no final do .s) no LCD
loopHEXLCD
	MOV R12, #0
	PUSH{LR}
loopWithoutLR
	LDRB	R0, [R4], #1
	BL		escreverDadoLCD

	CMP		R12, R10
	ADD		R12, #1						;somo 1 por causa do BEQ position
	IT	EQ								;q volta na cmp R12,#10
	MOVEQ	R0, #0xC0					;para evitar de entrar num loop infinito
	BEQ		positionCursor				;foi preciso R12+=1
	
	CMP		R12, R11
	IT		LO
	BLO		loopWithoutLR
	POP{LR}
	BX		LR


; -------------------------------------------------------------------------------
;Funções referentes a detecção dos inputs do teclado mx
dtBtPress		;detect button press
	LDR	R4, =matrixPsbility
	MOV R12, #0
	PUSH{LR}
	MOV	R3, #1
loopDtKey
	CMP R12, #3
	ADD	R12, #1
	ITT	EQ
	LDREQ	R4, =matrixPsbility-1
	MOVEQ	R12, #0
	
	LDRB R0, [R4, #1]!
	PUSH{R0}
	BL	checkMxKey
	POP{R0}

;Condições p/ preparar a seed da randomização
	PUSH{R0, R1, R2}
	CMP		R3, #99
	ITE		HS
	MOVHS	R3, #1
	ADDLO	R3, #2
	MOV		R1, #5
	UDIV	R0, R3, R1
	MLS		R2, R1, R0, R3
	CMP		R2, #0
	ADDEQ	R3, #2
	POP{R0, R1, R2}
	
	CMP		R2, #0xf0
	BEQ		loopDtKey
	POP{LR}

	BX	LR
	
	NOP


boasVindasHEX 	DCB		0x42, 0x65, 0x6D, 0x2D, 0x76, 0x69, 0x6E, 0x64, 0x6F, 0x20, 0x61, 0x6F, 0x4A, 0x6F, 0x67, 0x6F, 0x20, 0x64, 0x61, 0x20, 0x4D, 0x65, 0x6D, 0x6F, 0x72, 0x69, 0x61, 0X20
;Bem-vindo aoJogo da Memoria
pressButtonHEX	DCB		0x50, 0x52, 0x45, 0x53, 0x53, 0x20, 0x41, 0x4E, 0x59, 0x20, 0x4B, 0x45, 0x59, 0x54, 0x4F, 0x20, 0x53, 0x54, 0x41, 0x52, 0x54, 0x2E
;PRESS ANY KEYTO START (when 0x54, 0x4F go to next line)
ruReadyHEX		DCB		0x41, 0x72, 0x65, 0x20, 0x79, 0x6F, 0x75, 0x20, 0x72, 0x65, 0x61, 0x64, 0x79, 0x3F
;Are you ready?
roundHEX		DCB		0x52, 0x6F, 0x75, 0x6E, 0x64, 0X20
;Round
writeNumbHEX	DCB		0x44, 0x69, 0x67, 0x69, 0x74, 0x65, 0x20, 0x6F, 0X4E, 0X75, 0X6D, 0X65, 0X72, 0X6F, 0X3A
;Digite oNumero:
gameOverHEX		DCB		0x20, 0x20, 0x20, 0x47, 0x41, 0x4D, 0x45, 0x20, 0x4F, 0x56, 0x45, 0x52, 0x2E
;    GAME OVER.
scoreHEX		DCB		0x20, 0x20, 0x54, 0x4F, 0x54, 0x41, 0x4C, 0x20, 0x53, 0x43, 0x4F, 0x52, 0x45, 0x3A, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
;  TOTAL SCORE:
goodJobHEX		DCB		0x20, 0x20, 0x20, 0x20, 0x46, 0x4C, 0x41, 0x57, 0x4C, 0x45, 0x53, 0x53, 0x20, 0x20, 0x20, 0x20, 0x20, 0x56, 0x49, 0x43, 0x54, 0x4F, 0x52, 0x59
;   Good Job!
congratsHEX		DCB		0x50, 0x61, 0x72, 0x61, 0x62, 0x65, 0x6E, 0x73, 0x20, 0x70, 0x65, 0x6C, 0x61, 0x73, 0x20, 0x20, 0x20, 0x20
;Parabens pelas
vitoriasHEX		DCB		0x20, 0x56, 0x69, 0x74, 0x6F, 0x72, 0x69, 0x61, 0x73, 0x21
; XXX vitorias!
matrixPsbility	DCB		2_00001110, 2_00001101, 2_00001011, 2_00000111

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
		
		
		;Feito por: Edson Jonas Sozo Junior & Fabio Zhao Yuan Wang