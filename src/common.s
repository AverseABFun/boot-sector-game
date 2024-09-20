bits 16

%ifndef COMMON_S
%define COMMON_S

printchar: ;Assume that AL has the character in it and BH has the page in it; does not modify general purpose registers
	pusha

	mov ah, 0Eh ;Operation
	mov bl, 00h ;Color in graphics mode, not in the current text mode
	mov cx, 01h ;Number of repetitions

	int 10h

	popa
	ret

print: ;Assume that string starting pointer is in register SI; does not modify general purpose registers
	pusha

	p_next_char:
		mov al, [si]
		inc si
		or al, al
		jz p_end
		mov bh, 00h
		call printchar
		jmp p_next_char
	p_end:
		popa
		ret

%endif