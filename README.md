# as2cs

Tiny example of converting a bit of syntax from ActionScript to C#.  

Typographify example of using SimpleParse is from David Mertz' copyrighted article, cited in that directory.

Installation
============

Depends on Python SimpleParse 2.2.  You can install SimpleParse here:

https://pypi.python.org/pypi/SimpleParse/

Test discovery depends on Python 2.7 or higher.

Features
========

 * Example doctest of import.
 * Run discovered doctests and unit tests:
    python test.py
    # or
    python -m unittest discover
 * Grammar unit test format related to gUnit.

To-do
=====

 * Merge grammar definition files.
 * Recognize identical grammar definition.
 * as.def, cs.def package, import
 * Convert cs.def to formatter, analogous to a string template in ANTLR.

Not supported
=============

 * Preprocessor directive 'include'
 * Everything else not explicitly mentioned as a feature.

Reference code
==============

 * ActionScript 3 grammar in ANTLR
  http://svn.badgers-in-foil.co.uk/metaas/trunk/src/main/antlr/org/asdt/core/internal/antlr/AS3.g
  http://stackoverflow.com/questions/1839146/as3-grammar-most-accurate
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
