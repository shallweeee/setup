#! /bin/bash

TARGET_BRANCH=main
git branch | grep -qw master && TARGET_BRANCH=master

while getopts "b:" opt; do
	case $opt in
		b) TARGET_BRANCH=$OPTARG;;
	esac
done
shift $((OPTIND - 1))

dir=${1-cc}
shift

head=$(git log --oneline -1 | cut -d' ' -f1)

if [ $dir = cc ]; then
	[ -z "$1" ] && OPTS=-C2 || OPTS=$1
	git log --oneline $TARGET_BRANCH | grep $head $OPTS | sed 's/^/  /' | sed '/'$head'/s/ /*/'
elif [ $dir = cp ]; then
	next=$(git log --oneline $TARGET_BRANCH | grep $head -B1 | head -1 | awk '{print $1}')
	git checkout $next
elif [ $dir = cn ]; then
	next=$(git log --oneline $TARGET_BRANCH | grep $head -A1 | tail -1 | awk '{print $1}')
	git checkout $next
fi

