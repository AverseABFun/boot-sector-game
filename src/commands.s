bits 16

%ifndef COMMANDS_S
%define COMMANDS_S

%include "src/common.s"
%include "src/verycommon.s"
%include "src/generated/text.s"

help_command:
    print_text help_text
    ret

%endif