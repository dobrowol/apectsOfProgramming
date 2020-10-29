cmake_minimum_required(VERSION 3.8)
# TEMPORARY
# DO NOT TRY THIS AT HOME!
# Workaround for SDK problem
#include_directories(SYSTEM $ENV{PKG_CONFIG_SYSROOT_DIR}/usr/include/c++/${CMAKE_CXX_COMPILER_VERSION})

# Cmake parameters
option(CCACHE "Use ccache mechanism" ON)

# Options handling
## ccache
find_program(CCACHE_EXE NAMES ccache)
if(CCACHE AND CCACHE_EXE)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_EXE})
    message(STATUS "Use compilation cache: ${CCACHE_EXE}")
endif()

# System info

# Cmake paths
list(APPEND CMAKE_FIND_ROOT_PATH $ENV{PKG_CONFIG_SYSROOT_DIR}/usr)
list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules
    $ENV{PKG_CONFIG_SYSROOT_DIR}/usr/lib/cmake)
## find pkg-config for pkg_search_module due to changed CMAKE_FIND_ROOT_PATH
find_program(PKG_CONFIG_EXECUTABLE NAMES pkg-config DOC "pkg-config executable" NO_CMAKE_FIND_ROOT_PATH)

# General compiler flags
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
if (CXX)
  add_compile_options(-Wall -Werror -pedantic -DHAL_API_VERSION_MADE_ES1="1")
endif()
# General library build dir (needed for tests that links with shared libraries)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)

add_subdirectory(src)
