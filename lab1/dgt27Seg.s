

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
		
	

numbSelector
	MOV R0, #0
	
	CMP R6, R0
	BEQ NUMB0
	ADD R0, #1
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


NUMB0
	MOV R3, #2_00111111
	BL LoadNUMB
	
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

LoadNUMB
	AND R0, R3, #2_11110000
	BL displayPortA
	AND R0, R3, #2_00001111
	BL displayPortQ
	
	CMP R10, #0
	BEQ	JustRight
	
	CMP R10, #1
	BEQ verificaPrimo
	
	CMP R10, #2
	BEQ JustLeft
	
	ADD R5, R12
	CMP R5, #100
	BGE restarting
	B MainLoop

JustRight
	MOV R4, #2_00000000
	BL actLed
	MOV R3, #2_00000000
	BL displayLeft
	MOV R3, #2_00100000
	BL displayRight
	
	MOV R0, #0100
	BL SysTick_Wait1ms
	
	ADD R10, #1
	BL LoadNUMB

JustLeft
	MOV R4, #2_00000000
	BL actLed
	MOV R3, #2_00000000
	BL displayRight
	MOV R3, #2_00010000
	BL displayLeft
	
	MOV R0, #0100
	BL SysTick_Wait1ms
	
	ADD R10, #1
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