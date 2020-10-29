# Search for the ag++ executable
SET(CMAKE_ACXX_COMPILER_ENV_VAR "ACXX")
file (COPY ${CMAKE_CURRENT_LIST_DIR}/../aspectc++/ag++ DESTINATION ${CMAKE_BINARY_DIR} FILE_PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
file (COPY ${CMAKE_CURRENT_LIST_DIR}/../aspectc++/ac++ DESTINATION ${CMAKE_BINARY_DIR} FILE_PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)

SET(CMAKE_ACXX_COMPILER "${CMAKE_BINARY_DIR}/ag++")
SET(CMAKE_REAL_ACXX_COMPILER "${CMAKE_BINARY_DIR}/ac++")
mark_as_advanced(CMAKE_ACXX_COMPILER)
mark_as_advanced(CMAKE_REAL_ACXX_COMPILER)

# Determine the ag++ version
if(CMAKE_REAL_ACXX_COMPILER)
    execute_process(COMMAND ${CMAKE_REAL_ACXX_COMPILER} "--version" 
                    OUTPUT_VARIABLE ACXX_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REGEX REPLACE "^ac\\+\\+ ([0-9.]*) .*" "\\1" ACXX_VERSION "${ACXX_VERSION}")
endif(CMAKE_REAL_ACXX_COMPILER)

# configure variables set in this file for fast reload later on
SET(OUTPUTFILE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeACXXCompiler.cmake")
if(NOT(EXISTS(${OUTPUTFILE})))
    CONFIGURE_FILE(${CMAKE_CURRENT_LIST_DIR}/CMakeACXXCompiler.cmake.in ${OUTPUTFILE} @ONLY IMMEDIATE)
  message(STATUS "ACXX Compiler: ${CMAKE_ACXX_COMPILER} ${ACXX_VERSION}")
endif()
# newer cmake version search in CMAKE_VERSION subfolder.
# configure variables set in this file for fast reload later on
SET(OUTPUTFILE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${CMAKE_VERSION}/CMakeACXXCompiler.cmake")
if(NOT(EXISTS(${OUTPUTFILE})))
  CONFIGURE_FILE(${CMAKE_CURRENT_LIST_DIR}/CMakeACXXCompiler.cmake.in ${OUTPUTFILE} @ONLY IMMEDIATE)
endif()
# Handle the QUIETLY and REQUIRED arguments, which may be given to the find call.
# Furthermore set ACXX_FOUND to TRUE if ag++ has been found (aka.
# CMAKE_ACXX_COMPILER is set)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ACXX DEFAULT_MESSAGE
  CMAKE_ACXX_COMPILER ACXX_VERSION)