project(compress)

set(EXECUTABLE_OUTPUT_PATH /home/ruanjian/workspace/project/generate_project/compress/bin)

add_executable(compress_exe main.cc)
target_link_libraries(compress_exe compress)
