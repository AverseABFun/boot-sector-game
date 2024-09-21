bits 16

%ifndef VERYCOMMON_S
%define VERYCOMMON_S

%include "src/common.s"

%macro print_text 1
    mov si, %1
    call print
%endmacro

%macro set_cur_pos 2
    mov dh, %1
    mov dl, %2
    call set_cursor_position
%endmacro

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
    mov cl, 00h
    int 10h           ;Call video interrupt

    popa
    ret

blink_cursor:
    pusha

    mov ah, 01h       ;Command
    mov ch, 01000000b ;bits 6-7 unused, bit 5 disables cursor, bits 0-4 control cursor shape
    xor cl, cl
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


push_cursor: ;AL has number of columns
    pusha

    add [cursor_column], al

    cmp byte [cursor_column], 80

    jl pc_end

    pc_loop:
        add byte [cursor_row], 1
        
        cmp byte [cursor_row], 25
        jl pc_cont

        call scroll_up
        sub byte [cursor_row], 1

        pc_cont:
        sub byte [cursor_column], 80

        cmp byte [cursor_column], 80
        jge pc_loop

    pc_end:
    popa
    ret

add_lines: ;AL has number of lines
    pusha
    add [cursor_row], AL

    cmp byte [cursor_row], 0
    jle al_end

    mov byte [cursor_column], 1d

    al_end:
    mov al, 00d
    call push_cursor

    popa
    ret

cursor_column: db 0d ;up to 80
cursor_row: db 1d    ;up to 25

%endif