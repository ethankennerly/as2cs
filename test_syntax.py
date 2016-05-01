"""
Concise grammar unit test format in definitions.

definitions[definition]: [[input], [output]]

Related to gUnit:  Grammar unit test for ANTLR
https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
"""
from glob import glob
import unittest
from as2cs import cfg, convert, compare_files, \
    format_taglist, may_format, realpath


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
     ('ts', [
        ['/*c*/', '/*c*/'],
        ['//c', '//c'],
        ['// var i:int;', '// var i:int;'],
     ]),
     ('compilationUnit', [
        ['package{public class C{}}', 
         'namespace{\n    public class C{\n    }\n}'],
        ['package{class C{}}',
         'namespace{\n    class C{\n    }\n}'],
        ['package{public class C{\n}}',
         'namespace{\n    public class C{\n    }\n}'],
        ['package{\n    import A;\npublic class C{\n}}',
         '\nusing A;\nnamespace{\n    public class C{\n    }\n}'],
        ['package{\npublic class C1{}}',
         'namespace{\n    public class C1{\n    }\n}'],
        ['package{public class C2{}\n}',
         'namespace{\n    public class C2{\n    }\n}'],
        ['package{\npublic class C3{\n}\n}',
         'namespace{\n    public class C3{\n    }\n}'],
        ['package N\n{\npublic class C4{\n}\n}\n',
         'namespace N\n{\n    public class C4{\n    }\n}'],
        ['//c\npackage N\n{\npublic class C5{\n}\n}\n',
         '//c\nnamespace N\n{\n    public class C5{\n    }\n}'],
        ['package N\n{\n//c\npublic class C7{\n}\n}\n',
         'namespace N\n{\n    //c\n    public class C7{\n    }\n}'],
        ['/*c*/\npackage N\n{\npublic class C6{\n}\n}\n',
         '/*c*/\nnamespace N\n{\n    public class C6{\n    }\n}'],
     ]),
]


debug_definitions = [
    # 'compilationUnit'
    # 'importDefinition'
    # 'ts'
    # 'variableDeclaration'
]

debug_indexes = [
    # 9
]

original_source = cfg['source']
original_to = cfg['to']


class TestDefinitions(unittest.TestCase):

    def assertExample(self, definition, expected, input, index):
        got = None
        try:
            expected = may_format(definition, expected)
            if definition in debug_definitions:
                if not debug_indexes or index in debug_indexes:
                    import pdb; pdb.set_trace()
            got = convert(input, definition)
            self.assertEqual(expected, got)
        except Exception as err:
            if got is None:
                got = err.message
            print
            print definition, index, expected, got
            print 'Input:'
            print input
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
                for r, row in enumerate(rows):
                    expected = row[t]
                    input = row[s]
                    self.assertExample(definition, expected, input, r)
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
