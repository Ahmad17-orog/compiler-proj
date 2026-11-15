parser grammar CSSParser;
options { tokenVocab = CSSLexer; }

stylesheet : ( ruleset | atRule )* EOF ;

// ---------- rule sets ----------
ruleset      : selectorList LBRACE declarationList? RBRACE ;
selectorList : selector (COMMA selector)* ;

selector     : simpleSelector+ ( combinator simpleSelector+ )* ;
combinator   : GT | PLUS | TILDE ;

simpleSelector
    : IDENT                                                              # TypeSelector
    | STAR                                                               # UniversalSelector
    | HASH                                                               # IdSelector
    | DOT IDENT                                                          # ClassSelector
    | LBRACK IDENT ( ATTR_OP (IDENT | STRING | NUMBER) )? RBRACK         # AttributeSelector
    | COLON IDENT ( LPAREN pseudoArgs RPAREN )?                          # PseudoClassSelector
    | DOUBLE_COLON IDENT                                                 # PseudoElementSelector
    ;
pseudoArgs : ~(LPAREN | RPAREN)+ ;

// ---------- declarations ----------
declarationList : SEMI* declaration ( SEMI+ declaration )* SEMI* ;
declaration     : property COLON expr IMPORTANT? ;
property        : IDENT ;

expr : term ( operator? term )* ;
operator : SLASH | COMMA | STAR ;

term
    : (PLUS | MINUS)? (NUMBER | PERCENTAGE | DIMENSION)     # NumericTerm
    | STRING                                                # StringTerm
    | URL                                                   # UrlTerm
    | HASH                                                  # ColorTerm
    | IDENT LPAREN expr RPAREN                              # FunctionTerm
    | IDENT                                                 # IdentTerm
    ;

// ---------- at-rules (@media, @import, @font-face) ----------
atRule    : AT_RULE atPrelude? ( SEMI | LBRACE atBody RBRACE ) ;
atPrelude : ~(LBRACE | SEMI)+ ;
atBody    : ruleset* | declarationList ;