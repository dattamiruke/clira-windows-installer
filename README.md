clira-windows-installer
=======================

This repository contains the necessary files to build the Windows CLIRA
installer.

Prerequisites
-------------

* Inno Setup (http://www.jrsoftware.org/isinfo.php)
* This repository checked out

How to Build the Windows Installer
----------------------------------

First off, install Inno Setup.  This is a Windows installer framework that
uses .iss files as the input to build the installer application.

Wherever you checked out the repository to, you will need to modify the
clira.iss Inno Setup Script file to point to this location.  If you don't want
to modify the file, check the repository out into C:\CLIRABASE.

If you need to modify the location, search and replace C:\CLIRABASE to
wherever you have the repository.  The Inno Setup script expects to find the
files that it needs to include in the installer in this location.

After this is done, open clira.iss in the Inno Setup Compiler and choose
"Build".  It will create a "Output" directory which contains the built
CLIRA installer setup.exe file.

Things To Know
--------------

The ISS file will package up all the prerequisite cygwin install files (and
the Cygwin installer) from C:\CLIRABASE\cygwin into the .exe file.

During installation, these files will be extracted, and Inno Setup will run
the Cygwin installer in local script mode (which won't prompt the user for
input) against these prerequisites.  It also will install startup/shutdown
scripts for CLIRA.

It may be necessary to update the prerequisites for Cygwin due to security
updates.  If so, we use the standard Cygwin repository for pulling our
prerequisites from, as well as Cygwin Ports
(https://sourceware.org/cygwinports/) for the PHP prerequisite.


