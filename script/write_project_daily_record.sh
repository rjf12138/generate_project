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
"1" "记录代码进度" \
"2" "记录未来计划" \
"3" "查看昨天进度" \
"4" "退出"  3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus != 0 ]; then
    echo "exit."
fi

case $OPTION in
"1")
    Done=$(whiptail --title "title" --inputbox "今天完成了什么" 10 60 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "You chose Cancel."
        exit 1
    fi

    Doing=$(whiptail --title "title" --inputbox "还有什么正在做" 10 60  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "You chose Cancel."
        exit 1
    fi

    # 最后确认
    if (whiptail --title "确认日志" --yesno "`echo -e "${Done}\n${Doing}"`" 10 60) then
        echo ""
    else
        exit 0
    fi
    #写入文件中
    date_time=`date '+%F %T'`
    echo "$date_time" >> $PROJ_PROJECT_PATH/.proj_config/record/daily_record
    echo "完成：$Done" >> $PROJ_PROJECT_PATH/.proj_config/record/daily_record
    echo "正在做：$Doing" >> $PROJ_PROJECT_PATH/.proj_config/record/daily_record
    ;;
"2")
    old_plan=`cat $PROJ_PROJECT_PATH/.proj_config/record/plan`
    plan=$(whiptail --title "title" --inputbox "未来的计划" 10 60 $old_plan 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "You chose Cancel."
    fi
    date_time=`date '+%F %T'`
    echo "$plan" >> $PROJ_PROJECT_PATH/.proj_config/record/plan
    ;;
"3")
    yesterdat_record=`tail -n 3 $PROJ_PROJECT_PATH/.proj_config/record/daily_record`
    whiptail --title "昨天日志" --msgbox "$yesterdat_record" 10 60
    ;;
*)
    echo "exit"
    ;;
esac