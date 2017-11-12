#!/bin/bash

HOME_DIR=${HOME}
CUR_DIR=`pwd`

ln -sf ${CUR_DIR}/bashrc		${HOME_DIR}/.bashrc
ln -sf ${CUR_DIR}/vimrc			${HOME_DIR}/.vimrc
ln -sf ${CUR_DIR}/bash_completion	${HOME_DIR}/.bash_completion
ln -sf ${CUR_DIR}/dircolors		${HOME_DIR}/.dircolors
ln -sf ${CUR_DIR}/vim-plugin		${HOME_DIR}/.vim	
ln -sf ${CUR_DIR}/download		/opt/bin/download

