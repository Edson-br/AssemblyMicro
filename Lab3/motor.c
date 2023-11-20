// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Faz o giro de um motor de passo definindo o numero de voltas, o sentido da rotacao e o passo
// atravez de um teclado matricial 4x4 e atualizando o usuario do estado do motor por um display LCD

#include <stdint.h>
#include <stdio.h>
#include <string.h>

//declaracao das funcoes implementadas em assembly
void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
void GPIO_InitLED(void);

uint32_t inputNumb(void);
void displayPortA(uint32_t state);
void PortN_Output(uint32_t leds);
void enableLCD(void);
void limpaLCD(void);
void controleLCD(void);
void modoLCD(void);
void resetCursorPosition(void);
void nxline(void);
void escreverDadoLCD(uint32_t data);
void motorPasso(uint32_t velo);

void GPIOPortJ_Handler(void);
void goToMenu(void);

//variaveis locais
int voltas;
int rotacao;
int velocidade;
int potencia10;
int inputMx;

//funcao que percorre uma string imprimindo-a no display LCD
//Entrada: string a ser impressa
//Saida:
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

//funcoes de inicializacao (parametros de execucao)
//Entrada: valores de voltas, direcao de rotacao, e passo respectivamente
//Saida:
void cleanVoltas(void)
{
		limpaLCD();
		voltas = 0;
		potencia10 = 0;
		str2LCD("insert the n. oflaps bt 01&10:");
}

void cleanRotacao(void)
{
		limpaLCD();
		rotacao = 1;
		str2LCD("Clk or AntiClk? (0/1): ");
}

void cleanVelo(void)
{
		limpaLCD();
		velocidade = 1;
		str2LCD("Full or Half ST?(0/1): ");
}

void pressbutton()
{
	limpaLCD();
	inputMx = 0;
	
	str2LCD("PRESS (*) TO    START");
	while (1)
	{
		inputMx = inputNumb();
		if(inputMx == 14){
		goToMenu();
		}
		SysTick_Wait1ms(50);		
	}
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	GPIO_InitLED();
	controleLCD();
	modoLCD();
	resetCursorPosition();
	
	pressbutton();

}

void mainMenu(void)
{
	inputMx = 0;
	cleanVoltas();
	while(inputMx != 58 | voltas > 10)		//press "A" to confirm
	{
		inputMx = inputNumb();
		if(inputMx < 10 & potencia10 < 2){
			switch (potencia10){
				case 1:
					voltas += inputMx;
					potencia10 += 2;	
					break;
				case 0:
					voltas = 10*inputMx;
					potencia10 += 1;
			}
			inputMx += 0x30;
			escreverDadoLCD(inputMx);
		}else if(inputMx > 10){
			cleanVoltas();
		}
		inputMx += 0x30;
		if(voltas > 10){
			cleanVoltas();
		}
	}
	
	inputMx = 0;
	cleanRotacao();
	do
	{
		inputMx = inputNumb();
		if((inputMx < 2) & (rotacao != 0) & (rotacao != 8)){ //Seleciona o tipo de rotacao no matricial
			switch (inputMx){
				case 1:
					rotacao = 8;
					break;
				case 0:
					rotacao = 0;
			}
			inputMx += 0x30;
			escreverDadoLCD(inputMx);
		}else if((inputMx > 1 & inputMx != 10)){
			cleanRotacao();
		}
		inputMx += 0x30;
	}	while((inputMx != 58) | (rotacao != 0 & rotacao != 8));		//press "A" to confirm
	
	
	inputMx = 0;
	cleanVelo();
	do
	{
		inputMx = inputNumb();
		if((inputMx < 2) & (velocidade != 16) & (velocidade != 0)){ //Seleciona a velocidade (passo completo/meio passo) no matricial
			switch (inputMx){
				case 1:
					velocidade = 16;
					break;
				case 0:
					velocidade = 0;
			}
			inputMx += 0x30;
			escreverDadoLCD(inputMx);
		}else if((inputMx > 1 & inputMx != 10)){
			cleanVelo();
		}
		inputMx += 0x30;
	}while((inputMx != 58) | (velocidade != 16 & velocidade != 0));	//press "A" to confirm
	
	int	whichMode;
	whichMode = rotacao + velocidade;
	
	limpaLCD();
	if(rotacao != 8){
		str2LCD("Clockwise ");
	}else{
		str2LCD("Counterclockwise ");
	}
	nxline();
	if(velocidade != 16){
		str2LCD("Full-step ");
	}else{
		str2LCD("Half-step ");
	}
	
	while(voltas > 0) //giro do motor decrementando as voltas
	{
		
		if(voltas != 10){
			escreverDadoLCD(0 + 0x30);
			escreverDadoLCD(voltas + 0x30);
		}else{
			escreverDadoLCD(1 + 0x30);
			escreverDadoLCD(0 + 0x30);
		}
		str2LCD(" lft");
		motorPasso(whichMode);
		voltas -= 1;
	}
	pressbutton();
}


