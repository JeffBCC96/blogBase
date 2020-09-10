---
title: "SED and AWK command lines"
date: 2020-09-10T17:20:13-04:00
draft: false
description: ""
tags: [
    "Linux",
    "SED",
    "AWK"
]
type: "post"
---

这里我罗列了sed 和 awk 常用的命令和用法。
<!--more-->

### 1. SED

sed 比较适合处理以行为单位的数据

#### 1.1 基本结构

`	sed options script file`

<img src="../image-20200908224021456.png" alt="image-20200908224021456" style="zoom:50%;" />

注释 

​	-e: 允许多个命令



#### 1.2 基础命令

1. <mark>替换</mark> `s/pattern/replacement/flags`  flags: 数字(要替换第几处), g(全局), p(打印), w(将替换结果写入指定文件)

   - `sed 's/test/trial/' data4.txt`
   - `sed 's/test/trial/2' data4.txt` 
   - `sed -n 's/test/trial/p' data5.txt` -n 是禁止sed编辑器输出，最后结果是只输出替换过后的行
   - `sed 's/test/trial/w test.txt' data5.txt` 将替换结果保存在data5.txt
   - `sed 's!/bin/bash!/bin/csh!' /etc/passwd` 这样可以方便替换包含 '/' 的字符串，相当于用！来分割 要替换的和将要替换的内容

2.  <mark>地址</mark>

   - `sed '2s/dog/cat/' data1.txt` 替换第二行

   - `sed '2,3s/dog/cat/' data1.txt` 2-3行

   - `sed '2,$s/dog/cat/' data1.txt` 2-末尾

   - `sed '/Samantha/s/bash/csh/' /etc/passwd` 文本过滤器， 只匹配 有Samantha 的行

   - 命令组合 

     ```shell
     所有命令作用到 3-最后
     $ sed '3,${
     > s/brown/green/
     > s/lazy/active/
     > }' data1.txt
     ```

3. <mark>删除</mark>

   - `sed '3d' data6.txt`
   - `sed '3,$d' data6.txt` 
   - `sed '/number 1/d' data6.txt`

4. <mark>插入和附加</mark>

   - `echo "Test Line 2" | sed 'i\Test Line 1'` 插在 Test Line 1 的前面
   - `echo "Test Line 2" | sed 'a\Test Line 1'`  后面
   - `sed '3i\  This is an inserted line.' data6.txt` 插在第三行前
   - `sed '$a\  This is an inserted line.' data6.txt` 插在最后
   - `sed '1i\ xajskjakjsdkj' data6.txt` 插在开头

5. <mark>修改</mark>

   - `sed '3c\ This is a changed line of text.' data6.txt` 
   - `sed '/number 3/c\ ajsdjaasd' data6.txt ` 匹配模式修改

6. 转换命令

   `[address]y/inchars/outchars/`

   - `sed 'y/123/789/' data8.txt ` 将文本中所有123转化成789

7. 打印

   - `sed -n '2,3p' data6.txt`

   - `sed '=' data.txt` 打印行号和内容，两者不在同一行， 常用方法：

     ```shell
     $ sed -n '/number 4/{ 
     >=
     >p
     > }' data6.txt
     4
     This is line number 4. 
     $
     ```

   - `sed -n 'l' data.txt ` 将'\t' 之类的符号显示出来

8. 文件处理

   1. 写入 `[address]w filename`

      - `sed '1,2w test.txt' data6.txt`
      - `sed -n '/Browncoat/w Browncoats.txt' data11.txt`

   2. 读取 `[address] r filename`

      - `sed '3r data12.txt' data6.txt` 将data12中的内容查到data6的第三行后

      ```shell
      # 经典案例 将LIST 变成动态内容
      $ cat notice.std
      Would the following people:
      LIST
      please report to the ship's captain. 
      $
      
      $ sed '/LIST/{
      > r data11.txt
      >d
      > }' notice.std
      Would the following people:
      Blum, R Browncoat
      McGuiness, A Alliance
      Bresnahan, C Browncoat
      Harken, C Alliance
      please report to the ship's captain. 
      $
      ```



#### 1.3 进阶命令

1. 多行命令 N(加入数据流中的下一行); D(删除多行组中的一行); P (打印多行组中的一行)

   - 单行next 命令 `sed '/header/{n ; d}' data1.txt` 找到header 所在行，并删除它下一行的内容

   - 多行版next, 将下一文本行的内容添加到已有内容中。`sed '/first/{ N ; s/\n/ / }' data2.txt`

   - 多行删除 `sed 'N ; /System\nAdministrator/D' data4.txt` 只删除模式空间中的第一行，会删到换行符为止

     比如只删除文本中第一行空白行 `sed '/^$/{N ; /header/D}' data5.txt` 

   - 多行打印 只打印多行模式空间中的第一行 `sed -n 'N ; /System\nAdministrator/P' data3.txt` 

2. 保持空间

   - hold space  可以作为缓冲区域 

   <img src="../image-20200910100015392.png" alt="image-20200910100015392" style="zoom:50%;" />

   - `sed -n '/first/ {h ; p ; n ; p ; g ; p }' data2.txt`

3. 排除命令 ！ 

   - `sed -n '/header/!p' data2.txt` 不打印匹配到header 的这一行
   - 将文本从下到上打印 `sed -n '{1!G ; h ; $p }' data2.txt`

