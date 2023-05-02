# Cleanup after yourself

I work on other people's computers. A lot. I mean, technically they're mine to manage, but they're also for someone who isn't me and I don't really want my stuff sticking around after I'm gone.

This is less of a tool and more of a how-to guide for IT people looking to clean up after themselves.

## Step 1: Delete your user profile

DelProf by Helge Kline is a tremendously helpful tool for deleting your user profile on "this" or a remote computer. Just run it with a few parameters:

`DelProf2.exe /c:[Your Computer Here] /id:[Your_Username]`

You can learn more about DelProf2 from <https://helgeklein.com/free-tools/delprof2-user-profile-deletion-tool/> and download the tool from the official download page: <https://helgeklein.com/download/>.

Once you have it downloaded I'd recommend putting it on a file share that you have access to so that you can use it wherever you go. Or just take it with you.

## Step 2: Clear out your login info from the Windows Login screen

It's super awkward for me whenever I build a computer for someone and they go to sign in and Windows is like "Hey kkatfish, want to sign in?" and whoever is picking up the computer is like "umm, who is this?" or worse yet - they try too many times to enter their password with my username and _my_ account gets locked.

Pro tip #1: When you image a computer, don't touch it until the client signs in. If you access it remotely, the logonui won't have a chance to cache your username and ask you to log in.

Pro tip #2: If that fails (you had to log in at the computer)...

Clear out the following registry keys (but don't outright delete them):

`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI ! LastLoggedOnDisplayName`

`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI ! LastLoggedOnSAMUser`

`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI ! LastLoggedOnUser`

`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI ! LastLoggedOnUserSID`

`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI ! SelectedUserSID`

Reboot the computer, and windows should just say "howdy whoever you are!" (not literally, it should say Other User and prompt for a username and password).
