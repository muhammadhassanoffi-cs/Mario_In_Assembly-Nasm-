;==============================================================
; Project  : Super Mario Engine (EL2003 COAL Semester Project)
; Group    : (group number), Section (section)
; Members  : (names and roll numbers)
; Module   : 1 Skeleton, 2 Drawing, 5 Frame buffer, 4 Sprites
; Date     : 20-11-2026
; Tools    : NASM, DOSBox 0.74-3
;
; Files    : mario.asm   main program and procedures
;            consts.inc  shared constants (EQU only)
;            sprites.inc sprite artwork (data only)
;
; What this build shows (press a key to go to the next screen):
;   1. colour test        2. demo scene with sprites
;   3. sprite gallery     4. walking animation (any key exits)
;==============================================================

bits 16
org 100h

jmp start                       ; skip over data and procedures

%include "consts.inc"


;==============================================================
; MACRO DRAWSPR x, y, address, flags
; Pushes the four DrawSprite parameters in order and calls it.
; Just a shortcut so scenes stay readable.
;==============================================================

%macro DRAWSPR 4
    push word %1                ; x
    push word %2                ; y
    push word %3                ; sprite address
    push word %4                ; flags
    call DrawSprite
%endmacro


; ---------------------------------------------------------
; DATA AREA
; ---------------------------------------------------------

frame_seg   dw 0                ; segment of the off-screen frame buffer
frame_count dw 0                ; frames drawn so far (used for blinking)
anim_x      dw 0                ; x of the walking Mario (signed)

msg_nomem db 'Not enough memory for frame buffer.$'

; Game colours for slots 16..33, three bytes each: red, green, blue.
; Each value is 0..63 (6-bit VGA DAC). Order must match COL_ constants.

palette_data:
    db 23,37,63     ; 16 sky
    db  0,42, 0     ; 17 grass
    db 50,19, 3     ; 18 dirt / brick
    db 25, 8, 0     ; 19 brick dark
    db 50,37,20     ; 20 tan
    db 54,10, 0     ; 21 Mario red
    db 63,38,14     ; 22 skin
    db 63,47, 0     ; 23 coin yellow
    db 32,52, 4     ; 24 pipe green
    db  0,30, 0     ; 25 pipe dark
    db 38,20, 0     ; 26 Goomba brown
    db 10,20,60     ; 27 overall blue
    db 63,63,63     ; 28 white
    db  4, 3, 3     ; 29 dark outline
    db 30,14, 0     ; 30 brown (hair, shoes)
    db  0,50,10     ; 31 Koopa green
    db  0,30, 5     ; 32 Koopa dark green
    db 50,32, 0     ; 33 coin gold

; Demo scene: one record per rectangle, 5 words each:
; x, y, width, height, colour.  Drawn in this order (later covers earlier).

scene_rects:
    dw   0,   0, 320, 16, COL_BLACK     ; HUD strip
    dw   0, 160, 320,  4, COL_GRASS     ; grass
    dw   0, 164, 320, 28, COL_DIRT      ; dirt
    dw   0, 192, 320,  8, COL_BLACK     ; bottom border
    dw  96, 112,  16, 16, COL_BRICKD    ; brick 1 outline
    dw  97, 113,  14, 14, COL_DIRT      ; brick 1 face
    dw 112, 112,  16, 16, COL_BRICKD    ; brick 2 outline
    dw 113, 113,  14, 14, COL_DIRT      ; brick 2 face
    dw 128, 112,  16, 16, COL_BRICKD    ; brick 3 outline
    dw 129, 113,  14, 14, COL_DIRT      ; brick 3 face
    dw 200, 140,  32, 20, COL_PIPED     ; pipe body outline
    dw 202, 140,  28, 20, COL_PIPE      ; pipe body
    dw 196, 128,  40, 12, COL_PIPED     ; pipe top outline
    dw 198, 130,  36,  8, COL_PIPE      ; pipe top
scene_end:

SCENE_COUNT equ (scene_end - scene_rects) / 10     ; 10 bytes per record

%include "sprites.inc"


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
    mov ax, VIDEO_MODE_GRAPHICS
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
    mov ax, VIDEO_MODE_TEXT
    int 10h
    pop ax
    ret


