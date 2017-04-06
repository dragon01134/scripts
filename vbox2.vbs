
If Wscript.Arguments.Count() > 0 Then
	Set objShell = CreateObject("Wscript.Shell")

	Wscript.echo objShell.CurrentDirectory


	objShell.CurrentDirectory = "C:\Program Files\Oracle\VirtualBox"


	Wscript.echo objShell.CurrentDirectory

	objShell.Run "cmd /c VBoxManage.exe list vms >C:\Users\jitendra\Downloads\temp"

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set file = fso.OpenTextFile("C:\Users\jitendra\Downloads\temp")

	text = file.ReadAll
	file.Close

	If InStr(text,"Clone") > 0 Then
	   WScript.Echo "Found Match"
	   cmd="cmd /c VBoxManage.exe clonevm Clone --register --name  " & Wscript.Arguments.Item(0)
	   wscript.Echo cmd
	   
	Else
	   WScript.Echo "No match"
	End If
Else 
	intBox = InputBox("Enter new machine name","Machine name")
	If len(intBox) <> 0 Then
		Wscript.echo "Machine Name:" & intBox
		Set objShell = CreateObject("Wscript.Shell")

		Wscript.echo objShell.CurrentDirectory


		objShell.CurrentDirectory = "C:\Program Files\Oracle\VirtualBox"


		Wscript.echo objShell.CurrentDirectory

		objShell.Run "cmd /c VBoxManage.exe list vms >C:\Users\jitendra\Downloads\temp"

		Set fso = CreateObject("Scripting.FileSystemObject")
		Set file = fso.OpenTextFile("C:\Users\jitendra\Downloads\temp")
	
		text = file.ReadAll
		file.Close
	
		If InStr(text,"Clone") > 0 Then
			WScript.Echo "Found Match"
			cmd="cmd /c VBoxManage.exe clonevm Clone --register --name  " & intBox
			wscript.Echo cmd
			intRet = objShell.Run(cmd,1,true)
			If intRet <> 0 Then
				Wscript.echo "Failed to create the box : " & intBox
			Else
				Wscript.echo "Box created sucessfully : " & intBox
			End if
			
	   
		Else
			WScript.Echo "No match"
		End If
	End if
End If

'For Modification of interface type and network
'	VBoxManage modifyvm virtual_box_name --nic<N> intnet --intnet network_name






