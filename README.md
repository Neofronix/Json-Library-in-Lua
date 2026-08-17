# Json-Library-in-Lua
json library written in pure lua. Available for 5.1 - 5.5 Lua versions

# Use example:
```
json = require"jparser"
Lexer = json.Lexer
Parser = json.Parser
json_text='{"i": 1, "test": [1,2]}'

test = Lexer.new()
test:put(json_text)
print(test.src)

val = test:tokenize()

parser = Parser.new()
parser:put(val)
o = parser:parse()
print(o.test[2])
```
