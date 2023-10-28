
; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports
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


;NVIC registers
NVIC_EN1_R					EQU		0xE000E104
NVIC_PRI12_R 				EQU		0xE000E430
; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
;		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT displayPortA
		EXPORT displayPortQ
		EXPORT displayLeft
		EXPORT displayRight
		EXPORT actLed
		EXPORT GPIOPortJ_Handler

;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTB                 ;Seta o bit da porta B
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR		R1, #GPIO_PORTA
			ORR		R1, #GPIO_PORTQ
			ORR		R1, #GPIO_PORTP
            STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
			MOV     R2, #GPIO_PORTB                 ;Seta os bits correspondentes �s portas para fazer a compara��o
			ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
			ORR     R2, #GPIO_PORTA
			ORR     R2, #GPIO_PORTQ
			ORR     R2, #GPIO_PORTP
            TST     R1, R2							;ANDS de R1 com R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando
 
; 2. Limpar o AMSEL para desabilitar a anal�gica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endere�o do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da mem�ria
            LDR     R0, =GPIO_PORTB_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da mem�ria
			LDR     R0, =GPIO_PORTA_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da mem�ria
			LDR     R0, =GPIO_PORTQ_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da mem�ria
			LDR     R0, =GPIO_PORTP_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da mem�ria
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endere�o do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da mem�ria
            LDR     R0, =GPIO_PORTB_AHB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da mem�ria
            LDR     R0, =GPIO_PORTA_AHB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da mem�ria	
            LDR     R0, =GPIO_PORTQ_AHB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da mem�ria
            LDR     R0, =GPIO_PORTP_AHB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da mem�ria			
; 4. DIR para 0 se for entrada, 1 se for sa�da
            LDR     R0, =GPIO_PORTB_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta B
			MOV     R1, #2_00110000					;PB4 & PB5 para TRANSISTOR CONTROLE DISPLAY
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTA_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta B
			MOV     R1, #2_11110000					;PA de 4 a 7 para DISPLAY
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTQ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta B
			MOV     R1, #2_00001111					;PQ de 0 a 3 para DISPLAY
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTP_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta B
			MOV     R1, #2_00100000					;P5 para TRANSISTOR CONTROLE LED
            STR     R1, [R0]						;Guarda no registrador
			; O certo era verificar os outros bits da PF para n�o transformar entradas em sa�das desnecess�rias
            LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta J
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com sa�da
            STR     R1, [R0]						;Guarda no registrador PCTL da porta J da mem�ria
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem fun��o alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
            LDR     R0, =GPIO_PORTB_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta B
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTA_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta A
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTQ_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta Q
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTP_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta P
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endere�o do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTB_AHB_DEN_R			;Carrega o endere�o do DEN
            MOV     R1, #2_00110000                     ;Ativa os pinos PB5 e PB4 como I/O Digital
            STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
            LDR     R0, =GPIO_PORTA_AHB_DEN_R			;Carrega o R0 com o endere�o do DIR para a porta B
			MOV     R1, #2_11110000						;PA de 4 a 7 para DISPLAY
            STR     R1, [R0]							;Guarda no registrador
            LDR     R0, =GPIO_PORTQ_AHB_DEN_R			;Carrega o R0 com o endere�o do DIR para a porta B
			MOV     R1, #2_00001111						;PQ de 0 a 3 para DISPLAY
            STR     R1, [R0]							;Guarda no registrador
            LDR     R0, =GPIO_PORTP_AHB_DEN_R			;Carrega o R0 com o endere�o do DIR para a porta B
			MOV     R1, #2_00100000						;P5 para TRANSISTOR CONTROLE LED
            STR     R1, [R0]							;Guarda no registrador
 
            LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endere�o do DEN
			MOV     R1, #2_00000011                     ;Ativa os pinos PJ0 e PJ1 como I/O Digital      
            STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endere�o do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
                                                        ;nos bits 0 e 1
            STR     R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up
            
; 8. Habilitando interrup��o na portaJ
			LDR		R0, =GPIO_PORTJ_AHB_IM_R
			MOV		R1, #2_00000000
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTJ_AHB_IS_R 
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTJ_AHB_IBE_R
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTJ_AHB_IEV_R
			MOV		R1, #2_00000011
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTJ_AHB_ICR_R
			MOV		R1, #2_00000011
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTJ_AHB_IM_R
			MOV		R1, #2_00000011
			
			LDR		R0, =NVIC_EN1_R
			MOV		R1, #1
			LSL		R1, #19
			STR		R1, [R0]
			
			LDR		R0, =NVIC_PRI12_R
			MOV		R1, #5
			LSL		R1, #29
			STR		R1, [R0]
;retorno            
			BX      LR

; Fun��o PortF_Output
; Par�metro de entrada: R0 --> se os BIT4 e BIT0 est�o ligado ou desligado
; Par�metro de sa�da: N�o tem
displayPortA
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta A o barramento de dados dos pinos A4 a A7
	BX LR

displayPortQ
	LDR	R1, =GPIO_PORTQ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R2, [R1]
	BIC R2, #2_00001111                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta Q o barramento de dados dos pinos Q4 a Q0
	BX LR
	
displayLeft
	LDR	R1, =GPIO_PORTB_AHB_DATA_R
	LDR R2, [R1]
	BIC R2, #2_00010000                  
	ORR R0, R0, R2                          
	STR R0, [R1]
	BX LR

displayRight
	LDR	R1, =GPIO_PORTB_AHB_DATA_R
	LDR R2, [R1]
	BIC R2, #2_00100000                  
	ORR R0, R0, R2                          
	STR R0, [R1]
	BX LR
	
actLed
	LDR	R1, =GPIO_PORTP_AHB_DATA_R
	LDR R2, [R1]
	BIC R2, #2_00100000                  
	ORR R0, R0, R2                          
	STR R0, [R1]
	
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
;PortJ_Input
;	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
;	LDR R0, [R1]                            ;L� no barramento de dados dos pinos [J1-J0]
;	BX LR									;Retorno
GPIOPortJ_Handler
	LDR R1, =GPIO_PORTJ_AHB_RIS_R
	LDR R0, [R1]
	
	CMP R0, #1
	ADDEQ R12, #1
	CMP R12, #10
	MOVEQ R12, #9
	
	CMP R0, #2
	SUBEQ R12, #1
	CMP R12, #0
	MOVEQ R12, #1
	
	
	MOV	R1, #2_00000011
	LDR R2, =GPIO_PORTJ_AHB_ICR_R
	STR R1, [R2]

	BX LR


    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo