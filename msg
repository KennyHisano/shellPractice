#!/bin/ksh

if [ "$1" = "" ]
then
  echo "error: no users are listed"
fi



if ! ypcat passwd | grep ^$USER
then
   echo "my username not found in /etc/passwd $USER"
   exit 
fi

myname=`ypcat passwd | grep ^$USER | awk -F : '{print $1}'`
echo "$myname"
for recpt in $@
do
    if ! ypcat passwd | grep ^$recpt
    then
        "username $recpt not found in /etc/passwd"
        continue
    fi
    who | cut -d' ' -f1 | grep "^$recpt\$" >/dev/null

    if [ $? -eq 0 ]
    then
        fullname=`ypcat passwd | grep ^$USER | awk -F : '{print $4}'`

        mail -s "Assigtnment 4" $recpt <<EOF

**** This email is automatically generatated by khisa880 ******

My instructor requires that I send this message as part of an assignment for class 92.312.
The current time and date is `date`.

Have a nice day.

"Kentaro Hisano"

EOF
    fi
done
