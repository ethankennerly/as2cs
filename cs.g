compilation_unit := import_definition_place, namespace_declaration, 
    LCURLY, class_definition_place, RCURLY
IMPORT := "using"
NAMESPACE := "namespace"

class_base_clause := ts, COLON, class_base
class_extends := ts, class_identifier
interface_first := ts, interface_identifier
interface_type_list_follows := ts?, COMMA, ts, interface_identifier, interface_next_place
FINAL := "sealed"

function_modified := ts, namespace_modifiers, return_type, ts, function_signature
function_default := ts, return_type, ts, function_signature

variable_declaration := ts?, argument_declaration
argument_declared := data_type, ts, identifier
argument_initialized := data_type, ts, identifier, argument_initializer

float_format := float, float_suffix

INTEGER := "int"
STRING := "string"
BOOLEAN := "bool"
FLOAT := "float"
float_suffix := "f" / "F"
OBJECT := "object"
