compilation_unit := namespace_declared / namespace_default
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
MARKUP_START := "/*<"
MARKUP_END := ">*/"

namespace_sector := COM / ORG / NET
COM := "com"
ORG := "org"
NET := "net"
namespace_declaration := ts?, NAMESPACE, ts, 
    namespace_sector_prefix?, 
    namespace_address
    , ts?
import_definition_place := import_definition*
import_definition := import_flash / (ts?, IMPORT, ts, !, import_address, EOL?)
import_address := (import_address_replaced, SEMICOLON) /
    ( namespace_sector_prefix?, 
    namespace_identifier, (import_class_clause / import_subaddress)+)
import_address_replaced := UNIT_TEST_ADDRESS
import_subaddress := ts?, DOT, ts?, namespace_identifier
namespace_address := namespace_identifier, ts?, (DOT, ts?, namespace_identifier)*
namespace_identifier := identifier
namespace_suffix := GLOB_ALL / identifier
GLOB_ALL := "*"
FLASH := "flash"

class_definition_place := class_definition?, ts?
class_definition := test_class 
    / (ts?, class_modifier*, CLASS, ts, identifier, class_base_clause?, 
        class_block)
class_block := ts?, LBRACE, member_expression*, ts?, RBRACE
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
member_declaration := instance_declaration / static_declaration
static_declaration := ts?, static_modifiers_place, member_data_declaration, ts?, !, SEMICOLON
member_data_declaration := delegate_declaration / constant_declaration / member_variable_declaration
data_declaration := delegate_declaration / constant_declaration / variable_declaration
delegate_declaration := delegate_argument_declaration / delegate_no_argument_declaration
CONSTANT := "const"
static_modifiers_place := static_modifier, (ts, static_modifier)*, whitespace
instance_modifiers_place := instance_modifier, (ts, instance_modifier)*, whitespace
namespace_modifiers_place := namespace_modifier, (ts, namespace_modifier)*, whitespace
namespace_modifier := scope / STATIC / FINAL / OVERRIDE
instance_modifier := scope / FINAL / OVERRIDE
static_modifier := scope / STATIC / FINAL / OVERRIDE
function_body := ts?, LBRACE, !, statement_place, ts?, RBRACE
function_declaration := test_function / function_modified / function_default / constructor
constructor := ts?, namespace_modifiers_place?, function_signature
function_identifier := identifier
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
member_argument_declaration := member_argument_initialized / member_argument_declared
argument_initializer := ts?, ASSIGN, ts?, !, assignment_value
member_argument_initializer := ts?, ASSIGN, ts?, !, assignment_value
assignment_value := conditional_expression / expression
variable_assignment := address, ts?, assignment_operator, ts?, assignment_value
address := (new_expression / replaced_address / identifier), address_tail*
function_address := (identifier / bracket_expression, DOT)*, replaced_property / function_identifier
address_tail := ts?, 
    (DOT, ts?, (replaced_property / identifier)) / bracket_expression
bracket_expression := LBRACK, ts?, expression, ts?, RBRACK
LBRACK := "["
RBRACK := "]"
call_expression := reordered_call / call_address, (ts?, DOT, ts?, 
                   reordered_call / call_address)*
call_address := replaced_address / function_address / address, ts?, LPAREN, ts?, expression_list?, ts?, RPAREN
reordered_call := clone_call / assert_equals_with_message_call / assert_equals_call / to_string_call
to_string_call := ts?, TO_STRING, ts?, LPAREN, ts?, RPAREN

assert_equals_call := ASSERT_EQUALS, ts?, LPAREN, 
    ts?, expected_expression, ts?, COMMA, whitespace, 
    ts?, got_expression, ts?, RPAREN
expected_expression := expression
got_expression := expression
message_expression := expression

clone_address := (new_expression / replaced_address / identifier), clone_address_tail*
clone_address_tail := ts?, 
    (DOT, ts?, not_clone_identifier)
not_clone_identifier := ?-CLONE_CALL, alphaunder, alphanumunder*
replaced_address := PARSE_INT / PARSE_FLOAT / unity_address / TYPEOF
TYPEOF := "typeof"
unity_address := DEBUG_LOG / RANDOM / math_address
replaced_property := 
    string_property / collection_property,
    EOF / ?-(alphanumunder / DOT)
string_property := TO_LOWER_CASE
collection_property := COLLECTION_LENGTH / CLONE_CALL / PUSH 
    / INDEX_OF / LAST_INDEX_OF / REMOVE_RANGE / SORT

math_address := MATH, ts?, DOT, ts?, math_property
math_property := ABS / ACOS / ASIN / ATAN / ATAN2
    / CEIL / COS / EXP / FLOOR / LOG / MAX / MIN
    / PI / POW / ROUND / SIN / SQRT / TAN

