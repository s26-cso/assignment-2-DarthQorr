.section .rodata
    format_int:   .string "%ld"
    format_space: .string " "
    format_nl:    .string "\n"
    format_scan:  .string "%ld"
.text
.global main

main:
# Index of registers
# ra - (120);
# t0 - N (112);
# t1 - Start of Address of numbers (104);
# t2 - Start of Address of result (96);
# t3 - Start of Address of stack (88);
# t4 - top (80);
# t5 - Loop counter(72);
# t6 - Spare

addi sp, sp, -128
sd ra, 120(sp)

li a0, 800000					                    # Allocated large buffer
call malloc
sd a0, 104(sp)                                      # Store Start Address of numbers (arr) at 104(sp)

li t0, 0                                            # Initialize N = 0
sd t0, 112(sp)



arrayinit:
ld t1, 104(sp)
ld t5, 112(sp)
slli t4, t5, 3
add t3, t1, t4                                      # Calculate Address of arr[N]

lla a0, format_scan
mv a1, t3                                           # Store numbers in arr

call scanf

li t4, 1
bne a0, t4, back                             

ld t5, 112(sp)
addi t5, t5, 1                                      # N++
sd t5, 112(sp)

j arrayinit




back:
ld t0, 112(sp)                                      # Load final N into t0
beq t0, x0, wrap_up


slli a0, t0, 3
call malloc                                         # Initialising Result
sd a0, 96(sp)

ld t0, 112(sp)
slli a0, t0, 3
call malloc                                         # Initialising Stack
sd a0, 88(sp)

li t4, -1                                           # Initializes stack 'top' to -1 (empty)
sd t4, 80(sp)

ld t0, 112(sp)
ld t2, 96(sp)
li t5, 0



result_loop:
beq t5, t0, while_start

slli t6, t5, 3
add t6, t2, t6
li t1, -1                                       # result[i] = -1
sd t1, 0(t6)
addi t5, t5, 1

j result_loop



while_start:
ld t0, 112(sp)
addi t5, t0, -1                                 # Start loop counter at i = N - 1
sd t5, 72(sp)

loop:
ld t5, 72(sp)
blt t5, x0, print_setup                         # If i < 0, algorithm is done

subloop1:
ld t4, 80(sp)
li t6, -1
beq t4, t6, subloop3                            # If stack is empty (top == -1), jump to subloop3

ld t3, 88(sp)
slli t6, t4, 3                                  # Load stack[top]
add t6, t3, t6
ld t6, 0(t6)

ld t1, 104(sp)
slli t0, t6, 3
add t0, t1, t0                                  # array[stack[top]]
ld t0, 0(t0)

ld t1, 104(sp)
slli t3, t5, 3
add t3, t1, t3
ld t3, 0(t3)                                    # array[i]

bgt t0, t3, subloop2                            # If array[stack[top]] > array[i], stop popping

addi t4, t4, -1                                 # Pop: top--
sd t4, 80(sp)
j subloop1


subloop2:
ld t4, 80(sp)
ld t3, 88(sp)
slli t6, t4, 3
add t6, t3, t6
ld t6, 0(t6)                                    # Get stack[top] index

ld t2, 96(sp)
slli t0, t5, 3
add t0, t2, t0
sd t6, 0(t0)                                    # result[i] = stack[top]

# Decrement main loop: i--

subloop3:
ld t4, 80(sp)
addi t4, t4, 1                                  
sd t4, 80(sp)                                   # top++

ld t3, 88(sp)
slli t6, t4, 3
add t6, t3, t6                                  # stack[top] = i
sd t5, 0(t6)

ld t5, 72(sp)
addi t5, t5, -1                                 # i--
sd t5, 72(sp)

j loop





print_setup:
li t5, 0

print:
ld t0, 112(sp)
beq t5, t0, wrap_up                             

ld t2, 96(sp)
slli t1, t5, 3
add t1, t2, t1                                  
ld a1, 0(t1)

sd t5, 72(sp)
lla a0, format_int
call printf                                     # Prints the number
ld t5, 72(sp)

ld t0, 112(sp)
addi t0, t0, -1
beq t5, t0, skip_space                          # If it's the last number, skip the space!

sd t5, 72(sp)
lla a0, format_space
call printf                                     # Prints the space
ld t5, 72(sp)

skip_space:
addi t5, t5, 1
j print


wrap_up:
lla a0, format_nl
call printf

ld ra, 120(sp)
addi sp, sp, 128
li a0, 0
ret
