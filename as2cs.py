"""
Tests a trivial example.
Usage: 
    cd as2cs
    python as2cs.py [file.as ...]
"""


import codecs
from os import path
from sys import stdin, stdout
from pprint import pformat
from pretty_print_code.pretty_print_code import format_text
from simpleparse.parser import Parser
from simpleparse.simpleparsegrammar import declaration
from simpleparse.common import strings, comments, numbers, chartypes, SOURCES


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
set_tags(common_tags, open('as_and_cs.def').read())


def find_text(text, name, parts):
    """
    >>> parts = [('name', 0, 6, []), ('seq_group', 9, 18, [('element_token', 10, 18, [('literal', 10, 17, [('CHARNOSNGLQUOTE', 11, 16, None)])])])]
    >>> find_text("import := 'using'", 'digit', parts)
    >>> find_text("import := 'using'", 'literal', parts)
    "'using'"
    >>> find_text('import := "using"', 'CHARNOSNGLQUOTE', parts)
    'using'
    """
    found = ''
    if parts:
        for tag, begin, end, part in parts:
            if name == tag:
                found += text[begin:end]
                break
            else:
                found_part = find_text(text, name, part)
                if found_part:
                    found += found_part
    if found:
        return found


def find_texts(text, name, parts):
    """
    >>> parts = [('variableDeclarationKeyword', 0, 3, None),
    ...  ('whitespacechar', 3, 4, None),
    ...  ('identifier',
    ...   4,
    ...   8,
    ...   [('alphaunder', 4, 5, [('letter', 4, 5, None)]),
    ...    ('alphanums',
    ...     5,
    ...     8,
    ...     [('letter', 5, 6, None),
    ...      ('letter', 6, 7, None),
    ...      ('letter', 7, 8, None)])]),
    ...  ('COLON', 8, 9, None),
    ...  ('dataType', 9, 15, [('string', 9, 15, None)]),
    ...  ('SEMI', 15, 16, None)]
    >>> as_code = 'var path:String;';
    >>> find_texts(as_code, 'digit', parts)
    []
    >>> find_texts(as_code, 'letter', parts)
    ['p', 'a', 't', 'h']
    """
    found = []
    if parts:
        for tag, begin, end, part in parts:
            if name == tag:
                found.append(text[begin:end])
            else:
                found_part = find_texts(text, name, part)
                if found_part:
                    found.extend(found_part)
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
        taglist = ebnf_parser.parse(def_text)[1]
        for tag, begin, end, parts in taglist:
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


as_def = merge_declaration_paths(['as_and_cs.def', 'as/as3.def'])
cs_def = merge_declaration_paths(['as_and_cs.def', 'cs/cs.def'])
replaces = replace_literals(as_def, cs_def)


def tag_order(def_text):
    """
    >>> cs_var = 'variableDeclaration := dataType, whitespacechar+, identifier, whitespace*, SEMI'
    >>> tag_order(cs_var)
    ['dataType', 'whitespacechar', 'identifier', 'whitespace', 'SEMI']
    >>> as_var = 'variableDeclaration := variableDeclarationKeyword, whitespacechar+, identifier, (COLON, dataType)?, whitespace*, SEMI'
    >>> tag_order(as_var)
    ['variableDeclarationKeyword', 'whitespacechar', 'identifier', 'COLON', 'dataType', 'whitespace', 'SEMI']
    """
    taglist = ebnf_parser.parse(def_text)[1]
    order = find_texts(def_text, 'name', taglist)[1:]
    return order


def tags_to_reorder(a_def, b_def):
    """
    For grammar tags of the same name.
    Order of tags in definition B where they differ from order in A
    >>> cs_var = 'variableDeclaration := dataType, whitespacechar+, identifier, whitespace*, SEMI'
    >>> as_var = 'variableDeclaration := variableDeclarationKeyword, whitespacechar+, identifier, (COLON, dataType)?, whitespace*, SEMI'
    >>> reorder_tags = tags_to_reorder(as_var, cs_var)
    >>> reorder_tags.get('variableDeclaration')
    ['dataType', 'whitespacechar', 'identifier', 'whitespace', 'SEMI']
    """
    def reorder_declaration(reorders, original_strings, def_text):
        taglist = ebnf_parser.parse(def_text)
        ## print pformat(taglist)
        for tag, begin, end, parts in taglist[1]:
            if tag == 'declaration':
                name_begin, name_end = parts[0][1:3]
                name = def_text[name_begin:name_end]
                text = def_text[begin:end]
                if name in original_strings and text != original_strings[name]:
                    order_tags = tag_order(text)
                    reorders[name] = order_tags
                original_strings[name] = text
    reorders = {}
    original_strings = {}
    reorder_declaration(reorders, original_strings, a_def)
    reorder_declaration(reorders, original_strings, b_def)
    return reorders


