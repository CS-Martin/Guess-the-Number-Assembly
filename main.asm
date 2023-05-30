; Defining vars
sys_exit equ 1 ; System Exit
sys_read equ 3
sys_write equ 4
stdin equ 0
stdout equ 1

section .text
    global _start

    _start:
        ; Print "enter first number: "
        mov eax, sys_write
        mov ebx, stdout
        mov ecx, firstNum
        mov edx, lenFirstNum
        int 0x80
        
        ; Get input for first number
        mov eax, sys_read
        mov ebx, stdin
        mov ecx, num1
        mov edx, 2
        int 0x80
        
        ; Print "enter second number: "
        mov eax, sys_write
        mov ebx, stdout
        mov ecx, secondNum
        mov edx, lenSecondNum
        int 0x80
        
        ; Get input for the second number
        mov eax, sys_read
        mov ebx, stdin
        mov ecx, num2
        mov edx, 2
        int 0x80
        
        ; Print "enter third number: "
        mov eax, sys_write
        mov ebx, stdout
        mov ecx, thirdNum
        mov edx, lenThirdNum
        int 0x80
        
        ; Get input for the third number
        mov eax, sys_read
        mov ebx, stdin
        mov ecx, num3
        mov edx, 2
        int 0x80
        
        ; Print "Largest Number: "
        mov eax, sys_write
        mov ebx, stdout
        mov ecx, largest
        mov edx, lenLargest
        int 0x80
        
        ; Assembly interprets inputs as characters
        ; So I need to convert it to integer
        ; To do that:
        mov al, [num1]      ; al is 8-bit char size register
        sub al, '0'         ; convert to integer
         
        mov ah, [num2]
        sub ah, '0'
        
        ; Compare num1 and num2 to determine which is greater or lesser
        cmp al, ah ; al = num1, ah = num2
        jg _greater ; Jump if greater
        jl _lesser  ; Jump if lesser 
        
        ; If _greater, then num1 > num2
        _greater:
            ; Have to convert everything to integer once again
            mov al, [num1]
            sub al, '0'
            mov ah, [num3]
            sub ah, '0'
            ; Compare num1 to num3
            cmp al, ah
            jl _printNum3
            
            ; Else num1 is greater
            ; Print out num1
            mov eax, sys_write
            mov ebx, stdout
            mov ecx, num1
            mov edx, 2
            int 0x80
            jmp _leastVal
        
        ; if _lesser, num2 > num1
        _lesser:
            ; Convert to int
            mov al, [num2]
            sub al, '0'
            mov ah, [num3]
            sub ah, '0'
            ; Compare num2 to num3
            cmp al, ah
            jl _printNum3
            
            ; Else num2 is greater
            ; Print out num 2
            mov eax, sys_write
            mov ebx, stdout
            mov ecx, num2
            mov edx, 2
            int 0x80
            jmp _leastVal
        
        ; If neither num1 or num2, then num3 is greater
        _printNum3:
            mov eax, sys_write
            mov ebx, stdout
            mov ecx, num3
            mov edx, 2
            int 0x80
            jmp _leastVal
            
        ; This is where finding the lowest value starts
        _leastVal:
            ; Print "Smallest Number: "
            mov eax, sys_write
            mov ebx, stdout
            mov ecx, smallest
            mov edx, lenSmallest
            int 0x80
            
            ; Convert chars to integers once again
            mov al, [num1]
            sub al, '0'
            mov ah, [num2] 
            sub ah, '0'
            cmp al, ah
            jl _num1Lesser
            jg _num2Lesser
            
            ; Then num1 < num2
            _num1Lesser:
                mov al, [num1]
                sub al, '0'
                mov ah, [num3]
                sub ah, '0'
                ; Compare which is the lowest
                cmp al, ah
                jg _printNum3Lowest
                
                ; Else, num1 is the lowest value among 3 numbers
                ; Print num1
                mov eax, sys_write
                mov ebx, stdout
                mov ecx, num1
                mov edx, 2
                int 0x80
                
            ; Then num2 < num1
            _num2Lesser:
                mov al, [num2]
                sub al, '0'
                mov ah, [num3]
                sub ah, '0'
                ; Compare which number is the lowest
                cmp al, ah
                jg _printNum3Lowest
                
                ; Else, num2 is the lowest value among the three
                ; PRint num2
                mov eax, sys_write
                mov ebx, stdout
                mov ecx, num2
                mov edx, 2
                int 0x80
                
            _printNum3Lowest:
                mov eax, sys_write
                mov ebx, stdout
                mov ecx, num3
                mov edx, 2
                int 0x80
            
        ; System call to Exit
        mov eax, 1
        mov ebx, 0
        int 0x80
        
; Section that contains uninitialized variables
section .bss
    ; 2 can only contain 1 digit variable
    num1 resb 2 ; First var
    num2 resb 2 ; Second var
    num3 resb 2 ; Third var

section .data
    firstNum db 'Enter first number: '
    lenFirstNum equ $ - firstNum
    
    secondNum db 0xa, 'Enter second number: '
    lenSecondNum equ $ - secondNum
    
    thirdNum db 0xa, 'Enter third number: '
    lenThirdNum equ $ - thirdNum
    
    largest db 0xa, 'Largest Number: '
    lenLargest equ $ - largest
    
    smallest db 'Smallest Number: '
    lenSmallest equ $ - smallest