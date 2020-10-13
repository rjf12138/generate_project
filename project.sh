#!/bin/bash

################################################################
# 全局变量
TMP_PROJECT_INFO=$HOME/.current_project.tmp
INSTALL_PATH=`cat $TMP_PROJECT_INFO | grep install_path | awk -F[=] '{print $2}'`
EXTERN_RESOURSE_PATH="`cat $TMP_PROJECT_INFO | grep install_path | awk -F[=] '{print $2}'`/script/extern"
CURRENT_PATH=`pwd`
################################################################
pwd
source $INSTALL_PATH/project_config_manager.sh

#基础的工具函数
function help_info() 
{
    echo "Usage: $0 [OPTIONS] [param1 param2 ...]"
    echo "-h                    --print help info."
    echo "-cfg                  --configuration profile"
    echo "-l                    --load project."
    echo "-cr                   --clean and rebuild project."
    echo "-r                    --rebuild without cleanning."
    echo "-rr                   --release version(non debug)"
    echo "-c                    --clean all."
    echo "-e                    --enter project exec file dir."
    echo "-w                    --open new gnome_terminal."
    echo "-cp                   --create new project."
    echo "-pp                   --print current project name."
    echo "-dr                   --daily record"
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
    # 检查当前是不是在gnome-terminal下
    # 如果是就直接打开标签，不是就打开新窗口
    gnome-terminal --tab 2> /tmp/terminal_error
    file_size=`du /tmp/terminal_error | awk '{ORS="";print $1}'`
    if [ $file_size != "0" ];then
        exec gnome-terminal
    fi
}

