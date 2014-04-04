#!/bin/bash
cd /home/christian/acw/client

FILES=*.js
for f in $FILES
do
    echo "closure --js=$f --js_output_file=../public/js/build/$f"
    closure --js=$f --js_output_file=../public/js/build/$f 
done