include "emu8086.inc"


data segment                           
    
    new_line db 13, 10, "$"
    
    game_draw db "_|_|_", 13, 10
              db "_|_|_", 13, 10
              db "_|_|_", 13, 10, "$"    
                  
    game_pointer db 9 DUP(?)  
    
    win_flag db 0 
    player db "0$" 
    
    game_over_message db "WOHOOO!", 13, 10, "$"    
    game_start_message db "TIC TAC TOE", 13, 10, "$"
    player_message db "PLAYER $"   
    win_message db " WON!$"   
    type_message db "TYPE A POSITION: $"
ends

stack segment
    dw   128  dup(?)
ends         

extra segment
    
ends

code segment
    
start:       
mov bp,offset VAR
mov di,offset VAR
mov ah, 09h
mov cx, 1000h
mov al, 20h  
mov bl, 4FH;This is red & White.
int 10h
mov     ah,2 ;funtion
mov     dh,5 ;row number
mov     dl,21;column number
mov     bh,0 
int 10h      ;will move the cursor at that particular cell and will print the string
print "*********ALP PACKAGE*********" 
mov     ah,2 ;funtion
mov     dh,6 ;row number
mov     dl,21;column number
mov     bh,0
int 10h
print "         TIC TAC TOE       "
mov     ah,2
mov     dh,14
mov     dl,42
mov     bh,0 
int 10h      ;will move the cursor at that particular cell and will print the string
print "BY"
printn
mov     ah,2 ;funtion 
mov     dh,15;row number
mov     dl,42;column number
mov     bh,0 
int 10h       ;will move the cursor at that particular cell and will print the string
print "GANESHI SHREYA-19PD12"
mov     ah,2 ;funtion 
mov     dh,16;row number
mov     dl,42;column number
mov     bh,0 
int 10h      ;will move the cursor at that particular cell and will print the string
print "S HARIHARAN-19PD27"
mov     ah,2  ;funtion
mov     dh,17 ;row number
mov     dl,42 ;column number
mov     bh,0 
int 10h       ;will move the cursor at that particular cell and will print the string
print "PRESS ANY KEY TO CONTINUE"
;Waits for the user to enter the key 
mov ah,7
int 21h       

L1:
call clear_screen
mov     ah,2 ;funtion
mov     dh,5 ;row number
mov     dl,21;column number
mov     bh,0
int 10h      ;will move the cursor at that particular cell and will print the string
print "PRESS-1 TO LOAD THE GAME"
mov     ah,2 ;funtion
mov     dh,6 ;row number
mov     dl,21;column number
mov     bh,0
int 10h      ;will move the cursor at that particular cell and will print the string
print "PRESS-2 FOR TUTORIAL" 
mov     ah,2  ;funtion
mov     dh,7  ;row number
mov     dl,21 ;column number
mov     bh,0  
int 10h        ;will move the cursor at that particular cell and will print the string
print "PRESS-3 TO QUIT" 
L2:
;getting input from the user
mov ah,1h
int 21h
;compare the input given by the user with 1,2 and 3 inorder to perform the respective task 
cmp al,31h
je  block
cmp al,32h
je tut
cmp al,33h
je quit      ;jumps directly to fim block and will end the program 

;This part will get executed when you enter input other then 1,2 and 3 and will let you enter the valid input again.
mov     ah,2 ;funtion
mov     dh,8  ;row number
mov     dl,21 ;column number
mov     bh,0
int 10h       ;will move the cursor at that particular cell and will print the string
print "ENTER VALID INPUT"

jmp L2
tut:
call clear_screen
printn
print "1.IT'S A TWO PLAYER GAME"
printn
print "2.BY DEFAULT THE FIRST PLAYER'S NAME IS PLAYER-0"
PRINT " AND SECOND PLAYER'S IS PLAYER-1"
print "3.A 3X3 GRID WILL BE DISPLAYED AND EACH PLAYER SHOULD ENTER THE POSITION WHERE HE WANTS TO INSERT HIS KEY IN THE GRID"
printn
print "4.x->PLAYER-0,o->PLAYER-1"
printn
print "5.IF A CELL IN THE GRID IS FILLED THEN DON'T ENTER THE SAME CELL NUMBER AGAIN"
;Waits for the user to enter a key
mov ah,7
int 21h

