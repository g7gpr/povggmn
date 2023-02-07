#!/bin/bash
ffmpeg -y -nostdin -nostats -stimeout 5000000 -i 'rtsp://'$1':554/user=admin&password=&channel=1&stream=0.sdp' -f segment -strftime 1 -segment_time 3600 -reset_timestamps 1 -vcodec copy capture_%Y%m%d_%H%M%S.mkv
