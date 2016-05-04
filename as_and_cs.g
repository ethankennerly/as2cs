ts := (whitespace+ / comment_area)+
comment_area := comment_line / comment_block
comment_block := COMMENT_START, comment_middle*, COMMENT_END
comment_line := COMMENT_LINE_START, comment_line_content*, EOL
comment_middle := -COMMENT_END
comment_line_content := -EOL
COMMENT_LINE_START := "//"
COMMENT_START := "/*"
COMMENT_END := "*/"

namespace_declaration := ts?, NAMESPACE, (ts, address)?, ts?
import_definition_place := import_definition*
import_definition := ts?, IMPORT, ts, address, SEMI, EOL?

class_definition_place := class_definition?, ts?
class_definition := ts?, class_modifier*, CLASS, ts, identifier, class_base_clause?, 
    ts?, LCURLY, member_expression*, ts?, RCURLY
class_modifier := scope / FINAL, ts
class_base := 
    (class_extends, interface_type_list_follows) / interface_type_list / 
    class_extends
class_identifier := identifier
interface_type_list := interface_first, interface_next_place
interface_next_place := (ts?, COMMA, ts?, interface_identifier)*
interface_prefix := I, uppercasechar, identifier?
interface_identifier := interface_prefix, identifier?
I := "I"

member_expression := function_definition / member_declaration
member_declaration := ts, namespace_modifiers?, variable_declaration, ts?, SEMI

namespace_modifier_place := namespace_modifiers?
namespace_modifiers := (scope / STATIC / FINAL / OVERRIDE, ts)+
function_body := ts?, LCURLY, statement*, ts?, RCURLY
function_declaration := function_modified / function_default
function_signature := FUNCTION, ts, identifier, function_parameters
function_definition := function_declaration, function_body
function_parameters := ts?, LPAREN, ts?, argument_list?, ts?, RPAREN
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

argument_list := argument_declaration, (ts?, COMMA, ts?, argument_declaration)*
argument_declaration := argument_initialized / argument_declared
argument_initializer := ts?, ASSIGN, ts?, assignment_value
assignment_value := expression
argument_end := SEMI / COMMA / EOL / EOF / RPAREN
variable_assignment := address, ts?, ASSIGN, ts?, assignment_value
address := identifier, (ts?, PERIOD, ts?, identifier)*
call_expression := address, ts?, LPAREN, ts?, call_parameters?, ts?, RPAREN
call_parameters := expression, (ts?, COMMA, expression)*

identifier := alphaunder, alphanumunder*
alphanumunder := digit / alphaunder
alphaunder := letter / UNDERSCORE
data_type := INTEGER / STRING / BOOLEAN / FLOAT / OBJECT
return_type := data_type / VOID

statement := ts?, primary_expression, ts?, SEMI
primary_expression := expression
expression := variable_declaration
    / variable_assignment
    / call_expression
    / address
    / literal

literal :=
    number_format
    / string
    / literal_keyword

number_format := hex / float_format / int

conditional_expression :=
    conditional_function /
    (expression, ts?, comparison_operator, ts?, expression)

conditional_function := 
    contains_not_expression / contains_expression
    / strict_not_equal_expression / strict_equal_expression 
contained_expression := expression
comparison_operator := equality_operator / relational_operator
equality_operator := NOT_EQUAL / EQUAL
relational_operator := LT / GT / LE / GE

GE := ">="
GT := ">"
LT := "<"
LE := "<="

EQUAL := "=="
NOT_EQUAL := "!="
LNOT := "!"
NULL := "null"

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
