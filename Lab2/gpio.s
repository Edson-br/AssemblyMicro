
; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
; PORT A
GPIO_PORTA_AHB_LOCK_R    	EQU    	0x40058520
GPIO_PORTA_AHB_CR_R      	EQU    	0x40058524
GPIO_PORTA_AHB_AMSEL_R   	EQU    	0x40058528
GPIO_PORTA_AHB_PCTL_R    	EQU    	0x4005852C
GPIO_PORTA_AHB_DIR_R     	EQU    	0x40058400
GPIO_PORTA_AHB_AFSEL_R   	EQU    	0x40058420
GPIO_PORTA_AHB_DEN_R     	EQU    	0x4005851C
GPIO_PORTA_AHB_PUR_R     	EQU    	0x40058510	
GPIO_PORTA_AHB_DATA_R    	EQU    	0x400583FC
GPIO_PORTA               	EQU    	2_000000000000001	
; PORT Q
GPIO_PORTQ_AHB_LOCK_R    	EQU    	0x40066520
GPIO_PORTQ_AHB_CR_R      	EQU    	0x40066524
GPIO_PORTQ_AHB_AMSEL_R   	EQU    	0x40066528
GPIO_PORTQ_AHB_PCTL_R    	EQU    	0x4006652C
GPIO_PORTQ_AHB_DIR_R     	EQU    	0x40066400
GPIO_PORTQ_AHB_AFSEL_R   	EQU    	0x40066420
GPIO_PORTQ_AHB_DEN_R     	EQU    	0x4006651C
GPIO_PORTQ_AHB_PUR_R     	EQU    	0x40066510	
GPIO_PORTQ_AHB_DATA_R    	EQU    	0x400663FC
GPIO_PORTQ               	EQU    	2_100000000000000	


; PORT K
GPIO_PORTK_AHB_LOCK_R    	EQU    	0x40061520
GPIO_PORTK_AHB_CR_R      	EQU    	0x40061524
GPIO_PORTK_AHB_AMSEL_R   	EQU    	0x40061528
GPIO_PORTK_AHB_PCTL_R    	EQU    	0x4006152C
GPIO_PORTK_AHB_DIR_R     	EQU    	0x40061400
GPIO_PORTK_AHB_AFSEL_R   	EQU    	0x40061420
GPIO_PORTK_AHB_DEN_R     	EQU    	0x4006151C
GPIO_PORTK_AHB_PUR_R     	EQU    	0x40061510	
GPIO_PORTK_AHB_DATA_R    	EQU    	0x400613FC
GPIO_PORTK               	EQU    	2_000001000000000
	
; PORT M
GPIO_PORTM_AHB_LOCK_R    	EQU    	0x40063520
GPIO_PORTM_AHB_CR_R      	EQU    	0x40063524
GPIO_PORTM_AHB_AMSEL_R   	EQU    	0x40063528
GPIO_PORTM_AHB_PCTL_R    	EQU    	0x4006352C
GPIO_PORTM_AHB_DIR_R     	EQU    	0x40063400
GPIO_PORTM_AHB_AFSEL_R   	EQU    	0x40063420
GPIO_PORTM_AHB_DEN_R     	EQU    	0x4006351C
GPIO_PORTM_AHB_PUR_R     	EQU    	0x40063510	
GPIO_PORTM_AHB_DATA_R    	EQU    	0x400633FC
GPIO_PORTM               	EQU    	2_000100000000000

; PORT L
GPIO_PORTL_AHB_LOCK_R    	EQU    	0x40062520
GPIO_PORTL_AHB_CR_R      	EQU    	0x40062524
GPIO_PORTL_AHB_AMSEL_R   	EQU    	0x40062528
GPIO_PORTL_AHB_PCTL_R    	EQU    	0x4006252C
GPIO_PORTL_AHB_DIR_R     	EQU    	0x40062400
GPIO_PORTL_AHB_AFSEL_R   	EQU    	0x40062420
GPIO_PORTL_AHB_DEN_R     	EQU    	0x4006251C
GPIO_PORTL_AHB_PUR_R     	EQU    	0x40062510	
GPIO_PORTL_AHB_DATA_R    	EQU    	0x400623FC
GPIO_PORTL               	EQU    	2_000010000000000

; PORT B
GPIO_PORTB_AHB_LOCK_R    	EQU    	0x40059520
GPIO_PORTB_AHB_CR_R      	EQU    	0x40059524
GPIO_PORTB_AHB_AMSEL_R   	EQU    	0x40059528
GPIO_PORTB_AHB_PCTL_R    	EQU    	0x4005952C
GPIO_PORTB_AHB_DIR_R     	EQU    	0x40059400
GPIO_PORTB_AHB_AFSEL_R   	EQU    	0x40059420
GPIO_PORTB_AHB_DEN_R     	EQU    	0x4005951C
GPIO_PORTB_AHB_PUR_R     	EQU    	0x40059510	
GPIO_PORTB_AHB_DATA_R    	EQU    	0x400593FC
GPIO_PORTB               	EQU    	2_000000000000010	
; PORT P
GPIO_PORTP_AHB_LOCK_R    	EQU    	0x40065520
GPIO_PORTP_AHB_CR_R      	EQU    	0x40065524
GPIO_PORTP_AHB_AMSEL_R   	EQU    	0x40065528
GPIO_PORTP_AHB_PCTL_R    	EQU    	0x4006552C
GPIO_PORTP_AHB_DIR_R     	EQU    	0x40065400
GPIO_PORTP_AHB_AFSEL_R   	EQU    	0x40065420
GPIO_PORTP_AHB_DEN_R     	EQU    	0x4006551C
GPIO_PORTP_AHB_PUR_R     	EQU    	0x40065510	
GPIO_PORTP_AHB_DATA_R    	EQU    	0x400653FC
GPIO_PORTP               	EQU    	2_010000000000000	
	
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    	0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    	0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    	0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    	0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    	0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    	0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    	0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    	0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    	0x400603FC
GPIO_PORTJ               	EQU    	2_000000100000000
	
