"""
Concise grammar unit test format in definitions.

definitions[definition]: [[input], [output]]

Related to gUnit:  Grammar unit test for ANTLR
https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
"""


from glob import glob
from unittest import main, TestCase

from as2cs import cfg, convert, compare_files, \
    format_taglist, literals, may_format, realpath, reset
from pretty_print_code.pretty_print_code import format_difference

is_debug_fail = False
taglist_head = 4000 # 500

debug_definitions = [
    # 'data_type'
    # 'compilation_unit'
    # 'function_definition'
    # 'import_definition'
    # 'ts'
    # 'variable_declaration'
]

debug_source = [
    # 'as'
]

debug_indexes = [
    # 2
]

directions = [
    # source, to, source_index, to_index
    ['as', 'cs', 0, 1],
    ['cs', 'as', 1, 0],
    ['as', 'js', 0, 2],
    ['js', 'as', 2, 0],
]

definitions = [
     ('new_expression', [
        ['new C(a, b)',
         'new C(a, b)',
         'new C(a, b)'],
        ['new Vector.<Number>()',
         'new List<float>()',
         'new Array/*<Vector.<Number>>*/()'],
     ]),
     ('expression', [
        ['"as.g"',
         '"as.g"',
         '"as.g"'],
        ['0.125',
         '0.125f',
         '0.125'],
        ['a % b',
         'a % b',
         'a % b'],
        ['((a + 2) % b)',
         '((a + 2) % b)',
         '((a + 2) % b)'],
        ['a ~ b',
         'a ~ b',
         'a ~ b'],
        ['a && b',
         'a && b',
         'a && b'],
        ['a || b',
         'a || b',
         'a || b'],
        ['typeof(index)',
         'typeof(index)',
         'typeof(index)'],
        ['parseInt(s)',
         'int.Parse(s)',
         'parseInt(s)'],
        ['parseFloat(s)',
         'float.Parse(s)',
        'parseFloat(s)'],
        ['path as a.b.string',
         'path as a.b.string',
         'path /*<as a.b.string>*/'
         ],
        ['aString as String',
         'aString as string',
         'aString /*<as String>*/'
         ],
        ['int(path)',
         '(int)(path)',
         'int(path)'],
        ['Number(path)',
         '(float)(path)',
         'Number(path)'],
        ['paths.length',
         'paths.Count',
         'paths.length'],
        ['paths.push(p)',
         'paths.Add(p)',
         'paths.push(p)'],
        ['paths.indexOf(p)',
         'paths.IndexOf(p)',
         'paths.indexOf(p)'],
        ['paths.splice(p, 1)',
         'paths.RemoveRange(p, 1)',
         'paths.splice(p, 1)'],
        ['paths.lengths',
         'paths.lengths',
         'paths.lengths'],
        ['paths.length.i',
         'paths.length.i',
         'paths.length.i'],
        ['paths.push.i',
         'paths.push.i',
         'paths.push.i'],
        ['name.toLowerCase',
         'name.ToLower',
         'name.toLowerCase'],
        ['name.lastIndexOf',
         'name.LastIndexOf',
         'name.lastIndexOf'],
        ['trace(s)',
         'Debug.Log(s)',
         'console.log(s)'],
        ['a.trace(s)',
         'a.trace(s)',
         'a.trace(s)'],
        ['Math.floor(a)',
         'Mathf.Floor(a)',
         'Math.floor(a)'],
        ['a.Math.floor(index)',
         'a.Math.floor(index)',
         'a.Math.floor(index)'],
        ['Math.PI',
         'Mathf.PI',
         'Math.PI'],
        ['Math.random()',
         '(Random.value % 1.0f)',
         'Math.random()'],
        ['my.Math.random()',
         'my.Math.random()',
         'my.Math.random()'],
        ['Math',
         'Math',
         'Math'],
        ['-a',
         '-a',
         '-a'],
        [' ++i',
         ' ++i',
         ' ++i'],
        ['-- j',
         '-- j',
         '-- j'],
        # ['thesePaths.concat()',
        #  'new ArrayList(thesePaths)'],
        # Not supported:
        # ['pools["Explosion"].next()',
        #  'pools["Explosion"].next()'],
     ]),
     ('argument_declaration', [
        ['path:String',
         'string path',
         'path:String'],
        ['index:int = -1',
         'int index = -1',
         'index:int = -1'],
     ]),
     ('variable_declaration', [
        ['var path:String',
         'string path',
         'var path:String'],
        ['var index:int',
         'int index',
         'var index:int'],
        ['var a:C = new C()',
         'C a = new C()',
         'var a:C = new C()'],
        ['var v:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>()',
         'List<List<bool>> v = new List<List<bool>>()',
         'var v:Array/*<Vector.<Vector.<Boolean>>>*/ = new Array/*<Vector.<Vector.<Boolean>>>*/()'],
        ['var v:Vector.<Vector.<CustomType>> = new Vector.<Vector.<CustomType>>()',
         'List<List<CustomType>> v = new List<List<CustomType>>()',
         'var v:Array/*<Vector.<Vector.<CustomType>>>*/ = new Array/*<Vector.<Vector.<CustomType>>>*/()'],
        ['var a:*',
         'var a',
         'var a:any'],
     ]),
     ('argument_list', [
        ['path:String',
         'string path',
         'path:String'],
        ['path:String, index:int',
         'string path, int index',
         'path:String, index:int'],
        ['index:int, isEnabled:Boolean, a:Number',
         'int index, bool isEnabled, float a',
         'index:int, isEnabled:Boolean, a:Number'],
        ['path:String, index:int = -1',
         'string path, int index = -1',
         'path:String, index:int = -1'],
     ]),
     ('member_declaration', [
        ['var path:String="as.g";',
         'string path="as.g";',
         'path:String="as.g";'],
        ['var a:int;',
         'int a;',
         'a:int;'],
        ['private var index:int=16;',
         'private int index=16;',
         '/*<private >*/ index:int=16;'],
        ['private static var index:int = 16;',
         'private static int index = 16;',
         '/*<private >*/ static index:int = 16;'],
        ['static var path:String = "as.g";',
         'static string path = "as.g";',
         'static path:String = "as.g";'],
     ]),
     ('conditional_expression', [
        ['path is Boolean',
         'path is bool',
         'path instanceof Boolean'],
        ['path is a.b.Boolean',
         'path is a.b.Boolean',
         'path instanceof a.b.Boolean'],
        ['.0 === null',
         'object.ReferenceEquals(.0f, null)'],
        ['.0 === ""',
         'object.ReferenceEquals(.0f, "")'],
        ['a !== b',
         '!object.ReferenceEquals(a, b)'],
        ['i ? 1 : 2',
         'i ? 1 : 2'],
        ['i == 0 ? 1 : 2',
         'i == 0 ? 1 : 2'],
        ['i ? 1 : (b ? c : 4)',
         'i ? 1 : (b ? c : 4)'],
     ]),
     ('reordered_call', [
        ['abc.concat()',
         'new ArrayList(abc)'],
        ['a.b.c.concat()',
         'new ArrayList(a.b.c)'],
     ]),
     ('data_declaration', [
        ['const path:String',
         'const string path'],
     ]),
     ('data_type', [
        ['int', 'int'],
        ['String', 'string'],
        ['Boolean', 'bool'],
        ['Number', 'float'],
        ['Custom', 'Custom'],
        ['Array', 'ArrayList'],
        ['Object', 'Dictionary<string, object>'],
        ['*', 'var'],
        ['A.B.C', 'A.B.C'],
        ['Vector.<String>', 'List<string>'],
        ['Vector.<Point>', 'List<Vector2>'],
        ['Vector.<DisplayObject>', 'List<Collider2D>'],
        ['Vector.<DisplayObjectContainer>', 'List<GameObject>'],
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
        ['a[i]', 'a[i]'],
        ['_0._1[a.b]._2', '_0._1[a.b]._2'],
        ['_0._1[a % b]._2', '_0._1[a % b]._2'],
     ]),
     ('import_definition', [
        ['import com.finegamedesign.anagram.Model;',
         'using /*<com>*/finegamedesign.anagram/*<Model>*/;'],
        ['import _._2;',
         'using _/*<_2>*/;'],
        ['import _.*;',
         'using _/*<*>*/;'],
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
     ('namespace_modifiers_place', [
        ['public ',
         'public '],
        ['private static ',
         'private static '],
        ['static private ',
         'static private '],
     ]),
     ('function_declaration', [
        ['  function f():void',
         '  void f()'],
        ['    function g( ):void',
         '    void g( )'],
     ]),
     ('function_definition', [
        ['  function f():void{}',
         '  void f(){}'],
        [' function f():void{}',
         ' void f(){}'],
        [' public function f():void{}',
         ' public void f(){}'],
        [' internal function isF():Boolean{}',
         ' internal bool isF(){}'],
        [' protected function getF():Number{}',
         ' protected float getF(){}'],
        ['    function ClassConstructor(){i = index;}',
         '    ClassConstructor(){i = index;}'],
        # Not supported:
        # ['    function f():*{}',
        #  '    var f(){}'],
     ]),
     ('function_declaration', [
        ['  function f(path:String, index:int):void',
         '  void f(string path, int index)'],
        ['  private function isF(index:int, isEnabled:Boolean, a:Number):Boolean',
         '  private bool isF(int index, bool isEnabled, float a)'],
        ['\n\n  private static function shuffle(cards:Array):void',
         '\n\n  private static void shuffle(ArrayList cards)'],
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
        ['a[1 + i] = 2',
         'a[1 + i] = 2'],
     ]),
     ('variable_declaration', [
        ['var path:String = "as.g"',
         'string path = "as.g"'],
        ['var index:int = 16',
         'int index = 16'],
        ['var swap:* = cards[r]',
         'var swap = cards[r]'],
        ['var r:int = Math.random() * (i + 1)',
         'int r = (Random.value % 1.0f) * (i + 1)'],
     ]),
     ('function_declaration', [
        [' function f(path:String, index:int = -1):void',
         ' void f(string path, int index = -1)'],
        [' private function isF(index:int, isEnabled:Boolean, a:Number=NaN):Boolean',
         ' private bool isF(int index, bool isEnabled, float a=NaN)'],
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
     ('function_definition', [
        ['  function f():void{var i:int = index;}',
         '  void f(){int i = index;}'],
        ['  function f():void{i = index;}',
         '  void f(){i = index;}'],
        ['  function f():void{var i:int = Math.floor(index);}',
         '  void f(){int i = Mathf.Floor(index);}'],
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
     ('contains_expression', [
        ['oil in italian.salad',
         'italian.salad.ContainsKey(oil)'],
        ['Content in Container.Container',
         'Container.Container.ContainsKey(Content)'],
     ]),
     ('conditional_function', [
        ['oil in salad',
         'salad.ContainsKey(oil)'],
        ['!(apple in basket)',
         '!basket.ContainsKey(apple)'],
     ]),
     ('logical_expression', [
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
        ['for (i=0; i<L;i++){}',
         'for (i=0; i<L;i++){}'],
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
         '  void f(){if (a){}}'],
     ]),
     ('expression_list', [
         ['i-=s', 'i-=s']
     ]),
     ('iteration_statement', [
        ['for (i=0; i<L;i++){}',
         'for (i=0; i<L;i++){}'],
        ['for (var i:int=0; i<L;i++){}',
         'for (int i=0; i<L;i++){}'],
        ['for(;;);',
         'for(;;);'],
        ['for(;; i++, j--);',
         'for(;; i++, j--);'],
        ['for(;; i++, j--){break; continue;}',
         'for(;; i++, j--){break; continue;}'],
        ['while(a == b){i++;  j--;}',
         'while(a == b){i++;  j--;}'],
        ['while(true){i++;  j--;}',
         'while(true){i++;  j--;}'],
        ['while( true ){i++;  j--;}',
         'while( true ){i++;  j--;}'],
        ['do {i++; j--;}while(false)',
         'do {i++; j--;}while(false)'],
        ['for(var key:String in items){text += key; a = key;}',
         'foreach(KeyValuePair<string, object> _entry in items){string key = _entry.Key; text += key; a = key;}'],
        ['for(key in items){text += key;}',
         'foreach(KeyValuePair<string, object> _entry in items){key = _entry.Key; text += key;}'],
        ['for (var i:int = cards.length - 1; 1 <= i; i--){}',
         'for (int i = cards.Count - 1; 1 <= i; i--){}'],
        ['for (var i:int=0; i <= L; i -= s){}',
         'for (int i=0; i <= L; i -= s){}'],
     ]),
     ('member_expression', [
        ['  internal var /*<delegate>*/ ActionDelegate:/*<void>*/*;',
         '  internal delegate /*<var>*/void ActionDelegate();'],
        ['  internal var onComplete:/*<ActionDelegate>*/Function;',
         '  internal /*<Function>*/ActionDelegate onComplete;'],
        ['  public var /*<delegate>*/ IsJustPressed:Boolean, letter:String;',
         '  public delegate bool IsJustPressed(string letter);'],
        ['  public function getPresses(justPressed:/*<IsJustPressed>*/Function):Array{}',
         '  public ArrayList getPresses(/*<Function>*/IsJustPressed justPressed){}'],
     ]),
     ('block', [
        ['{var word:Vector.<String>;    available = word.concat();}',
         '{List<string> word;    available = new List<string>(word);}'],
     ]),
     ('compilation_unit', [
        ['package{public class C{}}',
         'public class C{}'],
        ['package{class C{}}',
         'class C{}'],
        ['package{public class C{}}',
         'public class C{}'],
     ]),
     ('statement', [
        ['return;',
         'return;'],
        ['return a ? b : c;',
         'return a ? b : c;'],
        ['return "object" === typeof(value);',
         'return object.ReferenceEquals("object", typeof(value));'],
        ['f(a ? b : c);',
         'f(a ? b : c);'],
        ['delete container[key];',
         'container.Remove(key);'],
        ['throw new Error("message");',
         'throw new System.InvalidOperationException("message");'],
        ['a.sort();',
         'a.Sort();'],
        # Not supported:
        # ['return f()[i];',
        #  'return f()[i];'],
        # ['f(a.split(",")[0])',
        # 'f(a.split(",")[0])'],
        ['break;',
         'break;'],
        ['continue;',
         'continue;'],
     ]),

     # ASUnit to NUnit:

     ('call_expression', [
        ['assertEquals(expected, got)',
         'Assert.AreEqual(expected, got)'],
        ['assertEquals(message, expected, got)',
         'Assert.AreEqual(expected, got, message)'],
     ]),
     ('function_declaration', [
        ['  public function testThis():void',
         '  [Test] public void This()'],
        ['  /*comment*/public function testThis():void',
         '  /*comment*/[Test] public void This()'],
     ]),
     ('class_definition', [
        ['internal class TestThis extends TestCase{}',
         '[TestFixture] internal class TestThis{}'],
     ]),
     ('import_definition', [
        ['import asunit.framework.TestCase;',
         'using NUnit.Framework;'],
     ]),

     # Complex cases:

     ('variable_declaration', [
        ['var columnOffset:int = offset == 0 ? -1 : 1',
         'int columnOffset = offset == 0 ? -1 : 1'],
        ['var isChanged:Boolean = g == grid[index] || g == gridPreviously[index]',
         'bool isChanged = g == grid[index] || g == gridPreviously[index]'],
     ]),
     ('expression', [
        ['power(trimmed).toString()',
         'power(trimmed).ToString()'],
        ['new <int>[1, 0]',
         'new List<int>(){1, 0}'],
        ['new <int>[]',
         'new List<int>(){}'],
        ['int(Math.random() * (i + 1))',
         '(int)((Random.value % 1.0f) * (i + 1))'],
        ['null == a && a is Array',
         'null == a && a is ArrayList'],
        ['null == a || a is Array',
         'null == a || a is ArrayList'],
        ['(null == hash) || (key in hash)',
         '(null == hash) || (hash.ContainsKey(key))'],
        # Not supported:
        # ['null == hash || key in hash',
        #  'null == hash || hash.ContainsKey(key)'],

        # Collection literals:

        ['[]', 'new ArrayList(){}'],
        ['[a, 1.0, ""]', 'new ArrayList(){a, 1.0f, ""}'],
        ['{}', 'new Dictionary<string, object>(){}'],
        ['{a: b, "1.0": 2.0}', 'new Dictionary<string, object>(){{"a", b}, {"1.0", 2.0f}}'],
        ['{a: {b: "1.0"}}', 'new Dictionary<string, object>(){{"a", new Dictionary<string, object>(){{"b", "1.0"}}}}'],
     ]),
     ('class_definition', [
        ['class C{\n    var a:int;\n    var b:int;\n}',
         'class C{\n    int a;\n    int b;\n}'],
     ]),
     ('compilation_unit', [
        ['package P{import A.B;\n\npublic class C{}}',
         'using A/*<B>*/;\nnamespace P{\n    public class C{}}'],
        ['package P{\npublic class C1{}}',
         'namespace P{\n    public class C1{}}'],
        ['package P{public class C2{}}',
         'namespace P{public class C2{}}'],
        ['package N{\npublic class C3{}}',
         'namespace N{\n    public class C3{}}'],
        ['package N\n{\npublic class C4{}}',
         'namespace N\n{\n    public class C4{}}'],
        ['//c\npackage N\n{\npublic class C5{}}',
         '//c\nnamespace N\n{\n    public class C5{}}'],
        ['package N\n{\n//c\npublic class C7{}}',
         'namespace N\n{\n    //c\n    public class C7{}}'],
        ['/*c*/\npackage N\n{\npublic class C6{}}',
         '/*c*/\nnamespace N\n{\n    public class C6{}}'],
        ['package N{ class C{ var a:Vector.<String>;}}',
         'using System.Collections.Generic;\nnamespace N{ class C{ List<string> a;}}'],
     ]),
]



one_ways = {
    'as': {
        'js': [
        #('expression', [
        #    ['int(path)',
        #     'Math.floor(path)'],
        # ]),
        ],
        'cs': [
        ('literal', [
            ['undefined',
             'null'],
         ]),
        ('data_type', [
            ['Dictionary',
             'Hashtable'],
            ['Sprite',
             'GameObject'],
            ['MovieClip',
             'GameObject'],
            ['TextField',
             'GameObject'],
         ]),
        ('expression', [
            ['[[a, b]]', 'new ArrayList(){new ArrayList(){a, b}}'],
            ['[{a: b}]', 'new ArrayList(){new Dictionary<string, object>(){{"a", b}}}'],
        ]),
        ('class_definition', [
            ['class C{\n    var a:int;\n    var repeat:Object = {};\n    var b:int;\n}',
             'class C{\n    int a;\n    Dictionary<string, object> repeat = new Dictionary<string, object>(){};\n    int b;\n}'],
        ]),
        ('import_definition', [
            ['import flash.display.Sprite;',
             '// using flash.display.Sprite;'],
        ]),
        ('import_definition_place', [
            ['import flash.display.Sprite;\nimport flash.display.MovieClip;',
             '// using flash.display.Sprite;\n// using flash.display.MovieClip;'],
        ]),
     ]},
    'cs': {'as': [
        ('number_format', [
            ['3.5',
             '3.5F'],
        ]),
    ]},
    'js': {'as':[
        #('expression', [
        #    ['Math.floor(path)',
        #     'Math.floor(path)'],
        # ]),
    ]},
}



case_definitions = [
     ('compilation_unit', [
        ['package org.p{import com.a.b; class C{}}',
         'using /*<com>*/A/*<b>*/;namespace /*<org>*/P{ class C{}}'],
     ]),
     ('import_definition', [
        ['import com.finegamedesign.anagram.Model;',
         'using /*<com>*/Finegamedesign.Anagram/*<Model>*/;'],
     ]),
     ('function_definition', [
        [' function doThis():void{ doThis();}',
         ' void DoThis(){ DoThis();}'],
        [' function doThis():void{ doThis(); b.do(); A.B.c.go();}',
         ' void DoThis(){ DoThis(); b.Do(); A.B.c.Go();}'],
        [' function doThis():void{ doThis(); b.do(); A.B.c.go(); f = int(a);}',
         ' void DoThis(){ DoThis(); b.Do(); A.B.c.Go(); f = (int)(a);}'],
     ]),
     ('expression', [
        ['"as.g"',
         '"as.g"'],
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
        ['new C(a, b)',
         'new C(a, b)'],
        ['typeof(index)',
         'typeof(index)'],
        ['parseInt(s)',
         'int.Parse(s)'],
        ['parseFloat(s)',
         'float.Parse(s)'],
        ['path as a.b.string',
         'path as a.b.string'],
        ['path as String',
         'path as string'],
        ['int(path)',
         '(int)(path)'],
        ['Number(path)',
         '(float)(path)'],
        ['paths.length',
         'paths.Count'],
        ['paths.push(p)',
         'paths.Add(p)'],
        ['paths.indexOf(p)',
         'paths.IndexOf(p)'],
        ['paths.splice(p, 1)',
         'paths.RemoveRange(p, 1)'],
        # ['paths.concat()',
        #  'new ArrayList(paths)'],
        ['paths.lengths',
         'paths.lengths'],
        ['paths.length.i',
         'paths.length.i'],
        ['paths.push.i',
         'paths.push.i'],
        ['name.toLowerCase',
         'name.ToLower'],
        ['name.lastIndexOf',
         'name.LastIndexOf'],
        ['trace(s)',
         'Debug.Log(s)'],
        ['a.trace(s)',
         'a.Trace(s)'],
        ['Math.floor(a)',
         'Mathf.Floor(a)'],
        ['a.Math.floor(index)',
         'a.Math.Floor(index)'],
        ['Math.PI',
         'Mathf.PI'],
        ['Math.random()',
         '(Random.value % 1.0f)'],
        ['my.Math.random()',
         'my.Math.Random()'],
        ['Math',
         'Math'],
        ['-a',
         '-a'],
        [' ++i',
         ' ++i'],
        ['-- j',
         '-- j'],
        # Not supported:
        # ['pools["Explosion"].next()',
        #  'pools["Explosion"].Next()'],
     ]),
     ('data_declaration', [
        ['const path:String',
         'const string path'],
     ]),
     ('data_type', [
        ['int', 'int'],
        ['String', 'string'],
        ['Boolean', 'bool'],
        ['Number', 'float'],
        ['Custom', 'Custom'],
        ['Array', 'ArrayList'],
        ['Object', 'Dictionary<string, object>'],
        ['*', 'var'],
        ['A.B.C', 'A.B.C'],
        ['Vector.<String>', 'List<string>'],
        ['Vector.<Point>', 'List<Vector2>'],
        ['Vector.<DisplayObject>', 'List<Collider2D>'],
        ['Vector.<DisplayObjectContainer>', 'List<GameObject>'],
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
        ['a[i]', 'a[i]'],
        ['_0._1[a.b]._2', '_0._1[a.b]._2'],
        ['_0._1[a % b]._2', '_0._1[a % b]._2'],
     ]),
     ('import_definition', [
        ['import _._2;',
         'using _/*<_2>*/;'],
        ['import _.*;',
         'using _/*<*>*/;'],
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
     ('namespace_modifiers_place', [
        ['public ',
         'public '],
        ['private static ',
         'private static '],
        ['static private ',
         'static private '],
     ]),
     ('function_declaration', [
        ['  function f():void',
         '  void F()'],
        ['    function g( ):void',
         '    void G( )'],
     ]),
     ('function_definition', [
        ['  function f():void{}',
         '  void F(){}'],
        [' function f():void{}',
         ' void F(){}'],
        [' public function f():void{}',
         ' public void F(){}'],
        [' internal function isF():Boolean{}',
         ' internal bool IsF(){}'],
        [' protected function getF():Number{}',
         ' protected float GetF(){}'],
        ['    function f(){i = index;}',
         '    F(){i = index;}'],
        # Not supported:
        # ['    function f():*{}',
        #  '    var f(){}'],
     ]),
     ('function_declaration', [
        ['  function f(path:String, index:int):void',
         '  void F(string path, int index)'],
        ['  private function isF(index:int, isEnabled:Boolean, a:Number):Boolean',
         '  private bool IsF(int index, bool isEnabled, float a)'],
        ['\n\n  private static function shuffle(cards:Array):void',
         '\n\n  private static void Shuffle(ArrayList cards)'],
     ]),
     ('function_declaration', [
        [' function f(path:String, index:int = -1):void',
         ' void F(string path, int index = -1)'],
        [' private function isF(index:int, isEnabled:Boolean, a:Number=NaN):Boolean',
         ' private bool IsF(int index, bool isEnabled, float a=NaN)'],
     ]),
     ('function_definition', [
        ['  function f():void{var i:int = index;}',
         '  void F(){int i = index;}'],
        ['  function f():void{i = index;}',
         '  void F(){i = index;}'],
        ['  function f():void{var i:int = Math.floor(index);}',
         '  void F(){int i = Mathf.Floor(index);}'],
     ]),
     ('contains_expression', [
        ['oil in italian.salad',
         'italian.salad.ContainsKey(oil)'],
        ['Content in Container.Container',
         'Container.Container.ContainsKey(Content)'],
     ]),
     ('conditional_function', [
        ['oil in salad',
         'salad.ContainsKey(oil)'],
        ['!(apple in basket)',
         '!basket.ContainsKey(apple)'],
     ]),

     # ASUnit to NUnit:

     ('call_expression', [
        ['assertEquals(expected, got)',
         'Assert.AreEqual(expected, got)'],
        ['assertEquals(message, expected, got)',
         'Assert.AreEqual(expected, got, message)'],
     ]),
     ('function_declaration', [
        ['  public function testThis():void',
         '  [Test] public void This()'],
        ['  /*comment*/public function testThis():void',
         '  /*comment*/[Test] public void This()'],
     ]),
     ('class_definition', [
        ['internal class TestThis extends TestCase{}',
         '[TestFixture] internal class TestThis{}'],
     ]),
     ('import_definition', [
        ['import asunit.framework.TestCase;',
         'using NUnit.Framework;'],
     ]),

     # Complex cases:

     ('expression', [
        ['power(trimmed).toString()',
         'Power(trimmed).ToString()'],
     ]),
]


original_source = cfg['source']
original_to = cfg['to']


def print_expected(expected, got, input, definition, index, err):
    difference = format_difference(expected, got)
    if got is None:
        got = err.message
    tag_text = ''
    try:
        tag_text = format_taglist(input, definition)[:taglist_head]
    except:
        tag_text = 'Failed formatting.'
    message = (''
        + '\nConverting from %s to %s' % (cfg['source'], cfg['to'])
        + '\n' + definition + ' ' + str(index)
        + '\n' + 'Input (first 200 characters):'
        + '\n' + input[:200]
        + '\n' + 'Difference (expected to got, first 500 characters):'
        + '\n' + difference[:500]
        + '\n' + 'Tag parts (first 500 characters):'
        + '\n' + tag_text)
    message = message.encode('ascii', 'replace')
    print(message)


class TestDefinitions(TestCase):

    def assertExample(self, definition, expected, input, index):
        got = None
        try:
            expected = may_format(definition, expected)
            if definition in debug_definitions:
                if not debug_indexes or index in debug_indexes:
                    if cfg['source'] in debug_source:
                        import pdb
                        pdb.set_trace()
            got = convert(input, definition)
            self.assertEqual(expected, got)
        except Exception as err:
            print 'is_conform_case: %r' % cfg['is_conform_case']
            print_expected(expected, got, input, definition, index, err)
            if is_debug_fail:
                import pdb
                pdb.set_trace()
                got = convert(input, definition)
                self.assertEqual(expected, got)
            raise err

    def test_definitions(self):
        self.assert_definitions_case(False, definitions)
        self.assert_definitions_case(True, case_definitions)

    def assert_definitions_case(self, is_conform_case, definitions):
        cfg['is_conform_case'] = is_conform_case
        for source, to, source_index, to_index in directions:
            cfg['source'] = source
            cfg['to'] = to
            if is_conform_case:
                these_definitions = definitions
            else:
                these_definitions = definitions + one_ways[source][to]
            for definition, examples in these_definitions:
                reset()
                for example_index, example in enumerate(examples):
                    if to_index < len(example) and source_index < len(example):
                        expected = example[to_index]
                        input = example[source_index]
                        self.assertExample(definition, expected, input, example_index)
        cfg['source'] = original_source
        cfg['to'] = original_to

    def DISABLED_test_files(self):
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

    def test_quote(self):
        self.assertEqual('"', literals['cs']['QUOTE'])
        self.assertEqual('"', literals['as']['QUOTE'])


if '__main__' == __name__:
    main()
