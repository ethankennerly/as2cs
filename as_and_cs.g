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
    ts?, LBRACE, member_expression*, ts?, RBRACE
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
function_body := ts?, LBRACE, statement*, ts?, RBRACE
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
address := identifier, (ts?, DOT, ts?, identifier)*
call_expression := address, ts?, LPAREN, ts?, call_parameters?, ts?, RPAREN
call_parameters := expression, (ts?, COMMA, expression)*

identifier := alphaunder, alphanumunder*
alphanumunder := digit / alphaunder
alphaunder := letter / UNDERSCORE
data_type := INTEGER / STRING / BOOLEAN / FLOAT / OBJECT
return_type := data_type / VOID

statement := ts?, 
    block /
    (
        (
            variable_declaration
            / primary_expression
        ), 
        ts?, SEMI
    )
    / if_statement

block := LBRACE, statement*, RBRACE
primary_expression := expression
expression := 
    variable_assignment
    / unary_expression
    / left_hand_side_expression

left_hand_side_expression := 
    literal
    / call_expression
    / address
    / (LPAREN, ts?, conditional_expression, ts?, RPAREN)

literal :=
    number_format
    / string
    / literal_keyword

number_format := hex / float_format / int

if_statement := (if_head, ts?, ELSE, statement) /
    if_head
if_head := ts?, IF, ts?, LPAREN, ts?, conditional_expression, ts?, RPAREN, statement
IF := "if"
ELSE := "else"

conditional_expression :=
    conditional_function /
    relational_expression

conditional_function := 
    contains_not_expression / contains_expression
    / strict_not_equal_expression / strict_equal_expression 
contained_expression := expression

relational_expression := (ts?, unary_expression, relational_expression_tail*)
relational_expression_tail := ts?, computational_operator, ts?, relational_expression

unary_expression :=
    postfix_expression
    / (PLUS2, ts?, unary_expression)
    / (MINUS2, ts?, unary_expression)
    / (LNOT, ts?, unary_expression)

postfix_expression := left_hand_side_expression, (PLUS2 / MINUS2)?
PLUS2 := "++"
MINUS2 := "--"

computational_operator :=
    arithmetic_operator
    / comparison_operator
    / logical_operator

comparison_operator := equality_operator / relational_operator
equality_operator := NOT_EQUAL / EQUAL
relational_operator := LE / GE / LT / GT
GE := ">="
GT := ">"
LT := "<"
LE := "<="
EQUAL := "=="
NOT_EQUAL := "!="

arithmetic_operator := PLUS / MINUS / ASTERISK / DIVIDE
PLUS := "+"
MINUS := "-"
PERCENT := "%"
ASTERISK := "*"
DIVIDE := "/"

logical_operator := OR / AND
OR := "||"
AND := "&&"

LNOT := "!"
NULL := "null"
DOT := "."
LBRACE := "{"
RBRACE := "}"
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
