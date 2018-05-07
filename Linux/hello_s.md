
## AT&T格式汇编 HelloWorld

环境Linux Ubuntu:

**hello.s  **
```C
.data                    # 数据段声明
msg : .string "Hello, world!\n" # 要输出的字符串
    len = . - msg                   # 字串长度
.text                    # 代码段声明 
.global _start           # 指定入口函数
_start:                  # 在屏幕上显示一个字符串
    movl $len, %edx  # 参数三：字符串长度
    movl $msg, %ecx  # 参数二：要显示的字符串
    movl $1, %ebx    # 参数一：文件描述符(stdout)
    movl $4, %eax    # 系统调用号(sys_write)
    int  $0x80       # 调用内核功能
                     # 退出程序
    movl $0,%ebx     # 参数一：退出代码
    movl $1,%eax     # 系统调用号(sys_exit)
    int  $0x80       # 调用内核功能```
         
Compile:<br>
　　　　as -o as.o as.s
或者gcc -c as.s

Link:<br>
　　　　ld -s -o as as.o

Run:<br>
　　　　./as


**AT&T和Intel基本语法区别**
<div id="cnblogs_post_body"><p>GCC采用的是AT&amp;T的汇编格式, 也叫GAS格式(Gnu ASembler GNU汇编器), 而微软采用Intel的汇编格式.    <br>一 基本语法     <br>语法上主要有以下几个不同.     <br>1、寄存器命名原则</p>  <table border="1" cellpadding="1" cellspacing="1" width="621"><tbody>     <tr>       <td valign="top" width="136">AT&amp;T</td>        <td valign="top" width="148">Intel</td>        <td valign="top" width="344">说明</td>     </tr>      <tr>       <td valign="top" width="136">%eax</td>        <td valign="top" width="148">eax</td>        <td valign="top" width="344">Intel的不带百分号</td>     </tr>   </tbody></table>  <p>   <br>2、源/目的操作数顺序</p>  <table border="1" cellpadding="1" cellspacing="1" width="624"><tbody>     <tr>       <td valign="top" width="134">AT&amp;T</td>        <td valign="top" width="144">Intel</td>        <td valign="top" width="340">说明</td>     </tr>      <tr>       <td valign="top" width="134">movl %eax, %ebx</td>        <td valign="top" width="144">mov ebx, eax</td>        <td valign="top" width="340">Intel的目的操作数在前,源操作数在后</td>     </tr>   </tbody></table>  <p>   <br>3、常数/立即数的格式</p>  <table border="1" cellpadding="1" cellspacing="1" width="623"><tbody>     <tr>       <td valign="top" width="133">AT&amp;T</td>        <td valign="top" width="143">Intel</td>        <td valign="top" width="341">说明</td>     </tr>      <tr>       <td valign="top" width="133">movl $_value,%ebx</td>        <td valign="top" width="143">mov eax,_value</td>        <td valign="top" width="341">Intel的立即数前面不带$符号</td>     </tr>      <tr>       <td valign="top" width="133">movl $0xd00d,%ebx</td>        <td valign="top" width="143">mov ebx,0xd00d</td>        <td valign="top" width="341">规则同样适用于16进制的立即数</td>     </tr>   </tbody></table>  <p>   <br>4、操作数长度标识</p>  <table border="1" cellpadding="1" cellspacing="1" width="624"><tbody>     <tr>       <td valign="top" width="134">AT&amp;T</td>        <td valign="top" width="144">Intel</td>        <td valign="top" width="340">说明</td>     </tr>      <tr>       <td valign="top" width="134">movw %ax,%bx</td>        <td valign="top" width="144">mov bx,ax</td>        <td valign="top" width="340">Intel的汇编中, 操作数的长度并不通过指令符号来标识</td>     </tr>   </tbody></table>     <p>在AT&amp;T的格式中, 每个操作都有一个字符后缀, 表明操作数的大小. 例如:mov指令有三种形式:</p>    <p>movb&nbsp; 传送字节</p>    <p>movw&nbsp; 传送字</p>    <p>movl&nbsp;&nbsp; 传送双字</p>    <p>movq 64位机</p><p>因为在许多机器上, 32位数都称为长字(long word), 这是沿用以16位字为标准的时代的历史习惯造成的.</p>    <p>---------摘自《深入理解计算机系统》</p> <p>5、长调用和跳转使用不同语法定义段和偏移量</p><p><br> AT&T语法使用ljmp $section, $offset，而Intel语法使用jmp section:offset。</p> <p>   <br>6、寻址方式</p>  <table border="1" cellpadding="1" cellspacing="1" width="671"><tbody>     <tr>       <td valign="top" width="313">AT&amp;T</td>        <td valign="top" width="353">Intel</td>     </tr>      <tr>       <td valign="top" width="313">imm32(basepointer,indexpointer,indexscale) </td>        <td valign="top" width="353">[basepointer + indexpointer*indexscale + imm32) </td>     </tr>   </tbody></table>  <p>两种寻址的实际结果都应该是</p>  <p>imm32 + basepointer + indexpointer*indexscale</p>    <p>AT&amp;T的汇编格式中, 跳转指令有点特殊.</p>    <p>直接跳转, 即跳转目标是作为指令的一部分编码的. </p>    <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 例如: jmp Label_1</p>    <p>间接跳转, 即跳转目标是从寄存器或存储器位置中读出的. 写法是在" * "后面跟一个操作数指示符.</p>    <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 例如: jmp *%eax 用寄存器%eax中的值作为跳转目标</p>    <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; jmp *(%eax) 以%eax中的值作为读入的地址, 从存储器中读出跳转目标</p>    <p>--------摘自《深入理解计算机系统》</p>  <p>&nbsp;</p> </div>
下面是一些寻址的例子：

