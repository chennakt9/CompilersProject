%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>  
#include "calc.h"  /* Contains definition of `symrec'        */
int  yylex(void);
void yyerror (char  *);
int whileStart=0,nextJump=0; /*two separate variables not necessary for this application*/

int funcStart=0;

int count=0;
int argcount=1;
int ifcount=0;
int labelCount=0;
FILE *fp;
struct StmtsNode *final;
struct StmtsNode *funcfinal;
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
%token PROGRAM
%token  WRITELN
%token INT
%token VAR_KW   /* "var" keyword */
%token BEGIN_KW  /* "begin" keyword */
%token END_KW    /* "end" keyword */
%token DO_KW     /* "do" keyword */
%token PROCEDURE_KW   /* "procedure" keyword */
%token IF_KW          /* If keyword*/
%token THEN_KW         /*Then keyword*/
%token  <val> NUM        /* Integer   */
%token <val> RELOP
%token  WHILE
%token <tptr> ID 
%type  <c>  exp
%type <nData> x
%type <stmtsptr> stmts
%type <stmtptr> stmt
%type <argsptr> args
%type <argptr> arg
%type <stmtsptr> declr_stmts

%right '='
%left '-' '+'
%left '*' '/'

%start prog




/* Grammar follows */

%%

prog: PROGRAM ID ';' '\n'stmts {printf("Start of the program");final=$5;}

stmts: stmt {$$=(struct StmtsNode *) malloc(sizeof(struct StmtsNode));
   $$->singl=1;$$->left=$1,$$->right=NULL;}
| stmt stmts {$$=(struct StmtsNode *) malloc(sizeof(struct StmtsNode));
   $$->singl=0;$$->left=$1,$$->right=$2;}
     ;

stmt:   
        '\n' {$$=NULL;}

        | VAR_KW '\n' declr_stmts  '\n'                {$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=0;
       $$->isFunc=0;

	    sprintf($$->bodyCode,"\n");
	    $$->down=$3;}

         | BEGIN_KW '\n' stmts  END_KW  '\n'                {printf("Main Function\n");$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=0;
       $$->isFunc=0;

	    sprintf($$->bodyCode,"\n");
	    $$->down=$3;}
       

        | PROCEDURE_KW ID'(' args ')' '\n' BEGIN_KW  stmts END_KW '\n'          {printf("%s","Function Declaration\n");$$=NULL;

         struct StmtNode *temp;
         temp=(struct StmtNode *) malloc(sizeof(struct StmtNode));
         temp->isWhile=0;
         temp->isFunc=1;
         //  sprintf(temp->bodyCode,"%s\nsw $t0,%s($t8)\n", $3, $1->addr);
         temp->down=$8;
         funcfinal = (struct StmtsNode *) malloc(sizeof(struct StmtsNode));
         funcfinal->singl=1;funcfinal->left=temp,funcfinal->right=NULL;

         }   /* Function declaration w/ params*/

        | IF_KW '(' ID RELOP ID ')' THEN_KW '\n' BEGIN_KW stmts  END_KW '\n'                     {printf("If Statement\n");$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=0;
       $$->isFunc=0;
       $$->isIf=1;
       
       sprintf($$->initCode,"lw $t0, %s($t8)\nlw $t1, %s($t8)\n", $3->addr,$5->addr);
	    sprintf($$->initJumpCode,"blt $t0, $t1,");
	    $$->down=$10;}

        | WHILE '(' ID RELOP ID ')' DO_KW  '\n' BEGIN_KW stmts END_KW '\n' {printf("%s","While Loop\n");$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=1;
       $$->isFunc=0;
	    sprintf($$->initCode,"lw $t0, %s($t8)\nlw $t1, %s($t8)\n", $3->addr,$5->addr);
	    sprintf($$->initJumpCode,"bge $t0, $t1,");
	    $$->down=$10;}

         | ID '=' exp ';' '\n'   {printf("Assignment statement\n");$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=0;
       $$->isFunc=0;

	    sprintf($$->bodyCode,"%s\nsw $t0,%s($t8)\n", $3, $1->addr);
	    $$->down=NULL;}

         
                                                                     // lw $t0,   <--4($t8)
                                                                     // sw $t0,-->  8($t8)
         | ID'('args')' ';' '\n' {printf("Function calling\n");$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=0;
       $$->isFunc=0;
	    sprintf($$->bodyCode,"jal FuncName%d\n", funcStart);
	    $$->down=NULL;}



         
         | WRITELN'('ID')'	';' '\n'		{printf("Print Statemant\n"); $$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=0;
       $$->isFunc=0;
	    sprintf($$->bodyCode,"\nli $v0, 1\nlw $a0, %s($t8)\nsyscall\naddi $a0, $0, 0xA\naddi $v0, $0, 0xB\nsyscall\n\n", $3->addr);
	    $$->down=NULL;}

         | error '\n' {yyerrok; }
