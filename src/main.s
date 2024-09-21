bits 16

jmp start

%include "src/common.s"
%include "src/verycommon.s"
%include "src/generated/text.s"

start:

call clear_screen

call blink_cursor
print_text hello_world

mov al, 13d
call push_cursor

mov al, hello_world_lines
call add_lines

set_cur_pos [cursor_row], [cursor_column]

hlt