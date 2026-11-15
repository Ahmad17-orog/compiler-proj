lexer grammar CSSLexer;

COMMENT : '/*' .*? '*/' -> skip ;
WS      : [ \t\r\n\f]+  -> channel(HIDDEN) ;

AT_RULE   : '@' IDENT ;
URL       : 'url(' ~[)]* ')' ;
IMPORTANT : '!' [ \t]* 'important' ;

PERCENTAGE : NUM '%' ;
DIMENSION  : NUM [a-zA-Z]+ ;
NUMBER     : NUM ;
fragment NUM : [0-9]+ ('.' [0-9]+)? | '.' [0-9]+ ;

HASH   : '#' [a-zA-Z0-9_\-]+ ;       // id selector or hex color
STRING : '"'  ( ~["\\\r\n] | '\\' . )* '"'
       | '\'' ( ~['\\\r\n] | '\\' . )* '\''
       ;

DOUBLE_COLON : '::' ;
COLON  : ':' ;   SEMI   : ';' ;   COMMA : ',' ;
LBRACE : '{' ;   RBRACE : '}' ;
LPAREN : '(' ;   RPAREN : ')' ;
LBRACK : '[' ;   RBRACK : ']' ;
ATTR_OP : [~^$*|]? '=' ;
DOT    : '.' ;   STAR : '*' ;   GT : '>' ;   PLUS : '+' ;
TILDE  : '~' ;   SLASH : '/' ;  MINUS : '-' ;

IDENT : '-'* [a-zA-Z_] [a-zA-Z0-9_\-]* ;