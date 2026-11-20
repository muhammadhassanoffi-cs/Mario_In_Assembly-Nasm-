@echo off
nasm src\mario.asm -i src\ -o mario.com
if errorlevel 1 goto fail
mario.com
goto end
:fail
echo BUILD FAILED
:end