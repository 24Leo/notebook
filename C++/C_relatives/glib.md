##GObject对象系统

简单的说，GObject对象系统是一个建立在GLIB基础上的，用C语言完成的，具有跨平台特色的、灵活的、可扩展的、非常容易映射到其它语言的面向对象的框架。如果你是一个C语言的执着的追随者，你没有理由不研究一下它。
####前言

大多数现代的计算机语言都带有自己的类型和对象系统，并附带算法结构。正象GLib提供的基本类型和算法结构（如链表、哈希表等）一样，GObject的对象系统提供了一种灵活的、可扩展的、并容易映射（到其它语言）的面向对象的C语言框架。它的实质可以概括为：
* 
一个通用类型系统，用来注册任意的、轻便的、单根继承的、并能推导出任意深度的结构类型的界面，它照顾组合对象的定制、初始化和内存管理，类结构，保持对象的父子关系，处理这些类型的动态实现。也就是说，这些类型的实现是在运行时重置和卸载的；
* 
一个基本类型的实现集，如整型，枚举型和结构型等；
* 
一个基本对象体系之上的基本对象类型的实现的例子--GObject基本类型；
* 
一个信号系统，允许用户非常灵活的自定义虚的或重载对象的方法，并且能充当非常有效力的通知机制；
* 
一个可扩展的参数/变量体系，支持所有的能被用作处理对象属性或其它参数化类型的基本的类型。 

####类型（GType）与对象（GObject）

GLib中最有特色的是它的对象系统--GObject System，它是以Gtype为基础而实现的一套单根继承的C语言的面向对象的框架。

GType 是GLib 运行时类型认证和管理系统。GType API 是GObject的基础系统，所以理解GType是理解GObject的关键。Gtype提供了注册和管理所有基本数据类型、用户定义对象和界面类型的技术实现。（注意：在运用任一GType和GObject函数之前必需运行g_type_init()函数来初始化类型系统。）

为实现类型定制和注册这一目的，所有类型必需是静态的或动态的这二者之一。静态的类型永远不能在运行时加载或卸载，而动态的类型则可以。静态类型由g_type_register_static()创建，通过GTypeInfo结构来取得类型的特殊信息。动态类型则由g_type_register_dynamic()创建，用GTypePlugin结构来取代GTypeInfo，并且还包括g_type_plugin_*()系列API。这些注册函数通常只运行一次，目的是取得它们返回的专有类的类型标识。

还可以用g_type_register_fundamental来注册基础类型，它同时需要GTypeInfo和GTypeFundamentalInfo两个结构，事实上大多数情况下这是不必要的，因为系统预先定义的基础类型是优于用户自定义的。

####对象的定义

在GObject系统中，对象由三个部分组成：

    对象的ID标识（唯一，无符号长整型，所有此类对象共同的标识）；
    对象的类结构（唯一，结构型，由对象的所有实例共同拥有）；
    对象的实例（多个，结构型，对象的具体实现）。 

基于GObject的对象到底是什么样的呢？下面是基于GObject的简单对象 -- Boy的定义代码：
```C
/* boy.h */
#ifndef __BOY_H__
#define __BOY_H__
#include <glib-object.h>
#define BOY_TYPE (boy_get_type())
#define BOY(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj),BOY_TYPE,Boy))
typedef struct _Boy Boy;
typedef struct _BoyClass BoyClass;
struct _Boy {
GObject parent;
//
gint age;
gchar *name;
void (*cry)(void);
};
struct _BoyClass {
GObjectClass parent_class;
//
void (*boy_born)(void);
};
GType	boy_get_type(void);
Boy*  boy_new(void);
int	boy_get_age(Boy *boy);
void	boy_set_age(Boy *boy, int age);
char* boy_get_name(Boy *boy);
void	boy_set_name(Boy *boy, char *name);
Boy*  boy_new_with_name(gchar *name);
Boy*  boy_new_with_age(gint age);
Boy*  boy_new_with_name_and_age(gchar *name, gint age);
void  boy_info(Boy *boy);
#endif /* __BOY_H__*/
```
这是一段典型的C语言头文件定义，包括编译预处理，宏定义，数据结构定义和函数声明；首先要看的是两个数据结构对象Boy和BoyClass，

