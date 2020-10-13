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
source ./project_config_manager.sh
PROJ_PROJECT_PATH=`print_obj_val 项目路径`
##########################################################################
cd $PROJ_PROJECT_PATH

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
echo "" >> $main_cmakelists_path

#添加头文件目录
for head_dir in $head_dirs
do
    echo "include_directories($head_dir)" >> $main_cmakelists_path
done
echo "" >> $main_cmakelists_path

#添加链接库目录
for head_dir in $head_dirs
do
    echo "link_directories($head_dir)" >> $main_cmakelists_path
done
echo "" >> $main_cmakelists_path

#添加源文件目录
gen_lib_lists=""
for src_dir in $src_dirs
do
    echo "add_subdirectory($src_dir)" >> $main_cmakelists_path
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
    if [ $src_path == $PROJ_PROJECT_PATH/main ];then
        # 记录下主函数所在目录
        main_dir=$src_dir
    else
        is_empty_dir=`ls *.cc *.cpp | tr -d ['\n']`
        if [ -z $is_empty_dir ];then
            continue
        fi
        
        echo "project($project_name)" >> ./CMakeLists.txt
        echo "" >> ./CMakeLists.txt
        echo "set(LIBRARY_OUTPUT_PATH $PROJ_PROJECT_PATH/output/$compile_method/lib)" >> ./CMakeLists.txt
        echo "" >> ./CMakeLists.txt
        echo "aux_source_directory(. DIR_LIB_SRCS)" >> ./CMakeLists.txt
        echo "" >> ./CMakeLists.txt

        # 根据时间戳设置临时库名称
        lib_name=`date +%s`
        if [ $src_path == $PROJ_PROJECT_PATH/src && $export_file_type == "exe" ];then
            # src 目录的库名称与项目名称相同，只有这个目录会链接其他库
            lib_name=$project_name
            for link_lib in $static_libs
            do
                echo "target_link_libraries($lib_name -l$link_lib)" >> ./CMakeLists.txt
            done
        else if [ $src_path == $PROJ_PROJECT_PATH/src ];then
            # 生成非可执行文件，src库cmakelists.txt之后在生成
            continue
        else
            echo "add_library ($lib_name ${DIR_LIB_SRCS})" >> ./CMakeLists.txt
            echo "" >> ./CMakeLists.txt
        fi

        gen_lib_lists=$gen_lib_lists" "$lib_name
    fi
    cd $PROJ_PROJECT_PATH
done

case $export_file_type in
"exe")
    if [ ! -f $PROJ_PROJECT_PATH/main/$program_entry_file ];then
        echo "Can't find program entry file"
        exit 1
    fi

    cd $PROJ_PROJECT_PATH/main
    echo "project($project_name)" >> ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    echo "set(LIBRARY_OUTPUT_PATH $PROJ_PROJECT_PATH/output/$compile_method/bin)" >> ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    for lib in $gen_lib_lists
    do
        echo "target_link_libraries($project_name -l$lib)" >> ./CMakeLists.txt
    done
    echo "" >> ./CMakeLists.txt

    echo "add_executable($project_name $program_entry_file)" >> ./CMakeLists.txt
    cd $PROJ_PROJECT_PATH
    ;;
"static_lib")
    cd $PROJ_PROJECT_PATH/src
    is_empty_dir=`ls *.cc *.cpp | tr -d ['\n']`
    if [ -z $is_empty_dir ];then
        echo "$src_path is empty"
        exit 1
    fi
    
    echo "project($project_name)" >> ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    echo "set(LIBRARY_OUTPUT_PATH $PROJ_PROJECT_PATH/output/$compile_method/lib)" >> ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    for lib in $gen_lib_lists
    do
        echo "target_link_libraries($project_name -l$lib)" >> ./CMakeLists.txt
    done
    echo "" >> ./CMakeLists.txt

    echo "add_library ($project_name ${DIR_LIB_SRCS})" >> ./CMakeLists.txt
    echo "" >> ./CMakeLists.txt

    cd $PROJ_PROJECT_PATH
    ;;
*)
    echo "Not support"
esac

exit 0
