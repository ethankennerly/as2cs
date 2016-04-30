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


def as2cs(input, definition = 'compilationUnit'):
    """
    Example of converting syntax from ActionScript to C#.

    >>> print as2cs('import com.finegamedesign.anagram.Model;', 'importDefinition')
    using com.finegamedesign.anagram.Model;

    Related to grammar unit testing specification (gUnit)
    https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
    """
    text = ''
    as_def = merge_declaration_paths(['ecma.def', 'as/as3.def'])
    parser = Parser(as_def, definition)
    taglist = parser.parse(input)
    ## text += pformat(taglist) # debug
    common_tags = {}
    for source in SOURCES:
        for key in source.keys():
            common_tags[key] = True
    set_tags(common_tags, open('ecma.def').read())
    for tag, begin, end, parts in taglist[1]:
        ## text += input[begin:end]
        if tag == 'import':
            if parts:
                markup = parts[0]
                mtag, mbegin, mend = markup[:3]
                start = codes[mtag]
                text += start + input[mbegin:mend]
                ## text += pformat(input[begin:end])
            else:
                text += codes.get(tag)
        elif tag in common_tags:
            text += input[begin:end]
        else:
            pass
        # text += input[begin:end]
    # text += 'parsed %s chars of %s\n' %  (taglist[-1], len(input))
    return text


if '__main__' == __name__:
    # input = stdin.read()
    # stdout.write(as2cs(input))
    import doctest
    doctest.testmod()
