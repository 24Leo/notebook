Python执行系统命令的方法: ```os.system()，os.popen()，commands```<br>
Python执行其他程序的方法: ```subprocess```
```python
#test.sh
#!/bin/bash
echo "hello world!"
exit 3
```
1. 
execfile("filename")
```python
execfile(/home/leo/maple/test.sh)
```
1. 
os.system([cmd]):执行状态
```python
该方法在调用完shell脚本后，返回一个16位的二进制数，低位为杀死所调用脚本的信号号码，高位为脚本的退出状态
码，即脚本中“exit 1”的代码执行后，os.system函数返回值的高位数则是1，如果低位数是0的情况下，则函数的返回值
是0×100,换算为10进制得到256。
如果我们需要获得os.system的正确返回值，那使用位移运算可以还原返回值：
n = os.system(test.sh)
n >> 8
3
```
1. 
os.popen(cmd): 输出
```python
通过 os.popen() 返回的是 file-read 的对象，对其进行读取 read() 的操作可以看到执行的输出。
这种调用方式是通过管道的方式来实现，函数返回一个file-like的对象，里面的内容是脚本输出的内容
    （可简单理解为echo输出的内容）。```
1. 
commands:输出和返回值 
```python
(status, output) = commands.getstatusoutput('cat /proc/cpuinfo')
print status, output
======================example:
import commands
commands.getstatusoutput('ls /bin/ls')
(0, '/bin/ls')
commands.getstatusoutput('cat /bin/junk')
(256, 'cat: /bin/junk: No such file or directory')
commands.getstatusoutput('/bin/junk')
(256, 'sh: /bin/junk: not found')
commands.getoutput('ls /bin/ls')
'/bin/ls'
commands.getstatus('/bin/ls')
'-rwxr-xr-x 1 root 13352 Oct 14 1994 /bin/ls'
```
1. 
subprocess：其他程序
```python
1)call()
　　　　subprocess.call(['mkdir','name']，shell=True)
2)check_output()：输出结果
　　　　output=subprocess.check_output(['ls','-a'])
3)Popen()：调用其他程序
　　　　cmd = ["./out","i", "leo", "zhang"]
　　　　fd=subprocess.Popen(cmd,stdout=subprocess.PIPE,shell=False)
　　　　print fd.stdout.read()
　　　　print fd.poll()
　　　　print fd.wait()
　　　　fd.returncode
```
1. 
python3.5提供了run()也可以



[返回目录](README.md)