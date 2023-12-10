#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "tm4c1294ncpdt.h"

#define GPIO_PORTP  (0x2000) //bit 14

void GPIO_Init(void);
void SysTick_Init(void);

void PLL_Init(void);

void	GPIO_InitLED(void);
void	controleLCD(void);
void	modoLCD(void);
void 	UART0_SendChar(char text);
void	UART0_Init(void);
char	UART_ReceiveChar(void);
void 	UART_SendString(const char *str);
void 	UART_SendDec(uint32_t number);

void	PortFunctionInit(void);
void	Interrupt_Init(void);
void 	Timer0A_Init(unsigned long period);
void 	EnableInterrupts(void);
void	DisableInterrupts(void);
void 	limpaLCD(void);

void	initializeALL(void){
	unsigned long period = 960000; 	          /* reload value to Timer0A to generate 60ms delay */
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	GPIO_InitLED();
	controleLCD();
	modoLCD();
	PortFunctionInit();				                /* initialize the GPIO ports */
	UART0_Init();              		           /* initialize UART */
	Interrupt_Init();				                  /* Initialize hardware interrupt on PP0*/
	Timer0A_Init(period);			                /* initialize Timer0A and configure the interrupt */
	EnableInterrupts();        		            /* globally enable interrupt */
	limpaLCD();
}

int main(void){
	initializeALL();
	char received;
	while(1)
	{
		received = UART_ReceiveChar();
		switch(received){
			case 'a':
				DisableInterrupts();
				limpaLCD();
				break;
			case 'b':
				EnableInterrupts();
		}
	}
}




