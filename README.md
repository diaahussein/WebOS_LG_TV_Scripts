# WebOS_LG_TV_Scripts
WebOS_LG_TV_Scripts
I am trying to find out all about the LG WebOS undocumented API

here is what I have found so far
Please feel free to share with me if you have any additions

#get broadcastID
ls-monitor | grep -a -m 4 -h "broadcastId" | grep -oE "\b[0-9, a-z]{8}\-[0-9, a-z]{4}-[0-9, a-z]{4}-[0-9, a-z]{4}-[0-9, a-z]{12}\b" | tail -1

#get current channelID
luna-send -n 1 -f luna://com.webos.service.utp.broadcast/getCurrentChannel '{"broadcastId": "'$broadcastid'", "subscribe": false}'| grep -a -h "channelId" | grep -oE "\b[0-9, a-z]{1}_[0-9, a-z]{3}_[0-9, a-z]{1}_[0-9, a-z]{1}_[0-9, a-z]{2}_[0-9, a-z]{3}_[0-9, a-z]{3}\b"

#show recording dialog
luna-send -n 1 -f luna://com.webos.applicationManager/launch '{"id": "com.webos.app.dvrpopup", "noSplash": true, "params": {"activateType": "instantRecord", "broadcastId": "'$broadcastid'", "channelId": "'$channelid'", "inputType": "TV", "isDelayed": false, "isDvb": true}}'

#start recording and show recordingID

luna-send -n 1 -f luna://com.webos.service.utp.dvr/record/startProgramRecord '{ "camPinCode": "", "channelId": "'$channelid'", "duration": 2880, "endTime": { "day": 12, "hour": 20, "minute": 0, "month": 6, "second": 28, "year": 2021 }, "programId": "2048_59_10_46306", "quality": "record_quality_high", "recordingMode": "recording_direct", "storagePath": "/tmp/usb/sdb/sdb1/LG Smart TV" } '| grep recordingId | awk '{print substr ($2, 2, length ($2) -3) }'

#stop recording by recordingID
luna-send -n 1 -f luna://com.webos.service.utp.dvr/record/stopRecord '{"needSave": true, "recordingId": "'$recordingid'" } '

#close application by ID
luna-send -n 1 -f luna://com.webos.applicationManager/closeByAppId ' {"id":"netflix"} '

#Mute
luna-send -n 1 -f luna://com.webos.service.audiooutput/audio/volume/muteSoundOut ' {"mute":true, "soundOutput":"tv_external_speaker"} '

#UnMute
luna-send -n 1 -f luna://com.webos.service.audiooutput/audio/volume/muteSoundOut ' {"mute":false, "soundOutput":"tv_external_speaker"} '

#changechannel you must get the current broadcastID and the new channelID, old is irrelevent
luna-send -n 1 -f luna://com.webos.service.utp.broadcast/changeChannel ' {"channelId":"7_124_2_0_47_4712_2048", "broadcastId":"00000011-1dd3-acb4-84f7-41b645a4a528", "currentChannelId":"7_208_3_0_59_10_2048"} '

#to take a screenshot
luna-send -n 1 -f luna://com.webos.surfacemanager/captureCompositorOutput '{"output":"/tmp/usb/sda/sda1/NAS/shares/screenshot-temp.jpg", "format":"JPG"}'

#get current foregound application
luna-send -n 1 luna://com.webos.applicationManager/getForegroundAppInfo '{}'

#set master volume to 30
luna-send -f -n 1 luna://com.webos.service.audio/master/setVolume '{"volume":30}'

below is a link to my Github where I have a list of bash scripts that can be used for varies applications on LG based on the above function

Volume.sh
automatic control the volume based on the running application

recording.sh
start recording of the current channel and stop after 20 Seconds
