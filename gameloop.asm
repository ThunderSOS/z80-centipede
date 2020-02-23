
init_game               ld a, 6; (screen_colour)           ;  + 8*7                   ;
                        ld (23693),a                    ; set our screen colours.
                        call 3503                       ; clear the screen.
                        ld a, 0                         ;
                        call 8859                       ; set the border permanent
                        call init_mushrooms             ;
                        call display_score              ;
                        call init_segments              ;
                        call draw_all_segments          ;
                        call draw_player
                        ret

gameloop                ld a, 0                         ;
                        out(254), a                     ;
                        call update_all_segments        ;


                        call draw_player
                        call move_player
                        call draw_player
                        xor a                           ;
                        out(254), a                     ;;jr gameloop                     ;
                        ret                             ;

