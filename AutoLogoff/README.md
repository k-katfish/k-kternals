# AutoLogoff

This tool is based on the logoff20minlock tool that I wrote in a bit of a hurry to solve a problem. Read more about the problem and why this solves it below. Or, read on for instructions on "installing" the AutoLogoff tool.

## "Installation"

### Deployment via Group Policy

In Group Policy Management Console, create (or edit) a Group Policy Object. Then, grab the GUID of that policy object and naviagate to your policy object's share on the domain controller. `\\your.dom.com\SYSVOL\your.dom.com\Policies\{your-policy-guid}\User\Files\`

Copy the executable: `AutoLogoff.exe` to that location.

> Note: %AppData% is a handy placeholder that points to `C:\Users\current-user\AppData\Roaming` . Give it a try: Open Explorer.exe, then press Ctrl + L, delete the selected text, and type %APPDATA%.

*Optional Step*: Create a folder: Edit the Policy Object, under **User Configuration -> Preferences -> Windows Settings -> Folders**, right click -> Add a new folder. Name it `%APPDATA%\your-dom` , and optionally make it Hidden (if you set your action to "Replace"). Note - it doens't have to be %AppData%\your-dom, it could be anything like %AppData%\utils or %AppData%\logoff_tool or something.

Now edit your group policy object, under **User Configuration -> Preferences -> Windows Settings -> Files**, add a new file. Put it somewhere the %LogonUser% can access, like %APPDATA%. If you created a folder (see above, *Optional Step*), this would be a great place to put your file. You could put it somewhere like `C:\Program Files` or something, but its soo small, and it's something that exists within the user's space, so why not also put the file in the user's folders as well?

If you need it spelled out, Right Click -> New File. For your source file, use the location of your file `\\your.dom.com\SYSVOL\your.dom.com\Policies\{your-policy-guid}\User\Files\AutoLogoff.exe`, then for the destination provide the location in the User's profile where this will be created: `%APPDATA%\your-dom\AutoLogoff.exe` .

### Scheduled Tasks

You can do this via GPO, under **User Configuration -> Preferences -> Control Panel Settings -> Scheduled Tasks**, then New Task. Create 2 tasks.

Task 1: "On Workstation Lock of %LogonUser%":

Create a task to run as %LogonDomain%\%LogonUser% . Set the trigger to be On Workstation Lock of %LogonDomain%\%LogonUser%. Set the action to be: Run a program, `%APPDATA%\your-dom\AutoLogoff.exe`, and be sure to provide the parameter -l, and optionally -t [seconds] to specify how long it should wait until the logoff occurs. By default this is 20 minutes.

Task 2: "On Workstation Unlock by %LogonUser%":

Create a task to run as %LogonDomain%\%LogonUser% . Set the trigger to be On Workstation unlock of %LogonDomain%\%LogonUser%. Set the action to be: Run a program, `%APPDATA%\your-dom\AutoLogoff.exe`, and be sure to provide the parameter -u to abort the pending logoff of this user.

Replce `%APPDATA%\your-dom` with the path to the two executables, if it's somewhere other than `%APPDATA%\your-dom`.

Note - Be sure to name your task something that includes %LogonUser% or the users SID or something to uniquely identify the user (otherwise another user who logs in will have the same task created for their user account, and the task won't end up running for the other user). If you include %LogonUser% in the task name (I mean the literal text %LogonUser%), every user who logs in will get a separate task created for their name. Something like "On Workstation Lock of kylek" and "On Workstation unlock of joeb".

## Parameters

Note - if you run AutoLogoff.exe with no parameters, it will try to abort a potentially existing logoff, and if there is no AutoLogoff pending then it will just do nothing. It's the same as running AutoLogoff.exe -u

### The important params

>- **--lock -l**    indicate that the workstation was locked, begin the logoff countdown
>- **--time -t [seconds]**   (optional) - Specify the time in seconds after lock that the user should be logged off. Defaults to 1200 seconds (20 minutes).
>- **--unlock -u**  indicate that the workstation was unlocked, abort the logoff.

### The secret params

- **--help -h**     show the help message
- **--forceadminlogoff** This one takes a bit of explaining. See, I don't want this to happen if the user with the username "Administrator" locks the workstation. But maybe you do want this to happen for the local admin account. So just pass the --forceadminlogoff parameter when you run the lock workstation task (`AutoLogoff.exe -l --forceadminlogoff`) and even the local admin account will get kicked if the local admin account locks the workstation.

## The Problem & Solution

### The Problem

You have a lab space. There's 60 computers in this space, and about 100 people will come through the space on a given day. Some will log off when they're done, but some will just lock the workstation and walk away. Others will **leave the workstation *unlocked*??** and walk away.

So... what's a lab admin to do when people will just leave the computers in this poor state?

You could enable **Fast User Switching**, and allow people to click **Switch User** on the login screen to move the other user session to a disconnected state, and then log in. But that won't actually log off the other user. Instead, the other user will continue to exist in the background, with all of their running processes taking up precious RAM and potentially CPU space that could be better used by the actual current user. What to do...

### The Solution

Disable **Fast User Switching**, and instead use this AutoLogoff tool. Now, a user can lock their workstation and leave, but still come back within 20 minutes and still have the workstation available to them. Unlock the workstation, and pick up *right* where they left off. But, if they leave for more than 20 minutes (often because they're just *leaving*), the workstation will log them off after the time limit you set (20 minutes by default), and then become available to someone else.