结构类型_Boy是Boy对象的实例，就是说我们每创建一个Boy对象，也就同时创建了一个_Boy结构。Boy对象中的parent表示此对象的父类，GObject系统中所有对象的共同的根都是GObject类，所以这是必须的；其它的成员可以是公共的，这里包括表示年龄的age，表示名字的name和表示方法的函数指针cry，外部代码可以操作或引用它们。

结构类型_BoyClass是Boy对象的类结构，它是所有Boy对象实例所共有的。BoyClass中的parent_class是GObjectClass，同GObject是所有对象的共有的根一样，GObejctClass是所有对象的类结构的根。在BoyClass中我们还定义了一个函数指针boy_born，也就是说这一函数指针也是所有Boy对象实例共有的，所有的Boy实例都可以调用它；同样，如果需要的话，你也可以在类结构中定义其它数据成员。

其余的函数定义包括三种，一种是取得Boy对象的类型ID的函数boy_get_type，这是必须有的；另一种是创建Boy对象实例的函数boy_new和boy_new_with_*，这是非常清晰明了的创建对象的方式，当然你也可以用g_object_new函数来创建对象；第三种是设定或取得Boy对象属性成员的值的函数boy_get_*和boy_set_*。正常情况下这三种函数都是一个对象所必需的，另外一个函数boy_info用来显示此对象的当前状态。

宏在GObject系统中用得相当广泛，也相当重要，这里我们定义了两个非常关键的宏，BOY_TYPE宏封装了boy_get_type函数，可以直接取得并替代Boy对象的ID标识；BOY(obj)宏是G_TYPE_CHECK_INSTANCE_CAST宏的再一次封装，目的是将一个Gobject对象强制转换为Boy对象，这在对象的继承中十分关键，也经常用到。

####对象的实现

下面的代码实现了上面的Boy对象的定义：
```C
/* boy.c */
#include "boy.h"
enum { BOY_BORN, LAST_SIGNAL };
static gint boy_signals[LAST_SIGNAL] = { 0 };
static void boy_cry (void);
static void boy_born(void);
static void boy_init(Boy *boy);
static void boy_class_init(BoyClass *boyclass);
GType boy_get_type(void)
{
	static GType boy_type = 0;
	if(!boy_type)
	{
		static const GTypeInfo boy_info = {
			sizeof(BoyClass),
			NULL,NULL,
			(GClassInitFunc)boy_class_init,
			NULL,NULL,
			sizeof(Boy),
			0,
			(GInstanceInitFunc)boy_init
		};
		boy_type = g_type_register_static(G_TYPE_OBJECT,"Boy",&boy_info,0);
	}
	return boy_type;
}
static void boy_init(Boy *boy)
{
	boy->age = 0;
	boy->name = "none";
	boy->cry = boy_cry;
}
static void boy_class_init(BoyClass *boyclass)
{
	boyclass->boy_born = boy_born;
	boy_signals[BOY_BORN] = g_signal_new("boy_born",
				BOY_TYPE,
				G_SIGNAL_RUN_FIRST,
				G_STRUCT_OFFSET(BoyClass,boy_born),
				NULL,NULL,
				g_cclosure_marshal_VOID__VOID,
				G_TYPE_NONE, 0, NULL);
}
Boy *boy_new(void)
{
	Boy *boy;
	boy = g_object_new(BOY_TYPE, NULL);
	g_signal_emit(boy,boy_signals[BOY_BORN],0);
	return boy;
}
int boy_get_age(Boy *boy)
{
	return boy->age;
}
void boy_set_age(Boy *boy, int age)
{
	boy->age = age;
}
char *boy_get_name(Boy *boy)
{
	return boy->name;
}
void boy_set_name(Boy *boy, char *name)
{
	boy->name = name;
}
Boy*  boy_new_with_name(gchar *name)
{
	Boy* boy;
	boy = boy_new();
	boy_set_name(boy, name);
	return boy;
}
Boy*  boy_new_with_age(gint age)
{
	Boy* boy;
	boy = boy_new();
	boy_set_age(boy, age);
	return boy;
}
Boy *boy_new_with_name_and_age(gchar *name, gint age)
{
	Boy *boy;
	boy = boy_new();
	boy_set_name(boy,name);
	boy_set_age(boy,age);
	return boy;
}
static void boy_cry (void)
{
	g_print("The Boy is crying ......\n");
}
static void boy_born(void)
{
	g_print("Message : A boy was born .\n");
}
void  boy_info(Boy *boy)
{
	g_print("The Boy name is %s\n", boy->name);
	g_print("The Boy age is %d\n", boy->age);
}
```
在这段代码中，出现了实现Boy对象的关键函数，这是在Boy对象的定义中未出现的，也是没必要出现的。就是两个初始化函数，boy_init和boy_class_init，它们分别用来初始化实例结构和类结构。它们并不被在代码中明显调用，关键是将其用宏转换为地址指针，然后赋值到GTypeInfo结构中，然后由GType系统自行处理，同时将它们定义为静态的也是非常必要的。

