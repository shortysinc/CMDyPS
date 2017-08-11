# @author: Jorge R.

#Cuando rehacemos perfil y no nos aparece la tienda, sticky notes y edge; tenemos que reinstarlos con los xml's de configuración que vienen en la ruta
#C:\Program Files\WindowsApps\<La aplicación que sea. Hay que ir leyendo.> o C:\Windows\SystemApps\<La aplicación que sea. Hay que ir leyendo.>

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Previamente antes de probar el script, habría que cambiar la política de ejecución de scripts de PS de Undefined a Unrestricted con respecto al Currentuser. Una vez se haya terminado de ejecutar los 3 comandos,
#hay que volver a dejar la política tal y como estaba para prevenir ejecuciones no previstas o maliciosas.
#1. Set-ExecutionPolicy Unrestricted Currentuser
#2. Ejecutar el script 
#3. Set-ExecutionPolicy Undefined Currentuser
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Nota: Si no sabemos cómo se llama el paquete que queremos "registrar", podemos ver su nombre ejecutando: Get-AppxPackage -AllUsers. también nos devuelve su ubicación.


#Microsoft Edge
Add-AppxPackage -register "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AppxManifest.xml" -DisableDevelopmentMode

#Store
Add-AppxPackage -register "C:\Program Files\WindowsApps\Microsoft.WindowsStore_11706.1001.26.0_x64__8wekyb3d8bbwe\AppxManifest.xml" -DisableDevelopmentMode

#Sticky notes
Add-AppxPackage -register "C:\Program Files\WindowsApps\Microsoft.MicrosoftStickyNotes_1.8.0.0_x64__8wekyb3d8bbwe\AppxManifest.xml" -DisableDevelopmentMode