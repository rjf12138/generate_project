project(test)

aux_source_directory(. DIR_LIB_SRCS)

add_library (test ${DIR_LIB_SRCS})

