compilationUnit := namespaceDeclaration, LCURLY, importDefinitionPlace, classDefinitionPlace, RCURLY


functionModified := ts, namespaceModifiers, functionSignature, (ts?, COLON, ts?, returnType)?
functionDefault := ts, functionSignature, (ts?, COLON, ts?, returnType)?

variableDeclaration := ts?, variableDeclarationKeyword, ts, argumentDeclaration
argumentDeclared := identifier, (ts?, COLON, ts?, dataType)?
argumentInitialized := identifier, (ts?, COLON, ts?, dataType)?, argumentInitializer

integer := "int"
string := "String"
boolean := "Boolean"
float := "Number"
object := "Object"
variableDeclarationKeyword := "var"

import := "import"

namespace := "package"


