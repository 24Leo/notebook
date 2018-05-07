###依赖包
```python
dotenv
twilio
yagmail
git+https://github.com/charlierguo/gmail
```
### 其他几个程序可能用到的检测平台环境
```python
#hackerutils.py
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pathlib
import subprocess

from dotenv import Dotenv


def get_dotenv(filename='.env'):
    return Dotenv(str(pathlib.Path(__file__).parent / filename))


def sh(*args):
    proc = subprocess.Popen(args, stdout=subprocess.PIPE)
    stdout, _ = proc.communicate()
    return stdout


def get_log_path(name):
    path = pathlib.Path(__file__).parent / 'logs' / name
    path.parent.mkdir(parents=True, exist_ok=True)
    return path
```
### auto_coffee
```python
#auto_coffee.py
#!/usr/bin/env python3
#-*- coding: utf-8 -*-
#coffee-auto
import datetime
import telnetlib
import time

from hackerutils import sh

COFFEE_MACHINE_ADDR = '10.10.42.42'
COFFEE_MACHINE_PASS = '1234'
COFFEE_MACHINE_PROM = 'Password: '


def main():
    # Skip on weekends.
    if datetime.date.today().weekday() in (0, 6,):
        return

    # Exit early if no sessions with my_username are found.
    if not any(s.startswith(b'my_username ') for s in sh('who').split(b'\n')):
        return

    time.sleep(17)

    conn = telnetlib.Telnet(host=COFFEE_MACHINE_ADDR)
    conn.open()
    conn.expect([COFFEE_MACHINE_PROM])
    conn.write(COFFEE_MACHINE_PASS)

    conn.write('sys brew')
    time.sleep(64)

    conn.write('sys pour')
    conn.close()


if __name__ == '__main__':
    main()
```
###自动请假
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime
import random

from twilio import TwilioRestException
from twilio.rest import TwilioRestClient

from hackerutils import get_dotenv, get_log_path, sh

dotenv = get_dotenv()

TWILIO_ACCOUNT_SID = dotenv['TWILIO_ACCOUNT_SID']
TWILIO_AUTH_TOKEN = dotenv['TWILIO_AUTH_TOKEN']

LOG_FILE_PATH = get_log_path('hangover.txt')


def main():
    # Skip on weekends.
    if datetime.date.today().weekday() in (0, 6,):
        return

    # Exit early if any session with my_username is found.
    if any(s.startswith(b'my_username ') for s in sh('who').split(b'\n')):
        return

    client = TwilioRestClient(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

    # Phone numbers.
    my_number = '+xxx'
    number_of_boss = '+xxx'

    excuses = [
        'Locked out',
        'Pipes broke',
        'Food poisoning',
        'Not feeling well',
    ]

    try:
        # Send a text message.
        client.messages.create(
            to=number_of_boss,
            from_=my_number,
            body='Gonna work from home. ' + random.choice(excuses),
        )
    except TwilioRestException as e:
        # Log errors.
        with LOG_FILE_PATH.open('a') as f:
            f.write('Failed to send SMS: {}'.format(e))
        raise


if __name__ == '__main__':
    main()
```
###处理别人问题
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re

import gmail
import yagmail

from hackerutils import get_dotenv

dotenv = get_dotenv()

GMAIL_USERNAME = dotenv['GMAIL_USERNAME']
GMAIL_PASSWORD = dotenv['GMAIL_PASSWORD']

KUMAR_EMAIL = 'kumar.a@example.com'
KEYWORDS_REGEX = re.compile(r'sorry|help|wrong', re.IGNORECASE)

REPLY_BODY = "No problem. I've fixed it. \n\n Please be careful next time."


yagmail.register(GMAIL_USERNAME, GMAIL_PASSWORD)


def send_reply(subject):
    yag = yagmail.SMTP(GMAIL_USERNAME)
    yag.send(
        to=KUMAR_EMAIL,
        subject='RE: {}'.format(subject),
        contents=REPLY_BODY,
    )


def main():
    g = gmail.login(GMAIL_USERNAME, GMAIL_PASSWORD)
    for mail in g.inbox().mail(unread=True, sender=KUMAR_EMAIL, prefetch=True):
        if KEYWORDS_REGEX.search(mail.body):
            # Restore DB and send a reply.
            mail.add_label('Database fixes')
            send_reply(mail.subject)


if __name__ == '__main__':
    main()
```
###哄老婆
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime
import random

from twilio import TwilioRestException
from twilio.rest import TwilioRestClient

from hackerutils import get_dotenv, get_log_path, sh

dotenv = get_dotenv()

TWILIO_ACCOUNT_SID = dotenv['TWILIO_ACCOUNT_SID']
TWILIO_AUTH_TOKEN = dotenv['TWILIO_AUTH_TOKEN']

LOG_FILE_PATH = get_log_path('smack_my_bitch_up.txt')


def main():
    # Skip on weekends.
    if datetime.date.today().weekday() in (0, 6,):
        return

    # Exit early if no sessions with my_username are found.
    if not any(s.startswith(b'my_username ') for s in sh('who').split(b'\n')):
        return

    client = TwilioRestClient(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

    # Phone numbers.
    my_number = '+xxx'
    her_number = '+xxx'

    reasons = [
        'Working hard',
        'Gotta ship this feature',
        'Someone fucked the system again',
    ]

    try:
        # Send a text message.
        client.messages.create(
            to=her_number,
            from_=my_number,
            body='Late at work. ' + random.choice(reasons),
        )
    except TwilioRestException as e:
        # Log errors.
        with LOG_FILE_PATH.open('a') as f:
            f.write('Failed to send SMS: {}'.format(e))
        raise


if __name__ == '__main__':
    main()
```

[返回目录](README.md)