block:


    ;set segment registers
    mov     ax, data
    mov     ds, ax
    mov     ax, extra
    mov     es, ax

    ;game start   
    call    set_game_pointer    
            
main_loop:  
    call    clear_screen;Will clear screen   
                                         
    lea     dx, game_start_message;Load the offset address of the variable game_start_message in dx
    call    print                 ;Will print the message stored in the variable game_start_message(i.e;TIC TAC TOE)
    
    lea     dx, new_line         ;works as "\n"(in c and c++) 
    call    print                      
    
    lea     dx, player_message   ;Load the offset address of the variable player_message in dx
    call    print                ;Will print the message stored in the variable player_message(i.e;PLAYER)
    
    lea     dx, player           ;Load the offset address of the variable player in dx
    call    print                ;Will print the message stored in the variable player(i.e;0 or 1)
    
                                 ;This whole will look like (PLAYER 0 OR PLAYER 1)  
    
    lea     dx, new_line         
    call    print    
    
    lea     dx, game_draw        ;Load the offset address of the variable game_draw in dx
    call    print                ;Will print grid 
    
    lea     dx, new_line
    call    print    
    
    lea     dx, type_message     ;Load the offset address of the variable type_message in dx
    call    print                ;Will print the message stored in the variable type_message(i.e;TYPE A POSITION)
                        
    ; read draw position                   
    call    read_keyboard        
                       
    ; calculate draw position                   
    sub     al, 49               
    mov     bh, 0
    mov     bl, al                                  
                                  
    call    update_draw                                    
                                                          
    call    check  
                       
    ; check if game ends                   
    cmp     win_flag, 1  
    je      game_over  
    
    call    change_player 
            
    jmp     main_loop   


change_player:   
    lea     si, player    ;Load the offset address of the variable player in si
    xor     ds:[si], 1    ;For changing the player(i.e;0 to 1 and vice versa)
    
    ret                   ;return the player number
      
 
update_draw:
    mov     bl, game_pointer[bx] 
    mov     bh, 0
    
    lea     si, player    ;Load the offset address of the variable player in si
    
    cmp     ds:[si], "0"  ;compare the player number with 0 if its 0 then will jmp to draw_x
    je      draw_x     
                  
    cmp     ds:[si], "1"  ;compare the player number with 1 if its 1 then will jmp to draw_o
    je      draw_o              
                  
    draw_x:
    mov     cl, "x"       ;prints x in the grid if the player number is 0
    jmp     update

    draw_o:          
    mov     cl, "o"      ;prints o in the grid if the player number is 1
    jmp     update    
          
    update:         
    mov     ds:[bx], cl  ;will print x or o in the particular position entered by the player o or by the player 1 
      
    ret 
       
       
check:
    call    check_line   
    ret     
       
;For checking the tictactoe condition i.e;checking for the similar input(x or o) in a line(i.e;horizontal or vertical)       
check_line:
    mov     cx, 0
    
    ;checking for horizontal line(i.e;row)
    check_line_loop:     
    cmp     cx, 0     
    je      first_line
    
    cmp     cx, 1
    je      second_line
    
    cmp     cx, 2
    je      third_line  
    
    call    check_column
    ret                    
        
    first_line:    
    mov     si, 0   
    jmp     do_check_line   

    second_line:    
    mov     si, 3
    jmp     do_check_line
    
    third_line:    
    mov     si, 6
    jmp     do_check_line        

    do_check_line:
    inc     cx
  
    mov     bh, 0
    mov     bl, game_pointer[si]
    mov     al, ds:[bx]
    cmp     al, "_"
    je      check_line_loop
    
    inc     si
    mov     bl, game_pointer[si]    
    cmp     al, ds:[bx]
    jne     check_line_loop 
      
    inc     si
    mov     bl, game_pointer[si]  
    cmp     al, ds:[bx]
    jne     check_line_loop
                 
    ;if the similar input is found in the row then the win message will get displayed                     
    mov     win_flag, 1
    ret         
       
       
