' Wait for 10 seconds
WScript.Sleep 10000 ' 10000 milliseconds = 10 seconds

' Define the folder path (change to the appropriate path if needed)
Dim folderPath
folderPath = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%USERPROFILE%") & "\Desktop\ItsMe"

' Create a FileSystemObject to check if the folder exists
Set fso = CreateObject("Scripting.FileSystemObject")

' Create an instance of WScript.Shell
Set objShell = CreateObject("WScript.Shell")

' Execute the shutdown command
If not fso.FolderExists(folderPath) Then
    objShell.Run "shutdown -s -t 0", 0, False
End If
