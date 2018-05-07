1. 
PASSWORD_HASHER:<br>
django 自带的加密算法：PBKDF2、PBKDF2SHA1、BCryptSHA256、BCrypt、SHA1、MD5、Crypt等
1. 
ADMINS：是一个二元组，记录开发人员的姓名和email，有DEGUG=False有异常时通知
1. 
ALLOWED_HOST：指定接受请求的host
1. 
DEBUG：True时出错或者异常会显示详细信息，上线时要设为False
1. 
INSTALLED_APPS：<br>自带或者自定义的app包路径(推荐：django_bleach(过滤字符串)、xframeoptions(防范ClickJacking))
1. 
MANAGERS：与ADMIS类似，只是给manager发邮件
1. 
MIDDLEWARE_CLASS：中间件<br>（推荐：SessionMiddleware(应用中使用session)、CsrfViewMiddleware(防csrf攻击)、XFrameOptionsMiddleware） 
1. 
TEMPLATE_DEBUG：网页上会显示详细信息，上线时要设置为False
1. 
SESSION_COOKIE_SECURE：cookie被标记上secure信息，只能在HTTPS下传输
1. 
SESSION_COOKIE_HTTPONLY：cookie被标记上HTTP信息，只能在被http协议读取，JS不可以
1. 
DEBUG/TEMPLATE_DEBUG：测试时True，上线后False



[返回目录](README.md)