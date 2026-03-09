/*
 * MioLink_Pico (Pico-based MioLink) board pinout and configuration.
 */
#ifndef _BOARDS_MIOLINK_PICO_H
#define _BOARDS_MIOLINK_PICO_H

#include "pinout/miolink_pico_pinout.h"

pico_board_cmake_set(PICO_PLATFORM, rp2040)

/* Board - MioLink_Pico */
#define BOARD_MIOLINK_PICO

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

#endif /* _BOARDS_MIOLINK_PICO_H */
