.data

.text
main:


li $t8,268500992




li $t0, 1
sw $t0,12($t8)

li $t0, 10
sw $t0,16($t8)

lw $t0, 12($t8)
lw $t1, 16($t8)

LabStartWhile0:
add $t0, $t0,1 
bge $t0, $t1, NextPart0

li $v0, 1
lw $a0, 12($t8)
syscall
addi $a0, $0, 0xA
addi $v0, $0, 0xB
syscall


j LabStartWhile0
NextPart0:

li $v0,10
syscall