GTypeInfo结构中定义了对象的类型信息，包括以下内容：

    包括类结构的长度（必需，即我们定义的BoyClass结构的长度）；
    基础初始化函数（base initialization function，可选）；
    基础结束化函数（base finalization function，可选）；

（以上两个函数可以对对象使用的内存来做分配和释放操作，使用时要用GBaseInitFunc和GBaseFinalizeFunc来转换为指针，本例中均未用到，故设为NULL。）
类初始化函数（即我们这里的boy_class_init函数，用GclassInit宏来转换，可选，仅用于类和实例类型）；
类结束函数（可选）；
实例初始化函数（可选，即我们这里的boy_init函数）；
最后一个成员是GType变量表（可选）。 

定义好GTypeInfo结构后就可以用g_type_register_static函数来注册对象的类型了。

g_type_register_static函数用来注册对象的类型，它的第一个参数是表示此对象的父类的对象类型，我们这里是G_TYPE_OBJECT，这个宏用来表示GObject的父类；第二个参数表示此对象的名称，这里为"Boy"；第三个参数是此对象的GTypeInfo结构型指针，这里赋值为&boyinfo；第四个参数是对象注册成功后返回此对象的整型ID标识。

g_object_new函数，用来创建一个基于G_OBJECT的对象，它可以有多个参数，第一个参数是上面说到的已注册的对象标识ID；第二个参数表示后面参数的数量，如果为0，则没有第三个参数；第三个参数开始类型都是GParameter类型，它也是一个结构型，定义为：
```C
struct GParameter{
		const gchar* name;
		GValue value;
	};
```
关于GValue，它是变量类型的统一定义，它是基础的变量容器结构，用于封装变量的值和变量的类型，可以GOBJECT文档的GVALUE部分。

####信号的定义和应用

在GObject系统中，信号是一种定制对象行为的手段，同时也是一种多种用途的通知机制。初学者可能是在GTK+中首先接触到信号这一概念的，事实上在普通的字符界面编程中也可以正常应用，这可能是很多初学者未曾想到的。

一个对象可以没有信号，也可以有多个信号。当有一或多个信号时，信号的名称定义是必不可少的，此时C语言的枚举类型的功能就凸显出来了，用LAST_SIGNAL来表示最后一个信号（不用实现的信号）是一种非常良好的编程风格。这里为Boy对象定义了一个信号BOY_BORN，在对象创建时发出，表示Boy对象诞生。

同时还需要定义静态的整型指针数组来保存信号的标识，以便于下一步处理信号时使用。

对象的类结构是所有对象的实例所共有的，我们将信号也定义在对象的类结构中，如此信号同样也是所有对象的实例所共有的，任意一个对象的实例都可以处理信号。因此我们有必要在在类初始化函数中创建信号（这也可能是GObject设计者的初衷）。函数g_signal_new用来创建一个新的信号，它的详细使用方法可以在GObject的API文档中找到。信号创建成功后，返回一个信号的标识ID，如此就可以用发射信号函数g_signal_emit向指定义对象的实例发射信号，从而执行相应的功能。

本例中每创建一个新的Boy对象，就会发射一次BOY_BORN信号，也就会执行一次我们定义的boy_born函数，也就输出一行"Message : A boy was born ."信息。

####对象的属性和方法

对象实例所有的属性和方法一般都定义在对象的实例结构中，属性定义为变量或变量指针，而方法则定义为函数指针，如此，我们一定要定义函数为static类型，当为函数指针赋值时，才能有效。

####对象的继承

