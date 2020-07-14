.data

.text
main:


li $t8,268500992
li $t0, 2
sw $t0,0($t8)

li $t0, 4
sw $t0,4($t8)


li $v0,10
syscall


FuncName0:
li $v0, 1
lw $a0, 0($t8)
syscall
addi $a0, $0, 0xA
addi $v0, $0, 0xB
syscall
jr $ra