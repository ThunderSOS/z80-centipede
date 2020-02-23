

interrupt_setup         di                              ;
                        ld hl, interrupt_service        ;
                        ld ix, #fff0                    ;
                        ld (ix+#04), #c3                ; plonk opcode for jp InterruptService at location 65535 - 13
                        ld (ix+#05), l                  ;
                        ld (ix+#06), h                  ;
                        ld (ix+#0f), #18                ; plonk opcode for jr at 65535, next byte at #0000 is f3 (-13)
                        ld a, #39                       ; interrupt vector table at #3900 (in a secion of ROM containing all 255's)
                        ld i, a                         ; hence cpu executes a jp to 65535 which executes the jr -13
                        im 2                            ; and so we land at the jp InterruptService instruction
                        call init_game                  ; set up and draw main game screen
                        ei                              ; enable interrupts for the game loop
infinite_loop           ld h, 0                         ;
                        ld l, 24*8                      ;
                        call hl_to_screen               ;
                        call display_score_digits       ;
                        jr infinite_loop                ; game background tasks can run here - draw score, lives, etc

interrupt_service       push af, bc, de, hl, ix, iy     ;
                        exx                             ;
                        ex af, af'                      ;
                        push af, bc, de, hl             ;
                        call gameloop                   ;
                        pop hl, de, bc, af              ;
                        ex af, af'                      ;
                        exx                             ;
                        pop iy, ix, hl, de, bc, af      ;
                        ei                              ;
                        reti                            ;
