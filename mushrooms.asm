
init_mushrooms          ld b, 50                        ;
init_mush_lp            call get_random_8               ;
                        and 31                          ;
                        ld l, a                         ;
                        push hl                         ;
                        call get_random_8               ;
                        pop hl                          ;
                        and 15                          ;
                        ld c, a                         ;
                        ld a, (top_of_screen)           ;
                        inc a                           ;
                        add a, c                        ;
                        ld h, a                         ;
                        push bc                         ;
                        call draw_mushroom              ;
                        pop bc                          ;
                        djnz init_mush_lp               ;
                        ret                             ;

