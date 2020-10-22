########################################################
#   写代码日志
########################################################

#!/bin/bash

#########################################################
# 全局变量
TMP_PROJECT_INFO=$HOME/.current_project.tmp
CURRENT_PATH=`pwd`
##########################################################################
#加载项目的配置
source ./project_config_manager.sh
PROJ_PROJECT_PATH=`print_obj_val 项目路径`
##########################################################################
mkdir -p $PROJ_PROJECT_PATH/.proj_config/record/

OPTION=$(whiptail --title "日志选项" --menu "选择你的操作：" 15 60 4 \
"1" "记录项目进度" \
"2" "记录未来计划" \
"3" "查看历史记录" \
"4" "退出"  3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus != 0 ]; then
    echo "exit."
fi

case $OPTION in
"1")
    OPTION=$(whiptail --title "Menu Dialog" --menu "$title" 15 60 3 \
    "1" "今天完成了什么" \
    "2" "还有什么正在做" \
    3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "You chose Cancel."
        break
    fi

    file_name=`date '+%F_%T'`
    if [ $OPTION == "1" ]
    then
        file_path="$PROJ_PROJECT_PATH/.proj_config/record/daily_record/done_$file_name"
    else
        file_path="$PROJ_PROJECT_PATH/.proj_config/record/daily_record/todo_$file_name"
    fi
    
    vim $file_path
    if [ -f "$file_path" ]
    then
        if [ $OPTION == "1" ]
        then
            echo $file_path >> $PROJ_PROJECT_PATH/.proj_config/record/daily_record/done_record_file.txt
        else
            echo $file_path >> $PROJ_PROJECT_PATH/.proj_config/record/daily_record/todo_record_file.txt
        fi
        
    fi
    ;;
"2")
    plan_path=$PROJ_PROJECT_PATH/.proj_config/record/plan.txt
    vim $plan_path
    ;;
"3")
    OPTION=$(whiptail --title "Menu Dialog" --menu "$title" 15 60 3 \
    "1" "历史日志" \
    "2" "历史计划" \
    3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "You chose Cancel."
        break
    fi


    
    ;;
*)
    echo "exit"
    ;;
esac