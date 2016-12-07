echo off
chcp 65001

:start

rem del ebin /*.beam
erl -s make all -s c q -pa ebin_sys/ -pa ebin/

:loop
set /p choice= Compile Done, Continue? (Y/N)

if %choice%==Y goto start
if %choice%==y goto start
if %choice%==N goto end
if %choice%==n goto end

goto loop

:end