Token = {
  Lbrace=1, Rbrace=2,
  
  Lbracket=3, Rbracket=4,
  
  True=5, False=6, Null=7,
  
  Colon=8, Comma=9,
  
  String=10, Number=11, Identifier=12
}

Lexer = {
  line = 1,
  pos = 1,
  err = function(self, msg)
    print(self.line .. ":" .. self.pos .. " " .. msg)
  end,
  
  new = function (self)
    local o = {}
    
    setmetatable(o, {__index = Lexer})
    return o
  end,
  
  put = function(self, src)
    self.src = src
  end,
  
  peek = function (self, off)
    off = off or 0
    return self.src:sub(self.pos + off, self.pos + off)
  end,
  
  advance = function (self)
    self.pos = self.pos + 1
    return self.src:sub(self.pos, self.pos)
  end,
  
  isalpha = function(self, ch)
    local c = ch:byte()
    
    if c=="" then
      return false
    end
    
    if c>=65 and c<=90 or c >=97 and c<=122 then
      return true
    end
    return false
  end,
  
  isdigit = function(self, ch)
    local c = ch:byte()
    if c=="" then
      return false
    end
    
    if c>= 48 and c<=57 then
      return true
    end
    return false
  end,
  
  Identifier = function(self)
    local start = self.pos
    while self:isalpha(self:peek()) do
      self:advance()
    end
    local str = self.src:sub(start, self.pos)
  --  print("got "..str)
    
    if str=="true" then
      return {Token.True, str, self.line}
    elseif str=="false" then
      return {Token.False, str, self.line}
    elseif str=="null" then
      return {Token.Null, str, self.line}
    else
      return {Token.Identifier, str, self.line}
    end
  end,
  
  
  Symbol = function(self) 
    local c = self:peek()
    if c==":" then
      self:advance()
      return {Token.Colon, ":", self.line}
    elseif c=="[" then
      self:advance()
      return {Token.Lbracket, "[", self.line}
    elseif c=="]" then
      self:advance()
      return {Token.Rbracket, "]", self.line}
    elseif c=="{" then
      self:advance()
      return {Token.Lbrace, "{", self.line}
    elseif c=="}" then
      self:advance()
      return {Token.Rbrace, "}", self.line}
    elseif c=="," then
      self:advance()
      return {Token.Comma, ",", self.line}
      
    end
    
    self:err("unexpected symbol " .. c .. " at line " .. self.line)
    return nil
  end,
  
  
  String = function(self)
    self:advance()
    local start = self.pos
    
    while self:peek() ~= '"' do
      self:advance()
    end
    
    local str = self.src:sub(start, self.pos-1)
   -- print("got string "..str)
    
    self:advance()
    
    return {Token.String, str, self.line}
  end,
  
  
  Number = function(self)
    local start = self.pos
    while self:isdigit(self:peek()) or self:peek()=="." do
      self:advance()
    end
    
    local num = self.src:sub(start, self.pos-1)
   -- self:advance()
  --  print("got number " .. num)
    return {Token.Number, num, self.line}
  end,
  
    
  tokenize = function(self)
    local out = {}
    while self.pos <= #self.src do
      local c = self:peek()
      
      if c==" " or c=="\t" then
        self:advance()
      elseif c=="\n" then
        self:advance()
        self.line=self.line+1
        
      elseif (self:isdigit(c) or c==".") then
        out[#out + 1] = self:Number()
      elseif (self:isalpha(c)) then
        out[#out + 1] = self:Identifier()
      elseif (c=='"') then
        out[#out + 1] = self:String()
      else
        out[#out + 1] = self:Symbol()
      end
      
    end
    return out
  end
    
}

return {
  Lexer=Lexer,
  Token=Token
}