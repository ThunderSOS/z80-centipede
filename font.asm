
font_base               equ 15616                       ;
upper_col               defb 6                          ;
lower_col               defb 3                          ;

; print a whole string double height
; (assumed to fit on one line)

; h -> y (must be on an 8 bit boundary)
; l -> x
; de -> string (zero terminated)
pr_str_dbl_ht           call hl_to_screen               ;
pr_str_dbl_ht_lp        ld a, (de)                      ; grab current char
                        and a                           ; is it 0?
                        ret z                           ; return if so, we're done
                        push de                         ; save string position
                        call pr_char_dbl_ht             ; draw this char
                        pop de                          ; restore string position
                        inc de                          ; next char
                        jr pr_str_dbl_ht_lp             ;

; print char double height
; hl -> screen position
; a -> ascii code of char
pr_char_dbl_ht          push hl                         ; backup screen pos on stack
                        ex de, hl                       ; and copy to de whilst we calculate the font address
                        sub 32                          ; printable chars start at ascii 32
                        ld l, a                         ;
                        ld h, 0                         ; hl = a
                        add hl, hl                      ;
                        add hl, hl                      ;
                        add hl, hl                      ; so now hl = (a-32)*8
                        ld bc, font_base                ;
                        add hl, bc                      ; add on font base address and we're done
                        ex de, hl                       ; de now contains font address, hl = screen pos
dh_font_loop_1          ld b, 4                         ; draw the top half
dh_font_loop_top        ld a, (de)                      ; copy the font bytes
                        ld (hl), a                      ;
                        inc h                           ; each byte is copied twice so we get a double height char
                        ld (hl), a                      ;
                        inc h                           ;
                        inc de                          ; next font byte
                        djnz dh_font_loop_top           ;
                        ld a, h                         ; reset screen pos in to order to calculate the attribute address
                        sub 8                           ;
                        ld h, a                         ;
                        call screen_to_attr_bc          ; find the attribute address
                        ld a, (upper_col)               ;
                        ld (bc), a                      ; set the upper colour
                        rr h                            ; move screen pos down by one character row
                        rr h                            ;
                        rr h                            ;
                        ld bc, 32                       ;
                        add hl, bc                      ;
                        rl h                            ;
                        rl h                            ;
                        rl h                            ; done
                        call screen_to_attr_bc          ; get attribute address of new screen pos
                        ld a, (lower_col)               ;
                        ld (bc), a                      ; set the lower colour
                        ld b, 4                         ; draw the bottom half of the char
dh_font_loop_low        ld a, (de)                      ;
                        ld(hl), a                       ;
                        inc h                           ;
                        ld (hl), a                      ;
                        inc h                           ;
                        inc de                          ;
                        djnz dh_font_loop_low           ;
                        pop hl                          ; restore hl
                        inc l                           ; leave hl at next print position
                        ret                             ;

