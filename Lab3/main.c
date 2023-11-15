// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.

#include <stdint.h>

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);
void Pisca_leds(void);

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	while (1)
	{
    //Se a USR_SW2 estiver pressionada
		if (PortJ_Input() == 0x1)
			PortN_Output(0x1);
    //Se a USR_SW1 estiver pressionada
		else if (PortJ_Input() == 0x2)
			PortN_Output(0x2);
    //Se ambas estiverem pressionadas
		else if (PortJ_Input() == 0x0)
			Pisca_leds();
    //Se nenhuma estiver pressionada
		else if (PortJ_Input() == 0x3)
			PortN_Output(0x0);        
	}
}

void Pisca_leds(void)
{
	PortN_Output(0x2);
	SysTick_Wait1ms(250);
	PortN_Output(0x1);
	SysTick_Wait1ms(250);
}
