#!/bin/bash

if [ $# -ne 1 ]
then
    echo "$0 project_name workspace_path"
    exit 1
fi

cd $1
project_name=$1
project_path=`pwd`

cd .proj_config
touch proj_config.sh
project_uuid=`uuidgen`
echo "#!/bin/bash" > proj_config.sh
echo "" >> proj_config.sh
echo "# basic config" >> proj_config.sh
echo "export PROJ_PROJECT_PATH=$project_path" >> proj_config.sh
echo "export PROJ_VSCODE_CONFIG_PATH=\$PROJ_PROJECT_PATH/.vscode" >> proj_config.sh
echo "export PROJ_UUID=$project_uuid" >> proj_config.sh
echo "export PROJ_PROJECT_NAME=$project_name" >> proj_config.sh
#echo "export PROJ_EXEC_NAME=\${PROJ_PROJECT_NAME}_exe" >> proj_config.sh
#echo "export PROJ_EXEC_ARGS=\"\"" >> proj_config.sh 
echo "export PROJ_LIB_NAME=\${PROJ_PROJECT_NAME}" >> proj_config.sh
echo "export PROJ_CMAKE_FILE=CMakeLists.txt" >> proj_config.sh
#echo "export PROJ_LIB_LINK_LIST=\"\"" >> proj_config.sh
echo "export PROJ_LIB_OUTPUT_DIR=\$PROJ_PROJECT_PATH/output" >> proj_config.sh
echo "export PROJ_BIN_OUTPUT_DIR=\$PROJ_PROJECT_PATH/output" >> proj_config.sh
echo "" >> proj_config.sh
echo "#compile and debug config" >> proj_config.sh
echo "export COMPILE_SCRIPT_NAME=project" >> proj_config.sh
echo "export COMPILE_SCRIPT_PATH=project" >> proj_config.sh
echo "export COMPILE_SCRIPT_ARGS=\"-r\"" >> proj_config.sh
echo "" >> proj_config.sh

chmod u+x proj_config.sh

exit 0