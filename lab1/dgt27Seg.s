

    AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB

	EXPORT	numbSelector
	EXPORT	LoadNUMB

	IMPORT	SysTick_Wait1ms
	IMPORT	actLed
	IMPORT	displayLeft
	IMPORT	displayRight
	IMPORT	displayPortA
	IMPORT	displayPortQ
	IMPORT	verificaPrimo
	IMPORT 	MainLoop

constTime	EQU		40;
; -------------------------------------------------------------------------------
; Função numbSelector
; Parâmetro de entrada: R6 --> Numero a ser impresso
; Parâmetro de saída: nao tem
numbSelector
	LDR R1, =ListDisplayPattern
	MOV R0, #0				;zera o R0 para fazer utliza-lo como contador

AGAIN
	CMP R0, R3
	
	ITEET LO
	ADDLO 	R0, #1
	ADDHS 	R1, R0
	LDRBHS 	R3, [R1]
	BLO		AGAIN	

; -------------------------------------------------------------------------------
; Função LoadNUMB
; Parâmetro de entrada: R3 --> Valor dos sete seg | R10 --> Contador do mutiplexador dos displays
; Parâmetro de saída: Nao tem 
LoadNUMB
	MOV 	R0, #0005
	BL		SysTick_Wait1ms					;Espera 5ms
	MOV R0, #2_00000000					;Desativa o conjunto de LEDs
	BL 	actLed
	MOV R0, #2_00000000					;Desativa o display da esquerda
	BL 	displayLeft
	MOV R0, #2_00000000					;Desativa o display da direita
	BL 	displayRight	
	
	CMP R10, #3
	MOVEQ R3, R9
	
	AND R0, R3, #2_11110000				;Seleciona a primeira parte do display a fim de usar a porta A4-A7
										;R0 <-- R3 & 11110000
	BL displayPortA						;Chama a funcao displayPortA (GPIO)
	AND R0, R3, #2_00001111				;Seleciona a segunda  parte do display a fim de usar a porta Q0-Q3
										;R0 <-- R3 & 00001111
	BL displayPortQ						;Chama a funcao displayPortQ (GPIO)
	
	CMP R10, #1
	ADD R10, #1
;(FLAGnumb 0)STEP 0, ACTIVATE AND DEACTIVATE DISPLAYRIGHT
	ITT   	LO
	MOVLO	R0, #2_00100000					;Ativa o display da direita
	BLLO	displayRight

;(FLAGnumb 1)STEP 1, SET THE RIGHT DATE FOR THE DISPLAYLEFT
	CMP R10, #1
	MOVEQ	R10, #1							;para corrigir flagNumb
	MOVEQ 	R3, R7							;prepara o algarismo das dezenas 
	BEQ		numbSelector					;vai para numbSelector	

;(FLAGnumb 2)STEP 2, 
	CMP R10, #2
	ITT		EQ
	MOVEQ	R0, #2_00010000					;Ativa o display da esquerda
	BLEQ 	displayLeft
;(FLAGnumb 3)STEP 3, VERIFY PRIME NUMBER
	BEQ		verificaPrimo
;(FLAGnumb 4)STEP 4, ACTIVATE LED
	CMP	R10, #4
	MOVEQ R0, #2_00100000					;Desativa o conjunto de LEDs
	BLEQ 	actLed
	
	ADD R6, #1							;R6 += 1 (cronometro universal, quando r6 completa seu ciclo o sistema adiciona 1 ao numb exibido nos displays)
	CMP R6, #constTime					;compara R6 com a constante de tempo
	ADDEQ R5, R12						;caso igual, R5 += R12 (passo definido pelo sw1 sw2)
	MOVEQ R6, #0						;prepara R6 para o próximo ciclo
	
	CMP R5, #100						;verifica se R5 == 100
	ITT		GE
	MOVGE 	R10, #100					
	UDIVGE 	R7, R5, R10
	ITT		GE
	MLSGE	R3, R10, R7, R5
	MOVGE 	R5, R3
	
	B 	MainLoop						;vai para a label MainLoop (countWprime.S)


ListDisplayPattern DCB 2_00111111, 2_00000110, 2_01011011, 2_01001111, 2_01100110, 2_01101101, 2_01111101, 2_00000111, 2_01111111, 2_01100111
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo