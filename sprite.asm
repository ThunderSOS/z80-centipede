
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
                        ld a, (ix+seg_dx)               ;
                        ld de, segment_sprite           ;
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
                        call screen_to_attr_hl          ;
                        ld (ix+seg_last_attr), hl       ;
                        ld a, 2                         ;
                        ld (hl), a                      ;
                        ld a, (ix+seg_dx)               ;
                        ld de, segment_sprite           ;
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
delete_mushroom_hl      ld de, mushroom_sprite          ;
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

draw_player             ld a, (iy+pl_dx)                ;
                        ld c, a                         ;
                        ld de, player_sprite            ;
                        call calc_sprite_base           ;
                        ld l, c                         ;
                        ld h, (iy+pl_dy)                ;
                        call hl_to_screen               ;
                        ld (iy+pl_last_screen), hl      ;
                        push hl                         ;
                        call screen_to_attr_hl          ;
                        ld (iy+pl_last_attr), hl        ;
                        pop hl                          ;
                        ld b, 8                         ;
                        ld a, c                         ;
                        and 7                           ;
                        jr z, draw_player_8             ;

draw_player_16          ld a, (de)                      ;
                        xor (hl)                        ;
                        ld (hl), a                      ;
                        inc l                           ;
                        inc de                          ;
                        ld a, (de)                      ;
                        xor (hl)                        ;
                        ld (hl), a                      ;
                        inc de                          ;
                        dec l                           ;
                        call inc_y                      ;
                        djnz draw_player_16             ;
                        ld hl, (iy+pl_last_attr)        ;
                        ld a, 5                         ;
                        ld (hl), a                      ;
                        inc l                           ;
                        ld (hl), a                      ;
                        ld a, (iy+pl_dy)                ;
                        and 7                           ;
                        ret z                           ;
                        ld a, 5                         ;
                        ld bc, 31                       ;
                        add hl, bc                      ;
                        ld (hl), a                      ;
                        inc l                           ;
                        ld (hl), a                      ;
                        ret                             ;

draw_player_8           ld a, (de)                      ;
                        ld c, a                         ;
                        xor (hl)                        ;
                        ld (hl), a                      ;
                        inc de                          ;
                        inc de                          ;
                        call inc_y                      ;
                        djnz draw_player_8              ;
                        ld hl, (iy+pl_last_attr)        ;
                        ld a, 5                         ;
                        ld (hl), a                      ;
                        ld a, (iy+pl_dy)                ;
                        and 7                           ;
                        ret z                           ;
                        ld a, 5                         ;
                        ld bc, 32                       ;
                        add hl, bc                      ;
                        ld (hl), a                      ;
                        ret                             ;

draw_bullet             ld hl, (bullet_last_screen)     ;
                        ld de, (bullet_last_sprite)     ;
                        call screen_to_attr_bc          ;
                        ld (bullet_last_attr), bc       ;
                        bit 1, (iy+pl_flags)            ;
                        ld b, 8                         ;
                        jr nz, draw_bullet_8            ;

draw_bullet_16          ld a, (de)                      ;
                        xor (hl)                        ;
                        ld (hl), a                      ;
                        inc l                           ;
                        inc de                          ;
                        ld a, (de)                      ;
                        xor (hl)                        ;
                        ld (hl), a                      ;
                        inc de                          ;
                        dec l                           ;
                        call inc_y                      ;
                        djnz draw_bullet_16             ;
                        ;ld hl, (bullet_last_attr)       ;
                        ;ld a, (hl)
                        ;cp 68
                        ;jr z, bullet_mush_coll
                        ;inc l
                        ;ld a, (hl)
                        ;cp 68
                        ;set 2, (iy+pl_flags)
                        ;jr z, bullet_mush_coll
                        ;dec l
                        ;ld a, 7                         ;
                        ;ld (hl), a                      ;
                        ;inc l                           ;
                        ;ld (hl), a                      ;
                        ret                             ;

draw_bullet_8           ld a, (de)                      ;
                        xor (hl)                        ;
                        ld (hl), a                      ;
                        inc de                          ;
                        inc de                          ;
                        call inc_y                      ;
                        djnz draw_bullet_8              ;
                        ;ld hl, (bullet_last_attr)       ;
                        ;ld a, (hl)
                        ;cp 68
                        ;jr z, bullet_mush_coll
                        ;ld a, 7                         ;
                        ;ld (hl), a                      ;
                        ret                             ;


