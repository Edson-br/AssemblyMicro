

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
	EXPORT	numbSelector
	EXPORT 	displaying
		
; -------------------------------------------------------------------------------
; Função numbSelector
; Parâmetro de entrada: R6 --> Numero a ser impresso
; Parâmetro de saída: nao tem
numbSelector
	MOV R0, #0					;zera o R0 para fazer utliza-lo como contador
	
	CMP R6, R0					;compara o R6 como o contador R0
	BEQ NUMB0					;caso R6==#0-R0 vai para funcao numb0
	ADD R0, #1					;incrementa R0
	CMP R6, R0
	BEQ NUMB1
	ADD R0, #1
	CMP R6, R0
	BEQ NUMB2
	ADD R0, #1
	CMP R6, R0
	BEQ NUMB3
	ADD R0, #1
	CMP R6, R0
	BEQ NUMB4
	ADD R0, #1
	CMP R6, R0
	BEQ NUMB5
	ADD R0, #1
	CMP R6, R0
	BEQ NUMB6
	ADD R0, #1
	CMP R6, R0
	BEQ NUMB7
	ADD R0, #1
	CMP R6, R0
	BEQ NUMB8
	ADD R0, #1
	CMP R6, R0
	BEQ NUMB9

; -------------------------------------------------------------------------------
; Função numb* [0-9]
; Parâmetro de entrada: Nao tem
; Parâmetro de saída: R3 --> Bits do display de sete seg
NUMB0
	MOV R3, #2_00111111					;seta o R3 com os valores do display de sete segmentos 
										;a fim de formar o numero 0
	BL LoadNUMB							;chama a funcao de carregar o numero
	
NUMB1
	MOV R3, #2_00000110
	BL LoadNUMB
	
NUMB2
	MOV R3, #2_01011011
	BL LoadNUMB

NUMB3
	MOV R3, #2_01001111
	BL LoadNUMB

NUMB4
	MOV R3, #2_01100110
	BL LoadNUMB

NUMB5
	MOV R3, #2_01101101
	BL LoadNUMB

NUMB6
	MOV R3, #2_01111101
	BL LoadNUMB

NUMB7
	MOV R3, #2_00000111
	BL LoadNUMB

NUMB8
	MOV R3, #2_01111111
	BL LoadNUMB

NUMB9
	MOV R3, #2_01100111
	BL LoadNUMB

; -------------------------------------------------------------------------------
; Função LoadNUMB
; Parâmetro de entrada: R3 --> Valor dos sete seg | R10 --> Contador do mutiplexador dos displays
; Parâmetro de saída: Nao tem 
LoadNUMB
	AND R0, R3, #2_11110000			;Seleciona a primeira parte do display a fim de usar a porta A4-A7
									;R0 <-- R3 & 11110000	
	BL displayPortA					;Chama a funcao displayPortA (GPIO)
	AND R0, R3, #2_00001111			;Seleciona a segunda  parte do display a fim de usar a porta Q0-Q3
									;R0 <-- R3 & 00001111	
	BL displayPortQ					;Chama a funcao displayPortQ (GPIO)
	
	CMP R10, #0
	BEQ	JustRight					;R10 == 0 chama a funcao do display Direito
	
	CMP R10, #1
	BEQ verificaPrimo				;R10 == 1 chama a funcao do verifica primo(Leds)
	
	CMP R10, #2
	BEQ JustLeft					;R10 == 2 chama a funcao do display Esquerdo
	
	ADD R5, R12
	CMP R5, #100
	BGE restarting
	B MainLoop

; -------------------------------------------------------------------------------
; Função JustRight-JustLeft
; Parâmetro de entrada: R4 -->  Transistor dos LED | R3 --> Transistor dos displays
; Parâmetro de saída: R10 --> Contador do mutiplexador dos displays
JustRight
	MOV R4, #2_00000000			;Zera R4
	BL actLed
	MOV R3, #2_00000000			;Zera R3(porta do display esquerdo)
	BL displayLeft
	MOV R3, #2_00100000			;Ativa R3(porta do display direito)
	BL displayRight
	
	MOV R0, #0100
	BL SysTick_Wait1ms			;Chama a funcao de esperar 1 ms
	
	ADD R10, #1					;R10 + = 1 | adiciona um ao contador de multiplexador
	BL LoadNUMB

JustLeft
	MOV R4, #2_00000000			;Zera R4
	BL actLed
	MOV R3, #2_00000000			;Zera R3(porta do display direito)
	BL displayRight
	MOV R3, #2_00010000			;Ativa R3(porta do display esquerdo)
	BL displayLeft
	
	MOV R0, #0100
	BL SysTick_Wait1ms			;Chama a funcao de esperar 1 ms
	
	ADD R10, #1					;R10 + = 1 | adiciona um ao contador de multiplexador
	BL LoadNUMB

displaying
	MOV R6, R7
	BL numbSelector

restarting
	MOV R10, #100
	UDIV R7, R5, R10
	MLS	R6, R10, R7, R5
	MOV R5, R6
	B ResetPrimeList
	
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo