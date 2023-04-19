Set shell = CreateObject("WScript.Shell")
shell.Run "mstsc.exe C:\ORG\server.rdp", 1, true
shell.Run "logoff"