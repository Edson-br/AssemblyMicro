; Contador
; Desenvolvido para a placa EK-TM4C1294XL
; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Defini��es de Valores


; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
		EXPORT	ruReadyScreen
		EXPORT	roundScreen
									
		IMPORT  PLL_Init
		IMPORT  SysTick_Init				
		IMPORT  GPIO_Init
		IMPORT	GPIO_InitLED
		IMPORT	SysTick_Wait1ms
		;Opera��es referentes ao LCD
		IMPORT 	limpaLCD
		IMPORT	positionCursor
		IMPORT	escreverDadoLCD
		IMPORT	controleLCD
		IMPORT	modoLCD
		IMPORT  moveCursor
		IMPORT	resetCursorPosition
		; Dados referenes a exibi��o
		IMPORT	RoundNumberHEX
		; Opera��es referentes ao teclado matricial
		IMPORT 	checkMxKey
		IMPORT 	pressedStart
; -------------------------------------------------------------------------------
; Fun��o main()
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
;Fun��es que fazem a exibi��o dos textos
boasVindas
	MOV R5, #0
	LDR	R4, =boasVindasHEX
	MOV		R10, 	#11						;num de hex da primeira linha - 1 (p/ pular para pr�xima linha)
	MOV		R11, 	#0x1C					;numb de hex das duas linhas + 1
	BL		loopHEXLCD
	
PressButtonScreen
	MOV 	R0, #2000
	BL		SysTick_Wait1ms					;Espera 2s
	BL		limpaLCD
	LDR		R4, =pressButtonHEX
	MOV 	R10, #12						;num de hex da primeira linha - 1 (p/ pular para pr�xima linha)
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
	BL		limpaLCD
	LDR	R4, =roundHEX
	MOV 	R10, #6
	MOV		R11, #6
	BL		loopHEXLCD
	BL		RoundNumberHEX
	
writeNumbScreen
	MOV 	R0, #2000
	BL		SysTick_Wait1ms					;Espera 2s
	BL		limpaLCD
	LDR	R4, =writeNumbHEX
	MOV 	R10, #7
	MOV		R11, #16
	BL		loopHEXLCD
	B		writeNumbScreen
	

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
;Fun��es referentes a detec��o dos inputs do teclado mx
dtBtPress		;detect button press
	LDR	R4, =matrixPsbility
	MOV R12, #0
	PUSH{LR}

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
	
	CMP	R2, #0xf0
	BEQ	loopDtKey
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
matrixPsbility	DCB		2_00001110, 2_00001101, 2_00001011, 2_00000111

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
		
		
		;Feito por: Edson Jonas Sozo Junior & Fabio Zhao Yuan Wang