以下为继承自Boy对象的Man对象的实现，Man对象在Boy对象的基础上又增加了一个属性job和一个方法bye。
```C
#ifndef __MAN_H__
#define __MAN_H__
#include "boy.h"
#define MAN_TYPE  (man_get_type())
#define MAN(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj),MAN_TYPE,Man))
typedef struct _Man Man;
typedef struct _ManClass ManClass;
struct _Man {
	Boy parent;
	char *job;
	void (*bye)(void);
};
struct _ManClass {
	BoyClass parent_class;
};
GType man_get_type(void);
Man*  man_new(void);
gchar* man_get_gob(Man *man);
void  man_set_job(Man *man, gchar *job);
Man*  man_new_with_name_age_and_job(gchar *name, gint age, gchar *job);
void man_info(Man *man);
#endif //__MAN_H__
/* man.c */
#include "man.h"
static void man_bye(void);
static void man_init(Man *man);
static void man_class_init(Man *man);
GType man_get_type(void)
{
	static GType man_type = 0;
	if(!man_type)
	{
		static const GTypeInfo man_info = {
			sizeof(ManClass),
			NULL, NULL,
			(GClassInitFunc)man_class_init,
			NULL, NULL,
			sizeof(Man),
			0,
			(GInstanceInitFunc)man_init
		};
		man_type = g_type_register_static(BOY_TYPE, "Man", &man_info, 0);
	}
	return man_type;
}
static void man_init(Man *man)
{
	man->job = "none";
	man->bye = man_bye;
}
static void man_class_init(Man *man)
{
}
Man*  man_new(void)
{
	Man *man;
	man = g_object_new(MAN_TYPE, 0);
	return man;
}
gchar* man_get_gob(Man *man)
{
	return man->job;
}
void  man_set_job(Man *man, gchar *job)
{
	man->job = job;
}
Man*  man_new_with_name_age_and_job(gchar *name, gint age, gchar *job)
{
	Man *man;
	man = man_new();
	boy_set_name(BOY(man), name);
	boy_set_age(BOY(man), age);
	man_set_job(man, job);
	return man;
}
static void man_bye(void)
{
	g_print("Goodbye everyone !\n");
}
void man_info(Man *man)
{
	g_print("the man name is %s\n", BOY(man)->name);
	g_print("the man age is %d\n", BOY(man)->age);
	g_print("the man job is %s\n", man->job);
}
```
关键在于定义对象时将父对象实例定义为Boy，父类设定为BoyClass，在注册此对象时将其父对象类型设为BOY_TYPE，在设定对象属性时如用到父对象的属性要强制转换下，如取得对象的name属性，就必须用BOY(obj)->name，因为Man本身没有name属性，而其父对象Boy有，所以用BOY宏将其强制为Boy类型的对象。

####测试我们定义的对象
```C
#include <glib.h>
#include "boy.h"
#include "man.h"
int main(int argc, char *argv[])
{
	Boy *tom, *peter;
	Man *green, *brown;	
	g_type_init();//注意，初始化类型系统，必需
	tom = boy_new_with_name("Tom");
	tom->cry();
	boy_info(tom);
	peter = boy_new_with_name_and_age("Peter", 10);
	peter->cry();
	boy_info(peter);
	green = man_new();
	boy_set_name(BOY(green), "Green");
//设定Man对象的name属性用到其父对象Boy的方法
	boy_set_age(BOY(green), 28);
	man_set_job(green, "Doctor");
	green->bye();
	man_info(green);
	brown = man_new_with_name_age_and_job("Brown", 30, "Teacher");
	brown->bye();
	man_info(brown);
}
Makefile文件如下：
CC = gcc
all:
	$(CC) -c boy.c `pkg-config --cflags glib-2.0 gobject-2.0`
	$(CC) -c man.c `pkg-config --cflags glib-2.0 gobject-2.0`
	$(CC) -c main.c `pkg-config --cflags glib-2.0 gobject-2.0`
	$(CC) -o simple boy.o man.o main.o `pkg-config --libs glib-2.0 gobject-2.0`
执行make命令编译，编译结束后，执行./simple运行此测试程序，输出结果如下：
Message : A boy was born .
The Boy is crying ......
The Boy name is Tom
The Boy age is 0
Message : A boy was born .
The Boy is crying ......
The Boy name is Peter
The Boy age is 10
Goodbye everyone !
the man name is Green
the man age is 28
the man job is Doctor
Goodbye everyone !
the man name is Brown
the man age is 30
the man job is Teacher

Makefile中用到`pkg-config -cflags -libs gobject-2.0`，
在GLIB中将线程（gthread），插件（gmoudle）和对象系统（gobject）这三个子系统区别对待，编译时要注意加入相应的参数。
```
本文只是概要的介绍了如何定义和实现GObject对象，GObject系统中还有很多相关内容，如：枚举和标识类型（Enumeration and flags types）；Gboxed，是Gtype系统中注册一种封装为不透明的C语言结构类型的机制；许多对象用到的参数对象都是C结构类型，使用者不必了解其结构的内部定义，即不透明，GBoxed即是实现这一功能的机制；标准的参数和变量类型的定义（Standard Parameter and Value Types）等，它们都以C语言来开发，是深入了解和掌握GObject的关键。



