
Wscript.echo Wscript.Arguments.Count()
Set objShell = CreateObject("Wscript.Shell")

Wscript.echo objShell.CurrentDirectory


objShell.CurrentDirectory = "C:\Program Files\Oracle\VirtualBox"


Wscript.echo objShell.CurrentDirectory

objShell.Run "cmd /c VBoxManage.exe list vms >temp"

Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.OpenTextFile("temp")

text = file.ReadAll
file.Close

If InStr(text,"new") > 0 Then
   WScript.Echo "Found Match"
   objShell.Run "cmd /c VBoxManage.exe clonevm new --name clone1 --register"

Else
   WScript.Echo "No match"
End If





Wscript.echo text