;==============================================
; Name     : SetPalette
; Purpose  : load palette_data into VGA colour slots
;            PAL_FIRST .. PAL_FIRST+PAL_COUNT-1
; Inputs   : none (uses palette_data, PAL_FIRST, PAL_COUNT)
; Outputs  : none (colours are active on screen)
; Changes  : none (all registers preserved)
; Note     : call AFTER SetVideoMode (a mode change resets
;            the palette)
;==============================================

SetPalette:
    push ax
    push cx
    push dx
    push si

    mov dx, 3C8h                ; DAC write-index port
    mov al, PAL_FIRST           ; first slot to write
    out dx, al

    inc dx                      ; DX = 3C9h, DAC data port
    mov si, palette_data        ; DS:SI -> table of R,G,B bytes
    mov cx, PAL_COUNT * 3       ; 3 bytes per colour
    cld
    rep outsb                   ; stream every byte to the port

    pop si
    pop dx
    pop cx
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


;==============================================
; Name     : WaitKey
; Purpose  : wait until a key is pressed (BIOS INT 16h)
;            temporary; Module 7 replaces keyboard handling
; Inputs   : none
; Outputs  : none
; Changes  : none (all registers preserved)
;==============================================

WaitKey:
    push ax
    mov ah, 00h
    int 16h
    pop ax
    ret


;==============================================
; Name     : DrawSprite
; Purpose  : draw a sprite into the frame buffer.
;            - colour 0 is transparent (never drawn)
;            - FLAG_MIRROR flips it left-right
;            - FLAG_BLINK draws it only on even frames
;            - clips on all four screen edges, so a sprite
;              half off the screen never writes outside it
;            Sprite format: db width, height, then the pixel
;            rows (width*height colour bytes, top row first).
; Inputs   : (stack, pushed in this order)
;            x       : left edge, signed word
;            y       : top edge, signed word
;            address : offset of the sprite data
;            flags   : FLAG_MIRROR / FLAG_BLINK bits
; Outputs  : none
; Changes  : none (all registers preserved),
;            procedure removes its 4 parameters (ret 8)
;==============================================

SPR_W       equ -16             ; local: sprite width  [bp-16]
SPR_H       equ -18             ; local: sprite height [bp-18]

DrawSprite:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    sub sp, 4                   ; room for the two locals

    ; blink: skip drawing on odd frames

    test word [bp+4], FLAG_BLINK
    jz .visible
    test word [frame_count], 1
    jnz .done

.visible:
    mov si, [bp+6]              ; SI -> sprite header
    xor ax, ax
    mov al, [si]                ; AL = width
    mov [bp+SPR_W], ax
    mov al, [si+1]              ; AL = height
    mov [bp+SPR_H], ax
    add si, 2                   ; SI -> first pixel row

    mov ax, [frame_seg]
    mov es, ax

    xor dx, dx                  ; DX = row counter

.row_loop:
    cmp dx, [bp+SPR_H]
    jae .done

    mov bx, [bp+8]              ; BX = y
    add bx, dx                  ; BX = screen y of this row
    cmp bx, SCREEN_HEIGHT       ; unsigned: also rejects negative y
    jae .next_row

    mov di, bx                  ; DI = screen y * 320
    shl di, 8
    shl bx, 6
    add di, bx

    xor cx, cx                  ; CX = column counter

.col_loop:
    cmp cx, [bp+SPR_W]
    jae .next_row

    mov bx, cx                  ; BX = source column
    test word [bp+4], FLAG_MIRROR
    jz .read_pixel
    mov bx, [bp+SPR_W]          ; mirrored: source column =
    dec bx                      ;   width - 1 - column
    sub bx, cx

.read_pixel:
    mov al, [bx+si]             ; AL = pixel of this row
    test al, al
    jz .next_pixel              ; colour 0 = transparent

    mov bx, [bp+10]             ; BX = x
    add bx, cx                  ; BX = screen x of this pixel
    cmp bx, SCREEN_WIDTH        ; unsigned: also rejects negative x
    jae .next_pixel

    mov [es:bx+di], al          ; write pixel

.next_pixel:
    inc cx
    jmp .col_loop

