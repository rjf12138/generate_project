###########################################
# 修改項目的配置文件
###########################################
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
COMPILE_CONFIG_PATH=$PROJ_PROJECT_PATH/.proj_config/compile_config.json
JSON_PARSE=$PROJ_PROJECT_PATH/.proj_config/parse_json
cd $PROJ_PROJECT_PATH

###########################################################################
# JSON 解析封装函数
# # 只能打印当前节点以及其下级数组的元素
function print_obj_val()
{
echo '<< EOF
print $1
quit
EOF' | $JSON_PARSE $COMPILE_CONFIG | tr -d "\n"
}

function print_array_val()
{
echo '<< EOF
cd $1
print $2
quit
EOF' | $JSON_PARSE $COMPILE_CONFIG | tr -d "\n"
}

function print_array_all()
{
echo '<< EOF
cd $1
print $2
quit
EOF' | $JSON_PARSE $COMPILE_CONFIG | tr -d "\n"
}

###########################################################################
# exe_file_list=`ls ./main/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
# src_file_list=`ls ./src/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
# static_lib_file_list=`cd ./lib/$compile_method/; ls *.a | tr -s " " | awk '{ORS=" "; print $1}'`
# share_lib_file_list=`cd ./lib/$compile_method/; ls *.so | tr -s " " | awk '{ORS=" "; print $1}'`

