namespace_declared := namespace_declaration, LBRACE, import_definition_place, class_definition_place, RBRACE
namespace_default := NAMESPACE, ts?, LBRACE, import_definition_place, class_definition_place, RBRACE

namespace_sector_prefix := namespace_sector, DOT

NAMESPACE := "package"
IMPORT := "import"
import_class_clause := DOT, namespace_suffix, SEMICOLON

UNIT_TEST_ADDRESS := "asunit.framework.TestCase"
import_flash := ts?, IMPORT, whitespace, FLASH, DOT, address, SEMICOLON, EOL

test_class := ts?, scope, 
    whitespace, CLASS, whitespace, identifier, 
    whitespace, EXTENDS_TEST_CASE, class_block
EXTENDS_TEST_CASE := "extends TestCase"
class_base_clause := class_base
class_extends := ts, EXTENDS, ts, class_identifier
interface_first := ts, IMPLEMENTS, ts, interface_identifier
interface_type_list_follows := ts, IMPLEMENTS, ts, interface_identifier, interface_next_place
EXTENDS := "extends"
IMPLEMENTS := "implements"

function_modified := ts, namespace_modifiers_place, function_signature, ts?, COLON, ts?, return_type
function_default := ts, function_signature, ts?, COLON, ts?, return_type
function_signature := FUNCTION, ts, function_identifier, function_parameters

test_function := ts, PUBLIC, ts, FUNCTION, ts, test_function_identifier, ts?, LPAREN, ts?, RPAREN, ts?, COLON, ts?, VOID
test_function_identifier := TEST_PREFIX, identifier
TEST_PREFIX := "test"


delegate_argument_declaration := VARIABLE, whitespace, DELEGATE, whitespace, argument_declared, ts?, COMMA, whitespace, argument_list
delegate_no_argument_declaration := VARIABLE, whitespace, DELEGATE, whitespace, argument_declared
DELEGATE := "/*<delegate>*/"
swap_type := MARKUP_START, cs_type, MARKUP_END, as_type
variable_declaration := ts?, VARIABLE, whitespace, argument_declaration

member_variable_declaration := ts?, member_argument_declaration
member_argument_declaration := member_argument_declared / member_argument_initialized
instance_declaration := ts?, instance_modifiers_place, member_data_declaration, ts
instance_modifiers_place := MARKUP_START, instance_modifier, (ts, instance_modifier)*, MARKUP_END, whitespace
member_argument_initializer := ts?, COLON, ts?, !, assignment_value
member_argument_initialized := identifier, 
    (ts?, MARKUP_START, COLON, data_type, MARKUP_END)?,
    member_argument_initializer
member_argument_declared := identifier, 
    (ts?, MARKUP_START, COLON, data_type, MARKUP_END)?,
    ts?, COLON, ts, !, UNDEFINED


constant_declaration := ts?, CONSTANT, whitespace, argument_declaration
argument_data_type := ts?, MARKUP_START, COLON, data_type, MARKUP_END
argument_declared := identifier, 
    (ts?, MARKUP_START, COLON, data_type, MARKUP_END)?
argument_initialized := identifier, 
    (ts?, MARKUP_START, COLON, data_type, MARKUP_END)?,
    argument_initializer
collection_prefix := LIST, ts?, DOT
new_generic_collection := ARRAY_LIST, MARKUP_START, generic_collection, MARKUP_END
ARRAY_LIST := "Array"
LIST := "Vector"
STRING_HASH_TABLE := "Object"
HASH_TABLE := "Dictionary"
OBJECT := "Object"
array_literal_prefix := LBRACK
array_literal_suffix := RBRACK
list_literal_prefix := NEW, ts, list_literal_type, ts?, LBRACK
list_literal_type := template_type
list_literal_suffix := RBRACK
hash_literal_prefix := LBRACE
hash_literal_suffix := RBRACE
property := key, ts?, COLON, ts, expression
quoted_identifier := identifier

for_in_statement := ts?, FOR_IN, ts?, LPAREN, iterator, ts, IN_ITERATOR, !, ts, expression, ts?, RPAREN, ts?, LBRACE, statement_place, ts?, RBRACE
variable_declared := ts?, VARIABLE, ts, argument_declared
FOR_IN := "for"

strict_equal_expression := expression, ts, STRICT_EQUAL, ts, expression
strict_not_equal_expression := expression, ts, STRICT_NOT_EQUAL, ts, expression
contains_expression := 
    contained_expression, ts, IS_CONTAINED_IN, ts, container_expression
contains_not_expression := LNOT, ts?, LPAREN, ts?, 
    contained_expression, ts, IS_CONTAINED_IN, ts, container_expression, ts?, RPAREN
container_expression := container_address
container_address := identifier, container_subaddress*
container_subaddress := ts?, DOT, ts?, container_identifier
container_identifier := alphaunder, alphanumunder*
literal_keyword := NULL / UNDEFINED

STRICT_EQUAL := "==="
STRICT_NOT_EQUAL := "!=="

COLLECTION_LENGTH := "length"
CLONE_CALL := "concat()"
TO_STRING := "toString"
INDEX_OF := "indexOf"
SORT := "sort"
LAST_INDEX_OF := "lastIndexOf"
PUSH := "push"
REMOVE_RANGE := "splice"
TO_LOWER_CASE := "toLowerCase"

collection_clone := ts?, clone_address, ts?, DOT, ts?, CLONE_CALL
clone_call := ts?, clone_address, ts?, DOT, ts?, CLONE_CALL
delete_expression := ts?, DELETE, ts, identifier, ts?, LBRACK, ts?, address, ts?, RBRACK
DELETE := "delete"
ERROR := "Error"


assert_equals_with_message_call := ASSERT_EQUALS, ts?, LPAREN, 
    ts?, message_expression, 
    ts?, COMMA, whitespace, ts?, expected_expression, 
    ts?, COMMA, whitespace, ts?, got_expression, 
    ts?, RPAREN
ASSERT_EQUALS := "assertEquals"

PARSE_INT := "parseInt"
PARSE_FLOAT := "parseFloat"
DEBUG_LOG := "cc.log"

RANDOM := "Math.random()"
MATH := "Math"
ABS := "abs"
ACOS := "acos"
ASIN := "asin"
ATAN := "atan"
ATAN2 := "atan2"
CEIL := "ceil"
COS := "cos"
EXP := "exp"
FLOOR := "floor"
LOG := "log"
MAX := "max"
MIN := "min"
PI := "PI"
POW := "pow"
ROUND := "round"
SIN := "sin"
SQRT := "sqrt"
TAN := "tan"

cast_expression := ts?, reserved_data_type, ts?, LPAREN, ts?, expression, ts?, RPAREN
nullable_cast_expression := ts?, left_hand_side_expression, ts, MARKUP_START, AS, ts, data_type, MARKUP_END
IS := "instanceof"

float_format := float

UNDEFINED := "undefined"
VECTOR2 := "Point"
COLLIDER2D := "DisplayObject"
SCENE_NODE := "DisplayObjectContainer"
CONCRETE_SCENE_NODE := "Sprite"
ANIMATED_SCENE_NODE := "MovieClip"
TEXT_NODE := "TextField"
INTEGER := "int"
STRING := "String"
BOOLEAN := "Boolean"
FLOAT := "Number"
VARIABLE := "var"
DYNAMIC_TYPE := "*"
FINAL := "final"
IS_CONTAINED_IN := "in"
