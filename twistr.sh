#!/bin/bash
#
# Twistr v0.3, a Tumblr client.
#
# by Enric Morales (http://enric.me/twistr). Uncopyrighted 2010.


# {{ See if we can import the info on ~/.twistr.rc, otherwise prompt the user.
source ~/.twistr.rc 2>/dev/null && test -z "$email" || test -z "$password" && \
echo "Save your Tumblr email and password in this format at $HOME/.twistr.rc:
   email="YOUR EMAIL HERE"
   password="YOUR PASSWORD HERE"" && exit 1
# }}

# {{ cURL magic!
case $1 in
   text)  if [ -z "$3" ]
   		then echo -n "Enter the post title: " && read title
		else title="$3"
	  fi

	  if [ -z "$4" ]
	  	then echo -n "Enter the post tags: " && read tags
		else tags="$4"
	  fi

   	  curl  -S \
		-d email=$email \
		-d password=$password \
		-d type=regular \
		-d title="$title" \
		-d tags="$tags" \
		-d generator=Twistr \
		--data-urlencode body@"$2" \
		"http://www.tumblr.com/api/write" ;;

   photo) if [ -z "$3" ]
   		then echo -n "Enter the photo caption: " && read caption
		else caption="$3"
	  fi

	  if [ -z "$4" ]
	  	then echo -n "Enter the photo tags: " && read tags
		else tags="$4"
	  fi

	  curl  -S \
		-F email=$email \
		-F password=$password \
		-F type=photo \
		-F generator=Twistr \
		-F caption="$caption" \
		-F tags="$tags" \
		-F "data=@"$2"" \
		"http://www.tumblr.com/api/write" ;;

   *)	echo -e "Twistr, a tumblr client.\n"
	echo "Usage: $0 text </path/to/file.txt> \"[title]\" \"[tags]\""
	echo "       $0 photo </path/to/photo.jpg> \"[caption]\" \"[tags]\""
	exit 1 ;;
esac
#}}
