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

classDefinitionPlace := classDefinition?
classDefinition := ts?, (scope, ts)?, class, ts, identifier, ts?, LCURLY, ts?, RCURLY

scope := public / internal / private

class := "class"

public := "public"
internal := "internal"
private := "private"

identifier := alphaunder, (PERIOD?, alphanums+)*
alphanums      := (letter / digit)+
alphaunder     := (letter / "_")
dataType := integer / string / boolean / float / object

PERIOD := "."
LCURLY := "{"
RCURLY := "}"
SEMI := ";"
COLON := ":"
EOL   := ("\r"?,"\n") / EOF
