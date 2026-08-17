json_parser = require"jparser"

json_text='{"i": 1, "test": [1,2]}'

test = Lexer.new()
test:put(json_text)
print(test.src)

val = test:tokenize()

parser = Parser.new()
parser:put(val)
o = parser:parse()
print(o.test[2])