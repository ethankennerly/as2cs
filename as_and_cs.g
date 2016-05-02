namespaceDeclaration := ts?, namespace, (ts, identifier)?, ts?

ts := (whitespace+ / comment_area)+

comment_area := comment_line / comment_block
comment_block := comment_start, comment_middle*, comment_end
comment_line := comment_line_start, comment_line_content*, EOL
comment_middle := -comment_end
comment_line_content := -EOL
comment_line_start := "//"
comment_start := "/*"
comment_end := "*/"


importDefinitionPlace := importDefinition*

importDefinition := ts?, import, ts, identifier, SEMI, EOL?

classDefinitionPlace := classDefinition?, ts?
classDefinition := ts?, (scope, ts)?, class, ts, identifier, ts?, LCURLY, ts?, RCURLY

namespaceModifierPlace := namespaceModifiers?
namespaceModifiers := (scope / STATIC, ts)+
functionBody := ts?, LCURLY, ts?, RCURLY
functionDeclaration := functionModified / functionDefault
functionSignature := FUNCTION, ts, identifier, functionParameters
functionDefinition := functionDeclaration, functionBody
functionParameters := ts?, LPAREN, ts?, argumentList?, ts?, RPAREN

argumentList := argumentDeclaration, (ts?, COMMA, ts?, argumentDeclaration)*

statement := variableDeclaration, ts?, SEMI

scope := public / internal / protected / private

FUNCTION := "function"

class := "class"

public := "public"
internal := "internal"
protected := "protected"
private := "private"
VOID := "void"

STATIC := "static"

identifier := alphaunder, (PERIOD?, alphanums+)*
alphanums      := (letter / digit)+
alphaunder     := (letter / "_")
dataType := integer / string / boolean / float / object
returnType := dataType / VOID

PERIOD := "."
LCURLY := "{"
RCURLY := "}"
LPAREN := "("
RPAREN := ")"
SEMI := ";"
COLON := ":"
COMMA := ","
EOL   := ("\r"?, "\n") / EOF
SPACE := " "

