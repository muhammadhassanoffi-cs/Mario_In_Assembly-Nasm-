;==============================================================
; consts.inc : shared constants for the whole team
; Rule       : constants only (EQU), no code and no data bytes
;==============================================================

; ---------- Screen and video ----------
SCREEN_WIDTH        equ 320
SCREEN_HEIGHT       equ 200

VIDEO_SEGMENT       equ 0A000h

VIDEO_MODE_GRAPHICS equ 0013h
VIDEO_MODE_TEXT     equ 0003h

FRAME_PARAS         equ 0FA0h   ; 64000 bytes / 16 = 4000 paragraphs
FRAME_WORDS         equ 32000   ; 64000 bytes / 2

; ---------- Tiles ----------
TILE_SIZE           equ 16
HUD_HEIGHT          equ 16

; ---------- Palette ----------
PAL_FIRST           equ 16      ; first colour slot we redefine
PAL_COUNT           equ 18      ; number of colours in palette_data

COL_BLACK           equ 0       ; slot 0 stays black = transparent for sprites
COL_SKY             equ 16
COL_GRASS           equ 17
COL_DIRT            equ 18
COL_BRICKD          equ 19
COL_TAN             equ 20
COL_RED             equ 21
COL_SKIN            equ 22
COL_YELLOW          equ 23
COL_PIPE            equ 24
COL_PIPED           equ 25
COL_GOOMBA          equ 26
COL_BLUE            equ 27
COL_WHITE           equ 28
COL_DARK            equ 29      ; near-black (real black is transparent)
COL_BROWN           equ 30      ; Mario hair and shoes
COL_GREEN           equ 31      ; Koopa shell
COL_GREEND          equ 32      ; Koopa shell dark
COL_GOLD            equ 33      ; coin outline

; ---------- DrawSprite flags ----------
FLAG_MIRROR         equ 1       ; bit 0: flip left-right (facing left)
FLAG_BLINK          equ 2       ; bit 1: draw only on even frames

; ---------- Scan codes (Appendix A.3) ----------
KEY_LEFT            equ 4Bh
KEY_RIGHT           equ 4Dh
KEY_UP              equ 48h
KEY_DOWN            equ 50h
KEY_SPACE           equ 39h
KEY_SHIFT           equ 2Ah
KEY_P               equ 19h
KEY_ENTER           equ 1Ch
KEY_ESC             equ 01h

; ---------- Game limits (Appendix A.4) ----------
START_LIVES         equ 3
MAX_LIVES           equ 99
LEVEL_TIME          equ 300
MAX_ENEMIES         equ 8
