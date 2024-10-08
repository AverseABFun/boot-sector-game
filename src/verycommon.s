bits 16

%ifndef VERYCOMMON_S
%define VERYCOMMON_S

%include "src/common.s"

%macro print_raw_text 1
    mov si, %1
    call print
%endmacro

%macro print_text 1
    mov si, %1
    call print
    mov al, [%1_lines]
    call add_lines
    mov al, [%1_length]
    add [cursor_column], al
    set_cur_pos [cursor_row], [cursor_column]
%endmacro

%macro set_cur_pos 2
    mov dh, %1
    mov dl, %2
    call set_cursor_position
%endmacro

delay: ;CX:DX Number of microseconds to elapse
    pusha

    mov ah, 86h
    int 83h

    popa
    ret

disable_cursor:
    pusha

    mov ah, 01h       ;Command
    mov ch, 00100000b ;bits 6-7 unused, bit 5 disables cursor, bits 0-4 control cursor shape
    mov cl, 00h
    int 10h           ;Call video interrupt

    popa
    ret

enable_cursor:
    pusha

    mov ah, 01h       ;Command
    mov ch, 00000000b ;bits 6-7 unused, bit 5 disables cursor, bits 0-4 control cursor shape
    mov cl, 0Fh
    int 10h           ;Call video interrupt

    popa
    ret

blink_cursor:
    pusha

    mov ah, 01h       ;Command
    mov ch, 01000000b ;bits 6-7 unused, bit 5 disables cursor, bits 0-4 control cursor shape
    mov cl, 0Fh
    int 10h           ;Call video interrupt

    popa
    ret

set_cursor_position: ;Assume that dh and dl have row and column, respectively.
    pusha

    mov ah, 02h ;Command
    mov bh, 00h ;Page
    int 10h

    popa
    ret

clear_screen:
    pusha
    
    mov ax, 03h
    int 10h

    popa
    ret

set_background:
    pusha

    mov ah, 0Bh ;Command
    mov bh, 00h ;Apparently to prevent issues
    mov bl, 01h ;Color
    int 10h     ;Call video interrupt

    popa
    ret

scroll_up: ;http://www.ctyme.com/intr/rb-0096.htm
    pusha

    mov ah, 06h ;Commmand
    mov al, 01h ;Number of rows
    mov bh, 00h ;Attribute
    mov ch, 00h
    mov cl, 00h
    mov dh, 25h
    mov dl, 80h
    int 10h

    popa
    ret

add_lines: ;AL has number of lines
    pusha
    add byte [cursor_row], al

    mov byte [cursor_column], 0

    mov al, [cursor_row]

    cmp al, 25
    jl al_end

    scroll_loop:
    call scroll_up

    sub al, 1

    cmp al, 25
    jge scroll_loop

    mov [cursor_row], al

    al_end:
    popa
    ret

cursor_column: db 0 ;up to 80
cursor_row: db 1    ;up to 25

%define SC_UP_ARROW 48h
%define SC_DOWN_ARROW 50h
%define SC_LEFT_ARROW 4Bh
%define SC_RIGHT_ARROW 4Dh

get_char:
    mov ah, 00h
    int 16h
    ret

%endif