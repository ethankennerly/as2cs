"""
Concise grammar unit test format in definitions.

definitions[definition]: [[input], [output]]

Related to gUnit:  Grammar unit test for ANTLR
https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
"""


from glob import glob
from unittest import main, TestCase

from as2cs import cfg, convert, compare_files, \
    format_taglist, may_format, realpath
from pretty_print_code.pretty_print_code import format_difference

directions = [
    ['as', 'cs', 0, 1],
    ['cs', 'as', 1, 0],
]

definitions = [
     ('data_type', [
        ['int', 'int'],
        ['String', 'string'],
        ['Boolean', 'bool'],
        ['Number', 'float'],
     ]),
     ('identifier', [
        ['_a', '_a'],
        ['_2', '_2'],
        ['I', 'I'],
        ['b', 'b'],
     ]),
     ('address', [
        ['_a', '_a'],
        ['salad', 'salad'],
        ['OIL', 'OIL'],
        ['_0._1._2', '_0._1._2'],
     ]),
     ('import_definition', [
        ['import com.finegamedesign.anagram.Model;',
         'using com.finegamedesign.anagram.Model;'],
        ['import _2;',
         'using _2;'],
        ['import _;',
         'using _;'],
        ['import A;',
         'using A;'],
     ]),
     ('class_definition', [
        ['class C{}', 'class C{}'],
        ['public class PC{}', 'public class PC{}'],
        ['internal class IC{}', 'internal class IC{}'],
     ]),
     ('ts', [
        ['/*c*/', '/*c*/'],
        ['//c', '//c'],
        ['// var i:int;', '// var i:int;'],
     ]),
     ('namespace_modifiers', [
        ['public ', 
         'public '],
        ['private static ', 
         'private static '],
        ['static private ', 
         'static private '],
     ]),
     ('function_declaration', [
        ['  function f():void', 
         '  void function f()'],
        ['    function g( ):void', 
         '    void function g( )'],
     ]),
     ('function_definition', [
        ['  function f():void{}', 
         '  void function f(){}'],
        [' function f():void{}', 
         ' void function f(){}'],
        [' public function f():void{}', 
         ' public void function f(){}'],
        [' internal function isF():Boolean{}', 
         ' internal bool function isF(){}'],
        [' protected function getF():Number{}', 
         ' protected float function getF(){}'],
     ]),
     ('argument_declaration', [
        ['path:String',
         'string path'],
        ['index:int = -1',
         'int index = -1'],
     ]),
     ('variable_declaration', [
        ['var path:String',
         'string path'],
        ['var index:int',
         'int index'],
     ]),
     ('argument_list', [
        ['path:String',
         'string path'],
        ['path:String, index:int',
         'string path, int index'],
        ['index:int, isEnabled:Boolean, a:Number',
         'int index, bool isEnabled, float a'],
        ['path:String, index:int = -1',
         'string path, int index = -1'],
     ]),
     ('function_declaration', [
        [' function f(path:String, index:int):void',
         ' void function f(string path, int index)'],
        [' private function isF(index:int, isEnabled:Boolean, a:Number):Boolean',
         ' private bool function isF(int index, bool isEnabled, float a)'],
     ]),
     ('variable_assignment', [
        ['path = "as.g"',
         'path = "as.g"'],
        ['index = 16',
         'index = 16'],
        ['a = index',
         'a = index'],
        ['this.a = index',
         'this.a = index'],
        ['a += 2',
         'a += 2'],
        ['a -= 2',
         'a -= 2'],
        ['a /= 2',
         'a /= 2'],
        ['a *= 2',
         'a *= 2'],
        ['a %= 2',
         'a %= 2'],
        ['a ^= 2',
         'a ^= 2'],
        ['a &= 2',
         'a &= 2'],
        ['a |= 2',
         'a |= 2'],
        ['a <<= 2',
         'a <<= 2'],
        ['a >>= 2',
         'a >>= 2'],
     ]),
     ('variable_declaration', [
        ['var path:String = "as.g"',
         'string path = "as.g"'],
        ['var index:int = 16',
         'int index = 16'],
     ]),
     ('function_declaration', [
        [' function f(path:String, index:int = -1):void',
         ' void function f(string path, int index = -1)'],
        [' private function isF(index:int, isEnabled:Boolean, a:Number=NaN):Boolean',
         ' private bool function isF(int index, bool isEnabled, float a=NaN)'],
     ]),
     ('number_format', [
        ['125', 
         '125'],
        ['-125', 
         '-125'],
        ['0xFF', 
         '0xFF'],
        ['0.125', 
         '0.125f'],
     ]),
     ('expression', [
        ['"as.g"', 
         '"as.g"'],
        ['Math.floor(index)', 
         'Math.floor(index)'],
        ['0.125', 
         '0.125f'],
        ['a % b', 
         'a % b'],
        ['((a + 2) % b)', 
         '((a + 2) % b)'],
        ['a ~ b', 
         'a ~ b'],
        ['a && b', 
         'a && b'],
        ['a || b', 
         'a || b'],
     ]),
     ('function_definition', [
        ['  function f():void{var i:int = index;}', 
         '  void function f(){int i = index;}'],
        ['  function f():void{i = index;}', 
         '  void function f(){i = index;}'],
        ['  function f():void{var i:int = Math.floor(index);}', 
         '  void function f(){int i = Math.floor(index);}'],
     ]),
     ('member_declaration', [
        ['  var path:String = "as.g";',
         '  string path = "as.g";'],
        ['  var path:String = "as.g";',
         '  string path = "as.g";'],
        [' private static var index:int = 16;',
         ' private static int index = 16;'],
        [' static var path:String = "as.g";',
         ' static string path = "as.g";'],
        ['    private var index:int = 16;',
         '    private int index = 16;'],
     ]),
     ('class_definition', [
        ['class C{  var path:String = "as.g";}', 
         'class C{  string path = "as.g";}'],
        ['public class PC{    private static var index:int = 16;}', 
         'public class PC{    private static int index = 16;}'],
        ['internal class PC{    private static var index:int = 16;\nprivate var a:String;}', 
         'internal class PC{    private static int index = 16;\nprivate string a;}'],
        ['internal final class PC{    private static var index:int = 16;\nprivate var a:String;}', 
         'internal sealed class PC{    private static int index = 16;\nprivate string a;}'],
     ]),
     ('class_base_clause', [
        [' extends B',
         ' : B'],
        [' extends B implements IA', 
         ' : B, IA'],
        [' extends B implements IA, II', 
         ' : B, IA, II'],
        [' extends B implements IA, II', 
         ' : B, IA, II'],
        [' implements IPc', 
         ' : IPc'],
        [' extends It', 
         ' : It'],
     ]),
     ('unary_expression', [
        ['a', 'a'],
        ['a++', 'a++'],
        ['b--', 'b--'],
        ['""', '""'],
        ['!a', '!a'],
        ['.0', '.0f'],
     ]),
     ('relational_expression', [
        ['a == b',
         'a == b'],
        ['.0 == ""',
         '.0f == ""'],
        ['a != b',
         'a != b'],
        ['a < b',
         'a < b'],
        ['a >= b',
         'a >= b'],
     ]),
     ('conditional_expression', [
        ['.0 === null',
         'object.ReferenceEquals(.0f, null)'],
        ['.0 === ""',
         'object.ReferenceEquals(.0f, "")'],
        ['a !== b',
         '!object.ReferenceEquals(a, b)'],
     ]),
     ('contains_expression', [
        ['oil in italian.salad',
         'italian.salad.Contains(oil)'],
        ['Content in Container.Container',
         'Container.Container.Contains(Content)'],
     ]),
     ('conditional_function', [
        ['oil in salad',
         'salad.Contains(oil)'],
        ['!(apple in basket)',
         '!basket.Contains(apple)'],
     ]),
     ('relational_expression', [
        ['a.b.c >= x.y',
         'a.b.c >= x.y'],
        ['a.b + 1.0 >= x.y',
         'a.b + 1.0f >= x.y'],
        ['a.b + 1.0 >= y - 1',
         'a.b + 1.0f >= y - 1'],
        ['(a + 1.0) >= y',
         '(a + 1.0f) >= y'],
        ['!(a.b + 1.0 == y - 1) && c',
         '!(a.b + 1.0f == y - 1) && c'],
     ]),
     ('conditional_expression', [
        ['a >= y',
         'a >= y'],
     ]),
     ('if_statement', [
        ['if (a >= x) a = x;',
         'if (a >= x) a = x;'],
        ['if (a) a = x;',
         'if (a) a = x;'],
        ['if (!a) a = x;',
         'if (!a) a = x;'],
        ['if (a.b.c >= x.y) a.b.c = x.y; else x.y = -1.0;',
         'if (a.b.c >= x.y) a.b.c = x.y; else x.y = -1.0f;'],
     ]),
     ('statement', [
        ['a = 0;', 'a = 0;'],
        ['{}', '{}'],
        ['{a = 0; b = "c";}', '{a = 0; b = "c";}'],
        ['i++;', 'i++;'],
        ['--i;', '--i;'],
     ]),
     ('if_statement', [
        ['if (a) {a = x; c = 1.0;}',
         'if (a) {a = x; c = 1.0f;}'],
        ['if (a.b.c >= x.y) a.b.c = x.y; else {x.y = -1.0;}',
         'if (a.b.c >= x.y) a.b.c = x.y; else {x.y = -1.0f;}'],
        ['if (a.b.c >= x.y) a.b.c = x.y; else {x.y = -1.0; z++;}',
         'if (a.b.c >= x.y) a.b.c = x.y; else {x.y = -1.0f; z++;}'],
     ]),
     ('function_definition', [
        ['  function f():void{if (a){}}', 
         '  void function f(){if (a){}}'],
     ]),
     ('compilation_unit', [
        ['package{public class C{}}', 
         'namespace{\n    public class C{\n    }\n}'],
        ['package{class C{}}',
         'namespace{\n    class C{\n    }\n}'],
        ['package{public class C{\n}}',
         'namespace{\n    public class C{\n    }\n}'],
        ['package{\n    import A;\n\npublic class C{\n}}',
         'using A;\nnamespace{\n    public class C{\n    }\n}'],
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

one_ways = {
    'as': {'cs': [
        ('literal', [
            ['undefined',
             'null'],
         ]),
     ]},
    'cs': {'as': [
        ('number_format', [
            ['3.5',
             '3.5F'],
        ]),
    ]},
}

is_debug_fail = True

debug_definitions = [
    # 'data_type'
    # 'compilation_unit'
    # 'function_definition'
    # 'import_definition'
    # 'ts'
    # 'variable_declaration'
]

debug_source = [
    # 'cs'
]

debug_indexes = [
    # 2
]

original_source = cfg['source']
original_to = cfg['to']


def print_expected(expected, got, input, definition, index, err):
    difference = format_difference(expected, got)
    if got is None:
        got = err.message
    print
    print 'Converting from %s to %s' % (cfg['source'], cfg['to'])
    print definition, index
    print 'Input:'
    print input
    print 'Difference (expected to got):'
    print difference
    print 'Tag parts (first 500 characters):'
    print format_taglist(input, definition)[:500]


class TestDefinitions(TestCase):

    def assertExample(self, definition, expected, input, index):
        got = None
        try:
            expected = may_format(definition, expected)
            if definition in debug_definitions:
                if not debug_indexes or index in debug_indexes:
                    if not debug_source or cfg['source'] in debug_source:
                        import pdb
                        pdb.set_trace()
            got = convert(input, definition)
            self.assertEqual(expected, got)
        except Exception as err:
            print_expected(expected, got, input, definition, index, err)
            if is_debug_fail:
                import pdb
                pdb.set_trace()
                got = convert(input, definition)
                self.assertEqual(expected, got)
            raise err

    def test_definitions(self):
        for source, to, s, t in directions:
            cfg['source'] = source
            cfg['to'] = to
            for definition, rows in definitions + one_ways[source][to]:
                for r, row in enumerate(rows):
                    expected = row[t]
                    input = row[s]
                    self.assertExample(definition, expected, input, r)
        cfg['source'] = original_source 
        cfg['to'] = original_to 

    def test_files(self):
        for source, to, s, t in directions:
            cfg['source'] = source
            cfg['to'] = to
            pattern = 'test/*.%s' % cfg['source']
            paths = glob(realpath(pattern))
            expected_gots = compare_files(paths)
            definition = 'compilation_unit'
            for index, expected_got in enumerate(expected_gots):
                expected, got = expected_got
                expected = may_format(definition, expected)
                path = paths[index]
                try:
                    self.assertEqual(expected, got)
                except Exception as err:
                    print_expected(expected, got, open(path).read(), definition, index, err)
                    raise err
        cfg['source'] = original_source
        cfg['to'] = original_to


if '__main__' == __name__:
    main()
