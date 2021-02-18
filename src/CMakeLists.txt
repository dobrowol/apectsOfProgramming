cmake_minimum_required(VERSION 3.8)
############## Aspect compiler ##############
# Find and check ACXX compiler
include(FetchContent)
 
set(BUILD_BOOST_ASIO ON CACHE BOOL "with asio") # pick options you need
FetchContent_Declare(
    rotor
    GIT_REPOSITORY https://github.com/basiliscos/cpp-rotor.git
    GIT_TAG v0.13
)
FetchContent_MakeAvailable(rotor)
 



set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)
#set(CMAKE_CXX_EXTENSIONS OFF)
#set(CMAKE_POSITION_INDEPENDENT_CODE ON)
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
#if(NOT CMAKE_ACXX_COMPILER_WORKS)
#  message(FATAL_ERROR "Required working ACXX compiler not found.")
#endif()

project(DracoPlatformMade LANGUAGES CXX C)
#flags for cross-compiler 
message("DUPA $ENV{OECORE_NATIVE_SYSROOTR}/usr/include/")

ADD_DEFINITIONS_ACXX(
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
    ADD_DEFINITIONS_ACXX("-a" "${AH_FILE}"
    -I "${rotor_SOURCE_DIR}/include")
    message("ah file ${SMALLFILE}")
endforeach()
# Target
add_executable(${PROJECT_NAME} 
    foo.cpp
)

set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION "1.0")

# Includes
target_include_directories(${PROJECT_NAME} INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)
target_include_directories(${PROJECT_NAME} PUBLIC ${rotor_SOURCE_DIR}/include)

# Dependencies

## General dependencies
target_link_libraries(${PROJECT_NAME} PRIVATE
    -Wl,--no-undefined
    rotor::asio
)

target_link_libraries(${PROJECT_NAME} PUBLIC
    -Wl,--no-undefined
    rotor::asio
)