####Why Bother to use Gobject?
* 
GObject告诉我们，使用C语言编写程序时，可以运用面向对象这种编程思想。
* 
Gobject系统提供了一个灵活的、可扩展的、并且容易映射到其他语言的面向对象的C语言框架。
* 
GObject的动态类型系统允许程序在运行时进行类型注册，它的最主要目的有两个：
    * 
使用面向对象的设计方法来编程。GObject仅依赖于GLib和libc,通过它可使用纯C语言设计一整套面向对象的软件模块。
    * 
多语言交互。在为已经使用 GObject框架写好的函数库建立多语言连结时，可以很容易对应到许多语言，包括C++、Java、Ruby、Python和.NET/Mono等。GObject被设计为可以直接使用在C 程序中，也封装至其他语言。   
 
####透明的跨语言互通性
—Gobject如何解决静态语言与动态语言的沟通问题？<br>
—在python语言中调用一个C的API：C的API是常常是一些从二进制文件中导出的函数集和全局变量。C的函数可以有任意数量的参数和一个返回值。每个函数有唯一的由函数名确定的标识符，并且由C类型来描述参数和返回值。类似的，由API导出的全局变量也是由它们的名字和类型所标识。一个C的API可能仅仅定义了一些类型集的关联。例如：
```C
    static void function_foo(int foo)  
    {  
    }  
      
    int main(int argc, char *argv[])  
    {  
       function_foo(10)  
       return 0;  
    }  
```

如果你了解函数调用和C类型至你所在平台的机器类型的映射关系，你可以在内存中解析到每个函数的名字从而找到这些代码所关联的函数的位置，并且构造出一个用在这个函数上的参数列表。最后，你可以用这个参数列表来调用这个目标C函数。第一个指令在堆栈上建立了十六进制的值0xa（十进制为10）作为一个32位的整型，并调用了function_foo函数。就如你看到的，C函数的调用由gcc实现成了本地机器码的调用（这是实现起来最快的方法）。

    push $0xa  
    call 0x80482f4 <function_foo>  


有了gcc这个第三方，我们的代码与机器的沟通更顺畅了！记住：GType/GObject库不仅仅是为了设计向C开发者提供面向对象的特性，也是为了透明的跨语言互通性。
####做一个受欢迎的协调者
—为了实现调用C函数，Python解释器需要做：

(1)找到函数所处的位置：这个意味着在C编译器编译成的二进制文件中寻找这个函数。

(2)在可执行的内存中，载入有关这个函数的相关代码。

(3)在调用这个函数前，将Python的参数转换为C兼容的参数。

(4)用正确的方式调用这个函数。

(5)将C函数的返回值转换成Python兼容的变量并将其返回至Python代码中。<br>
—方案一：手动编写一些“粘合代码”，当每个函数被导入或导出时，使用这些代码将Python的参数转换为C兼容的参数，并将C的返回值转换为Python兼容的返回值。这个粘合代码将被连接到解释器上，从而解释器在解释Python程序时，可以完成程序中的调用C函数的工作。方案二：自动产生粘合代码，当每个函数被导入或导出时，使用一个特殊的编译器来读取原始的函数签名。

