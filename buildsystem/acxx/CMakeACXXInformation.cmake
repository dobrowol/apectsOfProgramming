# Create a static archive incrementally for large object file counts.
# If CMAKE_ACXX_CREATE_STATIC_LIBRARY is set it will override these.
IF(NOT DEFINED CMAKE_ACXX_ARCHIVE_CREATE)
  SET(CMAKE_ACXX_ARCHIVE_CREATE "<CMAKE_AR> cr <TARGET> <LINK_FLAGS> <OBJECTS>")
ENDIF()
IF(NOT DEFINED CMAKE_ACXX_ARCHIVE_APPEND)
  SET(CMAKE_ACXX_ARCHIVE_APPEND "<CMAKE_AR> r  <TARGET> <LINK_FLAGS> <OBJECTS>")
ENDIF()
IF(NOT DEFINED CMAKE_ACXX_ARCHIVE_FINISH)
  SET(CMAKE_ACXX_ARCHIVE_FINISH "<CMAKE_RANLIB> <TARGET>")
ENDIF()

# compile a Aspect-C++ file into an object file
IF(NOT CMAKE_ACXX_COMPILE_OBJECT)
  SET(CMAKE_ACXX_COMPILE_OBJECT
    "${CMAKE_ACXX_COMPILER} --c_compiler ${CMAKE_CXX_COMPILER} <DEFINES> <FLAGS> -o <OBJECT> -c <SOURCE>")
ENDIF(NOT CMAKE_ACXX_COMPILE_OBJECT)
# 
# IF(NOT CMAKE_CXX_COMPILE_OBJECT)
#   SET(CMAKE_CXX_COMPILE_OBJECT
#     "${CMAKE_ACXX_COMPILER} --c_compiler ${CMAKE_CXX_COMPILER} <DEFINES> <FLAGS> -o <OBJECT> -c <SOURCE>")
# ENDIF(NOT CMAKE_CXX_COMPILE_OBJECT)

IF(NOT CMAKE_ACXX_LINK_EXECUTABLE)
  SET(CMAKE_ACXX_LINK_EXECUTABLE
    "${CMAKE_ACXX_COMPILER} --c_compiler ${CMAKE_CXX_COMPILER}  <FLAGS> <CMAKE_ACXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
ENDIF(NOT CMAKE_ACXX_LINK_EXECUTABLE)

# create a C++ static library
IF(NOT CMAKE_ACXX_CREATE_STATIC_LIBRARY)
  SET(CMAKE_ACXX_CREATE_STATIC_LIBRARY
      "<CMAKE_AR> cr <TARGET> <LINK_FLAGS> <OBJECTS> "
      "<CMAKE_RANLIB> <TARGET> ")
ENDIF(NOT CMAKE_ACXX_CREATE_STATIC_LIBRARY)

SET(CMAKE_ACXX_SOURCE_FILE_EXTENTIONS ${CMAKE_CXX_SOURCE_FILE_EXTENTIONS})
SET(CMAKE_ACXX_OUTPUT_EXTENSION ".o")
SET(CMAKE_ACXX_OUTPUT_EXTENSION_REPLACE 1)

SET(CMAKE_COMPILER_IS_GNUACXX 1)

# Create a set of shared library variable specific to ACXX
# For 90% of the systems, these are the same flags as the C versions
# so if these are not set just copy the flags from the c version
IF(NOT DEFINED CMAKE_ACXX_CREATE_SHARED_LIBRARY)
  set(CMAKE_ACXX_CREATE_SHARED_LIBRARY
      "<CMAKE_ACXX_COMPILER> <CMAKE_SHARED_LIBRARY_ACXX_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_ACXX_FLAGS> <SONAME_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
ENDIF()
      
IF(NOT DEFINED CMAKE_SHARED_LIBRARY_CREATE_ACXX_FLAGS)
  SET(CMAKE_SHARED_LIBRARY_CREATE_ACXX_FLAGS ${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS})
ENDIF()

IF(NOT DEFINED CMAKE_SHARED_LIBRARY_ACXX_FLAGS)
  SET(CMAKE_SHARED_LIBRARY_ACXX_FLAGS ${CMAKE_SHARED_LIBRARY_CXX_FLAGS})
ENDIF()

IF(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_ACXX_FLAGS)
  SET(CMAKE_SHARED_LIBRARY_LINK_ACXX_FLAGS ${CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS})
ENDIF()

IF(NOT DEFINED CMAKE_SHARED_LIBRARY_RUNTIME_ACXX_FLAG)
  SET(CMAKE_SHARED_LIBRARY_RUNTIME_ACXX_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG})
ENDIF()

IF(NOT DEFINED CMAKE_SHARED_LIBRARY_RUNTIME_ACXX_FLAG_SEP)
  SET(CMAKE_SHARED_LIBRARY_RUNTIME_ACXX_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG_SEP})
ENDIF()

IF(NOT DEFINED CMAKE_SHARED_LIBRARY_RPATH_LINK_ACXX_FLAG)
  SET(CMAKE_SHARED_LIBRARY_RPATH_LINK_ACXX_FLAG ${CMAKE_SHARED_LIBRARY_RPATH_LINK_CXX_FLAG})
ENDIF()

IF(NOT DEFINED CMAKE_EXE_EXPORTS_ACXX_FLAG)
  SET(CMAKE_EXE_EXPORTS_ACXX_FLAG ${CMAKE_EXE_EXPORTS_CXX_FLAG})
ENDIF()

IF(NOT DEFINED CMAKE_SHARED_LIBRARY_SONAME_ACXX_FLAG)
  SET(CMAKE_SHARED_LIBRARY_SONAME_ACXX_FLAG ${CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG})
ENDIF()

