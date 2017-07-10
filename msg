#!/bin/bash
# Write a mail message to listed users if they are online
if [ "$1" = "" ]
then
  echo "error: no users specified"
  echo "usage: $0 user ..."
fi

if ! grep -q ^$USER: /etc/passwd
then
   echo "my username not found in /etc/passwd $USER"
   exit 
fi

myname=`grep ^$USER: /etc/passwd | cut -d: -f5`
for recpt in $@
do
    if ! grep -q ^$recpt: /etc/passwd
    then
        "username $recpt not found in /etc/passwd"
        continue
    fi
    who | cut -d' ' -f1 | grep "^$recpt\$" >/dev/null
    # if user logged in, grep returns 0
    if [ $? -eq 0 ]
    then
        fullname=`grep ^$recpt: /etc/passwd | cut -d: -f5`
        mail -s "Hello message" $recpt <<EOF
Hello "$fullname",
Please ignore this mail. My instructor requires that I send this message as part of an assignment for class 92.312. The current time and date is `date`. 
Have a nice day.

$myname
EOF
    fi
done
