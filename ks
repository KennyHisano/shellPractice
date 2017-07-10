#!/usr/bin/ksh


print -- "${1%/*}"
print -- "${1##*/}"

find "$1" -depth -type d -name '* *' -print
find "$1" -depth -type f -name '* *' -print