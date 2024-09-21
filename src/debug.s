bits 16

%ifndef DEBUG_S
%define DEBUG_S

;xchg bx, bx for a magic breakpoint

%macro print_raw_textbochs 1
    mov si, %1
    call printbochs
%endmacro

printbochschar:  ;Assume that AL has the character in it; does not modify general purpose registers
    pusha
    
    out 0xE9, al

    popa
    ret

printbochs: ;Assume that string starting pointer is in register SI; does not modify general purpose registers
	pusha

	pb_next_char:
		mov al, [si]
		inc si
		or al, al
		jz pb_end
		mov bh, 00h
		call printbochschar
		jmp pb_next_char
	pb_end:
		popa
		ret

%endif