#!/bin/bash

################################################################
# 全局变量
TMP_PROJECT_INFO=/tmp/current_project.tmp

################################################################
#基础的工具函数
function help_info() 
{
    echo "Usage: $0 [OPTIONS] [param1 param2 ...]"
    echo "-h                    --print help info."
    echo "-l                    --load project."
    echo "-cr                   --clean and rebuild project."
    echo "-r                    --rebuild without cleanning."
    echo "-c                    --clean all."
    echo "-e                    --enter project exec file dir."
    echo "-w                    --open new gnome_terminal."
    echo "-cp proj_name         --create new project."
    echo "-sp proj_name         --set current work project."
    echo "-pp                   --print current project name."
    echo ""

    exit 0
}

function enter_bin_directory()
{
    dir=$BIN_OUTPUT_DIR
    if [ ! -d "$dir" ]
    then
        echo "Can't find \"$dir\" directory."
        exit 0
    fi
    cd $dir
    exec gnome-terminal
}

function set_curr_project()
{
    if [ ! -d $1/.proj_config ]
    then
        echo "$1 is not a project."
        echo "can't find .proj_config."
        exit 0
    fi
    echo "CURR_PROJ=$1" > /usr/local/etc/project.ini
}

function generate_project()
{
    if [ -d $1 ]
    then
        echo "$1 is exists"
        exit 1
    fi

    PROJECT_NAME=$1

    # 创建项目目录和配置文件
    mkdir ./$PROJECT_NAME/
    mkdir ./$PROJECT_NAME/config
    mkdir ./$PROJECT_NAME/doc
    mkdir ./$PROJECT_NAME/inc
    mkdir ./$PROJECT_NAME/lib
    mkdir ./$PROJECT_NAME/main
    mkdir ./$PROJECT_NAME/src
    mkdir ./$PROJECT_NAME/bin
    mkdir ./$PROJECT_NAME/.proj_config
    mkdir ./$PROJECT_NAME/.vscode

    # 创建项目配置文件和cmake编译文件
    # 只支持在当前所在目录下创建文件
    generate_proj_config.sh $PROJECT_NAME

    cd ./$PROJECT_NAME/
    git init
}
# compile_and_install option project_path
function compile_and_install()
{
    cd $2
    source .proj_config/proj_config.sh

    if [ ! -f ./CMakeLists.txt ]
    then
        echo "can't find CMakeLists.txt. path."
        return 0
    fi

    if [ -d "./build" ]
    then
        rm -rf ./build
    fi

    # 编译项目
    # 项目的可执行文件或是库根据生成的cmake_file
    # 决定输出位置
    mkdir ./build
    cd build
    cmake ..
    make
    cd ..

    # 如果设置 -r 选项表示编译完后
    # 清理生成的中间文件
    if [ $# -eq 1 ] && [ $1 == "-r" ]
    then
        ./clean_project.sh
    fi

    # 将项目下的 config 配置文件拷贝到可执行文件所在目录
    cp -rf ./config/* $PROJ_CONFIG_OUTPUT_DIR
}

function load_project()
{
    if [ $# -eq 0 ]
    then
        echo "Input project path."
        return 0
    fi

    if [ ! -d $1 ]
    then
        echo "$1 is not a dir"
        exit 1
    fi

    if [ ! -f $1/.proj_config/proj_config.sh ]
    then
        echo "Read Project Failed!"
        exit 1
    fi

    source $1/.proj_config/proj_config.sh
    cd $1
    project_path=`pwd`
    echo "project_config=$project_path/.proj_config/proj_config.sh" > $TMP_PROJECT_INFO
    echo "project_name=$PROJ_PROJECT_NAME" >> $TMP_PROJECT_INFO

    #更新项目路径
    old_project_path=`cat $project_path/.proj_config/proj_config.sh | grep PROJ_PROJECT_PATH`
    new_project_path="export PROJ_PROJECT_PATH=$project_path"
    sed 's/$old_project_path/$new_project_path/g' -i $project_path/.proj_config/proj_config.sh
}
#########################################################################
if [ $# -eq 0 ]
then
    help_info
fi

case $1 in
"-h")
    help_info
    ;;
"-l")
    if [ $# -ne 2 ]
    then
        help_info
    fi
    load_project $2
    ;;
"-cr")
    generate_proj_cmake_file
    compile_and_install -cr
    ;;
"-r")
    generate_proj_cmake_file
    compile_and_install
    ;;
"-c")
    clean_project.sh
    ;;
"-e")
    if [ $# -ne 2 ]
    then
        help_info
    fi
    enter_bin_directory $2
    ;;
"-w")
    gnome-terminal
    ;;
"-cp")
    if [ $# -ne 2 ]
    then
        help_info
    fi
    generate_project $2
    load_project $2
    ;;
"-sp")
    if [ $# -ne 2 ]
    then
        help_info
    fi
    set_curr_project $2
    ;;
"-pp")
    project_config=`cat $TMP_PROJECT_INFO | grep project_config | awk -F[=] '{print $2}'`
    project_name=`cat $TMP_PROJECT_INFO | grep project_name | awk -F[=] '{print $2}'`
    echo "project_name=$project_name"
    echo "project_config=$project_config"
    ;;
*)
    help_info
    ;;
esac

exit 0