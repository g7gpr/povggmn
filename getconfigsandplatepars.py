import os, glob
from tqdm import tqdm


filesystemroot ="/home/"
storagedirectory = "/home/gmn/"
libraryname = "archives/"


remotemachine = "gmn@192.168.1.241"
remotemachinepath = "/home"



if __name__ == '__main__':

    cameralist = []
    for camera in os.listdir(filesystemroot):
        if camera[0:2] == 'au':
                cameralist.append(camera)
    cameralist.sort()
   
    for camera in cameralist:
        bz2files = glob.glob(os.path.join(filesystemroot,camera,"files/incoming","*.bz2"))

        for bz2file in tqdm(bz2files):

           directorytocreate = os.path.join(filesystemroot, storagedirectory,libraryname,camera,"RMS_data","CapturedFiles",os.path.basename(bz2file)[0:29],"tmp")

           shellcommand = ""
           shellcommand += "mkdir -p {} ;\n".format(directorytocreate)
           shellcommand += "cd {};\n".format(directorytocreate)
           shellcommand += "cp {} . ;\n".format(os.path.join(filesystemroot,camera,"files/incoming",bz2file))
           shellcommand += "tar -xf {};\n".format(os.path.basename(bz2file))
           shellcommand += "cp .config ../ ; "
           shellcommand += "cp platepar_cmn2010.cal ../ ; "
           shellcommand += "cd .. ;"
           shellcommand += "rm -rf tmp ; "

           os.system(shellcommand)
