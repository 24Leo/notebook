
## 常用函数：

**1. 
暂停：**
* 
sleep：
```C
    #include <unistd.h/windows.h>
    void Sleep(DWORD dwMilliseconds);   参数为毫秒
    unsigned int sleep(unsigned int seconds);参数为秒 （如果需要更精确可以用usleep，单位为微秒）
        Sleep(1000);
        sleep(1);
        usleep(1000000);
```
* 
wait：
```C
#include <sys/types.h>/<sys/wait.h>
pid_t wait (int * status)      成功则返回子进程识别码(PID), 错误则返回-1. 失败原因存于errno 中.
```
* 
delay：
```C
#include<sys/wait.h>    #include<sys/types.h> 
void delay(unsigned int msec);      毫秒
```


sleep是自己睡,wait是等别人;<br>
sleep()使当前线程进入阻塞状态，让出CUP的使用、目的是不让当前线程独自霸占该进程所获的CPU资源，以留一定时间给其他线程执行的机会;  sleep()是Thread类的Static(静态)的方法；因此他不能改变对象的机锁，所以当在一个Synchronized块中调用sleep()方法，**线程虽然休眠了，但是对象的机锁并木有被释放**，其他线程无法访问这个对象（即使睡着也持有对象锁）。在sleep()休眠时间期满后，该线程**不一定会立即执行**，这是因为其它线程可能正在运行而且没有被调度为放弃执行，除非此线程具有更高的优先级。<br>
wait()方法是Object类里的方法；当一个线程执行到wait()方法时，它就进入到一个和**该对象相关的等待池**中，调用者被挂起，同时**失去（释放）了对象的机锁**（暂时失去机锁，wait(long timeout)超时时间到后还需要返还对象锁）；其他线程可以访问；wait()使用notify或者notifyAlll或者指定睡眠时间来唤醒当前等待池中的线程。wiat()必须放在synchronized block中，否则会在program runtime时扔出”java.lang.IllegalMonitorStateException“异常。 <br>但是wait()和sleep()都可以通过interrupt()方法打断线程的暂停状态，从而使线程立刻抛出InterruptedException（但不建议使用该方法）。<br>
其实两者都可以让线程暂停一段时间,但是本质的区别是一个线程的运行状态控制,一个是线程之间的通讯的问题<br>
wait是针对进程，如果一个子进程有多个线程，那么在最后一个结束时，其parent才能wait返回

**2.实现strcpy函数：**

```C
  char* strcpy(char *dest,const char *src)
  {
    assert(dest != NULL);
    assert(src != NULL);
    char *ret = dest;
    while(*src != '\0')
    {
      *ret = *src;
      ++ret;
      ++src;
    }
    *ret = '\0';
    return ret;
  }
```
**3.实现strlen函数：**

```C
  int strlen(const char *src)
  {
    assert(src != NULL);
    int ret = 0;
    while(*src != '\0')
    {
      ++ret;
      ++src;
    }
    return ret;
  }
```
**4.alloca、malloc、calloc、realloc的区别：**
```C
都在《stdlib.h》
void* alloca(size_t);
void* malloc(size_t);
void* calloc(size_t num,size_t each_size);
void* realloc(void* ptr,size_t newsize);
alloca：向栈申请内存，不需要释放
malloc：向堆申请内存，不会对内存初始化，所以一般需要memset进行初始化
calloc：向堆申请保存n个m大小的元素内存，初始化为0.
realloc：对已经分配的内存重新调正大小，一般是malloc申请的内存
区别：
  只有alloca是分配栈上的内存，其余都是堆上的操作；
  malloc分配后不初始化，calloc初始化为0；
  realloc不保证扩张或者缩小后的内存地址一致；扩展增加，缩小删除；
```


[返回目录](README.md)