—GLib用的解决办法是，使用GType库来保存在当前运行环境中的所有由开发者描述的对象的描述。这些“动态类型”库将被特殊的“通用粘合代码”,来自动转换函数参数和进行函数调用在不同的运行环境之间。
####GOBJECT模拟封装
在 GObject世界里，类是两个结构体的组合，一个是实例结构体，另一个是类结构体。有点绕。类、对象、实例有什么区别？可以这么理解，类-对象-实例，无非就是类型，该类型所声明的变量，变量所存储的内容。后面可以知道，类结构体初始化函数一般被调用一次，而实例结构体的初始化函数的调用次数等于对象实例化的次数。所有实例共享的数据，可保存在类结构体中，而所有对象私有的数据，则保存在实例结构体中。

####GOBJCT如何模拟私有属性
—一种最简单的办法，是在类的定义时，只需要向结构体中添加一条注释，用于标明哪些成员是私有的，哪些是可以被直接访问的。C语言认为，程序员应当知道自己正在干什么，而且保证自己的所作所为是正确的。
—第二种办法，也就是最常用的办法，是把需要设为私有属性的数据再次封装，并且将该封装实例的定义放到实现.c文件中。在上页的例子中，GUPnPContextPrivate的定义就被定义为私有，其定义放在gupnp-context.c文件中
 
####C语言实现CLASS域GOBJECT支持

    如何实现gobject面向对象支持呢？

    很简单，我们只需要建立自己的头文件，并添加一些宏定义G_DEFINE_TYPE即可。

这样，GUPnPContext就成为了Gobject库认可的一类合法公民了，即成功的把GUpnPContextClass类所代表的type(类型)注册到了glib类型系统中，并且将成功获取到一个类型ID。

也就是说，当你设计新类时，GUPnPContext可以被考虑加进你的继承体系，同时GUPnPContext也可以被用于组合成其他的类。
 进一步理解GType类型系统
—Gtype类型系统是Glib运行时类型认证和管理系统。
—Gtype API是Gobject系统的基础，它提供注册和管理所有基本数据、用户定义对象和接口类型的技术实现。如： G_DEFINE_TYPE宏、G_DEFINE_INTERFACE宏、g_type_register_static函数等都在GType实现。
—前面提到的G_DEFINE_TYPE宏，展开后主要用于实现用户定义类型，包括：声明类初始化函数、声明实例初始化函数、声明父类的一些信息、以及用于获取分配类型ID的xx_xx_get_type()函数
#### GOBEJCT如何实现继承
* 
前面我们已经介绍，在 GObject世界里，类是两个结构体的组合，一个是实例结构体，另一个是类结构体。
* 
很容易理解，GOBJECT的继承需要实现实例结构体的继承和类结构体的继承。
* 
在前面的例子，我们通过在gupnpcontext实例中显示声明GSSDPClient parent来告知gobject系统GSSDPClient是gupnpcontext实例的双亲；同时，通过GUPnPContextClass定义中声明GSSDPClientClassparent_class。通过实例结构体和类结构体的共同声明，
* 
GOBJECT知道gupnpcontext是gssdpclient的子类。
GOBJECT构造函数
* 
Gobject对象的初始化可分为2部分：类结构体初始化和实例结构体初始化。
类结构体初始化函数只被调用一次，而实例结构体的初始化函数的调用次数等于对象实例化的次数。这意味着，所有对象共享的数据，可保存在类结构体中，而所有对象私有的数据，则保存在实例结构体中。
####多态的概念
* 
多态指同一个实体同时具有多种形式。它是面向对象程序设计的一个重要特征。
* 
把不同的子类对象都当作父类来看，可以屏蔽不同子类对象之间的差异，写出通用的代码，做出通用的编程，以适应需求的不断变化。
* 
赋值之后，父对象就可以根据当前赋值给它的子对象的特性以不同的方式运作。也就是说，父亲的行为像儿子，而不是儿子的行为像父亲。
* 
我们这里讨论的多态，主要指运行时多态，其具体引用的对象在运行时才能确定。
####为什么要在GOBJECT引入多态？
* 
用C的struct可以实现对象。普通的结构体成员可以实现为成员数据，而对象的成员函数则可以由函数指针成员来实现。很多开源的软件也正是这么做的。
* 
这样的实现有一些严重的缺陷：别扭的语法、类型安全问题、缺少封装，更实际的问题是空间浪费严重。每一个实例化的对象需要4字节的指针来指向其每一个成员方法，而这些方法对于类的每个实例（对象）应该都是相同的，所以是完全冗余的。假设一个类有4个方法，1000个实例，那么我们将浪费接近16KB的空间。
* 
很明显，我们不需要为每个实例保存这些指针，我们只需要保存一张包含这些指针的表。
####Gobject如何实现多态？

