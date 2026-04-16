.text
.global make_node
.global insert
.global get
.global getAtMost



make_node:
# Index of registers
# ra - (16)
# t0 - Value (8)
# t1 - Address of new node (0)

addi sp,sp,-32
mv t0, a0
sd ra, 16(sp)               # Kicking off
sd t0, 8(sp)


li a0, 24
call malloc                 # Allocates memory for the node

mv t1, a0
sd t1, 0(sp)                # Saves new node address to the stack

ld t0, 8(sp)

sw t0, 0(t1)
sd x0, 8(t1)                    # Assigning values to the node
sd x0, 16(t1)


ld ra, 16(sp)
ld t1, 0(sp)                   # Wrap up
addi sp,sp,32
mv a0, t1

ret








insert:
# Index of registers: 
# ra - (56);
# t0 - Address of root (48);
# t1 - Value to be inserted (40);
# t2 - Value of current node;
# t3 - Address of Left node;
# t4 - Address of Right node;


mv t0, a0
mv t1, a1

addi sp,sp,-64
sd ra, 56(sp)
sd t0, 48(sp)
sd t1, 40(sp)

bne t0,x0,insert_1                      # If root is not null, proceed to insert

mv a0,t1
call make_node                          # If root is null, create new node to be root

sd a0, 48(sp)
j wrap_insert



insert_1:
ld t0, 48(sp)
ld t1, 40(sp)
lw t2, 0(t0)
ld t3, 8(t0)
ld t4, 16(t0)


blt t1,t2,left                          # If insert value < current value, go left
j right                                 # Otherwise, go right



left:
beq t3,x0, left_null                    # If left child is null, go to left_null

mv a0, t3
mv a1, t1
call insert                             # Recurse down the left branch

j wrap_insert



left_null:
mv a0,t1
call make_node                          # Creates the new left leaf node

ld t0, 48(sp)
sd a0, 8(t0)                            # Attaches new node to current node's left pointer

j wrap_insert



right:
beq t4, x0, right_null                  # If right child is null, go to right_null

mv a0, t4
mv a1, t1
call insert                             # Recurse down the right branch

j wrap_insert



right_null:
mv a0, t1
call make_node                          # Creates the new right leaf node

ld t0, 48(sp)
sd a0, 16(t0)                           # Attaches new node to current node's right pointer 

j wrap_insert




wrap_insert:
ld ra, 56(sp)
ld t0, 48(sp)
addi sp,sp,64                       # Wrap up
mv a0, t0

ret









get:
# Index of registers
# ra - (56)
# t0 - Address of root (48);
# t1 - Value to find (40);
# t2 - Address to return (32);
# t3 - Value of current node;
# t4 - Address of left branch
# t5 - Address of right branch


mv t0, a0
mv t1, a1

addi sp, sp, -64
sd ra, 56(sp)
sd t0, 48(sp)
sd t1, 40(sp)
li t2, 0                                                # Default return value is 0 (NULL)
sd t2, 32(sp)

beq t0,x0, wrap_get                                     # If node is null, end the function and return 0

lw t3, 0(t0)

blt t1, t3, left_get                                    # If Value is smaller, search left
bgt t1, t3, right_get                                   # If Value is larger, search right

sd t0, 32(sp)                                           # If Value is equal, save node address for returning

j wrap_get


left_get:
ld t4,8(t0)

mv a0, t4
mv a1, t1
call get                                                # Recurse down the left branch

sd a0, 32(sp)

j wrap_get



right_get:
ld t5, 16(t0)

mv a0, t5
mv a1, t1
call get                                                # Recurse down the right branch

sd a0, 32(sp)

j wrap_get



wrap_get:
ld ra, 56(sp)
ld t2, 32(sp)

addi sp,sp,64
mv a0, t2

ret






getAtMost:
# Index of registers
# ra - (56)
# t0 - Value to find (48);
# t1 - Address of root (40);
# t2 - Number to return;
# t3 - Value of current node;
# t4 - Address of Left branch
# t5 - Address of Right branch


mv t0, a0
mv t1, a1

addi sp, sp, -64
sd ra,56(sp)
sd t0, 48(sp)
sd t1, 40(sp)
li t2, -1                                           # Initialize highest valid value to -1

beq t1,x0, wrap_atmost                              # Ends funciton if tree is empty


get_loop:
beq t1, x0, wrap_atmost                             # Stop searching if leaf is null

lw t3,0(t1)
ld t4, 8(t1)
ld t5, 16(t1)

bgt t3, t0, cond1                                   # If current > target, go left to find a smaller one.
mv t2, t3                                           # Else save current as the best 'at most' value so far
mv t1, t5                                           # Move right to see if there's an even larger valid value

j get_loop


cond1:
mv t1,t4                                            # Move left pointer into t1 for next loop iteration

j get_loop



wrap_atmost:
ld ra, 56(sp)

addi sp,sp,64
mv a0, t2

ret
