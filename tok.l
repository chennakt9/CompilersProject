%{
#include "calc.tab.h"
#include "calc.h"
#include<stdlib.h>
#include <string.h>

int Adr=0;
symrec *sym_table = (symrec *)0;
%}


number [0-9]+
id [a-z]+


%%
[ ] {}
"while" {return WHILE;}
"print" {return PRINT;}
"<"   {yylval.val=2;return RELOP;}
{number} {sscanf(yytext,"%d",&yylval.val);printf("%d  %d\n",yylval.val,yytext);return NUM;}
{id} {symrec *s;s=getsym(yytext); if(s==0) s=putsym(yytext,VAR);s->type = 0;s->retval = 101;yylval.tptr=s;return VAR;}

\n|.  {return yytext[0];}
%%

/* The symbol table: a chain of `struct symrec'.  */


symrec * putsym (char *sym_name,int sym_type){
  symrec *ptr;
  ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  sprintf(ptr->addr,"%d",Adr); /* set value to 0 even if fctn.  */
  Adr=Adr+4;
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec *getsym (char *sym_name){
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name,sym_name) == 0)
      return ptr;
  return 0;
}

