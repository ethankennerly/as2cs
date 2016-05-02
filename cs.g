compilationUnit := importDefinitionPlace, namespaceDeclaration, LCURLY, classDefinitionPlace, RCURLY

import := "using"

namespace := "namespace"

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
OBJECT := "object"
float_suffix := "f" / "F"