identifier := alphaunder, alphanumunder*
alphanumunder := digit / alphaunder
alphaunder := letter / UNDERSCORE
reserved_data_type := SCENE_NODE / VECTOR2 / COLLIDER2D / CONCRETE_SCENE_NODE / ANIMATED_SCENE_NODE / TEXT_NODE
	/ INTEGER / STRING / BOOLEAN / FLOAT / DYNAMIC_TYPE / OBJECT
data_type := swap_type / collection_type / reserved_data_type / address
sub_data_type := collection / STRING_HASH_TABLE / sub_generic_collection / reserved_data_type / address
collection_type := collection / STRING_HASH_TABLE / generic_collection 
return_type := data_type / VOID
as_type := data_type
cs_type := data_type
collection_type := collection / STRING_HASH_TABLE / generic_collection 
generic_collection := collection_prefix, ts?, LT, ts?, sub_data_type, ts?, GT
sub_generic_collection := collection_prefix, ts?, LT, ts?, sub_data_type, ts?, GT
new_generic_collection := generic_collection
template_type := ts?, LT, ts?, data_type, ts?, GT
collection := ARRAY_LIST / HASH_TABLE
array_literal := array_literal_prefix, ts?, expression_list?, ts?, array_literal_suffix
string_hash_literal := hash_literal_prefix, ts?, property_list?, ts?, hash_literal_suffix
list_literal := list_literal_prefix, ts?, expression_list?, ts?, list_literal_suffix
property_list := property, (ts?, COMMA, ts?, property)*
key := quoted_identifier / literal

statement := ts?, 
    block 
    / if_statement
    / iteration_statement
    / (
        primary_expression, ts?, !, SEMICOLON
    )
    / (ts?, SEMICOLON)

block := LBRACE, !, statement_place, ts?, RBRACE
return_expression := ts?, RETURN, (ts, 
    conditional_expression / expression)?
RETURN := "return"
primary_expression := return_expression / delete_expression / throw_expression / data_declaration / expression
throw_expression := ts?, THROW, ts, NEW, ts?, ERROR, ts?, LPAREN, ts?, expression, ts?, RPAREN
THROW := "throw"
expression := 
    array_literal
    / string_hash_literal
    / list_literal
    / variable_assignment
    / logical_expression
    / relational_expression
    / left_hand_side_expression

new_expression := NEW, ts, data_type, ts?, LPAREN, ts?, expression_list?, ts?, RPAREN
NEW := "new"
expression_list := ts?, conditional_expression / expression, (ts?, COMMA, ts?, conditional_expression / expression)*

left_hand_side_expression := 
    literal
    / call_expression
    / new_expression
    / address
    / conditional_clause

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
    / ternary_expression
    / variable_assignment
    / logical_expression
    / relational_expression
    / expression

ternary_expression := logical_expression, ts?, QUESTION, ts?, assignment_value, ts?, COLON, ts?, assignment_value
QUESTION := "?"

conditional_function := 
    contains_not_expression / contains_expression
    / strict_not_equal_expression / strict_equal_expression 
contained_expression := expression

logical_expression := (ts?, relational_expression, logical_expression_tail*)
logical_expression_tail := ts?, logical_operator, ts?, logical_expression
relational_expression := (ts?, unary_expression, relational_expression_tail*)
relational_expression_tail := ts?, computational_operator, ts?, relational_expression

unary_expression :=
    reordered_call
    / collection_clone
    / cast_expression
    / is_expression
    / nullable_cast_expression
    / postfix_expression
    / prefix_expression
    / left_hand_side_expression
LNOT := "!"
nullable_cast_expression := ts?, left_hand_side_expression, ts, AS, ts, data_type
AS := "as"
is_expression := ts?, left_hand_side_expression, ts, IS, ts, data_type
IS := "is"

prefix_expression := (PLUS2 / MINUS2 / PLUS / MINUS / LNOT), ts?, left_hand_side_expression
PLUS2 := "++"
MINUS2 := "--"

postfix_expression := left_hand_side_expression, ts?, (PLUS2 / MINUS2)
PLUS2 := "++"
MINUS2 := "--"

computational_operator :=
    comparison_operator
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

statement_place := statement*
iteration_statement := for_in_statement / for_statement / do_statement / while_statement
for_statement := ts?, FOR, ts?, LPAREN, !, statement, statement, expression_list?, RPAREN, statement
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
SEMICOLON := ";"
COLON := ":"
COMMA := ","
EOL   := ("\r"?, "\n") / EOF
SPACE := " "
UNDERSCORE := "_"
APOS := "'"
QUOTE := '"'
IN_ITERATOR := "in"
