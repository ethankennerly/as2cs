compilationUnit := importDefinitionPlace, namespaceDeclaration, 
    LCURLY, classDefinitionPlace, RCURLY

classBaseClause := ts, COLON, classBase
classExtends := ts, classIdentifier
interfaceFirst := ts, interfaceIdentifier
interfaceTypeListFollows := ts?, COMMA, ts, interfaceIdentifier, interfaceNextPlace

variableDeclaration := ts?, argumentDeclaration
argumentDeclared := dataType, ts, identifier
argumentInitialized := dataType, ts, identifier, argumentInitializer

functionModified := ts, namespaceModifiers, returnType, ts, functionSignature
functionDefault := ts, returnType, ts, functionSignature

floatFormat := float, float_suffix

INTEGER := "int"
STRING := "string"
BOOLEAN := "bool"
FLOAT := "float"
float_suffix := "f" / "F"
OBJECT := "object"
FINAL := "sealed"
import := "using"
namespace := "namespace"
