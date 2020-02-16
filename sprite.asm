
; return sprite base in de
calc_sprite_base        push hl                         ;
                        rrca                            ;
                        and 3                           ; 4 frame animation
                        rlca                            ;
                        rlca                            ;
                        rlca                            ;
                        rlca                            ; x16
                        ld l, a                         ;
                        ld h, 0                         ;
                        add hl, de                      ;
                        ex de, hl                       ;
                        pop hl                          ;
                        ret                             ;

draw_seg_1x2            ld hl, (ix+seg_last_screen)     ;
                        ld a, h                         ;
                        or l                            ;
                        ret z                           ;
                        ld de, (ix+seg_last_sprite)     ;
                        ld b, 8                         ;
draw_seg_1x2_lp         ld a, (de)                      ;
                        xor (hl)                        ;
                        ld (hl), a                      ;
                        inc hl                          ;
                        inc de                          ;
                        ld a, (de)                      ;
                        xor (hl)                        ;
                        ld (hl), a                      ;
                        inc de                          ;
                        dec hl                          ;
                        inc h                           ;
                        djnz draw_seg_1x2_lp            ;
                        ret                             ;

draw_all_segments       ld ix, segments                 ;
                        ld a, (num_segments)            ;
                        ld b, a                         ;
draw_segs_lp            push bc                         ;
                        ld a, (ix+seg_dx)
                        ld de, segment_sprite
                        call calc_sprite_base           ;
                        ld (ix+seg_last_sprite), de     ;
                        ld h, (ix+seg_dy)               ;
                        ld l, (ix+seg_dx)               ;
                        call hl_to_screen               ;
                        ld (ix+seg_last_screen), hl     ;
                        call draw_seg_1x2               ;
                        ld de, len_seg                  ;
                        add ix, de                      ;
                        pop bc                          ;
                        djnz draw_segs_lp               ;
                        ret                             ;

update_all_segments     ld ix, segments                 ;
                        ld a, (num_segments)            ;
                        ld b, a                         ;
upd_segs_lp             push bc                         ;
                        call draw_seg_1x2               ; undraw
                        call mv_seg                     ;
                        ld h, (ix+seg_dy)               ;
                        ld l, (ix+seg_dx)               ;
                        call hl_to_screen               ;
                        ld (ix+seg_last_screen), hl     ;
                        call screen_to_attr_hl
                        ld (ix+seg_last_attr), hl
                        ld a, 2
                        ld (hl), a
                        ld a, (ix+seg_dx)
                        ld de, segment_sprite
                        call calc_sprite_base           ;
                        ld (ix+seg_last_sprite), de     ;
                        call draw_seg_1x2               ;
                        pop bc                          ;
                        ld de, len_seg                  ;
                        add ix, de                      ;
                        djnz upd_segs_lp                ;
                        ret                             ;

draw_mushroom           call xy_to_screen               ;
                        ld de, mushroom_sprite          ;
                        ld b, 8                         ;
draw_mush_lp            ld a, (de)                      ;
                        ld (hl), a                      ;
                        inc h                           ;
                        inc de                          ;
                        djnz draw_mush_lp               ;
                        ld a, h                         ;
                        sub 8                           ;
                        ld h, a                         ;
                        call screen_to_attr_hl          ;
                        ld a, (mushroom_colour)         ;
                        ld (hl), a                      ;
                        ret                             ;

delete_mushroom         call hl_to_screen               ;
                        ld de, mushroom_sprite          ;
                        ld b, 8                         ;
del_mush_lp             ld a, (de)                      ;
                        xor (hl)                        ;
                        ld (hl), a                      ;
                        inc h                           ;
                        inc de                          ;
                        djnz del_mush_lp                ;
                        ld a, h                         ;
                        sub 8                           ;
                        ld h, a                         ;
                        ret                             ;

draw_player             ld a, (iy+plyr_dx)
                        ld c, a
                        ld de, player_sprite
                        call calc_sprite_base
                        ld l, c
                        ld h, (iy+plyr_dy)
                        call hl_to_screen
                        ld b, 8
draw_plyr_lp            ld a, (de)
                        xor (hl)
                        ld (hl), a
                        inc de
                        inc l
                        ld a, (de)
                        xor (hl)
                        ld (hl), a
                        dec l
                        call inc_y
                        inc de
                        djnz draw_plyr_lp
                        ret






