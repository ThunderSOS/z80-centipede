
update_bullet           bit 0, (iy+pl_flags)            ;
                        ret z                           ;
                        call draw_bullet                ;
                        ld a, (bullet_y)                ;
                        sub a, 4                        ;
                        ld (bullet_y), a                ;
                        cp 32                           ;
                        jr z, reset_bullet              ;
                        jr c, reset_bullet              ;
                        ld h, a                         ;
                        ld a, (bullet_x)                ;
                        ld l, a                         ;
                        call hl_to_screen               ;
                        ld (bullet_last_screen), hl     ;
                        call screen_to_attr_bc          ;
                        ld (bullet_last_attr), bc       ;
                        jp draw_bullet                  ;

check_bullet_collision  bit 0, (iy+pl_flags)            ;
                        ret z                           ;
                        ld hl, (bullet_last_attr)       ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        jr z, mush_coll_detected        ;
                        bit 1, (iy+pl_flags)            ; if set 8 bit bullet draw
                        ret nz                          ;
                        inc l                           ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret nz                          ;
                        set 2, (iy+pl_flags)            ;
mush_coll_detected      ld a, (bullet_x)                ;
                        and 248                         ;
                        ld l, a                         ;
                        ld a, (bullet_y)                ;
                        and 248                         ;
                        ld h, a                         ;
                        call hl_to_screen               ;
                        bit 2, (iy+pl_flags)            ;
                        jr z, mush_coll_clearup         ;
                        inc l                           ;
mush_coll_clearup       push hl                         ;
                        call delete_mushroom_hl         ;
                        pop hl                          ;
                        call screen_to_attr_hl          ;
                        ld a, 2                         ;
                        ld (hl), a                      ;
                        call draw_bullet                ;
                        ld (iy+pl_flags), 0             ;
                        ld bc, $0250                    ;
                        call add_bc_to_score            ;
                        ret                             ;

colour_bullet_square    bit 0, (iy+pl_flags)            ;
                        ret z                           ;
                        ld hl, (bullet_last_attr)       ;
                        ld a, 7                         ;
                        ld (hl), a                      ;
                        bit 1, (iy+pl_flags)            ;
                        ret nz                          ;
                        inc l                           ;
                        ld (hl), a                      ;
                        ret                             ;

reset_bullet            ld (iy+pl_flags), 0             ;
                        ret                             ;
