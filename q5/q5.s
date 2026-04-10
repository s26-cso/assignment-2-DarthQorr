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
mv a0, t0
mv a1, t4
li a2, 0
ecall

ld t0,48(sp)

li a7, 63
mv a0, t0
lla a1, characters
li a2, 1
ecall

lla t6, characters
lb t5, 0(t6)
ld t3,24(sp)
ld t4,16(sp)

li t6, 10
beq t6,t5, newline

j loop



newline:
addi t4,t4,-1
sd t4, 16(sp)

ld t0, 48(sp)

li  a7, 62
mv a0, t0
mv a1, t4
li a2, 0
ecall

ld t0,48(sp)

li a7, 63
mv a0, t0
lla a1, characters
li a2, 1
ecall

lla t6, characters
lb t5, 0(t6)
li t6, 10

beq t6,t5, newline

j loop


loop:
bge t3,t4, print_yes



ld t3, 24(sp)
ld t0, 48(sp)

li  a7, 62
mv a0, t0
mv a1, t3
li a2, 0
ecall

ld t0,48(sp)

li a7, 63
mv a0, t0
lla a1, characters
li a2, 1
ecall

lla t6, characters
lb t1, 0(t6)
sd t1, 32(sp)



ld t4, 16(sp)
ld t0, 48(sp)

li  a7, 62
mv a0, t0
mv a1, t4
li a2, 0
ecall

ld t0,48(sp)

li a7, 63
mv a0, t0
lla a1, characters
li a2, 1
ecall

lla t6, characters
lb t2, 0(t6)
sd t2, 40(sp)



ld t1, 32(sp)
ld t3, 24(sp)
ld t4, 16(sp)

bne t1,t2,print_no

addi t3, t3, 1
addi t4, t4, -1
sd t3, 24(sp)
sd t4, 16(sp)

j loop




print_yes:
lla a0,format_yes
call printf

j wrap_up



print_no:
lla a0,format_no
call printf

j wrap_up



wrap_up:
ld ra, 56(sp)
addi sp,sp, 64                      # Finishing it off
li a0, 0
ret 
