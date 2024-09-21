bits 16

jmp start

%include "src/common.s"
%include "src/verycommon.s"
%include "src/generated/text.s"

entered_text: times 256 db 0
index: db 0

last_cursor_column: db 0

start:

call clear_screen
call blink_cursor
print_text hello_world

print_raw_text prompt

mov al, [prompt_length]
mov [cursor_column], al

set_cur_pos [cursor_row], [cursor_column]

core_loop:
call get_char
cmp al, 00h
jle core_loop ;no character, keep looping

cmp al, 0Dh ;newline
jne cl_re

call run_cmd

cl_re:
cmp byte [index], 255
je reached_input_limit

mov bx, entered_text
add bx, [index]
mov [bx], al
add byte [index], 1

xor bh, bh
call printchar

add byte [cursor_column], 1
set_cur_pos [cursor_row], [cursor_column]

jmp core_loop

run_cmd:

xor al, al

clear_loop:

mov bx, entered_text
add bx, [index]
mov [bx], al
add byte [index], 1

cmp byte [index], 255
jle clear_loop

mov byte [index], 0

mov byte [cursor_column], 0

add byte [cursor_row], 1
set_cur_pos [cursor_row], [cursor_column]

print_raw_text prompt

mov al, [prompt_length]
mov [cursor_column], al
set_cur_pos [cursor_row], [cursor_column]

ret

reached_input_limit:
xor al, al
call clear_loop

call clear_screen

mov byte [cursor_column], 0
mov byte [cursor_row], 1
set_cur_pos [cursor_row], [cursor_column]

print_raw_text too_much_input

mov byte [cursor_column], 0
mov byte [cursor_row], 2
set_cur_pos [cursor_row], [cursor_column]

print_raw_text prompt

mov al, [prompt_length]
mov [cursor_column], al

set_cur_pos [cursor_row], [cursor_column]

jmp core_loop