# 只能在给定的路径下创建项目
# generate_project proj_path proj_name
function generate_project()
{
    if [ -d $1 ]
    then
        echo "$1 is exists"
        exit 1
    fi

    PROJECT_NAME=$2
    PROJECT_PATH=$1

    # 创建项目目录和配置文件
    mkdir $PROJECT_PATH/
    mkdir $PROJECT_PATH/config
    mkdir $PROJECT_PATH/doc
    mkdir $PROJECT_PATH/inc
    mkdir $PROJECT_PATH/lib
    mkdir $PROJECT_PATH/lib/debug
    mkdir $PROJECT_PATH/lib/release
    mkdir $PROJECT_PATH/main
    mkdir $PROJECT_PATH/src
    mkdir $PROJECT_PATH/output
    mkdir $PROJECT_PATH/output/debug
    mkdir $PROJECT_PATH/output/debug/bin
    mkdir $PROJECT_PATH/output/debug/lib
    mkdir $PROJECT_PATH/output/release
    mkdir $PROJECT_PATH/output/release/bin
    mkdir $PROJECT_PATH/output/release/lib
    mkdir $PROJECT_PATH/.proj_config
    mkdir $PROJECT_PATH/.vscode

    # 创建项目配置文件和cmake编译文件
    # 只支持在当前所在目录下创建文件

    # 添加一些基本的头文见和测试库
    cp -rf $EXTERN_RESOURSE_PATH/gtest/include/* $PROJECT_PATH/inc/
    cp -rf $EXTERN_RESOURSE_PATH/gtest/lib/* $PROJECT_PATH/lib/debug
    cp -rf $EXTERN_RESOURSE_PATH/basic_head.h $PROJECT_PATH/inc/
    cp -rf $EXTERN_RESOURSE_PATH/project_config.json $PROJECT_PATH/.proj_config/
    cp -rf $EXTERN_RESOURSE_PATH/exbin/parse_json $PROJECT_PATH/.proj_config/
    echo $PROJECT_PATH/.proj_config/parse_json
    chmod u+x $PROJECT_PATH/.proj_config/parse_json

    # 初始化配置文件
    set_obj_val 项目名称 "$PROJECT_PATH"
    set_obj_val 项目名称 "$PROJECT_NAME"
    project_uuid=`uuidgen`
    set_obj_val 项目UUID "$project_uuid"

    # 初始化git
    cd $PROJECT_PATH
    git init
    git add -A .
	git commit -m "first commit"
}

function clean_project()
{
    if [[ $PROJ_PROJECT_PATH != "" ]];then
        rm -rf $PROJ_PROJECT_PATH/output/release/bin/*
        rm -rf $PROJ_PROJECT_PATH/output/release/lib/*
        rm -rf $PROJ_PROJECT_PATH/output/debug/bin/*
        rm -rf $PROJ_PROJECT_PATH/output/debug/lib/*
        rm -rf $PROJ_PROJECT_PATH/./build/

        # 删除cmake配置文件
        for cmake_file in `find $PROJ_PROJECT_PATH/ -name CMakeLists.txt`
        do
            if [ ! -z `echo $cmake_file | grep CMakeLists.txt` ];then
                rm -f $cmake_file
            fi
        done

        cd $PROJ_PROJECT_PATH
        src_dirs=`print_arr_all 源文件目录列表`
        for src_dir in src_dirs
        do
            if [ ! -d $src_dir ];then
                continue
            fi

            if [ -f "$src_dir/CMakeLists.txt" ];then
                rm -f $src_dir/CMakeLists.txt
            fi
        done
    fi

    echo "clean over"
}

# compile_and_install option project_path
function compile_and_install()
{
    if [ $# -ne 3 ]
    then
        echo "compile_and_install option project_path."
        return 0
    fi

    cd $2
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
    generate_proj_cmake_config.sh
    cd build
    cmake ..
    make
    cd ..
    echo "------------ $3 ---------------"
    # 将项目下的 config 配置文件拷贝到可执行文件所在目录
    if [[ `ls -A ./config/` != "" ]];then
        if [ $3 == "release" ];then
            cp -rf ./config/ ./output/release/bin
        else
            cp -rf ./config/ ./output/debug/bin
        fi
    fi
    
    # 最新的生成位置写到临时文件中
    if [ $3 == "release" ];then
        lib_path=`cat $TMP_PROJECT_INFO | grep gen_lib_path`
        bin_path=`cat $TMP_PROJECT_INFO | grep gen_bin_path`
        sed "s#$lib_path#gen_lib_path=$PROJ_BIN_OUTPUT_DIR/release/lib#g" -i $TMP_PROJECT_INFO
        sed "s#$bin_path#gen_bin_path=$PROJ_BIN_OUTPUT_DIR/release/bin#g" -i $TMP_PROJECT_INFO
    else
        lib_path=`cat $TMP_PROJECT_INFO | grep gen_lib_path`
        bin_path=`cat $TMP_PROJECT_INFO | grep gen_bin_path`
        sed "s#$lib_path#gen_lib_path=$PROJ_BIN_OUTPUT_DIR/debug/lib#g" -i $TMP_PROJECT_INFO
        sed "s#$bin_path#gen_bin_path=$PROJ_BIN_OUTPUT_DIR/debug/bin#g" -i $TMP_PROJECT_INFO
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

    project_path=$1
    cd $project_path

    project_uuid=`print_obj_val 项目UUID`
    project_name=`print_obj_val 项目名称`

    echo "`cat $TMP_PROJECT_INFO | grep install_path`" > $TMP_PROJECT_INFO
    echo "project_config=$project_path/.proj_config/project_config.json" >> $TMP_PROJECT_INFO
    echo "project_name=$project_name" >> $TMP_PROJECT_INFO
    echo "project_uuid=$project_uuid" >> $TMP_PROJECT_INFO
    echo "project_path=$project_path" >> $TMP_PROJECT_INFO

    # 记录下加载过的项目
    search_record=`cat $HOME/.project_history | grep $PROJ_UUID`
    if [ -z "$search_record" ];then
        echo "$PROJ_UUID=$project_path" >> $HOME/.project_history
    else
        sed "s#$search_record#$PROJ_UUID=$project_path#g" -i $HOME/.project_history
    fi

    #更新项目路径到临时缓存中
    old_project_path=`cat $project_path/.proj_config/proj_config.sh | grep PROJ_PROJECT_PATH=`
    new_project_path="export PROJ_PROJECT_PATH=$project_path"
    set_obj_val 项目路径 "$project_path"

    echo "gen_lib_path=$PROJ_BIN_OUTPUT_DIR/release/lib" >> $TMP_PROJECT_INFO
    echo "gen_bin_path=$PROJ_BIN_OUTPUT_DIR/release/bin" >> $TMP_PROJECT_INFO

    # 用vscode打开项目路径
    code -r $project_path
}

# update_project_info
function update_project_info()
{
    # 检查历史项目信息
    for project_info in `cat $HOME/.project_history`
    do
        project_path=`echo $project_info | awk -F[=] '{print $2}'`
        project_uuid=`echo $project_info | awk -F[=] '{print $1}'`
        if [ ! -f `print_obj_val 项目路径` ];then
            # 获取的项目是个无法加载的项目
            sed "s#$project_info##g" -i $HOME/.project_history
        else
            curr_project_uuid=`cat $project_path/.proj_config/proj_config.sh \
                                | grep PROJ_UUID= | awk -F[=] '{print $2}'`
            # 比对项目的uuid与记录中的uuid是否一致
            if [ $project_uuid != $curr_project_uuid ];then
                sed "s#$project_info##g" -i $HOME/.project_history
            fi 
        fi
    done
}
#########################################################################
if [ $# -eq 0 ]
then
    help_info
fi

##########################################################################
#加载项目的配置
project_config=`cat $TMP_PROJECT_INFO 2> /dev/null | grep project_config | awk -F[=] '{print $2}' | tr -s '\n'`
if [ ! -z $project_config ] && [ -f $project_config ];then
    source $project_config
fi

# 当项目未加载时， 执行cmd_lists中的命令会报错
if [ -z $project_config ];then
    cmd_lists=("-r" "-rr" "-c" "-cr" "-e" "-rg" "-dr" "-t" "-push")
    for cmd in ${cmd_lists[@]}
    do
        if [ $1 == $cmd ];then
            echo "There is not load any project."
            echo "Use \"project -l\" load a project or \"project -cp\" create project."
            echo "More information see \"project -h\""
            exit 1
        fi
    done
fi

##########################################################################
# 记录历史打开的配置
if [ ! -f $HOME/.project_history ];then
    touch $HOME/.project_history
    echo /dev/null > $HOME/.project_history
fi

case $1 in
"-h")
    help_info
    ;;
"-l")
    update_project_info # 更新历史项目配置
    project_arr=("输入项目路径" "")
    project_menu=("1" "输入项目路径" "2" "")
    for proj_info in `cat $HOME/.project_history`
    do
        project_path=`echo $proj_info | awk -F[=] '{print $2}'`
        project_uuid=`echo $proj_info | awk -F[=] '{print $1}'`
        result=`cat $TMP_PROJECT_INFO | grep $project_uuid`
        if [ ! -z $result ];then # 将最近打开项目设置到首要位置
            project_arr[1]=$project_path
            project_menu[3]=$project_path
            continue
        fi
        project_arr[${#project_arr[*]}]=$project_path
        project_menu[${#project_menu[*]}]=${#project_arr[*]}
        project_menu[${#project_menu[*]}]=$project_path
    done
    
    OPTION=$(whiptail --title "项目选择" --menu "选择加载的项目：" 15 60 ${#project_arr[*]} "${project_menu[@]}" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "exit."
        exit 1
    fi

    if [ $OPTION == "1" ];then
        proj_path=$(whiptail --title "title" --inputbox "项目路径" 10 60 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus != 0 ]; then
            echo "You chose Cancel."
            exit 1
        fi
    else
        index=$[$OPTION-1]
        proj_path=${project_arr[${index}]}
    fi

    # 用图形化选择项目
    load_project $proj_path
    ;;
"-cfg")
    config_project_config
    ;;
"-cr")
    compile_and_install -cr $PROJ_PROJECT_PATH debug
    generate_vscode_debug_config.sh
    ;;
"-r")
    compile_and_install -r $PROJ_PROJECT_PATH debug
    generate_vscode_debug_config.sh
    ;;
"-rr")
    compile_and_install -cr $PROJ_PROJECT_PATH release
    ;;
"-c")
    clean_project
    ;;
"-e")
    bin_path=`cat $TMP_PROJECT_INFO 2> /dev/null | grep gen_bin_path | awk -F[=] '{print $2}' | tr -s '\n'`
    enter_bin_directory $bin_path
    ;;
"-w")
    gnome-terminal
    ;;
"-cp")
    proj_name=$(whiptail --title "创建项目" --inputbox "输入名称项目" 10 60 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "You chose Cancel."
        exit 1
    fi

    if [ -z "$proj_name" ];then
        echo "project name is empty."
        exit 1
    fi

    proj_path="`pwd`/$proj_name"
    generate_project $proj_path $proj_name 
    load_project $proj_path
    ;;
"-pp")
    cat $TMP_PROJECT_INFO
    ;;
"-t")
    project_path=`cat $TMP_PROJECT_INFO | grep project_path | awk -F[=] '{print $2}'`
    cp $EXTERN_RESOURSE_PATH/test_code/*.cc $project_path/src/
    cp $EXTERN_RESOURSE_PATH/test_code/*.h $project_path/inc/
    mv $project_path/src/main.cc $project_path/main/
    ;;
"-dr")
    write_project_daily_record.sh
    clear
    ;;
"-rg")
    cd $PROJ_PROJECT_PATH

    note="输入远程github仓库地址\n(git remote add origin git@github.com:XXXX/XXXXX.git)"
    Doing=$(whiptail --title "title" --inputbox "$note" 10 60  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "You chose Cancel."
    fi
    git remote add origin $Doing
    ;;
"-push")
    cd $PROJ_PROJECT_PATH

    git add -A .
	git commit -m "`date`"
	git push -u origin master
    ;;
*)
    help_info
    ;;
esac

exit 0