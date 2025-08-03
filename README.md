# hoc-unix

这个语言源自《The UNIX Programming Environment》的第八章的 hoc 语言，并把习题中要求的
功能尽可能的加上。

目的是了解如何使用 yacc，make 等工具在 UNIX 编程环境中写一个 non-trivial 程序 -- 一个
编程语言的 Interpreter。程序分 6 步：
1. 一个支持四则运算的计算器。支持 +，-，\*，/ 和 `()`；支持符点数运算

Exercise 8-1. Examine the structure of the y.tab.c file. (It's about 300 lines long for hoc1)

Anwser: 事实上，使用 `bison` 生成的 `hoc.tab.c` 有 1611 行。

Exercise 8-2. Add the operators % (modulus or remainder) and unary + to hoc1. Suggestion: loot at frexp(3).

Answer: see [this commit.](https://github.com/guo-sj/hoc-unix/commit/d3416b36fa9f9324f40562255298930cbece7f3d)

2. 支持变量 a-z，以及单目运算符`-`

Exercise 8-3. Add a facility for remembering the most recent value computed, so that it does not have to be retyped in a sequence of related computations. One solution is to make it one of the variables, for instance 'p' for previous.

Answer: see [this commit.](https://github.com/guo-sj/hoc-unix/commit/3bbd3c4ffaa7bae8c0262f7146cfdccee58079ca)

Exercise 8-4. Modify *hoc* so that a semicolon can be used as an expression terminator equivalent to a newline.

Answer: see [this commit.](https://github.com/guo-sj/hoc-unix/commit/a9754e7c633c3c07c35a8cc8573b276cf6875e10)

3. 支持任意长度的变量名，实现内置函数 `sin`，`exp` 等，支持常量 `PI` 和幂次运算符

到这一步就有 5 个文件：
- hoc.y: Grammar, *main*, *yylex*
- hoc.h: Global data structures for inclusion
- symbol.c: Symbol table routines: *lookup*, *install*
- init.c: Built-ins and constants; *init*
- math.c: Interfaces to math routines: *Sqrt*, *Log*, etc.

Exercise 8-5. As `hoc3` stands, it's legal to say
```
    PI = 3
```
Is this a good idea? How would you change `hoc3` to prohibit assignment to "contants"?

Answer:

Exercise 8-6. Add the built-in function `atan2(y, x)`, which returns the angle whose tangent is y/x. Add the built-in `rand()`,
 which returns a floating point random variable uniformly distributed on the interval (0, 1). How do you have to change the grammar
 to allow for built-ins with different numbers of arguments?

Answer:

Exercise 8-7. How would you add a facility to execute commands from with `hoc`, similar to the `!` feature of other UNIX program?

Answer:

Exercise 8-8. Revise the code in math.c to use a table instead of the sed of essentially identical functions that we presented.

Answer:

4. 不新增功能，为每行语句生成代码并 2 次解析（中间代码生成）
5. 增加控制流 `if-else` 和 `while`，支持 `{}`，`>`，`<=` 等
6. 支持带参数的函数调用

OK，Let‘s do it！
