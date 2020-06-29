#!/bin/bash

#将这个项目安装到指定目录下方便其他地方也可以获取

INSTALL_PATH=/usr/local/bin

TMP_PROJECT_INFO=$HOME/.current_project.tmp
sudo touch $TMP_PROJECT_INFO
sudo chmod  777 $TMP_PROJECT_INFO
echo "install_path=$INSTALL_PATH" > $TMP_PROJECT_INFO

sudo cp -rf ./script/ $INSTALL_PATH/
sudo cp -f project.sh $INSTALL_PATH/project
sudo chmod 755 $INSTALL_PATH/project

cd $INSTALL_PATH
for script in `ls ./script/`
do
    sudo rm $script
    sudo ln -sv ./script/$script $script
    sudo chmod 755 $script
done