（1）Gobject为每个子类在内存中保存了一份包含成员函数指针的表. 这个表，就是我们在C++经常说到的虚方法表（vtable）。当你想调用一个虚方法时，你必须先向系统请求查找这个对象所对应的虚方法表。这张表包含了一个由函数指针组成的结构体。在调用这些函数时，需要在运行时查找合适的函数指针，这样就能允许子类覆盖这个方法，我们称之为“虚函数”。

(2)  Gobject系统要求我们向它注册新声明的类型，系统同时要求我们去向它注册（对象的和类的）结构体构造和析构函数（以及其他的重要信息），这样系统就能正确的实例化我们的对象。

（3）Gobject系统通过枚举化所有的向它注册的类型来记录新的对象类型，并且要求所有实例化对象的第一个成员是一个指向它自己类的虚函数表的指针，每个虚函数表的第一个成员是它在系统中保存的枚举类型的数字表示。
由常用的g_object_new()想到的
—g_object_new能够为我们进行对象的实例化.所以它必然要知道对象对应的类的数据结构.
—如上图示例，除第一个参数外，很容易猜想后面的参数都是“属性名-属性值”的配对。
—第一个参数其实是一个宏：具体细节可以不去管它，可以知道它是去获取数据类型xx_xx_get_type函数的作用就是告诉它有关PMDList类的具体结构。在*.c文件实现中，G_DEFINE_TYPE宏可以为我们生成xx_xx_get_type函数的实现代码。 它可以帮助我们最终实现类类型的定义。 。 当g_object_new从xx_xx_get_type函数那里获取类类型标识码之后，便可以进行对象实例的内存分配及属性的初始化。初始化函数在前面已有介绍。
GOBJECT多态：将丑陋封锁在内部
—要想实现前面讲述的让g_object_new函数中通过“属性名-属性值”结构为Gobject子类对象的属性进行初始化，我们需要完成以下工作：

（1）实现xx_xx_set_property与xx_xx_get_property函数，完成g_object_new函数“属性名-属性值”结构向Gobject子类属性的映射;

  (2)在Gobject子类的类结构体初始化函数中，让Gobject基类的两个函数指针set_property与get_property分别指向xx_xx_set_property与xx_xx_get_property。

（3）在Gobject子类的类结构体初始化函数中，为Gobject子类安装具体对象的私有属性。

可以看出，set_property是Gobject的虚函数实现，是运行时的多态。
GOBJECT多态：将优雅展示于外界
—set_property是2个函数指针，位于Gobject基类的类结构体中。这说明，它们可以被Gobject类及其子类的所有对象共享，并且各个对象都可以让这2个函数指针指向它所期望的函数。
—类似的机制，在C++中被称为虚函数，主要用于实现多态。
—由于有了这种机制，我们可以使用g_object_new函数在对象实例化时便进行对象的初始化。
—当我们要获取或设置类的实例属性时，可直接使用统一的接口：g_object_get_propertyg_object_set_property
GOBJECT属性实现：泛型与多态

假设我们需要一种数据类型，可以实现一个可以容纳多类型元素的链表，我想为这个链表编写一些接口，可以不依赖于任何特定的类型，并且不需要我为每种数据类型声明一个多余的函数。这种接口必然能涵盖多种类型，我们称它为GValue（Generic Value，泛型）。

要编写一个泛型的属性设置机制，我们需要一个将其参数化的方法，以及与实例结构体中的成员变量名查重的机制。从外部上看，我们希望使用C字符串来区分属性和公有API，但是内部上来说，这样做会严重的影响效率。因此我们枚举化了属性，使用索引来标识它们。

属性规格，在Glib中被称作!GParamSpec，它保存了对象的gtype，对象的属性名称，属性枚举ID，属性默认值，边界值等，类型系统用!GParamSpec来将属性的字符串

名转换为枚举的属性ID，GParamSpec也是一个能把所有东西都粘在一起的大胶水。

####gobject属性设置
 
