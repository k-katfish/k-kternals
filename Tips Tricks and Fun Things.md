# Tips, Tricks, and Fun Things

I've used Windows a bit more than the average bear. And in that time I've picked up a thing or two. But this isn't for me to keep all to myself, no, I want you to bask in the joy of having a super user friendly and awesomely powerful operating system.

## PowerToys

Published with every version of Windows since XP, PowerToys is a set of tools, utilities, and other applets that extend some of the default Windows behaviors. It can sometimes be a testing ground for new features, some Windows features actually used to just be PowerToys applets.

Some helpful things I enjoy are FancyZones, invisible snapable boxes on your screen where you can drag and drop a window to automatically size it just the way you want.

Another tool I enjoy is PowerRename, which allows you to quickly rename a whole lot of files using regular expressions and more (but all in the helpful applet with a GUI!)

I also _love_ the File Explorer add-ons. These let you preview PDF, pictures, SVGs, and even source code files directly in file explorer! You know that alt+p preview window that everyone leaves closed all the time because for just about anything other than a jpeg all it says is "No preview available"? Well File Explorer add-ons makes a preview available for all kinds of file types. Super handy when you want to see whats in a file without waiting like 10 seconds for notepad to open, or 30 seconds for photoviewer to initialize.

## learn your .cpls

Why, oh why did Microsoft decide to bury the rename this computer option 5 layers deep? Win+I -> System -> About -> Rename this PC (Advanced) (or Advanced System Settings on Win11) -> Computer Name tab -> Change? That's too many clicks even for me.

But... you can also just get straight to the "Rename this PC (Advanced)" window. It's called sysdm.cpl, and it's a control panel menu that you can use to specify System Environment Variables, the Name of your PC, and configure Remote Desktop options. Just press Win+R and run sysdm.cpl (or run that from a command line, powershell, or even from Windows Search if it would ever load) and you'll be taken straight to the sysdm.cpl window.

### My memorized every-day tools

Here are a list of some of my favorite little .cpl and .msc managment tools (I have each of these memorized and use these at least once everyday):

| tool | what it does |
| --- | --- |
| sysdm.cpl | System Properties (sys-dm, get it?) Set computer name, Environment Variables, Remote access |
| devmgmt.msc | Device Manager |
| lusrmgr.msc | Manage local users and groups. Run it with /computer:[other-pc-name] to manage the local users and groups on another computer (in a domain, don't get your hopes up script kiddies) |
| gpedit.msc | Edit the local computer's policy. use with /gpcomputer: [computername] (note the space) to manage the policy on another computer. |
| compmgmt.msc | Computer Management console. run with /computer:[computername] to manage another computer. |
| regedit | Registry editor (gui) |
| diskmgmt.msc | Disk Managment (Create and format hard disk partitions) |
| eventvwr.msc | Windows Event Viewer. Not as useful as, say, rsyslog, but better than nothing. |
| secpol.msc | Manage local security policy. Same as Computer Configuration -> Policies -> Windows Settings -> Security Settings on GPMC. |
| services.msc | Manage installed services |
| taskschd.msc | Create and manage scheduled tasks |

### Other tools

Other tools I use less frequently, but frequently enough to merit a spot in the list of CPLs you should know about.

| tool | what it does |
| --- | --- |
| appwiz.cpl | Uninstall a Program applet |
| inetcpl.cpl | Internet Browsing Options (not directly internet explorer, but like, the configuration tool for ie) |
| joy.cpl | Joystick (or gamepad) controllers |
| powercfg.cpl | Pro tip - on Windows 11 the default is f-ing "Balanced". Set that sh*t to "Ultimate Performance". Comeon Microsoft. |
| certmgr.msc | Current User Certificates |
| certlm.msc | Local Machine Certificates |
| wf.msc | Windows Firewall |
| fsmgmt.msc | File/Folder share management |
| ncpa.cpl | The network connection/interfaces applet |
| printmanagement.msc | Manage printers and print servers. Also helpful for managing other print servers without remoting into those servers. |

### Server-specific tools

These tools are really only available on Windows Server and only if you have that particular feature installed, so helpful if you're a sysadmin but these might not exist on Windows 10/11.

| tool | what it does |
| --- | --- |
| gpmc.msc | Group Policy Managment Console - (only on computers with the GPMC tool installed). Edit Group Policy objects in a domain |
| dsa.msc | Active Directory Users and Computers. Manage user and computer objects in a Windows Active Directory Domain |
| virtmgmt.msc | Hyper-V manager |
| wdsmgmt.msc | Windows Deployment Services |

## Server Manager

Super helpful tool for managing servers. Pro tip- add all your servers. If something comes up, like you need to install an optional feature/role to one or more servers, you can do that pretty simply with Server Manager.
