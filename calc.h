/* Data type for links in the chain of symbols.      */
struct symrec
{
  char *name;  /* name of symbol                     */
  int type;    /* type of symbol: either VAR or FNCT 0==VAR 1==FNCT*/
  int retval;    /* return val if function*/
  char addr[100];           /* value of a VAR          */
  struct symrec *next;    /* link field              */
};

typedef struct symrec symrec;



/* The symbol table: a chain of `struct symrec'.     */
extern symrec *sym_table;

symrec *putsym ();
symrec *getsym ();

typedef struct StmtsNode *stmtsptr;
typedef struct StmtNode *stmtptr;

typedef struct ArgsNode *argsptr;
typedef struct ArgNode *argptr;



struct ArgsNode{
    int singl;
    struct ArgNode *left;
    struct ArgsNode *right;
 };


struct ArgNode{
  char argcode[100];           /* address of arg          */
  struct ArgsNode *down;

};


struct StmtsNode{
    int singl;
    struct StmtNode *left;
    struct StmtsNode *right;
 };



struct StmtNode{
    int isWhile;
    int isFunc;
    int isIf;
    int isFor;
    char initCode[100];
    char initJumpCode[20];
    char bodyCode[1000];
    struct StmtsNode *down;
};




/*void StmtsTrav(stmtsptr ptr);
  void StmtTrav(stmtptr *ptr);*/
