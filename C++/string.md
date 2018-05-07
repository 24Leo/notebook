#String usage

### 头文件：

```C++
要想使用标准C++中string类，必须要包含

#include <string>                // 注意是<string>，不是<string.h>，带.h的是C语言中的头文件

using  std::string;
using  std::wstring;

或

using namespace std;

下面你就可以使用string/wstring了，它们两分别对应着char和wchar_t。
```

### 用法：
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;string和wstring的用法是一样的，以下只用string作介绍：

 **String类的构造函数**：

```C++
string(const char *s);    //用c字符串s初始化
string(int n,char c);     //用n个字符c初始化
string s1="hello"；       //string类还支持默认构造函数和复制构造函数  但当构造太长而无法表达：length_error
cin>>s1             //自动忽略开头所有的空白字符，读取字符直至再次遇到空白字符结束
```
 ** String类的字符操作：**

```C++
const char &operator[](int n)const;
const char &at(int n)const;
char &operator[](int n);
char &at(int n);
        operator[]和at()均返回当前字符串中第n个字符的位置，但at函数提供范围检查，当越界时会抛出out_of_range异常
        下标运算符[]不提供检查访问。
const char *data()const;   //返回一个非null终止的c字符数组
const char *c_str()const;  //返回一个以null终止的c字符串
int copy(char *s, int n, int pos = 0) const;/*把当前串中以pos开始的n个字符拷贝到以s为起始位置的字符数组中，
                                            返回实际拷贝的数目*/```
**String的特性描述:**
```C++
int capacity()const;    //返回当前容量（即string中不必增加内存即可存放的元素个数）
int max_size()const;    //返回string对象中可存放的最大字符串的长度
int size()const;        //返回当前字符串的大小
int length()const;       //返回当前字符串的长度,和sizes()返回值一样:源码中都是 return (_LEN)
bool empty()const;        //当前字符串是否为空
void resize(int len,char c);//把字符串当前大小置为len，并用字符c填充不足的部分
```
**String类的输入输出操作:**
```C++
string类重载运算符operator>>用于输入，同样重载运算符operator<<用于输出操作。
getline(istream &in,string &s);  用于从输入流in中读取字符串到s中，以换行符'\n'分开。
```
**String的赋值：**
```C++
string str(src);
string str(num,c);                  //用num个字符c初始化当前字符串
string str(src,pos,len);            //从src的pos处拷贝len个字符赋给当前字符串
string &operator=(const string &s);  //把字符串s赋给当前字符串
string &assign(const char *s);       //用c类型字符串s赋值
string &assign(const char *s,int n); //用c字符串s开始的n个字符赋值
string &assign(const string &s);     //把字符串s赋给当前字符串
string &assign(int n,char c);       //用n个字符c赋值给当前字符串
string &assign(const string &s,int start,int n);  //把字符串s中从start开始的n个字符赋给当前字符串
string &assign(const_iterator first,const_itertor last);  //把first和last迭代器之间的部分赋给字符串
cin>>s1             //自动忽略开头所有的空白字符，读取字符直至再次遇到空白字符结束
bool operator =     //重新赋值，替换原有内容
```
**String的连接/添加：**
```C++
string s1+='c'/"str"                //加操作符号
string push_back(char c);               //尾部添加字符
string &operator+=(const string &s);   //把字符串s连接到当前字符串的结尾
string &append(const char *s);         //把c类型字符串s连接到当前字符串结尾
string &append(const char *s,int n);    //把c类型字符串s的前n个字符连接到当前字符串结尾
string &append(const string &s);       //同operator+=()
string &append(const string &s,int pos,int n);//把字符串s中从pos开始的n个字符连接到当前字符串的结尾
string &append(int n,char c);           //在当前字符串结尾添加n个字符c
string &append(const_iterator first,const_iterator last);//迭代器first和last之间的部分加到当前字符串结尾```
**String的比较：**
```C++
bool operator==(const string &s1,const string &s2)const;//比较两个字符串是否相等
运算符">","<",">=","<=","!="均被重载用于字符串的比较；
int compare(const string &s) const;     //比较当前字符串和s的大小
int compare(int pos, int n,const string &s)const;//比较当前字符串从pos开始的n个字符组成的字符串与s的大小
int compare(int pos, int n,const string &s,int pos2,int n2)const;
                //比较当前字符串从pos开始的n个字符组成的字符串与s中pos2开始的n2个字符组成的字符串的大小
int compare(const char *s) const;
int compare(int pos, int n,const char *s) const;
int compare(int pos, int n,const char *s, int pos2) const;   //这三个同上，只是用的指针而非引用
```
**String的子串：**
```C++
string substr(int pos = 0,int n = npos) const;//返回pos开始的n个字符组成的字符串
```
**String的交换：**
```C++
void swap(string &s2);    //交换当前字符串与s2的值
```
**String类的查找函数：**
```C++
int find(char c, int pos = 0) const;        //从pos开始查找字符c在当前字符串的位置
int find(const char *s, int pos = 0) const; //从pos开始查找字符串s在当前串中的位置
int find(const char *s, int pos, int n) const;  //从pos开始查找字符串s中前n个字符在当前串中的位置
int find(const string &s, int pos = 0) const;   /*从pos开始查找字符串s在当前串中的位置
                                    查找成功时返回所在位置，失败返回string::npos的值*/
int rfind(char c, int pos = npos) const;    //从pos开始从后向前查找字符c在当前串中的位置
int rfind(const char *s, int pos = npos) const;
int rfind(const char *s, int pos, int n = npos) const;
int rfind(const string &s,int pos = npos) const;   /*从pos开始从后向前查找字符串s中前n个字符组成的字符串在
                        当前串中的位置，成功返回所在位置，失败时返回string::npos的值*/
int find_first_of(char c, int pos = 0) const;//从pos开始查找字符c第一次出现的位置
int find_first_of(const char *s, int pos = 0) const;
int find_first_of(const char *s, int pos, int n) const;
int find_first_of(const string &s,int pos = 0) const;
                //从pos开始查找当前串中第一个在s的前n个字符组成的数组里的字符的位置。查找失败返回string::npos
int find_first_not_of(char c, int pos = 0) const;
int find_first_not_of(const char *s, int pos = 0) const;
int find_first_not_of(const char *s, int pos,int n) const;
int find_first_not_of(const string &s,int pos = 0) const;
                //从当前串中查找第一个不在串s中的字符出现的位置，失败返回string::npos
int find_last_of(char c, int pos = npos) const;
int find_last_of(const char *s, int pos = npos) const;
int find_last_of(const char *s, int pos, int n = npos) const;
int find_last_of(const string &s,int pos = npos) const;
int find_last_not_of(char c, int pos = npos) const;
int find_last_not_of(const char *s, int pos = npos) const;
int find_last_not_of(const char *s, int pos, int n) const;
int find_last_not_of(const string &s,int pos = npos) const;
           //find_last_of和find_last_not_of与find_first_of和find_first_not_of相似，只不过是从后向前查找```
