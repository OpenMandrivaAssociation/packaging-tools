#!/bin/sh
# Gendiff-friendly editor invocation
# (c) 2002-2013 Bernhard Rosenkraenzer <bero@lindev.ch>
# Released to the public domain. Do with it whatever you want.

[ -z "$EDITOR" ] && EDITOR="$VISUAL"
[ -z "$EDITOR" ] && EDITOR="vim"
if [ "$1" = "-s" ]; then
	shift
	SUFFIX="$1"
	shift
fi
[ -z "$SUFFIX" ] && SUFFIX="omv~"

[ -e "$1"."$SUFFIX" ] || cp -f "$1" "$1"."$SUFFIX" || touch "$1"."$SUFFIX"

exec "$EDITOR" "$1"
