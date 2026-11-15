parser grammar ThymeleafParser;
options { tokenVocab = ThymeleafLexer; }

// ================= entry rules (one per attribute family) =================
standardAttr    : expression EOF ;                                  // text, if, href, action, field, object...
eachAttr        : iterVar=IDENTIFIER (COMMA statVar=IDENTIFIER)? COLON expression EOF ;
assignmentsAttr : assignment (COMMA assignment)* EOF ;              // th:with, th:attr
fragmentDefAttr : IDENTIFIER (LPAREN (IDENTIFIER (COMMA IDENTIFIER)*)? RPAREN)? EOF ;
fragmentUseAttr : (fragmentExpr | fragmentSpec) EOF ;               // th:replace, th:insert

assignment : attrName ASSIGN expression ;
attrName   : IDENTIFIER (SUB IDENTIFIER)* ;

// ================= expressions =================
expression
    : primary                                                        # PrimaryExpr
    | expression DOT IDENTIFIER LPAREN expressionList? RPAREN        # MethodCallExpr
    | expression DOT IDENTIFIER                                      # PropertyExpr
    | expression LBRACK expression RBRACK                            # IndexExpr
    | (NOT | SUB) expression                                         # UnaryExpr
    | expression (MUL | DIV | MOD) expression                        # MulExpr
    | expression (ADD | SUB) expression                              # AddExpr
    | expression (LT | GT | LE | GE) expression                      # RelationalExpr
    | expression (EQ | NE) expression                                # EqualityExpr
    | expression AND expression                                      # AndExpr
    | expression OR expression                                       # OrExpr
    | expression QUESTION expression (COLON expression)?             # ConditionalExpr
    | expression ELVIS expression                                    # ElvisExpr
    ;

primary
    : LPAREN expression RPAREN                       # ParenPrimary
    | variableExpr                                   # VariablePrimary
    | selectionExpr                                  # SelectionPrimary
    | linkExpr                                       # LinkPrimary
    | messageExpr                                    # MessagePrimary
    | fragmentExpr                                   # FragmentPrimary
    | literal                                        # LiteralPrimary
    | LITERAL_SUBST                                  # LiteralSubstPrimary
    | UTILITY_OBJECT                                 # UtilityPrimary
    | IDENTIFIER LPAREN expressionList? RPAREN       # FunctionCallPrimary
    | IDENTIFIER                                     # IdentPrimary
    ;

variableExpr  : VAR_START expression RBRACE ;                       // ${...}
selectionExpr : SEL_START expression RBRACE ;                       // *{...}
messageExpr   : MSG_START messageKey (LPAREN expressionList? RPAREN)? RBRACE ;   // #{...}
messageKey    : IDENTIFIER ((DOT | SUB) IDENTIFIER)* ;

linkExpr      : LINK_START LINK_PATH (LPAREN linkParams? RPAREN)? RBRACE ;      // @{...}
linkParams    : linkParam (COMMA linkParam)* ;
linkParam     : IDENTIFIER ASSIGN expression ;

fragmentExpr  : FRAG_START fragmentSpec RBRACE ;                    // ~{...}
fragmentSpec
    : templateName (DOUBLE_COLON fragmentSelector)?
    | DOUBLE_COLON fragmentSelector
    ;
templateName
    : IDENTIFIER ((DIV | DOT | SUB) IDENTIFIER)*
    | STRING_LITERAL
    | variableExpr
    ;
fragmentSelector : IDENTIFIER (LPAREN fragmentArgs? RPAREN)? ;
fragmentArgs     : fragmentArg (COMMA fragmentArg)* ;
fragmentArg      : (IDENTIFIER ASSIGN)? expression ;

expressionList : expression (COMMA expression)* ;

literal : NUMBER | STRING_LITERAL | BOOLEAN_LITERAL | NULL_LITERAL ;