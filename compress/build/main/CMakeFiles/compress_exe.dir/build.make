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
CMAKE_SOURCE_DIR = /home/ruanjian/workspace/project/generate_project/compress

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/ruanjian/workspace/project/generate_project/compress/build

# Include any dependencies generated for this target.
include main/CMakeFiles/compress_exe.dir/depend.make

# Include the progress variables for this target.
include main/CMakeFiles/compress_exe.dir/progress.make

# Include the compile flags for this target's objects.
include main/CMakeFiles/compress_exe.dir/flags.make

main/CMakeFiles/compress_exe.dir/main.cc.o: main/CMakeFiles/compress_exe.dir/flags.make
main/CMakeFiles/compress_exe.dir/main.cc.o: ../main/main.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ruanjian/workspace/project/generate_project/compress/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object main/CMakeFiles/compress_exe.dir/main.cc.o"
	cd /home/ruanjian/workspace/project/generate_project/compress/build/main && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/compress_exe.dir/main.cc.o -c /home/ruanjian/workspace/project/generate_project/compress/main/main.cc

main/CMakeFiles/compress_exe.dir/main.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/compress_exe.dir/main.cc.i"
	cd /home/ruanjian/workspace/project/generate_project/compress/build/main && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/ruanjian/workspace/project/generate_project/compress/main/main.cc > CMakeFiles/compress_exe.dir/main.cc.i

main/CMakeFiles/compress_exe.dir/main.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/compress_exe.dir/main.cc.s"
	cd /home/ruanjian/workspace/project/generate_project/compress/build/main && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/ruanjian/workspace/project/generate_project/compress/main/main.cc -o CMakeFiles/compress_exe.dir/main.cc.s

# Object files for target compress_exe
compress_exe_OBJECTS = \
"CMakeFiles/compress_exe.dir/main.cc.o"

# External object files for target compress_exe
compress_exe_EXTERNAL_OBJECTS =

../bin/compress_exe: main/CMakeFiles/compress_exe.dir/main.cc.o
../bin/compress_exe: main/CMakeFiles/compress_exe.dir/build.make
../bin/compress_exe: src/libcompress.a
../bin/compress_exe: main/CMakeFiles/compress_exe.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/ruanjian/workspace/project/generate_project/compress/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../bin/compress_exe"
	cd /home/ruanjian/workspace/project/generate_project/compress/build/main && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/compress_exe.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
main/CMakeFiles/compress_exe.dir/build: ../bin/compress_exe

.PHONY : main/CMakeFiles/compress_exe.dir/build

main/CMakeFiles/compress_exe.dir/clean:
	cd /home/ruanjian/workspace/project/generate_project/compress/build/main && $(CMAKE_COMMAND) -P CMakeFiles/compress_exe.dir/cmake_clean.cmake
.PHONY : main/CMakeFiles/compress_exe.dir/clean

main/CMakeFiles/compress_exe.dir/depend:
	cd /home/ruanjian/workspace/project/generate_project/compress/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/ruanjian/workspace/project/generate_project/compress /home/ruanjian/workspace/project/generate_project/compress/main /home/ruanjian/workspace/project/generate_project/compress/build /home/ruanjian/workspace/project/generate_project/compress/build/main /home/ruanjian/workspace/project/generate_project/compress/build/main/CMakeFiles/compress_exe.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : main/CMakeFiles/compress_exe.dir/depend