—当我们需要设置或者获取一个属性的值时，传入属性的名字，并且带上GValue用来保存我们要设置的值，调用g_object_set/get_property。g_object_set_property函数将在GParamSpec中查找我们要设置的属性名称，查找我们对象的类，并且调用对象的set_property方法。这意味着如果我们要增加一个新的属性，就必须要覆盖默认的set/get_property方法。而且基类包含的属性将被它自己的方法所正常处理，因为GParamSpec就是从基类传递下来的。最后，应该记住，我们必须事先通过对象的class_init方法来传入GParamSpec参数，用于安装上属性！
 Gobject消息系统：闭包

      一个Closure是一个抽象的、通用表示的回调（callback）。它是一个包含三个对象的简单结构：

     （1）一个函数指针（回调本身） ，原型类似于：

   return_type function_callback (... , gpointeruser_data);

     （2） user_data指针用来在调用Closure时传递到callback。

    （3）一个函数指针，代表Closure的销毁：当Closure的引用数达到0时，这个函数将被调用来释放Closure的结构。

一个GClosure提供以下简单的服务：

调用（g_closure_invoke）：这就是Closure创建的目的： 它们隐藏了回调者的回调细节。

通知：相关事件的Closure通知监听者如Closure调用，Closure无效和Clsoure终结。监听者可以用注册g_closure_add_finalize_notifier（终结通知），g_closure_add_invalidate_notifier（无效通知）和g_closure_add_marshal_guards（调用通知）。

对于终结和无效事件来说，这是对等的函数（g_closure_remove_finalize_notifier和g_closure_remove_invalidate_notifier，但调用过程不是。

 
“一眼望穿”闭包
—GClosureMarshal是一个函数指针,但是要注意它是用来定义回调函数类型的而不是直接调用。
 
GObject中真正的回调是marshal_data,这个是一个void *指针。这个在可通过查看C语言Marshaller的实现来得到证明。
Gobject为什么搞这么复杂？用于其它语言间的绑定.
闭包给多语言绑定带来了方便

我们从分析g_signal_new函数的使用来说明这个问题。第7个参数为GSignalMarshaller类型，它与前面体面提到的GClosureMarshal是一个东西，都是一个函数指针。

GSignalCMarshaller c_marshaller:该参数是一个GSignalCMarshall类型的函数指针，其值反映了回调函数的返回值类型和额外参数类型（所谓“额外参数”，即指除回调函数中instance和user_data以外的参数）。 

例如，g_closure_marshal_VOID_VOID说明该signal的回调函数为以下的callback类型：
typedef  void (*callback)  (gpointer instance, gpointer user_data);
而g_closure_marshal_VOID_POINTER则说明该signal的回调函数为以下的callback类型：
typedef void (*callback)  (gpointer instance,gpointer arg1,gpointer user_data);
GType return_type:该参数的值应为回调函数的返回值在GType类型系统中的ID。
guintn_params:该参数的值应为回调函数的额外参数的个数。
...: 这一系列的参数的值应为回调函数的额外参数在GType类型系统中的ID，且这一系列参数中第一个参数的值为回调函数的第一个额外参数在GType类型系统中的ID，依次类推。

可以认为，信号就是包含对可以连接到信号的闭包的描述和对连接到信号的闭包的调用顺序的规定的集合体。

事实上，它是用来翻译闭包的参数和返回值类型的，它将翻译的结果传递给闭包。之所以不直接调用callback或闭包，而在外面加了一层marshal的封装，主要是方便gobjec库与其他语言的绑定。例如，我们可以写一个pyg_closure_marshal_void_string函数，其中可以调用python语言编写的“闭包”并将其计算结果传递给Gvalue容器，然后再从Gvalue容器中提取计算结果。
Gobject消息系统：Signal机制
—在gobject系统中，信号是一种定制对象行为的手段，也是一种多种用途的通知机制。
—每一个信号都是和能发出信号的类型一起注册到系统中的。
—该类型的使用者，需要实现信号与闭包的连接，在给定的信号和给定的closure间指定对应关系，这样在信号被发射时，闭包会被调用。信号是closure被调用的主要机制;
—使用 GObject信号机制，一般有三个步骤：

（1）信号注册，主要解决信号与数据类型的关联问题

（2）信号连接，主要处理信号与闭包的连接问题；

（3）信号发射,   调用callback进行处理。

 
[返回目录](README.md)