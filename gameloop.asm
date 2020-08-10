
init_game               ld a, 6                         ; ld a, (screen_colour)
                        ld (23693),a                    ; set our screen colours.
                        call 3503                       ; clear the screen.
                        xor a                           ;
                        ld (num_mushrooms_left), a      ;
                        call 8859                       ; set the border permanent
                        ld a, 3                         ;
                        ld (lives), a                   ;
                        ld iy, player                   ;
                        call init_mushrooms             ;
                        call display_score              ;
                        call display_lives              ;
                        call init_segments              ;
                        call draw_all_segments          ;
                        call init_player                ;
                        ld (iy+pl_flags), 0             ;
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
                        call colour_bullet_square       ; bit of a hack this
                        call check_bseg_collision       ;
                        xor a                           ;
                        out(254), a                     ;
                        ret                             ;

