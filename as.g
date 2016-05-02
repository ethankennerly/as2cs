compilationUnit := namespaceDeclaration, LCURLY, importDefinitionPlace, classDefinitionPlace, RCURLY


functionModified := ts, namespaceModifiers, functionSignature, (ts?, COLON, ts?, returnType)?
functionDefault := ts, functionSignature, (ts?, COLON, ts?, returnType)?

variableDeclaration := ts?, variableDeclarationKeyword, ts, identifier, 
    (ts?, COLON, ts?, dataType)?, ts?, SEMI

integer := "int"
string := "String"
boolean := "Boolean"
float := "Number"
object := "Object"
variableDeclarationKeyword := "var"

import := "import"

namespace := "package"


