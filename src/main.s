bits 16

jmp start

%include "src/common.s"
%include "src/verycommon.s"
%include "src/generated/text.s"
%include "src/command_table.s"

entered_text: times 256 db 0
index: dw 0

last_cursor_column: db 0

start:

call clear_screen
call blink_cursor
print_text hello_world

