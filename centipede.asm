; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "centipede"                 ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+
                        zeusmem player, "Player", 9, true, false;
                        zeusmem 22528, "Screen", 32, true, false;

; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                ld sp, $FF40                    ;
                        jp interrupt_setup;             ;

                        include "gameloop.asm"          ;
                        include "mushrooms.asm"         ;
                        include "seg_handler.asm"       ;
                        include "screen.asm"            ;
                        include "player.asm"            ;
                        include "bullet.asm"
                        include "noises.asm"            ;
                        include "sprite.asm"            ;
                        include "sprite_metadata.asm"   ;
                        include "font.asm"              ;
                        include "score.asm"             ;
                        include "util.asm"              ;
                        include "interrupts.asm"        ;


; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1 ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                    ; Tell the emulator where to start
Zeus_SP                 equ $FF40                       ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry ; The szx file

                        output_bin AppFilename+".bin", AppFirst, AppLast-AppFirst+1;

                        output_tap AppFilename+".tap", AppFilename, "", AppFirst, AppLast-AppFirst+1, 0, AppEntry;

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,0,AppEntry ; A tzx file using the loader


