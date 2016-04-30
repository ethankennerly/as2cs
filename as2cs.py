# Tests a trivial example.
# Usage: 
#   cd as2cs
#   python as2cs.py

from simpleparse.parser import Parser
from sys import stdin, stdout, stderr
from cs import codes
import pprint


def merge_definitions(a_def_text, b_def_text):
    r"""
    B augments A.
    Normalize whitespace before and after assignment.
    Expects definition fits on one line.
    >>> a = "whitespace     := [ \t\r\n]+"
    >>> b = "import := 'import'"
    >>> merge_definitions(a, b)
    "whitespace     := [ \t\r\n]+\nimport := 'import'"

    B overwrites A.
    >>> a = "import  \t := 'import'"
    >>> b = "import := \t 'using'"
    >>> merge_definitions(a, b)
    "import := \t 'using'"
    """
    def parse_declaration(parser, input):
        text = ''
        taglist = parser.parse(input)
        for tag, begin, end, parts in taglist[1]:
            if tag == 'declaration':
                text += input[begin:end]
        ## text += pprint.pformat(taglist)
        return text
    parser = Parser(open('def.def').read(), 'declarationset')
    text = parse_declaration(parser, a_def_text)
    text += "\n" + parse_declaration(parser, b_def_text)
    ## text = a_def_text + "\n" + b_def_text
    return text


def as2cs(input, definition = 'as3CompilationUnit'):
    """
    Example of converting syntax from ActionScript to C#.

    >>> print as2cs('import com.finegamedesign.anagram.Model;', 'importDefinition')
    using com.finegamedesign.anagram.Model;

    Related to grammar unit testing specification (gUnit)
    https://theantlrguy.atlassian.net/wiki/display/ANTLR3/gUnit+-+Grammar+Unit+Testing
    """
    text = ''
    parser = Parser(open('as/as.def').read(), definition)
    taglist = parser.parse(input)
    # text += pprint.pformat(taglist)
    for tag, begin, end, parts in taglist[1]:
        # text += input[begin:end]
        if tag == 'import':
            if parts:
                markup = parts[0]
                mtag, mbegin, mend = markup[:3]
                start, stop = codes.get(mtag, ('/* unknown */','/*- / -*/'))
                text += start + input[mbegin+1:mend-1] + stop
            else:
                text += codes.get(tag)
        elif tag == 'whitespace' or tag == 'identifier' or tag == 'SEMI':
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
