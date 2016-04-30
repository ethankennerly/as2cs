"""
Concise grammar unit test format in definitions.

definitions[definition]: [[input], [output]]

Related to gUnit:  Grammar unit test for ANTLR
https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
"""
from glob import glob
import unittest
from as2cs import convert, convert_files, format_taglist, realpath


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
     'dataType': [
        ['String', 'string']
     ],
     'variableDeclaration': [
        ['var path:String;',
         'string path;'],
     ]
}


debug_definitions = [
    # 'variableDeclaration'
]

class TestDefinitions(unittest.TestCase):

    def assertExample(self, definition, row):
        try:
            self.assertEquals(row[1], convert(row[0], definition))
        except:
            print
            print definition, row
            print 'tag parts:'
            print format_taglist(row[0], definition)
            raise

    def test_definitions(self):
        for definition, rows in definitions.items():
            if definition in debug_definitions:
                import pdb; pdb.set_trace()
            for row in rows:
                self.assertExample(definition, row)

    def test_files(self):
        import pdb; pdb.set_trace()
        convert_files(glob(realpath('test/*.as')))


if '__main__' == __name__:
    unittest.main()