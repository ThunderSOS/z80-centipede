
; return sprite base in de
calc_sprite_base        push hl                         ;
                        ld a, (ix+dx)                   ;
                        rrca                            ;
                        and 3                           ; 4 frame animation
                        rlca                            ;
                        rlca                            ;
                        rlca                            ;
                        rlca                            ; x16
                        ld e, a                         ;
                        ld d, 0                         ;
                        ld hl, segment_sprite           ;
                        add hl, de                      ;
                        ex de, hl                       ;
                        pop hl                          ;
                        ret                             ;

draw_seg_1x2            ld hl, (ix+d_last_screen)       ;
                        ld a, h                         ;
                        or l                            ;
                        ret z                           ;
                        ld de, (ix+d_last_sprite)       ;
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
                        call calc_sprite_base           ;
                        ld (ix+d_last_sprite), de       ;
                        ld h, (ix+dy)                   ;
                        ld l, (ix+dx)                   ;
                        call hl_to_screen               ;
                        ld (ix+d_last_screen), hl       ;
                        call screen_to_attr_hl          ;
                        ld (ix+d_last_attr), hl         ;
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
                        ld h, (ix+dy)                   ;
                        ld l, (ix+dx)                   ;
                        call hl_to_screen               ;
                        ld (ix+d_last_screen), hl       ;
                        call calc_sprite_base           ;
                        ld (ix+d_last_sprite), de       ;
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
                        xor (hl)
                        ld (hl), a                      ;
                        inc h                           ;
                        inc de                          ;
                        djnz del_mush_lp                ;
                        ld a, h                         ;
                        sub 8                           ;
                        ld h, a                         ;
                        ret                             ;

seg_sprite_test         ld a, (screen_colour)           ;  + 8*7                   ;
                        ld (23693),a                    ; set our screen colours.
                        call 3503                       ; clear the screen.
                        ld a, 0                         ;
                        call 8859                       ; set the border permanent
                        call init_mushrooms             ;
                        ;call display_score              ;
                        call init_segments              ;
                        call draw_all_segments          ;
test_mv_lp              ld a, 1                         ;
                        out(254), a                     ;
                        call update_all_segments        ;
                        ld a, 6                         ;
                        out(254), a
                        ld h, 0;
                        ld l, 24*8
                        call hl_to_screen
                        call display_score_digits       ;
                        xor a                           ;
                        out(254), a                     ;
                        halt                            ;
                        jr test_mv_lp                   ;
                        ret                             ;

