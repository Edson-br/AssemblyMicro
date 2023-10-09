

    AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB

	IMPORT 	MainLoop
	IMPORT 	displayPortA
	IMPORT 	displayPortQ
	IMPORT 	displayLeft
	IMPORT 	displayRight
	IMPORT 	verificaPrimo
	IMPORT  SysTick_Wait1ms	
	IMPORT 	actLed
	IMPORT	ResetPrimeList
	IMPORT 	resetRegister
	EXPORT	numbSelector
	EXPORT 	displayingLeft
		

constTime	EQU		0050;
; -------------------------------------------------------------------------------
; Função numbSelector
; Parâmetro de entrada: R6 --> Numero a ser impresso
; Parâmetro de saída: nao tem
numbSelector
	MOV R0, #0				;zera o R0 para fazer utliza-lo como contador
	
	CMP R3, R0				;compara o R3 com o contador R0
	BEQ NUMB0				;caso R6==#0-R0 vai para funcao numb0
	ADD R0, #1				;c.c R0 += 1
	CMP R3, R0
	BEQ NUMB1
	ADD R0, #1
	CMP R3, R0
	BEQ NUMB2
	ADD R0, #1
	CMP R3, R0
	BEQ NUMB3
	ADD R0, #1
	CMP R3, R0
	BEQ NUMB4
	ADD R0, #1
	CMP R3, R0
	BEQ NUMB5
	ADD R0, #1
	CMP R3, R0
	BEQ NUMB6
	ADD R0, #1
	CMP R3, R0
	BEQ NUMB7
	ADD R0, #1
	CMP R3, R0
	BEQ NUMB8
	ADD R0, #1
	CMP R3, R0
	BEQ NUMB9

; -------------------------------------------------------------------------------
; Função numb* [0-9]
; Parâmetro de entrada: Nao tem
; Parâmetro de saída: R3 --> Bits do display de sete seg
NUMB0
	MOV R3, #2_00111111						;seta o R3 com os valores do display de sete segmentos 
											;a fim de formar o numero 0
	B 	LoadNUMB							;chama a funcao de carregar o numero
	
NUMB1
	MOV R3, #2_00000110
	B 	LoadNUMB
	
NUMB2
	MOV R3, #2_01011011
	B 	LoadNUMB

NUMB3
	MOV R3, #2_01001111
	B 	LoadNUMB

NUMB4
	MOV R3, #2_01100110
	B	LoadNUMB

NUMB5
	MOV R3, #2_01101101
	B 	LoadNUMB

NUMB6
	MOV R3, #2_01111101
	B 	LoadNUMB

NUMB7
	MOV R3, #2_00000111
	B 	LoadNUMB

NUMB8
	MOV R3, #2_01111111
	B 	LoadNUMB

NUMB9
	MOV R3, #2_01100111
	B	LoadNUMB


; -------------------------------------------------------------------------------
; Função LoadNUMB
; Parâmetro de entrada: R3 --> Valor dos sete seg | R10 --> Contador do mutiplexador dos displays
; Parâmetro de saída: Nao tem 
LoadNUMB
	AND R0, R3, #2_11110000				;Seleciona a primeira parte do display a fim de usar a porta A4-A7
										;R0 <-- R3 & 11110000
	BL displayPortA						;Chama a funcao displayPortA (GPIO)
	AND R0, R3, #2_00001111				;Seleciona a segunda  parte do display a fim de usar a porta Q0-Q3
										;R0 <-- R3 & 00001111
	BL displayPortQ						;Chama a funcao displayPortQ (GPIO)
	
	CMP R10, #0
	BEQ	JustRight						;R10 == 0 chama a funcao do display Direito
	
	CMP R10, #1
	BEQ verificaPrimo					;R10 == 1 chama a funcao do verifica primo(Leds)
	
	CMP R10, #2
	BEQ JustLeft						;R10 == 2 chama a funcao do display Esquerdo
	
	ADD R6, #1							;R6 += 1 (cronometro universal, quando r6 completa seu ciclo o sistema adiciona 1 ao numb exibido nos displays)
	CMP R6, #constTime					;compara R6 com a constante de tempo
	ADDEQ R5, R12						;caso igual, R5 += R12 (passo definido pelo sw1 sw2)
	MOVEQ R6, #0						;prepara R6 para o próximo ciclo
	
	CMP R5, #100						;verifica se R5 == 100
	BGE restarting						;se sim, vai para a label restarting
	
	CMP R6, #0							;verifica se R6 == 0 (se está preparado para o próx ciclo)
	BEQ MainLoop						;se sim vai para MainLoop (countWprime.S)
	
	B 	resetRegister					;vai para a label resetRegister (countWprime.S)

;-------------------------------------------------------------------------------
; Função JustRight-JustLeft
; Parâmetro de entrada: R0 --> placeholder p/ estado desejado dos componentes
; Parâmetro de saída: R10 --> Contador do mutiplexador dos displays
JustRight
	MOV R0, #2_00000000					;Desativa o conjunto de LEDs
	BL 	actLed
	MOV R0, #2_00000000					;Desativa o display da esquerda
	BL 	displayLeft
	MOV R0, #2_00100000					;Ativa o display da direita
	BL 	displayRight
	
	MOV R0, #0005
	BL 	SysTick_Wait1ms					;Espera 5ms
	
	MOV R3, #2_00000000					;Desativa o display da direita
	BL 	displayRight	
	
	ADD R10, #1							;R10 + = 1 | adiciona um ao contador de multiplexador
	B	LoadNUMB

JustLeft
	MOV R0, #2_00000000					;Desativa o conjunto de LEDs
	BL 	actLed
	MOV R0, #2_00000000					;Desativa o display da direita
	BL 	displayRight
	MOV R0, #2_00010000					;Ativa o display da esquerda
	BL 	displayLeft
	
	MOV R0, #0005
	BL 	SysTick_Wait1ms					;Espera 5ms

	MOV R0, #2_00000000					;Desativa o display da esquerda
	BL 	displayLeft
	
	ADD R10, #1							;R10 + = 1 | adiciona um ao contador de multiplexador
	B	LoadNUMB

displayingLeft
	MOV R3, R7							;prepara o algarismo das dezenas 
	B	numbSelector					;vai para numbSelector	

;-------------------------------------------------------------------------------
;Função restarting
;Usado para garantir que R5 sempre recebe um numb entre 0 e 99, incluindo ambos os extremos
restarting
	MOV 	R10, #100					
	UDIV 	R7, R5, R10
	MLS		R3, R10, R7, R5
	MOV 	R5, R3
	B 		ResetPrimeList				;(countWprime.S)
	
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo