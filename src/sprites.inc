;==============================================================
; sprites.inc : sprite artwork (Module 4)
;
; Sprite format (used by DrawSprite):
;     db width, height
;     then width*height colour bytes, row by row, top row first
; Colour 0 is transparent and is never drawn.
;
; Each pixel is written as one letter so the picture can be seen
; right in the source. Each letter is a colour slot (EQU below).
;==============================================================

_   equ 0                ; transparent (not drawn)
R   equ COL_RED          ; Mario red (cap, shirt, mushroom cap)
S   equ COL_SKIN         ; skin
B   equ COL_BLUE         ; overalls blue
N   equ COL_BROWN        ; hair, shoes
D   equ COL_DARK         ; dark outline, eyes, Goomba feet
W   equ COL_WHITE        ; white
Y   equ COL_YELLOW       ; coin yellow, Koopa skin
O   equ COL_GOLD         ; coin outline
G   equ COL_GREEN        ; Koopa shell green
H   equ COL_GREEND       ; Koopa shell dark green
M   equ COL_GOOMBA       ; Goomba body brown
T   equ COL_TAN          ; tan (Goomba face/feet, mushroom stem)


; ---- Small Mario standing ----
spr_mario_stand:
    db 16, 16
    db _,_,_,_,R,R,R,R,R,_,_,_,_,_,_,_
    db _,_,_,R,R,R,R,R,R,R,R,R,_,_,_,_
    db _,_,_,N,N,N,S,S,N,S,_,_,_,_,_,_
    db _,_,N,S,N,S,S,S,N,S,S,S,_,_,_,_
    db _,_,N,S,N,N,S,S,S,N,S,S,S,_,_,_
    db _,_,N,N,S,S,S,S,N,N,N,N,_,_,_,_
    db _,_,_,_,S,S,S,S,S,S,S,_,_,_,_,_
    db _,_,_,R,R,B,R,R,R,R,_,_,_,_,_,_
    db _,_,R,R,R,B,R,R,B,R,R,R,_,_,_,_
    db _,R,R,R,R,B,B,B,B,R,R,R,R,_,_,_
    db _,S,S,R,B,S,B,B,S,B,R,S,S,_,_,_
    db _,S,S,S,B,B,B,B,B,B,S,S,S,_,_,_
    db _,S,S,B,B,B,B,B,B,B,B,S,S,_,_,_
    db _,_,_,B,B,B,_,_,B,B,B,_,_,_,_,_
    db _,_,N,N,N,_,_,_,_,N,N,N,_,_,_,_
    db _,N,N,N,N,_,_,_,_,N,N,N,N,_,_,_

; ---- Small Mario running ----
spr_mario_run:
    db 16, 16
    db _,_,_,_,R,R,R,R,R,_,_,_,_,_,_,_
    db _,_,_,R,R,R,R,R,R,R,R,R,_,_,_,_
    db _,_,_,N,N,N,S,S,N,S,_,_,_,_,_,_
    db _,_,N,S,N,S,S,S,N,S,S,S,_,_,_,_
    db _,_,N,S,N,N,S,S,S,N,S,S,S,_,_,_
    db _,_,N,N,S,S,S,S,N,N,N,N,_,_,_,_
    db _,_,_,_,S,S,S,S,S,S,S,_,_,_,_,_
    db _,_,R,R,R,R,B,R,R,R,R,_,_,_,_,_
    db _,R,R,R,R,R,R,B,B,R,R,R,_,_,_,_
    db S,S,R,R,R,B,B,B,B,B,B,_,_,_,_,_
    db S,S,S,B,B,B,B,B,B,B,B,_,_,_,_,_
    db _,S,B,B,B,B,B,B,B,B,B,_,_,_,_,_
    db _,_,B,B,B,B,B,B,B,B,_,_,_,_,_,_
    db _,N,N,B,B,B,_,_,N,N,_,_,_,_,_,_
    db N,N,N,N,_,_,_,_,_,N,N,N,_,_,_,_
    db N,N,N,_,_,_,_,_,_,_,N,N,_,_,_,_

