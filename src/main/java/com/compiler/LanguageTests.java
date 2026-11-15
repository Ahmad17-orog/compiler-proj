package com.compiler;

import com.compiler.grammar.*;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTree;

public class LanguageTests {

    public static void main(String[] args) throws Exception {
        testHtml("samples/products.html");
        testHtml("samples/add-product.html");
        testCss("samples/style.css");

        System.out.println("\n######## THYMELEAF ########");
        String[] standard = {
                "${product.name}",
                "'$' + ${p.price}",
                "@{/products/{id}(id=${p.id})}",
                "@{/products/add}",
                "${#lists.isEmpty(products)}",
                "${p.price gt 100} ? 'expensive' : 'cheap'",
                "${user != null and user.active}",
                "*{name}",
                "#{products.title}",
                "|Price: ${p.price}|"
        };
        for (String s : standard) testThymeleaf(s, "standard");
        testThymeleaf("p, stat : ${products}", "each");
        testThymeleaf("title=${p.name}, id=${p.id}", "with");
        testThymeleaf("~{fragments/layout :: header}", "fragmentUse");
    }

    static void testHtml(String file) throws Exception {
        System.out.println("\n######## HTML: " + file);
        HTMLLexer lexer = new HTMLLexer(CharStreams.fromFileName(file));
        HTMLParser parser = new HTMLParser(new CommonTokenStream(lexer));
        ParseTree tree = parser.htmlDocument();
        System.out.println(tree.toStringTree(parser));
        System.out.println("Syntax errors: " + parser.getNumberOfSyntaxErrors());
    }

    static void testCss(String file) throws Exception {
        System.out.println("\n######## CSS: " + file);
        CSSLexer lexer = new CSSLexer(CharStreams.fromFileName(file));
        CSSParser parser = new CSSParser(new CommonTokenStream(lexer));
        ParseTree tree = parser.stylesheet();
        System.out.println(tree.toStringTree(parser));
        System.out.println("Syntax errors: " + parser.getNumberOfSyntaxErrors());
    }

    static void testThymeleaf(String text, String kind) {
        ThymeleafLexer lexer = new ThymeleafLexer(CharStreams.fromString(text));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        tokens.fill();

        StringBuilder sb = new StringBuilder();
        for (Token t : tokens.getTokens()) {
            if (t.getType() != Token.EOF) {
                sb.append(lexer.getVocabulary().getSymbolicName(t.getType())).append(' ');
            }
        }

        ThymeleafParser parser = new ThymeleafParser(tokens);
        ParseTree tree = switch (kind) {
            case "each"        -> parser.eachAttr();
            case "with"        -> parser.assignmentsAttr();
            case "fragmentUse" -> parser.fragmentUseAttr();
            default            -> parser.standardAttr();
        };

        System.out.println("\n[" + kind + "] " + text);
        System.out.println("  tokens: " + sb);
        System.out.println("  tree:   " + tree.toStringTree(parser));
        System.out.println("  errors: " + parser.getNumberOfSyntaxErrors());
    }
}