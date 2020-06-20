#!/bin/bash

################################################################
# 全局变量
TMP_PROJECT_INFO=/usr/local/etc/current_mproject.tmp
################################################################
#功能函数
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
    echo "-cp proj_name         --create new mproject."
    echo "-sp proj_name         --set current work project."
    echo "-pp                   --print current project name."
    echo "-dr                   --daily record"
    echo "-db                   --debug the project."
    echo "-rg                   --add remote git address"
    echo "-push                 --push to github"
    echo ""

    exit 0
}

function generate_mproject()
{
    if [ -d $1 ]
    then
        echo "$1 is exists"
        exit 1
    fi

    PROJECT_NAME=$1

    # 创建项目目录和配置文件
    mkdir ./$PROJECT_NAME/
    mkdir ./$PROJECT_NAME/.mproj_config

    touch ./$PROJECT_NAME/.mproj_config/projects_info.ini
}

function load_mproject()
{
    if [ $# -eq 0 ]
    then
        echo "Input mproject path."
        return 0
    fi

    mproj_path=$1
    mproj_config_path = $mproj_path/.mproj_config/projects_info.ini
    if [ ! -d $mproj_path ]
    then
        echo "$mproj_path is not a dir"
        exit 1
    fi

    if [ ! -f $mproj_config_path ]
    then
        echo "Read mproject Failed!"
        exit 1
    fi

    arr=()
    # 项目格式：项目名称
    for project_info in `cat $mproj_config_path`
    do
        arr[${#arr[*]}]=$project_info
    done

    project_name=$(whiptail --title "项目目录" --menu "选择项目：" 15 60 4 arr[*] 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "exit."
    fi

    if [ $project_name != "" ];then
        project -l $mproj_path/project_name
    else
        echo "It's an empty mproject."
    fi
}

function add_new_mproject()
{
    if [ $# -eq 0 ]
    then
        echo "Input project name."
        return 0
    fi

    project_name=$1
    test_project_name=`cat `
}
##############################################


case $1 in
"-h")
    help_info
    ;;
"-l")
    if [ $# -ne 2 ]
    then
        help_info
    fi
    load_mproject $2
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