; ---- Small Mario jumping ----
spr_mario_jump:
    db 16, 16
    db _,_,_,_,_,_,_,_,_,_,_,_,S,S,S,_
    db _,_,_,_,R,R,R,R,R,_,_,R,R,S,S,_
    db _,_,_,R,R,R,R,R,R,R,R,R,R,R,S,_
    db _,_,_,N,N,N,S,S,N,S,R,R,R,_,_,_
    db _,_,N,S,N,S,S,S,N,S,S,R,R,_,_,_
    db _,_,N,S,N,N,S,S,S,N,S,S,S,_,_,_
    db _,_,N,N,S,S,S,S,N,N,N,N,_,_,_,_
    db _,_,_,_,S,S,S,S,S,S,S,_,_,_,_,_
    db _,_,R,R,R,B,R,R,R,B,R,R,_,_,_,_
    db _,R,R,R,R,B,B,B,B,B,R,R,R,R,_,_
    db S,S,R,R,B,B,B,B,B,B,B,R,S,S,_,_
    db S,S,S,_,B,B,B,B,B,B,B,_,S,S,S,_
    db _,_,_,_,B,B,B,B,B,B,B,_,_,_,_,_
    db _,_,_,N,N,B,B,_,_,B,B,N,N,_,_,_
    db _,_,N,N,N,N,_,_,_,_,N,N,N,N,_,_
    db _,_,N,N,N,_,_,_,_,_,_,N,N,N,_,_

; ---- Goomba walking ----
spr_goomba:
    db 16, 16
    db _,_,_,_,_,_,M,M,M,M,_,_,_,_,_,_
    db _,_,_,_,M,M,M,M,M,M,M,M,_,_,_,_
    db _,_,_,M,M,M,M,M,M,M,M,M,M,_,_,_
    db _,_,M,M,W,W,M,M,M,M,W,W,M,M,_,_
    db _,M,M,M,W,D,M,M,M,M,D,W,M,M,M,_
    db _,M,M,M,W,D,M,M,M,M,D,W,M,M,M,_
    db _,M,M,M,M,M,M,M,M,M,M,M,M,M,M,_
    db _,M,M,M,M,M,M,M,M,M,M,M,M,M,M,_
    db _,_,M,M,M,M,M,M,M,M,M,M,M,M,_,_
    db _,_,_,M,M,M,T,T,T,T,M,M,M,_,_,_
    db _,_,_,_,T,T,T,T,T,T,T,T,_,_,_,_
    db _,_,_,_,T,T,T,T,T,T,T,T,_,_,_,_
    db _,_,_,T,T,T,T,T,T,T,T,T,T,_,_,_
    db _,_,D,D,D,D,_,_,_,_,D,D,D,D,_,_
    db _,D,D,D,D,D,_,_,_,_,D,D,D,D,D,_
    db _,D,D,D,D,_,_,_,_,_,_,D,D,D,D,_

; ---- Goomba flattened (stomped) ----
spr_goomba_flat:
    db 16, 16
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,M,M,M,M,M,M,M,M,M,M,_,_,_
    db _,_,M,M,W,W,M,M,M,M,W,W,M,M,_,_
    db _,M,M,M,M,M,M,M,M,M,M,M,M,M,M,_
    db _,M,M,M,M,M,M,M,M,M,M,M,M,M,M,_
    db _,_,T,T,T,T,T,T,T,T,T,T,T,T,_,_
    db _,_,_,D,D,D,D,D,D,D,D,D,D,_,_,_

; ---- Koopa Troopa ----
spr_koopa:
    db 16, 16
    db _,_,_,_,_,_,_,_,_,_,Y,Y,Y,Y,_,_
    db _,_,_,_,_,_,_,_,_,Y,Y,Y,Y,Y,Y,_
    db _,_,_,_,_,_,_,_,_,Y,W,D,Y,Y,Y,_
    db _,_,_,_,_,_,_,_,_,Y,Y,Y,Y,Y,Y,_
    db _,_,_,_,H,H,H,H,_,Y,Y,Y,Y,_,_,_
    db _,_,_,H,G,G,G,G,H,Y,Y,Y,Y,_,_,_
    db _,_,H,G,G,W,G,G,G,H,Y,Y,Y,_,_,_
    db _,_,H,G,W,W,G,G,G,G,H,Y,_,_,_,_
    db _,_,H,G,G,W,G,G,G,G,H,Y,_,_,_,_
    db _,_,H,G,G,G,G,G,G,G,H,Y,Y,_,_,_
    db _,_,H,H,H,H,H,H,H,H,H,_,_,_,_,_
    db _,_,_,Y,Y,Y,Y,Y,Y,Y,Y,_,_,_,_,_
    db _,_,_,Y,Y,Y,_,_,Y,Y,Y,_,_,_,_,_
    db _,_,Y,Y,Y,Y,_,_,Y,Y,Y,Y,_,_,_,_
    db _,_,Y,Y,Y,_,_,_,_,Y,Y,Y,_,_,_,_
    db _,_,D,D,D,_,_,_,_,D,D,D,_,_,_,_

