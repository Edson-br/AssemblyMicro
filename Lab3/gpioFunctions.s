; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------

GPIO_PORTA_AHB_DATA_R    	EQU    	0x400583FC
GPIO_PORTQ_AHB_DATA_R    	EQU    	0x400663FC	
GPIO_PORTK_AHB_DATA_R    	EQU    	0x400613FC
GPIO_PORTM_AHB_DATA_R    	EQU    	0x400633FC	
GPIO_PORTL_AHB_DATA_R    	EQU    	0x400623FC
GPIO_PORTB_AHB_DATA_R    	EQU    	0x400593FC	
GPIO_PORTP_AHB_DATA_R    	EQU    	0x400653FC
GPIO_PORTH_AHB_DATA_R    	EQU    	0x4005F3FC


GPIO_PORTJ_AHB_ICR_R 		EQU		0x4006041C
; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
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
		
		IMPORT	LEDsequence
		IMPORT	actLed
		IMPORT	GPIOPortJ_Handler
		IMPORT 	SysTick_Wait1ms
;Enables e disable para LCD
;a princ�pio basta executar enableLCD q o c�digo do disableLCD � executado ap�s 5ms
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
;	PUSH	{LR}
;	MOV 	R0, #0002
;	BL		SysTick_Wait1ms					;Espera 5ms
;	POP		{LR}
	BX 		LR

;Organiza��o das opera��es de acordo com a tabela fornecida

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
	MOV R0, #2_00001110				;00001ABC		A==Ativa display(1 exibe, 0 apaga), B==liga/deslig cursor (1liga, 0deslig)
	STR R0, [R1]					;				C==habilita cursor piscante
	PUSH	{LR}
	BL		enableLCD
	POP		{LR}
	BX 		LR

deslocaMSG							;Deslocam. Cursor/LCD
	LDR	R1, =GPIO_PORTK_AHB_DATA_R	
	MOV R0, #2_00011100				;com S/C setado para 1, fazendo com q seja ativada a opera��o q desloca msg
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
	

positionCursor						;entrada R0 == posi��o que queremos; primeira linha vai de 80h~8Fh, segunda linha vai de C0h~CFh
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

configHalfStep
	MOV R11, #4096
	MOV R7 , #1024
	SUB	R1, R0, #16
	CMP R1, #8
	IT	EQ
	LDREQ	R8, =passoanti
	BX LR
	
configFullStep
	MOV R11, #2048
	MOV R7 , #512
	CMP	R0, #8
	IT	EQ
	LDREQ	R8, =passoanti
	BX LR

motorPasso
	PUSH{R1, R2} 							;para invalidar
	MOV	R1, #2_00000011						;interrup��es ativadas
	LDR R2, =GPIO_PORTJ_AHB_ICR_R			;antes de entrar neste modo
	STR R1, [R2]							
	POP{R1, R2}
	
	MOV	R4, #0
	LDR	R8, =passoHora
	PUSH{LR}
	CMP R0, #16
	IT		HS
	BLHS	configHalfStep
	CMP R0, #16
	IT		LO
	BLLO	configFullStep
	POP{LR}
	
	LDR R12, =passoComp0
	ADD R12, R0
	MOV	R2 , R12
	LDR	R3, =GPIO_PORTH_AHB_DATA_R

passoLoop
	PUSH{LR}
	PUSH{R1}
	BL	mudaStateMotor
	PUSH{R2, R3, R4}
	UDIV	R2, R4, R7
	MOV		R10, R8
	ADD		R10, R2
	LDRB	R0, [R10]
	BL		LEDsequence
	BL		actLed
	BL 		GPIOPortJ_Handler
	MOV		R0, #0xCA
	BL		positionCursor
	POP{R2, R3, R4}
	POP{R1}
	POP{LR}
	
	
	MOV	R0, #8
	ADD	R4, #1
	UDIV	R9, R4, R0
	PUSH{R1}
	MLS		R1, R9, R0, R4
	CMP R1, #0
	MOVEQ R2, R12
	POP{R1}
	CMP 	R4, R11	
	IT		LO
	BLO		passoLoop

	BX	LR

mudaStateMotor
	LDRB	R0, [R2], #1
	LDR		R1, [R3]
	BIC	R1, #2_00001111
	ORR	R0, R0, R1
	STR	R0, [R3]
	BX	LR

	BX	LR									;Retorno

matrixPsbility	DCB		2_00001110, 2_00001101, 2_00001011, 2_00000111
mxToChar		DCB		0xEB, 0x77, 0x7B, 0x7D, 0xB7, 0xBB,0xBD, 0xD7, 0xDB, 0xDD,0x7E, 0xBE, 0xDE, 0xEE, 0xE7 , 0xED
passoComp0		DCB		2_00001000, 2_00000100, 2_00000010, 2_00000001, 2_00001000, 2_00000100, 2_00000010, 2_00000001
passoComp1		DCB		2_00000001, 2_00000010, 2_00000100, 2_00001000, 2_00000001, 2_00000010, 2_00000100, 2_00001000
meioPasso0		DCB		2_00001000, 2_00001100, 2_00000100, 2_00000110, 2_00000010, 2_00000011, 2_00000001, 2_00001001
meioPasso1		DCB		2_00000001, 2_00000011, 2_00000010, 2_00000110, 2_00000100, 2_00001100, 2_00001000, 2_00001001
passoHora		DCB		2_00000011, 2_00001100, 2_00110000, 2_11000000
passoanti		DCB		2_11000000, 2_00110000, 2_00001100, 2_00000011

    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo