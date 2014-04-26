#!/usr/bin/env bash

#./client.compiler.sh
clear
rm ~/.pm2/logs/*
pm2 delete all
pm2 start acw.js
pm2 logs
