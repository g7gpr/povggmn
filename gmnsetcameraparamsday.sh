#!/bin/bash
#
# bash script to set an IMX291 camera to day settings
#
echo "This script will set your camera to settings which can be used during the day"
echo ""
echo "NB: The script requires that your camera is -already- set to the "
echo "right IP address and that this address has been added to the RMS .config file."
source ~/vRMS/bin/activate
cd ~/source/RMS

currip=$(python -m Utils.CameraControl GetIP)

echo "Camera Address is $currip"
cd ~/source/RMS
source ~/vRMS/bin/activate
# a few miscellaneous things - onscreen date/camera Id off, colour settings, autoreboot at 1500 every day
python -m Utils.CameraControl SetOSD on
python -m Utils.CameraControl SetColor 50,50,50,50,0,8
python -m Utils.CameraControl SetAutoReboot Everyday,15

# set the Video Encoder parameters
python -m Utils.CameraControl SetParam Encode Video Compression H.264
python -m Utils.CameraControl SetParam Encode Video Resolution 720P
python -m Utils.CameraControl SetParam Encode Video BitRateControl VBR
python -m Utils.CameraControl SetParam Encode Video FPS 25
python -m Utils.CameraControl SetParam Encode Video Quality 6
python -m Utils.CameraControl SetParam Encode AudioEnable 0
python -m Utils.CameraControl SetParam Encode VideoEnable 1
python -m Utils.CameraControl SetParam Encode SecondStream 0

# camera parameters
python -m Utils.CameraControl SetParam Camera Style type1
python -m Utils.CameraControl SetParam Camera AeSensitivity 5
python -m Utils.CameraControl SetParam Camera ApertureMode 0
python -m Utils.CameraControl SetParam Camera BLCMode 0
python -m Utils.CameraControl SetParam Camera DayNightColor 0
python -m Utils.CameraControl SetParam Camera Day_nfLevel 3
python -m Utils.CameraControl SetParam Camera DncThr 30
python -m Utils.CameraControl SetParam Camera ElecLevel 50
python -m Utils.CameraControl SetParam Camera EsShutter 1
python -m Utils.CameraControl SetParam Camera ExposureParam LeastTime 256
python -m Utils.CameraControl SetParam Camera ExposureParam Level 0
python -m Utils.CameraControl SetParam Camera ExposureParam MostTime 40000
python -m Utils.CameraControl SetParam Camera GainParam AutoGain 1
python -m Utils.CameraControl SetParam Camera GainParam Gain 50
python -m Utils.CameraControl SetParam Camera IRCUTMode 0
python -m Utils.CameraControl SetParam Camera IrcutSwap 0
python -m Utils.CameraControl SetParam Camera Night_nfLevel 3
python -m Utils.CameraControl SetParam Camera RejectFlicker 0
python -m Utils.CameraControl SetParam Camera WhiteBalace 0
python -m Utils.CameraControl SetParam Camera PictureFlip 0
python -m Utils.CameraControl SetParam Camera PictureMirror 0

# network parameters
python -m Utils.CameraControl SetParam Network TransferPlan Fluency

