# Tests a trivial example.
# Usage: 
#   cd as2cs
#   python as2cs.py

from simpleparse.parser import Parser
from simpleparse.simpleparsegrammar import declaration
from simpleparse.common import strings, comments, numbers, chartypes, SOURCES
from sys import stdin, stdout, stderr
from pprint import pformat

from cs import codes


ebnf_parser = Parser(declaration, 'declarationset')


def merge_declarations(declarations):
    r"""
    B augments A.
    Normalize whitespace before and after assignment.
    Expects definition fits on one line.
    >>> a = "whitespace     := [ \t\r\n]+"
    >>> b = "import := 'import'"
    >>> merge_declarations([a, b])
    "whitespace     := [ \t\r\n]+\nimport := 'import'"

    B overwrites A.
    >>> a = "import  \t := 'import'"
    >>> b = "import := \t 'using'"
    >>> merge_declarations([a, b])
    "import := \t 'using'"
    """
    names = {}
    def new_declarations(parser, input):
        text = ''
        taglist = parser.parse(input)
        for tag, begin, end, parts in taglist[1]:
            if tag == 'declaration':
                name_begin, name_end = parts[0][1:3]
                name = input[name_begin:name_end]
                if not name in names:
                    names[name] = True
                    text += input[begin:end]
        ## text += pformat(taglist)
        return text
    texts = []
    for input in reversed(declarations):
        text = new_declarations(ebnf_parser, input)
        if text:
            texts.insert(0, text)
    return '\n'.join(texts)


def merge_declaration_paths(paths):
    texts = []
    for path in paths:
        texts.append(open(path).read())
    return merge_declarations(texts)


def set_tags(tags, def_text):
    r"""
    >>> def_text = "a := b\nb := '.'"
    >>> tags = {}
    >>> set_tags(tags, def_text)
    >>> print pformat(tags)
    {'a': True, 'b': True}
    >>> set_tags(tags, 'spacechar := " "')
    >>> print pformat(tags)
    {'a': True, 'b': True, 'spacechar': True}
    """
    taglist = ebnf_parser.parse(def_text)
    for tag, begin, end, parts in taglist[1]:
        if tag == 'declaration':
            name_begin, name_end = parts[0][1:3]
            name = def_text[name_begin:name_end]
            tags[name] = True


common_tags = {}
for source in SOURCES:
    for key in source.keys():
        common_tags[key] = True
set_tags(common_tags, open('ecma.def').read())


def find_text(text, name, parts):
    """
    >>> parts = [('name', 0, 6, []), ('seq_group', 9, 18, [('element_token', 10, 18, [('literal', 10, 17, [('CHARNOSNGLQUOTE', 11, 16, None)])])])]
    >>> find_text("import := 'using'", 'digit', parts)
    >>> find_text("import := 'using'", 'literal', parts)
    "'using'"
    >>> find_text('import := "using"', 'CHARNOSNGLQUOTE', parts)
    'using'
    """
    found = None
    if parts:
        for tag, begin, end, part in parts:
            if name == tag:
                found = text[begin:end]
                break
            else:
                found = find_text(text, name, part)
    return found


def find_literal_text(text, parts):
    return find_text(text, 'CHARNOSNGLQUOTE', parts)


def replace_literals(a_def, b_def):
    """
    >>> replaces = replace_literals(as_def, cs_def)
    >>> replaces.get('import')
    'using'
    >>> replaces.get('alphaunder')
    """
    def replace_declaration(replaces, original_strings, def_text):
        taglist = ebnf_parser.parse(def_text)
        for tag, begin, end, parts in taglist[1]:
            if tag == 'declaration':
                name_begin, name_end = parts[0][1:3]
                name = def_text[name_begin:name_end]
                text = def_text[begin:end]
                if name in original_strings and text != original_strings[name]:
                    literal = find_literal_text(def_text, parts)
                    if literal:
                        replaces[name] = literal
                original_strings[name] = text
    replaces = {}
    original_strings = {}
    replace_declaration(replaces, original_strings, a_def)
    replace_declaration(replaces, original_strings, b_def)
    return replaces


as_def = merge_declaration_paths(['ecma.def', 'as/as3.def'])
cs_def = merge_declaration_paths(['ecma.def', 'cs/cs.def'])
replaces = replace_literals(as_def, cs_def)


def taglist(input, definition):
    parser = Parser(as_def, definition)
    taglist = parser.parse(input)
    return pformat(taglist)


def _recurse_tags(taglist, input):
    text = ''
    for tag, begin, end, parts in taglist:
        if tag in replaces:
            text += replaces.get(tag)
        elif tag in common_tags:
            if parts:
                text += recurse_tags(parts, input)
            else:
                text += input[begin:end]
        else:
            pass
    return text

    
def as2cs(input, definition = 'compilationUnit'):
    """
    Example of converting syntax from ActionScript to C#.

    >>> print as2cs('import com.finegamedesign.anagram.Model;', 'importDefinition')
    using com.finegamedesign.anagram.Model;

    Related to grammar unit testing specification (gUnit)
    https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
    """
    parser = Parser(as_def, definition)
    taglist = parser.parse(input)
    text = _recurse_tags(taglist[1], input)
    return text


if '__main__' == __name__:
    input = stdin.read()
    stdout.write(as2cs(input))
    import doctest
    doctest.testmod()