AT&T: `-4(%ebp)'             相当于 Intel: `[ebp - 4]'<br>
AT&T: `foo(,%eax,4)'    相当于 Intel: `[foo + eax*4]'<br>
AT&T: `foo(,1)'           相当于 Intel `[foo]'<br>
AT&T: `%gs:foo'          相当于 Intel`gs:foo' <br>
<br>
<h3>通用寄存器</h3>
<tbody>
	<tr>
	<td colspan="3" nowrap="nowrap">8位</td>
	<td colspan="2" nowrap="nowrap">16位</td>
	<td colspan="2" nowrap="nowrap">32位</td>
	<td colspan="2" nowrap="nowrap">64位</td>
	</tr>
	<tr>
	<td nowrap="nowrap">原</td>
	<td colspan="2" nowrap="nowrap">新增</td>
	<td nowrap="nowrap">原</td>
	<td nowrap="nowrap">新增</td>
	<td nowrap="nowrap">原</td>
	<td nowrap="nowrap">新增</td>
	<td nowrap="nowrap">扩展</td>
	<td nowrap="nowrap">新增</td>
	</tr>
	<tr>
	<td nowrap="nowrap">al</td>
	<td rowspan="4" nowrap="nowrap">---</td>
	<td nowrap="nowrap">r8b</td>
	<td nowrap="nowrap">ax</td>
	<td nowrap="nowrap">r8w</td>
	<td nowrap="nowrap">eax</td>
	<td nowrap="nowrap">r8d</td>
	<td nowrap="nowrap">rax</td>
	<td nowrap="nowrap">r8</td>
	</tr>
	<tr>
	<td nowrap="nowrap">cl</td>
	<td nowrap="nowrap">r9b</td>
	<td nowrap="nowrap">cx</td>
	<td nowrap="nowrap">r9w</td>
	<td nowrap="nowrap">ecx</td>
	<td nowrap="nowrap">r9d</td>
	<td nowrap="nowrap">rcx</td>
	<td nowrap="nowrap">r9</td>
	</tr>
	<tr>
	<td nowrap="nowrap">dl</td>
	<td nowrap="nowrap">r10b</td>
	<td nowrap="nowrap">dx</td>
	<td nowrap="nowrap">r10w</td>
	<td nowrap="nowrap">edx</td>
	<td nowrap="nowrap">r10d</td>
	<td nowrap="nowrap">rdx</td>
	<td nowrap="nowrap">r10</td>
	</tr>
	<tr>
	<td nowrap="nowrap">bl</td>
	<td nowrap="nowrap">r11b</td>
	<td nowrap="nowrap">bx</td>
	<td nowrap="nowrap">r11w</td>
	<td nowrap="nowrap">ebx</td>
	<td nowrap="nowrap">r11d</td>
	<td nowrap="nowrap">rbx</td>
	<td nowrap="nowrap">r11</td>
	</tr>
	<tr>
	<td nowrap="nowrap">ah</td>
	<td nowrap="nowrap">spl</td>
	<td nowrap="nowrap">r12b</td>
	<td nowrap="nowrap">sp</td>
	<td nowrap="nowrap">r12w</td>
	<td nowrap="nowrap">esp</td>
	<td nowrap="nowrap">r12d</td>
	<td nowrap="nowrap">rsp</td>
	<td nowrap="nowrap">r12</td>
	</tr>
	<tr>
	<td nowrap="nowrap">ch</td>
	<td nowrap="nowrap">bpl</td>
	<td nowrap="nowrap">r13b</td>
	<td nowrap="nowrap">bp</td>
	<td nowrap="nowrap">r13w</td>
	<td nowrap="nowrap">ebp</td>
	<td nowrap="nowrap">r13d</td>
	<td nowrap="nowrap">rbp</td>
	<td nowrap="nowrap">r13</td>
	</tr>
	<tr>
	<td nowrap="nowrap">dh</td>
	<td nowrap="nowrap">sil</td>
	<td nowrap="nowrap">r14b</td>
	<td nowrap="nowrap">si</td>
	<td nowrap="nowrap">r14w</td>
	<td nowrap="nowrap">esi</td>
	<td nowrap="nowrap">r14d</td>
	<td nowrap="nowrap">rsi</td>
	<td nowrap="nowrap">r14</td>
	</tr>
	<tr>
	<td nowrap="nowrap">bh</td>
	<td nowrap="nowrap">dil</td>
	<td nowrap="nowrap">r15b</td>
	<td nowrap="nowrap">di</td>
	<td nowrap="nowrap">r15w</td>
	<td nowrap="nowrap">edi</td>
	<td nowrap="nowrap">r15d</td>
	<td nowrap="nowrap">rdi</td>
	<td nowrap="nowrap">r15</td>
	</tr>
