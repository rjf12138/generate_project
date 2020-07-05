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

if [ -z `$JSON_PARSE $COMPILE_CONFIG_PATH 项目md5编码`];then
    compile_method=$1  # debug or release
    generate_file_type="exe" # static_lib/share_lib/exe
    compiler="g++"
    release_compile_option="-O2 -Wall -std=c++11"
    debug_compile_option="-O0 -Wall -g -ggdb -std=c++1"
    main_file_list=`ls ./main/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
    src_file_list=`ls ./src/ | tr -s \" \" | awk '{ORS=\" \"; print $1}'`
    static_lib_file_list=`cd ./lib/$compile_method/; ls *.a | tr -s " " | awk '{ORS=" "; print $1}'`
    share_lib_file_list=`cd ./lib/$compile_method/; ls *.so | tr -s " " | awk '{ORS=" "; print $1}'`
else
    #从json配置文件中读取
fi
