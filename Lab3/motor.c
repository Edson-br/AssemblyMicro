// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.

#include <stdint.h>

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);

uint32_t numbFromM4x4(void);
void displayPortA(uint32_t state);
void PortN_Output(uint32_t leds);
void enableLCD(void);
void limpaLCD(void);
void controleLCD(void);
void modoLCD(void);
void resetCursorPosition(void);
void escreverDadoLCD(uint32_t data);

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	limpaLCD();
	controleLCD();
	modoLCD();
	resetCursorPosition();
	char test = 'q';
	
	uint32_t inputMx;
	while (1)
	{
    inputMx = numbFromM4x4() + 0x30;
		escreverDadoLCD(test);
	}
}

