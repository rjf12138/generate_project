# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.15

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/bin/cmake

# The command to remove a file.
RM = /usr/local/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/ruanjian/workspace/project/generate_project/test

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/ruanjian/workspace/project/generate_project/test/build

# Include any dependencies generated for this target.
include src/CMakeFiles/test.dir/depend.make

# Include the progress variables for this target.
include src/CMakeFiles/test.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/test.dir/flags.make

src/CMakeFiles/test.dir/bit_operation.cc.o: src/CMakeFiles/test.dir/flags.make
src/CMakeFiles/test.dir/bit_operation.cc.o: ../src/bit_operation.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ruanjian/workspace/project/generate_project/test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/CMakeFiles/test.dir/bit_operation.cc.o"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/test.dir/bit_operation.cc.o -c /home/ruanjian/workspace/project/generate_project/test/src/bit_operation.cc

src/CMakeFiles/test.dir/bit_operation.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test.dir/bit_operation.cc.i"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ruanjian/workspace/project/generate_project/test/src/bit_operation.cc > CMakeFiles/test.dir/bit_operation.cc.i

src/CMakeFiles/test.dir/bit_operation.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test.dir/bit_operation.cc.s"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ruanjian/workspace/project/generate_project/test/src/bit_operation.cc -o CMakeFiles/test.dir/bit_operation.cc.s

src/CMakeFiles/test.dir/build_tree.cc.o: src/CMakeFiles/test.dir/flags.make
src/CMakeFiles/test.dir/build_tree.cc.o: ../src/build_tree.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ruanjian/workspace/project/generate_project/test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/CMakeFiles/test.dir/build_tree.cc.o"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/test.dir/build_tree.cc.o -c /home/ruanjian/workspace/project/generate_project/test/src/build_tree.cc

src/CMakeFiles/test.dir/build_tree.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test.dir/build_tree.cc.i"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ruanjian/workspace/project/generate_project/test/src/build_tree.cc > CMakeFiles/test.dir/build_tree.cc.i

src/CMakeFiles/test.dir/build_tree.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test.dir/build_tree.cc.s"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ruanjian/workspace/project/generate_project/test/src/build_tree.cc -o CMakeFiles/test.dir/build_tree.cc.s

src/CMakeFiles/test.dir/compress.cc.o: src/CMakeFiles/test.dir/flags.make
src/CMakeFiles/test.dir/compress.cc.o: ../src/compress.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ruanjian/workspace/project/generate_project/test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object src/CMakeFiles/test.dir/compress.cc.o"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/test.dir/compress.cc.o -c /home/ruanjian/workspace/project/generate_project/test/src/compress.cc

src/CMakeFiles/test.dir/compress.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test.dir/compress.cc.i"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ruanjian/workspace/project/generate_project/test/src/compress.cc > CMakeFiles/test.dir/compress.cc.i

src/CMakeFiles/test.dir/compress.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test.dir/compress.cc.s"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ruanjian/workspace/project/generate_project/test/src/compress.cc -o CMakeFiles/test.dir/compress.cc.s

src/CMakeFiles/test.dir/compress_extract.cc.o: src/CMakeFiles/test.dir/flags.make
src/CMakeFiles/test.dir/compress_extract.cc.o: ../src/compress_extract.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ruanjian/workspace/project/generate_project/test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object src/CMakeFiles/test.dir/compress_extract.cc.o"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/test.dir/compress_extract.cc.o -c /home/ruanjian/workspace/project/generate_project/test/src/compress_extract.cc

src/CMakeFiles/test.dir/compress_extract.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test.dir/compress_extract.cc.i"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ruanjian/workspace/project/generate_project/test/src/compress_extract.cc > CMakeFiles/test.dir/compress_extract.cc.i

src/CMakeFiles/test.dir/compress_extract.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test.dir/compress_extract.cc.s"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ruanjian/workspace/project/generate_project/test/src/compress_extract.cc -o CMakeFiles/test.dir/compress_extract.cc.s

src/CMakeFiles/test.dir/decode.cc.o: src/CMakeFiles/test.dir/flags.make
src/CMakeFiles/test.dir/decode.cc.o: ../src/decode.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ruanjian/workspace/project/generate_project/test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object src/CMakeFiles/test.dir/decode.cc.o"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/test.dir/decode.cc.o -c /home/ruanjian/workspace/project/generate_project/test/src/decode.cc

src/CMakeFiles/test.dir/decode.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test.dir/decode.cc.i"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ruanjian/workspace/project/generate_project/test/src/decode.cc > CMakeFiles/test.dir/decode.cc.i

src/CMakeFiles/test.dir/decode.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test.dir/decode.cc.s"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ruanjian/workspace/project/generate_project/test/src/decode.cc -o CMakeFiles/test.dir/decode.cc.s

