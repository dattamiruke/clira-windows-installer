@echo off
chdir "$APPDIR$\cygwin\bin"
bash --login -c "/usr/bin/bash /usr/local/etc/lighttpd-wrapper.sh stop