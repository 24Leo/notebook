启动
```shell
main
    |-mysqld_main
        |-pre_initialize_performance_schema     //初始化监控表
        |-my_init                               // 初始话线程变量，互斥量
        |-load_defaults                         // 加载配置
            |-init_alloc_root                    // 初始化内存池
        |-init_common_variables                 // 初始化变量
            |-get_options                       // 处理默认参数及命令行参数
                |-connection_handler_manager::init     //初始化连接管理模块
                |-Global_THD_manager::create_instance  //初始化线程管理模块
        |-init_server_components                // 初始化插件
            |-plugin_init
                |-plugin_initialize
            |-ha_init                           // 初始化存储引擎
        |-network_init                          // 监听网络
        |-create_pid_file                       // 创建pid文件
        |-grant_init                            // 授权管理
        |-start_handle_manager                  // 启动管理线程
        |-connection_event_loop                 // While循环监听连接          
```
监听
```shell
connection_event_loop
    |-listen_for_connection_event               // 获得channel_info，连接信息：封装THD
        |-poll、select
        |-mysql_socket_getfd                    // 获得连接描述符
        |-Channel_info_tcpip_socket             // 初始化channel_info
            |-create_thd                         // 线程连接对象，封装在channel_info中
    |-process_new_connection                    // 处理新连接
        |-check_and_incr_conn_count             // 是否超出最大连接数
        |-add_connection                        // 添加到连接管理模块实例中
            |-check_idle_thread_and_enqueue_connection   // 是否有重用线程
                |-pthread_cond_signal(&COND_thread_cache) // 有的话则唤醒
            |-mysql_thread_create               //创建新线程
            |-放到等待队列中
```


处理连接
```shell 
handle_connection                               // 函数指针，处理连接
    |-从等待队列中取出channel_info处理
    |-thd_prepare_connection                    // 预处理
        |-login_connection                      // 连接身份认证
    |-prepare_new_connection_state              // 初始化show status 显示内容
    |-do_command 
```
 
处理命令
```shell
do_command
    |-get_command                               // 从thd连接中获得命令
    |-dispatch_command                          // 根据命令类型调用mysql_parse
        |-mysql_parse                           // 解析命令
        |-mysql_execute_command                 // 执行

mysql_insert为例
    |-TABLE_LIST                                // 需要用的表
    |-open_and_lock_tables                       // 对表加锁，防止表结构变更
    |-write_record                              // 执行写数据
        |-ha_write_row
        |-binlog_long_row
```

* mysql实例使用的内存是管理在**连接对象**里面的，所以长连接。。。。不释放内存，很容易导致被强制杀死
* 

[return](README.md)