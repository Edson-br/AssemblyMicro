; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------

GPIO_PORTA_AHB_DATA_R    	EQU    	0x400583FC
GPIO_PORTQ_AHB_DATA_R    	EQU    	0x400663FC	
GPIO_PORTK_AHB_DATA_R    	EQU    	0x400613FC
GPIO_PORTM_AHB_DATA_R    	EQU    	0x400633FC	
GPIO_PORTL_AHB_DATA_R    	EQU    	0x400623FC
GPIO_PORTB_AHB_DATA_R    	EQU    	0x400593FC	
GPIO_PORTP_AHB_DATA_R    	EQU    	0x400653FC
GPIO_PORTH_AHB_DATA_R    	EQU    	0x4005F3FC

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT 	limpaLCD
		EXPORT	positionCursor
		EXPORT	escreverDadoLCD
		EXPORT	enableLCD
		EXPORT	disableLCD
		EXPORT  controleLCD
		EXPORT	modoLCD
		EXPORT	moveCursor
		EXPORT	resetCursorPosition	
		EXPORT	inputNumb
		EXPORT	nxline
		EXPORT	motorPasso
		
		IMPORT	GPIOPortJ_Handler
		IMPORT 	SysTick_Wait1ms
;Enables e disable para LCD
;a princípio basta executar enableLCD q o código do disableLCD é executado após 5ms
;e dps de mais 5ms ele volta para o main
enableLCD
	LDR	R1, =GPIO_PORTM_AHB_DATA_R		    
	;Read-Modify-Write para escrita
	MOV	R0, #2_00000100
	LDR R2, [R1]
	BIC R2, #2_00000111                     
	ORR R0, R0, R2                          
	STR R0, [R1]                            
	PUSH	{LR}
	MOV 	R0, #0005
	BL		SysTick_Wait1ms					;Espera 5ms
	BL		disableLCD
	POP		{LR}
	BX 		LR
	
enableRWLCD
	LDR	R1, =GPIO_PORTM_AHB_DATA_R		    
	;Read-Modify-Write para escrita
	MOV	R0, #2_00000101
	LDR R2, [R1]
	BIC R2, #2_00000111                     
	ORR R0, R0, R2                          
	STR R0, [R1]                            
	PUSH	{LR}
	MOV 	R0, #0005
	BL		SysTick_Wait1ms					;Espera 5ms
	POP		{LR}

disableLCD
	LDR	R1, =GPIO_PORTM_AHB_DATA_R		    
	;Read-Modify-Write para escrita
	MOV	R0, #2_00000000
	LDR R2, [R1]
	BIC R2, #2_00000111                     
	ORR R0, R0, R2                          
	STR R0, [R1]                            
	PUSH	{LR}
	MOV 	R0, #0005
	BL		SysTick_Wait1ms					;Espera 5ms
	POP		{LR}
	BX 		LR

;Organização das operações de acordo com a tabela fornecida

limpaLCD
	LDR	R1, =GPIO_PORTK_AHB_DATA_R		    
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	MOV R0, #2_00000001                     
	STR R0, [R1]
	PUSH	{LR}
	BL		enableLCD
	POP		{LR}	
	BX 		LR

resetCursorPosition					;Retorn. Cursor
	LDR	R1, =GPIO_PORTK_AHB_DATA_R	
	MOV R0, #2_00000010
	BIC R2, #0xFE                     		
	ORR R0, R0, R2                          
	STR R0, [R1]  
	PUSH	{LR}
	BL		enableLCD
	POP		{LR}
	BX 		LR

controleLCD							
	LDR	R1, =GPIO_PORTK_AHB_DATA_R	
	MOV R0, #2_00001111				;00001ABC		A==Ativa display(1 exibe, 0 apaga), B==liga/deslig cursor (1liga, 0deslig)
	STR R0, [R1]					;				C==habilita cursor piscante
	PUSH	{LR}
	BL		enableLCD
	POP		{LR}
	BX 		LR

deslocaMSG							;Deslocam. Cursor/LCD
	LDR	R1, =GPIO_PORTK_AHB_DATA_R	
	MOV R0, #2_00011100				;com S/C setado para 1, fazendo com q seja ativada a operação q desloca msg
	BIC R2, #2_11111100                     		
	ORR R0, R0, R2 	
	STR R0, [R1]
	PUSH	{LR}
	BL		enableLCD
	POP		{LR}
	BX 		LR

moveCursor							;Deslocam. Cursor/LCD
	LDR	R1, =GPIO_PORTK_AHB_DATA_R	
	BIC R2, #2_11111100                   
	ORR R0, R0, R2 					;entrada R0 == 0001ABxx; A == Display ou cursor, B == Direita ou esquerda
	STR R0, [R1]
	PUSH	{LR}
	BL		enableLCD
	POP		{LR}
	BX 		LR

nxline
	MOV R0, #0xC0
	PUSH{LR}
	BL moveCursor
	POP{LR}
	BX LR

