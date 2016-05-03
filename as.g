compilationUnit := namespaceDeclaration, LCURLY, importDefinitionPlace, classDefinitionPlace, RCURLY
NAMESPACE := "package"
IMPORT := "import"

classBaseClause := classBase
classExtends := ts, EXTENDS, ts, classIdentifier
interfaceFirst := ts, IMPLEMENTS, ts, interfaceIdentifier
interfaceTypeListFollows := ts, IMPLEMENTS, ts, interfaceIdentifier, interfaceNextPlace
EXTENDS := "extends"
IMPLEMENTS := "implements"

functionModified := ts, namespaceModifiers, functionSignature, (ts?, COLON, ts?, returnType)?
functionDefault := ts, functionSignature, (ts?, COLON, ts?, returnType)?

variableDeclaration := ts?, VARIABLE, ts, argumentDeclaration
argumentDeclared := identifier, (ts?, COLON, ts?, dataType)?
argumentInitialized := identifier, (ts?, COLON, ts?, dataType)?, argumentInitializer
floatFormat := float

INTEGER := "int"
STRING := "String"
BOOLEAN := "Boolean"
FLOAT := "Number"
OBJECT := "Object"
VARIABLE := "var"
FINAL := "final"
