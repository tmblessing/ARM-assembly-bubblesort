    AREA asm_demo, CODE, READONLY
    EXPORT asm_sort
asm_sort   ;Performs bubble sort on dataset provided as an array into argument 0, with the length of the dataset provided as an integer into arg 1
    PUSH {R2-R9, LR}   ;Store registers and LR
    
    SUB R3, R1, #0x2   ;R3 is now how many bubble sort passes we must make (outer loops)(Size of dataset - 2)
    MOV R5, R3         ;How many comparisons the inner loop must make. Will decrease after each pass is completed.
    MOV R4, R0         ;R4 will point to the element we are current at in a sorting pass, initalized to point to the start of the data set
    MOV R6, #0         ;Counter for outer loop, start at 0
    MOV R7, #0         ;Counter for inner loop, start at 0

loop_start             ;Sorting loop
    LDR R8, [R4]       ;Load the element we are currently at
    LDR R9, [R4, #0x04];Load next element
    CMP R8, R9         ;Compare the two elements
    BLE skip_swap      ;If R8 is less than or equal to R9 (they are already in order), jump past the swapping step
    
    STR R9, [R4]       ;Swap the two elements. Store element 2 into the position of element 1
    STR R8, [R4, #0x04];Store element 1 into the position of element 2
    
skip_swap
    ADD R4, R4, #0x04  ;Move R4 pointer to next element in dataset
    ADD R7, R7, #0x01  ;Inner counter ++
    CMP R7, R5         ;Compare the number of comparisons that we have made so far to the number of comparisons that we need to make
    BLE loop_start     ;If we haven`t made enough comparisons yet, jump back to start of sorting loop

;end of inner loop
    PUSH {R0}          ;Save the pointer to the dataset to free up the argument register
    MOV R0, R6         ;Put the counter for the outer loop into R0, so that it will be passed to the my_leds subroutine as an argument
    BL my_leds         ;Start my_leds subroutine
    POP {R0}           ;Restore R0
    
    CMP R6, R3         ;Check to see if we have made enough sorting passes
    BEQ end_loop       ;If enough sorting passes have been made, jump to the end of the loop
    
    ADD R6, R6, #0x1   ;If not, increment the outer counter by 1
    MOV R7, #0         ;Set inner counter back to zero
    SUB R5, R5, #0x1   ;Decrease the number of comparisons we need to make by 1
    MOV R4, R0         ;Set R4 (current element) back to the start of the dataset
    B loop_start       ;Go back to start of loop
    
end_loop    
    POP {R2-R9, LR}    ;Restore registers, including LR
    BX LR              ;Return to C 
    
my_leds                             ;Takes given number in R0 and displays it on LPC1768's onboard LEDs
    PUSH {R1, R2, R3, R4, LR}       ;Save registers
    
    LDR R1, =0x2009C020             ;Address of GPIO registers for port 1
    LDR R2, =0xB40000               ;1's on bits 23, 21, 20, and 18, which corresponds to the pins that the LEDs are on
    STR R2, [R1, #0x1C]             ;Stores R2 in the FIOCLR register of port 1, clearing the LEDs
    
    ;Transforming input from C into pattern that matches pin locations for the onboard LEDs
    ;LEDs are on pins 23, 21, 20, and 18
    ;For example: 0000000000000000000000000001111 needs to be changed to 0000000010110100000000000000000
    
    AND R4, R0, #8                  ;Take just leftmost bit of given number
    AND R3, R3, #0                  ;Clear R3, we will use it to make our bit mask
    ORR R3, R4                      ;Place the taken bit into our mask
    LSL R3, R3, #1                  ;Moves mask left 1 bit
    AND R4, R0, #6                  ;Isolates middle two bits of given number onto R4
    ORR R3, R4                      ;Places these on our mask
    LSL R3, R3, #1                  ;Shifts mask 1 bit, again
    AND R4, R0, #1                  ;Isolates rightmost bit
    ORR R3, R4                      ;Places it onto mask
    LSL R3, R3, #18                 ;Shifts mask 18 bits left, so it lines up with LED pins

    STR R3, [R1, #0x18]             ;Stores mask into FIOSET register, ativating LEDs
    
    BL wait                         ;Call to wait
    POP {R1, R2, R3, R4, LR}        ;Restore registers
    BX LR
    ALIGN                           ;End of function
    
wait                                ;Start of wait subroutine
    PUSH {R1, R2}                   ;Store registers
    MOV.W R1, #1                    ;We are going to use this as the counting variable of our loop, initalize it at 1
    MOV.W R2, #0x1000000            ;This will be the limit for our loop
loop_entry
    CMP R1, R2                      ;Compare R1 and R2
    BGT loop_exit                   ;if R1 is greater than R2, jump to loop_exit
                                    
    ADD R1, R1, #1 ;i++             ;Increment R1 by 1
    B loop_entry                    ;Jump back to start of loop
loop_exit
    POP {R1, R2}                    ;Restore registers
    BX LR                           ;Return from wait
    
    ALIGN
    END