#!/bin/bash

if [ $# -lt  1 ]; then
    echo "$0 <blog name>"
    exit 1
fi



msg="$1"

text="123 456"
# 关键！只有这样写，才能保存下来，并在之后的操作中使用。
pos=$(expr index $text '1')
echo "$pos"



# if [ $2 == "folder" ]; then 
#     echo "folder will be created"
#     mkdir $msg
    


echo -e "Your new blog name is $msg"

for file in `ls ~/rongBlog/content/post/`; do 
    if [ $msg == $file ]; then 
        echo -e "repeated name $msg"
        exit 1
    fi

done

hugo new ~/rongBlog/content/post/"$blogName"
code ~/rongBlog/content/post/"$blogName"


