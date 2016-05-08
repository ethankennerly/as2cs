ts := (whitespace / comment_area)+
comment_area := comment_line+ / comment_block
comment_block := comment_start, comment_middle*, COMMENT_END
comment_line := COMMENT_LINE_START, comment_line_content*, EOL
comment_middle := -COMMENT_END
comment_line_content := -EOL
COMMENT_LINE_START := "//"
comment_start := COMMENT_START, ?-COMMENT_MARKUP_START
COMMENT_START := "/*"
COMMENT_END := "*/"
COMMENT_MARKUP_START := "<"
COMMENT_MARKUP_END := ">"
MARKUP_START := COMMENT_START, COMMENT_MARKUP_START
MARKUP_END := COMMENT_MARKUP_END, COMMENT_END

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
member_declaration := ts?, namespace_modifiers_place, data_declaration, ts?, SEMI
data_declaration := delegate_declaration / constant_declaration / variable_declaration
delegate_declaration := delegate_argument_declaration / delegate_no_argument_declaration
CONSTANT := "const"
namespace_modifiers_place := (namespace_modifier, (ts, namespace_modifier)*, whitespace)?
namespace_modifier := scope / STATIC / FINAL / OVERRIDE
function_body := ts?, LBRACE, statement*, ts?, RBRACE
function_declaration := function_modified / constructor / function_default
constructor := ts?, namespace_modifiers_place, function_signature
function_definition := function_declaration, function_body
function_parameters := ts?, LPAREN, whitespace?, argument_list?, ts?, RPAREN
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

argument_list := argument_declaration, (ts?, COMMA, whitespace, argument_declaration)*
argument_declaration := argument_initialized / argument_declared
argument_initializer := ts?, ASSIGN, ts?, assignment_value
assignment_value := expression
variable_assignment := address, ts?, assignment_operator, ts?, assignment_value
address := (new_expression / replaced_address / identifier), address_tail*
address_tail := ts?, 
    (DOT, ts?, (replaced_property / identifier))
    / (LBRACK, ts?, expression, ts?, RBRACK)
LBRACK := "["
RBRACK := "]"
call_expression := address, ts?, LPAREN, ts?, expression_list?, ts?, RPAREN
replaced_property := COLLECTION_LENGTH / CLONE / PUSH, ?(ts / -(alphanumunder / DOT))
replaced_address := PARSE_INT / PARSE_FLOAT
identifier := alphaunder, alphanumunder*

alphanumunder := digit / alphaunder
alphaunder := letter / UNDERSCORE
data_type := swap_type / INTEGER / STRING / BOOLEAN / FLOAT / collection_type / DYNAMIC_TYPE / OBJECT / address
return_type := data_type / VOID
as_type := data_type
cs_type := data_type
collection_type := collection / generic_collection 
generic_collection := collection_prefix, ts?, LT, ts?, data_type, ts?, GT
collection := ARRAY_LIST / STRING_HASH_TABLE / HASH_TABLE
array_literal := array_literal_prefix, ts?, expression_list?, ts?, array_literal_suffix
hash_literal := hash_literal_prefix, ts?, property_list?, ts?, hash_literal_suffix
property_list := property, (ts?, COMMA, ts?, property)*
key := quoted_identifier / literal

statement := ts?, 
    block /
    (
        (
            data_declaration
            / primary_expression
        )?, 
        ts?, SEMI
    )
    / if_statement

block := LBRACE, statement*, RBRACE
primary_expression := expression
expression := 
    array_literal
    / hash_literal
    / variable_assignment
    / relational_expression
    / left_hand_side_expression

new_expression := NEW, ts?, data_type, ts?, LPAREN, ts?, expression_list?, ts?, RPAREN
NEW := "new"
expression_list := expression, (ts?, COMMA, ts?, expression)*

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
if_head := ts?, IF, conditional_clause, statement
conditional_clause := ts?, LPAREN, ts?, conditional_expression, ts?, RPAREN

IF := "if"
ELSE := "else"

conditional_expression :=
    conditional_function 
    / is_expression
    / ternary_expression
    / relational_expression
    / address

ternary_expression := relational_expression, ts?, QUESTION, ts?, assignment_value, ts?, COLON, ts?, assignment_value
QUESTION := "?"

conditional_function := 
    contains_not_expression / contains_expression
    / strict_not_equal_expression / strict_equal_expression 
contained_expression := expression

relational_expression := (ts?, unary_expression, relational_expression_tail*)
relational_expression_tail := ts?, computational_operator, ts?, relational_expression

unary_expression :=
    nullable_cast_expression
    / postfix_expression
    / (PLUS2, ts?, unary_expression)
    / (MINUS2, ts?, unary_expression)
    / (LNOT, ts?, unary_expression)
LNOT := "!"
nullable_cast_expression := ts?, left_hand_side_expression, ts, AS, ts, data_type
AS := "as"
is_expression := ts?, left_hand_side_expression, ts, IS, ts, data_type
IS := "is"

postfix_expression := left_hand_side_expression, (PLUS2 / MINUS2)?
PLUS2 := "++"
MINUS2 := "--"

computational_operator :=
    comparison_operator
    / logical_operator
    / assignable_operator
    / BIT_NOT

comparison_operator := equality_operator / relational_operator
equality_operator := NOT_EQUAL / EQUAL
relational_operator := LE / GE / LT / GT
GE := ">="
GT := ">"
LT := "<"
LE := "<="
EQUAL := "=="
NOT_EQUAL := "!="

assignment_operator := assignable_operator?, ASSIGN
ASSIGN := "="

assignable_operator := BIT_AND / BIT_OR / BIT_XOR / PLUS / MINUS / TIMES / DIVIDE / MOD / LSHIFT / RSHIFT
PLUS := "+"
MINUS := "-"
MOD := "%"
TIMES := "*"
DIVIDE := "/"
BIT_AND := "&"
BIT_OR := "|"
BIT_XOR := "^"
PLUS := "+"
MINUS := "-"
TIMES := "*"
LSHIFT := "<<"
RSHIFT := ">>"

logical_operator := OR / AND
OR := "||"
AND := "&&"

BIT_NOT := "~"

iteration_statement := for_in_statement / for_statement / do_statement / while_statement
for_statement := ts?, FOR, ts?, LPAREN, statement, statement, expression_list?, RPAREN, statement
FOR := "for"
while_statement := ts?, WHILE, conditional_clause, statement
WHILE := "while"
do_statement := ts?, DO, statement, ts?, WHILE, conditional_clause
DO := "do"
NULL := "null"
DOT := "."
iterator := variable_declared / address
LBRACE := "{"
RBRACE := "}"
LPAREN := "("
RPAREN := ")"
SEMI := ";"
COLON := ":"
COMMA := ","
EOL   := ("\r"?, "\n") / EOF
SPACE := " "
UNDERSCORE := "_"
APOS := "'"
QUOTE := '"'
IN_ITERATOR := "in"
