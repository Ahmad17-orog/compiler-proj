package com.compiler;

import com.compiler.grammar.JavaLexer;
import com.compiler.grammar.JavaParser;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.ParseTree;

public class Main {
    public static void main(String[] args) throws Exception {
        // 1) قراءة الملف
        CharStream input = CharStreams.fromFileName("samples/ProductController.java");

        // 2) الـ Lexer: نص ← رموز
        JavaLexer lexer = new JavaLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        // طباعة الرموز لفهم عمل الـ Lexer
        tokens.fill();
        for (Token t : tokens.getTokens()) {
            System.out.println(t.getLine() + ":" + t.getCharPositionInLine()
                    + "  " + lexer.getVocabulary().getSymbolicName(t.getType())
                    + "  '" + t.getText() + "'");
        }

        // 3) الـ Parser: رموز ← شجرة تحليل
        JavaParser parser = new JavaParser(tokens);
        ParseTree tree = parser.compilationUnit();

        System.out.println("\n===== Parse Tree =====");
        System.out.println(tree.toStringTree(parser));

        System.out.println("\nعدد أخطاء التحليل: " + parser.getNumberOfSyntaxErrors());
    }
}