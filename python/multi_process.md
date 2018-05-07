
## 多进程


在python中多线程并不是真正的多线程，只是体现在CPU的快速切换上，如果想真正利用多核CPU，就要使用多进程。

### 基础

```python
创建:
Process([group[,target[,name[,args[,kwargs]]]]]):
    group  一般不用
    target 调用的对象
    name    别名
    args    参数,元组形式
    kwargs  字典
方法:
    is_alive()
    join([timeout])
    run()
    start()
    terminate()
属性:
    authkey     
    daemon      在start()之前设置：意味着父进程终止后自动终止，且自己不能产生新进程；默认False
    exitcode
    name
    pid
```

### 使用

```python
#实例1：单个
import multiprocessing
import time

def worker(ti):
    n=6
    while n>0:
        print("time is {0}".format(time.ctime()))
        time.sleep(ti)
        n-=1
    
if __name__=="__main__":
    print("the number of cpu is {0}".format(multiprocessing.cpu_count()))
    p = multiprocessing.Process(target=worker,args = (3,))
    p.start()
    print("pid is {0}".format(p.pid))
    print("name is {0}".format(p.name))
    print("isalive is {0}".format(p.is_live()))
```
```python
#实例2：多个
import multiprocessing
import time

def worker1(ti):
    print("time is {0}".format(time.ctime()))
    time.sleep(ti)
def worker2(ti):
    print("time is {0}".format(time.ctime()))
    time.sleep(ti)
def worker3(ti):
    print("time is {0}".format(time.ctime()))
    time.sleep(ti)
def worker4(ti):
    print("time is {0}".format(time.ctime()))
    time.sleep(ti)
if __name__=="__main__":
    print("the number of cpu is {0}".format(multiprocessing.cpu_count()))
    p1 = multiprocessing.Process(target=worker1,args = (4,))
    p2 = multiprocessing.Process(target=worker2,args = (3,))
    p3 = multiprocessing.Process(target=worker3,args = (2,))
    p4 = multiprocessing.Process(target=worker4,args = (1,))
    p1.start()
    p2.start()
    p3.start()
    p4.start()
    for p in multiprocessing.active_children():
        print("name is {0}, id is {1}".format(p.pid,p.name))
```
```python
#实例3：daemon
import multiprocessing
import time

def worker(ti):
    print("start time is {0}".format(time.ctime()))
    time.sleep(ti)
    print("end time is {0}".format(time.ctime()))
    
if __name__=="__main__":
    print("the number of cpu is {0}".format(multiprocessing.cpu_count()))
    p = multiprocessing.Process(target=worker,args = (3,))
    p.start()
    print("end!!!")
输出;
    end!!!
    start time is ...
    end tiem is...
    
#daemon:设置为True则意味着父结束子自动结束
import multiprocessing
import time

def worker(ti):
    print("start time is {0}".format(time.ctime()))
    time.sleep(ti)
    print("end time is {0}".format(time.ctime()))
    
if __name__=="__main__":
    print("the number of cpu is {0}".format(multiprocessing.cpu_count()))
    p = multiprocessing.Process(target=worker,args = (3,))
    p.daemon = True
    p.start()
    print("end!!!")
输出：end!!!
因为设置daemon为True：父进程结束后子进程也结束。怎么改？
    p.start()后调用p.join()即可
```
```python
#类中实现
import multiprocessing 
import time

class clockprocess(multiprocessing.Process):
    def __init__(self,ti):
        multiprocessing.Process.__init__(self)
        self.ti = ti
    def run():
        n = 4
        while n!=0:
            print("the time is {0}".format(time.ctime()))
            time.sleep(self.ti)
            --n
if __name__ == "__main__":
    p = clockprocess (3)
    p.start()           #自动调用run()
```

### Lock：共享资源
```python
import multiprocessing
import sys

def worker_with(lock,f):
    with lock:
        fs = open(f,"a+")
        n = 10
        while n!=0:
            fs.write("lock with with")
            --n
        fs.close()
def worker_without(lock,f):
    lock.acquire()
    try:
        fs = open(f,"a+")
        n = 10
        while n!=0:
            fs.write("lock with with")
            --n
        fs.close()
    finally；
        lock.release()
        
if __name__ == "__main__"；
    lock = multiprocessing.lock()
    f="file.txt"
    w = mulitprocessing.Process(target = worker_with,args=(lock,f))
    wo = mulitprocessing.Process(target = worker_without,args=(lock,f))
    w.start()
    wo.start()
```

