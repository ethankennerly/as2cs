compilation_unit := import_definition_place, namespace_declaration, 
    LBRACE, class_definition_place, RBRACE
IMPORT := "using"
NAMESPACE := "namespace"

class_base_clause := ts, COLON, class_base
class_extends := ts, class_identifier
interface_first := ts, interface_identifier
interface_type_list_follows := ts?, COMMA, ts, interface_identifier, interface_next_place
FINAL := "sealed"

function_modified := ts, namespace_modifiers_place, return_type, ts, function_signature
function_default := ts, return_type, ts, function_signature
function_signature := identifier, function_parameters

delegate_argument_declaration := DELEGATE, whitespace, argument_declared, LPAREN, argument_list, RPAREN
delegate_no_argument_declaration := DELEGATE, whitespace, argument_declared, LPAREN, RPAREN
swap_type := MARKUP_START, as_type, MARKUP_END, cs_type
DELEGATE := "delegate"
variable_declaration := whitespace?, argument_declaration
constant_declaration := whitespace?, CONSTANT, whitespace, argument_declaration
argument_declared := data_type, ts, identifier
argument_initialized := data_type, ts, identifier, argument_initializer
collection_prefix := LIST
ARRAY_LIST := "ArrayList"
array_literal_prefix := NEW_ARRAY_LIST, ts?, LBRACE
array_literal_suffix := RBRACE
NEW_ARRAY_LIST := "new ArrayList()"
LIST := "List"
HASH_TABLE := "Hashtable"
STRING_HASH_TABLE := "Hashtable"
hash_literal_prefix := NEW_HASH_TABLE, ts?, LBRACE
hash_literal_suffix := RBRACE
NEW_HASH_TABLE := "new Hashtable()"
property := LBRACE, ts?, key, ts?, COMMA, ts, expression, ts?, RBRACE
quoted_identifier := QUOTE, identifier, QUOTE


for_in_statement := ts?, FOR_IN, ts?, LPAREN, ts?, HASH_ENTRY, ts, IN_ITERATOR, ts, expression, ts?, RPAREN, ts?, LBRACE, iterator, ASSIGN_KEY, ts, statement+, RBRACE
variable_declared := ts?, argument_declared
HASH_ENTRY := "DictionaryEntry _entry"
ASSIGN_KEY := " = (string)_entry.Key;"
FOR_IN := "foreach"

strict_equal_expression := REFERENCE_EQUAL, ts?, LPAREN, ts?, expression, COMMA, ts, expression, ts?, RPAREN
strict_not_equal_expression := LNOT, ts?, REFERENCE_EQUAL, ts?, LPAREN, ts?, expression, COMMA, ts, expression, ts?, RPAREN
REFERENCE_EQUAL := "object.ReferenceEquals"
contains_expression := 
    container_expression, ts?, DOT, ts?, CONTAINS, ts?, LPAREN, ts?, contained_expression, ts?, RPAREN
contains_not_expression := LNOT, ts?, 
    container_expression, ts?, DOT, ts?, CONTAINS, ts?, LPAREN, ts?, contained_expression, ts?, RPAREN
CONTAINS := "ContainsKey"
container_expression := container_address
container_address := identifier, container_subaddress*
container_subaddress := ts?, DOT, ts?, container_identifier
container_identifier := ?-CONTAINS, alphaunder, alphanumunder*
COLLECTION_LENGTH := "Count"
CLONE := "Clone()"
INDEX_OF := "IndexOf"
REMOVE_RANGE := "RemoveRange"
PUSH := "Add"

PARSE_INT := "int.Parse"
PARSE_FLOAT := "float.Parse"
DEBUG_LOG := "Debug.Log"

RANDOM := "(Random.value % 1.0f)"
MATH := "Mathf"
ABS := "Abs"
ACOS := "Cos"
ASIN := "Sin"
ATAN := "Atan"
ATAN2 := "Atan2"
CEIL := "Ceil"
COS := "Cos"
EXP := "Exp"
FLOOR := "Floor"
LOG := "Log"
MAX := "Max"
MIN := "Min"
PI := "PI"
POW := "Pow"
ROUND := "Round"
SIN := "Sin"
SQRT := "Sqrt"
TAN := "Tan"

cast_expression := ts?, LPAREN, ts?, reserved_data_type, ts?, RPAREN, ts?, left_hand_side_expression

float_format := float, float_suffix

literal_keyword := NULL
INTEGER := "int"
STRING := "string"
BOOLEAN := "bool"
FLOAT := "float"
float_suffix := "f" / "F"
OBJECT := "object"
DYNAMIC_TYPE := "dynamic"
UNDEFINED := NULL

