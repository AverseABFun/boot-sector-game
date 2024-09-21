bits 16

jmp _main_start

%include "src/common.s"
%include "src/verycommon.s"
%include "src/generated/text.s"
%include "src/options/pong.s"

current_selection db 1

_main_start:

call clear_screen
call disable_cursor
print_raw_text menu

main_loop:
    ; Wait for key press
    call get_char

    cmp al, '1'
    je option1
    cmp al, '2'
    je option2
    cmp al, '3'
    je option3

    jmp main_loop

option1:
    print_raw_text snake_unimplemented
    jmp main_loop

option2:
    call pong_play
    call clear_screen
    call disable_cursor
    print_raw_text menu
    jmp main_loop

option3:
    mov ah,53h            ;this is an APM command
    mov al,00h            ;installation check command
    xor bx,bx             ;device id (0 = APM BIOS)
    int 15h               ;call the BIOS function through interrupt 15h
    jc APM_error          ;if the carry flag is set there was an error
                        ;the function was successful
                        ;AX = APM version number
                            ;AH = Major revision number (in BCD format)
                            ;AL = Minor revision number (also BCD format)
                        ;BX = ASCII characters "P" (in BH) and "M" (in BL)
                        ;CX = APM flags (see the official documentation for more details)
    ;disconnect from any APM interface
    mov ah,53h               ;this is an APM command
    mov al,04h               ;interface disconnect command
    xor bx,bx                ;device id (0 = APM BIOS)
    int 15h                  ;call the BIOS function through interrupt 15h
    jc .disconnect_error            ;if the carry flag is set see what the fuss is about. 
    jmp .no_error

    .disconnect_error:       ;the error code is in ah.
    cmp ah,03h               ;if the error code is anything but 03h there was an error.
    jne APM_error            ;the error code 03h means that no interface was connected in the first place.

    .no_error:
                            ;the function was successful
                            ;Nothing is returned.
    ;connect to an APM interface
    mov ah,53h               ;this is an APM command
    mov al,01h               ;real mode interface
    xor bx,bx                ;device id (0 = APM BIOS)
    int 15h                  ;call the BIOS function through interrupt 15h
    jc APM_error             ;if the carry flag is set there was an error
                            ;the function was successful
                            ;The return values are different for each interface.
                            ;The Real Mode Interface returns nothing.
                            ;See the official documentation for the 
                            ;return values for the protected mode interfaces.
    
    ;Enable power management for all devices
    mov ah,53h              ;this is an APM command
    mov al,08h              ;Change the state of power management...
    mov bx,0001h            ;...on all devices to...
    mov cx,0001h            ;...power management on.
    int 15h                 ;call the BIOS function through interrupt 15h
    jc APM_error            ;if the carry flag is set there was an error

    ;Set the power state for all devices
    mov ah,53h              ;this is an APM command
    mov al,07h              ;Set the power state...
    mov bx,0001h            ;...on all devices to...
    mov cx,03h              ;off
    int 15h                 ;call the BIOS function through interrupt 15h
    jc APM_error            ;if the carry flag is set there was an error
    jmp $

APM_error:
    call clear_screen
    print_raw_text apm_error
    print_raw_text menu
