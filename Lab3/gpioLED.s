
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


; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT 	GPIO_InitLED            ; Permite chamar GPIO_Init de outro arquivo
;		EXPORT 	PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT 	LEDsequence
		EXPORT 	displayLeft
		EXPORT 	displayRight
		EXPORT 	actLed
			
		IMPORT	SysTick_Wait1ms

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_InitLED
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
            LDR     R0, =GPIO_PORTB_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da memória
			LDR     R0, =GPIO_PORTA_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da memória
			LDR     R0, =GPIO_PORTQ_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da memória
			LDR     R0, =GPIO_PORTP_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da memória
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTB_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da memória
            LDR     R0, =GPIO_PORTA_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da memória	
            LDR     R0, =GPIO_PORTQ_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da memória
            LDR     R0, =GPIO_PORTP_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da memória			
; 4. DIR para 0 se for entrada, 1 se for saída
            LDR     R0, =GPIO_PORTB_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_00110000					;PB4 & PB5 para TRANSISTOR CONTROLE DISPLAY
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTA_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_11110000					;PA de 4 a 7 para DISPLAY
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTQ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_00001111					;PQ de 0 a 3 para DISPLAY
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTP_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_00100000					;P5 para TRANSISTOR CONTROLE LED
            STR     R1, [R0]						;Guarda no registrador
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
            LDR     R0, =GPIO_PORTB_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta B
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTA_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta A
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTQ_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta Q
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTP_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta P
            STR     R1, [R0]						;Escreve na porta
; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTB_AHB_DEN_R			;Carrega o endereço do DEN
            MOV     R1, #2_00110000                     ;Ativa os pinos PB5 e PB4 como I/O Digital
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
            LDR     R0, =GPIO_PORTA_AHB_DEN_R			;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_11110000						;PA de 4 a 7 para DISPLAY
            STR     R1, [R0]							;Guarda no registrador
            LDR     R0, =GPIO_PORTQ_AHB_DEN_R			;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_00001111						;PQ de 0 a 3 para DISPLAY
            STR     R1, [R0]							;Guarda no registrador
            LDR     R0, =GPIO_PORTP_AHB_DEN_R			;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_00100000						;P5 para TRANSISTOR CONTROLE LED
            STR     R1, [R0]							;Guarda no registrador
 
            
			BX      LR

; Função PortF_Output
; Parâmetro de entrada: R0 --> se os BIT4 e BIT0 estão ligado ou desligado
; Parâmetro de saída: Não tem
LEDsequence
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R3, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R3, [R1]                            ;Escreve na porta A o barramento de dados dos pinos A4 a A7
	LDR	R1, =GPIO_PORTQ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	
	LDR R2, [R1]
	BIC R2, #2_00001111                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta Q o barramento de dados dos pinos Q4 a Q0
	BX LR
	
displayLeft
	LDR	R1, =GPIO_PORTB_AHB_DATA_R
	LDR R2, [R1]
	MOV	R0, #2_00010000
	STR R0, [R1]
	PUSH	{LR}
	MOV 	R0, #5
	BL		SysTick_Wait1ms					;Espera 5ms
	POP		{LR}
	MOV	R0, #2_00000000
	STR R0, [R1]
	BX LR

displayRight
	LDR	R1, =GPIO_PORTB_AHB_DATA_R
	LDR R2, [R1]
	MOV R0, #2_00100000                                        
	STR R0, [R1]
	PUSH	{LR}
	MOV 	R0, #5
	BL		SysTick_Wait1ms					;Espera 5ms
	POP		{LR}
	MOV	R0, #2_00000000
	STR R0, [R1]
	BX LR
	
actLed
	LDR	R1, =GPIO_PORTP_AHB_DATA_R
	LDR R2, [R1]
	MOV R0, #2_00100000                                          
	STR R0, [R1]
	PUSH	{LR}
	MOV 	R0, #5
	BL		SysTick_Wait1ms					;Espera 5ms
	POP		{LR}
	MOV	R0, #2_00000000
	STR R0, [R1]
	
	BX LR									;Retorno


    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo