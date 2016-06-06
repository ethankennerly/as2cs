namespace_declared := import_definition_place, namespace_declaration, 
    LBRACE, class_definition_place, RBRACE
namespace_default := import_definition_place, class_definition_place
IMPORT := "using"
NAMESPACE := "namespace"
import_suffix := ""
import_class_clause := MARKUP_START, namespace_identifier, MARKUP_END, SEMICOLON
UNIT_TEST_ADDRESS := "NUnit.Framework"

test_class := ts?, TEST_FIXTURE_TAG, whitespace, scope, 
    whitespace, CLASS, whitespace, identifier, 
    class_block
TEST_FIXTURE_TAG := "[TestFixture]"

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
list_literal_prefix := NEW, ts, list_literal_type, ts?, LPAREN, ts?, RPAREN, ts?, LBRACE
list_literal_type := LIST, ts?, template_type
list_literal_suffix := RBRACE
LIST := "List"
HASH_TABLE := "Hashtable"
STRING_HASH_TABLE := "Dictionary<string, dynamic>"
hash_literal_prefix := NEW_HASH_TABLE, ts?, LBRACE
hash_literal_suffix := RBRACE
NEW_HASH_TABLE := "new Dictionary<string, dynamic>()"
property := LBRACE, ts?, key, ts?, COMMA, ts, expression, ts?, RBRACE
quoted_identifier := QUOTE, identifier, QUOTE


for_in_statement := ts?, FOR_IN, ts?, LPAREN, ts?, STRING_HASH_ENTRY, ts, IN_ITERATOR, !, ts, expression, ts?, RPAREN, ts?, LBRACE, iterator, ASSIGN_KEY, ts, statement_place, ts?, RBRACE
variable_declared := ts?, argument_declared
STRING_HASH_ENTRY := "KeyValuePair<string, dynamic> _entry"
ASSIGN_KEY := " = _entry.Key;"
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
CLONE_CALL := "Clone()"
INDEX_OF := "IndexOf"
LAST_INDEX_OF := "LastIndexOf"
PUSH := "Add"
REMOVE_RANGE := "RemoveRange"
TO_LOWER_CASE := "ToLower"

collection_clone := ts?, NEW, ts, collection_type, ts?, LPAREN, ts?, clone_address, ts?, RPAREN
clone_call := ts?, NEW, ts, declared_type, ts?, LPAREN, ts?, clone_address, ts?, RPAREN
TO_STRING := "ToString"
delete_expression := ts?, identifier, ts?, DOT, ts?, REMOVE, ts?, LPAREN, ts?, address, ts?, RPAREN
REMOVE := "Remove"

declared_type := "ArrayList"
NEW_ARRAYLIST := "new ArrayList"

test_function := ts, TEST_TAG, ts, PUBLIC, ts, VOID, ts, test_function_identifier, ts?, LPAREN, ts?, RPAREN
test_function_identifier := identifier
TEST_TAG := "[Test]"

assert_equals_with_message_call := ASSERT_EQUALS, ts?, LPAREN, 
    ts?, expected_expression, 
    ts?, COMMA, whitespace, ts?, got_expression, 
    ts?, COMMA, whitespace, ts?, message_expression, 
    ts?, RPAREN
ASSERT_EQUALS := "Assert.AreEqual"

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

cast_expression := ts?, LPAREN, ts?, reserved_data_type, ts?, RPAREN, ts?, LPAREN, ts?, expression, ts?, RPAREN

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

