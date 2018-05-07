事物里面不要DDL。回滚影响
自增id按批而不是一个

###[xcode & mysql-src](http://c.colabug.com/thread-1145804-1-1.html)
* ```
brew upgrade cmake
cmake . -G "Xcode" -DWITH_DEBUG=1 -DCMAKE_INSTALL_PREFIX=/Users/zhangzhuang03/baidu_work/mysql-5.7.20/work -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost
```
* ```
如果xcode error：
xcode-select -switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild install   注：一般通过xcode构建安装
```

* add column 报警1034：
    * 没有指定默认值，这样导致其他行需要填充值。

[return](README.md)