reorder_tags = tags_to_reorder(as_def, cs_def)


def reorder_taglist(taglist, order_tags, input):
    """
    >>> input = 'var path:String;'
    >>> variableDeclaration = ['dataType', 'whitespacechar', 'identifier', 
    ...     'whitespace', 'SEMI']
    >>> taglist = [('variableDeclarationKeyword', 0, 3, None),
    ...  ('whitespacechar', 3, 4, None),
    ...  ('identifier',
    ...   4,
    ...   8,
    ...   [('alphaunder', 4, 5, [('letter', 4, 5, None)]),
    ...    ('alphanums',
    ...     5,
    ...     8,
    ...     [('letter', 5, 6, None),
    ...      ('letter', 6, 7, None),
    ...      ('letter', 7, 8, None)])]),
    ...  ('COLON', 8, 9, None),
    ...  ('dataType', 9, 15, [('string', 9, 15, None)]),
    ...  ('SEMI', 15, 16, None)]
    >>> reorder_taglist(taglist, variableDeclaration, input)
    'string path;'

    Does not handle multiple occurences.
    Instead group those together in the grammar, such as 'digits' instead of ('digit', 'digit')
    >>> input = 'b22'
    >>> order = ['digits', 'letter']
    >>> taglist = [('letter', 0, 1, None), ('digits', 1, 3, None)]
    >>> reorder_taglist(taglist, order, input)
    '22b'
    >>> order = ['digit', 'letter']
    >>> taglist = [('letter', 0, 1, None), ('digit', 1, 2, None), ('digit', 2, 3, None)]
    >>> reorder_taglist(taglist, order, input)
    '2b'
    """
    ordered = []
    unordered = taglist[:]
    used_indexes = {}
    for order_tag in order_tags:
        for r, row in enumerate(unordered):
            tag = row[0]
            if order_tag == tag and not r in used_indexes:
                ordered.append(unordered[r])
                used_indexes[r] = True
                break
    text = _recurse_tags(ordered, input)
    return text


def _recurse_tags(taglist, input):
    text = ''
    for tag, begin, end, parts in taglist:
        if tag in replaces:
            text += replaces.get(tag)
        elif tag in reorder_tags:
            text += reorder_taglist(parts, reorder_tags[tag], input)
        elif tag in common_tags:
            if parts:
                text += _recurse_tags(parts, input)
            else:
                text += input[begin:end]
        elif parts:
            text += _recurse_tags(parts, input)
    return text


def newline_after_braces(text):
    return text.replace('{', '{\n').replace('}', '}\n').replace('\n\n', '\n')

    
def convert(input, definition = 'compilationUnit'):
    """
    Example of converting syntax from ActionScript to C#.

    >>> print convert('import com.finegamedesign.anagram.Model;', 'importDefinition')
    using com.finegamedesign.anagram.Model;

    Related to grammar unit testing specification (gUnit)
    https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
    """
    parser = Parser(as_def, definition)
    taglist = parser.parse(input)
    taglist = [(definition, 0, taglist[-1], taglist[1])]
    text = _recurse_tags(taglist, input)
    if 'compilationUnit' == definition:
        text = newline_after_braces(text)
        text = format_text(text)
    return text


def format_taglist(input, definition):
    parser = Parser(as_def, definition)
    taglist = parser.parse(input)
    return pformat(taglist)


def convert_file(as_path, cs_path):
    text = codecs.open(as_path, 'r', 'utf-8').read()
    str = convert(text)
    f = codecs.open(cs_path, 'w', 'utf-8')
    ## print(str)
    f.write(str)
    f.close()


def convert_files(as_paths):
    for as_path in as_paths:
        root, ext = path.splitext(as_path)
        cs_path = root + '.cs'
        convert_file(as_path, cs_path)


def compare_file(as_path, cs_path):
    text = codecs.open(as_path, 'r', 'utf-8').read()
    got = convert(text)
    expected = codecs.open(cs_path, 'r', 'utf-8').read()
    return [expected, got]


def compare_files(as_paths):
    expected_gots = []
    for as_path in as_paths:
        root, ext = path.splitext(as_path)
        cs_path = root + '.cs'
        expected_gots.append(compare_file(as_path, cs_path))
    return expected_gots


def realpath(a_path):
    """
    http://stackoverflow.com/questions/4934806/python-how-to-find-scripts-directory
    """
    return path.join(path.dirname(path.realpath(__file__)), a_path)


if '__main__' == __name__:
    import sys
    if len(sys.argv) <= 1:
        print __doc__
    if 2 <= len(sys.argv) and '--test' != sys.argv[1]:
        convert_files(sys.argv[1:])