;
/* Invariant: we store the result of an expression in R0 */


declr_stmts: ID ':' INT ';' '\n' {
   
   $$=(struct StmtsNode *) malloc(sizeof(struct StmtsNode));
   $$->singl=1;$$->left=NULL,$$->right=NULL;
   }
            | ID ':' INT ';' '\n' declr_stmts  {
               $$=(struct StmtsNode *) malloc(sizeof(struct StmtsNode));
   $$->singl=0;$$->left=NULL,$$->right=$6;
   }
            
;



args:  arg                        {$$=(struct ArgsNode *) malloc(sizeof(struct ArgsNode));
                              $$->singl=1;$$->left=$1,$$->right=NULL;}
         | arg ',' args           {printf("ICameHERE  arglist\n");$$=(struct ArgsNode *) malloc(sizeof(struct ArgsNode));
                                    $$->singl=0;$$->left=$1,$$->right=$3; }
    ;
arg:    {$$=NULL;}| ID                            {$$=(struct ArgNode *) malloc(sizeof(struct ArgNode));
                       
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
| ID {sprintf($$, "lw $t%d, %s($t8)",count,$1->addr);count=(count+1)%2;}
   ;
/* End of grammar */
%%

void StmtsTrav(stmtsptr ptr){
//   printf("stmts\n");
  if(ptr==NULL) return;
	  if(ptr->singl==1)StmtTrav(ptr->left);
	  else{
	  StmtTrav(ptr->left);
	  StmtsTrav(ptr->right);
	  }
	  }

void StmtTrav(stmtptr ptr){
   int ws,nj;
   // printf("stmt\n");
   if(ptr==NULL) return;
   if(ptr->isWhile==0){
      if (ptr->isFunc==0){
         fprintf(fp,"%s\n",ptr->bodyCode);
         if(ptr->isIf==1){
            fprintf(fp,"%s\n%sIfLabel%d\nIfLabel%d:\n",ptr->initCode,ptr->initJumpCode,ifcount,ifcount);
         }
         if(ptr->down!=NULL){
            StmtsTrav(ptr->down);
         }
      }
      else if (ptr->isFunc==1){
         int fs=funcStart; funcStart++;
         fprintf(fp,"FuncName%d:\n",fs);
         StmtsTrav(ptr->down);
         fprintf(fp,"jr $ra");

      }
      
   }
   else if (ptr->isWhile==1){
      ws=whileStart; whileStart++;nj=nextJump;nextJump++;
      fprintf(fp,"LabStartWhile%d:%s\n%s NextPart%d\n",ws,ptr->initCode,ptr->initJumpCode,nj);
      StmtsTrav(ptr->down);
      fprintf(fp,"j LabStartWhile%d\nNextPart%d:\n",ws,nj);
   }
	  
}
   


int main ()
{
   fp=fopen("asmb.asm","w");
   fprintf(fp,".data\n\n.text\nmain:\n\n\nli $t8,268500992\n");
   yyparse ();
   StmtsTrav(final);
   fprintf(fp,"\nli $v0,10\nsyscall\n\n\n");
   StmtsTrav(funcfinal);
   fclose(fp);
   
}

void yyerror(char *s)
{   
    extern int yylineno;
    fprintf(stderr,"\nAt line : %d %s  \n\n",yylineno,s);
}



