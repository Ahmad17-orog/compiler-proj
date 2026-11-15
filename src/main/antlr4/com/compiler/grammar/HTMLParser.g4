parser grammar HTMLParser;
options { tokenVocab = HTMLLexer; }

@members {
    private static final java.util.Set<String> VOID_TAGS = java.util.Set.of(
        "area","base","br","col","embed","hr","img","input",
        "link","meta","param","source","track","wbr");

    // LT(1) is '<' and LT(2) is the tag name
    private boolean isVoidTag() {
        Token t = _input.LT(2);
        return t != null && VOID_TAGS.contains(t.getText().toLowerCase());
    }
}

htmlDocument : DOCTYPE? htmlContent EOF ;

htmlContent
    : ( htmlElement | styleElement | scriptElement | htmlText )*
    ;

htmlText      : HTML_TEXT ;
styleElement  : STYLE_OPEN  STYLE_BODY ;
scriptElement : SCRIPT_OPEN SCRIPT_BODY ;

htmlElement
    : {isVoidTag()}? TAG_OPEN TAG_NAME htmlAttribute* (TAG_CLOSE | TAG_SLASH_CLOSE)
                                                                  # VoidElement
    | TAG_OPEN TAG_NAME htmlAttribute* TAG_SLASH_CLOSE            # SelfClosingElement
    | {!isVoidTag()}? TAG_OPEN TAG_NAME htmlAttribute* TAG_CLOSE
          htmlContent
      TAG_OPEN TAG_SLASH TAG_NAME TAG_CLOSE                       # NormalElement
    ;

htmlAttribute : TAG_NAME (TAG_EQUALS ATTVALUE_VALUE)? ;