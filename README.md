# k-kternals

Like sysinternals... but the tools that I wrote

Each of these tools has it's own folder, with it's own README file with more details on each tool. But here's a quick list of the tools.

## AutoLogoff

A tool designed to automatically log a user off after a certain ammount of inactivity (after they lock the workstation). Meant to be deployed in a Server Active Directory domain environment. Put a copy of the .exe on a globally accessible share (like your domain controller's public share) and then create a GPO as described in the readme.

## 6thSense

You know RDP shadowing? I guess it's actually called Terminal Services shadowing but whatever. Anyway... wouldn't it be nice to know if someone is watching your session remotely? This is a set of scheduled tasks (you'll have to import them yourself) which listen for the shadow events 20503, 20504, 20506 and 20507 and then trigger a msg box with the appropriate text to alert you that your session is being watched/controlled/unwatched/uncontrolled.
