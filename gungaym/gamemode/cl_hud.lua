t = {}
t.i = {}
keel = false
ded = false
sui = false

killgun = {"mutilated", "killed", "broke", "ventilated", "murdered", "destroyed" }
killknife = { "shanked", "stabbed", "cut", "cut up", "sliced" }
suicide = { "You couldn't take the heat", "You offed yourself", "You commited suicide", "You killed yourself", "Mistakes were made" }


--Right off the bat, I'm terrible with HUD's, so enjoy lots of text instead of a nice pretty bunch of health/ammo bars
function InitializeFonts()

surface.CreateFont( "healthfont", {
	font 		= "Impact",
	size 		= 70,
	weight 		= 500,
	blursize 	= .0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= true,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
	} )
	
		surface.CreateFont( "ammofont", {
	font 		= "Impact",
	size 		= 75,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= true,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
	} )
	
		surface.CreateFont( "ammofontsmall", {
	font 		= "Impact",
	size 		= 35,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= true,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
	} )
	
			surface.CreateFont( "prevwep", {
	font 		= "Impact",
	size 		= 30,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= true,
	strikeout 	= true,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
	} )
	
			surface.CreateFont( "nextwep", {
	font 		= "Impact",
	size 		= 45,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= true,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
	} )
	
				surface.CreateFont( "curwep", {
	font 		= "Impact",
	size 		= 70,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= true,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
	} )
end

function cl_randlist()
	for k,v in pairs(weapons.GetList()) do
		if v.Class ~= nil then
			table.insert(t,k,(v.Class))
			table.insert(t.i,k,v.PrintName)
		end
	end
end

function cl_ReceiveList()
	randlist = net.ReadTable()
	for k,v in pairs(randlist) do
		print (k,v)
	end
	cl_randlist()
end
net.Receive("wepcl",cl_ReceiveList)

function cl_PrevNextWeps(level)
	nextwep = randlist[level+1]
	for l,p in pairs(t) do
	
		if nextwep == p then
			for k,v in pairs(t.i) do
				if l == k then
					nextname = v
				end
			end
		end
	end
end

function DrawHUD()
	ply = LocalPlayer()
	local round = GetGlobalInt("round")
	health = ply:Health()
	level = ply:GetNWInt("level")
	if ply:Alive() then
	
		if GetConVarNumber("gy_nextwep_enabled") == 1 then
		
			if lasttime == nil or lasttime < CurTime() - (GetConVarNumber("gy_nextwep_delay")) then
				lasttime = CurTime()
				cl_PrevNextWeps(level)
			end
			if nextname ~= nil and level == count() then
				draw.SimpleText(("Knife") ,"nextwep", ScrW()-350, ScrH() - 150, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			elseif nextname ~= nil and level < count() then
				draw.SimpleText(("--> "..nextname) ,"nextwep", ScrW()-350, ScrH() - 150, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
		end
		
		if IsValid(ply:GetActiveWeapon()) then
			local mag_left = ply:GetActiveWeapon():Clip1() //How much ammunition you have inside the cusrrent magazine
			local mag_extra = ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()) //How much ammunition you have outside the current magazine
			
			name = ply:GetActiveWeapon().PrintName
			draw.SimpleText((name) ,"curwep", ScrW()-255, ScrH() - 200, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			

			
			if level < count() + 1 then
				draw.SimpleText(("Level: "..level.."/"..count()) ,"prevwep", ScrW()/14, ScrH() - 30, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
			
			--if prevname ~= nil and level ~= 1 then
				--draw.SimpleText((prevname) ,"prevwep", ScrW()-350, ScrH() - 180, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			--end
			
			if mag_left ~= -1 then
				draw.SimpleText((mag_left) ,"ammofont", ScrW()-255, ScrH() - 41, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				draw.SimpleText(("/"..mag_extra) ,"ammofontsmall", ScrW()-255, ScrH() - 50, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
			--draw.RoundedBox(10, ScrW()/15, ScrH() - 100, 250, 50, Color(100,25,25,200))
			--draw.RoundedBox(10, ScrW()/15, ScrH() - 100, LocalPlayer():Health()*2.5, 50, Color(25,150,25,200))
			draw.SimpleText(("Health: "..health) ,"healthfont", ScrW()/14, ScrH() - 50, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end
	
	if lastertime == nil or lastertime < CurTime() - 4 then
		lastertime = CurTime()
		local round = GetGlobalInt("round")
		maxrounds = GetGlobalInt("MaxRounds")
	end
		
	draw.SimpleText(("Round "..round.."/"..maxrounds) ,"nextwep", ScrW()-55, ScrH() - 0, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	
	if keel then
		draw.SimpleText(("You "..res.." "..vic) ,"nextwep", ScrW()/2, ScrH()/1.1, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	if ded then
		draw.SimpleText(("You were "..res.." by "..kil) ,"nextwep", ScrW()/2, ScrH()/1.1, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	if sui then
		draw.SimpleText(resu,"nextwep", ScrW()/2, ScrH()/1.1, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
end

hook.Add("HUDPaint","DrawHUD",DrawHUD)

function hidehud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery","CHudAmmo","CHudSecondaryAmmo"})do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideOldHud", hidehud)

function PrintDeath(data)
	timer.Destroy("DeathTimer")
	ded = false
	keel = false
	sui = false
	resu = false
	res = "" --The 'witty' death response, "mutilated" and "cut up"
	vic = data:ReadString()
	wep = data:ReadString()
	kil = data:ReadString()
	
	if wep == "gy_knife" then
		res = table.Random(killknife)
	else
		res = table.Random(killgun)
	end
	
	ply = LocalPlayer():GetName()
	
	if vic == kil then
		sui = true
		resu = table.Random(suicide)
	elseif ply == vic then
		ded = true
	elseif ply == kil then
		keel = true
	end
	
	timer.Create("DeathTimer",3,1,function()
		ded = false
		keel = false
		sui = false
	end)
end	
usermessage.Hook("DeathNotif",PrintDeath)