#include "TM4C1294NCPDT.h"    
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

void UART0_Init(void) {
    // Enable clock for UART module (UART0 in this case)
    SYSCTL_RCGCUART_R |= SYSCTL_RCGCUART_R0;

    // Enable clock for GPIO Port A
    SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R0;

    // Wait until the UART module is ready
    while ((SYSCTL_PRUART_R & SYSCTL_PRUART_R0) == 0) {}

    // Wait until the GPIO Port A is ready
    while ((SYSCTL_PRGPIO_R & SYSCTL_PRGPIO_R0) == 0) {}

    // Disable UART during configuration
    UART0_CTL_R &= ~UART_CTL_UARTEN;

    // Configure UART pins (TX and RX)
    GPIO_PORTA_AHB_AFSEL_R |= 0x03;  // Enable alternate function for PA0 and PA1 (UART0)
    GPIO_PORTA_AHB_PCTL_R = (GPIO_PORTA_AHB_PCTL_R & 0xFFFFFF00) + 0x11;  // Set PA0 and PA1 as UART pins
    GPIO_PORTA_AHB_DEN_R |= 0x03;  // Enable digital function for PA0 and PA1

    // Set the baud rate (BRD = UART_CLK / (16 * Baud Rate))
    UART0_IBRD_R = 260;  // Integer part of the baud rate
    UART0_FBRD_R = 27;   // Fractional part of the baud rate

    // Configure line control settings (8-bit data, no parity, one stop bit)
    UART0_LCRH_R = (UART_LCRH_WLEN_8 | UART_LCRH_FEN);

    // Configure clock source (using system clock)
    UART0_CC_R = UART_CC_CS_SYSCLK;

    // Enable UART, TX, and RX
    UART0_CTL_R |= (UART_CTL_UARTEN | UART_CTL_TXE | UART_CTL_RXE);
}

void UART0_SendChar(char data) {
    // Wait until the UART is ready for transmission
    while ((UART0_FR_R & UART_FR_TXFF) != 0) {}

    // Send the character
    UART0_DR_R = data;
}

void UART_SendString(const char *str) {
    // Loop through each character in the string
    while (*str != '\0') {
        // Wait until the UART transmitter is ready
        while ((UART0_FR_R & UART_FR_TXFF) != 0) {}

        // Send the character
        UART0_DR_R = *str;

        // Move to the next character in the string
        str++;
    }
}

void UART_SendDec(uint32_t number) {
    char buffer[10];  // Buffer to store the string representation of the number
    int i = 0;

    // Convert the decimal number to a string
    do {
        buffer[i++] = '0' + (number % 10);  // Convert digit to character
        number /= 10;
    } while (number > 0);

    // Send the string in reverse order
    for (i--; i >= 0; i--) {
        // Wait until the UART transmitter is ready
        while ((UART0_FR_R & UART_FR_TXFF) != 0) {}

        // Send the character
        UART0_DR_R = buffer[i];
    }
}



char UART_ReceiveChar(void) {
    // Check if the receive FIFO is not empty
    if ((UART0_FR_R & UART_FR_RXFE) == 0) {
        // Read and return the received character
        return (char)(UART0_DR_R & 0xFF);
    } else {
        // No character received, return null character
        return '\0';
    }
}