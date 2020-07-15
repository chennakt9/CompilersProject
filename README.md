#### How to compile:
```sh
bison -d calc.y
flex tok.l
gcc calc.tab.c lex.yy.c -lfl
```

-------------------
#### How to run:
```sh
./a<tests/Fibonocci.prog
```

######The output will be asmb.asm. Load asmb.asm in Mars, assemble and run.
---------------------

1. What is the output? The last expression is the output.

2. Put a nextline character at the end of the last statement. 

3. The condition inside the while loop needs to of atomic nature (var relop var).

#### Basic Structure of a Pascal Program

>program {name of the program}
>uses {comma delimited names of libraries you use}
>const {global constant declaration block}
>var {global variable declaration block}
>
>function {function declarations, if any}
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

