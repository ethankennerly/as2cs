ts := (whitespace+ / comment_area)+
comment_area := comment_line / comment_block
comment_block := COMMENT_START, comment_middle*, COMMENT_END
comment_line := COMMENT_LINE_START, comment_line_content*, EOL
comment_middle := -COMMENT_END
comment_line_content := -EOL
COMMENT_LINE_START := "//"
COMMENT_START := "/*"
COMMENT_END := "*/"

namespaceDeclaration := ts?, NAMESPACE, (ts, identifier)?, ts?
importDefinitionPlace := importDefinition*
importDefinition := ts?, IMPORT, ts, identifier, SEMI, EOL?

classDefinitionPlace := classDefinition?, ts?
classDefinition := ts?, classModifier*, CLASS, ts, identifier, classBaseClause?, 
    ts?, LCURLY, memberExpression*, ts?, RCURLY
classModifier := scope / FINAL, ts
classBase := 
    (classExtends, interfaceTypeListFollows) / interfaceTypeList / 
    classExtends
classIdentifier := identifier
interfaceTypeList := interfaceFirst, interfaceNextPlace
interfaceNextPlace := (ts?, COMMA, ts?, interfaceIdentifier)*
interfacePrefix := I, uppercasechar, identifier?
interfaceIdentifier := interfacePrefix, identifier?
I := "I"

memberExpression := functionDefinition / memberDeclaration
memberDeclaration := ts, namespaceModifiers?, variableDeclaration, ts?, SEMI

namespaceModifierPlace := namespaceModifiers?
namespaceModifiers := (scope / STATIC / FINAL / OVERRIDE, ts)+
functionBody := ts?, LCURLY, statement*, ts?, RCURLY
functionDeclaration := functionModified / functionDefault
functionSignature := FUNCTION, ts, identifier, functionParameters
functionDefinition := functionDeclaration, functionBody
functionParameters := ts?, LPAREN, ts?, argumentList?, ts?, RPAREN
FUNCTION := "function"
OVERRIDE := "override"
scope := PUBLIC / INTERNAL / PROTECTED / PRIVATE
CLASS := "class"
PUBLIC := "public"
INTERNAL := "internal"
PROTECTED := "protected"
PRIVATE := "private"
VOID := "void"
STATIC := "static"

argumentList := argumentDeclaration, (ts?, COMMA, ts?, argumentDeclaration)*
argumentDeclaration := argumentInitialized / argumentDeclared
argumentInitializer := ts?, ASSIGN, ts?, assignmentValue
assignmentValue := expression
argumentEnd := SEMI / COMMA / EOL / EOF / RPAREN
variableAssignment := identifier, ts?, ASSIGN, ts?, assignmentValue
address := identifier, (ts?, PERIOD, ts?, identifier)?
callExpression := address, ts?, LPAREN, ts?, callParameters?, ts?, RPAREN
callParameters := expression, (ts?, COMMA, expression)*

identifier := alphaunder, (PERIOD?, alphanums+)*
alphanums      := (letter / digit)+
alphaunder     := (letter / UNDERSCORE)
dataType := INTEGER / STRING / BOOLEAN / FLOAT / OBJECT
returnType := dataType / VOID

statement := ts?, primaryExpression, ts?, SEMI
primaryExpression := expression
expression := variableDeclaration
    / variableAssignment
    / callExpression
    / identifier
    / numberFormat
    / string

numberFormat := hex / floatFormat / int

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
ASSIGN := "="
UNDERSCORE := "_"
QUOTE := "\""
APOS := "'"
