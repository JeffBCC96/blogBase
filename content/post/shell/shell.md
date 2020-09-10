---
title: "Shell"
date: 2020-09-10T17:19:54-04:00
draft: false
description: ""
tags: [
    "Linux",
    "Shell"
]
type: "post"
---


更多关于linux 和shell的知识。
<!--more-->


# Shell 常用命令

### 1. 处理用户输入

#### 1.1 参数

- 前9位参数都可以按照`$1 - $9` 来取，但是10位以后就要变成`${10}`. `$0` 是程序名。

  `$#` 特殊变量，查看总参数数量，但是当这个值附加成变量是要变成`${!#} 而不是 ${$#}`。 

  `$*` 返回所有参数，但是看做一个整体

  `$@` 返回所有参数，看出单独个体。 这两个的区别可以在 for loop中体现出来 `$@`会循环多次，而`$*` 只循环一次

- 字符串参数需要用引号括起来`./test.sh "your name is jeff"`

- `basename /home/rong/test.sh 只返回 test.sh` 

- 检查参数是否存在 `if [-n "$1"] then xxx else xxx fi `

- `shift 可以移动变量（默认向左移动）； shift 2 向左移两位` 

- 我们一般用case 来控制参数的选择, 用 -- 来隔断额外的参数 , 用赋值来提取option后面的信息

  ```shell
  $ cat test17.sh
  #!/bin/bash
  # extracting command line options and values echo
  while [ -n "$1" ]
  do
      case "$1" in
      -a) echo "Found the -a option";;
      -b) param="$2"
          echo "Found the -b option, with parameter value $param"
          shift ;;
      -c) echo "Found the -c option";;
      --) shift
          break ;;
      *) echo "$1 is not an option";;
  		esac
  		shift 
  done
  #
  count=1
  for param in "$@"
  do
  	echo "Parameter #$count: $param"
  	count=$[ $count + 1 ]
  done
  
  
  $ ./test17.sh -a -b test1 -d
          Found the -a option
  Found the -b option, with parameter value test1
  -d is not an option
  $
  ```

- getopt 也是可以控制参数的选取的命令

  ```shell
  # 通用写法 getopt optstring parameters 
  # :代表这个选项后面需要跟参数
  $ getopt ab:cd -a -b test1 -cd test2 test3 -a -b test1 -c -d -- test2 test3
  	-a -b test1 -c -d -- test2 test3
  $
  
  # set命令能够处理shell中的各种变量。 set命令的选项之一是双破折线(--)，它会将命令行参数替换成set命令的命令行值。 然后，该方法会将原始脚本的命令行参数传给getopt命令，之后再将getopt命令的输出传给set命令，用getopt格式化后的命令行参数来替换原始的命令行参数
  # 下面是演示
  
  $ cat test18.sh
  #!/bin/bash
  # Extract command line options & values with getopt #
  set -- $(getopt -q ab:cd "$@")   # <---- 唯一需要改变的
  # 其他代码与上面一样
  ```

- 更高级的是getopts, 会避免一些getopt 的错误

  ```shell
  #!/bin/bash
  # simple demonstration of the getopts command #
  echo
  while getopts :ab:c opt # <---- 在选项之前加冒号可以去掉错误信息
  do
      case "$opt" in
          a) echo "Found the -a option" ;;  #<-- getopts 会移除‘-’，所以case 只有选项本身就行了
          b) echo "Found the -b option, with value $OPTARG";; 
          c) echo "Found the -c option" ;;
          *) echo "Unknown option: $opt";;
  		esac 
  done
  $
  $ ./test19.sh -ab test1 -c
  Found the -a option
  Found the -b option, with value test1 Found the -c option
  $
  ```

- 常用参数标准含义：<img src="../image-20200907212942817.png" alt="image-20200907212942817" style="zoom:50%;" />

#### 1.2 用户输入

- read [-p (指定提示符或者变量名) -t (计时器，限定输入时间) -n1(限定输入的字符数只能是1) -s(隐藏读取，适用于密码输入) ]  相当于 python 里的 age = input('Please enter your age:  ')

  如果不指定，那就是存在 环境变量 $REPLY中

  ```shell 
  read -p "Please enter your age: " age 
  days=$[ $age * 365 ]
  echo "That makes you over $days days old! "
  
  # 利用while 来读取文本中的每一行
  $ cat test28.sh 
  #!/bin/bash
  # reading data from a file #
  count=1
  cat test | while read line do
     echo "Line $count: $line"
     count=$[ $count + 1]
  done
  echo "Finished processing the file"
  $
  ```



---

### 2. 呈现数据

#### 2.1 理解输入输出

- 0，1，2 为文件描述符(shell 一次只能有9个)， 被定义为标准输入，输出，以及错误

