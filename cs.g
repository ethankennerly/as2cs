compilationUnit := importDefinitionPlace, namespaceDeclaration, LCURLY, classDefinitionPlace, RCURLY

import := "using"

namespace := "namespace"

variableDeclaration := ts?, dataType, ts, identifier, ts?, SEMI

functionModified := ts, namespaceModifiers, returnType, ts, functionSignature
functionDefault := ts, returnType, ts, functionSignature

integer := "int"
string := "string"
boolean := "bool"
float := "float"
object := "object"