**String类的替换函数：**
```C++
string &replace(int p0, int n0,const char *s);
                //删除从p0开始的n0个字符，然后在p0处插入串s
string &replace(int p0, int n0,const char *s, int n);
                //删除p0开始的n0个字符，然后在p0处插入字符串s的前n个字符
string &replace(int p0, int n0,const string &s);
                //删除从p0开始的n0个字符，然后在p0处插入串s
string &replace(int p0, int n0,const string &s, int pos, int n);
                //删除p0开始的n0个字符，然后在p0处插入串s中从pos开始的n个字符
string &replace(int p0, int n0,int n, char c);//删除p0开始的n0个字符，然后在p0处插入n个字符c
string &replace(iterator first0, iterator last0,const char *s);
                //把[first0，last0）之间的部分替换为字符串s
string &replace(iterator first0, iterator last0,const char *s, int n);
                //把[first0，last0）之间的部分替换为s的前n个字符
string &replace(iterator first0, iterator last0,const string &s);
                //把[first0，last0）之间的部分替换为串s
string &replace(iterator first0, iterator last0,int n, char c);
                //把[first0，last0）之间的部分替换为n个字符c
string &replace(iterator first0, iterator last0,const_iterator first, const_iterator last);
                //把[first0，last0）之间的部分替换成[first，last）之间的字符串```
