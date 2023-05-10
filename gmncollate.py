# Script to collate information from a meteor detection event from one station
# and save to dropbox


import os
import shutil
import datetime



def geteventslist(eventslocation):
    result = []
    for filename in os.listdir(eventslocation):
        if os.path.isdir(os.path.join(eventslocation, filename)):
            result.append(filename)
    result.sort()
    return (result)


def getworklist(eventslist):
    result = []
    for event in eventslist:
        if stationname not in os.listdir(os.path.join(eventslocation, event)):
            result.append(event)
    result.sort()
    return (result)


def collatedata(station, event):
    print("Collating data for {}".format(event))
    print("Create station directory")
    stationdirectory = (os.path.join(eventslocation, event, station))
    os.mkdir(stationdirectory)
    for camera in os.listdir(cameralistlocation):
        print("Creating directory for {} at station {}".format(camera, station))
        cameradirectory = os.path.join(stationdirectory, camera)
        os.mkdir(cameradirectory)
        copyfiles(station, camera, event, cameradirectory)


def convertgmntimetoposix(event):
    try:
     eventdate = event[0:8]
     eventtime = event[9:15]
     eventyear = int(eventdate[0:4])
     eventmonth = int(eventdate[4:6])
     eventday = int(eventdate[6:8])
     eventhour = int(eventtime[0:2])
     eventminute = int(eventtime[2:4])
     eventsecond = int(eventtime[4:6])

     eventposixtime = datetime.datetime(eventyear, eventmonth, eventday, eventhour, eventminute, eventsecond)
     return eventposixtime
    except:
     print("convergmntimetoposix failed")
     return 0


def copyfiles(station, camera, event, cameradirectory):
    print("For event {} copy the files for camera {} at station {} to directory {}".format(event, camera, station,
                                                                                           cameradirectory))
    print("Determine path of night directory")
    print(RMSRoot)
    captureddatadirectory = os.path.join(RMSRoot, camera, RMS_data)
    eventposixtime = convertgmntimetoposix(event)
    print(eventposixtime)
    for nightdirectory in os.listdir(captureddatadirectory):
        directoryposixtime = convertgmntimetoposix(nightdirectory[7:22])

        if directoryposixtime < eventposixtime:
            # capture directory must be timestamped before the event
            if ((eventposixtime - directoryposixtime).total_seconds()) < 16 * 3600:
                # capture start must be less than 16 hours before the event
                print("Candidate directory is {}".format(nightdirectory))
                nightdirectoryfullpath = (os.path.join(captureddatadirectory, nightdirectory))
                relevantfilesfound = False
                for file in os.listdir(nightdirectoryfullpath):
                    if file.endswith(".fits"):
                        fileposixtime = convertgmntimetoposix(file[10:25])
                        if abs((fileposixtime - eventposixtime).total_seconds()) < 30:
                            print("Candidate file is {}".format(file))
                            print("Copy file from {} to {}".format(os.path.join(nightdirectoryfullpath, file),
                                                                   cameradirectory))
                            shutil.copyfile(os.path.join(nightdirectoryfullpath, file),
                                            os.path.join(cameradirectory, file))
                            relevantfilesfound = True

                    if file.endswith(".bin"):
                        fileposixtime = convertgmntimetoposix(file[10:25])
                        if abs((fileposixtime - eventposixtime).total_seconds()) < 30:
                            print("Candidate file is {}".format(file))
                            print("Copy file from {} to {}".format(os.path.join(nightdirectoryfullpath, file),
                                                                   cameradirectory))
                            shutil.copyfile(os.path.join(nightdirectoryfullpath, file),
                                            os.path.join(cameradirectory, file))
                            relevantfilesfound = True

                if relevantfilesfound:
                 #convert the fits to jpg
                 shellcommand = "cd " + cameradirectory + ";"
                 shellcommand += "for f in *.fits; do convert -flip $f ${f%.*}.bmp; cp ${f%.*}.bmp composite.bmp; done;"
                 shellcommand += "for f in *.fits; do convert -flip $f ${f%.*}.jpg; done;"
                 shellcommand += "/home/" + username + "/scripts/povggmn/gmnstack.sh " + cameradirectory + "  " + camera + ";"
                 shellcommand += "mv " + cameradirectory + "/" + camera + "_stack.jpg " + cameradirectory + "/.."
                 print(shellcommand)
                 os.system(shellcommand)
                 #copy the .config file
                 shutil.copyfile(os.path.join(nightdirectoryfullpath, ".config"),
                                 os.path.join(cameradirectory, ".config"))
                 #copy the platepar
                 shutil.copyfile(os.path.join(nightdirectoryfullpath, ".config"),
                                 os.path.join(cameradirectory, ".config"))
                 #copy the CALSTARS file
                 shellcommand = "cp " + nightdirectoryfullpath + "/CALSTARS*.txt " + cameradirectory
                 os.system(shellcommand)
                 #copy any .bz2 files
                 shellcommand = "cp " + nightdirectoryfullpath + "/*.bz2 " + cameradirectory
                 os.system(shellcommand)
                 #copy any FTPdetectinfo files
                 shellcommand = "cp " + nightdirectoryfullpath + "/FTPdetectinfo*.txt " + cameradirectory
                 os.system(shellcommand)
                 # copy any platepar files
                 shellcommand = "cp " + nightdirectoryfullpath + "/platepar_cmn2010.cal " + cameradirectory
                 os.system(shellcommand)
                 # copy any ecsv files
                 shellcommand = "cp " + nightdirectoryfullpath + "/*.ecsv" \
                                                                 " " + cameradirectory
                 os.system(shellcommand)
                 #convert bin files to mp4
                 shellcommand = "~/scripts/bintomp4.sh " + cameradirectory

                 print(shellcommand)
                 os.system(shellcommand)

if __name__ == '__main__':
    print("Collator started")
    stationname = os.popen("hostname").read().strip()
    username = os.popen("whoami").read().strip()
    eventslocation = "/home/" + username + "/Dropbox/events"
    cameralistlocation = "/home/gmn/cameras"
    RMSRoot = "home"
    RMS_data = "RMS_data/CapturedFiles/"

    print("Station Name : {}".format(stationname))
    print("User Name : {}".format(username))

    eventslist = geteventslist(eventslocation)
    worklist = getworklist(eventslist)
    print("Work to do on events {}".format(worklist))
    if len(worklist) == 0:
        print("No work to do, exit")
        exit()
    for event in worklist:
        collatedata(stationname, event)
