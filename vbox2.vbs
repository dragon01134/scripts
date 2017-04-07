
Set objShell = CreateObject("Wscript.Shell")
CloneSrcBox = "Clone"
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
newMachineLine:
	newBox = InputBox("Enter new machine name","Machine name")
	If len(newBox) <> 0 Then
		Wscript.echo "Machine Name:" & newBox

		If Not  virtual_machine_exist(newBox) Then
			Wscript.Echo "Box Exists Give another name"
			GoTo newMachineLine
		End If
	
		If  virtual_machine_exist(CloneSrcBox) Then
			cmd="cmd /c VBoxManage.exe clonevm"& CloneSrcBox & "--register --name  " & newBox
			wscript.Echo cmd
			intRet = objShell.Run(cmd,1,true)
			If intRet <> 0 Then
				Wscript.echo "Failed to create the box : " & newBox & "Quiting"
				Wscript.Quit
			Else
				Wscript.echo "Box created sucessfully : " & newBox
			End if
		Else
			Wscript.Echo "Base Machine not exists"
		End If
	End if
End If

'For Modification of interface type and network
'	VBoxManage modifyvm virtual_box_name --nic<N> intnet --intnet network_name


Function virtual_machine_exist(boxName)
	virtual_machine_exist=False
	username = objShell.ExpandEnvironmentStrings( "%USERNAME%" )
	objShell.CurrentDirectory = "C:\Program Files\Oracle\VirtualBox"
	objShell.Run "cmd /c VBoxManage.exe list vms >C:\Users\" & username & "\temp"
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set file = fso.OpenTextFile("C:\Users\"& username &"\temp")
	
	do Until file.AtEndOfStream
		line = file.Readline
		words = Split(line," ")
		bname = Replace(words,chr(34),"")
		If bname = boxName Then
			virtual_machine_exist=True
			file.Close
			Exit Function
		End If
	Loop
	file.Close
End Function