# repeat for modules
IF(NOT DEFINED CMAKE_SHARED_MODULE_CREATE_ACXX_FLAGS)
  SET(CMAKE_SHARED_MODULE_CREATE_ACXX_FLAGS ${CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS})
ENDIF()

IF(NOT DEFINED CMAKE_SHARED_MODULE_ACXX_FLAGS)
  SET(CMAKE_SHARED_MODULE_ACXX_FLAGS ${CMAKE_SHARED_MODULE_CXX_FLAGS})
ENDIF()

IF(NOT DEFINED CMAKE_EXECUTABLE_RUNTIME_ACXX_FLAG)
  SET(CMAKE_EXECUTABLE_RUNTIME_ACXX_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_ACXX_FLAG})
ENDIF()

IF(NOT DEFINED CMAKE_EXECUTABLE_RUNTIME_ACXX_FLAG_SEP)
  SET(CMAKE_EXECUTABLE_RUNTIME_ACXX_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_ACXX_FLAG_SEP})
ENDIF()

IF(NOT DEFINED CMAKE_EXECUTABLE_RPATH_LINK_ACXX_FLAG)
  SET(CMAKE_EXECUTABLE_RPATH_LINK_ACXX_FLAG ${CMAKE_SHARED_LIBRARY_RPATH_LINK_ACXX_FLAG})
ENDIF()

IF(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_ACXX_WITH_RUNTIME_PATH)
  SET(CMAKE_SHARED_LIBRARY_LINK_ACXX_WITH_RUNTIME_PATH ${CMAKE_SHARED_LIBRARY_LINK_CXX_WITH_RUNTIME_PATH})
ENDIF(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_ACXX_WITH_RUNTIME_PATH)

IF(NOT CMAKE_INCLUDE_FLAG_ACXX)
  SET(CMAKE_INCLUDE_FLAG_ACXX ${CMAKE_INCLUDE_FLAG_C})
ENDIF(NOT CMAKE_INCLUDE_FLAG_ACXX)

IF(NOT CMAKE_INCLUDE_FLAG_SEP_ACXX)
  SET(CMAKE_INCLUDE_FLAG_SEP_ACXX ${CMAKE_INCLUDE_FLAG_SEP_C})
ENDIF(NOT CMAKE_INCLUDE_FLAG_SEP_ACXX)

include(AddFileDependencies)

function(GET_ACXX_VERSION ACXX_VERSION_OUT)
	find_program(CMAKE_REAL_ACXX_COMPILER ac++)
	mark_as_advanced(CMAKE_REAL_ACXX_COMPILER)

	# Determine the ag++ version
	if(CMAKE_REAL_ACXX_COMPILER)
		execute_process(COMMAND ${CMAKE_REAL_ACXX_COMPILER} "--version" 
						OUTPUT_VARIABLE ACXX_VERSION
						OUTPUT_STRIP_TRAILING_WHITESPACE)
		string(REGEX REPLACE "^ac\\+\\+ ([0-9.]*) .*" "\\1" ACXX_VERSION "${ACXX_VERSION}")
		SET(ACXX_VERSION_OUT "DA ${ACXX_VERSION}" PARENT_SCOPE)
	else()
		SET(ACXX_VERSION_OUT "BLA ${CMAKE_REAL_ACXX_COMPILER}" PARENT_SCOPE)
	endif()
endfunction()

function(ACXX_AUTOMATIC_DEPENDENCIES _file)
  get_directory_property(INCLUDES INCLUDE_DIRECTORIES)
  set(FLAGS " -M -p${CMAKE_CURRENT_SOURCE_DIR}")
  foreach(inc ${INCLUDES})
    set(FLAGS "${FLAGS} -I${inc}")
  endforeach(${inc})
  EXEC_PROGRAM(${CMAKE_ACXX_COMPILER}
    ARGS ${FLAGS} ${_file} | grep -v warning
    OUTPUT_VARIABLE DEPS
    RETURN_VALUE RETURN)

  if(${RETURN} EQUAL 0) 
    STRING(REGEX REPLACE "^.*: " "" DEPS ${DEPS})
    STRING(STRIP ${DEPS} DEPS)
    STRING(REGEX REPLACE "\\\\\n " " " DEPS ${DEPS})
    STRING(REGEX REPLACE " " ";" DEPS ${DEPS})
    ADD_FILE_DEPENDENCIES(${_file} ${DEPS})
  endif()
endfunction(${_file})

MACRO(ADD_DEFINITIONS_ACXX)
  foreach(FLAG ${ARGN})
    SET(CMAKE_ACXX_FLAGS "${CMAKE_ACXX_FLAGS} ${FLAG}")
  endforeach(${FLAG})
ENDMACRO(${_defs})

MACRO(ADD_DEFINITIONS_FILE _file)
   GET_SOURCE_FILE_PROPERTY(_defs ${_file} COMPILE_FLAGS)
   IF (_defs)
      SET(_defs ${_defs} ${ARGN})
   ELSE (_defs)
      SET(_defs ${ARGN})
   ENDIF (_defs)
   SET_SOURCE_FILES_PROPERTIES(${_file} PROPERTIES COMPILE_FLAGS "${_defs}")
ENDMACRO(ADD_DEFINITIONS_FILE)


function(ACXX_AUTOMATIC_FLAGS _file)
  EXEC_PROGRAM(sed
    ARGS "-n -e '1,10s/^\\/\\/.*CXXFLAGS_EXTRA=//p' ${_file}"
    OUTPUT_VARIABLE FLAGS
    RETURN_VALUE RETURN)

  if(${RETURN} EQUAL 0) 
    ADD_DEFINITIONS_FILE(${_file} ${FLAGS})
  endif()
endfunction(${_file})