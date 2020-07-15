.data

.text
main:


li $t8,268500992




li $t0, 12392272
sw $t0,4($t8)

li $t0, 12392568
sw $t0,8($t8)

li $t0, 12426632
sw $t0,12($t8)

li $t0, 12392696
sw $t0,16($t8)

LabStartWhile0:lw $t0, 16($t8)
lw $t1, 12($t8)

bge $t0, $t1, NextPart0
lw $t0, 4($t8)
sw $t0,20($t8)

lw $t0, 8($t8)
sw $t0,4($t8)

lw $t0, 20($t8)
lw $t1, 8($t8)
add $t0, $t0, $t1
sw $t0,8($t8)


li $v0, 1
lw $a0, 8($t8)
syscall
addi $a0, $0, 0xA
addi $v0, $0, 0xB
syscall


lw $t0, 16($t8)
li $t1, 12392696
add $t0, $t0, $t1
sw $t0,16($t8)

j LabStartWhile0
NextPart0:

li $v0,10
syscall


