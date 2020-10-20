#!/bin/bash

################################################################
# 全局变量
TMP_PROJECT_INFO=$HOME/.current_project.tmp
INSTALL_PATH=`cat $TMP_PROJECT_INFO | grep install_path | awk -F[=] '{print $2}'`
PROJ_PROJECT_PATH=`cat $TMP_PROJECT_INFO | grep project_path | awk -F[=] '{print $2}'`
BIN_PATH=`cat $TMP_PROJECT_INFO | grep gen_bin_path | awk -F[=] '{print $2}'`
CURRENT_PATH=`pwd`
################################################################
source $INSTALL_PATH/project_config_manager.sh
PROJ_EXEC_ARGS=`print_obj_val 程序参数 | sed 's/#//g'`
EXE_FILE_NAME=`print_obj_val 当前程序入口文件 | awk -F[.] '{print $1}'`
cd $PROJ_PROJECT_PATH/.vscode/
##########################################################################

echo "{"                                                                > tasks.json
echo "    // See https://go.microsoft.com/fwlink/?LinkId=733558"        >> tasks.json
echo "    // for the documentation about the tasks.json format"         >> tasks.json
echo "        \"tasks\": ["                                             >> tasks.json
echo "            {"                                                    >> tasks.json
echo "                \"type\": \"shell\","                             >> tasks.json
echo "                \"label\": \"compile script\","                   >> tasks.json
echo "                \"command\": \"project\","                        >> tasks.json
echo "                \"args\": ["                                      >> tasks.json
echo "                    \"-r\""                                       >> tasks.json
echo "                ],"                                               >> tasks.json
echo "                \"options\": {"                                   >> tasks.json
echo "                    \"cwd\": \"$PROJ_PROJECT_PATH\""              >> tasks.json
echo "                },"                                               >> tasks.json
echo "                \"group\": {"                                     >> tasks.json
echo "                    \"kind\": \"build\","                         >> tasks.json
echo "                    \"isDefault\": true"                          >> tasks.json
echo "                }"                                                >> tasks.json
echo "            }"                                                    >> tasks.json
echo "        ],"                                                       >> tasks.json
echo "        \"version\": \"2.0.0\""                                   >> tasks.json
echo "    }"                                                            >> tasks.json

echo "{"                                                                > launch.json
echo "   // Use IntelliSense to learn about possible attributes."       >> launch.json
echo "   // Hover to view descriptions of existing attributes."         >> launch.json
echo "   // For more information, visit: "                              >> launch.json
echo "   // https://go.microsoft.com/fwlink/?linkid=830387"             >> launch.json
echo "    \"version\": \"0.2.0\","                                      >> launch.json
echo "    \"configurations\": ["                                        >> launch.json 
echo "        {"                                                        >> launch.json
echo "            \"name\": \"gdb_debug\","                             >> launch.json
echo "            \"type\": \"cppdbg\","                                >> launch.json
echo "            \"request\": \"launch\","                             >> launch.json
echo "            \"program\": \"$BIN_PATH/$EXE_FILE_NAME\","           >> launch.json
echo "            \"args\": [\"$PROJ_EXEC_ARGS\"],"                     >> launch.json
echo "            \"stopAtEntry\": false,"                              >> launch.json
echo "            \"cwd\": \"$PROJ_PROJECT_PATH\","                     >> launch.json
echo "            \"environment\": [],"                                 >> launch.json
echo "            \"externalConsole\": false,"                          >> launch.json
echo "            \"MIMode\": \"gdb\","                                 >> launch.json
echo "            \"setupCommands\": ["                                 >> launch.json
echo "                {"                                                >> launch.json
echo "                    \"description\": \"\","                       >> launch.json
echo "                    \"text\": \"-enable-pretty-printing\","       >> launch.json    
echo "                    \"ignoreFailures\": true"                     >> launch.json
echo "                }"                                                >> launch.json
echo "            ]"                                                    >> launch.json
echo "        }"                                                        >> launch.json
echo "    ]"                                                            >> launch.json
echo "}"                                                                >> launch.json

exit 0