
font_base equ           15616
upper_col               defb 6
lower_col               defb 3


; h -> y (must be on an 8 bit boundary)
; l -> x
; de -> string (zero terminated)
pr_str_dbl_ht           call hl_to_screen
pr_str_dbl_ht_lp        ld a, (de)
                        and a
                        ret z
                        push de
                        call pr_char_dbl_ht
                        pop de
                        inc de
                        jr pr_str_dbl_ht_lp

; hl -> screen position
; a  ascii code of char
pr_char_dbl_ht          push hl
                        push af
                        ex de, hl
                        pop af
                        sub 32
                        ld l, a
                        ld h, 0
                        add hl, hl
                        add hl, hl
                        add hl, hl
                        ld bc, font_base
                        add hl, bc
                        ex de, hl
dh_font_loop_1          ld b, 4
dh_font_loop_top        ld a, (de)
                        ld (hl), a
                        inc h
                        ld (hl), a
                        inc h
                        inc de
                        djnz dh_font_loop_top
                        ld a, h
                        sub 8
                        ld h, a
                        call screen_to_attr_bc
                        ld a, (upper_col)
                        ld (bc), a
                        rr h
                        rr h
                        rr h
                        ld bc, 32
                        add hl, bc
                        rl h
                        rl h
                        rl h
                        call screen_to_attr_bc
                        ld a, (lower_col)
                        ld (bc), a
                        ld b, 4
dh_font_loop_low        ld a, (de)
                        ld(hl), a
                        inc h
                        ld (hl), a
                        inc h
                        inc de
                        djnz dh_font_loop_low
                        pop hl
                        inc l
                        ret

font_print_test         ld a, 6
                        ld (23693),a ; set our screen colours.
                        call 3503 ; clear the screen.
                        ld a, 0
                        call 8859 ; set the border permanent
                        ld h, 10*8
                        ld l, 12*8
                        ld de, test_message
                        call pr_str_dbl_ht
                        ret

font_char_test          ld a, 6
                        ld (23693), a ; set our screen colours.
                        call 3503 ; clear the screen.
                        ld a, 0
                        call 8859 ; set the border permanent
                        ld h, 10*8
                        ld l, 12*8
                        call hl_to_screen
                        ld de, $1234
                        ld a, 'Q'
                        call pr_char_dbl_ht
                        ld a, 'R'
                        call pr_char_dbl_ht
                        ld a, 'S'
                        call pr_char_dbl_ht
                        ret

test_message            defb "Hello, world!"
                        defb 0
