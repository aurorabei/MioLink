add_library(version INTERFACE)

target_include_directories(version INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}
)

file(GLOB version_sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/*.h")
target_sources(version INTERFACE
    ${version_sources}
)