src/CMakeFiles/test.dir/encode.cc.o: src/CMakeFiles/test.dir/flags.make
src/CMakeFiles/test.dir/encode.cc.o: ../src/encode.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ruanjian/workspace/project/generate_project/test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object src/CMakeFiles/test.dir/encode.cc.o"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/test.dir/encode.cc.o -c /home/ruanjian/workspace/project/generate_project/test/src/encode.cc

src/CMakeFiles/test.dir/encode.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test.dir/encode.cc.i"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ruanjian/workspace/project/generate_project/test/src/encode.cc > CMakeFiles/test.dir/encode.cc.i

src/CMakeFiles/test.dir/encode.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test.dir/encode.cc.s"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ruanjian/workspace/project/generate_project/test/src/encode.cc -o CMakeFiles/test.dir/encode.cc.s

src/CMakeFiles/test.dir/extract.cc.o: src/CMakeFiles/test.dir/flags.make
src/CMakeFiles/test.dir/extract.cc.o: ../src/extract.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ruanjian/workspace/project/generate_project/test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object src/CMakeFiles/test.dir/extract.cc.o"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/test.dir/extract.cc.o -c /home/ruanjian/workspace/project/generate_project/test/src/extract.cc

src/CMakeFiles/test.dir/extract.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test.dir/extract.cc.i"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ruanjian/workspace/project/generate_project/test/src/extract.cc > CMakeFiles/test.dir/extract.cc.i

src/CMakeFiles/test.dir/extract.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test.dir/extract.cc.s"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ruanjian/workspace/project/generate_project/test/src/extract.cc -o CMakeFiles/test.dir/extract.cc.s

src/CMakeFiles/test.dir/rwfile.cc.o: src/CMakeFiles/test.dir/flags.make
src/CMakeFiles/test.dir/rwfile.cc.o: ../src/rwfile.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ruanjian/workspace/project/generate_project/test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building CXX object src/CMakeFiles/test.dir/rwfile.cc.o"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/test.dir/rwfile.cc.o -c /home/ruanjian/workspace/project/generate_project/test/src/rwfile.cc

src/CMakeFiles/test.dir/rwfile.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test.dir/rwfile.cc.i"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ruanjian/workspace/project/generate_project/test/src/rwfile.cc > CMakeFiles/test.dir/rwfile.cc.i

src/CMakeFiles/test.dir/rwfile.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test.dir/rwfile.cc.s"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ruanjian/workspace/project/generate_project/test/src/rwfile.cc -o CMakeFiles/test.dir/rwfile.cc.s

# Object files for target test
test_OBJECTS = \
"CMakeFiles/test.dir/bit_operation.cc.o" \
"CMakeFiles/test.dir/build_tree.cc.o" \
"CMakeFiles/test.dir/compress.cc.o" \
"CMakeFiles/test.dir/compress_extract.cc.o" \
"CMakeFiles/test.dir/decode.cc.o" \
"CMakeFiles/test.dir/encode.cc.o" \
"CMakeFiles/test.dir/extract.cc.o" \
"CMakeFiles/test.dir/rwfile.cc.o"

# External object files for target test
test_EXTERNAL_OBJECTS =

src/libtest.a: src/CMakeFiles/test.dir/bit_operation.cc.o
src/libtest.a: src/CMakeFiles/test.dir/build_tree.cc.o
src/libtest.a: src/CMakeFiles/test.dir/compress.cc.o
src/libtest.a: src/CMakeFiles/test.dir/compress_extract.cc.o
src/libtest.a: src/CMakeFiles/test.dir/decode.cc.o
src/libtest.a: src/CMakeFiles/test.dir/encode.cc.o
src/libtest.a: src/CMakeFiles/test.dir/extract.cc.o
src/libtest.a: src/CMakeFiles/test.dir/rwfile.cc.o
src/libtest.a: src/CMakeFiles/test.dir/build.make
src/libtest.a: src/CMakeFiles/test.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/ruanjian/workspace/project/generate_project/test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Linking CXX static library libtest.a"
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && $(CMAKE_COMMAND) -P CMakeFiles/test.dir/cmake_clean_target.cmake
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/test.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/test.dir/build: src/libtest.a

.PHONY : src/CMakeFiles/test.dir/build

src/CMakeFiles/test.dir/clean:
	cd /home/ruanjian/workspace/project/generate_project/test/build/src && $(CMAKE_COMMAND) -P CMakeFiles/test.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/test.dir/clean

src/CMakeFiles/test.dir/depend:
	cd /home/ruanjian/workspace/project/generate_project/test/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/ruanjian/workspace/project/generate_project/test /home/ruanjian/workspace/project/generate_project/test/src /home/ruanjian/workspace/project/generate_project/test/build /home/ruanjian/workspace/project/generate_project/test/build/src /home/ruanjian/workspace/project/generate_project/test/build/src/CMakeFiles/test.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/test.dir/depend

