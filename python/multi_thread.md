
## 多线程

采用的是分时复用技术，即不存在真正的多线程，cpu做的事是快速地切换线程，以达到类似同步运行的目的，因为高密集运算方面多线程是没有用的，但是对于存在延迟的情况（延迟IO，网络等）多线程可以大大减少等待时间，避免不必要的浪费。

对于资源，加锁是个重要的环节。因为python原生的list,dict等，都是not thread safe的。而Queue，是线程安全的，因此在满足使用条件下，建议使用队列。

```Python 
Queue模块有三种队列及构造函数:
Python Queue模块的FIFO队列先进先出。    class Queue.Queue(maxsize)
LIFO类似于堆，即先进后出。              class Queue.LifoQueue(maxsize)
还有一种是优先级队列级别越低越先出来。     class Queue.PriorityQueue(maxsize)

此包中的常用方法(q = Queue.Queue()):
q.qsize()       返回队列的大小
q.empty()       如果队列为空，返回True,反之False
q.full()        如果队列满了，返回True,反之False 
q.get([block[, timeout]]) 获取队列，timeout等待时间
q.get_nowait()  相当q.get(False)
q.put(item，timeout)  写入队列，timeout等待时间,非阻塞 
q.put_nowait(item)  相当q.put(item, False)
q.task_done()   consumer在完成对该queue上元素的操作(先get()，用于join激活)，
q.join()        阻塞到queue上的元素均被操作(实际上意味着等到队列为空)，再执行别的操作
        由于join()引起的阻塞，所有元素被操作(task_done)后重新“激活”(每一个put进去的元素都进行了task_done调用)
q.put(item,block[False],timeout[None]):
        block=True:若queue已满，调用该queue的线程阻塞直至出现一个空的单元
            同时若timeout是一个正整数：该阻塞时长后仍未有空，发出Full异常
        block=False:满了就会引起Full异常
q.get(item,block,timeout):
        block=True:若queue为空，调用该queue的线程阻塞直至出现一个可用单元。
        block=False:空了就会引起Empty异常
```
用于多进程的队列<br>
范例0:
```python
import threading,Queue

def consumer(): 
    while 1:
        item = q.get()
        if item is None:
            break
        print(item)
        q.task_done()
q = Queue.Queue()
threads=[]
for i in range(5):
    t = threading.Thread(target = consumer):
    t.start()
    threads.append(t)
for i in range(10):
    q.put(i)
for t in threads:
    t.join()
q.join()
```
线程的join([i])：<br>
　　1、阻塞主线程，无法执行join之后的语句，专注于多线程的执行<br>
　　2、参数：等待的时间<br>
　　　　1、无则意味着一直等待，即直到该线程结束才执行接下来的语句<br>
　　　　2、有即意味着等待该时间，如果子线程在该时间里执行完则正常执行下面语句，
　　　　　　　　　　　　　　　　否则不等待，让他继续，但父进程可以继续接下来的操作<br>
范例1：
```python
#consuming after produced
import Queue,threading,time,random

class consumer(threading.Thread):
    def __init__(self,que):
        threading.Thread.__init__(self)
        self.daemon = False
        self.queue = que
    def run(self):
        while True:
            if self.queue.empty():
                break
            item = self.queue.get()
            #processing the item
            time.sleep(item)
            print self.name,item
            self.queue.task_done()
        return
que = Queue.Queue()
for x in range(10):
    que.put(random.random() * 10, True, None)       #生产者（主线程）
consumers = [consumer(que) for x in range(3)]

for c in consumers:
    c.start()
que.join()

代码的功能是产生10个随机数（0～10范围），sleep相应时间后输出数字和线程名称
这段代码里，是一个快速生产者（产生10个随机数），3个慢速消费者的情况。
在这种情况下，先让三个consumers跑起来，然后主线程用que.join()阻塞。
当三个线程发现队列都空时，各自的run函数返回，三个线程结束。同时主线程的阻塞打开，全部程序结束。
```
* 
调用start()不一定立刻调用run()执行
* 
不同线程间的run()的顺序不一定

范例2:

```python
#consuming while producing
import Queue,threading,time,random

class consumer(threading.Thread):
    def __init__(self,que):
        threading.Thread.__init__(self)
        self.daemon = False
        self.queue = que
    def run(self):
        while True:
            item = self.queue.get()
            if item == None:
                break
            #processing the item
            print self.name,item
            self.queue.task_done()
        self.queue.task_done()
        return
que = Queue.Queue()

consumers = [consumer(que) for x in range(3)]
for c in consumers:
    c.start()
for x in range(10):
    item = random.random() * 10
    time.sleep(item)
    que.put(item, True, None)
que.put(None)
que.put(None)
que.put(None)
que.join()

这种情况下，快速消费者在get时需要阻塞.因此对于停止整个程序，使用的是None标记，让子线程遇到None便返回结束。
因为消费速度大于产生速度，因此先运行子线程等待队列加入新的元素，然后再慢速地添加任务。
注意最后put（None）三次，是因为每个线程返回都会取出一个None，都要这样做才可以使三个线程全部停止。当然有种更简单粗暴
的方法，就是把子线程设置为deamon，一但生产完成，开始que.join()阻塞直至队列空就结束主线程，子线程虽然在阻塞等待队列
也会因为deamon属性而被强制关闭。。。。
```


[返回目录](README.md)