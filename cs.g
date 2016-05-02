compilationUnit := importDefinitionPlace, namespaceDeclaration, LCURLY, classDefinitionPlace, RCURLY

import := "using"

namespace := "namespace"

variableDeclaration := ts?, argumentDeclaration
argumentDeclaration := dataType, ts, identifier

functionModified := ts, namespaceModifiers, returnType, ts, functionSignature
functionDefault := ts, returnType, ts, functionSignature

integer := "int"
string := "string"
boolean := "bool"
float := "float"
object := "object"
