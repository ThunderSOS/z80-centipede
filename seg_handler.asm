top_of_screen           defb 4                          ;
segment_def struct                                      ;
                        direction ds 1                  ;
                        dx ds 1                         ;
                        dy ds 1                         ;
                        d_last_screen ds 2              ;
                        d_last_sprite ds 2              ;
                        d_last_attr ds 2                ;
                        len_seg equ .                   ;
send

; Table of segments.
; Format: 7 bytes per entry, 10 segments.
; byte 0: 255=segment off, 0=left, 1=right.
; byte 1 = x (horizontal) coordinate.
; byte 2 = y (vertical) coordinate.
segments                defb 0,0,0,0,0,0,0,0,0          ; segment 1
                        defb 0,0,0,0,0,0,0,0,0          ; segment 2
                        defb 0,0,0,0,0,0,0,0,0          ; segment 3
                        defb 0,0,0,0,0,0,0,0,0          ; segment 4
                        defb 0,0,0,0,0,0,0,0,0          ; segment 5
                        defb 0,0,0,0,0,0,0,0,0          ; segment 6
                        defb 0,0,0,0,0,0,0,0,0          ; segment 7
                        defb 0,0,0,0,0,0,0,0,0          ; segment 8
                        defb 0,0,0,0,0,0,0,0,0          ; segment 9
                        defb 0,0,0,0,0,0,0,0,0          ; segment 10

num_segments            defb 9                          ;

init_segments           ld a, (num_segments)            ;
                        ld b, a                         ;
                        ld ix, segments                 ;
init_seg_loop           ld a, b                         ;
                        rla                             ;
                        rla                             ;
                        rla                             ; a = b*8
                        ld (ix+dx), a                   ; x position = a
                        ld a, (top_of_screen)           ;
                        rla                             ;
                        rla                             ;
                        rla                             ;
                        ld (ix+dy), a                   ; y position = row 4    (top of screen)
                        ld (ix+direction), 1            ; moving right
                        ld de, 0                        ;
                        ld (ix+d_last_screen), de       ;
                        ld (ix+d_last_sprite), de       ;
                        ld de, len_seg                  ; len_seg = size of the struct
                        add ix, de                      ; point to next segment
                        djnz init_seg_loop              ;
                        ret                             ;

mv_seg                  ld a, (ix+direction)            ;
                        and a                           ;
                        jr z, mv_seg_lft                ;

mv_seg_rt               ld a, (ix+dx)                   ;
                        cp 248                          ;
                        jr z, mv_seg_dn                 ;
                        ld c, a                         ;
                        and 7                           ;
                        jr z, mv_rt_boundary            ;
                        ld a, c                         ;
mv_rt_2                 ld c, 2                         ;
                        add a, c                        ;
                        ld (ix+dx), a                   ;
                        ret                             ;

mv_rt_boundary          ld de, 1                        ; look one place to the right
                        ld hl, (ix+d_last_screen)       ;
                        call attr_at_hl                 ;
                        ld b, a                         ;
                        ld a, (mushroom_colour)         ;
                        cp b                            ; bright green
                        jr z, mv_seg_dn                 ;
                        ld a, (ix+dx)                   ;
                        jr mv_rt_2                      ;

mv_seg_dn               call chk_direction              ;
                        ld a, (ix+dy)                   ;
                        cp 23*8                         ; reached bottom of screen?
                        jr z, mv_dn_reset               ;
                        ld a, (ix+dy)                   ;
                        add 8                           ;
                        ld (ix+dy), a                   ;
                        ld c, a                         ;
                        ld b, (ix+dx)                   ;
                        call attr_from_xy               ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        jr z, obliterate_mushroom       ;
                        ret                             ;

; simply reversing the direction isn't enough, screen edges need an extra check
; that there's nothing in the way to send us back when we move down a row.
chk_direction           ld a, (ix+direction)            ;
                        and a                           ;
                        ld a, (ix+dx)                   ;
                        jr z, going_right               ;
                        and a                           ; going left and at left edge?
                        jr z, go_right                  ;
                        ld a, (ix+direction)            ; otherwise swap direction
                        xor 1                           ;
                        ld (ix+direction), a            ;
                        ret                             ;
going_right             cp 248                          ; going right and at right edge?
                        jr z, go_left                   ;
go_right                ld a, 1                         ;
                        ld (ix+direction), a            ;
                        ret                             ;
go_left                 xor a                           ;
                        ld (ix+direction), a            ;
                        ret                             ;

mv_dn_reset             ld a, (top_of_screen)           ;
                        rla                             ;
                        rla                             ;
                        rla                             ;
                        ld (ix+dy), a                   ;
                        ret                             ;

mv_seg_lft              ld a, (ix+dx)                   ;
                        and a                           ; left edge
                        jr z, mv_seg_dn                 ;
                        ld c, a                         ; back up a in c
                        and 7                           ; on a char boundary?
                        jr z, mv_lft_boundary           ;
                        ld a, c                         ;
mv_lft_2                ld c, 2                         ;
                        sub a, c                        ;
                        ld (ix+dx), a                   ;
                        ret                             ;

mv_lft_boundary         ld de, -1                       ;
                        ld hl, (ix+d_last_screen)       ;
                        call attr_at_hl                 ;
                        cp 68                           ;
                        jr z, mv_seg_dn                 ;
                        ld a, (ix+dx)                   ;
                        jr mv_lft_2                     ;

obliterate_mushroom     ld a, 2
                        ld (hl), a
                        ld h, (ix+dy)
                        ld l, (ix+dx)
                        call delete_mushroom
                        ret
