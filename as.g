compilationUnit := namespaceDeclaration, LCURLY, importDefinitionPlace, classDefinitionPlace, RCURLY


functionModified := ts, namespaceModifiers, functionSignature, (ts?, COLON, ts?, returnType)?
functionDefault := ts, functionSignature, (ts?, COLON, ts?, returnType)?

variableDeclaration := ts?, variableDeclarationKeyword, ts, argumentDeclaration
argumentDeclaration := identifier, (ts?, COLON, ts?, dataType)?

integer := "int"
string := "String"
boolean := "Boolean"
float := "Number"
object := "Object"
variableDeclarationKeyword := "var"

import := "import"

namespace := "package"


