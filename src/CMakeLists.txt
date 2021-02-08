cmake_minimum_required(VERSION 3.8)
############## Aspect compiler ##############
# Find and check ACXX compiler
message("Main DUPA")
if(NOT CMAKE_ACXX_COMPILER_WORKS)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../buildsystem/acxx")
    enable_language(ACXX)
    # Determine the ag++ version
    if(CMAKE_REAL_ACXX_COMPILER)
        execute_process(COMMAND ${CMAKE_REAL_ACXX_COMPILER} "--version" 
                        OUTPUT_VARIABLE ACXX_VERSION
                        OUTPUT_STRIP_TRAILING_WHITESPACE)
        string(REGEX REPLACE "^ac\\+\\+ ([0-9.]*) .*" "\\1" ACXX_VERSION "${ACXX_VERSION}")
    else()
        SET(ACXX_VERSION "BLA ${CMAKE_REAL_ACXX_COMPILER}" )
    endif()

    MESSAGE(STATUS "ACXX Version: ${ACXX_VERSION}")
endif()
if(NOT CMAKE_ACXX_COMPILER_WORKS)
  message(FATAL_ERROR "Required working ACXX compiler not found.")
endif()

project(DracoPlatformMade LANGUAGES ACXX CXX C)
#flags for cross-compiler 
message("DUPA $ENV{OECORE_NATIVE_SYSROOTR}/usr/include/")

ADD_DEFINITIONS_ACXX(
-I "$ENV{SDKTARGETSYSROOT}/usr/include/c++/7.3.0"
-I "$ENV{SDKTARGETSYSROOT}/usr/include/"
-I "/var/fpwork/wodobrow/poky/sysroots/x86_64-pokysdk-linux/usr/include/c++/7.3.0/x86_64-pokysdk-linux"
-I $ENV{OECORE_NATIVE_SYSROOT}/usr/lib/x86_64-poky-linux/gcc/x86_64-poky-linux/7.3.0/include/
--c_compiler x86_64-poky-linux-g++
--system-config ${CMAKE_CURRENT_SOURCE_DIR}puma.config
--real-instances
--no_warn_macro
--keep_woven
-k
--no_line
-p${CMAKE_CURRENT_SOURCE_DIR})

# Compile all cpp sources with ACXX
message("Compiling all sources with AXCC")

file(GLOB_RECURSE SRC_CXX_FILES *.cpp)
file(GLOB_RECURSE SRC_AH_FILES *.ah)

set_source_files_properties(${SRC_CXX_FILES} PROPERTIES LANGUAGE ACXX)

# Workaround for ac++. Only take .ah files into consideration which are relevant.
# We use the -a argument for this.
foreach(AH_FILE ${SRC_AH_FILES})
    STRING(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" SMALLFILE "${AH_FILE}")
    ADD_DEFINITIONS_ACXX("-a" "${AH_FILE}")
    message("ah file ${SMALLFILE}")
endforeach()
# Target
add_library(${PROJECT_NAME} SHARED
    foo.cpp
)

set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION "1.0")

# Includes
target_include_directories(${PROJECT_NAME} INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)

# Dependencies

## General dependencies
target_link_libraries(${PROJECT_NAME} PRIVATE
    -Wl,--no-undefined
)

target_link_libraries(${PROJECT_NAME} PUBLIC
    -Wl,--no-undefined
)

