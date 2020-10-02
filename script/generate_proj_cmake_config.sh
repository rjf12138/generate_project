#!/bin/bash

# 导入接口读取函数
source ./project_config_manager.sh

export_file_type=`print_obj_val 当前生成文件类型`
compile_method=`print_obj_val 编译方式`
compiler=`print_obj_val 当前编译器`
if [ compile_method == "release" ]
then
    compile_option=`print_obj_val release版编译选项`
elif [ compile_method == "debug" ]
then
    compile_option=`print_obj_val debug版编译选项`
else
    echo "Unknown option: $compile_option"
    exit 1
fi

program_entry_file=`print_obj_val 当前程序入口文件`
head_file_dirs=`print_arr_vals 头文件目录列表`
static_libs=`print_arr_vals 静态库目录列表`
src_files=`print_arr_vals 源文件目录列表`

