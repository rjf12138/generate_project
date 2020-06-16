########################################################
#   在项目的主目录生成主CMakeLists.txt
#   在 src 目录下生成用于生成库的CMakeLists.txt
#   在 main 目录下生成用于生成可执行文件的CMakeLists.txt
########################################################

#!/bin/bash
# 加载项目自身配置
cd $PROJ_PROJECT_PATH
touch $PROJ_CMAKE_FILE

# 向主目录下的 CMakeLists.txt 写项目信息
echo "project($PROJ_PROJECT_NAME)" > ./$PROJ_CMAKE_FILE
echo "cmake_minimum_required(VERSION 3.10)" >> ./$PROJ_CMAKE_FILE
echo "include_directories(./inc/)" >> ./$PROJ_CMAKE_FILE
echo "include_directories(\${PROJECT_BINARY_DIR}/../local/include)" >> ./$PROJ_CMAKE_FILE
echo "link_directories(\${PROJECT_BINARY_DIR}/../local/lib)" >> ./$PROJ_CMAKE_FILE
echo "" >> ./$PROJ_CMAKE_FILE
echo "if(CMAKE_COMPILER_IS_GNUCXX)" >> ./$PROJ_CMAKE_FILE
echo "    add_compile_options(-std=c++11)" >> ./$PROJ_CMAKE_FILE
echo "    message(STATUS \"optional:-std=c++11\")" >>  ./$PROJ_CMAKE_FILE 
echo "endif(CMAKE_COMPILER_IS_GNUCXX)" >> ./$PROJ_CMAKE_FILE
echo "" >> ./$PROJ_CMAKE_FILE
echo "add_subdirectory(./src)" >> ./$PROJ_CMAKE_FILE
echo "add_subdirectory(./main)" >> ./$PROJ_CMAKE_FILE

# 在src目录下创建cmakefile
cd $PROJ_PROJECT_PATH/src/
touch $PROJ_CMAKE_FILE

echo "project($PROJ_PROJECT_NAME)" > $PROJ_CMAKE_FILE
echo "" >> $PROJ_CMAKE_FILE
echo "aux_source_directory(. DIR_LIB_SRCS)" >> $PROJ_CMAKE_FILE
echo "" >> $PROJ_CMAKE_FILE
echo "add_library ($PROJ_PROJECT_NAME \${DIR_LIB_SRCS})" >> $PROJ_CMAKE_FILE
echo "" >> $PROJ_CMAKE_FILE

for static_lib in `ls ../lib/ | grep -E ".a"`
do
    echo "target_link_libraries($PROJ_PROJECT_NAME -l$static_lib)" >> $PROJ_CMAKE_FILE
done

for extern_lib in `echo $PROJ_LIB_LINK_LIST`
do
    echo "target_link_libraries($PROJ_PROJECT_NAME -l$extern_lib)" >> $PROJ_CMAKE_FILE
done

# 在main目录下创建cmakefile
cd $PROJ_PROJECT_PATH/main/
touch $PROJ_CMAKE_FILE

echo "project($PROJ_PROJECT_NAME)" > $PROJ_CMAKE_FILE
echo "" >> $PROJ_CMAKE_FILE
echo "set(EXECUTABLE_OUTPUT_PATH $PROJ_BIN_OUTPUT_DIR)" >> $PROJ_CMAKE_FILE
echo "" >> $PROJ_CMAKE_FILE

# 匹配满足 .cc 和 .cpp 后缀的文件
for src_file in `ls | grep -E ".cc|.cpp|.c"`
do
    echo "add_executable(${PROJ_EXEC_NAME}_Test $src_file)" >> $PROJ_CMAKE_FILE
done

echo "target_link_libraries(${PROJ_EXEC_NAME}_Test $PROJ_PROJECT_NAME)" >> $PROJ_CMAKE_FILE

exit 0