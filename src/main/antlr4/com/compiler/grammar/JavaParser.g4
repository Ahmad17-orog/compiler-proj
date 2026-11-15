parser grammar JavaParser;
options { tokenVocab = JavaLexer; }

compilationUnit
    : packageDeclaration? importDeclaration* typeDeclaration* EOF
    ;

packageDeclaration : PACKAGE qualifiedName SEMI ;
importDeclaration  : IMPORT STATIC? qualifiedName (DOT MUL)? SEMI ;

typeDeclaration
    : modifier* (classDeclaration | interfaceDeclaration)
    ;

modifier
    : annotation
    | PUBLIC | PRIVATE | PROTECTED | STATIC | FINAL | ABSTRACT
    ;

// ---------- Annotations (Spring) ----------
annotation
    : AT qualifiedName ( LPAREN (elementValuePairs | elementValue)? RPAREN )?
    ;
elementValuePairs : elementValuePair (COMMA elementValuePair)* ;
elementValuePair  : IDENTIFIER ASSIGN elementValue ;
elementValue
    : expression
    | annotation
    | LBRACE (elementValue (COMMA elementValue)*)? RBRACE
    ;

// ---------- Classes & Interfaces ----------
classDeclaration
    : CLASS IDENTIFIER (EXTENDS type)? (IMPLEMENTS typeList)? classBody
    ;
interfaceDeclaration
    : INTERFACE IDENTIFIER (EXTENDS typeList)? interfaceBody
    ;

classBody : LBRACE classBodyDeclaration* RBRACE ;
classBodyDeclaration
    : SEMI
    | modifier* memberDeclaration
    ;
memberDeclaration
    : methodDeclaration
    | fieldDeclaration
    | constructorDeclaration
    ;

interfaceBody : LBRACE interfaceMethodDeclaration* RBRACE ;
interfaceMethodDeclaration
    : modifier* (type | VOID) IDENTIFIER formalParameters SEMI
    ;

methodDeclaration
    : (type | VOID) IDENTIFIER formalParameters (block | SEMI)
    ;
constructorDeclaration : IDENTIFIER formalParameters block ;
fieldDeclaration       : type variableDeclarators SEMI ;

formalParameters : LPAREN (formalParameter (COMMA formalParameter)*)? RPAREN ;
formalParameter  : modifier* type IDENTIFIER ;

variableDeclarators : variableDeclarator (COMMA variableDeclarator)* ;
variableDeclarator  : IDENTIFIER (ASSIGN expression)? ;

// ---------- Types ----------
type
    : (primitiveType | qualifiedName typeArguments?) (LBRACK RBRACK)*
    ;
primitiveType : INT | LONG | DOUBLE | FLOAT | BOOLEAN | CHAR ;
typeArguments : LT (type (COMMA type)*)? GT ;
typeList      : type (COMMA type)* ;
qualifiedName : IDENTIFIER (DOT IDENTIFIER)* ;

// ---------- Statements ----------
block : LBRACE blockStatement* RBRACE ;

blockStatement
    : localVariableDeclaration SEMI
    | statement
    ;
localVariableDeclaration : FINAL? type variableDeclarators ;

statement
    : block                                              # BlockStmt
    | IF parExpression statement (ELSE statement)?       # IfStmt
    | FOR LPAREN forControl RPAREN statement             # ForStmt
    | WHILE parExpression statement                      # WhileStmt
    | RETURN expression? SEMI                            # ReturnStmt
    | expression SEMI                                    # ExprStmt
    | SEMI                                               # EmptyStmt
    ;

forControl
    : FINAL? type IDENTIFIER COLON expression            // for-each
    | forInit? SEMI expression? SEMI expressionList?     // classic for
    ;
forInit : localVariableDeclaration | expressionList ;

parExpression  : LPAREN expression RPAREN ;
expressionList : expression (COMMA expression)* ;

// ---------- Expressions (higher in list = higher precedence) ----------
expression
    : primary                                                   # PrimaryExpr
    | expression DOT IDENTIFIER LPAREN expressionList? RPAREN   # MethodCallExpr
    | expression DOT IDENTIFIER                                 # FieldAccessExpr
    | IDENTIFIER LPAREN expressionList? RPAREN                  # SimpleCallExpr
    | expression LBRACK expression RBRACK                       # ArrayAccessExpr
    | expression (INC | DEC)                                    # PostfixExpr
    | (INC | DEC | ADD | SUB | BANG) expression                # UnaryExpr
    | NEW creator                                               # NewExpr
    | expression (MUL | DIV | MOD) expression                   # MulExpr
    | expression (ADD | SUB) expression                         # AddExpr
    | expression (LT | GT | LE | GE) expression                 # RelationalExpr
    | expression (EQUAL | NOTEQUAL) expression                  # EqualityExpr
    | expression AND expression                                # AndExpr
    | expression OR expression                                  # OrExpr
    | <assoc=right> expression ASSIGN expression                # AssignExpr
    ;

primary
    : LPAREN expression RPAREN
    | THIS
    | literal
    | IDENTIFIER
    ;

creator : qualifiedName typeArguments? LPAREN expressionList? RPAREN ;

literal
    : DECIMAL_LITERAL | FLOAT_LITERAL | STRING_LITERAL | CHAR_LITERAL
    | TRUE | FALSE | NULL
    ;