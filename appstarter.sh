#!/usr/bin/env bash

rm ~/.pm2/logs/*
pm2 delete all

cd ~/me
pm2 start me.js

cd ~/acw
pm2 start acw.js #-i 2

cd ~/ghost
pm2 start index.js

pm2 logs

