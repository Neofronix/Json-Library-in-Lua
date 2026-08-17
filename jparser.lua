local jlex = require "jlex"

local Lexer = jlex.Lexer
local Token = jlex.Token



Parser = {
  pos = 1,
  line = 1,
  
  err = function(self, msg)
    print(self.line .. ":" .. self.pos .. " " .. msg)
  end,
  
  new = function(self)
    local o = {}
    setmetatable(o,{__index = Parser})
    return o
  end,
  
  put = function(self, tok)
    self.tokens = tok
  end,
  
  peek = function(self, off)
    off = off or 0
    return self.tokens[self.pos + off]
  end,
  
  advance = function(self)
    self.pos = self.pos + 1
    return self:peek()
  end,
  
  
  
  parseValue = function(self)
    local tok = self:peek()
    
    if tok[1]==Token.Number then
      self:advance()
      return tonumber(tok[2])
      
    elseif tok[1]==Token.String then
      self:advance()
      return tok[2]
      
    elseif tok[1]==Token.True then
      self:advance()
      return true
      
    elseif tok[1]==Token.False then
      self:advance()
      return false
      
    elseif tok[1]==Token.Null then
      self:advance()
      return nil
      
    elseif tok[1]==Token.Lbrace then
      return self:parseObject()
      
    elseif tok[1]==Token.Lbracket then
      return self:parseArray()
    end
    
    self:err("unexpected token")
  end,
  
  parseObject = function(self)
    local out = {}
    self:advance()
    
    while true do
      local key = self:peek()
    
      if key[1] ~= Token.String then
        self:err("expected string as a key")
      end
      
      self:advance()
      
      if self:peek()[1] ~= Token.Colon then
        self:err("expected ':'")
      end
      
      self:advance()
      
      local value = self:parseValue()
      
      out[key[2]] = value
      
      local tok = self:peek()
      
      if tok[1]==Token.Rbrace then
        self:advance()
        break
      end
      
      if tok[1] ~= Token.Comma then
        self:err("expected ',' or '}'")
      end
      self:advance()
    end
      return out
  end,
    
  parseArray = function(self)
    local out = {}
    self:advance()
    
    while true do
      local tok = self:peek()
      
      if tok[1]==Token.Rbracket then
        self:advance()
        break
      end
      
      out[#out + 1] = self:parseValue()
      
      local tok = self:peek()
      
      if tok[1]==Token.Rbracket then
        self:advance()
        break
      end
      
      if tok[1] ~= Token.Comma then
        self:err("expected ',' or ']'")
      end
      
      self:advance()
    end
    
    return out
  end,
  
  parse = function(self)
    local result = self:parseValue()
    
    if self.pos > #self.tokens then
      return result
    end
    print(self.pos, #self.tokens)
    self:err("parser couldnt parse all values")
  end
  
  
}

