%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>  
#include "calc.h"  /* Contains definition of `symrec'        */
int  yylex(void);
void yyerror (char  *);
int whileStart=0,nextJump=0; /*two separate variables not necessary for this application*/
int count=0;
int argcount=1;
int labelCount=0;
FILE *fp;
struct StmtsNode *final;
struct ArgsNode *argfinal;
void StmtsTrav(stmtsptr ptr);
void StmtTrav(stmtptr ptr);
%}


%union {
int   val;  /* For returning numbers.                   */
struct symrec  *tptr;   /* For returning symbol-table pointers      */
char c[1000];
char cc[1000];
char nData[100];
struct StmtNode *stmtptr;
struct StmtsNode *stmtsptr;
struct ArgNode *argptr;
struct ArgsNode *argsptr;

}


/* The above will cause a #line directive to come in calc.tab.h.  The #line directive is typically used by program generators to cause error messages to refer to the original source file instead of to the generated program. */

%token  PRINT
%token  <val> NUM        /* Integer   */
%token <val> RELOP
%token  WHILE
%token <tptr> VAR 
%type  <c>  exp
%type <nData> x
%type <stmtsptr> stmts
%type <stmtptr> stmt
%type <argsptr> args
%type <argptr> arg

%right '='
%left '-' '+'
%left '*' '/'


/* Grammar follows */

%%
prog: stmts {printf("Hiiiii %d End",($1->left));final=$1;}
stmts: stmt {$$=(struct StmtsNode *) malloc(sizeof(struct StmtsNode));
   $$->singl=1;$$->left=$1,$$->right=NULL;}
| stmt stmts {$$=(struct StmtsNode *) malloc(sizeof(struct StmtsNode));
   $$->singl=0;$$->left=$1,$$->right=$2;}
     ;

stmt:   
        '\n' {$$=NULL;}

        | VAR'(' args ')' '{' stmts '}'          {printf("%s","ICameHERE  just function")}   /* Function declaration w/ params*/

        | WHILE '(' VAR RELOP VAR ')' '{' stmts '}' '\n' {$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=1;
	    sprintf($$->initCode,"lw $t0, %s($t8)\nlw $t1, %s($t8)\n", $3->addr,$5->addr);
	    sprintf($$->initJumpCode,"bge $t0, $t1,");
	    $$->down=$8;}

         | VAR '=' exp '\n'   {printf("Test1");$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=0;
	    sprintf($$->bodyCode,"%s\nsw $t0,%s($t8)\n", $3, $1->addr);
	    $$->down=NULL;}

         | VAR '=' VAR'('')'  {printf("ICameHERE  functioncall\n");$1->type = 1; }  /* Function Call w/o params*/

         | VAR '=' VAR'('args')'  {printf("ICameHERE  functioncall\n");$1->type = 1; }   /* Function Call w/ params*/


         
         | PRINT VAR 			{printf("Printing %d\n", $2); $$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=0;
	    sprintf($$->bodyCode,"li $v0, 1\nlw $a0, %s($t8)\nsyscall\naddi $a0, $0, 0xA\naddi $v0, $0, 0xB\nsyscall", $2->addr);
	    $$->down=NULL;}

         | error '\n' { yyerrok; }
;
/* Invariant: we store the result of an expression in R0 */





args:  arg                        {$$=(struct ArgsNode *) malloc(sizeof(struct ArgsNode));
                              $$->singl=1;$$->left=$1,$$->right=NULL;}
         | arg ',' args           {printf("ICameHERE  arglist\n");$$=(struct ArgsNode *) malloc(sizeof(struct ArgsNode));
                                    $$->singl=0;$$->left=$1,$$->right=$3; }
    ;
arg:    VAR                            {$$=(struct ArgNode *) malloc(sizeof(struct ArgNode));
                       
                        sprintf($$->argcode, "addi $a%d, $zero, %s($t8)",argcount,$1->addr);argcount=(argcount+1)%4;if(argcount==0)argcount=1;
                        $$->down=NULL;}
;




exp:      x                { sprintf($$,"%s",$1);count=(count+1)%2;}
        | x '+' x  { sprintf($$,"%s\n%s\nadd $t0, $t0, $t1",$1,$3);}
        | x '-' x        { sprintf($$,"%s\n%s\nsub $t0, $t0, $t1",$1,$3);}
        | x '*' x        { sprintf($$,"%s\n%s\nmul $t0, $t0, $t1",$1,$3);}
        | x '/' x        { sprintf($$,"%s\n%s\ndiv $t0, $t0, $t1",$1,$3);}
;
x:   NUM {sprintf($$,"li $t%d, %d",count,$1);count=(count+1)%2;}
| VAR {sprintf($$, "lw $t%d, %s($t8)",count,$1->addr);count=(count+1)%2;}
   ;
/* End of grammar */
%%

void StmtsTrav(stmtsptr ptr){
  printf("stmts\n");
  if(ptr==NULL) return;
	  if(ptr->singl==1)StmtTrav(ptr->left);
	  else{
	  StmtTrav(ptr->left);
	  StmtsTrav(ptr->right);
	  }
	  }

void StmtTrav(stmtptr ptr){
   int ws,nj;
   printf("stmt\n");
   if(ptr==NULL) return;
   if(ptr->isWhile==0){fprintf(fp,"%s\n",ptr->bodyCode);}
   else{ws=whileStart; whileStart++;nj=nextJump;nextJump++;
     fprintf(fp,"LabStartWhile%d:%s\n%s NextPart%d\n",ws,ptr->initCode,ptr->initJumpCode,nj);StmtsTrav(ptr->down);
     fprintf(fp,"j LabStartWhile%d\nNextPart%d:\n",ws,nj);}
	  
}
   


int main ()
{
   fp=fopen("asmb.asm","w");
   fprintf(fp,".data\n\n.text\nmain:\n\n\nli $t8,268500992\n");
   yyparse ();
   StmtsTrav(final);
   fprintf(fp,"\nli $v0,10\nsyscall\n");
   fclose(fp);
   // https://stackoverflow.com/questions/45186052/how-to-write-yacc-grammar-rules-to-identify-function-definitions-vs-function-cal
}

void yyerror (char *s)  /* Called by yyparse on error */
{
  printf ("Error : %s\n", s);
}



