
%include "consts.inc"

SetVideoMode:  ; to set to video mode 

push ax
mov ax, 0013h
int 10h
pop ax
ret 


RestoreTextMode:
push ax 
mov ax , 0003h
int 10h
pop ax

ret