</tbody>
<h3>常用汇编指令集合</h3>
<div id="cnblogs_post_body"><br>-----------------------算数运算指令-----------------------<br>ADD&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 加法<br>ADC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 带位加法<br>SBB &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 带位减法<br>SUB&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 减法.<br>INC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 加法.<br>NEC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 求反(以0减之). <br>NEG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 求反然后加1，假如NEG AL相当于Not AL; INC AL<br>CMP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 比较.(两操作数作减法,仅修改标志位,不回送结果). <br>INC DPTR&nbsp;&nbsp;&nbsp;&nbsp; 数据指针寄存器值加1 (说明：将16位的DPTR加1，当DPTR的低字节(DPL)从FFH溢出至00H时，会使高字<br>节(DPH)加1，不影响任何标志位)<br><br>MUL A B&nbsp;&nbsp;&nbsp;&nbsp; 将累加器的值与B寄存器的值相乘，乘积的低位字节存回累加器，高位字节存回B寄存器(说明：将累加<br>器A和寄存器B内的无符号整数相乘，产生16位的积，低位字节存入A，高位字节存入B寄存器.如果积大于FFH，则溢出<br><p>标志位(OV)被设定为1，而进位标志位为0) <br></p>IMUL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 整数乘法. 以上两条,结果回送AH和AL(字节运算),或DX和AX(字运算), <br>DIV A B&nbsp;&nbsp;&nbsp;&nbsp; 将累加器的值除以B寄存器的值，结果的商存回累加器，余数存回B寄存器(说明：无符号的除法运算，<br>将累加器A除以B寄存器的值，商存入A，余数存入B。执行本指令后，进位位(C)及溢出位(OV)被清除为0)<br><br>IDIV&nbsp;&nbsp;&nbsp; 整数除法. 以上两条,结果回送: 商回送AL,余数回送AH, (字节运算);&nbsp; 或&nbsp; 商回送AX,余数回送DX, (字运<br><br>算). <br><br>&nbsp;AAA&nbsp;&nbsp;&nbsp; 加法的ASCII码调整. <br>&nbsp;DAA&nbsp;&nbsp;&nbsp; 加法的十进制调整. <br>&nbsp;AAS&nbsp;&nbsp;&nbsp; 减法的ASCII码调整. <br>&nbsp;DAS&nbsp;&nbsp;&nbsp; 减法的十进制调整. <br>&nbsp;AAM&nbsp;&nbsp;&nbsp; 乘法的ASCII码调整. <br>&nbsp;AAD&nbsp;&nbsp;&nbsp; 除法的ASCII码调整. <br>&nbsp;CBW&nbsp;&nbsp; 字节转换为字. (把AL中字节的符号扩展到AH中去) <br>&nbsp;CWD&nbsp;&nbsp; 字转换为双字. (把AX中的字的符号扩展到DX中去) <br>&nbsp;CWDE&nbsp; 字转换为双字. (把AX中的字符号扩展到EAX中去) <br>&nbsp;CDQ&nbsp;&nbsp; 双字扩展.&nbsp;&nbsp;&nbsp;&nbsp; (把EAX中的字的符号扩展到EDX中去) <br><br>-----------------------逻辑运算指令---------------------------------<br>AND&nbsp;&nbsp;&nbsp; 与运算. <br>OR&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 或运算. <br>XOR&nbsp;&nbsp;&nbsp; 异或运算. <br>NOT&nbsp;&nbsp;&nbsp; 取反. <br>TEST&nbsp;&nbsp;&nbsp; 测试.(两操作数作与运算,仅修改标志位,不回送结果). <br>SHL&nbsp;&nbsp;&nbsp; 逻辑左移.<br>SHR&nbsp;&nbsp;&nbsp; 逻辑右移. &nbsp;<br>SAL&nbsp;&nbsp;&nbsp; 算术左移.(=SHL) <br>SAR&nbsp;&nbsp;&nbsp; 算术右移. (左移是一样的，右移是不同的.逻辑右移补0，算术右移补最高位)&nbsp; &nbsp;<br>ROL&nbsp;&nbsp;&nbsp; 循环左移.&nbsp; ( ((unsigned char)a) &lt;&lt; 5 ) | ( ((unsigned char)a) &gt;&gt; 3 ) <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rol eax,cl ==&gt; eax=(eax&lt;&lt;cl)+(eax&gt;&gt;(32-cl)); <br>ROR&nbsp;&nbsp;&nbsp; 循环右移.&nbsp; ror eax,cl ==&gt; eax=(eax&gt;&gt;cl)+(eax&lt;&lt;(32-cl));<br>RCL&nbsp;&nbsp;&nbsp; 通过进位的循环左移. <br>RCR&nbsp;&nbsp;&nbsp; 通过进位的循环右移. <br>以上八种移位指令,其移位次数可达255次. <br>&nbsp;&nbsp; &nbsp;移位一次时, 可直接用操作码.&nbsp; 如 SHL AX,1. <br>&nbsp;&nbsp; &nbsp;移位&gt;1次时, 则由寄存器CL给出移位次数. <br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 如&nbsp; MOV CL,04 <br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;SHL AX,CL <br><br>-----------------------数据转移指令---------------------------------<br><br>1. 通用数据传送指令. <br>&nbsp;&nbsp; &nbsp;MOV&nbsp;&nbsp;&nbsp; 传送字或字节. <br>&nbsp;&nbsp; &nbsp;MOVSX&nbsp; 先符号扩展,再传送. <br>&nbsp;&nbsp; &nbsp;MOVZX&nbsp; 先零扩展,再传送. <br>&nbsp;&nbsp; &nbsp;PUSH&nbsp;&nbsp;&nbsp; 把字压入堆栈. <br>&nbsp;&nbsp; &nbsp;POP&nbsp;&nbsp;&nbsp; 把字弹出堆栈. <br>&nbsp;&nbsp; &nbsp;PUSHA&nbsp; 把AX,CX,DX,BX,SP,BP,SI,DI依次压入堆栈. <br>&nbsp;&nbsp; &nbsp;POPA&nbsp;&nbsp;&nbsp; 把DI,SI,BP,SP,BX,DX,CX,AX依次弹出堆栈. <br>&nbsp;&nbsp; &nbsp;PUSHAD&nbsp; 把EAX,ECX,EDX,EBX,ESP,EBP,ESI,EDI依次压入堆栈. <br>&nbsp;&nbsp; &nbsp;POPAD&nbsp; 把EDI,ESI,EBP,ESP,EBX,EDX,ECX,EAX依次弹出堆栈. <br>&nbsp;&nbsp; &nbsp;BSWAP&nbsp; 交换32位寄存器里字节的顺序 <br>&nbsp;&nbsp; &nbsp;XCHG&nbsp;&nbsp;&nbsp; 交换字或字节.( 至少有一个操作数为寄存器,段寄存器不可作为操作数) <br>&nbsp;&nbsp; &nbsp;CMPXCHG 比较并交换操作数.( 第二个操作数必须为累加器AL/AX/EAX ) <br>&nbsp;&nbsp; &nbsp;XADD&nbsp;&nbsp;&nbsp; 先交换再累加.( 结果在第一个操作数里 ) <br>&nbsp;&nbsp; &nbsp;XLAT&nbsp;&nbsp;&nbsp; 字节查表转换. <br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;── BX 指向一张 256 字节的表的起点, AL 为表的索引值 (0-255,即 0-FFH); 返回 AL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 为查表结果. ( [BX+AL]-&gt;AL ) <br>2. 输入输出端口传送指令. <br>&nbsp;&nbsp; &nbsp;IN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; I/O端口输入. ( 语法: IN 累加器, {端口号│DX} ) <br>&nbsp;&nbsp; &nbsp;OUT&nbsp;&nbsp;&nbsp; I/O端口输出. ( 语法: OUT {端口号│DX},累加器 ) <br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;输入输出端口由立即方式指定时, 其范围是 0-255; 由寄存器 DX 指定时, <br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;其范围是 0-65535. <br>----------------------- 目的地址传送指令-----------------------<br>LEA&nbsp;&nbsp;&nbsp; 装入有效地址.&nbsp; 例: LEA DX,string&nbsp; ;把偏移地址存到DX. <br>LDS&nbsp;&nbsp;&nbsp; 传送目标指针,把指针内容装入DS. 例: LDS SI,string&nbsp; ;把段地址:偏移地址存到DS:SI. <br>LES&nbsp;&nbsp;&nbsp; 传送目标指针,把指针内容装入ES. 例: LES DI,string&nbsp; ;把段地址:偏移地址存到ES:DI. <br>LFS&nbsp;&nbsp;&nbsp; 传送目标指针,把指针内容装入FS. 例: LFS DI,string&nbsp; ;把段地址:偏移地址存到FS:DI. <br>LGS&nbsp;&nbsp;&nbsp; 传送目标指针,把指针内容装入GS. 例: LGS DI,string&nbsp; ;把段地址:偏移地址存到GS:DI. <br>LSS&nbsp;&nbsp;&nbsp; 传送目标指针,把指针内容装入SS. 例: LSS DI,string&nbsp; ;把段地址:偏移地址存到SS:DI. <br><br>----------------------- 标志传送指令----------------------- <br><br>LAHF&nbsp;&nbsp;&nbsp; 标志寄存器传送,把标志装入AH. <br>SAHF&nbsp;&nbsp;&nbsp; 标志寄存器传送,把AH内容装入标志寄存器. <br>PUSHF&nbsp;&nbsp; 标志入栈. <br>POPF&nbsp;&nbsp;&nbsp; 标志出栈. <br>PUSHD&nbsp;&nbsp; 32位标志入栈. <br>POPD&nbsp;&nbsp;&nbsp; 32位标志出栈. <br>0012F618&nbsp; |00A8E5A8&nbsp; ASCII "nk'MHBh30"<br><br><br>-----------------------程序转移指令 -----------------------<br><br>1&gt;无条件转移指令 (长转移) <br>&nbsp;&nbsp; &nbsp;JMP&nbsp;&nbsp;&nbsp; 无条件转移指令 <br>&nbsp;&nbsp; &nbsp;CALL&nbsp;&nbsp;&nbsp; 过程调用 <br>&nbsp;&nbsp; &nbsp;RET/RETF过程返回. <br>2&gt;条件转移指令 (短转移,-128到+127的距离内) <br>&nbsp;&nbsp; &nbsp;( 当且仅当(SF XOR OF)=1时,OP1&lt;OP2 ) <br>&nbsp;&nbsp; &nbsp;JA/JNBE 不小于或不等于时转移. <br>&nbsp;&nbsp; &nbsp;JAE/JNB 大于或等于转移. <br>&nbsp;&nbsp; &nbsp;JB/JNAE 小于转移. <br>&nbsp;&nbsp; &nbsp;JBE/JNA 小于或等于转移. <br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;以上四条,测试无符号整数运算的结果(标志C和Z). <br>&nbsp;&nbsp; &nbsp;JG/JNLE 大于转移. <br>&nbsp;&nbsp; &nbsp;JGE/JNL 大于或等于转移. <br>&nbsp;&nbsp; &nbsp;JL/JNGE 小于转移. <br>&nbsp;&nbsp; &nbsp;JLE/JNG 小于或等于转移. <br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;以上四条,测试带符号整数运算的结果(标志S,O和Z). <br>&nbsp;&nbsp; &nbsp;JE/JZ&nbsp; 等于转移. <br>&nbsp;&nbsp; &nbsp;JNE/JNZ 不等于时转移. <br>&nbsp;&nbsp; &nbsp;JC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 有进位时转移. <br>&nbsp;&nbsp; &nbsp;JNC&nbsp;&nbsp;&nbsp; 无进位时转移. <br>&nbsp;&nbsp; &nbsp;JNO&nbsp;&nbsp;&nbsp; 不溢出时转移. <br>&nbsp;&nbsp; &nbsp;JNP/JPO 奇偶性为奇数时转移. <br>&nbsp;&nbsp; &nbsp;JNS&nbsp;&nbsp;&nbsp; 符号位为 "0" 时转移. <br>&nbsp;&nbsp; &nbsp;JO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 溢出转移. <br>&nbsp;&nbsp; &nbsp;JP/JPE&nbsp; 奇偶性为偶数时转移. <br>&nbsp;&nbsp; &nbsp;JS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 符号位为 "1" 时转移. <br>3&gt;循环控制指令(短转移) <br>&nbsp;&nbsp; &nbsp;LOOP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CX不为零时循环. <br>&nbsp;&nbsp; &nbsp;LOOPE/LOOPZ&nbsp;&nbsp;&nbsp; CX不为零且标志Z=1时循环. <br>&nbsp;&nbsp; &nbsp;LOOPNE/LOOPNZ&nbsp; CX不为零且标志Z=0时循环. <br>&nbsp;&nbsp; &nbsp;JCXZ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CX为零时转移. <br>&nbsp;&nbsp; &nbsp;JECXZ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ECX为零时转移. <br>4&gt;中断指令 <br>&nbsp;&nbsp; &nbsp;INT&nbsp;&nbsp;&nbsp; 中断指令 <br>&nbsp;&nbsp; &nbsp;INTO&nbsp;&nbsp;&nbsp; 溢出中断 <br>&nbsp;&nbsp; &nbsp;IRET&nbsp;&nbsp;&nbsp; 中断返回 <br>5&gt;处理器控制指令 <br>&nbsp;&nbsp; &nbsp;HLT&nbsp;&nbsp;&nbsp; 处理器暂停, 直到出现中断或复位信号才继续. <br>&nbsp;&nbsp; &nbsp;WAIT&nbsp;&nbsp;&nbsp; 当芯片引线TEST为高电平时使CPU进入等待状态. <br>&nbsp;&nbsp; &nbsp;ESC&nbsp;&nbsp;&nbsp; 转换到外处理器. <br>&nbsp;&nbsp; &nbsp;LOCK&nbsp;&nbsp;&nbsp; 封锁总线. <br>&nbsp;&nbsp; &nbsp;NOP&nbsp;&nbsp;&nbsp; 空操作. <br>&nbsp;&nbsp; &nbsp;STC&nbsp;&nbsp;&nbsp; 置进位标志位. <br>&nbsp;&nbsp; &nbsp;CLC&nbsp;&nbsp;&nbsp; 清进位标志位. <br>&nbsp;&nbsp; &nbsp;CMC&nbsp;&nbsp;&nbsp; 进位标志取反. <br>&nbsp;&nbsp; &nbsp;STD&nbsp;&nbsp;&nbsp; 置方向标志位. <br>&nbsp;&nbsp; &nbsp;CLD&nbsp;&nbsp;&nbsp; 清方向标志位. <br>&nbsp;&nbsp; &nbsp;STI&nbsp;&nbsp;&nbsp; 置中断允许位. <br>&nbsp;&nbsp; &nbsp;CLI&nbsp;&nbsp;&nbsp; 清中断允许位. <br><br>-----------------------串指令-----------------------<br><br>DS:SI&nbsp;&nbsp; 源串段寄存器&nbsp; :串变址. <br>ES:DI&nbsp;&nbsp; 目标串段寄存器:串变址. <br>CX&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 重复次数计数器. <br>AL/AX&nbsp;&nbsp; 扫描值. <br>D标志&nbsp;&nbsp; 0表示重复操作中SI和DI应自动增量; 1表示应自动减量. <br>Z标志&nbsp;&nbsp; 用来控制扫描或比较操作的结束. <br>cld&nbsp; 将DF置为0<br>std&nbsp; 将DF置为1<br>MOVS&nbsp;&nbsp;&nbsp; 串传送. <br>&nbsp;&nbsp;&nbsp; ( MOVSB&nbsp; 传送字符。将ds:si指向的内存单元中的字节送入es:di中，然后根据DF的标志将si和di的值增或减(0增1减)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MOVSW&nbsp; 传送字。&nbsp; 将ds:si指向的内存单元中的字节送入es:di中，然后根据DF的标志将si和di的值增或减(0增1减) <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MOVSD&nbsp; 传送双字. ) 经常这么用rep movsb相当于s:movsb ; loop s<br><br>CMPS&nbsp;&nbsp;&nbsp; 串比较. <br>&nbsp;&nbsp;&nbsp; ( CMPSB&nbsp; 比较字符.&nbsp;&nbsp;&nbsp; CMPSW&nbsp; 比较字. ) <br>SCAS&nbsp;&nbsp;&nbsp; 串扫描. 把AL或AX的内容与目标串作比较,比较结果反映在标志位. <br>LODS&nbsp;&nbsp;&nbsp; 装入串. 把源串中的元素(字或字节)逐一装入AL或AX中. <br>&nbsp;&nbsp;&nbsp; ( LODSB&nbsp; 传送字符.&nbsp;&nbsp;&nbsp; LODSW&nbsp; 传送字.&nbsp;&nbsp;&nbsp; LODSD&nbsp; 传送双字. ) <br>STOS&nbsp;&nbsp;&nbsp; 保存串.是LODS的逆过程. <br>REP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 当CX/ECX&lt;&gt;0时重复. <br>REPE/REPZ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 当ZF=1或比较结果相等,且CX/ECX&lt;&gt;0时重复. <br>REPNE/REPNZ&nbsp;&nbsp;&nbsp; 当ZF=0或比较结果不相等,且CX/ECX&lt;&gt;0时重复. <br>REPC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 当CF=1且CX/ECX&lt;&gt;0时重复. <br>REPNC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 当CF=0且CX/ECX&lt;&gt;0时重复. <br><br>-----------------------伪指令-----------------------<br>DW&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 定义字(2字节). <br>PROC&nbsp;&nbsp;&nbsp; 定义过程. <br>ENDP&nbsp;&nbsp;&nbsp; 过程结束. <br>SEGMENT 定义段. <br>ASSUME&nbsp; 建立段寄存器寻址. <br>ENDS&nbsp;&nbsp;&nbsp; 段结束. <br>END&nbsp;&nbsp;&nbsp; 程序结束. &nbsp;<br></div>
<h3>指令长度</h3>
<div id="cnblogs_post_body">指令长度与寻址方式有关系，规律或原则如下：<br><br>一、没有操作数的指令，指令长度为1字节。如<br>es:<br>ds:<br>cbw<br>xlat<br>等。<br><br>二、操作数只涉及寄存器的指令，指令长度为2字节。如<br>mov al,[si]<br>mov ax,[bx+si]<br>mov ds,ax<br>等。<br><br>三、操作数涉及内存地址的指令，指令长度为3字节。如<br>mov al,[bx+1]<br>mov ax,[bx+si+3]<br>lea di,[1234]<br>mov [2345],ax<br>等。<br><br>四、操作数涉及立即数的指令，指令长度为：寄存器类型+2。<br>8位寄存器，寄存器类型=1；16位寄存器，寄存器类型=2。如<br>mov al,8 ;指令长度为2<br>mov ax,8 ;指令长度为3<br>等。<p>立即数的长度一般是1～4B</p><br>五、跳转指令，分3种情况，指令长度分别为2、3、5字节。<br>1、段内跳转，指令长度=（目标地址-指令当前地址）+1<br>jmp指令本身占用1个字节。<br>（目标地址-指令当前地址）若能用1个字节表示，则占用1个字节，整体指令长度为2字节；如<br>0113 jmp 0185 ;0185h-0113h=72h，72h可用1个字节表示<br>若需2个字节表示，则占用2个字节，整体指令为3个字节。如<br>0113 jmp 0845 ;0845h-0113h=732h，732h需用2个字节表示<br>2、段间跳转，指令长度为5字节。如<br>jmp 1234:5678<br>------------------------------</div>


[返回目录](README.md)