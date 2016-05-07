compilation_unit := namespace_declaration, LBRACE, import_definition_place, class_definition_place, RBRACE
NAMESPACE := "package"
IMPORT := "import"

class_base_clause := class_base
class_extends := ts, EXTENDS, ts, class_identifier
interface_first := ts, IMPLEMENTS, ts, interface_identifier
interface_type_list_follows := ts, IMPLEMENTS, ts, interface_identifier, interface_next_place
EXTENDS := "extends"
IMPLEMENTS := "implements"

function_modified := ts, namespace_modifiers, function_signature, (ts?, COLON, ts?, return_type)?
function_default := ts, function_signature, (ts?, COLON, ts?, return_type)?

variable_declaration := ts?, VARIABLE, ts, argument_declaration
argument_declared := identifier, (ts?, COLON, ts?, data_type)?
argument_initialized := identifier, (ts?, COLON, ts?, data_type)?, argument_initializer
collection_prefix := LIST, ts?, DOT
ARRAY_LIST := "Array"
LIST := "Vector"
STRING_HASH_TABLE := "Object"
HASH_TABLE := "Dictionary"
OBJECT := "Object"
array_literal_prefix := LBRACK
array_literal_suffix := RBRACK
hash_literal_prefix := LBRACE
hash_literal_suffix := RBRACE
property := key, ts?, COLON, ts, expression
quoted_identifier := identifier

for_in_statement := ts?, FOR_IN, ts?, LPAREN, iterator, ts, IN_ITERATOR, ts, expression, ts?, RPAREN, ts?, LBRACE, statement+, RBRACE
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

float_format := float

UNDEFINED := "undefined"
INTEGER := "int"
STRING := "String"
BOOLEAN := "Boolean"
FLOAT := "Number"
VARIABLE := "var"
FINAL := "final"
IS_CONTAINED_IN := "in"