function config_project_config()
{
	project_option=("项目名称", "项目路径", "当前编译器", "可选编译器列表", "编译方式", "debug版编译选项",
					"release版编译选项", "当前生成文件类型", "可生成文件类型", "当前程序入口文件", "程序入口文件列表", 
					"头文件目录列表", "静态库目录列表", "源文件目录列表", "项目UUID")
    project_name=`print_obj_val 项目名称`
	project_path=`print_obj_val 项目路径`
	current_compiler=`print_obj_val 当前编译器`
	compiler_list=`print_arr_all 可选编译器列表`
	compile_method=`print_obj_val 编译方式`
	debug_compile_option=`print_obj_val debug版编译选项`
	release_compile_option=`print_obj_val release版编译选项`
	current_generate_file_type=`print_obj_val 当前生成文件类型`
	generate_file_type_list=`print_arr_val 可生成文件类型`
	current_program_entry_file=`print_obj_val 当前程序入口文件`
	program_entry_file_list=`print_arr_val 程序入口文件列表`
	header_file_path_list=`print_arr_val 头文件目录列表`
	static_lib_dir_list=`print_arr_val 静态库目录列表`
	src_file_dir_list=`print_arr_val 源文件目录列表`
	project_uuid=`print_obj_val 项目UUID`

	while true
	do
		project_config_info=("*项目名称: ", $project_name, "*项目UUID: ", $project_uuid, "*项目路径: ", $project_path, 
								">当前编译器: ", $current_compiler, ">编译方式: ", $compile_method, ">debug版编译选项: ", $debug_compile_option,
								">release版编译选项: ", $release_compile_option, ">当前生成文件类型: ", $current_generate_file_type,
								">当前程序入口文件: ",  $current_program_entry_file, ">头文件目录列表", ""
								">静态库目录列表", "", ">源文件目录列表", "退出"， "")
		project_config_num=`expr ${#project_config_info[*]} / 2`
		OPTION=$(whiptail --title "Menu Dialog" --menu "项目配置" 15 60 $project_config_num "${project_config_info[@]}"  3>&1 1>&2 2>&3)

		exitstatus=$?
		if [ $exitstatus != 0 ]; then
			echo "You chose Cancel."
			break
		fi
		
		case $OPTION in
			"*项目名称: "|"*项目UUID: "|"*项目路径: ")
				continue
				;;
			">源文件目录列表")
				OPTION=$(whiptail --title "Menu Dialog" --menu "源文件目录" 15 60 2 \
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
					"添加源文件目录")
						new_dir=$(whiptail --title "添加源文件目录" --inputbox "" 10 60 3>&1 1>&2 2>&3)

						exitstatus=$?
						if [ $exitstatus != 0 ]; then
							echo "You chose Cancel."
							break
						fi
						
						src_file_dir_list=$src_file_dir_list" "$new_dir
						;;
					"删除源文件目录")
						for src_file in $src_file_dir_list
						do
							src_files_num=`expr ${#choose_compiler[*]} / 2`
							src_files[${#src_files[*]}]=$src_files_num
							src_files[${#src_files[*]}]=$src_file
							option_state[${#option_state[*]}]=OFF
						done

						src_files_num=`expr ${#src_files[*]} / 2`
						OPTION=$(whiptail --title "Menu Dialog" --checklist "删除源文件目录" 15 60 $src_files_num "${src_files[@]}" ${option_state[@]} 3>&1 1>&2 2>&3)

						exitstatus=$?
						if [ $exitstatus != 0 ]; then
							echo "You chose Cancel."
							break
						fi

						for del_file in $OPTION
						do
							src_file_dir_list=`echo $src_file_dir_list | sed "s/$del_file//g"`
						done
					"源文件目录列表")
						for src_file in $src_file_dir_list
						do
							src_files_num=`expr ${#choose_compiler[*]} / 2`
							src_files[${#src_files[*]}]=$src_files_num
							src_files[${#src_files[*]}]=$src_file
							option_state[${#option_state[*]}]=OFF
						done

						src_files_num=`expr ${#src_files[*]} / 2`
						OPTION=$(whiptail --title "Menu Dialog" --menu "删除源文件目录" 15 60 $src_files_num "${src_files[@]}" ${option_state[@]} 3>&1 1>&2 2>&3)

						exitstatus=$?
						if [ $exitstatus != 0 ]; then
							echo "You chose Cancel."
							break
						fi
				;;
			">静态库目录列表")
				OPTION=$(whiptail --title "Menu Dialog" --menu "静态库目录" 15 60 2 \
				"1" "添加静态库目录" \
				"2" "删除静态库目录" \
				"3" "静态库目录列表" \
				3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					break
				fi

				case $OPTION in
					"添加静态库目录")
						new_static_lib_dir=$(whiptail --title "添加静态库目录" --inputbox "" 10 60 3>&1 1>&2 2>&3)

						exitstatus=$?
						if [ $exitstatus != 0 ]; then
							echo "You chose Cancel."
							break
						fi
						
						static_lib_dir_list=$static_lib_dir_list" "$new_static_lib_dir
						;;
					"删除静态库目录")
						for static_lib_file in $static_lib_dir_list
						do
							static_lib_file_num=`expr ${#choose_compiler[*]} / 2`
							static_lib_file[${#static_lib_file[*]}]=$static_lib_file_num
							static_lib_file[${#static_lib_file[*]}]=$static_lib_file
							option_state[${#option_state[*]}]=OFF
						done

						static_lib_file_num=`expr ${#static_lib_file[*]} / 2`
						OPTION=$(whiptail --title "Menu Dialog" --checklist "删除静态库目录" 15 60 $static_lib_file_num "${static_lib_file[@]}" ${option_state[@]} 3>&1 1>&2 2>&3)

						exitstatus=$?
						if [ $exitstatus != 0 ]; then
							echo "You chose Cancel."
							break
						fi

						for del_file in $OPTION
						do
							static_lib_dir_list=`echo $static_lib_dir_list | sed "s/$del_file//g"`
						done
					"静态库目录列表")
						for static_lib_file in $static_lib_dir_list
						do
							static_lib_file_num=`expr ${#choose_compiler[*]} / 2`
							static_lib_file[${#static_lib_file[*]}]=$static_lib_file_num
							static_lib_file[${#static_lib_file[*]}]=$static_lib_file
						done

						static_lib_file_num=`expr ${#static_lib_file[*]} / 2`
						OPTION=$(whiptail --title "Menu Dialog" --menu "删除静态库目录" 15 60 $static_lib_file_num "${static_lib_file[@]}" 3>&1 1>&2 2>&3)

						exitstatus=$?
						if [ $exitstatus != 0 ]; then
							echo "You chose Cancel."
							break
						fi
				;;
			">头文件目录列表")
				OPTION=$(whiptail --title "Menu Dialog" --menu "头文件目录" 15 60 2 \
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
					"添加头文件目录")
						new_header_dir=$(whiptail --title "添加头文件目录" --inputbox "" 10 60 3>&1 1>&2 2>&3)

						exitstatus=$?
						if [ $exitstatus != 0 ]; then
							echo "You chose Cancel."
							break
						fi
						
						header_file_path_list=$header_file_path_list" "$new_header_dir
						;;
					"删除头文件目录")
						for header_file in $header_file_path_list
						do
							header_files_num=`expr ${#choose_compiler[*]} / 2`
							header_files[${#header_files[*]}]=$header_files_num
							header_files[${#header_files[*]}]=$header_file
							option_state[${#option_state[*]}]=OFF
						done

						header_files_num=`expr ${#header_files[*]} / 2`
						OPTION=$(whiptail --title "Menu Dialog" --checklist "删除头文件目录" 15 60 $header_files_num "${header_files[@]}" ${option_state[@]} 3>&1 1>&2 2>&3)

						exitstatus=$?
						if [ $exitstatus != 0 ]; then
							echo "You chose Cancel."
							break
						fi

						for del_head_file in $OPTION
						do
							header_file_path_list=`echo $header_file_path_list | sed "s/$del_head_file//g"`
						done
					"头文件目录列表")
						for header_file in $header_file_path_list
						do
							header_files_num=`expr ${#choose_compiler[*]} / 2`
							header_files[${#header_files[*]}]=$header_files_num
							header_files[${#header_files[*]}]=$header_file
							option_state[${#option_state[*]}]=OFF
						done

						header_files_num=`expr ${#header_files[*]} / 2`
						OPTION=$(whiptail --title "Menu Dialog" --menu "头文件目录" 15 60 $header_files_num "${header_files[@]}" 3>&1 1>&2 2>&3)

						exitstatus=$?
						if [ $exitstatus != 0 ]; then
							echo "You chose Cancel."
							break
						fi
				;;
			">当前程序入口文件: ")
				for entry_file in $program_entry_file_list
				do
					program_entry_files_num=`expr ${#choose_compiler[*]} / 2`
					program_entry_files[${#program_entry_files[*]}]=$program_entry_file_num
					program_entry_files[${#program_entry_files[*]}]=$entry_file
				done

				program_entry_files_num=`expr ${#program_entry_files[*]} / 2`
				OPTION=$(whiptail --title "Menu Dialog" --menu "选择程序入口文件" 15 60 $compile_num "${program_entry_files[@]}"  3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					break
				fi

				current_program_entry_file=$OPTION
				;;
			">当前生成文件类型: ")
				OPTION=$(whiptail --title "Menu Dialog" --menu "生成文件类型" 15 60 2 \
				"1" "exe" \
				"2" "static_lib" \
				"3" "shared_lib" \
				3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					break
				fi

				current_generate_file_type=$OPTION
				;;
			">当前编译器: ")
				for compile in $compiler_list
				do
					compile_num=`expr ${#choose_compiler[*]} / 2 `
					choose_compiler[${#choose_compiler[*]}]=$compile_num
					choose_compiler[${#choose_compiler[*]}]=$compile
				done

				compile_num=`expr ${#choose_compiler[*]} / 2`
				OPTION=$(whiptail --title "Menu Dialog" --menu "选择编译器" 15 60 $compile_num "${project_config_info[@]}"  3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					break
				fi

				current_compiler=$OPTION
				;;
			">编译方式: ")
				OPTION=$(whiptail --title "Menu Dialog" --menu "选择编译方式" 15 60 2 \
				"1" "debug" \
				"2" "release" \
				3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					break
				fi

				compile_method=$OPTION
			;;
			">debug版编译选项: ")
				compile_option=$(whiptail --title "Input Box" --inputbox "Debug编译器选项" 10 60 $debug_compile_option 3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					break
				fi
				debug_compile_option=$compile_option
			;;
			">release版编译选项: ")
				compile_option=$(whiptail --title "Input Box" --inputbox "Release编译器选项" 10 60 $ 3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus != 0 ]; then
					echo "You chose Cancel."
					break
				fi
				release_compile_option=$compile_option
			;;
		esac
	done
}