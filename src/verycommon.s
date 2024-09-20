bits 16

%ifndef VERYCOMMON_S
%define VERYCOMMON_S

%include "src/common.s"

%macro print_text 1
    mov si, %1
    call print
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
    mov ch, 00100000b ;bits 6-7 unused, bit 5 disables cursor, bits 0-4 control cursor shape
    mov cl, 00h
    int 10h           ;Call video interrupt

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

%endif