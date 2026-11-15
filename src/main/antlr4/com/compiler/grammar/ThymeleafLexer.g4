lexer grammar ThymeleafLexer;

// ---------- expression start markers ----------
VAR_START  : '${' ;
SEL_START  : '*{' ;
MSG_START  : '#{' ;
FRAG_START : '~{' ;
LINK_START : '@{' -> pushMode(LINK_MODE) ;

// ---------- operators (symbol or word form) ----------
AND   : '&&' | 'and' ;
OR    : '||' | 'or' ;
NOT   : '!'  | 'not' ;
EQ    : '==' | 'eq' ;
NE    : '!=' | 'neq' | 'ne' ;
LE    : '<=' | 'le' ;
GE    : '>=' | 'ge' ;
LT    : '<'  | 'lt' ;
GT    : '>'  | 'gt' ;

ELVIS        : '?:' ;
QUESTION     : '?' ;
DOUBLE_COLON : '::' ;
COLON        : ':' ;

ADD : '+' ;  SUB : '-' ;  MUL : '*' ;  DIV : '/' ;  MOD : '%' ;
ASSIGN : '=' ;

LPAREN : '(' ;  RPAREN : ')' ;
LBRACK : '[' ;  RBRACK : ']' ;
RBRACE : '}' ;
COMMA  : ',' ;  DOT : '.' ;

// ---------- literals ----------
BOOLEAN_LITERAL : 'true' | 'false' ;
NULL_LITERAL    : 'null' ;
NUMBER          : [0-9]+ ('.' [0-9]+)? ;
STRING_LITERAL
    : '\'' ( ~['\\] | '\\' . )* '\''
    | '"'  ( ~["\\] | '\\' . )* '"'
    ;
LITERAL_SUBST   : '|' ~[|]* '|' ;        // |Hello ${name}|

// ---------- names ----------
UTILITY_OBJECT  : '#' [a-zA-Z_]+ ;       // #lists, #strings, #dates
IDENTIFIER      : [a-zA-Z_] [a-zA-Z_0-9]* ;

WS : [ \t\r\n]+ -> skip ;

// ---------- inside @{ ... } : the URL path ----------
mode LINK_MODE;
LINK_PATH : ( '{' ~[{}]* '}' | ~[({}] )+ -> popMode ;