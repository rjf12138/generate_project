#!/bin/bash

# basic config
export PROJ_PROJECT_PATH=/home/ruanjian/workspace/project/generate_project/compress
export PROJ_VSCODE_CONFIG_PATH=$PROJ_PROJECT_PATH/.vscode
export PROJ_UUID=2429fd73-1e3f-4f33-b433-e4e9c22bd44d
export PROJ_PROJECT_NAME=compress
export PROJ_EXEC_NAME=${PROJ_PROJECT_NAME}_exe
export PROJ_EXEC_ARGS=""
export PROJ_LIB_NAME=${PROJ_PROJECT_NAME}
export PROJ_CMAKE_FILE=CMakeLists.txt
export PROJ_LIB_LINK_LIST=""
export PROJ_LIB_OUTPUT_DIR=$PROJ_PROJECT_PATH/output
export PROJ_BIN_OUTPUT_DIR=$PROJ_PROJECT_PATH/output

#compile and debug config
export COMPILE_SCRIPT_NAME=project
export COMPILE_SCRIPT_PATH=project
export COMPILE_SCRIPT_ARGS="-r"

