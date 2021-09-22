#!/bin/bash
#-d - dir name; -l length; -n sarting number
#convert with ImageMagick: http://www.imagemagick.org/script/download.php#windows

> identify_logs.txt
> convert_logs.txt
currentDirName=$(pwd)

let defaultLen=8
let defaultNumber=0
for arg in ${@}
do
	case $arg in
		-d=*|--directory=*)
		currentDirName="${arg#*=}"
		if ! [[ -d "$currentDirName" ]] ; then
			echo "Wrong Directory Name";
			exit 1
		fi
		shift
		;;
		-l=*|--len=*)
		let defaultLen="${arg#*=}"
		if [[ $defaultLen =~ ^[+][0-9]*$ ]] ; then 
			echo "Length Not a number or negative"; 
			exit 1
		fi
		shift
		;;
		-n=*|--number=*)
		let defaultNumber="${arg#*=}"
		if  [[ $defaultNumber =~ ^[+][0-9]*$ ]] ; then 
			echo "Number Not a number or negative"; 
			exit 1
		fi
		shift
		;;
	esac
done

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

files=($( ls "$currentDirName" ))
for counter in ${files[@]}; do
	identify "$counter" >> identify_logs.txt 2>&1
    	if [ $? -eq 0 ]; then
        	printf -v uniqueNumber '%0*i' $(($defaultLen)) $defaultNumber;
		convert "$counter" "$currentDirName/$(basename $currentDirName)-$(date -r "$counter" +'%Y-%m-%d-%H-%M-%S')-$uniqueNumber.jpg"  >> convert_logs.txt 2>&1
		let defaultNumber+=1
    	fi
done
IFS=$SAVEIFS

