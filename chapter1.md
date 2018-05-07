# First Chapter

window中产看无线网密码：<br>
管理员权限运行DOS：<br>
```for /f "skip=9 tokens=1,2 delims=:" %i in ('netsh wlan show profiles') do  @echo %j | findstr -i -v echo | netsh wlan show profiles %j key=clear```


[返回目录](README.md)
