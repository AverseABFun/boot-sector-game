bits 16

jmp start

%include "src/common.s"
%include "src/verycommon.s"
%include "src/generated/text.s"

start:

call disable_cursor
print_text(hello_world)
hlt