; ---- Koopa shell ----
spr_shell:
    db 16, 16
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,H,H,H,H,H,H,H,H,_,_,_,_
    db _,_,_,H,G,G,G,G,G,G,G,G,H,_,_,_
    db _,_,H,G,G,W,G,G,G,G,W,G,G,H,_,_
    db _,_,H,G,W,W,G,G,G,G,W,W,G,H,_,_
    db _,_,H,G,G,W,G,G,G,G,W,G,G,H,_,_
    db _,_,H,G,G,G,G,G,G,G,G,G,G,H,_,_
    db _,_,H,H,H,H,H,H,H,H,H,H,H,H,_,_
    db _,_,_,W,W,W,W,W,W,W,W,W,W,_,_,_
    db _,_,D,W,W,W,W,W,W,W,W,W,W,D,_,_
    db _,_,_,D,D,D,D,D,D,D,D,D,D,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_

; ---- Mushroom power-up ----
spr_mushroom:
    db 16, 16
    db _,_,_,_,_,_,R,R,R,R,_,_,_,_,_,_
    db _,_,_,_,R,R,W,W,W,R,R,R,_,_,_,_
    db _,_,_,R,W,W,W,W,W,R,R,R,R,R,_,_
    db _,_,R,R,W,W,W,W,R,R,R,W,W,R,R,_
    db _,R,R,R,W,W,W,R,R,R,R,W,W,W,R,R
    db _,R,R,R,R,R,R,R,R,R,R,R,R,R,R,R
    db _,R,W,W,R,R,R,R,R,R,R,R,W,W,R,_
    db _,R,W,W,R,R,R,R,R,R,R,R,W,W,R,_
    db _,_,R,R,R,R,R,R,R,R,R,R,R,R,_,_
    db _,_,_,_,T,T,T,T,T,T,T,T,_,_,_,_
    db _,_,_,T,T,D,T,T,T,T,D,T,T,_,_,_
    db _,_,_,T,T,D,T,T,T,T,D,T,T,_,_,_
    db _,_,_,T,T,T,T,T,T,T,T,T,T,_,_,_
    db _,_,_,_,T,T,T,T,T,T,T,T,_,_,_,_
    db _,_,_,_,_,T,T,T,T,T,T,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_

; ---- Coin ----
spr_coin:
    db 16, 16
    db _,_,_,_,_,_,O,O,O,O,_,_,_,_,_,_
    db _,_,_,_,_,O,Y,Y,Y,Y,O,_,_,_,_,_
    db _,_,_,_,_,O,Y,Y,Y,Y,O,_,_,_,_,_
    db _,_,_,_,O,Y,Y,O,O,Y,Y,O,_,_,_,_
    db _,_,_,_,O,Y,Y,O,O,Y,Y,O,_,_,_,_
    db _,_,_,_,O,Y,Y,O,O,Y,Y,O,_,_,_,_
    db _,_,_,_,O,Y,Y,O,O,Y,Y,O,_,_,_,_
    db _,_,_,_,O,Y,Y,O,O,Y,Y,O,_,_,_,_
    db _,_,_,_,O,Y,Y,O,O,Y,Y,O,_,_,_,_
    db _,_,_,_,O,Y,Y,O,O,Y,Y,O,_,_,_,_
    db _,_,_,_,O,Y,Y,O,O,Y,Y,O,_,_,_,_
    db _,_,_,_,_,O,Y,Y,Y,Y,O,_,_,_,_,_
    db _,_,_,_,_,O,Y,Y,Y,Y,O,_,_,_,_,_
    db _,_,_,_,_,_,O,O,O,O,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_

; ---- Super Mario standing (16x32) ----
spr_super_stand:
    db 16, 32
    db _,_,_,_,R,R,R,R,R,_,_,_,_,_,_,_
    db _,_,_,R,R,R,R,R,R,R,R,R,_,_,_,_
    db _,_,_,N,N,N,S,S,N,S,_,_,_,_,_,_
    db _,_,N,S,N,S,S,S,N,S,S,S,_,_,_,_
    db _,_,N,S,N,N,S,S,S,N,S,S,S,_,_,_
    db _,_,N,N,S,S,S,S,N,N,N,N,_,_,_,_
    db _,_,_,_,S,S,S,S,S,S,S,_,_,_,_,_
    db _,_,_,R,R,B,R,R,R,R,_,_,_,_,_,_
    db _,_,R,R,R,B,R,R,B,R,R,R,_,_,_,_
    db _,R,R,R,R,B,B,B,B,R,R,R,R,_,_,_
    db _,S,S,R,B,S,B,B,S,B,R,S,S,_,_,_
    db _,S,S,S,B,B,B,B,B,B,S,S,S,_,_,_
    db _,S,S,B,B,B,B,B,B,B,B,S,S,_,_,_
    db _,S,S,B,B,B,B,B,B,B,B,S,S,_,_,_
    db _,_,S,B,B,B,B,B,B,B,B,S,_,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,_,_,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,_,_,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,_,_,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,_,_,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,_,_,B,B,B,B,_,_,_
    db _,_,_,B,B,B,_,_,_,_,B,B,B,_,_,_
    db _,_,N,N,N,_,_,_,_,_,_,N,N,N,_,_
    db _,N,N,N,N,_,_,_,_,_,_,N,N,N,N,_
    db _,N,N,N,N,_,_,_,_,_,_,N,N,N,N,_

