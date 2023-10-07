; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL

; -------------------------------------------------------------------------------
; Declarações EQU
;<NOME>         EQU <VALOR>

; -------------------------------------------------------------------------------

		AREA  DATA, ALIGN=2
		
        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
			
		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
									
; --------------------------------------------------------------------------------
; --------------------------------------------------------------------------------
LISTAN 	EQU 0x20000A00 ; onde deve ficar a lista aleatória de números
RAMN		EQU 0x20000B00 ; lista de primos

Start

	LDR		R0, =LISTAN 	; aponta p/ o endereço especificado
	LDR 	R1, =RAMN		; aponta p/ o endereço especificado
	LDR 	R2, =RANDN	 	; aponta p/ o endereço especificado

; --------------------------------------------------------------------------------
;Label p/ colocar a lista a partir do endereço 0x20000A00
; --------------------------------------------------------------------------------

varreStr
	LDRB 	R12, [R2], #1 		;R12 recebe o byte apontado por R2 e logo em seguida R2 += 1
	STRB 	R12, [R0], #1 		;coloca o dado em R12 no endereço apontado por R0 e em seguida R0 += 1
	CMP	 	R12, #0				;verifica se R12 == 0
	BNE		varreStr			;se n é null volta para a label varreStr

	LDR		R3, =LISTAN		;R3 recebe LISTAN

; --------------------------------------------------------------------------------
;Conjunto de labels cuja a função é colocar os números primos da lista a partir do endereço 0x20000B00
; --------------------------------------------------------------------------------

ldToRAM
	LDRB 	R11	, [R3], #1		;R11 recebe o byte apont por R3 e dps R3 += 1
	MOV		R4	, #2			;R4 recebe const 2
	CMP 	R11	, #0			;verifica se R11 == 0
	BEQ		SORT				;c.c vai para label SORT
	
varrePrimo
	CMP 	R4, R11				;verifica se R4 == R11
	BEQ 	PRIMO				;se == vai p/ label PRIMO
	UDIV 	R5, R11, R4			;R5 recebe floor(R10/R3)
	MLS		R6, R4, R5, R11		;R6 recebe R11 - R4*R5
	CMP 	R6, #0				;verifica se R6 == 0
	BEQ 	ldToRAM				; se == vai para a label ldToRAM
	ADD 	R4, #1				;add 1 p/ o valor armazenado no R4
	B		varrePrimo			;volta para o início dela msm
	
PRIMO
	STRB 	R11, [R1], #1		;coloca o dado em R11 no endereço apont por R1 e dps R1 += 1
	B		ldToRAM
	
; --------------------------------------------------------------------------------
;Conjunto de labels que representa o algorítmo bubble-sort adaptado
; --------------------------------------------------------------------------------

SORT
	MOV		R7, #0				;R7(contador) recebe const 0
	LDR		R8, =RAMN			;R8 recebe o endereço armazenado na variável RAMN
	LDR		R9, =RAMN+1			;R9 recebe o msm de R2 mas deslocado uma unidade

bbSort
	LDRB	R10	, [R8]			;R10 recebe byte do endereço apont por R8
	LDRB	R11	, [R9]			;R11 recebe byte do endereço apont por R9
	CMP		R11	, #0			;verificar se R11 == 0
	BEQ		Almst				;se == vai p/ a label Almst (ALMoST ending)
	UDIV	R12	, R11, R10		;R12 recebe floor(R11/R10)
	CMP		R12	, #0			;verifica se R12 == 0
	BEQ		sorting				;se == vai p/ a label sorting
	ADD		R8	, #1			;R8 += 1
	ADD		R9	, #1			;R9 += 1
	B		bbSort				;volta p/ o começo da label bbSort

sorting
	ADD		R7	, #1			;R7 += 1
	STRB	R11	, [R8], #1		;R11 armazena o byte em R8 e dps R8 += 1
	STRB	R10	, [R9], #1		;R10 armazena o byte em R9 e dps R9 += 1
	B	bbSort					;volta p/ a label bbSort

Almst
	CMP		R7, #0				;verifica se R7 == 0
	BNE		SORT				;se != volta para a label SORT
	
; --------------------------------------------------------------------------------
; --------------------------------------------------------------------------------

	NOP							;FIM

; ---------------------------------------------------------------------------------
; Declarando constantes:
RANDN	DCB		150, 199, 3, 11, 137, 17, 152, 158, 132, 109, 113, 127, 101, 103, 254, 6, 8, 10, 37, 41, 128

	ALIGN                           ; garante que o fim da seção está alinhada 
	END                             ; fim do arquivo
