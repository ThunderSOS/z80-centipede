
init_game               ld a, 6                         ; ld a, (screen_colour)
                        ld (23693),a                    ; set our screen colours.
                        call 3503                       ; clear the screen.
                        ld a, 0                         ;
                        call 8859                       ; set the border permanent
                        ld iy, player                   ;
                        call init_mushrooms             ;
                        call display_score              ;
                        call init_segments              ;
                        call draw_all_segments          ;
                        call draw_player                ;
                        ret                             ;

gameloop                ld a, 0                         ;
                        out(254), a                     ;
                        call update_all_segments        ;
                        call draw_player                ;
                        call move_player                ;
                        call draw_player                ;
                        call check_collision            ;
                        call update_bullet              ;
                        call check_bullet_collision     ;
                        call colour_bullet_square       ;
                        xor a                           ;
                        out(254), a                     ;
                        ret                             ;

