########################################################
#   在项目的主目录生成主CMakeLists.txt
#   在 src 目录下生成用于生成库的CMakeLists.txt
#   在 main 目录下生成用于生成可执行文件的CMakeLists.txt
########################################################

#!/bin/bash

#########################################################
# 全局变量
TMP_PROJECT_INFO=$HOME/.current_project.tmp
CURRENT_PATH=`pwd`
##########################################################################
#加载项目的配置
project_config=`cat $TMP_PROJECT_INFO | grep project_config | awk -F[=] '{print $2}'`
source $project_config
##########################################################################
cd $PROJ_PROJECT_PATH
touch $PROJ_CMAKE_FILE

# 向主目录下的 CMakeLists.txt 写项目信息
echo "project($PROJ_PROJECT_NAME)" > ./$PROJ_CMAKE_FILE
echo "cmake_minimum_required(VERSION 3.10)" >> ./$PROJ_CMAKE_FILE
echo "include_directories(./inc/)" >> ./$PROJ_CMAKE_FILE

if [ $1 == "release" ];then
    echo "link_directories(./lib/release/)" >> ./$PROJ_CMAKE_FILE
else
    echo "link_directories(./lib/debug/)" >> ./$PROJ_CMAKE_FILE
fi

echo "" >> ./$PROJ_CMAKE_FILE
echo "if(CMAKE_COMPILER_IS_GNUCXX)" >> ./$PROJ_CMAKE_FILE

if [ $1 == "release" ];then
    echo "    add_compile_options(-O2 -Wall -std=c++11)" >> ./$PROJ_CMAKE_FILE
else
    echo "    add_compile_options(-O0 -Wall -g -ggdb -std=c++11)" >> ./$PROJ_CMAKE_FILE
fi

echo "    message(STATUS \"optional:-std=c++11\")" >>  ./$PROJ_CMAKE_FILE 
echo "endif(CMAKE_COMPILER_IS_GNUCXX)" >> ./$PROJ_CMAKE_FILE
echo "" >> ./$PROJ_CMAKE_FILE
echo "add_subdirectory(./main)" >> ./$PROJ_CMAKE_FILE


# 在src目录下创建cmakefile

if [ ! -z `ls $PROJ_PROJECT_PATH/src/ | grep .c`];then
    echo "add_subdirectory(./src)" >> $PROJ_PROJECT_PATH/$PROJ_CMAKE_FILE

    cd $PROJ_PROJECT_PATH/src/
    touch $PROJ_CMAKE_FILE

    echo "project($PROJ_PROJECT_NAME)" > $PROJ_CMAKE_FILE
    echo "" >> $PROJ_CMAKE_FILE

    if [ $1 == "release" ];then
        echo "set(LIBRARY_OUTPUT_PATH $PROJ_LIB_OUTPUT_DIR/release/lib)" >> $PROJ_CMAKE_FILE
    else
        echo "set(LIBRARY_OUTPUT_PATH $PROJ_LIB_OUTPUT_DIR/debug/lib)" >> $PROJ_CMAKE_FILE
    fi
    echo "aux_source_directory(. DIR_LIB_SRCS)" >> $PROJ_CMAKE_FILE
    echo "" >> $PROJ_CMAKE_FILE
    echo "add_library ($PROJ_PROJECT_NAME \${DIR_LIB_SRCS})" >> $PROJ_CMAKE_FILE
    echo "" >> $PROJ_CMAKE_FILE

    link_lib=`ls`
    if [ $1 == "release" ];then
        link_lib=`ls ../lib/release/`
    else
        link_lib=`ls ../lib/debug/`
    fi

    for static_lib_file in `echo $link_lib`
    do
        static_lib=`echo $static_lib_file | grep ^lib | grep .a | sed 's/^lib//' | sed 's/\.a$//'`
        if [ -z $static_lib ];then
            continue
        fi
        echo "target_link_libraries($PROJ_PROJECT_NAME -l$static_lib)" >> $PROJ_CMAKE_FILE
    done

    # 系统库，如pthread，在.proj_config/proj_config.sh配置 PROJ_LIB_LINK_LIST 中修改
    for extern_lib in `echo $PROJ_LIB_LINK_LIST`
    do
        echo "target_link_libraries($PROJ_PROJECT_NAME -l$extern_lib)" >> $PROJ_CMAKE_FILE
    done
fi
# 在main目录下创建cmakefile
cd $PROJ_PROJECT_PATH/main/
touch $PROJ_CMAKE_FILE

echo "project($PROJ_PROJECT_NAME)" > $PROJ_CMAKE_FILE
echo "" >> $PROJ_CMAKE_FILE

if [ $1 == "release" ];then
    echo "set(EXECUTABLE_OUTPUT_PATH $PROJ_BIN_OUTPUT_DIR/release/bin)" >> $PROJ_CMAKE_FILE
else
    echo "set(EXECUTABLE_OUTPUT_PATH $PROJ_BIN_OUTPUT_DIR/debug/bin)" >> $PROJ_CMAKE_FILE
fi

echo "" >> $PROJ_CMAKE_FILE

# 匹配满足 .cc 和 .cpp 后缀的文件
for src_file in `ls | grep -E ".cc|.cpp|.c"`
do
    bin_name=`echo $src_file | sed 's/\.cc$//' | sed 's/\.cpp$//' | sed 's/\.c$//'`
    echo "add_executable($bin_name $src_file)" >> $PROJ_CMAKE_FILE

    if [ $1 == "release" ];then
        if [ -f "$PROJ_LIB_OUTPUT_DIR/release/lib/lib$PROJ_PROJECT_NAME.a" ];then
            echo "target_link_libraries($bin_name $PROJ_PROJECT_NAME)" >> $PROJ_CMAKE_FILE
        fi
    else
        if [ -f "$PROJ_LIB_OUTPUT_DIR/debug/lib/lib$PROJ_PROJECT_NAME.a" ];then
            echo "target_link_libraries($bin_name $PROJ_PROJECT_NAME)" >> $PROJ_CMAKE_FILE
        fi
    fi
    
    echo "" >> $PROJ_CMAKE_FILE
done

exit 0