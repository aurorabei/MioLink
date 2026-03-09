# Set pico-sdk path
set(PICO_SDK_PATH ${CMAKE_CURRENT_LIST_DIR}/pico-sdk)

# pico-sdk import
include(${CMAKE_CURRENT_LIST_DIR}/pico-sdk/external/pico_sdk_import.cmake)

# FreeRTOS-Kernel import
set(FREERTOS_KERNEL_PATH ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel)
include(${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/portable/ThirdParty/GCC/RP2040/FreeRTOS_Kernel_import.cmake)

# Generate version variable for FreeRTOS-Kernel
execute_process(COMMAND ${GIT_EXECUTABLE} --git-dir ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/.git describe --tags --always
    OUTPUT_VARIABLE GIT_FREERTOS_REPO_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)

# tinyusb library
set(TINYUSB_OPT_OS OPT_OS_FREERTOS)
set(PICO_TINYUSB_PATH ${CMAKE_CURRENT_LIST_DIR}/tinyusb)

# BlackMagic library
add_library(blackmagic INTERFACE)

# BlackMagic parameters (see blackmagic meson.build and src/target/meson.build)
target_compile_definitions(blackmagic INTERFACE
    GDB_PACKET_BUFFER_SIZE=8192
    PC_HOSTED=0
    NO_LIBOPENCM3=1
    DFU_SERIAL_LENGTH=17
    SYSTICKHZ=100
    ENABLE_RTT=1
    PLATFORM_IDENT_DYNAMIC=1
    # Probe firmware (not BMDA host app)
    CONFIG_BMDA=0
    # 32-bit pointer size for RP2040
    CONFIG_POINTER_SIZE=4
    # All supported debug targets (match blackmagic src/target/meson.build libbmd_target_deps)
    CONFIG_CORTEXAR=1
    CONFIG_CORTEXM=1
    CONFIG_RISCV=1
    CONFIG_RISCV_ACCEL=1
    CONFIG_APOLLO3=1
    CONFIG_AT32=1
    CONFIG_CH32=1
    CONFIG_CH579=1
    CONFIG_EFM32=1
    CONFIG_GD32=1
    CONFIG_HC32=1
    CONFIG_LPC=1
    CONFIG_MM32=1
    CONFIG_NRF=1
    CONFIG_NXP=1
    CONFIG_PUYA=1
    CONFIG_RA=1
    CONFIG_RZ=1
    CONFIG_RP=1
    CONFIG_SAM=1
    CONFIG_STM=1
    CONFIG_TI=1
    CONFIG_TI_ICEPICK=1
    CONFIG_XILINX=1
)

# BlackMagic sources
target_sources(blackmagic INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/command.c
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/exception.c
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/gdb_main.c
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/gdb_packet.c
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/hex_utils.c
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/maths_utils.c
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/morse.c
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/remote.c
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/rtt.c
    ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/timing.c
)

# BlackMagic target sources (exclude adiv5_swd, swdptap_generic)
file(GLOB blackmagic_targets CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/target/*.c")
list(FILTER blackmagic_targets EXCLUDE REGEX ".*adiv5_swd\\.c$")
list(FILTER blackmagic_targets EXCLUDE REGEX ".*swdptap_generic\\.c$")
target_sources(blackmagic INTERFACE ${blackmagic_targets})

# Blackmagic include directories
target_include_directories(blackmagic INTERFACE ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/include)
target_include_directories(blackmagic INTERFACE ${CMAKE_CURRENT_LIST_DIR}/blackmagic/src/target)

# Generate version variable for BlackMagic
execute_process(COMMAND ${GIT_EXECUTABLE} --git-dir ${CMAKE_CURRENT_LIST_DIR}/blackmagic/.git describe --tags --always
    OUTPUT_VARIABLE GIT_BMP_REPO_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
   
# SEGGER RTT libraty
add_library(segger_rtt INTERFACE)

# Segger RTT include directories
target_include_directories(segger_rtt INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}/SEGGER/RTT/RTT
)

# Segger RTT sources
target_sources(segger_rtt INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}/SEGGER/RTT/RTT/SEGGER_RTT.c
    ${CMAKE_CURRENT_LIST_DIR}/SEGGER/RTT/RTT/SEGGER_RTT_printf.c
)

# Link Segger RTT configuration library
target_link_libraries(segger_rtt INTERFACE
    segger_rtt_config
)

# SEGGER SysView library
add_library(segger_sysview INTERFACE)

# Segger SysView include directories
target_include_directories(segger_sysview INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}/SEGGER/SysView/SEGGER
    ${CMAKE_CURRENT_LIST_DIR}/SEGGER/SysView/SYSVIEW
    ${CMAKE_CURRENT_LIST_DIR}/SEGGER/SysView/Sample/FreeRTOSV11
)

# Segger SysView sources
target_sources(segger_sysview INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}/SEGGER/SysView/SYSVIEW/SEGGER_SYSVIEW.c
    ${CMAKE_CURRENT_LIST_DIR}/SEGGER/SysView/Sample/FreeRTOSV11/SEGGER_SYSVIEW_FreeRTOS.c
)

# Link Segger RTT and SysView configuration libraries
target_link_libraries(segger_sysview INTERFACE
    segger_sysview_config
    segger_rtt
)