.data

.text
main:


li $t8,268500992




li $t0, 2
sw $t0,4($t8)

li $t0, 3
sw $t0,8($t8)


lw $t0, 4($t8)
lw $t1, 8($t8)

blt $t0, $t1,IfLabel0
IfLabel0:
lw $t0, 4($t8)
lw $t1, 8($t8)
add $t0, $t0, $t1
sw $t0,12($t8)


li $v0, 1
lw $a0, 12($t8)
syscall
addi $a0, $0, 0xA
addi $v0, $0, 0xB
syscall



li $v0,10
syscall


