; Este programa deve esperar o usu�rio pressionar uma chave.
; Caso o usu�rio pressione uma chave, um LED deve piscar a cada 1 segundo.

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
		EXPORT MainLoop
		EXPORT verificaPrimo
		EXPORT ResetPrimeList
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms					
		IMPORT  GPIO_Init
		IMPORT  PortJ_Input		
        IMPORT  numbSelector
		IMPORT	displayLeft
		IMPORT 	displayRight
		IMPORT 	displayPortA
		IMPORT	displayPortQ
		IMPORT 	actLed
		IMPORT 	displaying
		

; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	MOV R5, #0
	MOV R6, #0
	MOV R11, #10
	MOV R12, #1
	MOV R9, #2_10101010
	
ResetPrimeList
	LDR R8, =ListPrimos

MainLoop
	MOV R0, #0100
	BL SysTick_Wait1ms
	BL PortJ_Input				 ;Chama a subrotina que l� o estado das chaves e coloca o resultado em R0
	MOV R10, #0
	
Verifica_Nenhuma
	CMP	R0, #2_00000011			 ;Verifica se nenhuma chave est� pressionada
	BNE Verifica_SW1			 ;Se o teste viu que tem pelo menos alguma chave pressionada pula
	BL TimeToDisplay					 ;Se o teste viu que nenhuma chave est� pressionada, volta para o la�o principal

Verifica_SW1	
	CMP R0, #2_00000010			 ;Verifica se somente a chave SW1 est� pressionada
	BNE Verifica_SW2             ;Se o teste falhou, pula
	CMP R12, #9
	BEQ TimeToDisplay
	ADD R12, #1
	BL TimeToDisplay

Verifica_SW2
	CMP R12, #1
	BEQ TimeToDisplay
	SUB R12, #1
	BL TimeToDisplay

TimeToDisplay
	UDIV R7, R5, R11
	CMP R7, #0
	BEQ baseCase
	MLS R6, R7, R11, R5
	CMP R6, #9
	BEQ registCorrection
	BL	nextStage
	
baseCase
	MOV R6, R5
	CMP R6, #9
	BEQ registCorrection

nextStage
	MOV R4, #2_00000000
	BL actLed
	MOV R3, #2_00000000
	BL displayLeft
	MOV R3, #2_00100000
	BL displayRight
	BL numbSelector

registCorrection
	ADD R7, #1
	BL	nextStage

verificaPrimo
	MOV R1, #2
	LDRB R4, [R8]
	CMP R5, R4
	BEQ Primo
	BGE NextPrime

nextStageLED
	UDIV R10, R9, R1
	MLS R6, R10, R1, R9
	CMP R6, #0
	BEQ registPar
	BNE registImpar

Primo
	MOV R10, #1
	CMP R4, #2
	BEQ NextPrime
	BL displaying

NextPrime
	LDRB R4, [R8, #1]!
	CMP R4, #3
	BEQ displaying
	BL nextStageLED

displayingLED
	MOV R3, #2_00000000
	BL displayRight
	MOV R3, #2_00000000
	BL displayLeft
	MOV R0, R9
	AND R0, #2_11110000
	BL displayPortA
	MOV R0, R9
	AND R0, #2_00001111
	BL displayPortQ
	MOV R4, #2_00100000
	BL actLed
	MOV R10, #1
	BL displaying

registPar
	UDIV R9, R1
	BL displayingLED

registImpar
	MUL R9, R1
	BL displayingLED

;--------------------------------------------------------------------------------
; Fun��o Pisca_LED
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
	NOP


ListPrimos	DCB	 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
