#!/usr/bin/env bash

#./client.compiler.sh
rm ~/.pm2/logs/*
pm2 delete all
pm2 start acw.js
sleep 2
pm2 logs
