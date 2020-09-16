########################################################
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
COMPILE_CONFIG_PATH=$PROJ_PROJECT_PATH/.proj_config/compile_config.json
JSON_PARSE=$PROJ_PROJECT_PATH/.proj_config/parse_json
cd $PROJ_PROJECT_PATH

###########################################################################
# JSON 解析封装函数
# # 只能打印根节点下级数组的全部对象
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


if [ -z `$JSON_PARSE $COMPILE_CONFIG_PATH 项目md5编码`];then
    compile_method=$1  # debug or release
    generate_file_type="exe" # static_lib/share_lib/exe
    compiler="g++"
    release_compile_option="-O2 -Wall -std=c++11"
    debug_compile_option="-O0 -Wall -g -ggdb -std=c++1"
    head_file_path=$PROJ_PROJECT_PATH/inc
    lib_file_path=$PROJ_PROJECT_PATH/lib/$compile_method
    exe_file_list=`ls ./main/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
    src_file_list=`ls ./src/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
    static_lib_file_list=`cd ./lib/$compile_method/; ls *.a | tr -s " " | awk '{ORS=" "; print $1}'`
    share_lib_file_list=`cd ./lib/$compile_method/; ls *.so | tr -s " " | awk '{ORS=" "; print $1}'`
else
    #从json配置文件中读取
    compile_method=`print_obj_val 编译方式`
    generate_file_type=`print_obj_val 生成文件类型`
    compiler=`print_obj_val 编译器`
    release_compile_option=`print_obj_val release版编译选项`
    debug_compile_option=`print_obj_val debug版编译选项`
    head_file_path=`print_arr_all 头文件路径`
    lib_file_path=`print_arr_all 库文件路径`
    exe_file_list=`ls ./main/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
    src_file_list=`ls ./src/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
    static_lib_file_list=`cd ./lib/$compile_method/; ls *.a | tr -s " " | awk '{ORS=" "; print $1}'`
    share_lib_file_list=`cd ./lib/$compile_method/; ls *.so | tr -s " " | awk '{ORS=" "; print $1}'`
fi
