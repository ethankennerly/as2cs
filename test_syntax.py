"""
Concise grammar unit test format in definitions.

definitions[definition]: [[input], [output]]

Related to gUnit:  Grammar unit test for ANTLR
https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
"""
import unittest
from as2cs import as2cs, parts


definitions = {
     'importDefinition': [
        ['import com.finegamedesign.anagram.Model;',
         'using com.finegamedesign.anagram.Model;'],
        ['import _2;',
         'using _2;'],
        ['import _;',
         'using _;'],
        ['import A;',
         'using A;'],
     ],
     'variableDeclaration': [
        ['var _:String;',
         'string _;'],
     ]
}


class TestDefinitions(unittest.TestCase):

    def assertExample(self, definition, row):
        try:
            self.assertEquals(row[1], as2cs(row[0], definition))
        except:
            print
            print definition, row
            print 'tag parts:'
            print parts(row[0], definition)
            raise

    def test_definitions(self):
        for definition, rows in definitions.items():
            for row in rows:
                self.assertExample(definition, row)


if '__main__' == __name__:
    unittest.main()
