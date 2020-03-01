
top_of_screen           defb 5                          ;

init_segments           ld a, (num_segments)            ;
                        ld b, a                         ;
                        ld ix, segments                 ;
init_seg_loop           ld a, b                         ;
                        rla                             ;
                        rla                             ;
                        rla                             ; a = b*8
                        ld (ix+seg_dx), a               ; x position = a
                        ld a, (top_of_screen)           ;
                        rla                             ;
                        rla                             ;
                        rla                             ;
                        ld (ix+seg_dy), a               ; y position = row 4    (top of screen)
                        ld (ix+seg_direction), 1        ; moving right
                        ld de, 0                        ;
                        ld (ix+seg_last_screen), de     ;
                        ld (ix+seg_last_sprite), de     ;
                        ld de, len_seg                  ; len_seg = size of the struct
                        add ix, de                      ; point to next segment
                        djnz init_seg_loop              ;
                        ret                             ;

mv_seg                  ld a, (ix+seg_direction)        ;
                        and a                           ;
                        jr z, mv_seg_lft                ;

mv_seg_rt               ld a, (ix+seg_dx)               ;
                        cp 248                          ;
                        jr z, mv_seg_dn                 ;
                        ld c, a                         ;
                        and 7                           ;
                        jr z, mv_rt_boundary            ;
                        ld a, c                         ;
mv_rt_2                 inc a                           ;
                        inc a
                        ld (ix+seg_dx), a               ;
                        ld b, a                         ;
                        ld c, (ix+seg_dy)               ;
                        ld hl, (ix+seg_last_attr)       ;
                        inc hl                          ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        ld a, 2                         ;
                        ld (hl), a                      ;
                        ret                             ;

mv_seg_lft              ld a, (ix+seg_dx)               ;
                        and a                           ; left edge
                        jr z, mv_seg_dn                 ;
                        ld c, a                         ; back up a in c
                        and 7                           ; on a char boundary?
                        jr z, mv_lft_boundary           ;
                        ld a, c                         ;
mv_lft_2                dec a                           ;
                        dec a                           ;
                        ld (ix+seg_dx), a               ;
                        ret                             ;

mv_lft_boundary         ld de, -1                       ;
                        ld hl, (ix+seg_last_screen)     ;
                        call attr_at_hl                 ;
                        cp 68                           ;
                        jr z, mv_seg_dn                 ;
                        ld a, (ix+seg_dx)               ;
                        jr mv_lft_2                     ;

mv_rt_boundary          ld de, 1                        ; look one place to the right
                        ld hl, (ix+seg_last_screen)     ;
                        call attr_at_hl                 ;
                        ld b, a                         ;
                        ld a, (mushroom_colour)         ;
                        cp b                            ; bright green
                        jr z, mv_seg_dn                 ;
                        ld a, (ix+seg_dx)               ;
                        jr mv_rt_2                      ;

mv_seg_dn               call chk_direction              ;
                        ld a, (ix+seg_dy)               ;
                        cp 23*8                         ; reached bottom of screen?
                        jr z, mv_dn_reset               ;
                        ld a, (ix+seg_dy)               ;
                        add a, 8                        ;
                        ld (ix+seg_dy), a               ;
                        ld hl, (ix+seg_last_attr)       ;
                        ld bc, 32
                        add hl, bc
                        ld a, (hl)                      ;
                        cp 68                           ;
                        jr z, obliterate_mushroom       ;
                        ret                             ;

; simply reversing the direction isn't enough, screen edges need an extra check
; that there's nothing in the way to send us back when we move down a row.
chk_direction           ld a, (ix+seg_direction)        ;
                        and a                           ;
                        ld a, (ix+seg_dx)               ;
                        jr z, going_right               ;
                        and a                           ; going left and at left edge?
                        jr z, go_right                  ;
                        ld a, (ix+seg_direction)        ; otherwise swap direction
                        xor 1                           ;
                        ld (ix+seg_direction), a        ;
                        ret                             ;
going_right             cp 248                          ; going right and at right edge?
                        jr z, go_left                   ;
go_right                ld a, 1                         ;
                        ld (ix+seg_direction), a        ;
                        ret                             ;
go_left                 xor a                           ;
                        ld (ix+seg_direction), a        ;
                        ret                             ;

mv_dn_reset             ld a, (top_of_screen)           ;
                        rla                             ;
                        rla                             ;
                        rla                             ;
                        ld (ix+seg_dy), a               ;
                        ret                             ;

obliterate_mushroom     ld a, 2                         ; turn the square red
                        ld (hl), a                      ;
                        ld h, (ix+seg_dy)               ;
                        ld l, (ix+seg_dx)               ;
                        jp delete_mushroom              ;

check_collision         ld ix, segments
                        ld a, (num_segments)
                        ld b, a
chk_coll_lp             ld a, (iy+pl_dy)
                        ld c, (ix+seg_dy)
                        call compare_unsigned
                        cp 8
                        jr c, chk_coll_x
chk_coll_end            ld de, len_seg
                        add ix, de
                        djnz chk_coll_lp
                        ret

chk_coll_x              ld a, (iy+pl_dx)
                        ld c, (ix+seg_dx)
                        call compare_unsigned
                        cp 6
                        jr nc, chk_coll_end
                        ; otherwise...

collision               call draw_player                 ; undraw player
                        call draw_all_segments           ; undraw segments
                        call init_segments               ; re-init segments
                        call init_player
                        call draw_player
                        ret

compare_unsigned        sub a, c
                        ret nc
                        neg
                        ret
