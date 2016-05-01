# as2cs

Tiny example of converting a bit of syntax from ActionScript to C#.  

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

To-do
=====

 * Convert basic example namespace bi-directionally:  C# to ActionScript.
 * Convert extended class declaration.
 * Preserve comments.
 * Convert function declaration.
 * Convert local variable.
 * Convert member variable.
 * Convert static variable.

Not supported
=============

 * Convert a sample of C# into ActionScript.
 * Test regardless of format.
 * typeof string format.
 * Mixing literals and non-literals in grammar to be replaced.
 * Multiple occurences of items that are reordered.  
  Instead these can be grouped, like 'digits?' instead of 'digit\*'.
 * Callbacks and delegates.
 * Preprocessor directive 'include'
 * Consistent prettify format that trims whitespace.
 * Prettify format from optional end of line and indentation in grammar.
 * Everything else not explicitly mentioned as a feature.

Reference code
==============

 * ActionScript 3 grammar in ANTLR3
  http://svn.badgers-in-foil.co.uk/metaas/trunk/src/main/antlr/org/asdt/core/internal/antlr/AS3.g
  http://stackoverflow.com/questions/1839146/as3-grammar-most-accurate
 * ECMAScript grammar in ANTLR3
  http://antlr3.org/grammar/1153976512034/ecmascriptA3.g
  http://stackoverflow.com/questions/1786565/ebnf-for-ecmascript
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
  https://en.wikipedia.org/wiki/DMS_Software_Reengineering_Toolkit
