compilationUnit := importDefinitionPlace, namespaceDeclaration, LCURLY, classDefinitionPlace, RCURLY

import := "using"

namespace := "namespace"

variableDeclaration := ts?, argumentDeclaration
argumentDeclared := dataType, ts, identifier
argumentInitialized := dataType, ts, identifier, argumentInitializer

functionModified := ts, namespaceModifiers, returnType, ts, functionSignature
functionDefault := ts, returnType, ts, functionSignature

integer := "int"
string := "string"
boolean := "bool"
float := "float"
object := "object"
