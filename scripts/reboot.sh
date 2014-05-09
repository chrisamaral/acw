#!/usr/bin/env bash

#./client.compiler.sh
clear
rm ~/.pm2/logs/*
pm2 delete all
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPTPATH/../server
pm2 start acw.js --watch
pm2 logs
