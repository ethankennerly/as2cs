compilationUnit := importDefinitionPlace, namespaceDeclaration, 
    LCURLY, classDefinitionPlace, RCURLY
IMPORT := "using"
NAMESPACE := "namespace"

classBaseClause := ts, COLON, classBase
classExtends := ts, classIdentifier
interfaceFirst := ts, interfaceIdentifier
interfaceTypeListFollows := ts?, COMMA, ts, interfaceIdentifier, interfaceNextPlace
FINAL := "sealed"

functionModified := ts, namespaceModifiers, returnType, ts, functionSignature
functionDefault := ts, returnType, ts, functionSignature

variableDeclaration := ts?, argumentDeclaration
argumentDeclared := dataType, ts, identifier
argumentInitialized := dataType, ts, identifier, argumentInitializer

floatFormat := float, float_suffix

INTEGER := "int"
STRING := "string"
BOOLEAN := "bool"
FLOAT := "float"
float_suffix := "f" / "F"
OBJECT := "object"
