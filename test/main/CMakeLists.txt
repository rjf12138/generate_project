project(test)

set(EXECUTABLE_OUTPUT_PATH /home/ruanjian/workspace/project/generate_project/test/bin)

add_executable(test_Test main.cc)
target_link_libraries(test_Test test)
