#!/bin/bash

error_and_die ()
    {
    echo "$@" >&2
    exit 1
    }
error_and_die_with_usage ()
    {
    echo "$@" >&2
    usage
    exit 1
    }

usage ()
{
echo "
change-lines [-n] -s search string -r replace string files ...

    -n    do not backup the original file
    -s    search string the search for this string
    -r    replace string replace the search string with this string
    -h    print this message
" 
}

check_file ()
    {
    FILE=$1
    shift
    NOTE="$@"

    if [ ! -e "$FILE" ]
	then
	error_and_die "$NOTE '$FILE' does not exist"
	fi
    if [ ! -f "$FILE" ]
	then
	error_and_die "$NOTE '$FILE' is not a regular FILE"
	fi
    if [ ! -r "$FILE" ]
	then
	error_and_die "Cannot read $NOTE '$FILE'"
	fi
    if [ ! -w "$FILE" ]
	then
	error_and_die "Cannot write $NOTE '$FILE'"
	fi
    }

backup_file=TRUE

search_string=

replace_string=

while :
    do
    case $1 in
    -n)
       backup_file=
       ;;
    -s)
	if [ ! "$2" ]
	    then
	    error_and_die_with_usage "Search String not specified with -s"
	    fi
	search_string="$2"
	shift 
	;;
    -r)
	if [ ! "$2" ]
	    then
	    error_and_die_with_usage "Replace String not specified with -s"
	    fi
	replace_string="$2"
	shift 
	;;
    -h)
	usage
	exit 0
	;;
    -?)
	error_and_die_with_usage "Unknown Option"
	;;
    *)
	break
	;;
    esac
    shift
    done

if [ ! "$search_string" -a ! "$replace_string"  -a $# -eq 0 ]
    then
    error_and_die_with_usage "-s, -r and input files are required see usage"
    fi

if [ ! "$search_string" -a ! "$replace_string" ]
    then
    error_and_die_with_usage "Both -s and -r are required"
    fi

if [ ! "$search_string" -a $# -eq 0 ]
    then
    error_and_die_with_usage "Search String not specified and no input files"
    fi

if [ ! "$search_string" ]
    then
    error_and_die_with_usage "Search String not specified"
    fi

if [ ! "$replace_string"  -a $# -eq 0 ]
    then
    error_and_die_with_usage "Replacement String not specified and no input files"
    fi

if [ ! "$replace_string" ]
    then
    error_and_die_with_usage "Replacement String not specified"
    fi

if [ $# -eq 0 ]
    then
    error_and_die_with_usage "No input files specified"
    fi

for file
    do

    check_file "$file" "INPUT FILE"

    BACKUP="${file}.keep"
    if [ -e "$BACKUP" ]
	then
	check_file "$BACKUP" "BACKUP FILE"
    elif cp "$file" "$BACKUP"
	then
 	:
    else
	error_and_die "Cannot create backup file '$BACKUP'"
	fi
   
    sed -e 's/'"$search_string"'/'"$replace_string"'/g' $BACKUP > "$file"

    if [ ! "$backup_file" ]
	then
	rm "$BACKUP"
	fi
    done
 
 