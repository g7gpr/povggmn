#!/bin/bash
ls ~/RMS_data/ArchivedFiles/*.bz2 | tail -n$1 | grep bz2 >> ~/RMS_data/FILES_TO_UPLOAD.inf 

