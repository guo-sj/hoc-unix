typedef struct Symbol { /* symbol table entry */
    char *name;
    short type; /* VAR, BLTIN, UNDEF */
    union {
        double val; /* if VAR */
        double (*ptr)(double); /* if BLTIN */
    } u;
    struct Symbol *next; /* to link to another */
} Symbol;
Symbol *install(char *s, int t, double d);
Symbol *lookup(char *s);
void init();
void execerror(char *s, char *t);
double Pow(double x, double y);
double Log(double x);
double Log10(double x);
double Exp(double x);
double Sqrt(double x);
double integer(double x);
