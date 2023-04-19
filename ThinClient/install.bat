REM echo 'Set shell = CreateObject("WScript.Shell")' > C:\Windows\System32\mstsc.vbs
REM echo 'shell.Run "mstsc.exe C:\ORG\server.rdp", 1, true' >> C:\Windows\System32\mstsc.vbs
REM echo 'shell.Run "logoff"' >> C:\Windows\System32\mstsc.vbs

REM echo 'Set shell = CreateObject("WScript.Shell")' > C:\Windows\System32\invisible.vbs
REM echo 'shell.Run "wscript.exe C:\Windows\System32\mstsc.vbs /B"' >> C:\Windows\System32\invisible.vbs

COPY invisible.vbs C:\Windows\System32\invisible.vbs
COPY mstsc.vbs C:\Windows\System32\mstsc.vbs
COPY server.rdp C:\ORG\server.rdp

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t reg_sz /d 'wscript.exe C:\Windows\System32\invisible.vbs'  /f

REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation" /v AllowDefaultCredentials /t reg_dword /d 1 /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation" /v ConcatenateDefaults_AllowDefault /t reg_dword /d 1 /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowDefaultCredentials" /v 1 /t reg_sz /d "TERMSRV/changeme.server.fake.example.org" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowDefaultCredentials" /v 2 /t reg_sz /d "TERMSRV/changeme" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowDefaultCredentials" /v 3 /t reg_sz /d "TERMSRV/*" /f