#!/bin/bash
#
# Twistr: a simple bash script to post to Tumblr.
#
# version 0.1 24 Nov 2010. Uncopyrighted.
# by Enric Morales (http://enric.me/twistr)


# {{ See if we can import the info on ~/.twistr.rc, otherwise prompt the user.

source ~/.twistr.rc 2>/dev/null && test -z "$email" || test -z "$password" && \
echo "Save your Tumblr email and password in this format at $HOME/.twistr.rc:
   email="YOUR EMAIL HERE"
   password="YOUR PASSWORD HERE"" && exit 1

# }}


# {{ If filename's missing, print usage. If the title's missing, read from stdin
test -z "$1" && echo "Usage: $0 </path/to/file.txt> \"[title]\"" && exit 1
test -z "$2" && echo -n "Enter title: " && read title

#}}

# {{ Tumblr API variables
posttype='regular'
title="$2"

# }}


# {{ cURL magic!

curl  -S \
      -d email=$email \
      -d password=$password \
      -d type=$posttype \
      -d title=$title \
      -d generator=Twistr \
      --data-urlencode body="$(cat $1)" \
       "http://www.tumblr.com/api/write"

#}}