.next_row:
    add si, [bp+SPR_W]          ; SI -> next source row
    inc dx
    jmp .row_loop

.done:
    lea sp, [bp-14]             ; drop the locals
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8


;==============================================
; Name     : DrawColorTest
; Purpose  : draw one box per game colour so every colour can
;            be checked by eye (Module 2 test screen)
; Inputs   : none
; Outputs  : none (boxes are drawn into the frame buffer)
; Changes  : none (all registers preserved)
;==============================================

DrawColorTest:
    push ax
    push bx
    push cx

    push word COL_BLACK
    call ClearFrame

    xor cx, cx                  ; CX = colour number i (0..PAL_COUNT-1)

.box_loop:
    mov ax, cx
    shl ax, 4                   ; x = i * 16
    push ax                     ; x
    push word 80                ; y
    push word 16                ; width
    push word 40                ; height
    mov bx, cx
    add bx, PAL_FIRST
    push bx                     ; colour = PAL_FIRST + i
    call FillRect

    inc cx
    cmp cx, PAL_COUNT
    jb .box_loop

    pop cx
    pop bx
    pop ax
    ret


;==============================================
; Name     : DrawScene
; Purpose  : draw the demo background: sky, HUD strip, ground,
;            bricks and pipe (from the scene_rects table)
; Inputs   : none
; Outputs  : none (scene is drawn into the frame buffer)
; Changes  : none (all registers preserved)
;==============================================

DrawScene:
    push cx
    push si

    push word COL_SKY
    call ClearFrame

    mov si, scene_rects
    mov cx, SCENE_COUNT

.rect_loop:
    push word [si]              ; x
    push word [si+2]            ; y
    push word [si+4]            ; width
    push word [si+6]            ; height
    push word [si+8]            ; colour
    call FillRect
    add si, 10                  ; next record
    loop .rect_loop

    pop si
    pop cx
    ret


;==============================================
; Name     : DrawProps
; Purpose  : draw the non-hero things of the demo scene:
;            coins, mushroom, Koopa and shell
; Inputs   : none
; Outputs  : none (drawn into the frame buffer)
; Changes  : none (all registers preserved)
;==============================================

DrawProps:
    DRAWSPR 150,  84, spr_coin,     0
    DRAWSPR 166,  84, spr_coin,     0
    DRAWSPR 182,  84, spr_coin,     0
    DRAWSPR 112,  96, spr_mushroom, 0
    DRAWSPR 250, 144, spr_koopa,    FLAG_MIRROR     ; faces left
    DRAWSPR 284, 144, spr_shell,    0
    ret


;==============================================
; Name     : DrawDemoScene
; Purpose  : the demo scene with sprites: background, props,
;            Mario, Goomba and Super Mario standing
; Inputs   : none
; Outputs  : none (drawn into the frame buffer)
; Changes  : none (all registers preserved)
;==============================================

DrawDemoScene:
    call DrawScene
    call DrawProps
    DRAWSPR  32, 144, spr_mario_stand, 0
    DRAWSPR 160, 144, spr_goomba,      0
    DRAWSPR  60, 128, spr_super_stand, 0
    ret


;==============================================
; Name     : DrawGallery
; Purpose  : show every sprite, normal and mirrored, plus
;            clipping tests half off every screen edge and
;            a blinking sprite
; Inputs   : none
; Outputs  : none (drawn into the frame buffer)
; Changes  : none (all registers preserved)
;==============================================

