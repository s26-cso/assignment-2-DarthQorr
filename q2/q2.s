.section .rodata
    format_int: .string "%ld "

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

mv t0, a0
mv t1, a1

addi t0, t0, -1
addi t1, t1, 8

sd t0, 112(sp)
sd t1, 104(sp)

slli a0, t0, 3
call malloc
sd a0, 96(sp)

mv t2, a0
li t5, 0


arrayinit:
beq t5, t0, back

ld t1, 104(sp)
slli t4, t5, 3
add t3, t1, t4
ld a0, 0(t3)

sd t0, 112(sp)
sd t1, 104(sp)
sd t2, 96(sp)
sd t5, 72(sp)

call atoi

ld t0, 112(sp)
ld t1, 104(sp)
ld t2, 96(sp)
ld t5, 72(sp)

slli t4, t5, 3
add t3, t2, t4
sd a0, 0(t3)

addi t5, t5, 1

j arrayinit



back:
ld t1, 96(sp)
sd t1, 104(sp)

ld t0, 112(sp)
slli a0, t0, 3
call malloc         # Initialising Result
sd a0, 96(sp)

ld t0, 112(sp)
slli a0, t0, 3
call malloc         # Initialising Stack
sd a0, 88(sp)

li t4, -1
sd t4, 80(sp)

ld t0, 112(sp)
ld t2, 96(sp)
li t5, 0



result_loop:
beq t5, t0, while_start

slli t6, t5, 3
add t6, t2, t6
li t1, -1
sd t1, 0(t6)
addi t5, t5, 1

j result_loop



while_start:
ld t0, 112(sp)
addi t5, t0, -1
sd t5, 72(sp)

loop:
ld t5, 72(sp)
blt t5, x0, print_setup

subloop1:
ld t4, 80(sp)
li t6, -1
beq t4, t6, subloop3

ld t3, 88(sp)
slli t6, t4, 3
add t6, t3, t6
ld t6, 0(t6)

ld t1, 104(sp)
slli t0, t6, 3
add t0, t1, t0
ld t0, 0(t0)

ld t1, 104(sp)
slli t3, t5, 3
add t3, t1, t3
ld t3, 0(t3)

bgt t0, t3, subloop2

addi t4, t4, -1
sd t4, 80(sp)
j subloop1


subloop2:
ld t4, 80(sp)
ld t3, 88(sp)
slli t6, t4, 3
add t6, t3, t6
ld t6, 0(t6)

ld t2, 96(sp)
slli t0, t5, 3
add t0, t2, t0
sd t6, 0(t0)


subloop3:
ld t4, 80(sp)
addi t4, t4, 1
sd t4, 80(sp)

ld t3, 88(sp)
slli t6, t4, 3
add t6, t3, t6
sd t5, 0(t6)

ld t5, 72(sp)
addi t5, t5, -1
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

lla a0, format_int
call printf

addi t5, t5, 1

j print



wrap_up:
ld ra, 120(sp)
addi sp, sp, 128
li a0, 0
ret
