/*
* Pico W - overlay (MioLink pinout on Pico W platform).
*/
#ifndef _BOARDS_OVERLAY_PICO_W_OVERLAY_H
#define _BOARDS_OVERLAY_PICO_W_OVERLAY_H

/* --- JTAG/SWD --- */
#define PICO_W_TARGET_TCK_PIN (10)
#define PICO_W_TARGET_TDO_PIN (13)
#define PICO_W_TARGET_TDI_PIN (12)
#define PICO_W_TARGET_TMS_PIN (11)

/* --- UART --- */
#define PICO_W_TARGET_UART_TX_PIN (8)
#define PICO_W_TARGET_UART_RX_PIN (9)

/* --- Reset --- */
#define PICO_W_TARGET_NRST_PIN (7)

/* Pico W CYW43 configuration */
#define CYW43_PIN_WL_DYNAMIC           0

#define CYW43_DEFAULT_PIN_WL_REG_ON    23
#define CYW43_DEFAULT_PIN_WL_DATA_OUT  24
#define CYW43_DEFAULT_PIN_WL_DATA_IN   24
#define CYW43_DEFAULT_PIN_WL_HOST_WAKE 24
#define CYW43_DEFAULT_PIN_WL_CLOCK     29
#define CYW43_DEFAULT_PIN_WL_CS        25
#define CYW43_PIN_WL_HOST_WAKE         24
#define CYW43_PIN_WL_REG_ON            23
#define CYW43_WL_GPIO_COUNT            3
#define CYW43_WL_GPIO_LED_PIN          0

#endif /* _BOARDS_OVERLAY_PICO_W_OVERLAY_H */