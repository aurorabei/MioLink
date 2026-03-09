add_library(bmp_port INTERFACE)

target_include_directories(bmp_port INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}
)

file(GLOB bmp_port_sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/*.c")
target_sources(bmp_port INTERFACE
    ${bmp_port_sources}
)