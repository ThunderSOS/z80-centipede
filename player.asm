
init_player             ld a, 15*8                      ;
                        ld (iy), a                      ;
                        ld a, 23*8                      ;
                        ld (iy+1), a                    ;
                        ld hl, 0                        ;
                        ld (iy+pl_last_screen), hl      ;
                        ld (iy+pl_last_attr), hl        ;
                        ;ld (iy+pl_flags), 0
                        ret                             ;

move_player             ld bc, zeuskeyaddr("Q")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("Q")          ;
                        and e                           ;
                        cp e                            ;
                        jp nz, pl_mv_up                 ;

                        ld bc, zeuskeyaddr("A")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("A")          ;
                        and e                           ;
                        cp e                            ;
                        jp nz, pl_mv_dn                 ;

                        ld bc, zeuskeyaddr("O")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("O")          ;
                        and e                           ;
                        cp e                            ;
                        jp nz, pl_mv_lft                ;

                        ld bc, zeuskeyaddr("P")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("P")          ;
                        and e                           ;
                        cp e                            ;
                        jp nz, pl_mv_rt                 ;

                        ld bc, zeuskeyaddr(" ")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask(" ")          ;
                        and e                           ;
                        cp e                            ;
                        jp nz, pl_fire                  ;
                        ret                             ;

pl_fire                 bit 0, (iy+pl_flags)            ; are we already firing?
                        ret nz                          ;
                        set 0, (iy+pl_flags)            ; set the 'is firing' flag
                        ld l, (iy+pl_dx)                ;
                        ld a, l                         ;
                        rrca                            ;
                        and 3                           ;
                        cp 3                            ; is this sprite 3?
                        ld a, l                         ;
                        jr nz, pl_fire_cont             ; if not jump
                        set 1, (iy+pl_flags)            ; set a flag to draw just 8 bit version
                        ld a, 4                         ; otherwise adjust the position 4 bits
                        add a, l                        ; to the right
pl_fire_cont            ld l, a                         ; store x position in l
                        ld (bullet_x), a                ;
                        ld a, (iy+pl_dy)                ;
                        sub a, 8                        ; initial bullet y-pos 8 bits above the
                        ld (bullet_y), a                ; player
                        ld h, a                         ; store y position in h
                        call hl_to_screen               ;
                        ld (bullet_last_screen), hl     ;
                        ld a, (iy+pl_dx)                ; find the right sprite
                        rrca                            ; 4 sprites so divide by 2
                        and 3                           ; 0, 1, 2 or 3
                        rlca                            ;
                        rlca                            ;
                        rlca                            ;
                        rlca                            ; x by 16
                        ld l, a                         ;
                        ld h, 0                         ;
                        ld de, bullet_sprite            ; add on sprite base
                        add hl, de                      ;
                        ld (bullet_last_sprite), hl     ; done
                        jp draw_bullet                  ; draw bullet

pl_mv_lft               ld a, (iy+pl_dx)                ;
                        and a                           ;
                        ret z                           ;
                        and 7                           ;
                        jr z, pl_mv_lft_boundary        ;
pl_mv_lft_0             ld a, (iy+pl_dx)                ;
                        sub a, 2                        ;
                        ld (iy+pl_dx), a                ;
                        ret                             ;
pl_mv_lft_boundary      ld hl, (iy+pl_last_attr)        ;
                        dec l                           ; attr one place left
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        ld a, (iy+pl_dy)                ;
                        and 7                           ;
                        jr z, pl_mv_lft_0               ;
                        ld de, 32                       ; attr down one row
                        add hl, de                      ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        jr pl_mv_lft_0                  ;

pl_mv_rt                ld a, (iy+pl_dx)                ;
                        cp 248                          ;
                        ret z                           ;
                        and 7                           ;
                        jr z, pl_mv_rt_boundary         ;
pl_mv_rt_0              ld a, (iy+pl_dx)                ;
                        add a, 2                        ;
                        ld (iy+pl_dx), a                ;
                        ret                             ;
pl_mv_rt_boundary       ld hl, (iy+pl_last_attr)        ;
                        inc l                           ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        ld a, (iy+pl_dy)                ;
                        and 7                           ;
                        jr z, pl_mv_rt_0                ;
                        ld de, 32                       ;
                        add hl, de                      ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        jr pl_mv_rt_0                   ;

pl_mv_up                ld a, (iy+pl_dy)                ;
                        cp 22*8                         ;
                        ret z                           ;
                        and 7                           ;
                        jr z, pl_mv_up_boundary         ;
pl_mv_up_0              ld a, (iy+pl_dy)                ;
                        sub a, 2                        ;
                        ld (iy+pl_dy), a                ;
                        ret                             ;
pl_mv_up_boundary       ld hl, (iy+pl_last_attr)        ;
                        ld de, 32                       ;
                        sbc hl, de                      ; carry is reset from previous 'and 7'
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        ld a, (iy+pl_dx)                ;
                        and 7                           ;
                        jr z, pl_mv_up_0                ;
                        inc l                           ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        jr pl_mv_up_0                   ;

pl_mv_dn                ld a, (iy+pl_dy)                ;
                        cp 23*8                         ;
                        ret z                           ;
                        and 7                           ;
                        jr z, pl_mv_dn_boundary         ;
pl_mv_dn_0              ld a, (iy+pl_dy)                ;
                        add a, 2                        ;
                        ld (iy+pl_dy), a                ;
                        ret                             ;
pl_mv_dn_boundary       ld hl, (iy+pl_last_attr)        ;
                        ld de, 32                       ;
                        add hl, de                      ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        ld a, (iy+pl_dx)                ;
                        and 7                           ;
                        jr z, pl_mv_dn_0                ;
                        inc l                           ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        jr pl_mv_dn_0                   ;

