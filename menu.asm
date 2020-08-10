
centipede_title         defb "C e n t i p e d e", 0     ;
option_1                defb "1 - Start", 0             ;
option_2                defb "0 - Quit", 0              ;

show_menu               di                              ;
                        ld a, 6                         ;
                        ld (23693),a                    ; set our screen colours.
                        call 3503                       ; clear the screen.
                        ld a, 0                         ;
                        call 8859                       ; set the border permanent
                        ld h, 3*8                       ;
                        ld l, 7*8                       ;
                        ld de, centipede_title          ;
                        call pr_str_dbl_ht              ;
                        ld h, 7*8                       ;
                        ld l, 11*8                      ;
                        ld de, option_1                 ;
                        call pr_str_dbl_ht              ;
                        ld h, 10*8                      ;
                        ld l, 11*8                      ;
                        ld de, option_2                 ;
                        call pr_str_dbl_ht              ;

wait_loop               ld bc, zeuskeyaddr("0")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("0")          ;
                        and e                           ;
                        cp e                            ;
                        jp nz, 0                        ;
                        ld bc, zeuskeyaddr("1")         ;
                        in a, (c)                       ;
                        ld e, zeuskeymask("1")          ;
                        and e                           ;
                        cp e                            ;
                        jp nz, interrupt_setup          ;
                        jr wait_loop                    ;



