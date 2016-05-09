"""
Converts a trivial example of an empty class.
Usage: 
    cd as2cs
    python as2cs.py [file.as ...]
"""


import codecs
from collections import Iterable
from os import path
from pprint import pformat
from pretty_print_code.pretty_print_code import format
from simpleparse.error import ParserSyntaxError
from simpleparse.parser import Parser
from simpleparse.simpleparsegrammar import declaration
from simpleparse.common import strings, comments, numbers, chartypes, SOURCES


cfg = {
    'source': 'as',
    'to': 'cs',
    'is_formats': [
        'compilation_unit'
    ],
}


ebnf_parser = Parser(declaration, 'declarationset')


source_keys = [key for source in SOURCES 
    for key in source.keys()]
source_keys.sort()
## print pformat(source_keys)


def merge_declarations(declarations):
    r"""
    B augments A.
    Normalize whitespace before and after assignment.
    Expects definition fits on one line.
    >>> a = "whitespace     := [ \t\r\n]+"
    >>> b = "IMPORT := 'import'"
    >>> merge_declarations([a, b])
    "whitespace     := [ \t\r\n]+\nIMPORT := 'import'"

    B overwrites A.
    >>> a = "IMPORT  \t := 'import'"
    >>> b = "IMPORT := \t 'using'"
    >>> merge_declarations([a, b])
    "IMPORT := \t 'using'"
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


def set_tags(tags, grammar_text, value):
    r"""
    >>> grammar_text = "a := b\nb := '.'"
    >>> tags = {}
    >>> set_tags(tags, grammar_text, True)
    >>> print pformat(tags)
    {'a': True, 'b': True}
    >>> set_tags(tags, 'spacechar := " "', False)
    >>> print pformat(tags)
    {'a': True, 'b': True, 'spacechar': False}
    """
    taglist = ebnf_parser.parse(grammar_text)
    for tag, begin, end, parts in taglist[1]:
        if tag == 'declaration':
            name_begin, name_end = parts[0][1:3]
            name = grammar_text[name_begin:name_end]
            tags[name] = value


def find_text(text, parts,
        names = ['CHARNOSNGLQUOTE', 'CHARNODBLQUOTE']):
    """
    If no match, return nothing.
    >>> grammar = "import := 'using'"
    >>> parts = ebnf_parser.parse(grammar)[1]
    >>> find_text(grammar, parts, ['digit'])

    Return first text matching.
    >>> find_text(grammar, parts, ['literal'])
    "'using'"

    By default find characters in single or double quotes.
    >>> find_text(grammar, parts)
    'using'
    >>> double_quote = 'import := "using"'
    >>> parts = ebnf_parser.parse(double_quote)[1]
    >>> find_text(double_quote, parts)
    'using'

    If multiple text found, only return the first found.
    >>> first = 'float_suffix := "f" / "F"'
    >>> parts = ebnf_parser.parse(first)[1]
    >>> find_text(first, parts)
    'f'
    """
    found = ''
    if parts:
        for tag, begin, end, part in parts:
            if tag in names:
                found += text[begin:end]
                break
            else:
                found_part = find_text(text, part, names)
                if found_part and not found:
                    found += found_part
    if found:
        return found


def find_texts(text, name, parts, not_followed_by = None, not_preceded_by = None):
    """
    >>> parts = [('VARIABLE', 0, 3, None),
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
    ...  ('data_type', 9, 15, [('string', 9, 15, None)]),
    ...  ('SEMI', 15, 16, None)]
    >>> as_code = 'var path:String;';
    >>> find_texts(as_code, 'digit', parts)
    []
    >>> find_texts(as_code, 'letter', parts)
    ['p', 'a', 't', 'h']

    Not followed by
    >>> find_texts(as_code, 'letter', parts, ':')
    ['p', 'a', 't']
    >>> find_texts(as_code, 'letter', parts, 't')
    ['p', 't', 'h']

    Not preceded by
    >>> find_texts(as_code, 'letter', parts, None, ':')
    ['p', 'a', 't', 'h']
    >>> find_texts(as_code, 'letter', parts, None, 't')
    ['p', 'a', 't']
    """
    found = []
    if parts:
        for tag, begin, end, part in parts:
            if name == tag:
                is_match = True
                if not_followed_by is not None:
                    following = text[end:].strip()
                    for not_followed in not_followed_by:
                        if following.startswith(not_followed):
                            is_match = False
                            break
                if not_preceded_by is not None:
                    preceding = text[:begin].strip()
                    for not_preceded in not_preceded_by:
                        if preceding.endswith(not_preceded):
                            is_match = False
                            break
                if is_match:
                    found.append(text[begin:end])
            else:
                found_part = find_texts(text, name, part, not_followed_by, not_preceded_by)
                if found_part:
                    found.extend(found_part)
    return found


def find_literals(grammar_text):
    literals = {}
    taglist = ebnf_parser.parse(grammar_text)[1]
    for tag, begin, end, parts in taglist:
        if tag == 'declaration':
            name_begin, name_end = parts[0][1:3]
            name = grammar_text[name_begin:name_end]
            literal = find_text(grammar_text, parts)
            if literal:
                literals[name] = literal
    return literals


def replace_literals(a_grammar, b_grammar, literals = None):
    """
    >>> replaces = replace_literals(as_grammar, cs_grammar, literals['cs'])
    >>> replaces.get('IMPORT')
    'using'
    >>> replaces.get('alphaunder')
    >>> replaces = replace_literals(as_grammar, cs_grammar)
    >>> replaces.get('IMPORT')
    'using'
    >>> replaces.get('alphaunder')
    >>> replaces.get('STRING')
    'string'
    """
    if literals is None:
        literals = find_literals(b_grammar)
    def replace_declaration(replaces, original_strings, grammar_text):
        taglist = ebnf_parser.parse(grammar_text)[1]
        for tag, begin, end, parts in taglist:
            if tag == 'declaration':
                name_begin, name_end = parts[0][1:3]
                name = grammar_text[name_begin:name_end]
                text = grammar_text[begin:end]
                if name in original_strings and text != original_strings[name]:
                    literal = literals.get(name)
                    if literal:
                        replaces[name] = literal
                original_strings[name] = text
    replaces = {}
    original_strings = {}
    replace_declaration(replaces, original_strings, a_grammar)
    replace_declaration(replaces, original_strings, b_grammar)
    return replaces


def tag_order(grammar_text):
    """
    >>> cs_var = 'variableDeclaration := whitespace?, dataType, whitespacechar+, identifier, whitespace*, SEMI'
    >>> tag_order(cs_var)
    ['dataType', 'whitespacechar', 'identifier', 'SEMI']
    >>> as_var = 'variableDeclaration := whitespace?, variableDeclarationKeyword, whitespacechar+, identifier, (COLON, dataType)?, whitespace*, SEMI'
    >>> tag_order(as_var)
    ['variableDeclarationKeyword', 'whitespacechar', 'identifier', 'COLON', 'dataType', 'SEMI']

    Exclude lookahead and negatives.
    >>> tag_order('container_expression := -CONTAINS, identity')
    ['identity']
    >>> tag_order('container_expression := ?-CONTAINS, identity')
    ['identity']
    >>> tag_order('container_expression := ?CONTAINS, identity')
    ['identity']
    >>> tag_order('literal_keyword := NULL / UNDEFINED')
    []
    """
    taglist = ebnf_parser.parse(grammar_text)[1]
    optional_occurences = ['*', '?', '/']
    lookahead_or_negatives = ['-', '?', '/']
    order = find_texts(grammar_text, 'name', taglist, optional_occurences, 
        lookahead_or_negatives)[1:]
    return order


def tags_to_reorder(a_grammar, b_grammar):
    """
    For grammar tags of the same name.
    Order of tags in definition B where they differ from order in A
    >>> cs_var = 'variable_declaration := whitespace?, data_type, whitespace, identifier, whitespace?, SEMI'
    >>> as_var = 'variable_declaration := whitespace?, VARIABLE, whitespace, identifier, (COLON, data_type)?, whitespace?, SEMI'
    >>> reorder_tags = tags_to_reorder(as_var, cs_var)
    >>> reorder_tags.get('variable_declaration')
    ['data_type', 'whitespace', 'identifier', 'SEMI']
    >>> reorder_tags = tags_to_reorder(cs_var, as_var)
    >>> reorder_tags.get('variable_declaration')
    ['VARIABLE', 'whitespace', 'identifier', 'COLON', 'data_type', 'SEMI']
    >>> tags_to_reorder('namespace := "package"', 'namespace := "namespace"')
    {}

    Exclude same order when optional keyword or lookahead.
    >>> as_grammar = 'container_identifier := alphaunder'
    >>> cs_grammar = 'container_identifier := ?-CONTAINS, alphaunder, alphanumunder*'
    >>> tags_to_reorder(as_grammar, cs_grammar)
    {}
    >>> cs_grammar = 'container_identifier := CONTAINS, alphaunder, alphanumunder*'
    >>> tags_to_reorder(as_grammar, cs_grammar)
    {'container_identifier': ['CONTAINS', 'alphaunder']}
    """
    def reorder_declaration(reorders, original_tags, grammar_text):
        taglist = ebnf_parser.parse(grammar_text)
        for tag, begin, end, parts in taglist[1]:
            if tag == 'declaration':
                name_begin, name_end = parts[0][1:3]
                name = grammar_text[name_begin:name_end]
                text = grammar_text[begin:end]
                order_tags = tag_order(text)
                if name in original_tags:
                    if order_tags != original_tags[name]:
                        if order_tags:
                            reorders[name] = order_tags
                original_tags[name] = order_tags
    reorders = {}
    original_tags = {}
    reorder_declaration(reorders, original_tags, a_grammar)
    reorder_declaration(reorders, original_tags, b_grammar)
    return reorders


def unique_tag_orders(as_grammar, cs_grammar):
    """
    """
    reorder_tags = {'as': {}, 'cs': {}}
    reorder_tags['as']['cs'] = tags_to_reorder(as_grammar, cs_grammar)
    reorder_tags['cs']['as'] = tags_to_reorder(cs_grammar, as_grammar)
    return reorder_tags


def insert(source_str, insert_str, pos):
    """
    answered Sep 22 '14 at 15:45 Sim Mak
    http://stackoverflow.com/questions/4022827/how-to-insert-some-string-in-the-given-string-at-given-index-in-python
    """
    return source_str[:pos] + insert_str + source_str[pos:]


def reorder_taglist(taglist, tag, input, source, to):
    """
    Inserts tags of target grammar not found in the source grammar.
    Example:  see test_syntax.py
    Does not handle multiple occurences.
    Instead group those together in the grammar, such as 'digits' instead of ('digit', 'digit')
    >>> input = 'b22'
    >>> order = ['digits', 'letter']
    >>> taglist = [('letter', 0, 1, None), ('digits', 1, 3, None)]
    >>> reorder_taglist(taglist, order, input, 'as', 'cs')
    '22b'
    >>> order = ['digit', 'letter']
    >>> taglist = [('letter', 0, 1, None), ('digit', 1, 2, None), ('digit', 2, 3, None)]
    >>> reorder_taglist(taglist, order, input, 'as', 'cs')
    '2b'
    """
    ordered = []
    unordered = taglist[:]
    used_indexes = {}
    reorders = reorder_tags[source][to]
    if isinstance(tag, basestring):
        order_tags = reorders[tag]
    else:
        order_tags = tag
    for order_tag in order_tags:
        for r, row in enumerate(unordered):
            unordered_tag = row[0]
            if order_tag == unordered_tag and not r in used_indexes:
                ordered.append(unordered[r])
                used_indexes[r] = True
                break
        else:
            for verbatim in literals, reorder_defaults:
                if order_tag in verbatim[to]:
                    insert_text = verbatim[to][order_tag]
                    length = len(insert_text)
                    end = len(input)
                    ordered.append((order_tag, end, end + length, None))
                    input += insert_text
                    break
    text = _recurse_tags(ordered, input, source, to)
    return text


def _last(latest, parts, is_pre):
    for t, b, e, sub in parts:
        if sub:
            latest = _last(latest, sub, is_pre)
        elif is_pre:
            latest = max(latest, b)
        else:
            latest = min(latest, e)
    return latest


def affix(begin, end, parts, input, is_pre):
    if is_pre:
        at = begin
    else:
        at = end
    text = ''
    latest = _last(at, parts, is_pre)
    if begin < latest and latest < end:
        if is_pre:
            text = input[:latest]
        else:
            text = input[latest:]
    return text


def _recurse_tags(taglist, input, source, to):
    """
    Reorder tags.
    Transcribe common tags and literal tags.
    Visit sub-parts.
    """
    reorders = reorder_tags[source][to]
    replaces = replace_tags[source][to]
    text = ''
    for tag, begin, end, parts in taglist:
        if tag in replaces:
            text += replaces.get(tag)
        elif tag in literals[to]:
            text += input[begin:end]
        elif tag in reorders:
            text += reorder_taglist(parts, tag, input, source, to)
        elif tag in source_keys:
            text += input[begin:end]
        elif parts:
            text += _recurse_tags(parts, input, source, to)
        else:
            text += input[begin:end]
    return text


def may_format(definition, text):
    if definition in cfg['is_formats']:
        text = format(text)
    return text


def is_iterable(obj):
    """
    http://stackoverflow.com/questions/19943654/type-checking-an-iterable-type-that-is-not-a-string
    """
    return not isinstance(obj, str) and isinstance(obj, Iterable)


def find_tag(taglist, target_tag):
    """
    >>> taglist = ((('other', None), ('generic_collection', None)))
    >>> find_tag(taglist, 'generic_collection')
    ('generic_collection', None)
    """
    if not taglist:
        return None
    elif target_tag == taglist[0]:
        return taglist
    else:
        for elements in taglist:
            if is_iterable(elements):
                tag = find_tag(elements, target_tag)
                if tag:
                    return tag


def may_import(taglist, text, definition, to):
    r"""
    Insert into C# compilation_unit only if there is a generic_collection.
    >>> taglist = ((('other', None), ('generic_collection', None)))
    >>> may_import(taglist, 't', 'function_body', 'cs')
    't'
    >>> may_import(taglist, 't', 'compilation_unit', 'as')
    't'
    >>> may_import(taglist, 't', 'compilation_unit', 'cs')
    'using System.Collections.Generic;\nt'
    >>> may_import(taglist, 't', 'compilation_unit', 'cs')
    'using System.Collections.Generic;\nt'
    >>> may_import(taglist, 't', 'compilation_unit', 'as')
    't'
    >>> taglist = ((('generic_collection', None), ('collection', None)))
    >>> may_import(taglist, 't', 'compilation_unit', 'cs')
    'using System.Collections;\nusing System.Collections.Generic;\nt'

    During preprocessing, remove from C# being converted to ActionScript.
    >>> from_cs = 'before\nusing System.Collections.Generic;\nafter'
    >>> may_import(taglist, from_cs, 'compilation_unit', 'as')
    'before\nafter'
    >>> from_cs = 'before\nusing System.Collections;\nafter'
    >>> may_import(taglist, from_cs, 'compilation_unit', 'as')
    'before\nafter'
    """
    if 'compilation_unit' == definition:
        import_statements = (
            ('generic_collection', 'using System.Collections.Generic;\n'),
            ('collection', 'using System.Collections;\n'),
            ('unity_address', 'using UnityEngine;\n'),
        )
        for tag, import_statement in import_statements:
            if 'cs' == to:
                found = find_tag(taglist, tag)
                if found:
                    text = '%s%s' % (import_statement, text)
            elif 'as' == to:
                text = text.replace(import_statement, '')
    return text


def convert(input, definition = 'compilation_unit'):
    """
    Example of converting syntax from ActionScript to C#.

    >>> print convert('import com.finegamedesign.anagram.Model;', 'import_definition')
    using com.finegamedesign.anagram.Model;

    Related to grammar unit testing specification (gUnit)
    https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
    """
    source = cfg['source']
    to = cfg['to']
    parser = Parser(grammars[source], definition)
    input = may_import(None, input, definition, to)
    taglist = parser.parse(input)
    taglist = [(definition, 0, taglist[-1], taglist[1])]
    text = _recurse_tags(taglist, input, source, to)
    text = may_import(taglist, text, definition, to)
    text = may_format(definition, text)
    return text


def format_taglist(input, definition):
    source = cfg['source']
    parser = Parser(grammars[source], definition)
    taglist = parser.parse(input)
    return pformat(taglist)


def convert_file(source_path, to_path):
    text = codecs.open(source_path, 'r', 'utf-8').read()
    str = convert(text)
    f = codecs.open(to_path, 'w', 'utf-8')
    f.write(str)
    f.close()


def analogous_paths(source_paths):
    path_pairs = []
    for source_path in source_paths:
        root, ext = path.splitext(source_path)
        to_path = '%s.%s' % (root, cfg['to'])
        path_pairs.append([source_path, to_path])
    return path_pairs


def convert_files(source_paths):
    try:
        for source_path, to_path in analogous_paths(source_paths):
            convert_file(source_path, to_path)
    except ParserSyntaxError as err:
        message = 'Path %s:\nproduction %s\nexpected %s\nposition %s' % (
            source_path, err.production, err.expected, err.position)
        if err.buffer:
            radius = 80
            context = err.buffer[max(0, err.position - radius):err.position]
            context += ' >>!<< '
            context += err.buffer[err.position:err.position + radius]
            message += ' of %s. context:\n%s' % (len(err.buffer), context)
        print message
        import pdb
        pdb.set_trace()

def compare_file(source_path, to_path):
    text = codecs.open(source_path, 'r', 'utf-8').read()
    got = convert(text)
    expected = codecs.open(to_path, 'r', 'utf-8').read()
    return [expected, got]


def compare_files(source_paths):
    expected_gots = []
    for source_path, to_path in analogous_paths(source_paths):
        expected_gots.append(compare_file(source_path, to_path))
    return expected_gots


def realpath(a_path):
    """
    http://stackoverflow.com/questions/4934806/python-how-to-find-scripts-directory
    """
    return path.join(path.dirname(path.realpath(__file__)), a_path)


# Cache global variables for speed
as_grammar = merge_declaration_paths(['as_and_cs.g', 'as.g'])
cs_grammar = merge_declaration_paths(['as_and_cs.g', 'cs.g'])
grammars = {'as': as_grammar, 'cs': cs_grammar}
literals = {'as': {}, 'cs': {}}
literals['as'] = find_literals(as_grammar)
literals['cs'] = find_literals(cs_grammar)
replace_tags = {'as': {}, 'cs': {}}
replace_tags['as']['cs'] = replace_literals(as_grammar, cs_grammar, literals['cs'])
replace_tags['cs']['as'] = replace_literals(cs_grammar, as_grammar, literals['as'])

reorder_defaults = {'as': {}, 'cs': {}}
reorder_defaults['cs']['ts'] = literals['cs']['SPACE']
reorder_defaults['as']['ts'] = literals['as']['SPACE']
reorder_defaults['cs']['whitespace'] = literals['cs']['SPACE']
reorder_defaults['as']['whitespace'] = literals['as']['SPACE']
reorder_tags = unique_tag_orders(as_grammar, cs_grammar)

different_tags = {}
set_tags(different_tags, open('as.g').read(), True)
set_tags(different_tags, open('cs.g').read(), True)
for key in source_keys:
    different_tags[key] = False
set_tags(different_tags, open('as_and_cs.g').read(), False)


if '__main__' == __name__:
    import sys
    if len(sys.argv) <= 1:
        print __doc__
    if 2 <= len(sys.argv) and '--test' != sys.argv[1]:
        convert_files(sys.argv[1:])
    import doctest
    doctest.testmod()
