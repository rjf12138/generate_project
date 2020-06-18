project(test)

set(LIBARY_OUTPUT_PATH /home/ruanjian/workspace/project/generate_project/test/lib)
aux_source_directory(. DIR_LIB_SRCS)

add_library (test ${DIR_LIB_SRCS})

