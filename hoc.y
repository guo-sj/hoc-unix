%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <signal.h>
#include <setjmp.h>
#include "hoc.h"

// function declaration
int yylex();
void yyerror(char *s);
void warning(char *s, char *t);
void fpecatch();

jmp_buf begin; // 设置恢复状态
%}

// part2: yacc declarations: lexical tokens, grammar variables
// precedence and associativity information
%union {
    double val; // actual value
    Symbol *sym; // symbol table pointer
}
%token <val> NUMBER // terminal token
%token <sym> VAR BLTIN UNDEF
%type <val> expr asgn // non-terminal token

%right '='
%left '+' '-'  // left associative, same precedence
%left '*' '/'  // left associative, higher precedence
%left '%'
%left UNARYMINES UNARYPLUS // unary minus
%right '^' /* exponentiation */

// grammar rules and actions
%%
list:   // nothing
        | list '\n'
        | list asgn '\n'
        | list expr ';'
        | list expr '\n'   { printf("\t%.8g\n", $2); }
        | list error '\n'  { yyerrork; } /* yyerrork 这个是个宏定义 */
        ;
asgn:     VAR '=' expr { $$ = $1->u.val = $3; $1->type = VAR; }
        ;
expr:   NUMBER
        | VAR              { if ($1->type == UNDEF)
                                 execerror("undefined variable", $1->name);
                             $$ = $1->u.val; }
        | asgn
        | BLTIN '(' expr ')' { $$ = (*($1->u.ptr))($3); }
        | expr '+' expr    { $$ = $1 + $3; }  // $1: 代表规则的第一部分，即 expr；$2: 代表规则的第二部分，即 '+'，and so on
        | expr '-' expr    { $$ = $1 - $3; }
        | expr '*' expr    { $$ = $1 * $3; }
        | expr '/' expr    { 
                if ($3 == 0.0) {
                    execerror("division by zero", "");
                }
                $$ = $1 / $3; }
        | expr '^' expr { $$ = Pow($1, $3); }
        | expr '%' expr    { $$ = fmod($1, $3); }
        | '(' expr ')'     { $$ = $2; }
        | '+' expr %prec UNARYPLUS  { $$ = $2; } // 和 UNARYPLUS 一样的优先级
        | '-' expr %prec UNARYMINES  { $$ = -$2; } // 和 UNARYMINES 一样的优先级
        ;
%%

char *progname;
int lineno = 1;

// yylex return type of token, the value of token is stored in `yylval`
int yylex()
{
    int c;
    while ((c=getchar()) == ' ' || c == '\t')
        ;
    if (c == EOF) {
        return 0;
    }
    if (c == '.' || isdigit(c)) {
        ungetc(c, stdin);
        scanf("%lf", &yylval.val);
        return NUMBER;
    }
    if (isalpha(c)) {
        Symbol *s;
        char sbuf[100], *p = sbuf;
        do {
            *p++ = c;
        } while ((c=getchar()) != EOF && isalnum(c));
        ungetc(c, stdin);
        *p = '\0';
        if ((s=lookup(sbuf)) == 0) {
            s = install(sbuf, UNDEF, 0.0);
        }
        yylval.sym = s;
        return s->type == UNDEF ? VAR : s->type;
    }
    if (c == '\n') {
        lineno++;
    }
    return c;
}

// 如果解析错误，yyparse 会调用 yyerror
void yyerror(char *s)
{
   warning(s, (char *)0);
}

void warning(char *s, char *t)
{
    fprintf(stderr, "%s: %s", progname, s);
    if (t) {
        fprintf(stderr, " %s", t);
    }
    fprintf(stderr, " near line %d\n", lineno);
}

void execerror(char *s, char *t)
{
    warning(s, t);
    longjmp(begin, 0);
}

void fpecatch()
{
    execerror("floating point exception", (char *)0);
}

int main(int argc, char *argv[])
{
    progname = argv[0];
    init();
    setjmp(begin);
    signal(SIGFPE, fpecatch);
    yyparse(); // call yylex()
    return 0;
}
