bits 16

jmp start

%include "src/common.s"
%include "src/verycommon.s"
%include "src/generated/text.s"

start:

call clear_screen

call blink_cursor
print_text hello_world
set_cur_pos 1d, 13d
hlt