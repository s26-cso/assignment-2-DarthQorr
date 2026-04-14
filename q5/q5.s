.section .rodata
    filename: .string "input.txt"   # The null-terminated file name
    format_integer:     .string "%ld\n"
    format_char:        .string "%c\n"
    format_string:      .string "%s\n"
    format_yes:         .string "Yes\n"
    format_no:          .string "No\n"

.section .bss
    characters: .space 1

.text
.global main


# Index of registers:
# t0 - File Descriptor(48);
# t1 - Length of file(32) / Left Text(32);
# t2 - Text of file(40) / Right Text(40);
# t3 - left pointer(24);
# t4 - right pointer(16)
# t6 - 10 / Crutch;

main:
addi sp,sp,-64
sd ra,56(sp)



li a7, 56
li a0, -100
lla a1, filename                    # Summons File Descriptor of input.txt
li a2, 0
li a3, 0
ecall

mv t0, a0                       
sd t0, 48(sp)                       # Saves File Descriptor in Memory at 48



li a7, 62
mv a0, t0
li a1, 0                            # Gets us length of file at t1
li a2, 2
ecall

mv t1, a0
sd t1, 32(sp)



li t3, 0
addi t3, t3,0                       # Setting up Left and Right pointer
addi t4, t1,-1
sd t3, 24(sp)
sd t4, 16(sp)       



ld t0, 48(sp)

li  a7, 62
mv a0, t0                           # Moves file offset to right pointer
mv a1, t4
li a2, 0
ecall

ld t0,48(sp)

li a7, 63                           # Loads rightmost byte into buffer
mv a0, t0
lla a1, characters
li a2, 1
ecall

lla t6, characters
lb t5, 0(t6)                        # Loads that read byte into t5
ld t3,24(sp)
ld t4,16(sp)

li t6, 10
beq t6,t5, newline                  # If byte is '\n' (10), jump to handle it

j loop



newline:                            # This loop gets rid of all newlines to the right
addi t4,t4,-1                       # Moves right pointer back 1 to skip newline
sd t4, 16(sp)

ld t0, 48(sp)

li  a7, 62
mv a0, t0
mv a1, t4                           # Moves offset to the new right pointer
li a2, 0
ecall

ld t0,48(sp)

li a7, 63
mv a0, t0
lla a1, characters                  # Grabs the new last character and puts it in buffer
li a2, 1
ecall

lla t6, characters                  
lb t5, 0(t6)
li t6, 10

beq t6,t5, newline                  # If it's another newline, loop back and skip it again

j loop


loop:
bge t3,t4, print_yes                # If left >= right without violating the equality constrant, the string is a palindrome!


ld t3, 24(sp)
ld t0, 48(sp)

li  a7, 62                          # Seek to the current left pointer
mv a0, t0
mv a1, t3
li a2, 0
ecall

ld t0,48(sp)

li a7, 63
mv a0, t0                           # Reads the left character
lla a1, characters
li a2, 1
ecall

lla t6, characters                  # Stores the left character in memory
lb t1, 0(t6)
sd t1, 32(sp)



ld t4, 16(sp)
ld t0, 48(sp)

li  a7, 62
mv a0, t0
mv a1, t4                           # Seek to the current right pointer
li a2, 0
ecall

ld t0,48(sp)

li a7, 63
mv a0, t0
lla a1, characters                  # Read the right character
li a2, 1
ecall

lla t6, characters
lb t2, 0(t6)                        # Stores the right character in memory
sd t2, 40(sp)



ld t1, 32(sp)
ld t3, 24(sp)                       # Reloads registers
ld t4, 16(sp)

bne t1,t2,print_no                  # Mismatch found, not a palindrome

addi t3, t3, 1                      # Move left pointer forward
addi t4, t4, -1                     # Move right pointer backward
sd t3, 24(sp)
sd t4, 16(sp)

j loop                              # Repeat for the next pair of characters




print_yes:
lla a0,format_yes                   # Prints yes
call printf

j wrap_up



print_no:
lla a0,format_no                    # Prints no
call printf

j wrap_up



wrap_up:
ld ra, 56(sp)
addi sp,sp, 64                      # Finishing it off
li a0, 0
ret 