; ---- Super Mario running (16x32) ----
spr_super_run:
    db 16, 32
    db _,_,_,_,R,R,R,R,R,_,_,_,_,_,_,_
    db _,_,_,R,R,R,R,R,R,R,R,R,_,_,_,_
    db _,_,_,N,N,N,S,S,N,S,_,_,_,_,_,_
    db _,_,N,S,N,S,S,S,N,S,S,S,_,_,_,_
    db _,_,N,S,N,N,S,S,S,N,S,S,S,_,_,_
    db _,_,N,N,S,S,S,S,N,N,N,N,_,_,_,_
    db _,_,_,_,S,S,S,S,S,S,S,_,_,_,_,_
    db _,_,_,R,R,B,R,R,R,R,_,_,_,_,_,_
    db _,_,R,R,R,B,R,R,B,R,R,R,_,_,_,_
    db _,R,R,R,R,B,B,B,B,R,R,R,R,_,_,_
    db _,S,S,R,B,S,B,B,S,B,R,S,S,_,_,_
    db _,S,S,S,B,B,B,B,B,B,S,S,S,_,_,_
    db _,S,S,B,B,B,B,B,B,B,B,S,S,_,_,_
    db _,S,S,B,B,B,B,B,B,B,B,S,S,_,_,_
    db _,_,S,B,B,B,B,B,B,B,B,S,_,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,B,B,B,B,B,B,_,B,B,B,B,_,_,_
    db _,_,B,B,B,B,B,_,_,_,B,B,B,B,_,_
    db _,B,B,B,B,B,_,_,_,_,_,B,B,B,_,_
    db _,B,B,B,B,_,_,_,_,_,_,_,B,B,_,_
    db N,N,N,N,N,_,_,_,_,_,_,_,N,N,N,_
    db N,N,N,N,_,_,_,_,_,_,_,_,N,N,N,_
    db N,N,N,_,_,_,_,_,_,_,_,_,_,N,N,_
    db N,N,_,_,_,_,_,_,_,_,_,_,_,N,N,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_

; ---- Super Mario jumping (16x32) ----
spr_super_jump:
    db 16, 32
    db _,_,_,_,_,_,_,_,_,_,_,_,S,S,S,_
    db _,_,_,_,R,R,R,R,R,_,_,R,R,S,S,_
    db _,_,_,R,R,R,R,R,R,R,R,R,R,R,S,_
    db _,_,_,N,N,N,S,S,N,S,R,R,R,_,_,_
    db _,_,N,S,N,S,S,S,N,S,S,R,R,_,_,_
    db _,_,N,S,N,N,S,S,S,N,S,S,S,_,_,_
    db _,_,N,N,S,S,S,S,N,N,N,N,_,_,_,_
    db _,_,_,R,R,B,R,R,R,R,_,_,_,_,_,_
    db _,_,R,R,R,B,R,R,B,R,R,R,_,_,_,_
    db _,R,R,R,R,B,B,B,B,R,R,R,R,_,_,_
    db _,S,S,R,B,S,B,B,S,B,R,S,S,_,_,_
    db _,S,S,S,B,B,B,B,B,B,S,S,S,_,_,_
    db _,S,S,B,B,B,B,B,B,B,B,S,S,_,_,_
    db _,S,S,B,B,B,B,B,B,B,B,S,S,_,_,_
    db _,_,S,B,B,B,B,B,B,B,B,S,_,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,_,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,_,B,B,B,B,B,B,B,B,B,B,B,_,_,_
    db _,B,B,B,B,_,_,_,_,_,B,B,B,B,_,_
    db _,B,B,B,_,_,_,_,_,_,_,B,B,B,_,_
    db N,N,N,N,_,_,_,_,_,_,_,N,N,N,N,_
    db N,N,N,_,_,_,_,_,_,_,_,_,N,N,N,_
    db N,N,_,_,_,_,_,_,_,_,_,_,_,N,N,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
    db _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_
