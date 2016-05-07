# as2cs

Tiny example of converting a bit of syntax from ActionScript 3 to C# and back from C# to ActionScript 3.  Compares compatible grammars.

Typographify example of using SimpleParse is from David Mertz' copyrighted article, cited in that directory.

Installation
============

Depends on Python SimpleParse 2.2.  You can install SimpleParse here:

https://pypi.python.org/pypi/SimpleParse/

Test discovery depends on Python 2.7 or higher.

Documentation
=============

SimpleParse:
http://www.ibm.com/developerworks/linux/library/l-simple/index.html
http://blog.dowski.com/2007/12/19/simpleparse-plug/
http://www.vrplumber.com/programming/simpleparse/simpleparse.html

EBNF:
http://simpleparse.sourceforge.net/simpleparse\_grammars.html

Features
========

 * Example doctest of import.
 * Run discovered doctests and unit tests:
    python test.py
    # or
    python -m unittest discover
 * Grammar unit test format related to gUnit.
 * Merge grammar declaration files.
 * Transcribe 'import' example of common base grammar.
 * Replace literal 'import' with 'using' by grammar.
 * Reformat an example variable declaration by grammar.
 * Convert trivial package with one import.
 * Convert empty base class declaration.
 * Convert basic example variables bi-directionally:  C# to ActionScript.
 * Convert simple namespace from C# to ActionScript.
 * Comment grammar adapted from simpleparse.common.comments 
  with literals extracted and no unreported or expanded definitions
 * Conform expected format in compilation unit test.
 * Preserve comments around namespace and class.
 * Convert function declaration.
 * Convert simple local variable assignment.
 * Convert floating point number suffix.
 * C# float suffix in capital case 'F'.
 * Convert member and static variables.
 * Distinguish if C# implements or extends only by prefix.  
  Interfaces are conventionally be prefixed by "I" and uppercase letter.
  Example:
    class A : IB {}
    class A implements IB {}
    class A : B {}
    class A extends B {}
    class A : It {}
    class A extends It {}
 * Convert extended class declaration.
 * Example file of all of the above.
 * Grammar literals in CAPITAL\_CASE following ANTLR grammar conventions.
 * Grammar ordered approximately in same order as the elements appear in a file.
 * Grammar names in snake\_case following simpleparsegrammar conventions.  Vim sed:
    %s/\([a-z]\)\([A-Z]\)/\1_\L\2/gIce
  http://vim.wikia.com/wiki/Switching\_case\_of\_characters
 * Equality operators.
 * Strictly equals to ReferenceEquals.
  http://stackoverflow.com/questions/4704388/using-equal-operators-in-c-sharp
 * ActionScript undefined to C# null.
 * ActionScript in operator to C# Contains only with some addresses.
 * Convert simple relational expressions verbatim.
 * If statement.
 * Shared assignment operators.
 * Array and hash access.
 * Create new object.
 * Ternary expression.
 * ActionScript Vector to C# List data type.
  http://stackoverflow.com/questions/3487690/multidimentional-vector-in-as3
 * Prefix import of C# collections.
    using System.Collections;
    using System.Collections.Generic;
 * ActionScript untyped Array to C# ArrayList data type.
 * ActionScript Object and Dictionary to C# Hashtable data type.
 * ActionScript Array literal.
  http://stackoverflow.com/questions/1723112/initializing-arraylist-with-constant-literal
 * Nested hash literal:  ActionScript JSON literal without quotes on keys.
 * For loop iteration.  Grammar is more permissive than a compiled for loop.

