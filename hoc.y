%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#define YYSTYPE double  // data type of yacc stack
int yylex();
void yyerror(char *s);
void warning(char *s, char *t);
%}

// part2: yacc declarations: lexical tokens, grammar variables
// precedence and associativity information
%token  NUMBER
%left '+' '-'  // left associative, same precedence
%left '*' '/'  // left associative, higher precedence
%left '%'
%left UNARYMINES UNARYPLUS // unary minus

// grammar rules and actions
%%
list:   // nothing
        | list '\n'
        | list expr '\n'   { printf("\t%.8g\n", $2); }
        ;
expr:   NUMBER             { $$ = $1; }  // $$: 整个规则的返回值;
        | '+' expr %prec UNARYPLUS  { $$ = $2; } // 和 UNARYPLUS 一样的优先级
        | '-' expr %prec UNARYMINES  { $$ = -$2; } // 和 UNARYMINES 一样的优先级
        | expr '+' expr    { $$ = $1 + $3; }  // $1: 代表规则的第一部分，即 expr；$2: 代表规则的第二部分，即 '+'，and so on
        | expr '-' expr    { $$ = $1 - $3; }
        | expr '*' expr    { $$ = $1 * $3; }
        | expr '/' expr    { $$ = $1 / $3; }
        | expr '%' expr    { $$ = fmod($1, $3); }
        | '(' expr ')'     { $$ = $2; }
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
        scanf("%lf", &yylval);
        return NUMBER;
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

int main(int argc, char *argv[])
{
    progname = argv[0];
    yyparse(); // call yylex()
    return 0;
}
