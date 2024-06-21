database = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ",", "."}
local comb = { get=function(seedGet, indexGet)
  local function lcg(seed)
    local a = 1664525
    local c = 1013904223
    local m = 2^32
    return (a * seed + c) % m
  end
  local function permutation_from_seed(seed, n)
    local L = {}
    for i = 1, n do
      table.insert(L, i)
    end
    for i = n, 2, -1 do
      seed = lcg(seed)
      local j = (seed % i) + 1
      L[i], L[j] = L[j], L[i]
    end
    return L
  end
  local function get_value_from_permutation(seed, i, n)
    n = n or 64
    local permutation = permutation_from_seed(seed, n)
    return permutation[i + 1]
  end
  return get_value_from_permutation(seedGet, indexGet)
end, getTable=function(seedGet)
  
  local function lcg(seed)
    local a = 1664525
    local c = 1013904223
    local m = 2^32
    return (a * seed + c) % m
  end
  local function permutation_from_seed(seed, n)
    local L = {}
    for i = 1, n do
      table.insert(L, i)
    end
    for i = n, 2, -1 do
      seed = lcg(seed)
      local j = (seed % i) + 1
      L[i], L[j] = L[j], L[i]
    end
    return L
  end
  return permutation_from_seed(seedGet, 64)
end}
criptografia = {
  make=function(data, chave)
    local biblioteca={}
    local finalcriptografedcontent=""
	local fianlkey=nil
    if type(chave)=="string" then
      finalkey=string.byte(chave)-1
      for e=1,#chave,1 do
        finalkey=(finalkey-string.byte(chave,e))*(((finalkey+string.byte(chave,e))%string.byte(chave,e))+e)
      end
    else
      finalkey=chave
    end
    for i=0,63 do
      table.insert(biblioteca,database[comb.get(finalkey,i)])
    end
    for i=1,#data,3 do
      if i+1==#data then
        local tableofresult = toSixFor({string.byte(data,i),string.byte(data,i+1),string.byte(" ")})
        finalcriptografedcontent = finalcriptografedcontent .. biblioteca[tableofresult[1]] .. biblioteca[tableofresult[2]] .. biblioteca[tableofresult[3]] .. biblioteca[tableofresult[4]]
      elseif i==#data then
        local tableofresult = toSixFor({string.byte(data,i),string.byte(" "),string.byte(" ")})
        finalcriptografedcontent = finalcriptografedcontent .. biblioteca[tableofresult[1]] .. biblioteca[tableofresult[2]] .. biblioteca[tableofresult[3]] .. biblioteca[tableofresult[4]]
      else
        local tableofresult = toSixFor({string.byte(data,i),string.byte(data,i+1),string.byte(data,i+2)})
        finalcriptografedcontent = finalcriptografedcontent .. biblioteca[tableofresult[1]] .. biblioteca[tableofresult[2]] .. biblioteca[tableofresult[3]] .. biblioteca[tableofresult[4]]
      end
    end
    return finalcriptografedcontent
  end,
  get=function(data, chave)
    local biblioteca={}
    local finaldecriptografedcontent=""
	local finalkey=nil
    if type(chave)=="string" then
      finalkey=string.byte(chave)-1
      for e=1,#chave,1 do
        finalkey=(finalkey-string.byte(chave,e))*(((finalkey+string.byte(chave,e))%string.byte(chave,e))+e)
      end
    else
      finalkey=chave
    end
    for i=0,63 do
      table.insert(biblioteca,database[comb.get(finalkey,i)])
    end
    for i=1,#data,4 do
      local tableofresult = toByte({getIndex(biblioteca,string.sub(data,i,i))-1,getIndex(biblioteca,string.sub(data,i+1,i+1))-1,getIndex(biblioteca,string.sub(data,i+2,i+2))-1,getIndex(biblioteca,string.sub(data,i+3,i+3))-1})
      finaldecriptografedcontent = finaldecriptografedcontent .. string.char(tableofresult[1]) .. string.char(tableofresult[2]) .. string.char(tableofresult[3])
    end
    return finaldecriptografedcontent
  end,
  makeDatabase=function(chave, baseDatabase)
    if baseDatabase==nil then
      baseDatabase={"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ",", "."}
    end
    local biblioteca={}
	local fianlkey=nil
    if type(chave)=="string" then
      finalkey=string.byte(chave)-1
      for e=1,#chave,1 do
        finalkey=(finalkey-string.byte(chave,e))*(((finalkey+string.byte(chave,e))%string.byte(chave,e))+e)
      end
    else
      finalkey=chave
    end
    for i=0,63 do
      table.insert(biblioteca,baseDatabase[comb.get(finalkey,i)])
    end
    return biblioteca
  end,
  setDatabase=function(databasetoset)
    if databasetoset==nil then
      database={"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ",", "."}
    else
      database=databasetoset
    end
  end
}
function getIndex(tabletoget,valor)
  for i=1,#tabletoget do
    if tabletoget[i]==valor then
      return i
    end
  end
  return false
end
function toSixFor(tableofvalues) -- sempre coloque 3 valores na tabela que é o ideal
  local thetableofbinari={}
  local tableofresult={}
  for i=1,#tableofvalues do
    tratValue=tableofvalues[i]
    deformvalue=0
    if tratValue>127 then
      table.insert(thetableofbinari,1)
      deformvalue=128
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>63 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+64
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>31 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+32
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>15 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+16
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>7 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+8
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>3 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+4
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>1 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+2
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>0 then
      table.insert(thetableofbinari,1)
    else
      table.insert(thetableofbinari,0)
    end
  end
  if #thetableofbinari%6>0 then
    table.insert(thetableofbinari,0)
    table.insert(thetableofbinari,0)
  end
  for i=1,#thetableofbinari,6 do
    table.insert(tableofresult,(thetableofbinari[i]*32)+(thetableofbinari[i+1]*16)+(thetableofbinari[i+2]*8)+(thetableofbinari[i+3]*4)+(thetableofbinari[i+4]*2)+thetableofbinari[i+5]+1)
  end
  return tableofresult
end
function toByte(tableofvalues) -- sempre coloque 4 valores na tabela que é o ideal
  local thetableofbinari={}
  local tableofresult={}
  for i=1,#tableofvalues do
    local tratValue=tableofvalues[i]
    deformvalue=0
    if tratValue>31 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+32
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>15 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+16
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>7 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+8
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>3 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+4
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>1 then
      table.insert(thetableofbinari,1)
      deformvalue=deformvalue+2
    else
      table.insert(thetableofbinari,0)
    end
    if tratValue-deformvalue>0 then
      table.insert(thetableofbinari,1)
    else
      table.insert(thetableofbinari,0)
    end
  end
  for i=1,#thetableofbinari,8 do
    table.insert(tableofresult,(thetableofbinari[i]*128)+(thetableofbinari[i+1]*64)+(thetableofbinari[i+2]*32)+(thetableofbinari[i+3]*16)+(thetableofbinari[i+4]*8)+(thetableofbinari[i+5]*4)+(thetableofbinari[i+6]*2)+thetableofbinari[i+7])
  end
  return tableofresult
end
return criptografia