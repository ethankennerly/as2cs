#!/usr/bin/bash

python as2cs.py test/TestSyntaxModel.as && cp -p test/TestSyntaxModel.cs ../../unity/anagram/Assets/Scripts/
cp -p DataUtil.cs ../../unity/anagram/Assets/Scripts/
