###线程池简介：
多线程技术主要解决处理器单元内多个线程执行的问题，它可以显著减少处理器单元的闲置时间，增加处理器单元的吞吐能力。  
####引言
假设一个服务器完成一项任务所需时间为：T1 创建线程时间，T2 在线程中执行任务的时间，T3 销毁线程时间。但是如果：T1 + T3 远大于 T2，程序可能会在创建和销毁线程上浪费太多的时间==========》可以采用线程池，以提高服务器性能。
<br>一个线程池包括以下四个基本组成部分：
* 
线程池管理器（ThreadPool）：用于创建并管理线程池，包括 创建线程池，销毁线程池，添加新任务到任务队列；
* 
工作线程（PoolWorker）：线程池中线程，在任务队列没有任务时处于等待状态，可以循环的执行任务；
* 
任务接口（Task）：每个任务必须实现的接口，以供工作线程调度任务的执行，它主要规定了任务的入口，任务执行完后的收尾工作，任务的执行状态等；
* 
任务队列（taskQueue）：用于存放没有处理的任务。提供一种缓冲机制。
* 
为所有任务建立一个任务队列，线程池只负责去队列取任务找现在空闲的线程去执行就行了  

####处理
概念：程序刚开始时是不会创建线程的。需要服务时才创建；
<br>第二，指定一个线程数量以及最大值；
* 
首先如果当前线程数比较少或者没有，那么针对服务创建一个线程，然后执行；
* 
如果当前线程比指定的线程数多。则尝试放到缓存队列中，如果成功放入那么就等着；否则（比如队列已满）还是为它创建一个线程；
* 
但是如果超过了指定的最大值，则会忽略；
* 
如果线程数超过了设置的线程数但是小于最大的，那么针对所有线程会看其是否超过设定的有效时间，如果超过了，则还给系统；
* 
并没有新建一个线程专门调度任务，而是让执行完任务的线程去任务缓存队列里面取任务来执行。

[实现](http://www.cnblogs.com/coser/archive/2012/03/10/2389264.html)


[返回目录](README.md)