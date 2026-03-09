/*
 * MioLink board common configuration.
 */
#ifndef _BOARDS_MIOLINK_H
#define _BOARDS_MIOLINK_H

#include "pinout/miolink_rev_a_pinout.h"
#include "pinout/miolink_rev_b_pinout.h"

pico_board_cmake_set(PICO_PLATFORM, rp2040)

/* Board - MioLink */
#define BOARD_MIOLINK

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

#endif /* _BOARDS_MIOLINK_H */
