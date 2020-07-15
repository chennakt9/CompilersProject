### Team Members
* Peeyush Dyavarashetty (17110053)
* Prudhvi Kakumani (17110066)
* Pittala Nikhil (17110108)
* Chenna Kesava  (17110039)

#### How to compile:
```sh
bison -d calc.y
flex tok.l
gcc calc.tab.c lex.yy.c -lfl
```

-------------------
#### How to run the test files :
```sh
./a<tests/double.prog
./a<tests/expressions.prog
./a<tests/Fibonocci.prog
./a<tests/if.prog
./a<tests/Procedure.prog
./a<tests/template.prog

```
> ## Our code can compile the following 
* if
* for
* while
* nested while
* procedures
* print statement
* 


###### The output will be asmb.asm. Load asmb.asm in Mars, assemble and run.
---------------------

1. What is the output? The last expression is the output.

2. Put a nextline character at the end of the last statement. 

3. The condition inside the while loop needs to of atomic nature (var relop var).

#### Below is a sample output file
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

blt $t0, $t1,IfLabel0<br>
IfLabel0:<br>
lw $t0, 4($t8)<br>
lw $t1, 8($t8)<br>
add $t0, $t0, $t1<br>
sw $t0,12($t8)<br>


li $v0, 1<br>
lw $a0, 12($t8)<br>
syscall<br>
addi $a0, $0, 0xA<br>
addi $v0, $0, 0xB<br>
syscall



li $v0,10
syscall



#### Basic Structure of a Pascal Program

>program {name of the program}
>uses {comma delimited names of libraries you use}
>const {global constant declaration block}
>var {global variable declaration block}
>
>function {function declarations, Procedure any}
>{ local variables }
>begin
>...
>end;
>
>procedure { procedure declarations, if any}
>{ local variables }
>begin
>...
>end;
>
>begin { main program block starts}
>...
>end. { the end of main program block }
