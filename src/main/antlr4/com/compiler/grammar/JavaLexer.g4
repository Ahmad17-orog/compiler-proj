lexer grammar JavaLexer;

// ---------- Keywords ----------
PACKAGE    : 'package';
IMPORT     : 'import';
CLASS      : 'class';
INTERFACE  : 'interface';
EXTENDS    : 'extends';
IMPLEMENTS : 'implements';
PUBLIC     : 'public';
PRIVATE    : 'private';
PROTECTED  : 'protected';
STATIC     : 'static';
FINAL      : 'final';
ABSTRACT   : 'abstract';
VOID       : 'void';
NEW        : 'new';
RETURN     : 'return';
IF         : 'if';
ELSE       : 'else';
FOR        : 'for';
WHILE      : 'while';
THIS       : 'this';

// primitive types
INT        : 'int';
LONG       : 'long';
DOUBLE     : 'double';
FLOAT      : 'float';
BOOLEAN    : 'boolean';
CHAR       : 'char';

// ---------- Literals ----------
TRUE       : 'true';
FALSE      : 'false';
NULL       : 'null';
DECIMAL_LITERAL : [0-9]+ [lL]?;
FLOAT_LITERAL   : [0-9]+ '.' [0-9]+ [fFdD]?;
STRING_LITERAL  : '"' ( ~["\\\r\n] | '\\' . )* '"';
CHAR_LITERAL    : '\'' ( ~['\\\r\n] | '\\' . ) '\'';

// ---------- Separators ----------
LPAREN : '(';  RPAREN : ')';
LBRACE : '{';  RBRACE : '}';
LBRACK : '[';  RBRACK : ']';
SEMI   : ';';  COMMA  : ',';
DOT    : '.';  AT     : '@';
COLON  : ':';  QUESTION : '?';

// ---------- Operators ----------
ASSIGN   : '=';
GT       : '>';   LT : '<';
BANG     : '!';
EQUAL    : '==';  NOTEQUAL : '!=';
LE       : '<=';  GE : '>=';
AND      : '&&';  OR : '||';
INC      : '++';  DEC : '--';
ADD      : '+';   SUB : '-';
MUL      : '*';   DIV : '/';  MOD : '%';

// ---------- Identifiers ----------
IDENTIFIER : [a-zA-Z_$] [a-zA-Z_$0-9]*;

// ---------- Skipped ----------
WS           : [ \t\r\n\u000C]+ -> skip;
LINE_COMMENT : '//' ~[\r\n]*    -> skip;
BLOCK_COMMENT: '/*' .*? '*/'    -> skip;