#!/bin/bash

USAGE="$0 -a FINDALL"
FINDALL=false

mywhich() 
{
	if [ "$#" -eq -a ]; then
		FINDALL=true
	
		echo "hi"
	else
		echo "ad"
	fi


}
mywhich