4. 分支命令

   - `[address]b [label]` address 表示哪些行会出发分支命令，也就是跳转到标签位置。如果标签位置没有表明，则跳转到脚本结尾

   - `:label` 代表标签

   - `sed '{2,3b ; s/This is/Is this/ ; s/line./test?/}' data2.txt` 第2，3行就没有被更改

   - ```shell
     一直修改第一次出现逗号的地方，直到没有逗号出现
     $ echo "This, is, a, test, to, remove, commas." | sed -n '{ 
     > :start
     > s/,//1p
     > /,/b start
     > }'
     ```

5. 测试命令

   - 和分支命令类似

   - ```shell
     $ sed '{
     > s/first/matched/
     >t
     > s/This is the/No match on/ 
     > }' data2.txt
     No match on header line
     This is the matched data line No match on second data line No match on last line
     $
     ```

6. 模式替代

   - & 符号

     `echo "the cat sleeps in his hat" | sed 's/.at/"&"/g'` 这里& 相当于替代了前面pattern 匹配到的文本， 然后再给这个文本加上了一个双引号。

#### 1.4 常用工具

1. 加倍行距 `sed '$!G' data2.txt` 最后一行不加空行

2. 加上行编号并和内容输出在同一行 `sed '=' data2.txt | sed 'N; s/\n/ /'`

   其他方式也可以 `nl data2.txt` 或者 `cat -n data2.txt`

3. 打印末尾行 `sed -n '$p' data2.txt`

4. 删除连续空白行 `sed '/./,/^$/!d' data8.txt` 匹配从有任意字符的行到一个空白行不删，其他的都删

5. 删除开头空白行 `sed '/./,$!d'` 从任意含有字符的行开始，到结束都不删除。 等于删除开头空白行

6. 删除结尾空白行 

   ```shell
   sed '{
   :start
   /^\n*$/{$d; N; b start } 
   }'
   ```

7. 删除html 标签`sed 's/<[^>]\*>//g ; /^$/d' data11.txt`



---

### 2. AWK

#### 2.1 基本概念

1. 内建变量

   <img src="../image-20200910133534165.png" alt="image-20200910133534165" style="zoom:50%;" />

2. 数据变量

   <img src="../image-20200910133731272.png" alt="image-20200910133731272" style="zoom:50%;" />

   Tips: 当输入文件数量大于1 时， NR 会累计行数 但是FNR 会重置行数

3. 处理数组

   1. ```shell
       $ gawk 'BEGIN{
          > capital["Illinois"] = "Springfield"
          > print capital["Illinois"]
          > }'
          Springfield
          $
      ```

   2. ```shell
      # 遍历数组
      $ gawk 'BEGIN{
      > var["a"] = 1
      > var["g"] = 2
      > var["m"] = 3
      > var["u"] = 4
      > for (test in var) >{
      	> print "Index:",test," - Value:",var[test] >}
      > }'
      Index: u - Value: 4
      Index: m - Value: 3 
      Index: a - Value: 1 
      Index: g - Value: 2 
      $`
      ```

   3. 删除数组 `delete array[index]`

#### 2.2 使用模式

1. 匹配

   `gawk -F: '$1 ~ /rich/{print $1,$NF}' /etc/passwd`

   `gawk –F: '$1 !~ /rich/{print $1,$NF}' /etc/passwd`

2. 数学表达

   `gawk -F: '$4 == 0{print $1}' /etc/passwd`

#### 2.3 结构化语言

1. if 

   ```shell
   $ gawk '{
   > if ($1 > 20) 
   >{
   > x=$1*2 
   > print x 
   >}else{
   > print "no"
   >}
   >}' data4
   100
   68
   $
   ```

2. while 

   ```shell
   $ gawk '{
   > total = 0
   >i=1
   > while (i < 4)
   >{
   > total += $i
   > if(i == 2)
   >  break
   > i++
   >}
   > avg = total / 2
   > print "The average of the first two data elements is:",avg 
   > }' data5
   The average of the first two data elements is: 125
   The average of the first two data elements is: 136.5
   The average of the first two data elements is: 157.5
   $
   
   ```

3. for 

   ```shell
   $ gawk '{
   > total = 0
   > for (i = 1; i < 4; i++) >{
   > total += $i
   >}
   > avg = total / 3
   > print "Average:",avg
   > }' data5
   Average: 128.333
   Average: 137.667
   Average: 176.667
   $
   ```

#### 2.4 结构化打印

- `print "xxx asd a %e", data` 

  <img src="../image-20200910135323243.png" alt="image-20200910135323243" style="zoom:50%;" />

#### 2.5 内建函数

1. 数学函数<img src="../image-20200910135625044.png" alt="image-20200910135625044" style="zoom:50%;" />

2. 字符串函数 

   <img src="../image-20200910135648352.png" alt="image-20200910135648352" style="zoom:70%;" />

   <img src="../image-20200910135709295.png" alt="image-20200910135709295" style="zoom:70%;" />

3. 时间函数

   <img src="../image-20200910135757621.png" alt="image-20200910135757621" style="zoom:70%;" />

4. 创建并使用自定义函数

   ```shell
   > gawk ' 
   > function myprint() 
   > {
   > printf "%-16s - %s\n", $1, $4
   >}
   > BEGIN{FS="\n"; RS=""} 
   >{
   > myprint()
   > }' data2
   Riley Mullen - (312)555-1234 
   Frank Williams - (317)555-9876 
   Haley Snell - (313)555-4938
   $
   
   ```

   

---

### 3. 正则匹配以及附加内容

- \+ 一次以上 ； 
- ？0次或者1次 ； 
- \* 多次；
- {数字} 重复次数; 
- (xxx) 分组表达，将括号内看成一个整体
- | 或的意思

<img src="../image-20200908232812463.png" alt="image-20200908232812463" style="zoom:50%;" />

- 数组 `a = (1,2,3,4,5) 或者 a = {1..5}`