;For checking the similar input in vertical line(i.e;column)       
check_column: 
    mov     cx, 0
    
    check_column_loop:     
    cmp     cx, 0
    je      first_column
    
    cmp     cx, 1
    je      second_column
    
    cmp     cx, 2
    je      third_column  
    
    call    check_diagonal
    ret    
        
    first_column:    
    mov     si, 0   
    jmp     do_check_column   

    second_column:    
    mov     si, 1
    jmp     do_check_column
    
    third_column:    
    mov     si, 2
    jmp     do_check_column        

    do_check_column:
    inc     cx
  
    mov     bh, 0
    mov     bl, game_pointer[si]
    mov     al, ds:[bx]
    cmp     al, "_"
    je      check_column_loop
    
    add     si, 3
    mov     bl, game_pointer[si]    
    cmp     al, ds:[bx]
    jne     check_column_loop 
      
    add     si, 3
    mov     bl, game_pointer[si]  
    cmp     al, ds:[bx]
    jne     check_column_loop
                 
    ;if the similar input is found in the column then the win message will get displayed                       
    mov     win_flag, 1
    ret        

;For checking the similar input in two diagonals
check_diagonal:
    mov     cx, 0
    
    check_diagonal_loop:     
    cmp     cx, 0
    je      first_diagonal
    
    cmp     cx, 1
    je      second_diagonal                         
    
    ret    
        
    first_diagonal:    
    mov     si, 0                
    mov     dx, 4 
    jmp     do_check_diagonal   

    second_diagonal:    
    mov     si, 2
    mov     dx, 2
    jmp     do_check_diagonal       

    do_check_diagonal:
    inc     cx
  
    mov     bh, 0
    mov     bl, game_pointer[si]
    mov     al, ds:[bx]
    cmp     al, "_"
    je      check_diagonal_loop
    
    add     si, dx
    mov     bl, game_pointer[si]    
    cmp     al, ds:[bx]
    jne     check_diagonal_loop 
      
    add     si, dx
    mov     bl, game_pointer[si]  
    cmp     al, ds:[bx]
    jne     check_diagonal_loop
                 
    ;if the similar input is found in the column then the win message will get displayed                   
    mov     win_flag, 1
    ret  
           
;if the win flag is 1 then the game is over so it will print the final grid and will display the message(i.e;player 0 or player1 won the game) 
game_over:        
    call    clear_screen   
    
    lea     dx, game_start_message  
    call    print
    
    lea     dx, new_line
    call    print                          
    
    lea     dx, game_draw
    call    print    
    
    lea     dx, new_line
    call    print

    lea     dx, game_over_message
    call    print  
    
    lea     dx, player_message
    call    print

    jmp     fim    
  
;Is necessary to start the game    
set_game_pointer:
    lea     si, game_draw
    lea     bx, game_pointer          
              
    mov     cx, 9   
    
    loop_1:
    cmp     cx, 6
    je      add_1                
    
    cmp     cx, 3
    je      add_1
    
    jmp     add_2 
    
    add_1:
    add     si, 1
    jmp     add_2     
      
    add_2:                                
    mov     ds:[bx], si 
    add     si, 2
                        
    inc     bx               
    loop    loop_1 
 
    ret  
         
       
print:      ; print dx content  
    mov     ah, 9
    int     21h   
    
    ret 
    

clear_screen:       ; get and set video mode
    ;for clearing the screen 
    mov     ah, 0fh
    int     10h   
    
    mov     ah, 0
    int     10h
   
    ;for changing the background color after clearing the screen 
    mov ah, 09h
    mov cx, 1000h
    mov al, 20h
    mov bl, 03fH ;This is cyan and white.
    int 10h
        
    ret
       
;reading the keyboard and return contents into ah 
;It also ensures no repeation/replacement of already filled position with new player's key   
read_keyboard:  
    mov     ah, 1       
    int     21h 
    mov    [di],al
    cmp     di,offset VAR
    je      return
    mov     bp,di  
    
    check1:
        mov  di,offset VAR
    check2:
        cmp [di],al
        je b1
        inc di       
        cmp di,bp
        jl check2
        
    return:
        inc di
        ret
    
    msg: 
        printn
        print "THIS POSITION IS ALREADY FILLED ENTER SOMEOTHER POSITION" 
        jmp read_keyboard
    b1:
        mov di,bp
        jmp msg          
      
;End of game      
fim: 
    lea     dx, player
    call    print
    
    lea     dx, win_message
    call    print
    
    mov ah,7
    int 21h

quit: 
   call clear_screen
    mov     ah,2 ;funtion
    mov     dh,8 ;row number
    mov     dl,35;column number
    mov     bh,0 
    int 10h
   print "THANK YOU!"            
      
code ends
define_get_string
define_print_string

VAR DB dup 9(?)
end start