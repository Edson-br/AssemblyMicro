; Este programa deve esperar o usuário pressionar uma chave.
; Caso o usuário pressione uma chave, um LED deve piscar a cada 1 segundo.

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
		EXPORT ResetPrimeList
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
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
; Função main()
Start  		
	BL PLL_Init                  	;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              	;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                	;Chama a subrotina que inicializa os GPIO
	
	MOV R5, #0						;registrador contador
	MOV R6, #0						;para ter ctz que o registrador está zerado
	MOV R9, #2_10101010				;registrador p/ led alternado
	MOV R11, #10					;registrador p/ armazenar o nmb 10
	MOV R12, #1						;registrador p/ decidir os passos

ResetPrimeList
	LDR R8, =ListPrimos				;lembrar do endereço do primeiro numb primo da lista definida
	
MainLoop
	;esperar?
	BL 	PortJ_Input				 	;Chama a subrotina que lê o estado das chaves e coloca o resultado em R0
	MOV R10, #0						;registrador p/ determinar os modos de operação
	
Verifica_Nenhuma
	CMP	R0, #2_00000011			 	;Verifica se nenhuma chave está pressionada
	BNE Verifica_SW1			 	;Se o teste viu que tem pelo menos alguma chave pressionada pula
	BL 	TimeToDisplay				;Se o teste viu que nenhuma chave está pressionada, continua com o incremento padrão do ciclo

Verifica_SW1	
	CMP 	R0, #2_00000010				;Verifica se somente a chave SW1 está pressionada
	BNE 	Verifica_SW2             	;Se o teste falhou, pula
	CMP 	R12, #9						;se o passo for 9, mantem e passa vai para o prox processo
	ADDNE 	R12, #1						;caso contrário (c.c) passo += 1 e vai para o prox processo
	BL TimeToDisplay
	
Verifica_SW2
	CMP   R12, #1						;Verifica se o passo atual é 1
	SUBNE R12, #1						;c.c passo -=1

TimeToDisplay
	UDIV R7, R5, R11					;r7 recebe(<=) floor(r5/r11)
	CMP R7, #0							
	BEQ baseCase						;r7 == 0, vai para baseCase
	MLS R6, R7, R11, R5					;r6 <= r5 - r7*r11
	BL	nextStage						;vai para nextStage
	
baseCase
	MOV R6, R5							;move o count p/ o "registrador de exibição" somente quando coun<10
	
nextStage
	CMP R6, #9							
	ADDEQ R7, #1						;r6 == 9, R7 +=1 (feita para "corrigir" o número q será exibido)
	BL numbSelector						;vai para numbSelector (dgt27Seg.s)
	
	
;	
;verifica se o numb exibido(r5) atual é primo
;

verificaPrimo
	MOV 	R1, #2						;p/ decidir o padrão q deve aparecer no LED
	LDRB 	R4, [R8]					;r4 recebe o primo apontado por r8
	CMP 	R5, R4
	BEQ 	Primo						;r5 == r4, r5 é primo
	BGE 	nextPrime					;r5 >= r4, vai para a label nextPrime

nextStageLED
	UDIV R10, R9, R1					;r10 <= floor(r9/r1), basicamente muda o padrão do LED
	MLS R6, R10, R1, R9					;r6 <= r9 - r1*r10, verifica a paridade de r9
	CMP R6, #0
	BEQ registPar						;r9 par, divide r9 por 2
	BNE registImpar						;r9 impar, multiplica por 2

nextPrime
	LDRB R4, [R8, #1]!
	CMP R4, #3
	BEQ displaying
	BL nextStageLED
	
Primo
	MOV R10, #2
	CMP R4, #2
	BEQ nextPrime
	MOV R0, #0100
	BL SysTick_Wait1ms
	BL displaying

registPar
	UDIV R9, R1
	BL displayingLED

registImpar
	MUL R9, R1

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
	
	MOV R0, #0100
	BL SysTick_Wait1ms
	
	MOV R10, #2
	BL displaying
	

	
	
;--------------------------------------------------------------------------------
; Função Pisca_LED
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
	NOP


ListPrimos	DCB	 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo