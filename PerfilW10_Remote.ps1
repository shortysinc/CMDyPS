 #@author: Jorge Rivas
 #Pendiente de Migrar a <java>

 <#
    Aún estando UAC activado, ejecutaría lo que necesitamos 
    de forma correcta, ya que somos admins
 #>

<#
    Se podrían lanzar perfiles para varios equipos a la vez, pero para eso después tendría que implementar un foreach.
    Aunque no tenga mucho sentido desde el punto de vista funcional, se puede mirar.
#>
<#
    [CmdletBinding()]
        PARAM (
            [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
            [String[]]$useripName = $env:ComputerName
        )
#>
#Abre una ventana donde nos pide el user e IP del equipo al que queremos hacer perfil 

<#------------------------------------------------------------------------#>
Set-ExecutionPolicy Unrestricted CurrentUser -Force
<#------------------------------------------------------------------------#>
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$titleIp = '-Perfil Remoto Windows 10-'
$msgIp   = 'Introduzca las Ip del equipo:'

$userip = [Microsoft.VisualBasic.Interaction]::InputBox($msgIp, $titleIp)

$title = '-Perfil Remoto Windows 10-'
$msg   = 'Introduzca las iniciales del usuario:'

$userperf = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)


try{

    if (Test-Path "\\$userip\c$\users\$userperf.old*"){
        $userperfout = [Microsoft.VisualBasic.Interaction]::MsgBox("Ya existe una carpeta .OLD para el usuario $userperf. Revisa si es necesario rehacer el perfil.")
    }
    else{
        try{
            if (Test-Path "\\$userip\c$\users\$userperf"){
                #Renombra la carpeta del usuario y dejamos un backup.
                Rename-Item -path "\\$userip\c$\users\$userperf" -NewName "\\$userip\c$\users\$userperf.old" -force 
                $userperfout = [Microsoft.VisualBasic.Interaction]::MsgBox("Se ha renombrado la carpeta del usuario $userperf")
                #En esta línea ejecutamos el cambio de perfil en el equipo solicitado.
                Get-WmiObject -ComputerName $userip -Class Win32_Userprofile | where {($_.localpath -eq "c:\Users\$userperf")}| Remove-WmiObject
                #Borramos archivo de CtrlFiles
                Remove-Item  "\\$userip\c$\CtrlFiles\LoginScriptW10OFF16_$userperf.txt" -Force
                $userperfout = [Microsoft.VisualBasic.Interaction]::MsgBox("Se ha borrado el perfil del usuario $userperf")
            }
            else{
                $userperfout = [Microsoft.VisualBasic.Interaction]::MsgBox("No existe el usuario $userperf")
            }
        }
        catch{
            $userperfout = [Microsoft.VisualBasic.Interaction]::MsgBox("Fallo al hacer perfil remotamente")
        }
    }
}
catch{
        $userperfout = [Microsoft.VisualBasic.Interaction]::MsgBox("Fallo al hacer perfil remotamente")
}
exit
#10.33.162.232