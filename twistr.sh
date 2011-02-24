#!/bin/bash
#
# Twistr v0.7.5, a Tumblr client.
#
# by Enric Morales (http://enric.me/twistr). Uncopyrighted 2010.
# With the contributions of mitsugu

# {{ Functions containter to simplify the code
function firstrun() {
	echo "Welcome to Twistr. To begin posting, save your Tumblr"
	echo "email and password in this format at $HOME/.twistrrc,"
	echo "and chmod it 700 so that only you can read it:"
	echo "   email="YOUR EMAIL HERE""
	echo "   password="YOUR PASSWORD HERE""
	exit 1
}
#}}

# {{ See if we can import the info on ~/.twistr.rc, otherwise prompt the user.
source ~/.twistrrc 2>/dev/null
test -z "$email" || test -z "$password" && firstrun
# }}

# {{ cURL magic!
if [ -z "$1" ]
  then echo -n "Enter the post group: " && read group
  else group="$1"
fi

case $2 in
	text)
		if [ -z "$4" ]
   			then echo -n "Enter the post title: " && read title
			else title="$4"
	  	fi
		if [ -z "$5" ]
	  		then echo -n "Enter the post tags: " && read tags
			else tags="$5"
	  	fi

   		postid=$(curl -fs \
			-d email=$email \
			-d password=$password \
			-d generator=Twistr \
			-d type=regular \
			-d title="$title" \
			-d tags="$tags" \
      -d group="$group.tumblr.com" \
			--data-urlencode body="$3" \
			"http://www.tumblr.com/api/write") ;;

	photo)
   		if [ -z "$4" ]
   			then echo -n "Enter the photo caption: " && read caption
			else caption="$4"
	  	fi
	  	if [ -z "$5" ]
	  		then echo -n "Enter the photo tags: " && read tags
			else tags="$5"
	  	fi

		postid=$(curl -fs \
			-F email=$email \
			-F password=$password \
			-F generator=Twistr \
			-F type=photo \
			-F caption="$caption" \
			-F tags="$tags" \
      -F group="$group.tumblr.com" \
			-F data=@"$3" \
			"http://www.tumblr.com/api/write") ;;

	video)
   		if [ -z "$4" ]
				then echo -n "Enter the video caption: " && read caption
			else caption="$4"
	  	fi
	  	if [ -z "$5" ]
	  		then echo -n "Enter the video tags: " && read tags
			else tags="$5"
	  	fi

		postid=$(curl -fs \
			-F email=$email \
			-F password=$password \
			-F generator=Twistr \
			-F type=video \
			-F caption="$caption" \
			-F tags="$tags" \
      -F group="$group.tumblr.com" \
			-F data=@"$3" \
			"http://www.tumblr.com/api/write") ;;

	link)
		if [ -z "$4" ]
		      	then echo -n "Enter the link name: " && read linkname
		    	else linkname="$4"
	   	fi
		if [ -z "$5" ]
			then echo -n "Enter the link description: " && read linkdesc
			else linkdesc="$5" 
		fi
		if [ -z "$6" ]
			then echo -n "Enter the post tags: " && read tags
			else tags="$6" 
		fi

		postid=$(curl -fs \
			-F email=$email \
			-F password=$password \
			-F generator=Twistr \
			-F type=link \
			-F name="$linkname" \
			-F description="$linkdesc" \
			-F tags="$tags" \
			-F url="$3" \
      -F group="$group.tumblr.com" \
			"http://www.tumblr.com/api/write") ;;

	audio)
		if [ -z "$4" ]
			then echo -n "Enter the audio caption: " && read caption
			else caption="$4" 
		fi
		if [ -z "$5" ]
			then echo -n "Enter the post tags: " && read tags
			else tags="$5" 
		fi

		postid=$(curl -fs \
			-F email=$email \
			-F password=$password \
			-F generator=Twistr \
			-F type=audio \
			-F caption="$caption" \
			-F tags="$tags" \
			-F data=@"$3" \
      -F group="$group.tumblr.com" \
			"http://www.tumblr.com/api/write") ;;
	
	quote)
		if [ -z "$4" ]
			then echo -n "Enter the quote source: " && read source 
			else caption="$4" 
		fi
		if [ -z "$5" ]
			then echo -n "Enter the post tags: " && read tags
			else tags="$5" 
		fi

		postid=$(curl -fs \
			-d email=$email \
			-d password=$password \
			-d generator=Twistr \
			-d type=quote \
			-d quote="$3" \
			-d source="$source" \
			-d tags="$tags" \
      -d group="$group.tumblr.com" \
			"http://www.tumblr.com/api/write") ;;

	chat)
		if [ -z "$4" ]
	    		then echo -n "Enter the chat title: " && read title
			else title="$4"
		fi   
		if [ -z "$5" ]
			then echo -n "Enter the post tags: " && read tags
			else tags="$5" 
		fi

		postid=$(curl -fs \
			-d email=$email \
			-d password=$password \
			-d generator=Twistr \
			-d type=conversation \
			-d title="$title" \
			-d tags="$tags" \
			--data-urlencode conversation="$3" \
			"http://www.tumblr.com/api/write") ;;

   	*)
		echo 'Twistr, a tumblr client. Usage:'
		echo 'twistr group text </path/to/file.txt> ["title"] ["tags"]'
		echo '             photo </path/to/photo.jpg> ["caption"] ["tags"]'
		echo '             video </path/to/video.mov> ["caption"] ["tags"]'
		echo '             audio </path/to/audio.mp3> ["title"] ["caption"] ["tags"]'
		echo '             link <URI> "[link name]" ["link description"] ["tags"]'
		echo '             quote <quote> ["source"] ["tags"]'
		echo '             chat </path/to/conver/sation.txt> "[title]" "[tags]"'
		exit 1 ;;
esac
#}}

if [ -z "$postid" ]
	then echo "Oh noes, there was an error!"
	else echo "Post-id: $postid"
fi
