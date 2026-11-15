lexer grammar HTMLLexer;

// ================= DEFAULT MODE =================
HTML_COMMENT : '<!--' .*? '-->' -> skip ;
DOCTYPE      : '<!' [dD][oO][cC][tT][yY][pP][eE] ~'>'* '>' ;

SCRIPT_OPEN  : '<script' ~'>'* '>' -> pushMode(SCRIPT) ;
STYLE_OPEN   : '<style'  ~'>'* '>' -> pushMode(STYLE) ;

TAG_OPEN     : '<' -> pushMode(TAG) ;

HTML_WS      : [ \t\r\n]+ -> skip ;
HTML_TEXT    : ~'<'+ ;

// ================= INSIDE A TAG =================
mode TAG;

TAG_CLOSE       : '>'  -> popMode ;
TAG_SLASH_CLOSE : '/>' -> popMode ;
TAG_SLASH       : '/' ;
TAG_EQUALS      : '=' -> pushMode(ATTVALUE) ;
TAG_NAME        : [a-zA-Z] [a-zA-Z0-9_:.\-]* ;
TAG_WS          : [ \t\r\n]+ -> skip ;

// ================= ATTRIBUTE VALUE =================
mode ATTVALUE;

ATTVALUE_WS    : [ \t\r\n]+ -> skip ;
ATTVALUE_VALUE
    : ( '"' ~'"'* '"'
      | '\'' ~'\''* '\''
      | ~[ \t\r\n"'<>=`]+
      ) -> popMode
    ;

// ================= RAW BODIES =================
mode SCRIPT;
SCRIPT_BODY : .*? '</script>' -> popMode ;

mode STYLE;
STYLE_BODY  : .*? '</style>' -> popMode ;