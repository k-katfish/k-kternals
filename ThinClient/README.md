# Thin Client

This was a handy little tool I wrote for ETS, but it's pretty much applicable everywhere. Here's how it works:

When you sign into a windows computer, the first program to get launched is your Shell (technically the first is the shell host and then the shell is the second). Anyway, by default the shell on Windows is Explorer.exe. When this program gets launched, your taskbar, desktop, start menu, everything gets set up and loaded and ready to go. But... you can change this. You don't *have* to use Explorer.exe as your shell. You could use C:\Windows\System32\cmd.exe as your shell. Or you could write your own custom application to use as your shell. Once you realize you can make your own shells man the world's your oyster.

Anyway, we can change that shell to be wscript.exe. Which is awesome, cause that means we can run a script with wscript.exe to do anything we want. In this case, we're going to run a script called "Invisible.vbs" which will allow us to have a task running without any kind of visible window.

In our invisible.vbs script, we'll call wscript.exe to run a second script: mstsc.vbs. This script will launch Remote Desktop (mstsc) and have it open the connection file C:\ORG\server.rdp . When that connection eventually gets closed, the next line in mstsc.vbs will get executed: logoff.exe . The user will be logged off of the computer, and everything is done.

## Configuration

There's a few things you'll need to take care of first:

1. Edit install.bat
    - Change the name of your org: line 10: COPY server.rdp C:\ORG\server.rdp (change this to wherever you'll be putting your server.rdp file)
    - Optionally, uncomment (remove the REM) lines 14-18 and edit those to match your server name. This will create some registry entries to trust the remote computer for credentials delegation, which means you won't have to log in again (I recommend doing this, or at least deploying trust-credentials-delegation through a GPO)
2. Edit server.rdp
    - Line 24: provide the name of your remote server.
    - If this is the redirector for a farm, edit line 44: set it to 1 instead of 0.
3. Edit mstsc.vbs
    - Adjust line 2 to the correct path for your server.rdp file, if you didn't put it at C:\ORG\server.rdp.

## Installation

Once you've done all of your configuration things, run install.bat.

## Note: You can also deploy all of this with Group Policy

Instead of copying/scripting/executing/installing, you could simply configure & publish the invisible.vbs, mstsc.vbs, and server.rdp files in a globally readable share (like one on a domain controller) and then create a Group Policy Object which copies these files to C:\Windows\System32 and then sets the registry key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon!Shell" equal to 'wscript.exe C:\Windows\System32\invisible.vbs' (no quotes). In that same group policy object, you should also allow the use of Default Credentials Delegation, under Computer Configuration -> Administrative Templates -> System -> Credentials Delegation, Enable "Allow Delegating Default Credentials" and "Allow Delegating Default Credentials with NTLM-Only Server Authentication", and add 3 items to each list: TERMSRV/* ; TERMSRV/server ; TERMSRV/server.example.org