modoLCD								
	LDR	R1, =GPIO_PORTK_AHB_DATA_R	
	MOV R0, #2_00111100				;001ABCXX	A==largura dos dados enviados(1 8bits 0 4bits), B==numb de linhas (1 2linhas 0 1linha)
	BIC R2, #2_11111100             ;			C == fonte das letras (1 5x10 pixels 0 5x7 pixels)		
	ORR R0, R0, R2	
	STR R0, [R1]
	PUSH	{LR}
	BL		enableLCD
	POP		{LR}
	BX 		LR
	

positionCursor						;entrada R0 == posição que queremos; primeira linha vai de 80h~8Fh, segunda linha vai de C0h~CFh
	LDR	R1, =GPIO_PORTK_AHB_DATA_R	
	LDR R2, [R1]
	BIC R2, #0xFF                     		
	ORR R0, R0, R2                          
	STR R0, [R1]                            
	PUSH	{LR}
	BL		enableLCD
	POP		{LR}
	BX 		LR


escreverDadoLCD
	LDR	R1, =GPIO_PORTK_AHB_DATA_R		    
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #0xFF                     		
	ORR R0, R0, R2                          
	STR R0, [R1]                            
	PUSH	{LR}
	BL		enableRWLCD
	POP		{LR}
	BX 		LR

;=====================
;Teclado matricial
;=====================
inputNumb		;detect button press
	LDR	R4, =matrixPsbility
	MOV R12, #0
	PUSH{LR}
	MOV	R3, #1
loopDtKey
	CMP R12, #3
	ADD	R12, #1
	ITT	EQ
	LDREQ	R4, =matrixPsbility-1
	MOVEQ	R12, #0
	
	LDRB R0, [R4, #1]!
	PUSH{R0}
	BL	checkMxKey
	POP{R0}
	
	CMP		R2, #0xf0
	BEQ		loopDtKey
	POP{LR}

whichKey
	ORR	R6, R2, R0
	LDR	R4, =mxToChar
	MOV	R0, #0
FO_WhichKey	
	LDRB	R10, [R4]
	CMP	R6, R10
	ADDNE	R0,#1
	ADDNE	R4, #1
	BNE		FO_WhichKey
	PUSH	{LR, R0}
	MOV 	R0, #200
	BL		SysTick_Wait1ms					;Espera 5ms
	POP		{LR, R0}
	IT		EQ
	BXEQ	LR

checkMxKey
	LDR	R1, =GPIO_PORTL_AHB_DATA_R
	LDR R2, [R1]
	BIC R2, #2_00001111                     		
	ORR R0, R0, R2                          
	STR R0, [R1]

	LDR	R1, =GPIO_PORTM_AHB_DATA_R
	LDR	R2, [R1]

	PUSH	{R2, LR}
	MOV 	R0, #25
	BL		SysTick_Wait1ms					;Espera 5ms
	POP		{R2, LR}
	
	MOV		R0, R2
	BX	LR

motorPasso
	MOV	R4, #0
	LDR R12, =passoComp0
	ADD R12, R0
	MOV	R5, R12
	LDR	R6, =GPIO_PORTH_AHB_DATA_R

passoLoop
	PUSH{LR}
	BL	mudaStateMotor
	MOV 	R0, #10
	BL		SysTick_Wait1ms					;Espera 10ms
	BL 		GPIOPortJ_Handler
	POP{LR}
	
	MOV	R0, #8
	ADD	R4, #1
	UDIV	R9, R4, R0
	MLS		R1, R9, R0, R4
	
	CMP R1, #0
	MOVEQ R5, R12
	
	CMP 	R4, #2048	
	IT		LE
	BLE		passoLoop

	BX	LR

mudaStateMotor
	LDRB	R7, [R5], #1
	LDR		R8, [R6]
	BIC	R8, #2_00001111
	ORR	R7, R7, R8
	STR	R7, [R6]
	BX	LR

	BX	LR									;Retorno

matrixPsbility	DCB		2_00001110, 2_00001101, 2_00001011, 2_00000111
mxToChar		DCB		0xEB, 0x77, 0x7B, 0x7D, 0xB7, 0xBB,0xBD, 0xD7, 0xDB, 0xDD,0x7E, 0xBE, 0xDE, 0xEE, 0xE7 , 0xED
passoComp0		DCB		2_00001000, 2_00000100, 2_00000010, 2_00000001, 2_00001000, 2_00000100, 2_00000010, 2_00000001
passoComp1		DCB		2_00000001, 2_00000010, 2_00000100, 2_00001000, 2_00000001, 2_00000010, 2_00000100, 2_00001000
meioPasso0		DCB		2_00001000, 2_00001100, 2_00000100, 2_00000110, 2_00000010, 2_00000011, 2_00000001, 2_00001001
meioPasso1		DCB		2_00001001, 2_00000001, 2_00000011, 2_00000010, 2_00000110, 2_00000100, 2_00001100, 2_00001000
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo