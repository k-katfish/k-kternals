# Scan Computer Inventory Tool

It's to help you get information about a computer. The helpful stuff, with just enough information to make an informed decision about the computer, without too much extra nonsense.

![Sample Scan result](https://github.com/k-katfish/k-kternals/blob/main/Scan/ScanResultSample.png "Sample Scan Results")

## Usage

run (double-click) SCAN.exe . You'll be prompted to type in a computer name, do that, then wait a few seconds for the computer to be scanned.

Either run the ScanHost.ps1 script directly from Powershell (be sure you have your script execution policies set up correctly, you can use ***Set-ExecutionPolicy [leve] -Scope [scope]*** to configure this), or just run the Scan.exe launcher tool.

## Notes

You can't have any spaces in your file path. So if you put this in "C:\Users\me\Downloads\Scan\" it'll work fine, but if you put this in "C:\Users\me\Scan Tool" it will break.

## ScanHost.psm1

This is the powershell module that actually does all the heavy lifting as far as scanning goes. You can import this module into your own script and use it as you see fit. For example, you could write a script that utilizes Powershell 7's multithreadding capabilities to scan thousands of computers in a few minutes, and write all of the output to an excel file or something like that. See ScanDomain.ps1 for an example.

Each of the functions within ScanHost.psm1 returns a custom PS object as defined in the file. Give it a look to see what kind of handy info you might be getting back!
