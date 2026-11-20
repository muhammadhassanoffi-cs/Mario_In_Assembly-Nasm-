
bits 16
org 100h

start:
    mov ax, 0013h       ; graphics mode on
    int 10h

    mov ah, 00h         ; wait for a key
    int 16h

    mov ax, 0003h       ; text mode back
    int 10h

    mov ah, 4Ch         ; exit to DOS
    int 21h
