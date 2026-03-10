cmake_minimum_required(VERSION 3.15)

# Save build type in uppercase for easier comparison
string(TOUPPER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)

# Use Pico SDK board selection; our board headers in boards/ are searched first (SDK appends its path).
set(PICO_BOARD_HEADER_DIRS ${CMAKE_CURRENT_LIST_DIR}/boards)

# Default board when not set (override with -DPICO_BOARD=pico etc.)
set(PICO_BOARD "auto" CACHE STRING "Pico SDK target board (e.g. miolink, pico, weact_studio_rp2040_2mb)")

# Set deoptimized debug mode for debug builds
if(BUILD_TYPE STREQUAL DEBUG)
    set(PICO_DEOPTIMIZED_DEBUG 1)
else()
    set(PICO_DEOPTIMIZED_DEBUG 0)
endif()

# Find Git before external.cmake so submodule version detection (execute_process) can use it.
find_package(Git QUIET)

# Import external libraries
include(${CMAKE_CURRENT_LIST_DIR}/external/external.cmake)

# Project definition
project(MioLink C CXX ASM)

# Set C and C++ standards
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Include configuration
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/config)

# Include boards header
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/boards)

# Initialize Pico SDK (must be after project)
pico_sdk_init()

# Add executable target
add_executable(MioLink)

# Disable Pico SDK's UART output
pico_enable_stdio_uart(MioLink 0)

# Disable Pico SDK's default printf implementation
pico_set_printf_implementation(MioLink "compiler")

# Specify number of active MCU cores
set(CONFIG_NUMBER_OF_CORES 2)

target_compile_definitions(MioLink PRIVATE
        PICO_STDIO_SHORT_CIRCUIT_CLIB_FUNCS=0
        CONFIG_NUMBER_OF_CORES=${CONFIG_NUMBER_OF_CORES}
)

# MioLink include directories
target_include_directories(MioLink PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
)

# Define parameter for CYW43 support if supported by the board
if(PICO_CYW43_SUPPORTED)
    target_compile_definitions(MioLink PRIVATE
        PICO_CYW43_SUPPORTED=1
        CYW43_LWIP=0
        CYW43_TASK_PRIORITY=1
        CYW43_TASK_STACK_SIZE=256
    )
endif()

# Create version header from git tag
execute_process(COMMAND ${GIT_EXECUTABLE} --git-dir ${CMAKE_CURRENT_LIST_DIR}/../.git describe --tags --always
        OUTPUT_VARIABLE GIT_MIOLINK_REPO_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
configure_file("${CMAKE_CURRENT_LIST_DIR}/git_version/git_version.h.in" "git_version.h")

# Include source library
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/src)

# Link boards library
target_link_libraries(MioLink PRIVATE
    boards
)

# Link source library
target_link_libraries(MioLink PRIVATE
    src
)

# Link Pico SDK hardware libraries
target_link_libraries(MioLink PRIVATE 
    hardware_pio
    hardware_uart
    hardware_dma
    hardware_timer
    hardware_adc
)

# Link Pico SDK middleware libraries
target_link_libraries(MioLink PRIVATE
    pico_stdlib
    pico_unique_id
    pico_bootrom
)

# Link tinyusb libraries
target_link_libraries(MioLink PRIVATE
    tinyusb_config
    tinyusb_device
    tinyusb_board
    tinyusb_additions
)

# Link FreeRTOS libraries
target_link_libraries(MioLink PRIVATE
    freertos_config
    FreeRTOS-Kernel
    FreeRTOS-Kernel-Heap4
)

# Link CYW43 Wi-Fi libraries if supported
if(PICO_CYW43_SUPPORTED)
    target_link_libraries(MioLink PRIVATE
        pico_cyw43_arch_sys_freertos
    )
endif()

# Link BlackMagic library
target_link_libraries(MioLink PRIVATE
    blackmagic
)

# Define debug parameter for MioLink
if(BUILD_TYPE STREQUAL DEBUG)
# Enable RTT trace if debug is enabled
    target_compile_definitions(MioLink PRIVATE
        ENABLE_DEBUG=1
    )

    target_link_libraries(MioLink PRIVATE
        segger_rtt
    )

# Enable SystemView trace if only one core is used and debug is enabled
    if(CONFIG_NUMBER_OF_CORES EQUAL 1)
        target_compile_definitions(MioLink PRIVATE
            ENABLE_SYSVIEW_TRACE=1
        )

        target_link_libraries(MioLink PRIVATE
            segger_sysview
        )
    endif()
else()
    target_compile_definitions(MioLink PRIVATE
        ENABLE_DEBUG=0
        ENABLE_SYSVIEW_TRACE=0
    )
endif()

# Generate linker script
set(PICO_FLASH_SIZE_BYTES_STRING "${PICO_FLASH_SIZE_BYTES}")
configure_file(${CMAKE_CURRENT_LIST_DIR}/linker/memmap_release.ld.in ${CMAKE_CURRENT_BINARY_DIR}/memmap_release.ld)
configure_file(${CMAKE_CURRENT_LIST_DIR}/linker/memmap_debug.ld.in ${CMAKE_CURRENT_BINARY_DIR}/memmap_debug.ld)

# Set linker script and set parameter to print memory usage
if(BUILD_TYPE STREQUAL DEBUG)
    pico_set_linker_script(MioLink ${CMAKE_CURRENT_BINARY_DIR}/memmap_debug.ld)
else()
    pico_set_linker_script(MioLink ${CMAKE_CURRENT_BINARY_DIR}/memmap_release.ld)
endif()

# Print memory usage after linking
target_link_options(MioLink PRIVATE -Xlinker --print-memory-usage)

# Add MioLink output
pico_add_extra_outputs(MioLink)
