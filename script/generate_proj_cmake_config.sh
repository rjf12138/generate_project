#######################################################
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

# 导入接口读取函数
source ./project_config_manager.sh

project_name=`print_obj_val 项目名称` 
export_file_type=`print_obj_val 当前生成文件类型`
compile_method=`print_obj_val 编译方式`
compiler=`print_obj_val 当前编译器`

if [ compile_method == "release" ]
then
    static_libs=`print_arr_vals release静态库列表`
    compile_option=`print_obj_val release版编译选项`
elif [ compile_method == "debug" ]
then
    static_libs=`print_arr_vals debug静态库列表`
    compile_option=`print_obj_val debug版编译选项`
else
    echo "Unknown option: $compile_option"
    exit 1
fi

program_entry_file=`print_obj_val 当前程序入口文件`
head_dirs=`print_arr_vals 头文件目录列表`
src_dirs=`print_arr_vals 源文件目录列表`

# 创建主cmake文件
main_cmakelists_path='./CMakeLists.txt'
touch ./CMakeLists.txt
echo "project($project_name)" > $main_cmakelists_path
echo "cmake_minimum_required(VERSION 3.10)" >> $main_cmakelists_path
echo "" >> $main_cmakelists_path

#添加编译选项
compile_option=`echo $compile_option > sed 's/#//g'` 
echo "add_compile_options($compile_option)" >> $main_cmakelists_path

#添加头文件目录
for head_dir in $head_dirs
do
    echo "include_directories($head_dir)" >> $main_cmakelists_path
done

#添加源文件目录
for src_dir in $src_dirs
do
    echo "add_subdirectory($src_dir)" >> $main_cmakelists_path
done

#添加链接库目录
https://blog.csdn.net/zhuiyunzhugang/article/details/88142908