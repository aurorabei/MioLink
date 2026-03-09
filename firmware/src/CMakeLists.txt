# Add all subdirectories
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/bmp_platform)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/bmp_port)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/bmp_rtt_swo)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/bmp_tap)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/hw_extras)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/pio_programs)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/target_serial)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/usb)

# Main source library
add_library(src INTERFACE)

target_include_directories(src INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}
)

file(GLOB src_sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/*.c")
target_sources(src INTERFACE
    ${src_sources}
)

target_link_libraries(src INTERFACE
    bmp_platform
    bmp_port
    bmp_rtt_swo
    bmp_tap
    hw_extras
    pio_programs
    target_serial
    usb
)