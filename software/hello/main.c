// The Potato Processor Benchmark Applications
// (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
// Report bugs and issues on <https://github.com/skordal/potato/issues>

#include <stdint.h>

//#include "platform.h"

#define PLATFORM_UART0_BASE 0xc0002000
#define PLATFORM_SYSCLK_FREQ 32000000
#define PLATFORM_GPIO_BASE 0xc0004000

#include "uart.h"
#include "gpio.h"

void exception_handler(uint32_t cause, void * epc, void * regbase)
{
	// Not used in this application
}

static struct uart uart0;
static struct gpio gpio0;


int main(void)
{
	const char * hello_string = "Hello world\n\r";
        
        gpio_initialize(&gpio0,(volatile void *)PLATFORM_GPIO_BASE);
        gpio_set_direction(&gpio0,0b11110000);
        gpio_set_output(&gpio0,0b10010000);  // Display 1001 at the LEDs

	uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(9600, PLATFORM_SYSCLK_FREQ));

        do {
	  for(int i = 0; hello_string[i] != 0; ++i)
	  {
		while(uart_tx_fifo_full(&uart0));
		uart_tx(&uart0, hello_string[i]);
	  }
        }while(true);

	return 0;
}

