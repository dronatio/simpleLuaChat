require("functions")
cript=require("criptograflib")
local tcp = require("tcpsocket")
local portapadrao=7642
socket=nil
conexaopass=""
conexoesdehost={}
conexoesdehostnicks={}
conexoesdehostpass={}
conexoesdehostwaiting={}
messageforminghostsocks={}
messageforminghost=""
messageformingclientnick=""
messageformingclient={}
confirmcode="axd"
senha="DsWrhk45"
ip=nil
conectionstarted=true
--server functions
function hostchat()
	senharequested=prompt("defina uma senha para acesso (deixe em branco para nao ter senha)\n> ")
	if senharequested=="" then
	else
		senha=senharequested
	end
	cript.setDatabase(cript.makeDatabase(senha))
	tcp.server.init()
	socket=tcp.server.create_socket()
	ip=prompt("informe o ip de sua maquina na rede ( a mesma rede dos clients )\n> ")
	tcp.server.bind(socket, ip, portapadrao)
	tcp.server.listen(socket, 256)
	tcp.server.set_accept_callback(function(client_sock, message)
		table.insert(conexoesdehostwaiting, client_sock)
		return 1
	end)
	tcp.server.set_accept_success_callback(function(client_sock)
		print("Client tentando conectar...")
    end)
	tcp.server.set_receive_callback(function(client_sock, data)
	if getIndex(conexoesdehostwaiting,client_sock)==false then
		indexget=getIndex(conexoesdehost,client_sock)
		passget=conexoesdehostpass[indexget]
		decriptmessage=cript.get(data,passget)
		commandreceived=string.sub(decriptmessage,1,3)
		if commandreceived=="tsm" then
			print(conexoesdehostnicks[indexget] .. ": " .. string.sub(decriptmessage,4))
			for i=1,#conexoesdehost do
				if i==indexget then
				else
					tcp.server.send(conexoesdehost[i],cript.make("num" .. tostringpers(#conexoesdehostnicks[indexget]) .. conexoesdehostnicks[indexget],conexoesdehostpass[i]))
					tcp.server.send(conexoesdehost[i],cript.make("wum" .. string.sub(decriptmessage,4),conexoesdehostpass[i]))
				end
			end
		elseif commandreceived=="tcm" then
			table.insert(messageforminghostsocks,client_sock)
			table.insert(messageforminghost,string.sub(decriptmessage,4))
		elseif commandreceived=="dcm" then
			messageid=getIndex(messageforminghostsocks,client_sock)
			messageforminghost[messageid]=messageforminghost[messageid] .. string.sub(decriptmessage,4)
		elseif commandreceived=="fcm" then
			messageid=getIndex(messageforminghostsocks,client_sock)
			messageforminghost[messageid]=messageforminghost[messageid] .. string.sub(decriptmessage,4)
			localuserid=getIndex(conexoesdehost,client_sock)
			localusernick=conexoesdehostnicks[localuserid]
			print(localusernick .. ": " .. messageforminghost[messageid])
			needdatao=#messageforminghost[messageid]/765
			for i=1,#conexoesdehost do
				if i==localuserid then
				else
					tcp.server.send(conexoesdehost[i], cript.make("cum" .. tostringpers(#localusernick) .. localusernick, conexoesdehostpass[i]))
					tcp.server.send(conexoesdehost[i], cript.make("tcm" .. string.sub(messageforminghost[messageid],1,765), conexoesdehostpass[i]))
					if needdatao>2 then
						for e=1,((#messageforminghost[messageid]-(#messageforminghost[messageid]%765))/765)-1 do
							tcp.server.send(conexoesdehost[i], cript.make("dcm" .. string.sub(messageforminghost[messageid],e*765+1,(e+1)*765), conexoesdehostpass[i]))
						end
					end
					tcp.server.send(conexoesdehost[i], cript.make("fcm" .. string.sub(messageforminghost[messageid],#messageforminghost[messageid]-(#messageforminghost[messageid]%765)), conexoesdehostpass[i]))
				end
			end
		end
	else
		decriptedmessage=cript.get(data, ip)
		if string.sub(decriptedmessage,1,3)==confirmcode then
			table.insert(conexoesdehostnicks,string.sub(decriptedmessage,6,#decriptedmessage+tonumber(string.sub(decriptedmessage,4,5))))
			table.insert(conexoesdehost,client_sock)
			passgenerated=generate32characterspass(string.byte(decriptedmessage, 4)+string.byte(decriptedmessage, 5)+string.byte(decriptedmessage, 6)+string.byte(decriptedmessage, 7))
			table.insert(conexoesdehostpass,passgenerated)
			tcp.server.send(client_sock, cript.make(confirmcode .. passgenerated, ip))
			table.remove(conexoesdehostwaiting,getIndex(conexoesdehostwaiting,client_sock))
			indexget=getIndex(conexoesdehostpass,passgenerated)
			if #conexoesdehost>1 then
				for i=1,#conexoesdehost do
					if i==indexget then
					else
						tcp.server.send(cript.make("ujc" .. tostringpers(#conexoesdehostnicks[indexget]) .. conexoesdehostnicks[indexget]), conexoesdehostpass[i])
					end
				end
			end
			print(string.sub(decriptedmessage,6,#decriptedmessage+tonumber(string.sub(decriptedmessage,4,5))) .. " conectou-se com sucesso!!!")
		end
	end
    end)
	tcp.server.set_disconnect_callback(function(client_sock)
		indexget=getIndex(conexoesdehost,client_sock)
		print(conexoesdehostnicks[indexget] .. " saiu do chat")
		for i=1,#conexoesdehost do
			if i==indexget then
			else
				tcp.server.send(cript.make("uec" .. tostringpers(#conexoesdehostnicks[indexget]) .. conexoesdehostnicks[indexget], conexoesdehostpass[i]))
			end
		end
		table.remove(conexoesdehostnicks,indexget)
		table.remove(conexoesdehostpass,indexget)
		table.remove(conexoesdehost,indexget)
	end)
	tcp.server.accept_async(socket)
	
	while true do
		digit=promptWithResult(nick .. ": ")
		if string.sub(string.lower(digit),1,6)==".kick " then
			kickguy(string.sub(digit,7))
		elseif digit=="" then
		else
			sendhostmessage(digit)
		end
	end
end

function sendhostmessage(message)
	if #conexoesdehost==0 then
	else
		for i=1,#conexoesdehost do
			if #message>765 then
				needdatao=#message/765
				tcp.server.send(conexoesdehost[i], cript.make("cum" .. tostringpers(#nick) .. nick, conexoesdehostpass[i]))
				tcp.server.send(conexoesdehost[i], cript.make("tcm" .. string.sub(message,1,765), conexoesdehostpass[i]))
				if needdatao>2 then
					for e=1,((#message-(#message%765))/765)-1 do
						tcp.server.send(conexoesdehost[i], cript.make("dcm" .. string.sub(message,e*765+1,(e+1)*765), conexoesdehostpass[i]))
					end
				end
				tcp.server.send(conexoesdehost[i], cript.make("fcm" .. string.sub(message,1+#message-(#message%765)), conexoesdehostpass[i]))
			else
				tcp.server.send(conexoesdehost[i],cript.make("num" .. tostringpers(#nick) .. nick, conexoesdehostpass[i]))
				tcp.server.send(conexoesdehost[i],cript.make("wum" .. message, conexoesdehostpass[i]))
			end
		end
	end
end

function kickguy(guy)
	indexget=getIndex(conexoesdehostnicks,guy)
	if indexget==false then
		print("Usuario nao encontrado: " .. guy)
	else
		for i=1,#conexoesdehost do
			if i==indexget then
			else
				tcp.server.send(cript.make("uec" .. tostringpers(#conexoesdehostnicks[indexget]) .. conexoesdehostnicks[indexget], conexoesdehostpass[i]), conexoesdehost[i])
			end
		end
		tcp.server.close_socket(conexoesdehost[indexget])
	end
end

-- client functions
function joinchat()
	senharequested=prompt("digite a senha para acesso (deixe em branco caso nao tenha senha)\n> ")
	ip=prompt("digite o ip do host\n> ")
	if senharequested=="" then
	else
		senha=senharequested
	end
	cript.setDatabase(cript.makeDatabase(senha))
	
	tcp.client.init()

	socket = tcp.client.create_socket()
	tcp.client.connect(socket, ip, portapadrao)
	tcp.client.send(socket, cript.make(confirmcode .. tostringpers(#nick) .. nick, ip))
	conexaopass=ip
	tcp.client.set_receive_callback(function(data)
		decriptedmessage=cript.get(data, conexaopass)
		commandreceived=string.sub(decriptedmessage,1,3)
		messagecontent=string.sub(decriptedmessage,4)
		if commandreceived=="ujc" then
			print(string.sub(messagecontent,3,#messagecontent+tonumber(string.sub(messagecontent,1,2))) .. " entrou no chat")
		elseif commandreceived=="num" then
			messagenick=string.sub(messagecontent,3,#messagecontent+tonumber(string.sub(messagecontent,1,2)))
		elseif commandreceived=="wum" then
			print(messagenick .. ": " .. messagecontent)
			messagenick=""
		elseif commandreceived=="uec" then
			print(string.sub(messagecontent,3,tonumber(string.sub(messagecontent,1,2))) .. " saiu do chat")
		elseif commandreceived=="cum" then
			messageformingclientnick=string.sub(messagecontent,3,#messagecontent+tonumber(string.sub(messagecontent,1,2)))
		elseif commandreceived=="tcm" then
			messageformingclient=messagecontent
		elseif commandreceived=="dcm" then
			messageformingclient=messageformingclient .. messagecontent
		elseif commandreceived=="fcm" then
			messageformingclient=messageformingclient .. messagecontent
			print(messageformingclientnick .. ": " .. messageformingclient)
			messageformingclient=nil
			messageformingclientnick=nil
		elseif commandreceived==confirmcode then
			conexaopass=messagecontent
			print("\nConexao bem sucedida!!!\n")
		end
	end)
	tcp.client.set_disconnect_callback(function(message)
		os.exit()
	end)
	tcp.client.receive_async(socket)
	while true do
		digit=promptWithResult(nick .. ": ")
		if digit=="" then
		else
			sendmessage(digit)
		end
	end
end
function sendmessage(messagetosend)
	if #messagetosend>765 then
		needdatao=#messagetosend/765
		tcp.client.send(socket, cript.make("tcm" .. string.sub(messagetosend,1,765), conexaopass))
		if needdatao>2 then
			for i=1,((#messagetosend-(#messagetosend%765))/765)-1 do
				tcp.client.send(socket, cript.make("dcm" .. string.sub(messagetosend,i*765+1,(i+1)*765), conexaopass))
			end
		end
		tcp.client.send(socket, cript.make("fcm" .. string.sub(messagetosend,1+#messagetosend-(#messagetosend%765)), conexaopass))
	else
		tcp.client.send(socket, cript.make("tsm" .. messagetosend, conexaopass))
	end
end
--inicio do programa
print("Bem vindo(a) ao chat hypercriptografado de terminal!!!")
print("esse programa foi desenvolvido pela Dronatio, todos os direitos sobre ele e sobre o servidor utilizado pelo programa sao reservados pela Dronatio")
resposta=string.lower(prompt("Deseja hospedar um chat ou entrar em um chat (Host/Join) > "))
nick=prompt("Qual sera seu nick?\n> ")
if (resposta=="h") or (resposta=="host") or (resposta=="hos") or (resposta=="ho") then
	hostchat()
elseif (resposta=="j") or (resposta=="join") or (resposta=="joi") or (resposta=="jo") then
	joinchat()
end