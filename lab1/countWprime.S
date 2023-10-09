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
		EXPORT resetRegister
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
		IMPORT 	displayingLeft
		

constTime	EQU		0050;
	

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


ResetPrimeList
	LDR R8, =ListPrimos					;Lembrar do endereço do primeiro numb primo da lista definida
	
MainLoop
	BL 	PortJ_Input				 		;Chama a subrotina que lê o estado das chaves e coloca o resultado em R0
	
Verifica_Nenhuma
										;Registrador p/ determinar os modos de operação
	CMP	R0, #2_00000011			 		;Verifica se nenhuma chave está pressionada
	BNE Verifica_SW1			 		;Se o teste viu que tem pelo menos alguma chave pressionada pula
	B	TimeToDisplay					;Se o teste viu que nenhuma chave está pressionada, continua com o incremento padrão do ciclo

Verifica_SW1	
	CMP 	R0, #2_00000010				;Verifica se somente a chave SW1 está pressionada
	BNE 	Verifica_SW2             	;Se o teste falhou, pula
	CMP 	R12, #9						;Se o passo for 9, mantem e passa vai para o prox processo
	ADDNE 	R12, #1						;Caso contrário (c.c) passo += 1 e vai para o prox processo
	B		TimeToDisplay
	
Verifica_SW2
	CMP   R12, #1						;Verifica se o passo atual é 1
	SUBNE R12, #1						;c.c passo -=1

resetRegister
	MOV R10, #0

TimeToDisplay
	UDIV R7, R5, R11					;R7 recebe(<=) floor(R5/R11)
	CMP R7, #0							
	BEQ baseCase						;R7 == 0, vai para baseCase
	MLS R3, R7, R11, R5					;R3 <= R5 - R7*R11
	B	nextStage						;Vai para nextStage
	
baseCase
	MOV R3, R5							;Move o count p/ o "registrador de exibição" somente quando coun<10
	
nextStage
	B	numbSelector					;Vai para numbSelector (dgt27Seg.s)
	
	
;-------------------------------------------------------------------------------
;Verifica se o numb exibido(r5) atual é primo
;

verificaPrimo
	MOV 	R1, #2						;p/ decidir o padrão q deve aparecer no LED
	LDRB 	R3, [R8]					;R3 recebe o primo apontado por r8
	CMP 	R5, R3
	BEQ 	Primo						;R5 == R3, R5 é primo
	BGE 	nextPrime					;R5 >= R3, vai para a label nextPrime

;Caso R5 não é primo, é ativado o nextStageLED

nextStageLED
	CMP R6, #1
	BNE	displayingLED
	UDIV 	R10, R9, R1					;R10 <= floor(R9/R1), basicamente muda o padrão do LED
	MLS R3, R10, R1, R9					;R3 <= R9 - R1*R10, verifica a paridade de R9
	CMP R3, #0
										;RegistPar e registImpar são usados para criar o padrão alternado
	BEQ registPar						;R9 par, divide R9 por 2
	BNE registImpar						;R9 impar, multiplica por 2

;Se R5 é primo

Primo
	MOV R10, #2							;Altera o modo de operação (ativa JustLeft)
	MOV R0, #0005						;Espera 5ms
	BL	SysTick_Wait1ms
	B	displayingLeft					;Vai para a label displayingLeft

nextPrime
	LDRB	R3, [R8, #1]!				;R8 += 1 e depois R3 recebe o byte apontado por R8
	CMP 	R3, #3						;Comparação necessária para garantir que não há "fade" nos LEDs quando o numb 3 é exibido 
	BEQ		displayingLeft
	B 		nextStageLED				;Vai para nextStageLED
	
;-------------------------------------------------------------------------------
;recria o padrão 01010101
registPar
	UDIV R9, R1							;Responsavel pelo padrão 01010101
	B   displayingLeft					;Vai para displayingLeft

;-------------------------------------------------------------------------------
;recria o padrão 10101010
registImpar
	MUL R9, R1							;Responsavel pelo padrão 10101010
	B 	displayingLeft					;Vai para displayingLeft (n)
	
;-------------------------------------------------------------------------------
; Função displayingLED
; Parâmetro de entrada: R0 --> placeholder p/ estado desejado dos componentes
; Parâmetro de saída: R10 --> Contador do mutiplexador dos displays
displayingLED
	MOV R0, #2_00000000					;Desativa o display da direita
	BL 	displayRight
	MOV R0, #2_00000000					;Desativa o display da esquerda
	BL 	displayLeft
	
	MOV R0, R9							;Seleciona o padrão desejado (10101010 ou 01010101)
	AND R0, #2_11110000					;Seleciona a primeira parte do display a fim de usar a porta A4-A7
										;R0 <-- R9 & 11110000
	BL 	displayPortA					;Chama a funcao displayPortA (GPIO)
	MOV R0, R9							;Seleciona o padrão desejado (10101010 ou 01010101)
	AND R0, #2_00001111					;Seleciona a segunda  parte do display a fim de usar a porta Q0-Q3
										;R0 <-- R9 & 00001111
	BL 	displayPortQ					;Chama a funcao displayPortQ (GPIO)
	
	MOV R0, #2_00100000					;Ativa os LEDs
	BL 	actLed
	
	MOV R0, #0005
	BL 	SysTick_Wait1ms
	
	MOV R0, #2_00000000					;Desativa os LEDs
	BL 	actLed
	
	MOV R10, #2
	B 	displayingLeft
	
	NOP


ListPrimos	DCB	 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo