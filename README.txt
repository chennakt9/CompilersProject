How to compile:
bison -d calc.y
flex tok.l
gcc calc.tab.c lex.yy.c -lfl

-------------------
How to run:
./a.out<test.prog

The output will be asmb.asm. Load asmb.asm in Mars, assemble and run.
---------------------

1. What is the output? The last expression is the output.

2. Put a nextline character at the end of the last statement. 

3. The condition inside the while loop needs to of atomic nature (var relop var).