**String类的插入函数：**
```C++
string &insert(int p0, const char *s);
string &insert(int p0, const char *s, int n);
string &insert(int p0,const string &s);
string &insert(int p0,const string &s, int pos, int n);
                //上4个函数在p0位置插入字符串s中pos开始的前n个字符
string &insert(int p0, int n, char c);  //此函数在p0处插入n个字符c
iterator insert(iterator it, char c);   //在it处插入字符c，返回插入后迭代器的位置------注意返回值*****
void insert(iterator it, const_iterator first, const_iterator last);
                //在it处插入[first，last）之间的字符
void insert(iterator it, int n, char c);    //在it处插入n个字符c
```
**String类的删除函数**
```C++
iterator erase(iterator first, iterator last);  //删除[first，last）之间的所有字符，返回删除后迭代器的位置
iterator erase(iterator it);                    //删除it指向的字符，返回删除后迭代器的位置
string &erase(int pos = 0, int n = npos);       //删除pos开始的n个字符，返回修改后的字符串
void clear();                     //清除所有元素
```
**String类的迭代器处理：**
```C++
用string::iterator或string::const_iterator声明迭代器变量，const_iterator不允许改变迭代的内容。
常用迭代器函数有：
const_iterator begin()const;
iterator begin();                   //返回string的起始位置
const_iterator end()const;
iterator end();                     //返回string的最后一个字符后面的位置
const_iterator rbegin()const;
iterator rbegin();                  //返回string的最后一个字符的位置
const_iterator rend()const;
iterator rend();                    //返回string第一个字符位置的前面

  rbegin和rend用于从后向前的迭代访问，通过设置string::reverse_iterator,string::const_reverse_iterator实现
  string类提供了向前和向后遍历的迭代器iterator：迭代器提供了访问各个字符的语法，类似于指针操作，迭代器不检查范围。
```
**字符串流处理：**
```C++
通过定义ostringstream和istringstream变量实现: #include <sstream>头文件中
例如：
    string input("hello,this is a test");
    istringstream is(input);
    string s1,s2,s3,s4;
    is>>s1>>s2>>s3>>s4;     //s1="hello,this",s2="is",s3="a",s4="test",
    ostringstream os;
    os<<s1<<s2<<s3<<s4;
    cout<<os.str();
                    //自动忽略开头所有的空白字符(换行、制表、空格等)，读取字符直至再次遇到空白字符结束
    
    getline(iostream &in,buf);     //从流中读取一行放入buf中。只要遇到换行符就算本次结束
```
**C兼容：**
```C
#include <string.h>/<cstring> 
//返回C格式字符串
char* c_str(const string &s)   
char* data(const string &s)

void * memcpy( void * des, const void * src, size_t num );  //把src的前num个字符赋值给des
void * memmove( void * des, const void * src, size_t num );   //从src取num个字符，在des处开始覆盖
char * strncpy ( char * des, const char * src, size_t num ); //把src的前num个字符赋值给des
char * strcpy ( char * destination, const char * source );   //src赋值给des

char * strcat ( char * destination, const char * source );   //把src添加到des尾部
char * strncat( char * des, const char * src, size_t num );  //把src的前num个字符添加到des尾部

int memcmp ( const void * ptr1, const void * ptr2, size_t num ); //比较两个串前num个元素大小
int strcmp ( const char * str1, const char * str2 );        //比较大小
int strncmp( const char * str1, const char * str2, size_t num ); //比较前num个字符大小
size_t strxfrm(char * des, const char * src, size_t num );  //把src的前num个字符赋值给des
int strcoll ( const char * str1, const char * str2 );       //比较大小

void * memchr ( const void * ptr, int value, size_t num );  //在ptr的前num个元素中查找value返回下标
char * strchr ( const char * str, int character );          //字符第一次出现的位置指针
char * strrchr ( const char * str, int character );         //从后开始第一次出现的位置指针
size_t strspn ( const char * str1, const char * str2 );     //str1中首次出现str2中任意字符的连续总长度
size_t strcspn ( const char * str1, const char * str2 );    //str1中首次出现str2中任意字符的下标
char * strpbrk ( const char * str1, const char * str2 );    //返回str1中首次出现str2里字符的位置指针
char * strstr ( const char * str1, const char * str2 );     //字符串第一次出现的位置指针
char * strtok ( char * str, const char * delim );      /*按delimz中任意字符分割字符串，返回已分割部分   
                                                        第二次调用时，第一个参数设为NULL即可*/
                                                        
void * memset ( void * ptr, int value, size_t num );        //设置ptr的前num个字符为value
char * strerror ( int errnum );

NULL            Null pointer (macro )               //空字符串
size_t          Unsigned integral type (type )      //长度
```
**字符串赋值时，从头覆盖。如果目地字符串比要源字符串长度长，覆盖剩下的依然是原有的值。**

[返回目录](README.md)