compilationUnit := namespaceDeclaration, LCURLY, importDefinitionPlace, classDefinitionPlace, RCURLY

classBaseClause := classBase
classExtends := ts, EXTENDS, ts, classIdentifier
interfaceFirst := ts, IMPLEMENTS, ts, interfaceIdentifier
interfaceTypeListFollows := ts, IMPLEMENTS, ts, interfaceIdentifier, interfaceNextPlace

functionModified := ts, namespaceModifiers, functionSignature, (ts?, COLON, ts?, returnType)?
functionDefault := ts, functionSignature, (ts?, COLON, ts?, returnType)?

variableDeclaration := ts?, VARIABLEDECLARATIONKEYWORD, ts, argumentDeclaration
argumentDeclared := identifier, (ts?, COLON, ts?, dataType)?
argumentInitialized := identifier, (ts?, COLON, ts?, dataType)?, argumentInitializer
floatFormat := float

INTEGER := "int"
STRING := "String"
BOOLEAN := "Boolean"
FLOAT := "Number"
OBJECT := "Object"
VARIABLEDECLARATIONKEYWORD := "var"
FINAL := "final"

import := "import"

namespace := "package"
EXTENDS := "extends"
IMPLEMENTS := "implements"