DrawGallery:
    push word COL_SKY
    call ClearFrame

    ; row 1: all small sprites, normal

    DRAWSPR   8,  24, spr_mario_stand, 0
    DRAWSPR  34,  24, spr_mario_run,   0
    DRAWSPR  60,  24, spr_mario_jump,  0
    DRAWSPR  86,  24, spr_goomba,      0
    DRAWSPR 112,  24, spr_goomba_flat, 0
    DRAWSPR 138,  24, spr_koopa,       0
    DRAWSPR 164,  24, spr_shell,       0
    DRAWSPR 190,  24, spr_mushroom,    0
    DRAWSPR 216,  24, spr_coin,        0

    ; row 2: the same sprites, mirrored

    DRAWSPR   8,  56, spr_mario_stand, FLAG_MIRROR
    DRAWSPR  34,  56, spr_mario_run,   FLAG_MIRROR
    DRAWSPR  60,  56, spr_mario_jump,  FLAG_MIRROR
    DRAWSPR  86,  56, spr_goomba,      FLAG_MIRROR
    DRAWSPR 112,  56, spr_goomba_flat, FLAG_MIRROR
    DRAWSPR 138,  56, spr_koopa,       FLAG_MIRROR
    DRAWSPR 164,  56, spr_shell,       FLAG_MIRROR
    DRAWSPR 190,  56, spr_mushroom,    FLAG_MIRROR
    DRAWSPR 216,  56, spr_coin,        FLAG_MIRROR

    ; row 3: Super Mario (16x32), normal then mirrored

    DRAWSPR   8,  96, spr_super_stand, 0
    DRAWSPR  40,  96, spr_super_run,   0
    DRAWSPR  72,  96, spr_super_jump,  0
    DRAWSPR 120,  96, spr_super_stand, FLAG_MIRROR
    DRAWSPR 152,  96, spr_super_run,   FLAG_MIRROR
    DRAWSPR 184,  96, spr_super_jump,  FLAG_MIRROR

    ; blinking Super Mario (this screen is static, so it shows
    ; either frame; the animation screen shows it blinking)

    DRAWSPR 240,  96, spr_super_stand, FLAG_BLINK

    ; clipping tests: half off the left, right, top, bottom
    ; edges and two corners

    DRAWSPR  -8, 150, spr_mario_stand, 0
    DRAWSPR 312, 150, spr_mario_stand, 0
    DRAWSPR 100,  -8, spr_mario_run,   0
    DRAWSPR 200, 192, spr_mario_jump,  0
    DRAWSPR  -8,  -8, spr_goomba,      0
    DRAWSPR 312, 192, spr_goomba,      0
    ret


;==============================================
; Name     : RunAnimation
; Purpose  : live demo loop: Mario walks right (stand/run
;            frames, clipped as he enters and leaves the
;            screen), a Goomba walks left flipping its feet,
;            Super Mario blinks. Runs until a key is pressed.
; Inputs   : none
; Outputs  : none
; Changes  : none (all registers preserved)
;==============================================

RunAnimation:
    push ax
    push bx

    mov word [anim_x], -16
    mov word [frame_count], 0

.frame:
    call DrawScene
    call DrawProps

    DRAWSPR 60, 128, spr_super_stand, FLAG_BLINK    ; blinking Super Mario

    ; walking Mario: swap stand/run every 4 frames

    mov bx, spr_mario_stand
    test word [frame_count], 4
    jz .mario_pose
    mov bx, spr_mario_run

.mario_pose:
    push word [anim_x]
    push word 144
    push bx
    push word 0
    call DrawSprite

    ; Goomba walking left: flip every 8 frames to fake the steps

    mov ax, 304
    sub ax, [anim_x]            ; x moves left as Mario moves right
    xor bx, bx                  ; flags = 0
    test word [frame_count], 8
    jz .goomba_pose
    mov bx, FLAG_MIRROR

.goomba_pose:
    push ax
    push word 144
    push word spr_goomba
    push bx
    call DrawSprite

    call WaitVRetrace
    call PresentFrame

    inc word [frame_count]
    add word [anim_x], 2
    cmp word [anim_x], 320      ; signed compare
    jl .no_wrap
    mov word [anim_x], -16      ; wrap: enter again from the left

.no_wrap:
    mov ah, 01h                 ; key waiting? (ZF = 1 if none)
    int 16h
    jz .frame

    mov ah, 00h                 ; remove the key from the buffer
    int 16h

    pop bx
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
    call SetPalette             ; must come after the mode switch

    ; screen 1: colour test

    call DrawColorTest
    call PresentFrame
    call WaitKey

    ; screen 2: demo scene with sprites

    call DrawDemoScene
    call PresentFrame
    call WaitKey

    ; screen 3: sprite gallery (normal, mirrored, clipped)

    call DrawGallery
    call PresentFrame
    call WaitKey

    ; screen 4: walking animation, any key exits

    call RunAnimation

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