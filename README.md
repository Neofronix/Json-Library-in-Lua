# Json-Library-in-Lua
json library written in lua. Available for 5.1 - 5.5 Lua versions

# Use example:
```
local jlex = require "jparser"

local Lexer = jlex.Lexer
local Token = jlex.Token

json_text='{"i": 1, "test": [1,2]}'

test = Lexer.new()
test:put(json_text)

val = test:tokenize()

parser = Parser.new()
parser:put(val)
o = parser:parse()
print(o.test[2])
```
