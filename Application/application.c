//
// Created by Artem Godin on 04/04/17.
//
#include <lcd_log.h>
#include "stdio.h"
#include "stm32746g_discovery.h"

void app_init() {
	BSP_LED_Init(LED1);

	/* Initialize the LCD */
	BSP_LCD_Init();

	/* LCD Layer Initialization */
	BSP_LCD_LayerDefaultInit(1, LCD_FB_START_ADDRESS);

	/* Select the LCD Layer */
	BSP_LCD_SelectLayer(1);

	/* Enable the display */
	BSP_LCD_DisplayOn();

	/* Init the LCD Log module */
	LCD_LOG_Init();

	LCD_LOG_SetHeader((uint8_t *) "STM32F746G-DISCO");
	LCD_LOG_SetFooter((uint8_t *) "Example Application");
}

void app_run() {
	LCD_UsrLog("Hi there!\n");
	while (1) {
		BSP_LED_Toggle(LED1);
		HAL_Delay(500);
	}
}
