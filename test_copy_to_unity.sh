#!/usr/bin/bash

python as2cs.py test/TestSyntax*.as \
&& cp -p test/TestSyntax*.cs ../../unity/anagram/Assets/Scripts/
cp -p DataUtil.cs ../../unity/anagram/Assets/Scripts/
