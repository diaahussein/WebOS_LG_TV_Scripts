broadcastid="$(ls-monitor | grep -a -m 4 -h "broadcastId" | grep -oE "\b[0-9,a-z]{8}\-[0-9,a-z]{4}-[0-9,a-z]{4}-[0-9,a-z]{4}-[0-9,a-z]{12}\b" | tail -1  &)"

sleep 2

pkill ls-monitor

echo $broadcastid

channelid="$(luna-send -n 1 -f luna://com.webos.service.utp.broadcast/getCurrentChannel '{"broadcastId": "'$broadcastid'","subscribe": false}'| grep -a -h "channelId" | grep -oE "\b[0-9,a-z]{1}_[0-9,a-z]{3}_[0-9,a-z]{1}_[0-9,a-z]{1}_[0-9,a-z]{2}_[0-9,a-z]{3}_[0-9,a-z]{3}\b" )"

echo $channelid

#luna-send -n 1 -f luna://com.webos.applicationManager/launch '{"id": "com.webos.app.dvrpopup","noSplash": true,"params": {"activateType": "instantRecord","broadcastId": "'$broadcastid'","channelId": "'$channelid'","inputType": "TV","isDelayed": false,"isDvb": true}}'
recordingid="$(luna-send -n 1 -f luna://com.webos.service.utp.dvr/record/startProgramRecord '{ "camPinCode": "", "channelId": "'$channelid'","duration": 2880, "endTime": { "day": 12, "hour": 20, "minute": 0, "month": 6, "second": 28, "year": 2021 }, "programId": "2048_59_10_46306", "quality": "record_quality_high", "recordingMode": "recording_direct", "storagePath": "/tmp/usb/sdb/sdb1/LG Smart TV" } '| grep recordingId | awk '{print  substr($2, 2, length($2)-3)}')"

echo $recordingid

sleep 20

done="$(luna-send -n 1 -f luna://com.webos.service.utp.dvr/record/stopRecord '{"needSave": true, "recordingId": "'$recordingid'" } ')"

echo "Recording Stoped"
