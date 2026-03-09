/*
 * Pico / Pico W - overlay (MioLink pinout on Pico platform).
 */
#ifndef _BOARDS_OVERLAY_PICO_OVERLAY_H
#define _BOARDS_OVERLAY_PICO_OVERLAY_H

/* --- LED --- */
#define PICO_LED_ACT_PIN (25)

/* --- JTAG/SWD --- */
#define PICO_TARGET_TCK_PIN (10)
#define PICO_TARGET_TDO_PIN (13)
#define PICO_TARGET_TDI_PIN (12)
#define PICO_TARGET_TMS_PIN (11)

/* --- UART --- */
#define PICO_TARGET_UART_TX_PIN (8)
#define PICO_TARGET_UART_RX_PIN (9)

/* --- Reset --- */
#define PICO_TARGET_NRST_PIN (7)

#endif /* _BOARDS_OVERLAY_PICO_OVERLAY_H */
