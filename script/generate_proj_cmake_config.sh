#######################################################
#   在项目的主目录生成主CMakeLists.txt
#   在 src 目录下生成用于生成库的CMakeLists.txt
#   在 main 目录下生成用于生成可执行文件的CMakeLists.txt
########################################################

#!/bin/bash

#########################################################
# 全局变量
TMP_PROJECT_INFO=$HOME/.current_project.tmp
INSTALL_PATH=`cat $TMP_PROJECT_INFO | grep install_path | awk -F[=] '{print $2}'`
CURRENT_PATH=`pwd`
##########################################################################
#加载项目的配置
source $INSTALL_PATH/project_config_manager.sh
PROJ_PROJECT_PATH=`print_obj_val 项目路径`
##########################################################################
cd $PROJ_PROJECT_PATH

project_name=`print_obj_val 项目名称` 
export_file_type=`print_obj_val 当前生成文件类型`
compile_method=`print_obj_val 编译方式`
compiler=`print_obj_val 当前编译器`

if [ "$compile_method" == "release" ]
then
    static_libs=`print_arr_all release静态库列表`
    compile_option=`print_obj_val release版编译选项`
elif [ "$compile_method" == "debug" ]
then
    static_libs=`print_arr_all debug静态库列表`
    compile_option=`print_obj_val debug版编译选项`
else
    echo "Unknown option: $compile_option"
    exit 1
fi

static_lib_dirs=`print_arr_all 静态库目录列表`
program_entry_file=`print_obj_val 当前程序入口文件`
head_dirs=`print_arr_all 头文件目录列表`
src_dirs=`print_arr_all 源文件目录列表`

# 创建主cmake文件
main_cmakelists_path=$PROJ_PROJECT_PATH/CMakeLists.txt
touch ./CMakeLists.txt
echo "project($project_name)" > $main_cmakelists_path
echo "cmake_minimum_required(VERSION 3.10)" >> $main_cmakelists_path
echo "" >> $main_cmakelists_path

#添加编译选项
compile_option=`echo $compile_option | sed 's/#//g'` 
echo "add_compile_options($compile_option)" >> $main_cmakelists_path
echo "" >> $main_cmakelists_path

#添加头文件目录
for head_dir in $head_dirs
do
    echo "include_directories($head_dir)" >> $main_cmakelists_path
done
echo "" >> $main_cmakelists_path

#添加链接库目录
for static_lib_dir in $static_lib_dirs
do
    echo "link_directories($static_lib_dir)" >> $main_cmakelists_path
done
echo "" >> $main_cmakelists_path

#添加源文件目录
gen_lib_lists=$static_libs

for src_dir in $src_dirs
do
    cd $PROJ_PROJECT_PATH
    cd $src_dir

    if [ $? != 0 ];then
        echo "Can't enter into $src_dir"
        continue
    fi
    
    # 添加子目录cmakelists.txt文件
    touch ./CMakeLists.txt
    echo "" > ./CMakeLists.txt
    # 判断是不是主函数目录
    
    is_main_dir=`echo $src_dir | grep main | tr -d ['\n']`
    is_entry_file=`ls | grep $program_entry_file | tr -d ['\n']`

    # 判断是不是项目下的 src 目录
    src_path=`pwd`
    if [ "$src_path" == "$PROJ_PROJECT_PATH/main" ] || [ "$src_path" == "$PROJ_PROJECT_PATH/src" ];then
        continue
    else
        is_empty_dir=`ls | grep -E '.cc|.cpp' |tr -d ['\n']`
        if [ -z $is_empty_dir ];then
            continue
        fi
        
        echo "project($project_name)" > ./CMakeLists.txt
        echo "" >> ./CMakeLists.txt
        echo "set(LIBRARY_OUTPUT_PATH $PROJ_PROJECT_PATH/output/$compile_method/lib)" >> ./CMakeLists.txt
        echo "" >> ./CMakeLists.txt
        echo "aux_source_directory(. DIR_LIB_SRCS)" >> ./CMakeLists.txt
        echo "" >> ./CMakeLists.txt

        # 根据时间戳设置临时库名称
        dirs=`echo $src_dir | sed 's#/# #g' | awk '{gsub(/^\s+|\s+$/, "");print}'`
        for dir in $dirs
        do
            lib_name=$dir
        done
        
        echo "add_library($lib_name \${DIR_LIB_SRCS})" >> ./CMakeLists.txt
        echo "" >> ./CMakeLists.txt

        gen_lib_lists=$gen_lib_lists" "$lib_name
        echo "add_subdirectory($src_dir)" >> $main_cmakelists_path
    fi
done

cd $PROJ_PROJECT_PATH/src
is_empty_dir=`ls | grep -E '.cc|.cpp' |tr -d ['\n']`
if [ ! -z $is_empty_dir ];then
    echo "project($project_name)" > ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    echo "set(LIBRARY_OUTPUT_PATH $PROJ_PROJECT_PATH/output/$compile_method/lib)" >> ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    echo "aux_source_directory(. DIR_LIB_SRCS)" >> ./CMakeLists.txt
        echo "" >> ./CMakeLists.txt

    echo "add_library ($project_name \${DIR_LIB_SRCS})" >> ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    for lib in $gen_lib_lists
    do
        echo "target_link_libraries($project_name -l$lib)" >> ./CMakeLists.txt
    done
    echo "" >> ./CMakeLists.txt
    gen_lib_lists=$project_name

    echo "add_subdirectory(./src/)" >> $main_cmakelists_path
fi


cd $PROJ_PROJECT_PATH
case $export_file_type in
"exe")
    if [ ! -f $PROJ_PROJECT_PATH/main/$program_entry_file ];then
        echo "Can't find program entry file"
        echo "Use 'project -cfg' to choose program entry file. "
        exit 1
    fi

    cd $PROJ_PROJECT_PATH/main
    echo "project($project_name)" >> ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    echo "set(EXECUTABLE_OUTPUT_PATH $PROJ_PROJECT_PATH/output/$compile_method/bin)" >> ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    exe_name=`echo $program_entry_file | awk -F[.] '{print $1}'`
    echo "add_executable($exe_name $program_entry_file)" >> ./CMakeLists.txt
    for lib in $gen_lib_lists
    do
        echo "target_link_libraries($exe_name -l$lib)" >> ./CMakeLists.txt
    done
    echo "" >> ./CMakeLists.txt
    echo "add_subdirectory(./main/)" >> $main_cmakelists_path
    
    cd $PROJ_PROJECT_PATH
    ;;
"static_lib")
    
    ;;
*)
    echo "Not support"
esac

exit 0
