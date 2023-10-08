

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
	MOV R0, #2_00110000
	BL displayPortA
	MOV R0, #2_00001111
	BL displayPortQ
	BL NUMBOVER
	
NUMB1
	MOV R0, #2_00000000
	BL displayPortA
	MOV R0, #2_00000110
	BL displayPortQ
	BL NUMBOVER
	
NUMB2
	MOV R0, #2_01010000
	BL displayPortA
	MOV R0, #2_00001011
	BL displayPortQ
	BL NUMBOVER

NUMB3
	MOV R0, #2_01000000
	BL displayPortA
	MOV R0, #2_00001111
	BL displayPortQ
	BL NUMBOVER

NUMB4
	MOV R0, #2_01100000
	BL displayPortA
	MOV R0, #2_00000110
	BL displayPortQ
	BL NUMBOVER

NUMB5
	MOV R0, #2_01100000
	BL displayPortA
	MOV R0, #2_00001101
	BL displayPortQ
	BL NUMBOVER

NUMB6
	MOV R0, #2_01110000
	BL displayPortA
	MOV R0, #2_00001101
	BL displayPortQ
	BL NUMBOVER

NUMB7
	MOV R0, #2_00000000
	BL displayPortA
	MOV R0, #2_00000111
	BL displayPortQ
	BL NUMBOVER

NUMB8
	MOV R0, #2_01110000
	BL displayPortA
	MOV R0, #2_00001111
	BL displayPortQ
	BL NUMBOVER

NUMB9
	MOV R0, #2_01100000
	BL displayPortA
	MOV R0, #2_00000111
	BL displayPortQ
	BL NUMBOVER
	
NUMBOVER
	CMP R10, #0
	BEQ verificaPrimo
	CMP R10, #1
	BEQ displaying
	ADD R5, R12
	CMP R5, #100
	BGE restarting
	B MainLoop


displaying
	MOV R0, #1000
	BL SysTick_Wait1ms
	MOV R4, #2_00000000
	BL actLed
	MOV R3, #2_00000000
	BL displayRight
	MOV R3, #2_00010000
	BL displayLeft
	ADD R10, #1
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