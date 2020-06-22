project(compress)

set(LIBARY_OUTPUT_PATH /home/ruanjian/workspace/project/generate_project/compress/lib/release/lib)
aux_source_directory(. DIR_LIB_SRCS)

add_library (compress ${DIR_LIB_SRCS})

