#!/bin/bash
#
# the objective of this script is to autmaticaly monitor forgound application and set the volume according to the running application
while : 
do
# get current foreground application
app="$(luna-send -n 1 luna://com.webos.applicationManager/getForegroundAppInfo '{}' | awk '{print  substr($1, 11, length($1)-60)}')"
#read old running application value
oldapp="$(cat /run/currentapp)"
#check if the running application is liveTV
if [ "$app" == "com.webos.app.livetv" ] && [ "$app" != "$oldapp" ]
        then
        # store current value of foregound application
        echo "$app" > /run/currentapp
        # set the volume to 30
        luna-send -f -n 1 luna://com.webos.service.audio/master/setVolume '{"volume":30}'
        else
        if [ "$app" == "$oldapp" ]
                then
                echo "no change"
                else
                # store current value of foregound application
                echo "$app" > /run/currentapp
                # set the volume to 20
                luna-send -f -n 1 luna://com.webos.service.audio/master/setVolume '{"volume":20}'
        fi
fi

done
