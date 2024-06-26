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
		EXPORT MainLoop
		EXPORT verificaPrimo
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init				
		IMPORT  GPIO_Init	
		IMPORT	GPIOPortJ_Handler
		IMPORT	numbSelector
		IMPORT	LoadNUMB

; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  		;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              		;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                		;Chama a subrotina que inicializa os GPIO
	
	MOV R5, #0							;Registrador contador
	MOV R9, #2_10101010					;Registrador p/ led alternado
	MOV R11, #10						;Registrador p/ armazenar o nmb 10
	MOV R12, #1							;Registrador p/ decidir os passos
	
MainLoop
	MOV R10, #0
	BL GPIOPortJ_Handler
TimeToDisplay
	UDIV R7, R5, R11					;R7 recebe(<=) floor(R5/R11)
	CMP R7, #0							
	ITE EQ
	MOVEQ R3, R5							;Move o count p/ o "registrador de exibi��o" somente quando coun<10
	MLSNE R3, R7, R11, R5					;R3 <= R5 - R7*R11
	B	numbSelector						;Vai para nextStage
	
;-------------------------------------------------------------------------------
;Verifica se o numb exibido(r5) atual � primo
;
verificaPrimo
	CMP 	R5, #1
	BEQ		nextStageLED
	MOV 	R1, #2						;p/ decidir o padr�o q deve aparecer no LED
	MOV		R3, #2						;R3 recebe o primo apontado por r8
	
tryNextPrime
	CMP 	R3, R5						;p/ o caso R5 = 2
	BEQ		itsPrime
	UDIV	R4, R5, R3
	MLS		R2, R4, R3, R5
	
	CMP		R2, #0
	BEQ		nextStageLED
	
	MUL		R4, R3, R3
	CMP		R4, R5
	
	ITT 	LO
	ADDLO	R3, #1
	BLO		tryNextPrime

itsPrime
	MOV 	R10, #4							;Altera o modo de opera��o
	B		LoadNUMB						;Vai para a label LoadNUMB
;Caso R5 n�o � primo e R3 � maior que R5, � ativado o nextStageLED

nextStageLED
	MOV	R0, #2
	CMP R6, #0
	ITT 	NE
	MOVNE	R10, #3
	BNE		LoadNUMB
	
	UDIV 	R10, R9, R0					;R10 <= floor(R9/R1), basicamente muda o padr�o do LED
	MLS R3, R10, R0, R9					;R3 <= R9 - R1*R10, verifica a paridade de R9
	CMP 	R3, #0
	
	ITE EQ
										;RegistPar e registImpar s�o usados para criar o padr�o alternado
	UDIVEQ 	R9, R0						;Responsavel pelo padr�o 01010101
	MULNE 	R9, R0						;Responsavel pelo padr�o 10101010
	
	MOV		R10, #3
	B   	LoadNUMB					;Vai para displayingLeft

	NOP

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
		
		
		;Feito por: Edson Jonas Sozo Junior & Fabio Zhao Yuan Wang