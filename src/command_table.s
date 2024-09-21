bits 16

%ifndef COMMAND_TABLE_S
%define COMMAND_TABLE_S

%include "src/commands.s"

%define number_of_commands 1
commands_table:
    help_command_t_entry:
        dw 4            ;Length of name
        db "help"       ;Name
        dw help_command ;Address to call

%endif