Not supported
=============

 * If you'd like to request a pull or fork to add a feature, that'd be appreciated!

 * While loop iteration.
 * Hash iteration over keys:  for in.
 * Constant declaration.
 * ActionScript type-casting to C# type-casting.
 * Explicit type-casting on access to a ArrayList to a data type.
 * ActionScript Array.concat to C# ArrayList.Clone.
 * ActionScript Array.push to C# ArrayList.Add.
 * Overriding virtual functions in C#.
  http://stackoverflow.com/questions/1327544/what-is-the-equivalent-of-javas-final-in-c
 * Interface definition.
 * ActionScript is keyword.
 * ActionScript as keyword.
 * ActionScript instanceof keyword.
 * JavaScript type keyword.
 * Nested function definitions.
 * Complex conditional expressions on shift operators, bitwise operators.
 * ActionScript 3 convention of no return type in constructor.
 * Declare multiple variables in a statement.
 * Variable return type declaration in ActionScript '\*'
 * C# typed Array to ActionScript typed Vector.
 * Hash literal without space before value in key value pair.
 * Recognize if C# needs to be converted to ActionScript Dictionary, or if an Object suffices.
 * C# Hashtable literal with addresses to ActionScript.
 * ActionScript only allows literal keyword, string, number default in signature.
 * Profile function hotspots in unit tests.
 * Reformat and reorder may insert some optional grammar, such as class base.
 * Reorder with nested grammar.  Otherwise the expanded form is needed, since the raw grammar text is parsed.
  This creates redundancy.  Example:
    contains_expression := expression, ts, IS_CONTAINED_IN, ts, container_expression
    contains_not_expression := LNOT, ts?, LPAREN, ts?, expression, ts, IS_CONTAINED_IN, ts, container_expression, ts?, RPAREN
 * Strict condition without whitespace around operator:
    a===b
    object.ReferenceEquals(a,b)
 * Distinguish order of operators that will be translated verbatim.
 * Anonymous function.
 * C# static class to ActionScript class.
 * Ungrouped ternary repetition
    i ? 1 : b ? c : 4
  Instead:
    i ? 1 : (b ? c : 4)
 * ActionScript dynamic class to C# class.
 * Insert C# explicit cast to another data type, such as from float to integer.
 * C# Generic classes and interfaces:
    class B<U,V> {...}
    class G<T>: B<string,T[]> {...}
 * C# nested classes:
    class A
    {
        class B: A {}
    }
 * Vim SimpleParse grammar syntax highlighter:
    / instead of |
    Comma required
    := assignment operator
 * ActionScript 3 argument list '...' syntax
 * Convert extended class declaration that has no whitespace:
    class A:B {}
 * Reordering syntax from nested definitions.  
  Example:  ActionScript 3 has a colon before data type.  Formatting scans this grammar.
    argumentDeclared := identifier, (ts?, COLON, ts?, dataType)?
    argumentDeclared := dataType, ts, identifier
  To convert both ways between argument declarations:
    path:String
    string path
 * Reformatting with optional parameters.  
  Instead I used two optional definitions, one which requires the option.  C# example:
    functionDeclaration := functionModified / functionDefault
    functionModified := ts, namespaceModifiers, returnType, ts, functionSignature
    functionDefault := ts, returnType, ts, functionSignature
 * Member variable and function declarations without preceding whitespace.  
  Instead have at least one space or tab before the.
  Whitespace is required to retain when reformatted.
 * Default data-type when omitted in ActionScript to explicit data type in C#.
 * JavaScript "Math.floor" to Unity C# "Mathf.Floor".
 * typeof string format.
 * Omitting semicolon at end of ActionScript.
 * Mixing literals and non-literals in grammar to be replaced.
 * Multiple occurences of items that are reordered.  
  Instead these can be grouped, like 'digits?' instead of 'digit\*'.
 * Callbacks and delegates.
 * Whitespace between grammar element and occurrence indicator.
 * Preprocessor directive 'include'
 * Consistent prettify format that trims whitespace.
 * Prettify format from optional end of line and indentation in grammar.
 * Regular expressions.
 * camelCase method names to CapitalCase method names.
 * ActionScript only allows one public class per package and one package per file.
 * Scope of variables declared a block are available outside the block in JavaScript.
 * C# does not have logical assignment.  ActionScript does.  Instead bitwise assignments exist.
 http://stackoverflow.com/questions/6346001/why-are-there-no-or-operators
 http://help.adobe.com/en\_US/FlashPlatform/reference/actionscript/3/operators.html
 * C# does not have bitwise unsigned shift:
    >>>
    >>>=
  nor bitwise not:
    ~=
  Both have bitwise shift:
    >>
 * Validate that initializations are last in a function parameter list.
 * JavaScript elision:
    var a = [, , ,];
 * Compiling bytecode.
 * Everything else not explicitly mentioned as a feature.

Reference code
==============

 * Intro to parsing and left-recursion.
  http://www.cs.kau.se/cs/education/courses/dvgc01/lectures/Syntax.pdf
 * ANTLR4 grammars
  https://github.com/antlr/grammars-v4
 * ActionScript 3 grammar in ANTLR3
  http://svn.badgers-in-foil.co.uk/metaas/trunk/src/main/antlr/org/asdt/core/internal/antlr/AS3.g
  http://stackoverflow.com/questions/1839146/as3-grammar-most-accurate
 * ECMAScript grammar in ANTLR3
  http://antlr3.org/grammar/1153976512034/ecmascriptA3.g
  http://stackoverflow.com/questions/1786565/ebnf-for-ecmascript
 * C# grammar
  https://msdn.microsoft.com/en-us/library/aa664812(v=vs.71).aspx
  https://github.com/ChristianWulf/CSharpGrammar/blob/master/grammars/CSharp4.g
  https://antlrcsharp.codeplex.com/
 * ANTLR by Terrence Parr
  https://en.wikipedia.org/wiki/ANTLR
 * Meta AS for ANTLR
  http://grepcode.com/snapshot/repo1.maven.org/maven2/cc.catalysts/metaas/0.9/
 * gUnit:  Grammar unit test for ANTLR
  https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
 * as2cs:  ActionScript to C# converter in Java by weeeBox
  https://github.com/weeeBox/oldies-bc-as3converter
 * as2js:  Partial ActionScript to JavaScript converter script
  https://github.com/ethankennerly/as2js
 * ActionScript 3 parser in Ruby
  https://github.com/gamemachine/as3/tree/master/parser
 * Program transformation system in DMS
  http://stackoverflow.com/questions/28711580/how-to-write-a-source-to-source-compiler-api
  https://en.wikipedia.org/wiki/DMS\_Software\_Reengineering\_Toolkit
