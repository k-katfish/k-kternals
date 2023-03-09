# logoff20minlock

How to log off the current user 20 minutes after they lock the workstation (Logoff by pressing Win+L plus 20 minutes)

## Setup

### Deploy via Group Policy Object

In Group Policy Management Console, create (or edit) a Group Policy Object. Then, grab the GUID of that policy object and naviagate to your policy object's share on the domain controller. `\\your.dc.com\SYSVOL\your.dc.com\Policies\{your-policy-guid}\User\Files\`

Copy the executables: `OnWorkstationLockTask.exe` and `OnWorkstationUnlockTask.exe` to that location.

> Note: %AppData% is a handy placeholder that points to `C:\Users\current-user\AppData\Roaming` . Give it a try: Open Explorer.exe, then press Ctrl + L, delete the selected text, and type %APPDATA%.

*Optional Step*: Create a folder: Edit the Policy Object, under **User Configuration -> Preferences -> Windows Settings -> Folders**, right click -> Add a new folder. Name it `%APPDATA%\your-com` , and optionally make it Hidden (if you set your action to "Replace").

Now edit your group policy object, under **User Configuration -> Preferences -> Windows Settings -> Files**, add 2 new files. Put them somewhere the %LogonUser% can access, like %APPDATA%. If you created a folder (see above, *Optional Step*), this would be a great place to put your 2 files. Add the both the OnWOrkstationLockTask.exe and OnWorkstationUnlockTask.exe.

If you need it spelled out, Right Click -> New File. For your source file, use the location of your file `\\your.dc.com\SYSVOL\your.dc.com\Policies\{your-policy-guid}\User\Files\OnWorkstationLock.exe`, then for the destination provide the location in the User's profile where this will be created: `%APPDATA%\your-com\OnWorkstationLock.exe` . Repeat for OnWorkstationUnlock.exe .

### Scheduled Tasks

You can do this via GPO, under **User Configuration -> Preferences -> Control Panel Settings -> Scheduled Tasks**, then New Task. Create 2 tasks.

Task 1: On Workstation Lock:

Create a task to run as %LogonDomain%\%LogonUser% . Set the trigger to be On Workstation Lock of %LogonDomain%\%LogonUser%. Set the action to be: Run a program, `%APPDATA%\your-org\OnWorkstationLock.exe`.

Create a task to run as %LogonDomain%\%LogonUser% . Set the trigger to be On Workstation unlock of %LogonDomain%\%LogonUser%. Set the action to be: Run a program, `%APPDATA%\your-org\OnWorkstationUnlock.exe`.

Replce `%APPDATA%\your-org` with the path to the two executables, if it's somewhere other than `%APPDATA%\your-org`.

## Notes

This tool (these two related tools) will not run if the local user is the account named "Administrator". This is so that when deploying a machine via MDT, the task sequence can continue to run for an extended period of time even though the local administrator account may have locked the workstation.
