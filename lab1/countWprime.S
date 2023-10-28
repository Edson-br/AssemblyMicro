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
		EXPORT MainLoop
		EXPORT verificaPrimo
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init				
		IMPORT  GPIO_Init	
		IMPORT	GPIOPortJ_Handler
		IMPORT	numbSelector
		IMPORT	LoadNUMB

; -------------------------------------------------------------------------------
; Função main()
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
	MOVEQ R3, R5							;Move o count p/ o "registrador de exibição" somente quando coun<10
	MLSNE R3, R7, R11, R5					;R3 <= R5 - R7*R11
	B	numbSelector						;Vai para nextStage
	
;-------------------------------------------------------------------------------
;Verifica se o numb exibido(r5) atual é primo
;
verificaPrimo
	CMP 	R5, #1
	BEQ		nextStageLED
	MOV 	R1, #2						;p/ decidir o padrão q deve aparecer no LED
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
	MOV 	R10, #4							;Altera o modo de operação
	B		LoadNUMB						;Vai para a label LoadNUMB
;Caso R5 não é primo e R3 é maior que R5, é ativado o nextStageLED

nextStageLED
	MOV	R0, #2
	CMP R6, #0
	ITT 	NE
	MOVNE	R10, #3
	BNE		LoadNUMB
	
	UDIV 	R10, R9, R0					;R10 <= floor(R9/R1), basicamente muda o padrão do LED
	MLS R3, R10, R0, R9					;R3 <= R9 - R1*R10, verifica a paridade de R9
	CMP 	R3, #0
	
	ITE EQ
										;RegistPar e registImpar são usados para criar o padrão alternado
	UDIVEQ 	R9, R0						;Responsavel pelo padrão 01010101
	MULNE 	R9, R0						;Responsavel pelo padrão 10101010
	
	MOV		R10, #3
	B   	LoadNUMB					;Vai para displayingLeft

	NOP

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
		
		
		;Feito por: Edson Jonas Sozo Junior & Fabio Zhao Yuan Wang