# https://pypi.python.org/pypi/SimpleParse/
# Version 2.2
# http://www.ibm.com/developerworks/linux/library/l-simple/index.html
# https://books.google.com/books?id=GxKWdn7u4w8C&pg=PA319&lpg=PA319&dq=simpleparse+standard+input&source=bl&ots=M8x58SCzpT&sig=5DOLvoC5-TZyxxlq3_LHD68gbXY&hl=en&sa=X&ved=0ahUKEwjFjOCurKjMAhVMuYMKHaM4ATUQ6AEIMTAD#v=onepage&q=simpleparse%20standard%20input&f=false

from simpleparse.parser import Parser
from sys import stdin, stdout, stderr

input = stdin.read()
from typo_html import codes
parser = Parser(open('typographify.def').read(), 'para')
taglist = parser.parse(input)
for tag, beg, end, parts in taglist[1]:
    if tag == 'plain':
        stdout.write(input[beg:end])
    elif tag == 'markup':
        markup = parts[0]
        mtag, mbeg, mend = markup[:3]
        start, stop = codes.get(mtag, ('<!-- unknown -->','<!-- / -->'))
        stdout.write(start + input[mbeg+1:mend-1] + stop)
stderr.write('parsed %s chars of %s\n' %  (taglist[-1], len(input)))