### semaphore：访问数量
```python
import multiprocessing
imort time
def worker(s,i):
    s.acquire()
    print("current process {0} acquire".format(multiprocessing.current_process().name)
    time.sleep()
    s.release()
    print("current process {0} release".format(multiprocessing.current_process().name)
if __name__=="__main__":
    s = multiprocessing.Semaphore(2)
    for i in range(5):
        p = multiprocessing.Process(target=worker,args = (s,i**2))
        p.start()
```

### event:同步通信
```python
import multiprocessing
import time

def wait_for_event(e):
    print("wait for event:starting")
    e.wait()
    print("wait for event:e.is_set()--->"+str(e.is_set()))
def wait_for_timeout(e,ti):
    print("wait for eventtimeout:starting")
    e.wait(ti)
    print("wait for eventtimeout:e.is_set()---->"+str(e.is_set()))
if __name__=="__main__":
    e = multiprocessing.Event()
    w1 = multiprocessing.Process(target = wait_for_event,name = "block",args = (e,))
    w2 = multiprocessing.Process(target = wait_for_timeout,name = "non-block",args = (e,4))
    w1.start()
    w2.start()
    time.sleep(3)
    e.set()
    print("main:e is set")

#output:
#    wait for event:starting
#    wait for eventtimeout:starting
#    wait for eventtimeout--->False
#    main:e is set
#    wait for event--->True
```

### Queue:数据传递

```python
import multiprocessing
def writer(q):
    try:
        q.put(1,block=False)
    except:
        pass
def reader(q):
    try:
        print(q.get(bloc=False))
    except:
        pass
if __name__=="__main__":
    q = multiprocessing.Queue()
    wri = multiprocessing.Process(target = writer, args=(q,))
    wri.start()
    rea = multiprocessing.Process(target=reader,args = (q,))
    rea.start()
    rea.join()
    wri.join()
```

### Pipe：通信管道的两端
```python
Pipe(conn1,conn2[,duplex]):返回通信管道的两端   duplex默认True即两端均可收发，False则只有conn1可以收，conn2发
send()  发送消息
recv()  接受消息：没有可接受的则阻塞，管道关闭抛出异常

import multiprocessing
import time
def pro1(pipe):
    while 1:
        for i in range(100):
            print("pro1 send {0}".format(i))
            pipe.send(i)
            time.sleep(2)
def pro2(pipe):
    while 1:
        print("pro2 recv is {0}".format(pipe.recv()))
        time.sleep()
def pro3(pipe):
    while 1:
        print("pro3 recv is {0}".format(pipe.recv()))
        time.sleep()
if __name__ == "__main__":
    pipe = multiprocessing.Pipe()
    p1 = multiprocessing.Process(target=pro1,args=(pipe[0],))
    p2 = multiprocessing.Process(target=pro2,args=(pipe[1],))
    p3 = multiprocessing.Process(target=pro3,args=(pipe[1],))
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()
```

### Pool：大规模多进程
```python
函数:
    apply_async(func[,args[,kwds[,callbakck]]]])   非阻塞，维持进程数量稳定
    apply(func[,args[,kwds]])       阻塞版
    close()         关闭pool，不接受新增
    join()          主进程阻塞，等待子进程结束，要在close()/terminate()之后使用
    terminate()     结束工作进程，不处理未完成的任务
    
#非阻塞版                                       #阻塞版
import multiprocessing                          import multiprocessing
import time                                     import time
def func(msg):                                  def func(msg):
    print("msg is {0}".format(msg))                 print("msg is {0}".format(msg))
    time.sleep(4)                                   time.sleep(4)
    print("sub:end!!!")                             rint("sub:end!!!")
if __name__=="__main__":                        if __name__=="__main__":
    pool = multiprocessing.Pool(processes=5)        pool = multiprocessing.Pool(processes=5)
    for i in range(6):                              for i in range(6):
        msg = "hello"+str(i)                            msg = "hello"+str(i)
        pool.apply_async(func,(msg,))                   pool.apply(func,(msg,))     #阻塞
    print("main : mark mark mark mark")             print("main : mark mark mark mark")
    pool.close()                                    pool.close()
    pool.join()                                     pool.join()
    print("main:end!!!")                            print("main:end!!!")
#  output: 可能有所不同，但大体一定一样
#  main : mark mark mark mark                   msg is hello0       
#  msg is hello0                                sub:end!!!
#  msg is hello1                                msg is hello1
#  msg is hello2                                sub:end!!!
#  sub:end!!!                                   msg is hello2
#  sub:end!!!                                   end!!!
#  msg is hello3
#  sub:end!!!
#  msg is hello4
#  msg is hello5
#  sub:end!!!
#  sub:end!!!
#  sub:end!!!                                   main : mark mark mark mark  
#  main:end!!!                                  main:end!!!
当然也可以使用多个进程池
```



[返回目录](README.md)

