function prompt(inputBaseText)
	io.write(inputBaseText)
	return io.read()
end
function promptWithResult(inputBaseText)
	resposta=io.read()
	return resposta
end
function getIndex(tabela, item)
	for i=1,#tabela do
		if tabela[i]==item then
			return i
		end
		return false
	end
end
function generate32characterspass(x)
	math.randomseed(x^x)
	return caracterespossiveis[math.random(1,99999)]
end
function tostringpers(xdaquestao)
	if xdaquestao>9 then
		return tostring(xdaquestao)
	else
		return "0" .. tostring(xdaquestao)
	end
end