- 重定向

  - 只有错误 `ls -al badfile 2> test4`

  - 错误以及数据 `$ ls -al test test2 test3 badtest 2> test6 1> test7` 或者 

    写到同一个文件 `$ ls -al test test2 test3 badtest &> test7`

  - 临时重定向 在脚本中写 `echo "This is an error message" >&2` 将这一行就导入到错误输出中

  - 永久重定向 在脚本中加 `exec 1>testout #重定向输出； exec 2>testerror 重定向错误` 这样输出或者错误就被写入文件testout 或者 testerror 中

  - 重定向输入 `exec 0< testfile` 这样运行文本是就会在从testfile中提取内容

  - 利用shell 文件描述符， 输出结果到不同文件 

    ```shell
    exec 3>xxxx #定义
    echo "jeff genius" >&3 # 要加的信息
    
    或者 exec 3>>testout # 追加信息到已有文件
    ```

  - 重定向文件描述符 `2>&1` 这意思是将错误写到标准输出中

  - 经过重定向后，如何恢复原来的默认状态？ 这就需要一个锚点。如下所示：

    ```shell
    #!/bin/bash
    # redirecting input file descriptors
    
    exec 6<&0  # 增加锚点 6，记录0的位置
    exec 0< testfile 将输入导入现在的0 
    
    count=1 11 while read line
    do
    count=$[ $count + 1 ] 12 done
    
    exec 0<&6 # 将锚点6 的位置告诉现在的0,从而实现复原。 下面是测试复原成功与否。
    
    read -p "Are you done now? " answer
    case $answer in 13 Y|y) echo "Goodbye";;
    N|n) echo "Sorry, this is the end.";;
    esac
    ```

  - 关闭文件描述符，不能再将数据导入或者导出到其中 `exec 3>&-`

  - 显示当前所有的，在用的文件描述符 `/usr/sbin/lsof -a -p(允许指定pid) $$(进程的当前pid) -d(允许指定文件描述符编号) 0,1,2 `

  - 阻止输出 `xxxx > /dev/null` 这个文件相当于垃圾箱，输出到这里等于啥都没有。也可以用来清空文件里面的内容而不删除文件 `cat /dev/null > file_name` 

- 临时文件或者目录

  - 创建本地临时文件 `mktemp testing.XXXXXX` 这里6个X一定要加
  - 创建临时目录`mktemp -d dir.XXXXXX`

- 同时显示和记录

  - `tee -a (追加到文件，而不重写) filename` 如 `$ date | tee -a testfile` 



---

### 3. 控制脚本

#### 3.1 处理信号

- 显示进程 `ps 或者 top`; 终止进程 `kill <pid>` 
- SIGINT 信号 Ctrl+C 终止现在程序
- SIGTSTP 信号 Ctrl+Z 停止程序，并挂到后台 可以通过 `bg %1 #1只是模拟进程的作业号`; 通过`jobs` 查看分配给shell 的作业
- 捕获信号
  - 捕获信号 `trap commands signals 比如 trap "echo ' Sorry! I have trapped Ctrl-C'" SIGINT  ` 这样加在脚本中可以让外部终止命令被捕获从而被忽略，脚本继续运行
  - 捕获并且退出 `trap "echo Goodbye..." EXIT` 
  - 恢复默认设置`trap -- SIGINT`

#### 3.2 后台运行

- 终端退出就退出 `command &`
- 终端退出继续后台运行 `nohup command &` 并将输出导入 nohup.out
- 调整优先级 `nice  | renice `
- 定时作业 `at -M -f test13b.sh now/tomorrow/13:30` ； 查看作业队列 `atq`; 删除作业 `atrm xxx`
- 安排定期作业 cron时间表 `min hour dayofmonth month dayofweek command`
  - ```00 12 * * * if [`date +%d -d tomorrow` = 01 ] ; then ; command``` 检查每天是不是这个月最后一天



---

### 4. 创建函数

- 创建一个函数的例子

  ```shell
  function dbl {
  	read -p "Enter a value: " value 
    echo "doubling the value" 
    return $[ $value * 2 ]
  }
  dbl #运行函数
  echo "yes"
  ```

- 函数也可以使用$1, \$2 之类的， 但是需要传入值

  ```shell
  $ cat test7
  #!/bin/bash
  # trying to access script parameters inside a function
  function func7 {
  		echo $[ $1 * $2 ]
  }
  if [ $# -eq 2 ] 
  		then
         value=$(func7 $1 $2)
         echo "The result is $value"
      else
         echo "Usage: badtest1 a b"
  fi
  $
  $ ./test7
  Usage: badtest1 a b $ ./test7 10 15
  The result is 150
  $
  ```

- `source xxx.sh 或者 . xxxx.sh`   这样相当于引入function 库。 

- select 可以将输入变成menu

  ```shell
  PS3="Enter option: "
  select option in "Display disk space" "Display logged on users" "Display memory usage" "Exit program"
  do
     case $option in
     "Exit program")
           break ;;
     "Display disk space")
           diskspace ;;
     "Display logged on users")
           whoseon ;;
     "Display memory usage")
  				memusage ;;
  		*)
          clear
          echo "sorry, wrong selection" ;;
  		esac
  done
  ```

  