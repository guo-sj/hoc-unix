%{
    #define YYSTYPE double  // data type of yacc stack
%}

// part2: yacc declarations: lexical tokens, grammar variables
// precedence and associativity information
%token  NUMBER
%left '+' '-'  // left associative, same precedence
%left '*' '/'  // left assoc., higher precedence

// grammar rules and actions
%%
list:   // nothing
        | list '/n'
        | list expr '/n'   { printf("\t%.8g\n", $2); }
        ;
expr:   NUMBER             { $$ = $1; }  // $$: 整个规则的返回值;
        | expr '+' expr    { $$ = $1 + $3; }  // $1: 代表规则的第一部分，即 expr；$2: 代表规则的第二部分，即 '+'，and so on
        | expr '-' expr    { $$ = $1 - $3; }
        | expr '*' expr    { $$ = $1 * $3; }
        | expr '/' expr    { $$ = $1 / $3; }
        | '(' expr ')'     { $$ = $2; }
        ;
%%


