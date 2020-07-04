#!/bin/bash
if [ $# -lt  1 ]; then
    echo "$0 <commit message>"
    exit 1
fi


msg="$1"
echo "$msg" 


