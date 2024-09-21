bits 16

%include "src/common.s"
%include "src/verycommon.s"

%define pong.DIR_UP_RIGHT   00b
%define pong.DIR_DOWN_RIGHT 10b
%define pong.DIR_UP_LEFT    01b
%define pong.DIR_DOWN_LEFT  11b
%define pong.SPEED          01h
%define pong.PADDLE_OFFSET  02h
%define pong.PADDLE_HEIGHT  04h
%define pong.PADDLE_CHAR    0DBh
%define pong.BALL_CHAR      0FEh
%define pong.WIDTH          80d
%define pong.HEIGHT         24d
%define pong.VOFFSET        01d

pong_play:
    call disable_cursor
    call clear_screen
    .loop:
        ;call clear_screen
        call pong_change_ball_pos
        call pong_draw_score
        call pong_draw_ball
        mov cx, 0000fh
        mov dx, 04240h
        call delay
        jmp .loop
    ret

pong_draw_ball:
    mov al, [pong_data.ball.x]
    mov ah, [pong_data.ball.y]
    add ah, pong.VOFFSET
    set_cur_pos ah, al
    mov al, pong.BALL_CHAR
    call printchar
    call disable_cursor

pong_draw_score:
    set_cur_pos 1, 38
    mov al, [pong_data.score.p1]
    add al, '0'
    call printchar

    set_cur_pos 1, 42
    mov al, [pong_data.score.p2]
    add al, '0'
    call printchar

    call disable_cursor

    ret

pong_change_ball_pos:
    call pong_check_ball_pos

    cmp byte [pong_data.ball.dir], pong.DIR_UP_RIGHT
    jne .cont1

    add byte [pong_data.ball.x], pong.SPEED
    sub byte [pong_data.ball.y], pong.SPEED
    ret

    .cont1:
    cmp byte [pong_data.ball.dir], pong.DIR_DOWN_RIGHT
    jne .cont2

    add byte [pong_data.ball.x], pong.SPEED
    add byte [pong_data.ball.y], pong.SPEED
    ret

    .cont2:
    cmp byte [pong_data.ball.dir], pong.DIR_UP_LEFT
    jne .cont3

    sub byte [pong_data.ball.x], pong.SPEED
    sub byte [pong_data.ball.y], pong.SPEED
    ret
    
    .cont3:
    cmp byte [pong_data.ball.dir], pong.DIR_DOWN_LEFT
    jne .end

    sub byte [pong_data.ball.x], pong.SPEED
    add byte [pong_data.ball.y], pong.SPEED
    ret
    
    .end:
    ret

pong_check_ball_pos:
    cmp byte [pong_data.ball.x], 00h
    jne .x2

    add byte [pong_data.score.p1], 1
    mov byte [pong_data.ball.x], 40
    mov byte [pong_data.ball.y], 12

    mov al, [pong_data.score.p1]
    and al, 2
    cmp al, 0
    je .p1score2

    mov byte [pong_data.ball.dir], pong.DIR_DOWN_LEFT
    jmp .end

    .p1score2:
    
    mov byte [pong_data.ball.dir], pong.DIR_UP_RIGHT
    jmp .end

    .x2:

    cmp byte [pong_data.ball.x], pong.WIDTH-1
    jne .y

    add byte [pong_data.score.p2], 1
    mov byte [pong_data.ball.x], 40
    mov byte [pong_data.ball.y], 12

    mov al, [pong_data.score.p1]
    and al, 2
    cmp al, 0
    je .p2score2

    mov byte [pong_data.ball.dir], pong.DIR_UP_RIGHT
    jmp .end

    .p2score2:
    
    mov byte [pong_data.ball.dir], pong.DIR_DOWN_LEFT
    jmp .end

    .y:
    
    cmp byte [pong_data.ball.y], pong.VOFFSET
    je .invert_y

    cmp byte [pong_data.ball.y], pong.HEIGHT
    je .invert_y

    jmp .end

    .invert_y:
    xor byte [pong_data.ball.dir], 10b
    
    .end:
    ret

pong_data:
    .paddle1: db 12
    .paddle2: db 12
    
    .ball.x: db 40
    .ball.y: db 12
    .ball.dir: db pong.DIR_UP_RIGHT

    .score.p1: db 0
    .score.p2: db 0
