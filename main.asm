; @Members
; Martin Edgar Atole
; Marco D. Mosna
; Ben Jenon Alpuerto

; Define - I like to do this because it feels like I'm using C++
sys_exit    equ 1 ; System exit
sys_write   equ 4 ; Writing
sys_read    equ 3 ; Read inputs
stdin       equ 0 ; input
stdout      equ 1 ; output

section .data
    ; Target
    ; target db 42
    
    prompt db 'Guess a number between 1 to 100: '
    promptLen equ $ - prompt
    
    ; Message if user guessed the number
    winner db 'Congratulations, you guessed the number correctly!'
    winnerLen equ $ - winner
    
    ; Message if user guessed too high
    too_high db 'Your guess is too high! Try again: '
    highLen equ $ - too_high
    
    ; Message if user guessed too low
    too_low db 'Your guess is too low! Try again: '
    lowLen equ $ - too_low
    
    ; Input variables
    player_guess db 10
    guessLen equ 10

section .bss
    target resb 1 
    
section .text
    global _start
    
_start:
    ; Generate a random number between 0 and 255 (one byte)
    rdrand ax

    ; Calculate the remainder when dividing the random value by 101 (0-100 inclusive)
    xor edx, edx
    mov ecx, 101
    div cx

    ; Store the random number in random_var
    mov byte [target], dl

    
    ; Display prompt message to console
    mov eax, sys_write
    mov ebx, stdout
    mov ecx, prompt
    mov edx, promptLen
    int 80h
    
; If user failed to guess the correct number
; Call guess_number_loop
guess_number_loop:
    ; We read user's input here
    mov eax, sys_read
    mov ebx, stdin
    mov ecx, player_guess
    mov edx, guessLen
    int 80h
    
    ; After getting the user's input
    ; Convert the input into a digit
    mov eax, 0
    mov ecx, player_guess
    
convert_loop:
    cmp byte [ecx], 10        ; Check if end of input
    je check_users_guess
    sub byte [ecx], '0'       ; Convert ASCII digit to number
    imul eax, 10              ; Multiply the current number by 10
    add al, [ecx]             ; Add the converted digit to the number
    inc ecx                   ; Move to the next character
    jmp convert_loop

; This function will compare the number to the target number
check_users_guess:
    ; Compare user's input from the target number
    cmp al, byte [target]
    ; If less, jump to low function (jl = jump if less)
    ; If equal, print congratualtions and exit program (je = jump if equal)
    ; If greater, jump to high function (jg = jump if greater)
    
    je _guess_is_equal
    jg _guess_is_high
    jl _guess_is_less
    
_guess_is_less:
    ; Display guess is too low message
    mov eax, sys_write
    mov ebx, stdout
    mov ecx, too_low
    mov edx, lowLen
    int 80h
    
    ; Jump to guess_number_loop to prompt user
    ; To guess the number again
    jmp guess_number_loop
    
_guess_is_high:
    ; Display guess is too high message    
    mov eax, sys_write
    mov ebx, stdout
    mov ecx, too_high
    mov edx, highLen
    int 80h
    
    ; Jump to guess_number_loop to prompt user
    ; To guess the number again
    jmp guess_number_loop
    
_guess_is_equal:
    ; Display congratulation message
    mov eax, sys_write
    mov ebx, stdout
    mov ecx, winner
    mov edx, winnerLen
    int 80h
    
    ; Terminate
    jmp end
    
end:
    ; Terminate the program
    mov eax, 1
    int 80h
    
; @References
; https://www.youtube.com/watch?v=Xw98IGQvUSo
; and ofcourse, chatGPT
