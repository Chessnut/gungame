a = 0
mapvote = {}
function changemap()
	if SERVER then
		local now = game.GetMap()
		local maps = file.Find("maps/gg_*.bsp","MOD")

		--if s > 3 then
			
			for k,v in pairs(maps) do
				--table.insert(mapvote,mapvote[v,0)
				mapvote[v] = 0
				--SetGlobalInt(v,0)
				--s= 0
				--print "Clear"
			end
		--end
		
		for k,v in pairs(player.GetAll()) do
			--if not v:GetNWBool("voted") then
				v:SetNWBool("voted",false)
				net.Start("maplist")
					net.WriteTable(maps)
				net.Send(v)
			--end
		end
	end
	timer.Simple(7.9,function() sv_mapvotefin() end)
end

function cl_SendChoice()
	if CLIENT then
		print "hi"
		local maps = net.ReadTable()
		choice = nil
		
		
		local frame = vgui.Create("DFrame")
		frame:SetSize(300,300)
		frame:SetTitle("Map vote")
		frame:Center()
		frame:MakePopup()
		DermaList = vgui.Create( "DPanelList", frame )
		DermaList:SetPos( 20,40 )
		DermaList:SetSize( 260, 240 )
		DermaList:SetSpacing( 5 ) -- Spacing between items
		DermaList:EnableHorizontal( false ) -- Only vertical items
		DermaList:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
		
		
		for k,v in pairs(maps) do
			button = vgui.Create("DButton")
			button:SetSize(260,35)
			button:SetText(v)
			button:SetParent(frame)
			button.DoClick = function()
			net.Start("mapback")
				net.WriteString(v)
				net.WriteEntity(LocalPlayer())
			net.SendToServer()
			frame:Close()
			end
			DermaList:AddItem( (button) ) -- Add the item above
		end
	end
end
net.Receive("maplist",cl_SendChoice)


function sv_gotit()
	choice = net.ReadString()
	ply = net.ReadEntity()
	if ply:GetNWBool("voted") then end
	ply:SetNWBool("voted",true)
	print(choice)
	old = mapvote[choice]
	mapvote[choice] = (old + 1)
	--SetGlobalInt(choice,GetGlobalInt(choice)+1)
	for k,v in pairs(mapvote) do
		if k == choice then
			--v=v+1
			
			--print(k,v)
		end
		--print(k,v)
	end
	--print(GetGlobalInt(choice))
	print(mapvote[choice])
end
net.Receive("mapback",sv_gotit)

function sv_mapvotefin()
	--a = 0
	--b = nil
	for k,v in pairs(mapvote) do
		if v > a then
			a = v
			b = k
		end
	end
	print(a,b)
	final = string.sub(b,1,-5)
	PrintMessage( HUD_PRINTCENTER, "Next map is "..final.."." )
	timer.Simple(5, function() RunConsoleCommand("changelevel",final) end)
end