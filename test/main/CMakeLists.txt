project(test)

set(EXECUTABLE_OUTPUT_PATH /home/ruanjian/workspace/project/generate_project/test/bin)

add_executable(main main.cc)
target_link_libraries(main test)
