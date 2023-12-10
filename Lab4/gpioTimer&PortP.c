#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include "tm4c1294ncpdt.h"

#define GPIO_PORTP  (0x2000) //bit 14

void 	SysTick_Wait1us(uint32_t delay);
void 	SysTick_Wait1ms(uint32_t delay);
void 	EnableInterrupts(void);
void 	limpaLCD(void);
void 	escreverDadoLCD(uint32_t data);
void 	UART_SendString(const char *str);
void 	UART_SendDec(uint32_t number);
void	nxline(void);


volatile unsigned int count = 0;							/* no of counts after +edge of echo */

void PortFunctionInit(void){
	volatile uint32_t ui32Loop;   
	/* Enable the clock of the GPIO port P that is used for the on-board LED. */
	SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R13;
	/* Do a dummy read to insert a few cycles after enabling the peripheral. */
	ui32Loop = SYSCTL_RCGCGPIO_R;
	GPIO_PORTP_DIR_R |= 0x02;						      /* make PP 1 as output to sensor trigger pin */
	GPIO_PORTP_DEN_R |= 0x02;						      /* enable data I/O on PP1 */
	GPIO_PORTP_DIR_R &= ~0x01;						    /* make PP 0 as input from sensor echo pin */
	GPIO_PORTP_DEN_R |= 0x01;					      	/* Enable data I/O on PP0 */
	GPIO_PORTP_AMSEL_R &= ~0x0D;   					  /* disable analog function on PP7-0 */
	GPIO_PORTP_PCTL_R = 0x00000000;   				/* configure PP7-0 as GPIO */  
	GPIO_PORTP_AFSEL_R = 0x00;    					  /* regular port function */
	GPIO_PORTP_DEN_R = 0xFF;       					  /* enable digital port */
}

void Interrupt_Init(void){
GPIO_PORTP_IM_R |= 0x01;   		            /* arm interrupt on PP0 */
	GPIO_PORTP_IS_R &= ~0x01;		              /* PP0 is edge-sensitive */
	GPIO_PORTP_IBE_R &= ~0x01;   	            /* PP0 both edges trigger */
	GPIO_PORTP_IEV_R |= 0x01;		              /* PP0 rising edge event */
	NVIC_PRI19_R = 0x20000000; 		            /* configure GPIO PORTP interrupt priority as 0 [4n+1] format for 73 = [4*18 + 1] */
	NVIC_EN2_R = 0x00001000;  		            /* enable interrupt (IRQ number) 73 in NVIC (GPIO PORTP) */
}

void Timer0A_Init(unsigned long period){		/* Timer 0A initialization */
	volatile uint32_t ui32Loop; 
	SYSCTL_RCGCTIMER_R |= SYSCTL_RCGCTIMER_R0;		/* activate timer0 */
	while((SYSCTL_RCGCTIMER_R & (SYSCTL_RCGCTIMER_R0) ) != (SYSCTL_RCGCTIMER_R0) ){};
	TIMER0_CTL_R &= ~0x00000001;     				  /* disable timer0A during setup */
	TIMER0_CFG_R = 0x00000000;       				  /* configure for 32-bit timer mode */
	TIMER0_TAMR_R = 0x00000002;               /* configure for periodic mode, default down-count settings */
	TIMER0_TAILR_R = period-1;          	      /* reload value */
	TIMER0_ICR_R &= ~0x00000001;
	TIMER0_IMR_R |= 0x00000001;               /* arm timeout interrupt */
	TIMER0_CTL_R |= 0x00000001;               /* enable timer0A */
	NVIC_PRI4_R |= 0x20000000; 	 	            /* configure Timer0A interrupt priority as 1 */
	NVIC_EN0_R |= 0x00080000;     	          /* enable interrupt 19 in NVIC (Timer0A) */
}

void Timer0A_Handler(void){				          /* Interrupt handler for Timer0A */
	TIMER0_ICR_R |= 0x00000001; 	            /* acknowledge flag for Timer0A */
	/* ================== Make a pulse ======================*/	
	GPIO_PORTP_DATA_R |=0x02;		
	SysTick_Wait1us(10);				                  /* to create 10us delay between pulses */
	GPIO_PORTP_DATA_R &=~0x02;
}

void str2LCD(char* text)
{
	int count = 0;
	int hex; 
	while(count != strlen(text))
	{
		hex = text[count];
		escreverDadoLCD(hex);
		count += 1;
		if(count == 16)
		{
			nxline();
		}
	}
}

/* Interrupt handler */
void GPIOPortP_Handler(void){	
	GPIO_PORTP_ICR_R |= 0x01;		              /* acknowledge flag for PP0 */
	while((GPIO_PORTP_DATA_R&0x01)!=0){			  /* if port P pin 0 become high */
		count++; 											          /* increment count */
	}
	str2LCD("objeto a aprox:      ");
	escreverDadoLCD((count/2300)%10+48);
	int sec = count/230;
	escreverDadoLCD(sec%10+48);
//	int dsec = count/23;
//	escreverDadoLCD(dsec%10+48);
//	int csec = (count/2.3);
//	escreverDadoLCD(csec%10+48);
//	UART0_ReceiveChar();
	str2LCD(" cm");
	SysTick_Wait1ms(500);
	UART_SendString("count value: ");
	UART_SendDec(count);
	UART_SendString("\n");
	limpaLCD();
	//Aqui vem a parte de oque fazer com a deteccao (no exemplo que tu mando ele acendia e printava via UARt um led na porta N0)
	//No nosso caso tem que printar no LCD
	count = 0; 							                  /* make count 0 */
}