GPIO_PORTJ_AHB_IS_R 		EQU		0x40060404
GPIO_PORTJ_AHB_IBE_R 		EQU		0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU		0x4006040C
GPIO_PORTJ_AHB_ICR_R 		EQU		0x4006041C
GPIO_PORTJ_AHB_IM_R			EQU	   	0x40060410

GPIO_PORTJ_AHB_RIS_R		EQU		0x40060414
GPIO_PORTJ_AHB_MIS_R    	EQU		0x40060418
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT 	GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT 	limpaLCD
		EXPORT	positionCursor
		EXPORT	escreverDadoLCD
		EXPORT	enableLCD
		EXPORT	disableLCD
		EXPORT  controleLCD
		EXPORT	modoLCD
		EXPORT	moveCursor
		EXPORT	resetCursorPosition	
		EXPORT	checkMxKey
			
		IMPORT 	SysTick_Wait1ms
;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			ORR		R1, #GPIO_PORTA
			ORR		R1, #GPIO_PORTQ

			ORR		R1, #GPIO_PORTK
			ORR		R1, #GPIO_PORTM
			ORR		R1, #GPIO_PORTL
			
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR		R1, #GPIO_PORTB
			ORR		R1, #GPIO_PORTQ
			ORR		R1, #GPIO_PORTP
            STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			ORR     R2, #GPIO_PORTA
			ORR     R2, #GPIO_PORTQ

			ORR		R2, #GPIO_PORTK
			ORR		R2, #GPIO_PORTM
			ORR		R2, #GPIO_PORTL
			
			ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
			ORR     R2, #GPIO_PORTB
			ORR     R2, #GPIO_PORTQ
			ORR     R2, #GPIO_PORTP
            TST     R1, R2							;ANDS de R1 com R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
 
; 2. Limpar o AMSEL para desabilitar a analógica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica	    
			LDR     R0, =GPIO_PORTK_AHB_AMSEL_R		
            STR     R1, [R0]					    
			LDR     R0, =GPIO_PORTM_AHB_AMSEL_R		
            STR     R1, [R0]					    
			LDR     R0, =GPIO_PORTL_AHB_AMSEL_R		
            STR     R1, [R0]					    
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO                
			LDR     R0, =GPIO_PORTK_AHB_PCTL_R		
            STR     R1, [R0]					    
			LDR     R0, =GPIO_PORTM_AHB_PCTL_R		
            STR     R1, [R0]					    
			LDR     R0, =GPIO_PORTL_AHB_PCTL_R		
            STR     R1, [R0]					    		
; 4. DIR para 0 se for entrada, 1 se for saída
            LDR     R0, =GPIO_PORTK_AHB_DIR_R		
			MOV     R1, #2_11111111					
            STR     R1, [R0]						

            LDR     R0, =GPIO_PORTM_AHB_DIR_R		
			MOV     R1, #2_00000111					
            STR     R1, [R0]						
			
            LDR     R0, =GPIO_PORTL_AHB_DIR_R		
			MOV     R1, #2_11111111					
            STR     R1, [R0]						
			; O certo era verificar os outros bits da PF para não transformar entradas em saídas desnecessárias
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa				
            LDR     R0, =GPIO_PORTK_AHB_AFSEL_R		
            STR     R1, [R0]						
            LDR     R0, =GPIO_PORTM_AHB_AFSEL_R		
            STR     R1, [R0]						
            LDR     R0, =GPIO_PORTL_AHB_AFSEL_R     
            STR     R1, [R0]                        

; 6. Setar os bits de DEN para habilitar I/O digital 						
			LDR     R0, =GPIO_PORTK_AHB_DEN_R			
			MOV     R1, #2_11111111						
            STR     R1, [R0]							
            LDR     R0, =GPIO_PORTM_AHB_DEN_R			
			MOV     R1, #2_11110111						
            STR     R1, [R0]							
            LDR     R0, =GPIO_PORTL_AHB_DEN_R			
			MOV     R1, #2_00001111						
            STR     R1, [R0]							
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTM_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_11110000						;Habilitar funcionalidade digital de resistor de pull-up 
                                                        ;nos bits 0 e 1
            STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up


;retorno            
			BX      LR
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
	MOV R0, #2_00010100				;com S/C setado para 0, fazendo com q seja ativada a operação q desloca o cursor
	BIC R2, #2_11111100                     		
	ORR R0, R0, R2 	
	STR R0, [R1]
	PUSH	{LR}
	BL		enableLCD
	POP		{LR}
	BX 		LR

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
	
	BX	LR
	
	BX	LR									;Retorno


    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo