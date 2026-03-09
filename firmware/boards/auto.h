/* Auto board selection (runtime detection). */
#ifndef _BOARDS_AUTO_H
#define _BOARDS_AUTO_H

/* Boards pinouts */
#include "pinout/miolink_rev_a_pinout.h"
#include "pinout/miolink_rev_b_pinout.h"
#include "pinout/miolink_pico_pinout.h"
#include "pinout/pico_pinout.h"
#include "pinout/pico_w_pinout.h"

/* Platform */
pico_board_cmake_set(PICO_PLATFORM, rp2040)
pico_board_cmake_set(PICO_CYW43_SUPPORTED, 1)

/* Board - auto detection */
#define BOARD_AUTO

/* --- Pico vs Pico W detection (ADC) --- */
#define PICO_W_DETECT_CYW43_CS_PIN           (CYW43_DEFAULT_PIN_WL_CS)
#define PICO_W_DETECT_ADC_CHANNEL            (3)
#define PICO_W_DETECT_ADC_THRESHOLD          (0x100)

/* Flash */
#define PICO_BOOT_STAGE2_CHOOSE_W25Q080 1

#ifndef PICO_FLASH_SPI_CLKDIV
#define PICO_FLASH_SPI_CLKDIV 2
#endif

pico_board_cmake_set_default(PICO_FLASH_SIZE_BYTES, (2 * 1024 * 1024))
#ifndef PICO_FLASH_SIZE_BYTES
#define PICO_FLASH_SIZE_BYTES (2 * 1024 * 1024)
#endif

// All boards have B1 RP2040
#ifndef PICO_RP2040_B0_SUPPORTED
#define PICO_RP2040_B0_SUPPORTED 0
#endif

#endif /* _BOARDS_AUTO_H */
