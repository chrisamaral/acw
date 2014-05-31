#!/usr/bin/env bash

clear
pm2 delete acw
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPTPATH/../server
pm2 start acw.js
pm2 logs acw
