"""
Concise grammar unit test format in definitions.

definitions[definition]: [[input], [output]]

Related to gUnit:  Grammar unit test for ANTLR
https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
"""
from glob import glob
import unittest
from as2cs import cfg, convert, compare_files, format_taglist, realpath


directions = [
    ['as', 'cs', 0, 1],
    ['cs', 'as', 1, 0],
]

definitions = [
     ('importDefinition', [
        ['import com.finegamedesign.anagram.Model;',
         'using com.finegamedesign.anagram.Model;'],
        ['import _2;',
         'using _2;'],
        ['import _;',
         'using _;'],
        ['import A;',
         'using A;'],
     ]),
     ('dataType', [
        ['int', 'int'],
        ['String', 'string'],
        ['Boolean', 'bool'],
        ['Number', 'float'],
     ]),
     ('classDefinition', [
        ['class C{}', 'class C{}'],
        ['public class PC{}', 'public class PC{}'],
        ['internal class IC{}', 'internal class IC{}'],
     ]),
     ('variableDeclaration', [
        ['var path:String;',
         'string path;'],
        ['var index:int;',
         'int index;'],
     ]),
     ('compilationUnit', [
        ['package{public class C{}}', 'namespace{\n    public class C{\n    }\n}'],
        ['package{class C{}}', 'namespace{\n    class C{\n    }\n}'],
        ['package{public class C{\n}}', 'namespace{\n    public class C{\n    }\n}'],
        ['package{\n    import A;\npublic class C{\n}}', '\nusing A;\nnamespace{\n    public class C{\n    }\n}'],
        ['package{\npublic class C1{}}', 'namespace{\n    public class C1{\n    }\n}'],
        ['package{public class C2{}\n}', '\nnamespace{\n    public class C2{\n    }\n}'],
        ['package{\npublic class C3{\n}\n}', '\nnamespace{\n    public class C3{\n    }\n}'],
        ['package N\n{\npublic class C4{\n}\n}\n', 'namespace\nN\n{\n    public class C4{\n    }\n}'],
     ]),
]


debug_definitions = [
    # 'variableDeclaration'
]

original_source = cfg['source']
original_to = cfg['to']


class TestDefinitions(unittest.TestCase):

    def assertExample(self, definition, expected, input):
        try:
            got = convert(input, definition, is_disable_format = False)
            self.assertEqual(expected, got)
        except:
            print
            print definition, expected, got
            print 'Expected:'
            print expected
            print 'Got:'
            print got
            print 'tag parts:'
            print format_taglist(input, definition)
            raise

    def test_definitions(self):
        for source, to, s, t in directions:
            cfg['source'] = source
            cfg['to'] = to
            for definition, rows in definitions:
                if definition in debug_definitions:
                    import pdb; pdb.set_trace()
                for row in rows:
                    expected = row[t]
                    input = row[s]
                    self.assertExample(definition, expected, input)
        cfg['source'] = original_source 
        cfg['to'] = original_to 

    def test_files(self):
        cfg['source'] = original_source 
        cfg['to'] = original_to 
        pattern = 'test/*.%s' % cfg['source']
        paths = glob(realpath(pattern))
        expected_gots = compare_files(paths)
        for expected, got in expected_gots:
            try:
                self.assertEqual(expected, got)
            except:
                print
                print 'Expected:'
                print expected
                print 'Got:'
                print got
                raise


if '__main__' == __name__:
    unittest.main()
