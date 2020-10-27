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
PROJ_PROJECT_PATH=`cat $TMP_PROJECT_INFO | grep project_path | awk -F[=] '{print $2}'`
##########################################################################
mkdir -p $PROJ_PROJECT_PATH/.proj_config/record/daily_record/

while true
do
    OPTION=$(whiptail --title "日志选项" --menu "选择你的操作：" 15 60 4 \
    "1" "记录项目进度" \
    "2" "记录未来计划" \
    "3" "查看历史记录" \
    "4" "退出"  3>&1 1>&2 2>&3)
    
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "exit."
        break
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
            continue
        fi

        file_name=`date '+%F_%T'`
        if [ $OPTION == "1" ]
        then
            file_path="$PROJ_PROJECT_PATH/.proj_config/record/daily_record/done_record_$file_name"
        else
            file_path="$PROJ_PROJECT_PATH/.proj_config/record/daily_record/todo_record_$file_name"
        fi
        
        vim $file_path
        ;;
    "2")
        plan_path=$PROJ_PROJECT_PATH/.proj_config/record/plan.txt
        vim $plan_path
        ;;
    "3")
        OPTION=$(whiptail --title "Menu Dialog" --menu "$title" 15 60 2 \
        "1" "历史日志" \
        "2" "历史计划" \
        3>&1 1>&2 2>&3)

        exitstatus=$?
        if [ $exitstatus != 0 ]; then
            echo "You chose Cancel."
            continue
        fi

        cd $PROJ_PROJECT_PATH/.proj_config/record/daily_record/
        case $OPTION in
            "1")
                unset records
                for record in `ls | grep done_record | sort -r`
                do
                    records[${#records[*]}]=$record
                done
            ;;
            "2")
                unset records
                for record in `ls | grep todo_record | sort -r`
                do
                    records[${#records[*]}]=$record
                done
            ;;
        esac

        start_line=0
        end_line=5
        while true
        do
            unset tmp_records
            for(( i=$start_line;i<${#records[@]};i++ )) 
            do
                if [ $i -lt $end_line ]
                then
                    records_num=`expr ${#tmp_records[*]} / 2 + 1`
                    tmp_records[${#tmp_records[*]}]=$records_num
                    tmp_records[${#tmp_records[*]}]=${records[$i]}
                fi   
            done
            
            records_num=`expr ${#tmp_records[*]} / 2 + 1`
            tmp_records[${#tmp_records[*]}]="next_page"
            tmp_records[${#tmp_records[*]}]=""

            records_num=`expr ${#tmp_records[*]} / 2 + 1`
            tmp_records[${#tmp_records[*]}]="last_page"
            tmp_records[${#tmp_records[*]}]=""

            OPTION=$(whiptail --title "Menu Dialog" --menu "$title" 15 60 $records_num "${tmp_records[@]}" 3>&1 1>&2 2>&3)

            exitstatus=$?
            if [ $exitstatus != 0 ]; then
                echo "You chose Cancel."
                break
            fi

            case $OPTION in
                "next_page")
                    tmp_line=`expr $start_line + 5`
                    if [ $tmp_line -gt ${#records[@]} ]
                    then
                        continue
                    fi
                    start_line=$tmp_line

                    end_line=`expr $end_line + 5`
                    if [ $end_line -gt ${#records[@]} ]
                    then
                        end_line=${#records[@]}
                    fi
                ;;
                "last_page")
                    if [ $start_line -eq 0 ]
                    then
                        continue
                    fi

                    start_line=`expr $start_line - 5`

                    end_line=`expr $start_line + 5`
                    if [ $end_line -gt ${#records[@]} ]
                    then
                        end_line=${#records[@]}
                    fi
                ;;
                *)
                    pos=`expr $start_line + $OPTION - 1`
                    vim ${records[$pos]}
                ;;
            esac

        done
        ;;
    "4")
        echo "exit."
        break;
        ;;
    esac
done