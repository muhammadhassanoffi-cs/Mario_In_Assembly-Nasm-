;==============================================================
; Project  : Super Mario Engine (EL2003 COAL Semester Project)
; Group    : (group number), Section (section)
; Members  : (names and roll numbers)
; Module   : 1 Skeleton, 2 Drawing, 5 Frame buffer
; Date     : 20-11-2026
; Tools    : NASM, DOSBox 0.74-3
;==============================================================

bits 16
org 100h

jmp start                       ; skip over data and procedures

%include "consts.inc"

; ---------------------------------------------------------
; DATA AREA
; ---------------------------------------------------------

frame_seg dw 0
test_x    dw 0

msg_nomem db 'Not enough memory for frame buffer.$'


;==============================================
; Name     : AllocFrameBuffer
; Purpose  : reserve 64000 bytes in a second segment
;            (shrink our block with INT 21h/4Ah, then
;            allocate with INT 21h/48h)
; Inputs   : none
; Outputs  : [frame_seg] = segment of the buffer
;            CF = 0 success, CF = 1 failure
; Changes  : flags only (all registers preserved)
;==============================================

AllocFrameBuffer:
    push ax
    push bx
    push es

    mov ax, cs
    mov es, ax
    mov bx, 1000h
    mov ah, 4Ah
    int 21h
    jc .fail

    mov bx, FRAME_PARAS
    mov ah, 48h
    int 21h
    jc .fail

    mov [frame_seg], ax
    clc
    jmp .out

.fail:
    stc

.out:
    pop es
    pop bx
    pop ax
    ret


;==============================================
; Name     : SetVideoMode
; Purpose  : switch to VGA Mode 13h (320x200, 256 colours)
; Inputs   : none
; Outputs  : none (screen is in graphics mode)
; Changes  : none (all registers preserved)
;==============================================

SetVideoMode:
    push ax
    mov ax, 0013h
    int 10h
    pop ax
    ret


;==============================================
; Name     : RestoreTextMode
; Purpose  : switch back to 80x25 text mode (call before exit)
; Inputs   : none
; Outputs  : none (screen is in text mode)
; Changes  : none (all registers preserved)
;==============================================

RestoreTextMode:
    push ax
    mov ax, 0003h
    int 10h
    pop ax
    ret


;==============================================
; Name     : PutPixel
; Purpose  : draw one pixel in the frame buffer;
;            pixels outside the screen are ignored
; Inputs   : (stack, pushed in this order)
;            x, y, colour
; Outputs  : none
; Changes  : none (all registers preserved),
;            procedure removes its 3 parameters (ret 6)
;==============================================

PutPixel:
    push bp
    mov bp, sp
    push ax
    push bx
    push di
    push es

    cmp word [bp+8], SCREEN_WIDTH
    jae .done

    cmp word [bp+6], SCREEN_HEIGHT
    jae .done

    mov ax, [frame_seg]
    mov es, ax

    mov bx, [bp+6]
    mov di, bx
    shl di, 8
    shl bx, 6
    add di, bx
    add di, [bp+8]

    mov al, [bp+4]
    mov [es:di], al

.done:
    pop es
    pop di
    pop bx
    pop ax
    pop bp
    ret 6


;==============================================
; Name     : FillRect
; Purpose  : draw a filled rectangle in the frame buffer;
;            the part outside the screen is clipped
; Inputs   : (stack, pushed in this order)
;            x, y, width, height, colour
; Outputs  : none
; Changes  : none (all registers preserved),
;            procedure removes its 5 parameters (ret 10)
;==============================================

FillRect:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push di
    push es

    mov ax, [bp+12]             ; AX = x
    cmp ax, SCREEN_WIDTH
    jae .done

    mov bx, [bp+10]             ; BX = y
    cmp bx, SCREEN_HEIGHT
    jae .done

    ; clip width

    mov cx, [bp+8]              ; CX = width
    mov dx, ax
    add dx, cx
    cmp dx, SCREEN_WIDTH
    jbe .width_ok

    mov cx, SCREEN_WIDTH
    sub cx, ax

.width_ok:

    ; clip height

    mov dx, [bp+6]              ; DX = height
    mov di, bx
    add di, dx
    cmp di, SCREEN_HEIGHT
    jbe .height_ok

    mov dx, SCREEN_HEIGHT
    sub dx, bx

.height_ok:

    ; calculate starting address

    mov di, bx
    shl di, 8
    shl bx, 6
    add di, bx
    add di, ax

    mov bx, cx                  ; BX = width

    mov ax, [frame_seg]
    mov es, ax

    mov al, [bp+4]              ; AL = colour
    cld

.row_loop:
    test dx, dx
    jz .done

    mov cx, bx
    push di
    rep stosb
    pop di

    add di, SCREEN_WIDTH
    dec dx
    jmp .row_loop

.done:
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 10


;==============================================
; Name     : ClearFrame
; Purpose  : fill the whole frame buffer with one colour
;            (REP STOSW, 32000 words)
; Inputs   : (stack) colour
; Outputs  : none
; Changes  : none (all registers preserved),
;            procedure removes its parameter (ret 2)
;==============================================

ClearFrame:
    push bp
    mov bp, sp
    push ax
    push cx
    push di
    push es

    mov ax, [frame_seg]
    mov es, ax

    xor di, di

    mov al, [bp+4]
    mov ah, al

    mov cx, FRAME_WORDS
    cld
    rep stosw

    pop es
    pop di
    pop cx
    pop ax
    pop bp
    ret 2


;==============================================
; Name     : PresentFrame
; Purpose  : copy the frame buffer to video memory
;            (REP MOVSW, 32000 words)
; Inputs   : none
; Outputs  : none (frame is visible on screen)
; Changes  : none (all registers preserved)
;==============================================

PresentFrame:
    push ax
    push cx
    push si
    push di
    push ds
    push es

    mov ax, [frame_seg]
    mov ds, ax

    mov ax, VIDEO_SEGMENT
    mov es, ax

    xor si, si
    xor di, di

    mov cx, FRAME_WORDS
    cld
    rep movsw

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret


;==============================================
; Name     : WaitVRetrace
; Purpose  : wait for the next vertical retrace
;            (temporary test timing; the final game uses
;            the timer interrupt)
; Inputs   : none
; Outputs  : none
; Changes  : none (all registers preserved)
;==============================================

WaitVRetrace:
    push ax
    push dx

    mov dx, 3DAh

.wait_end:
    in al, dx
    test al, 8
    jnz .wait_end

.wait_start:
    in al, dx
    test al, 8
    jz .wait_start

    pop dx
    pop ax
    ret


; ---------------------------------------------------------
; MAIN PROGRAM
; ---------------------------------------------------------

start:

    ; allocate frame buffer before graphics mode

    call AllocFrameBuffer
    jc .no_memory

    call SetVideoMode

    mov word [test_x], 0


.frame_loop:

    ; clear screen with blue colour

    push word 1
    call ClearFrame

    ; draw moving red square

    push word [test_x]
    push word 100
    push word 16
    push word 16
    push word 4
    call FillRect

    ; wait for screen refresh

    call WaitVRetrace

    ; show frame buffer on screen

    call PresentFrame

    ; move square to the right

    inc word [test_x]

    cmp word [test_x], 300
    jb .frame_loop


    ; wait for keyboard input

    mov ah, 00h
    int 16h

    call RestoreTextMode

    mov ax, 4C00h
    int 21h


; ---------------------------------------------------------
; MEMORY ERROR
; ---------------------------------------------------------

.no_memory:

    mov dx, msg_nomem
    mov ah, 09h
    int 21h

    mov ax, 4C01h
    int 21h