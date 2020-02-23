
move_player             ld ix, player
                        ld bc, zeuskeyaddr("O")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("O")          ;
                        and e                           ;
                        cp e                            ;
                        jr nz, pl_mv_lft                ;

                        ld bc, zeuskeyaddr("P")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("P")          ;
                        and e                           ;
                        cp e                            ;
                        jr nz, pl_mv_rt                 ;

                        ld bc, zeuskeyaddr("Q")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("Q")          ;
                        and e                           ;
                        cp e                            ;
                        jr nz, pl_mv_up                 ;

                        ld bc, zeuskeyaddr("A")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("A")          ;
                        and e                           ;
                        cp e                            ;
                        jp nz, pl_mv_dn                 ;
                        ret                             ;

pl_mv_lft               ld a, (ix+pl_dx)                ;
                        and a                           ;
                        ret z                           ;
                        ld c, a                         ;
                        and 7                           ;
                        jr z, pl_mv_lft_boundary        ;
pl_mv_lft_0             ld a, (ix+pl_dx)                ;
                        sub a, 2                        ;
                        ld (ix+pl_dx), a                ;
                        ret                             ;
pl_mv_lft_boundary      ld hl, (ix+pl_last_attr)        ;
                        dec l                           ; attr one place left
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        ld a, (ix+pl_dy)                ;
                        and 7                           ;
                        jr z, pl_mv_lft_0               ;
                        ld de, 32                       ; attr down one row
                        add hl, de                      ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        jr pl_mv_lft_0                  ;

pl_mv_rt                ld a, (ix+pl_dx)                ;
                        cp 248                          ;
                        ret z                           ;
                        ld c, a                         ;
                        and 7                           ;
                        jr z, pl_mv_rt_boundary         ;
pl_mv_rt_0              ld a, (ix+pl_dx)                ;
                        add a, 2                        ;
                        ld (ix+pl_dx), a                ;
                        ret                             ;
pl_mv_rt_boundary       ld hl, (ix+pl_last_attr)        ;
                        inc l                           ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        ld a, (ix+pl_dy)                ;
                        and 7                           ;
                        jr z, pl_mv_rt_0                ;
                        ld de, 32                       ;
                        add hl, de                      ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        jr pl_mv_rt_0                   ;

pl_mv_up                ld a, (ix+pl_dy)                ;
                        cp 40                           ;
                        ret z                           ;
                        ld c, a                         ;
                        and 7                           ;
                        jr z, pl_mv_up_boundary         ;
pl_mv_up_0              ld a, (ix+pl_dy)                ;
                        sub a, 2                        ;
                        ld (ix+pl_dy), a                ;
                        ret                             ;
pl_mv_up_boundary       ld hl, (ix+pl_last_attr)        ;
                        ld de, 32                       ;
                        and a                           ;
                        sbc hl, de                      ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        ld a, (ix+pl_dx)                ;
                        and 7                           ;
                        jr z, pl_mv_up_0                ;
                        inc l                           ;
                        ld a, (hl)                      ;
                        cp 68                           ;
                        ret z                           ;
                        jr pl_mv_up_0                   ;

pl_mv_dn                ld a, (ix+pl_dy)                ;
                        cp 23*8                         ;
                        ret z                           ;
                        ld c, a
                        and 7
                        jr pl_mv_dn_boundary
pl_mv_dn_0              ld a, (ix+pl_dy)
                        add a, 2                        ;
                        ld (ix+pl_dy), a                ;
                        ret                             ;
pl_mv_dn_boundary       ld hl, (ix+pl_last_attr)
                        ld de, 32
                        add hl, de
                        ld a, (hl)
                        cp 68
                        ret z
                        ld a, (ix+pl_dx)
                        and 7
                        jr z, pl_mv_dn_0
                        inc l
                        ld a, (hl)
                        cp 68
                        ret z
                        jr pl_mv_dn_0
