import os
import time

filesystemroot ="/"
storagedirectory = os.path.expanduser("~/gmn/")
libraryname = "trajectorydata/"
indexname = "index.txt"
webaddresstomirror= "https://globalmeteornetwork.org/data/traj_summary_data/daily"
oldfilesuffix = ".old"

#remotemachine = "david@x220"



# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    shellcommand = "mkdir -p {}".format(os.path.expanduser("~/gmn/trajectorydata/"))
    os.system(shellcommand)
    #does an index.txt file exist in the storage directory
    indexfile = storagedirectory + libraryname + indexname
    print("Indexfile " + filesystemroot + indexfile)
    if os.path.exists(filesystemroot + indexfile):
        print(filesystemroot + indexfile + " exists")
    else:
        print(filesystemroot + indexfile + " does not exist")

        #shellcommand = "ssh " + remotemachine + ' "touch ' + indexfile + '"'
        shellcommand = "touch " + indexfile
        print(shellcommand)
        os.system(shellcommand)


    # if the old index file still exists then do not mv the current file. Use the old index file for the comparison

    shellcommand =  'bash -c "if [[ -f ' + indexfile + oldfilesuffix + ' ]];'
    shellcommand += 'then echo exists ;'
    shellcommand += 'else echo notexists ;'
    shellcommand += 'fi"'
    #shellcommand = 'ssh ' + remotemachine + ' "' + shellcommand + '"'
    output_stream = os.popen(shellcommand)
    shellcommandreturn = output_stream.read().strip()
    print(shellcommandreturn)
    if shellcommandreturn == "notexists":
        print("No left over file - copy current index file to old")
        # shellcommand = 'ssh ' + remotemachine + ' "mv ' + indexfile + ' ' + indexfile + oldfilesuffix + '"'
        shellcommand = 'mv ' + indexfile + ' ' + indexfile + oldfilesuffix
        os.system(shellcommand)
    else:
        print("Left over file - use the existing old file as the reference and do not copy")


    shellcommand = 'lynx ' + webaddresstomirror + ' --nolist --dump > ' + storagedirectory + libraryname + indexname
    #shellcommand = 'ssh ' + remotemachine + ' "' + shellcommand + '"'
    print(shellcommand)
    os.system(shellcommand)
    with open (filesystemroot + indexfile + oldfilesuffix) as oldindex:
     with open(filesystemroot + indexfile) as newindex:
       for newline in newindex:
           if newline[0:3]=="../":
               break
       for newline in newindex:
           downloadrequired=True
           if newline[0] == " ":
               break
           oldindex.seek(0,0)
           for oldline in oldindex:
              if newline == oldline:
                   downloadrequired=False
                   break
           if downloadrequired:
               filetodownload = webaddresstomirror + '/' + newline.split()[0]

               shellcommand = 'cd ' + storagedirectory + libraryname + ";"
               shellcommand += 'rm $(basename ' + filetodownload + ');'
               shellcommand += ' wget ' + filetodownload
               #shellcommand = 'ssh ' + remotemachine + ' "' + shellcommand + '"'
               print(shellcommand)
               os.system(shellcommand)
    #shellcommand = 'ssh ' + remotemachine + ' "rm ' + storagedirectory + libraryname + indexname + oldfilesuffix + '"'
    shellcommand = 'rm ' + storagedirectory + libraryname + indexname + oldfilesuffix
    os.system(shellcommand)
