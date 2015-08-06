# Building Clira Windows Installer (Cygwin)

This document will cover instructions on how to build the Clira Windows
installer for Cygwin as well as how to update the libslax, lighttpd-for-juise,
and juise packages for Cygwin.

---

## Building Clira Windows Installer

* Install INNO Setup from http://www.jrsoftware.org/isdl.php
* Check out the 'clira-windows-installer' github repository to your Windows
  machine
* Rename (or copy) the 'clira-windows-installer' directory to C:\CLIRABASE  (If
  you wish to change this directory, you will need to modify the `clira.iss`
  file.
* Double click the `clira.iss` file to launch INNO Setup with it.  If you need
  to change the version of the output setup.exe file, modify `clira.iss` and
  make sure you commit it.
* Choose Build and it will output the setup file to
  `C:\CLIRABASE\Output\setup.exe`

---

## Compiling and Updating libslax, lighttpd-for-juise, juise for Cygwin

* Download Cygwin installer (32 bit) from http://www.cygwin.com/install.html
* Install Cygwin and make sure you have the following packages installed as
  well:

    autoconf  
    automake  
    bison  
    cvs  
    gcc-core  
    git  
    libbz2-devel  
    libcurl-devel  
    libpcre-devel  
    libsqlite3-devel  
    libssh2-devel  
    libtool  
    libuuid-devel  
    libxml2-devel  
    libxslt-devel  
    make  
    openssh  
    openssl-devel  
    patch  
    pkg-config  
    vim  
    wget  

* Alternatively you can simply run the installer with the command line
  parameters (modify paths appropriately):


```
C:\cygwin32>setup-x86.exe -a x86 -P autoconf,automake,bison,cvs,gcc-core,git,libbz2-devel,libcurl-devel,libpcre-devel,libsqlite3-devel,libssh2-devel,libtool,libuuid-devel,libxml2-devel,make,libxslt-devel,openssh,openssl-devel,patch,pkg-config,vim,wget -q -n -R c:\cygwin32
```

---


### libslax

* Checkout libslax from https://github.com/Juniper/libslax.git

```
cd libslax
autoreconf -f -i
cd packaging/cygwin
./cygwin.sh
```

At this point you have a cygwin libslax bundle built.  If you are fully
building CLIRA then you will need to:

```
cd ../..
./configure
make install
```

You need to install libslax in the local cygwin install because juise requires
it.

### lighttpd-for-juise

* Checkout lighttpd-for-juise from https://github.com/Juniper/lighttpd-for-juise.git

```
cd lighttpd-for-juise
./autogen.sh
cd packaging/cygwin
./cygwin.sh
```

At this point you will have a lighttpd-for-juise cygwin bundle built.  If you
are fully building CLIRA then you will need to:

```
cd ../..
./configure --with-websocket=ALL --without-libicu
make
```

You need the object files for lighttpd-for-juise built for the following juise
build.

### juise

* Checkout juise from https://github.com/Juniper/juise.git

```
cd juise
autoreconf -f -i
cd packaging/cygwin
./cygwin.sh <path-to-lighttpd-from-previous-step>
```

---

### Updating the `clira-windows-installer` bundle with updated libslax/lighttpd-for-juise/juise packages.

In order to update the 3 packages we maintain, simply copy them to their
respective directories in the `clira-windows-installer` repo.  Eg:
`cygwin/local/x86/release/lighttpd-for-juise` or
`cygwin/local/x86/release/juise`.

After you have done this, you will need to update their entries in
`cygwin/local/x86/setup.ini`.

You do this by going into your cygwin shell and run the `bin/genini` script:  

```
cd clira-windows-installer/cygwin/local
../../bin/genini --recursive --arch x86 * > setup.ini.updated
```

At this point, the proper setup.ini entries will be captured in the
setup.ini.updated file.  You will need to manually go into the
`clira-windows-installer/cygwin/local/x86/setup.ini` file and replace the
entries for juise/libslax/lighttpd-for-juise with the new entries.
