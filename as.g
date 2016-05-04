compilation_unit := namespace_declaration, LCURLY, import_definition_place, class_definition_place, RCURLY
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

strict_equal_expression := expression, ts, STRICT_EQUAL, ts, expression
strict_not_equal_expression := expression, ts, STRICT_NOT_EQUAL, ts, expression
contains_expression := 
    contained_expression, ts, IS_CONTAINED_IN, ts, container_expression
contains_not_expression := LNOT, ts?, LPAREN, ts?, 
    contained_expression, ts, IS_CONTAINED_IN, ts, container_expression, ts?, RPAREN
container_expression := identifier
STRICT_EQUAL := "==="
STRICT_NOT_EQUAL := "!=="

literal_keyword := NULL / UNDEFINED

float_format := float

UNDEFINED := "undefined"
INTEGER := "int"
STRING := "String"
BOOLEAN := "Boolean"
FLOAT := "Number"
OBJECT := "Object"
VARIABLE := "var"
FINAL := "final"
IS_CONTAINED_IN := "in"
