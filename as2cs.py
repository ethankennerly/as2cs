# Tests a trivial example.
# Usage: 
#   cd as2cs
#   python as2cs.py

from simpleparse.parser import Parser
from sys import stdin, stdout, stderr
from cs import codes
import pprint

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
    for tag, beg, end, parts in taglist[1]:
        # text += input[beg:end]
        if tag == 'import':
            if parts:
                markup = parts[0]
                mtag, mbeg, mend = markup[:3]
                start, stop = codes.get(mtag, ('/* unknown */','/*- / -*/'))
                text += start + input[mbeg+1:mend-1] + stop
            else:
                text += codes.get(tag)
        elif tag == 'whitespace' or tag == 'identifier' or tag == 'SEMI':
            text += input[beg:end]
        else:
            pass
        # text += input[beg:end]
    # text += 'parsed %s chars of %s\n' %  (taglist[-1], len(input))
    return text

if '__main__' == __name__:
    # input = stdin.read()
    # stdout.write(as2cs(input))
    import doctest
    doctest.testmod()
