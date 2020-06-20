#!/bin/bash

################################################################
# 全局变量
TMP_PROJECT_INFO=/usr/local/etc/current_project.tmp
CURRENT_PATH=`pwd`
################################################################
#基础的工具函数
function help_info() 
{
    echo "Usage: $0 [OPTIONS] [param1 param2 ...]"
    echo "-h                    --print help info."
    echo "-l                    --load project."
    echo "-cr                   --clean and rebuild project."
    echo "-r                    --rebuild without cleanning."
    echo "-rr                   --release version(non debug)"
    echo "-c                    --clean all."
    echo "-e                    --enter project exec file dir."
    echo "-w                    --open new gnome_terminal."
    echo "-cp proj_name         --create new project."
    echo "-sp proj_name         --set current work project."
    echo "-pp                   --print current project name."
    echo "-dr                   --daily record"
    echo "-db                   --debug the project."
    echo "-rg                   --add remote git address"
    echo "-push                 --push to github"
    echo ""

    exit 0
}

function enter_bin_directory()
{
    dir=$1
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
}

function clean_project()
{
    if [[ $PROJ_PROJECT_PATH != "" ]];then
        rm -r $PROJ_PROJECT_PATH/./bin/
        rm -r $PROJ_PROJECT_PATH/./lib/
        rm -rf $PROJ_PROJECT_PATH/./build/

        mkdir $PROJ_PROJECT_PATH/./bin/
        mkdir $PROJ_PROJECT_PATH/./lib/
    fi

    echo "clean over"
}

# compile_and_install option project_path
function compile_and_install()
{
    if [ $# -ne 2 ]
    then
        echo "compile_and_install option project_path."
        return 0
    fi

    cd $2
    if [ ! -f ./CMakeLists.txt ]
    then
        echo "can't find CMakeLists.txt path."
        return 0
    fi

    case $1 in
    "-cr")
        clean_project
        mkdir ./build
        ;;
    "-r")
        if [ ! -d "./build" ]
        then
            mkdir ./build
        fi
        ;;
    *)
        echo "compile_and_install unknown option $1"
        return 0
    ;;
    esac

    # 编译项目
    # 项目的可执行文件或是库根据生成的cmake_file
    # 决定输出位置
    cd build
    cmake ..
    make
    cd ..

    # 将项目下的 config 配置文件拷贝到可执行文件所在目录
    if [[ `ls -A ./config/` != "" ]];then
        echo $PROJ_CONFIG_OUTPUT_DIR
        cp -rf ./config/ $PROJ_CONFIG_OUTPUT_DIR/
    fi
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
    echo "project_uuid=$PROJ_UUID" >> $TMP_PROJECT_INFO
    echo "project_path=$PROJ_PROJECT_PATH" >> $TMP_PROJECT_INFO

    #更新项目路径
    old_project_path=`cat $project_path/.proj_config/proj_config.sh | grep PROJ_PROJECT_PATH`
    new_project_path="export PROJ_PROJECT_PATH=$project_path"
    sed 's/$old_project_path/$new_project_path/g' -i $project_path/.proj_config/proj_config.sh

    # 用vscode打开项目路径
    code -r $project_path
}

#########################################################################
if [ $# -eq 0 ]
then
    help_info
fi

##########################################################################
#加载项目的配置
project_config=`cat $TMP_PROJECT_INFO | grep project_config | awk -F[=] '{print $2}'`
if [ $project_config != "" ];then
    source $project_config
fi
##########################################################################

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
    generate_proj_cmake_file.sh
    compile_and_install -cr $PROJ_PROJECT_PATH
    ;;
"-r")
    generate_proj_cmake_file.sh
    compile_and_install -r $PROJ_PROJECT_PATH
    ;;
"-rr")
    generate_proj_cmake_file.sh release
    compile_and_install -cr $PROJ_PROJECT_PATH
    ;;
"-c")
    clean_project
    ;;
"-e")
    enter_bin_directory $PROJ_PROJECT_PATH/bin
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
    cat $TMP_PROJECT_INFO
    ;;
"-t")
    project_path=`cat $TMP_PROJECT_INFO | grep project_path | awk -F[=] '{print $2}'`
    cp $project_path/../src/*.cc $project_path/src/
    cp $project_path/../src/*.h $project_path/inc/
    mv $project_path/src/main.cc $project_path/main/
    ;;
"-dr")
    write_project_daily_record.sh
    clear
    ;;
"-db")
    generate_vscode_debug_config.sh
    ;;
"-rg")
    cd $PROJ_PROJECT_PATH
    git init

    note="输入远程github仓库地址\n(git remote add origin git@github.com:XXXX/XXXXX.git)"
    Doing=$(whiptail --title "title" --inputbox "echo -e $note" 10 60  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "You chose Cancel."
    fi
    $Doing
    ;;
"-push")
    cd $PROJ_PROJECT_PATH

    git add -A .
	git commit -m "$date"
	git push -u origin $PROJ_PROJECT_PATH
    ;;
*)
    help_info
    ;;
esac

exit 0