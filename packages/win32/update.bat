@echo off
cd %0\..
set PATH=..\usr\bin;..\usr\lib;%PATH%
start "" gcstar.exe -u -n
