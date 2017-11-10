#!/bin/bash

SUBL_DESTTOP=/usr/share/applications/sublime_text.desktop
SUBL_STRING="LD_PRELOAD=\/opt\/sublime_text\/libsublime-imfix.so exec"
SUBL_CONF_DIR=~/.config/sublime-text-3

# 安装解决不能输入中文支持库
sudo apt-get install build-essential libgtk2.0-dev -y

# 将相关配置文件拷贝到相应的目录
cp -rf Default\ \(Linux\).sublime-keymap 	${SUBL_CONF_DIR}/Packages/User/
cp -rf Preferences.sublime-settings 		${SUBL_CONF_DIR}/Packages/User/
cp -rf Austzhu.tmTheme  			${SUBL_CONF_DIR}/Packages/

# 解决sublime不支持中文输入问题
if [ -f sublime-imfix.c ];then
	gcc -shared -o libsublime-imfix.so sublime-imfix.c  \
	`pkg-config --libs --cflags gtk+-2.0` -fPIC
	sudo mv libsublime-imfix.so /opt/sublime_text/ -f
fi

# 让sublime启动后支持中文输入
echo -e	"#!/bin/bash\n\n"\
"LD_PRELOAD=/opt/sublime_text/libsublime-imfix.so exec "\
"/opt/sublime_text/sublime_text \"\$@\"" > /usr/bin/subl

sudo sed -i "s/Exec=\(.*%F\)/Exec=bash -c \"${SUBL_STRING} \1\"/"	${SUBL_DESTTOP}
sudo sed -i "s/Exec=\(.*-n\)/Exec=bash -c \"${SUBL_STRING} \1\"/"	${SUBL_DESTTOP}
sudo sed -i "s/Exec=\(.*new_file\)/Exec=bash -c \"${SUBL_STRING} \1\"/"	${SUBL_DESTTOP}

