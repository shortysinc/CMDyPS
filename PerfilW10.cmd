@echo off
::@author: Jorge R.
::Perfil Windows 10

::El siguiente Script hace automáticamente un perfil en Windows siguiendo los siguientes pasos:
::1. Entrar en el equipo como administrator.
::2. Copiar el script en en Desktop.
::3. Ejecutar el script as administrator.

set /P userpc="Introduce las iniciales del usuario: "
cls
echo %userpc%


if exist C:\USERS\%userpc% (echo Existe el usuario && goto EXISTEUSER) ELSE (echo El usuario introducido no existe en este equipo && goto NOEXISTEUSER)
set /P wait="Pulsa cualquier tecla..."

::Start EXISTEUSER
:EXISTEUSER
cls
echo Existe el usuario.
if exist C:\Users\%userpc%.old goto ExisteFolderUser
::Aquí renombramos el directorio que ya existe y le ponemos .old
Powershell Set-ExecutionPolicy Unrestricted CurrentUser
POWERSHELL Rename-Item -path 'C:\Users\%userpc%' -newName 'C:\Users\%userpc%.old'

::Una vez renombramos la carpeta del usuario a .old, tenemos que buscar el SID del user en AD.
::Lo saco por pantalla sólo para probar...
::wmic useraccount where name=%userpc% get SID
::set /p para="detenido..."


::Con este bucle  iteraro sobre todos los SID que hay en el equipo y buscar el SID del user deseado

for /f "delims= " %%a in ('"wmic path win32_useraccount where name='%userpc%' get sid"') do (
   if not "%%a"=="SID" (          
      set userreg=%%a
      goto :loop_end
   )   
)

:loop_end
echo El SID del usuario: %userpc% es: %userreg%
::-------------------------------------------FIN FOR-------------------------------------------

::Ahora una vez ya sabemos el SID del usuario, tengo que exportar una copia de seguridad de ese registro para tenerla en caso de que el script falle.
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\%userreg%" "C:\Security\%userpc%.reg" /y


::Habiendo importado la clave de registro que queriamos, ya podemos borrarla, para poder iniciar sesión otra vez y crear un nuevo perfil.
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\%userreg%" /f


set /P wait="Perfil antiguo borrado. Pulse una tecla para continuar..."
goto END
::FIN EXISTEUSER



::INICIO NOEXISTEUSER
:NOEXISTEUSER
cls
echo No existe el usuario...
set /P wait="Pulsa cualquier tecla para terminar..."
goto END

::FIN NOEXISTEUSER

:ExisteFolderUser
echo Ya existe una carpeta con old. Asegurese que desea hacer el perfil otra vez.
goto END

:END
powershell Set-ExecutionPolicy Undefined CurrentUser
set /P done="DONE!"