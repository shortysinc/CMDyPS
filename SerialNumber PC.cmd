'@author: Jorge R.
@echo off
CLS
set /P pc=Enter Computer Name/IP:

sc \\%pc% config remoteregistry start=auto
sc \\%pc% start remoteregistry 
CLS
wmic /NODE:%pc% bios get serialnumber
set /P stop=Done!
sc \\%pc% stop remoteregistry
sc \\%pc% config remoteregistry start=disabled

