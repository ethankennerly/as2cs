compilationUnit := namespaceDeclaration, LCURLY, importDefinitionPlace, classDefinitionPlace, ts?, RCURLY

variableDeclaration := ts?, variableDeclarationKeyword, ts, identifier, (COLON, dataType)?, ts?, SEMI

integer := "int"
string := "String"
boolean := "Boolean"
float := "Number"
object := "Object"
variableDeclarationKeyword := "var"

import := "import"

namespace := "package"
