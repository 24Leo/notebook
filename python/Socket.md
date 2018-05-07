#Socket


socket传输自由度太高，从而带来很多安全和兼容的问题。我们往往利用一些应用层的协议(比如HTTP协议)来规定socket 使用规则，以及所传输信息的格式。

HTTP协议利用请求-回应(request-response)的方式来使用TCP socket。客户端向服务器发一段文本作为request，服务器端在接收到request之后，向客户端发送一段文本作为response。在完成了这样一次request-response交易之后，TCP socket被废弃。下次的request将建立新的socket。request和response本质上说是两个文本，只是HTTP协议对这两个文本都有一定的格式要求。

**Server**
```python
#!/usr/bin/env python2.7
import socket

HOST = '127.0.0.1'
PORT = 8090

reply = 'Yes,hello'

    # Configure socket
s      = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))

    # passively wait, 3: maximum number of connections in the queue
s.listen(3)
print "listening..."
    # accept and establish connection
conn, addr = s.accept()
print "accept..."
    # receive message
request    = conn.recv(1024)

print 'request is: ',request
print 'Connected by', addr
    # send message
conn.sendall(reply)
    # close connection
conn.close()
```
扩展
```python
import socket,threading
def deal(self,sock,addr):
    sock.send('welcome...')
    while(true):
        data=sock.recv(1024)
        ....
    sock.close()
    
HOST = '127.0.0.1'
PORT = 8090

reply = 'Yes,hello'

    # Configure socket
s      = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))

    # passively wait, 3: maximum number of connections in the queue
s.listen(3)
print "listening..."
    # accept and establish connection
while(1):
    sock,attr=s.accept()
    t=threading.Thread(target=deal,args=(sock,attr))
    t.start()
```

**Client**
```python
#!/usr/bin/env python2.7
import socket

    # Address
HOST = '127.0.0.1'
PORT = 8090

request = 'can you hear me?'

    # configure socket
s       = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

    # send message
s.sendall(request)
    # receive message
reply   = s.recv(1024)
print 'reply is: ',reply
    # close connection
s.close()```


[返回目录](README.md)