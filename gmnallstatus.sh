#!/bin/bash
echo lemongum
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au0004
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au0006
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au0007
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au0008
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au0009
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000l
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au0011
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au0012
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au0013
echo
echo
echo walnut
echo
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000a
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000c
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000d
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000e
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000f
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000g
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000h
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000k
echo
echo
echo pioneer
echo
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000u
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000v
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000w
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000x
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000y
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au000z
echo
echo
echo rhodesdale
echo
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001a
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001b
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001c
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001d
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001e
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001f
echo
echo
echo coorinja
echo
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001u
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001v
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001w
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001x
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001y
/home/gmn/scripts/povggmn/gmnrelaystatus.sh au001z



echo
echo
echo overall
echo
/home/gmn/scripts/povggmn/gmnrelaystatus.sh "au00*"
echo sent to seti : $(ls /home/gmn/sendtoseti/*.senttoseti | wc -l)
echo
echo cams processes running: $(ls /home/gmn/.au* | wc -l)
ls /home/gmn/.au* -lhtr

