###########################################
# 修改項目的配置文件
###########################################
#!/bin/bash

#########################################################
# 全局变量
TMP_PROJECT_INFO=$HOME/.current_project.tmp
# 使用下面函数前要确保.current_project.tmp中要有当前项目的路径
###########################################################################
# 设置项目路径到 .current_project.tmp 中
function set_project_path_to_tmp_config_file()
{
	if [ $# != 1 ];then
		return 1
	fi
	
	# 检查配置文件中是否有项目路径这个选项
	project_path=`cat $TMP_PROJECT_INFO | grep project_path`
	key=`echo $project_path | awk -F[=] '{print $1}'`

	if [ "$key" != "project_path" ];then
		echo "project_path=$1" >> $TMP_PROJECT_INFO
	else
		sed "s#$project_path#project_path=$1#g" -i $TMP_PROJECT_INFO
	fi
}

# JSON 解析封装函数
# # 只能打印当前节点以及其下级数组的元素
function print_obj_val()
{
PROJ_PROJECT_PATH=`cat $TMP_PROJECT_INFO | grep project_path | awk -F[=] '{print $2}'`
PROJECT_CONFIG_PATH=$PROJ_PROJECT_PATH/.proj_config/project_config.json
JSON_PARSE=$PROJ_PROJECT_PATH/.proj_config/parse_json

if [ ! -d $PROJ_PROJECT_PATH ]
then
	return ;
fi
	
cd $PROJ_PROJECT_PATH

$JSON_PARSE $PROJECT_CONFIG_PATH << EOF
print $1
quit
EOF
}

function print_arr_val()
{
PROJ_PROJECT_PATH=`cat $TMP_PROJECT_INFO | grep project_path | awk -F[=] '{print $2}'`
PROJECT_CONFIG_PATH=$PROJ_PROJECT_PATH/.proj_config/project_config.json
JSON_PARSE=$PROJ_PROJECT_PATH/.proj_config/parse_json

if [ ! -d $PROJ_PROJECT_PATH ]
then
	return ;
fi
	
cd $PROJ_PROJECT_PATH

$JSON_PARSE $PROJECT_CONFIG_PATH << EOF
cd $1
print $2
quit
EOF
}

function print_arr_all()
{
PROJ_PROJECT_PATH=`cat $TMP_PROJECT_INFO | grep project_path | awk -F[=] '{print $2}'`
PROJECT_CONFIG_PATH=$PROJ_PROJECT_PATH/.proj_config/project_config.json
JSON_PARSE=$PROJ_PROJECT_PATH/.proj_config/parse_json

if [ ! -d $PROJ_PROJECT_PATH ]
then
	return ;
fi
	
cd $PROJ_PROJECT_PATH

$JSON_PARSE $PROJECT_CONFIG_PATH << EOF
cd $1
print
quit
EOF
}

function set_obj_val()
{
PROJ_PROJECT_PATH=`cat $TMP_PROJECT_INFO | grep project_path | awk -F[=] '{print $2}'`
PROJECT_CONFIG_PATH=$PROJ_PROJECT_PATH/.proj_config/project_config.json
JSON_PARSE=$PROJ_PROJECT_PATH/.proj_config/parse_json

if [ ! -d $PROJ_PROJECT_PATH ]
then
	return ;
fi
	
cd $PROJ_PROJECT_PATH

$JSON_PARSE $PROJECT_CONFIG_PATH << EOF
set str $1 $2
write
quit
EOF
}

# set_arr_all 参数名称 以空格为分割的字符串
function set_arr_all()
{
PROJ_PROJECT_PATH=`cat $TMP_PROJECT_INFO | grep project_path | awk -F[=] '{print $2}'`
PROJECT_CONFIG_PATH=$PROJ_PROJECT_PATH/.proj_config/project_config.json
JSON_PARSE=$PROJ_PROJECT_PATH/.proj_config/parse_json

if [ ! -d $PROJ_PROJECT_PATH ]
then
	return ;
fi
	
cd $PROJ_PROJECT_PATH

	old_val=`print_arr_all $1`
	for del_val in $old_val
	do
$JSON_PARSE $PROJECT_CONFIG_PATH << EOF
cd $1
del 0
write
quit
EOF
	done

	for param in $2
	do
$JSON_PARSE $PROJECT_CONFIG_PATH << EOF
cd $1
add str $param
write
quit
EOF
	done
}

###########################################################################
# 添加项目特有配置
function load_project_info()
{
	# 加载程序入口文件列表
	cd $PROJ_PROJECT_PATH/main

	program_entry_file_list=`ls | grep -E '.cc|.cpp' | awk -F['\n'] '{ORS=" ";print $1}'`
    set_arr_all 程序入口文件列表 "$program_entry_file_list"
}

###########################################################################
# exe_file_list=`ls ./main/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
# src_file_list=`ls ./src/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
# static_lib_file_list=`cd ./lib/$compile_method/; ls *.a | tr -s " " | awk '{ORS=" "; print $1}'`
# share_lib_file_list=`cd ./lib/$compile_method/; ls *.so | tr -s " " | awk '{ORS=" "; print $1}'`

function config_project_config()
{
	load_project_info

	project_option=("项目名称" "项目路径" "当前编译器" "可选编译器列表" "编译方式" "debug版编译选项"
					"release版编译选项" "当前生成文件类型" "可生成文件类型" "当前程序入口文件" "程序入口文件列表"
					"头文件目录列表" "静态库目录列表" "源文件目录列表" "项目UUID")
    project_name=`print_obj_val 项目名称`
	project_path=`print_obj_val 项目路径`
	current_compiler=`print_obj_val 当前编译器`
	compiler_list=`print_arr_all 可选编译器列表`
	compile_method=`print_obj_val 编译方式`
	program_run_param=`print_obj_val 程序参数`
	debug_compile_option=`print_obj_val debug版编译选项`
	release_compile_option=`print_obj_val release版编译选项`
	current_generate_file_type=`print_obj_val 当前生成文件类型`
	current_program_entry_file=`print_obj_val 当前程序入口文件`
	program_entry_file_list=`print_arr_all 程序入口文件列表`
	header_dir_path_list=`print_arr_all 头文件目录列表`
	static_lib_dir_list=`print_arr_all 静态库目录列表`
	release_static_lib_list=`print_arr_all release静态库列表`
	debug_static_lib_list=`print_arr_all debug静态库列表`
	src_file_dir_list=`print_arr_all 源文件目录列表`
	project_uuid=`print_obj_val 项目UUID`

	while true
	do
		# whiptail 的值不能以 ‘-’开始
		project_config_info=("*项目名称: " "$project_name" "*项目UUID: " "$project_uuid" "*项目路径: " "$project_path" 
								">当前编译器: " "$current_compiler" ">编译方式: " "$compile_method" ">程序参数: " "$program_run_param" ">debug编译选项: " "$debug_compile_option"
								">release编译选项: " "$release_compile_option" ">当前生成文件类型: " "$current_generate_file_type"
								">当前程序入口文件: "  "$current_program_entry_file" ">头文件目录列表" "查看"
								">静态库目录列表" "查看" ">静态库列表" "查看" ">源文件目录列表" "查看" "*退出并保存" "" "*退出不保存" "")

		project_config_num=`expr ${#project_config_info[*]} / 2`
		OPTION=$(whiptail --title "项目配置" --menu "项目配置" 25 82 $project_config_num "${project_config_info[@]}"  3>&1 1>&2 2>&3)

		exitstatus=$?
		if [ $exitstatus != 0 ]; then
			echo "You chose Cancel."
			return -1
		fi

		if [ $OPTION == "*退出不保存" ];then
			return 0
		elif [ $OPTION == "*退出并保存" ];then
			break
		fi
		
		case $OPTION in
			"*项目名称: "|"*项目UUID: "|"*项目路径: ")
				continue
				;;
			">静态库列表")
				if [ $compile_method == "release" ];then
					title="release静态库"
					static_lib_list=$release_static_lib_list
				else
					title="debug静态库"
					static_lib_list=$debug_static_lib_list
				fi
				while true
				do
					OPTION=$(whiptail --title "Menu Dialog" --menu "$title" 15 60 3 \
					"1" "添加静态库" \
					"2" "删除静态库" \
					"3" "查看静态库列表" \
					3>&1 1>&2 2>&3)

					exitstatus=$?
					if [ $exitstatus != 0 ]; then
						echo "You chose Cancel."
						break
					fi
			
					case $OPTION in
						"1")
							new_lib=$(whiptail --title "添加静态库" --inputbox "" 10 60 3>&1 1>&2 2>&3)

							exitstatus=$?
							if [ $exitstatus == 0 ]; then
								static_lib_list=$static_lib_list" "$new_lib
								if [ $compile_method == "release" ];then
										release_static_lib_list=$static_lib_list
									elif [ $compile_method == "debug" ];then
										debug_static_lib_list=$static_lib_list
									else
										echo "unknow $compile_method"
								fi
							fi
						;;
						"2")
							while true 
							do
								unset static_libs
								for static_lib in $static_lib_list
								do
									static_libs_num=`expr ${#static_libs[*]} / 2 + 1`
									static_libs[${#static_libs[*]}]=$static_libs_num
									static_libs[${#static_libs[*]}]=$static_lib
								done

								static_libs_num=`expr ${#static_libs[*]} / 2`
								OPTION=$(whiptail --title "Menu Dialog" --menu "删除源文件目录" 15 60 $static_libs_num "${static_libs[@]}" 3>&1 1>&2 2>&3)

								exitstatus=$?
								if [ $exitstatus != 0 ]; then
									echo "You chose Cancel."
									break
								fi

								index=$[$OPTION * 2 - 1]
								del_static_lib=${static_libs[$index]}

								if (whiptail --title "Yes/No Box" --yesno "确定要移除 $del_static_lib" 10 60) then
									static_lib_list=`echo $static_lib_list | sed "s#$del_static_lib##g"`
									if [ $compile_method == "release" ];then
										release_static_lib_list=$static_lib_list
									elif [ $compile_method == "debug" ];then
										debug_static_lib_list=$static_lib_list
									else
										echo "unknow $compile_method"
									fi
								else
									echo "You chose No. Exit status was $?."
								fi
							done 
							;;
						"3")
							while true
							do
								unset static_libs
								for static_lib in $static_lib_list
								do
									static_libs_num=`expr ${#static_libs[*]} / 2 + 1`
									static_libs[${#static_libs[*]}]=$static_libs_num
									static_libs[${#static_libs[*]}]=$static_lib
								done

								static_libs_num=`expr ${#static_libs[*]} / 2`
								OPTION=$(whiptail --title "Menu Dialog" --menu "删除源文件目录" 15 60 $static_libs_num "${static_libs[@]}" 3>&1 1>&2 2>&3)

								exitstatus=$?
								if [ $exitstatus != 0 ]; then
									echo "You chose Cancel."
									break
								fi
							done
						;;
					esac
				done
			;;
			">源文件目录列表")
				while true
				do
					OPTION=$(whiptail --title "Menu Dialog" --menu "源文件目录" 15 60 3 \
					"1" "添加源文件目录" \
					"2" "删除源文件目录" \
					"3" "源文件目录列表" \
					3>&1 1>&2 2>&3)

					exitstatus=$?
					if [ $exitstatus != 0 ]; then
						echo "You chose Cancel."
						break
					fi
			
					case $OPTION in
						"1")
							new_dir=$(whiptail --title "添加源文件目录" --inputbox "" 10 60 3>&1 1>&2 2>&3)

							exitstatus=$?
							if [ $exitstatus == 0 ]; then
								src_file_dir_list=$src_file_dir_list" "$new_dir
							fi
						;;
						"2")
							while true 
							do
								unset src_files_dirs
								for src_file_dir in $src_file_dir_list
								do
									src_files_dirs_num=`expr ${#src_files_dirs[*]} / 2 + 1`
									src_files_dirs[${#src_files_dirs[*]}]=$src_files_dirs_num
									src_files_dirs[${#src_files_dirs[*]}]=$src_file_dir
								done

								src_files_dirs_num=`expr ${#src_files_dirs[*]} / 2`
								OPTION=$(whiptail --title "Menu Dialog" --menu "删除源文件目录" 15 60 $src_files_dirs_num "${src_files_dirs[@]}" 3>&1 1>&2 2>&3)

								exitstatus=$?
								if [ $exitstatus != 0 ]; then
									echo "You chose Cancel."
									break
								fi

								index=$[$OPTION * 2 - 1]
								del_src_dir=${src_files_dirs[$index]}

								if (whiptail --title "Yes/No Box" --yesno "确定要移除 $del_src_dir" 10 60) then
									src_file_dir_list=`echo $src_file_dir_list | sed "s#$del_src_dir##g"`
								else
									echo "You chose No. Exit status was $?."
								fi
							done 
							;;
						"3")
							while true
							do
								unset src_files_dirs
								for src_file_dir in $src_file_dir_list
								do
									src_files_dirs_num=`expr ${#src_files_dirs[*]} / 2 + 1`
									src_files_dirs[${#src_files_dirs[*]}]=$src_files_dirs_num
									src_files_dirs[${#src_files_dirs[*]}]=$src_file_dir
								done

								src_files_dirs_num=`expr ${#src_files_dirs[*]} / 2`
								OPTION=$(whiptail --title "Menu Dialog" --menu "删除源文件目录" 15 60 $src_files_dirs_num "${src_files_dirs[@]}"3>&1 1>&2 2>&3)

								exitstatus=$?
								if [ $exitstatus != 0 ]; then
									echo "You chose Cancel."
									break
								fi
							done
						;;
					esac
				done
				;;
			">静态库目录列表")
				while true
				do
					OPTION=$(whiptail --title "Menu Dialog" --menu "静态库目录" 15 60 3 \
					"1" "添加静态库目录" \
					"2" "删除静态库目录" \
					"3" "静态库目录列表" 3>&1 1>&2 2>&3)

					exitstatus=$?
					if [ $exitstatus != 0 ]; then
						echo "You chose Cancel."
						break
					fi

					case $OPTION in
						"1")
							new_static_lib_dir=$(whiptail --title "添加静态库目录" --inputbox "添加静态库目录" 10 60 3>&1 1>&2 2>&3)

							exitstatus=$?
							if [ $exitstatus == 0 ]; then
								static_lib_dir_list=$static_lib_dir_list" "$new_static_lib_dir
							fi
							;;
						"2")
							while true 
							do
								unset static_lib_dirs
								for static_lib_dir in $static_lib_dir_list
								do
									static_lib_dirs_num=`expr ${#static_lib_dirs[*]} / 2 + 1`
									static_lib_dirs[${#static_lib_dirs[*]}]=$static_lib_dirs_num
									static_lib_dirs[${#static_lib_dirs[*]}]=$static_lib_dir
								done

								static_lib_dirs_num=`expr ${#static_lib_dirs[*]} / 2`
								OPTION=$(whiptail --title "Menu Dialog" --menu "删除头文件目录" 15 60 $static_lib_dirs_num "${static_lib_dirs[@]}" 3>&1 1>&2 2>&3)

								exitstatus=$?
								if [ $exitstatus != 0 ]; then
									echo "You chose Cancel."
									break
								fi

								index=$[$OPTION * 2 - 1]
								del_lib_dir=${static_lib_dirs[$index]}

								if (whiptail --title "Yes/No Box" --yesno "确定要移除 $del_lib_dir" 10 60) then
									static_lib_dir_list=`echo $static_lib_dir_list | sed "s#$del_lib_dir##g"`
								else
									echo "You chose No. Exit status was $?."
								fi
							done 
							;;
						"3")
							while true
							do
								unset static_lib_dirs
								for static_lib_dir in $static_lib_dir_list
								do
									static_lib_dirs_num=`expr ${#static_lib_dirs[*]} / 2 + 1`
									static_lib_dirs[${#static_lib_dirs[*]}]=$static_lib_dirs_num
									static_lib_dirs[${#static_lib_dirs[*]}]=$static_lib_dir
								done

								static_lib_dirs_num=`expr ${#static_lib_dirs[*]} / 2`
								OPTION=$(whiptail --title "Menu Dialog" --menu "查看静态库目录" 15 60 $static_lib_dirs_num "${static_lib_dirs[@]}" 3>&1 1>&2 2>&3)

								exitstatus=$?
								if [ $exitstatus != 0 ]; then
									echo "You chose Cancel."
									break
								fi
							done
						;;
					esac
				done
				;;
			">头文件目录列表")
				while true
				do
					OPTION=$(whiptail --title "Menu Dialog" --menu "头文件目录" 15 60 3 \
					"1" "添加头文件目录" \
					"2" "删除头文件目录" \
					"3" "头文件目录列表" \
					3>&1 1>&2 2>&3)

					exitstatus=$?
					if [ $exitstatus != 0 ]; then
						echo "You chose Cancel."
						break
					fi

					case $OPTION in
						"1")
							new_header_dir=$(whiptail --title "添加头文件目录" --inputbox "添加头文件目录" 10 60 3>&1 1>&2 2>&3)

							exitstatus=$?
							if [ $exitstatus == 0 ]; then
								header_dir_path_list=$header_dir_path_list" "$new_header_dir
							fi
						;;
						"2")
							while true 
							do
								unset header_dirs
								for header_dir in $header_dir_path_list
								do
									header_dirs_num=`expr ${#header_dirs[*]} / 2 + 1`
									header_dirs[${#header_dirs[*]}]=$header_dirs_num
									header_dirs[${#header_dirs[*]}]=$header_dir
								done

								header_dirs_num=`expr ${#header_dirs[*]} / 2`
								OPTION=$(whiptail --title "Menu Dialog" --menu "删除头文件目录" 15 60 $header_dirs_num "${header_dirs[@]}" 3>&1 1>&2 2>&3)

								exitstatus=$?
								if [ $exitstatus != 0 ]; then
									echo "You chose Cancel."
									break
								fi

								index=$[$OPTION * 2 - 1]
								del_header_dir=${header_dirs[$index]}

								if (whiptail --title "Yes/No Box" --yesno "确定要移除 $del_header_dir" 10 60) then
									header_dir_path_list=`echo $header_dir_path_list | sed "s#$del_header_dir##g"`
								else
									echo "You chose No. Exit status was $?."
								fi
							done 
							;;
						"3")
							while true 
							do
								unset header_dirs
								for header_dir in $header_dir_path_list
								do
									header_dirs_num=`expr ${#header_dirs[*]} / 2 + 1`
									header_dirs[${#header_dirs[*]}]=$header_dirs_num
									header_dirs[${#header_dirs[*]}]=$header_dir
								done

								header_dirs_num=`expr ${#header_dirs[*]} / 2`
								OPTION=$(whiptail --title "Menu Dialog" --menu "查看头文件目录" 15 60 $header_dirs_num "${header_dirs[@]}" 3>&1 1>&2 2>&3)

								exitstatus=$?
								if [ $exitstatus != 0 ]; then
									echo "You chose Cancel."
									break
								fi
							done 
						;;
					esac
				done
				;;
			">当前程序入口文件: ")
				unset program_entry_files #清空数组元素，防止下次循环回来数组元素添加出现叠加现象
				for entry_file in $program_entry_file_list
				do
					program_entry_files_num=`expr ${#program_entry_files[*]} / 2 + 1`
					program_entry_files[${#program_entry_files[*]}]=$program_entry_files_num
					program_entry_files[${#program_entry_files[*]}]=$entry_file
				done

				program_entry_files_num=`expr ${#program_entry_files[*]} / 2`
				OPTION=$(whiptail --title "Menu Dialog" --menu "选择程序入口文件" 15 60 $program_entry_files_num ${program_entry_files[@]}  3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					continue
				fi

				index=$[$OPTION * 2 - 1]
				current_program_entry_file=${program_entry_files[$index]}
				;;
			">当前生成文件类型: ")
				OPTION=$(whiptail --title "Menu Dialog" --menu "生成文件类型" 15 60 3 \
				"1" "exe" \
				"2" "static_lib" \
				"3" "shared_lib" \
				3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					continue
				fi

				if [ $OPTION == "1" ];then
					current_generate_file_type="exe"
				elif [ $OPTION == "2" ];then
					current_generate_file_type="static_lib"
				else
					current_generate_file_type="shared_lib"
				fi
				;;
			">当前编译器: ")
				unset choose_compiler #清空数组元素，防止下次循环回来数组元素添加出现叠加现象
				for compile in $compiler_list
				do
					compile_num=`expr ${#choose_compiler[*]} / 2 + 1`
					choose_compiler[${#choose_compiler[*]}]=$compile_num
					choose_compiler[${#choose_compiler[*]}]=$compile
				done

				compile_num=`expr ${#choose_compiler[*]} / 2`
				OPTION=$(whiptail --title "Menu Dialog" --menu "选择编译器" 15 60 $compile_num "${choose_compiler[@]}"  3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					continue
				fi
				index=$[$OPTION * 2 - 1]
				current_compiler=${choose_compiler[$index]}
				;;
			">编译方式: ")
				OPTION=$(whiptail --title "选择编译方式" --menu "选择编译方式" 15 60 2 \
				"1" "debug" \
				"2" "release" \
				3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					continue
				fi

				if [ $OPTION == "1" ];then
					compile_method="debug"
				else
					compile_method="release"
				fi
			;;
			">debug编译选项: ")
				compile_option=$(whiptail --title "Debug编译器选项" --inputbox "注意：不要去掉最前面的'#'" 10 60 "$debug_compile_option" 3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					continue
				fi
				debug_compile_option=$compile_option
			;;
			">release编译选项: ")
				compile_option=$(whiptail --title "Release编译器选项" --inputbox "注意：不要去掉最前面的'#'" 10 60 "$release_compile_option" 3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					continue
				fi
				release_compile_option=$compile_option
			;;
			">程序参数: ")
				option=$(whiptail --title "程序参数" --inputbox "注意：不要去掉最前面的'#', 参数中不要有'#'符号" 10 60 "$program_run_param" 3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					continue
				fi
				program_run_param=$option
			;;
		esac
	done

	set_obj_val 项目名称 "$project_name"
	set_obj_val 项目路径 "$project_path"
	set_obj_val 当前编译器 "$current_compiler"
	set_arr_all 可选编译器列表 "$compiler_list"
	set_obj_val 编译方式 "$compile_method"
	set_obj_val debug版编译选项 "$debug_compile_option"
	set_obj_val release版编译选项 "$release_compile_option"
	set_obj_val 当前生成文件类型 "$current_generate_file_type"
	set_obj_val 当前程序入口文件 "$current_program_entry_file"
	set_arr_all 程序入口文件列表 "$program_entry_file_list"
	set_arr_all 头文件目录列表 "$header_dir_path_list"
	set_arr_all 静态库目录列表 "$static_lib_dir_list"
	set_arr_all release静态库列表 "$release_static_lib_list"
	set_arr_all debug静态库列表 "$debug_static_lib_list"
	set_arr_all 源文件目录列表 "$src_file_dir_list"
	set_obj_val 项目UUID "$project_uuid"
	set_obj_val 程序参数 "$program_run_param"
}

# config_project_config