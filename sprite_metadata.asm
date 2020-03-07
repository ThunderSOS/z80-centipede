screen_colour           defb 2                          ;
mushroom_colour         defb 68                         ;


segment_def struct      seg_direction ds 1              ;
                        seg_dx ds 1                     ;
                        seg_dy ds 1                     ;
                        seg_last_screen ds 2            ;
                        seg_last_sprite ds 2            ;
                        seg_last_attr ds 2              ;
                        len_seg equ .                   ;
send

player_def struct       pl_dx ds 1                      ;
                        pl_dy ds 1                      ;
                        pl_last_screen ds 2             ;
                        pl_last_sprite ds 2             ;
                        pl_last_attr ds 2               ;
                        pl_flags ds 1                   ;
                        len_player equ .                ;
send

bullet_x                defb 0
bullet_y                defb 0
bullet_last_sprite      defw 0
bullet_last_screen      defw 0
bullet_last_attr        defw 0

; Table of segments based on above struct
segments                defb 0,0,0,0,0,0,0,0,0          ; segment 1
                        defb 0,0,0,0,0,0,0,0,0          ; segment 2
                        defb 0,0,0,0,0,0,0,0,0          ; segment 3
                        defb 0,0,0,0,0,0,0,0,0          ; segment 4
                        defb 0,0,0,0,0,0,0,0,0          ; segment 5
                        defb 0,0,0,0,0,0,0,0,0          ; segment 6
                        defb 0,0,0,0,0,0,0,0,0          ; segment 7
                        defb 0,0,0,0,0,0,0,0,0          ; segment 8
                        defb 0,0,0,0,0,0,0,0,0          ; segment 9
                        defb 0,0,0,0,0,0,0,0,0          ; segment 10

num_segments            defb 9                          ;

initial_num_mushrooms   defb 50
num_mushrooms           defb 50
num_mushrooms_left      defb 0

player                  defb 15*8,23*8,0,0,0,0,0,0,0  ;

segment_sprite          dg - - - X X - - - - - - - - - - - ;
                        dg - X X X X X X - - - - - - - - - ;
                        dg - X X X X X X - - - - - - - - - ;
                        dg X X X X X X X X - - - - - - - - ;
                        dg X X X X X X X X - - - - - - - - ;
                        dg - X X X X X X - - - - - - - - - ;
                        dg - X X X X X X - - - - - - - - - ;
                        dg - - - X X - - - - - - - - - - - ;

                        dg - - - - - X X - - - - - - - - - ;
                        dg - - - X X X X X X - - - - - - - ;
                        dg - - - X X X X X X - - - - - - - ;
                        dg - - X X X X X X X X - - - - - - ;
                        dg - - X X X X X X X X - - - - - - ;
                        dg - - - X X X X X X - - - - - - - ;
                        dg - - - X X X X X X - - - - - - - ;
                        dg - - - - - X X - - - - - - - - - ;

                        dg - - - - - - - X X - - - - - - - ;
                        dg - - - - - X X X X X X - - - - - ;
                        dg - - - - - X X X X X X - - - - - ;
                        dg - - - - X X X X X X X X - - - - ;
                        dg - - - - X X X X X X X X - - - - ;
                        dg - - - - - X X X X X X - - - - - ;
                        dg - - - - - X X X X X X - - - - - ;
                        dg - - - - - - - X X - - - - - - - ;

                        dg - - - - - - - - - X X - - - - - ;
                        dg - - - - - - - X X X X X X - - - ;
                        dg - - - - - - - X X X X X X - - - ;
                        dg - - - - - - X X X X X X X X - - ;
                        dg - - - - - - X X X X X X X X - - ;
                        dg - - - - - - - X X X X X X - - - ;
                        dg - - - - - - - X X X X X X - - - ;
                        dg - - - - - - - - - X X - - - - - ;


player_sprite           dg - - - - - - - - - - - - - - - - ; when player_x mod 8 == 0
                        dg - - X - - X - - - - - - - - - - ; only draw one byte wide
                        dg - - X - - X - - - - - - - - - - ; and check attrs on adjacent
                        dg - - X - - X - - - - - - - - - - ; squares for mushrooms
                        dg - X X X X X X - - - - - - - - - ;
                        dg - X X X X X X - - - - - - - - - ;
                        dg X X X X X X X X - - - - - - - - ;
                        dg X X X X X X X X - - - - - - - - ;

                        dg - - - - - - - - - - - - - - - - ; otherwise we should be clear to draw
                        dg - - - - X - - X - - - - - - - - ;
                        dg - - - - X - - X - - - - - - - - ;
                        dg - - - - X - - X - - - - - - - - ;
                        dg - - - X X X X X X - - - - - - - ;
                        dg - - - X X X X X X - - - - - - - ;
                        dg - - X X X X X X X X - - - - - - ;
                        dg - - X X X X X X X X - - - - - - ;

                        dg - - - - - - - - - - - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;
                        dg - - - - - X X X X X X - - - - - ;
                        dg - - - - - X X X X X X - - - - - ;
                        dg - - - - X X X X X X X X - - - - ;
                        dg - - - - X X X X X X X X - - - - ;

                        dg - - - - - - - - - - - - - - - - ;
                        dg - - - - - - - - X - - X - - - - ;
                        dg - - - - - - - - X - - X - - - - ;
                        dg - - - - - - - - X - - X - - - - ;
                        dg - - - - - - - X X X X X X - - - ;
                        dg - - - - - - - X X X X X X - - - ;
                        dg - - - - - - X X X X X X X X - - ;
                        dg - - - - - - X X X X X X X X - - ;

bullet_sprite           dg - - - - - - - - - - - - - - - - ;
                        dg - - X - - X - - - - - - - - - - ;
                        dg - - X - - X - - - - - - - - - - ;
                        dg - - X - - X - - - - - - - - - - ;
                        dg - - X - - X - - - - - - - - - - ;
                        dg - - X - - X - - - - - - - - - - ;
                        dg - - X - - X - - - - - - - - - - ;
                        dg - - X - - X - - - - - - - - - - ;

                        dg - - - - - - - - - - - - - - - - ;
                        dg - - - - X - - X - - - - - - - - ;
                        dg - - - - X - - X - - - - - - - - ;
                        dg - - - - X - - X - - - - - - - - ;
                        dg - - - - X - - X - - - - - - - - ;
                        dg - - - - X - - X - - - - - - - - ;
                        dg - - - - X - - X - - - - - - - - ;
                        dg - - - - X - - X - - - - - - - - ;

                        dg - - - - - - - - - - - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;
                        dg - - - - - - X - - X - - - - - - ;

                        dg - - - - - - - - - - - - - - - - ;  this one is drawn as an 8 bit sprite
                        dg X - - X - - - - - - - - - - - - ;  shifted to the left by 8 pixels
                        dg X - - X - - - - - - - - - - - - ;
                        dg X - - X - - - - - - - - - - - - ;
                        dg X - - X - - - - - - - - - - - - ;
                        dg X - - X - - - - - - - - - - - - ;
                        dg X - - X - - - - - - - - - - - - ;
                        dg X - - X - - - - - - - - - - - - ;

mushroom_sprite         dg - - - X X - - -
                        dg - X X X - X X -
                        dg X X - X X X X X
                        dg X X X X X X X X
                        dg - - X X - X - -
                        dg - - X X X X - -
                        dg - - X X X X - -
                        dg - - X X X X - -


