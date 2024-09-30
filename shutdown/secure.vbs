' Wait for 10 seconds
WScript.Sleep 10000
Dim folderPath
folderPath = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%USERPROFILE%") & "\Desktop\ItsMe"

Set fso = CreateObject("Scripting.FileSystemObject")

Set objShell = CreateObject("WScript.Shell")

If not fso.FolderExists(folderPath) Then
    objShell.Run "shutdown -s -t 0", 0, False
    Else
    fso.DeleteFolder(folderPath)
End If
