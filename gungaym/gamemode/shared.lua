GM.Name = "Gun Gaym"
GM.Author = "idklol"
GM.Email = "yousuck@life.com"
GM.Website = "goatse.cx"

function GM:Initialize()
	self.BaseClass.Initialize( self )
	
end

team.SetUp(0, "Gaymers", Color(0,0,0,255))
cvars.AddChangeCallback( "gy_rounds", function( convar_name, oldValue, newValue )
	SetGlobalInt("MaxRounds",newValue)
	print(convar_name,oldValue,newValue)
end )
/*
Alright, this is about to get really messy
The following is pretty much going to be all the stuff that happens on kill
*/
function OnKill( victim, weapon, killer )
	local prevlev = killer:GetNWInt("level") --Define the killer's level for convienence
	local wep = weplist[prevlev]
	victim.NextSpawnTime = CurTime() + 4
	victim.DeathTime = CurTime()
	if weapon:GetClass() == "gy_crowbar" then
		RoundEnd(killer)
	end
	
	
	if victim == killer or not IsValid(killer) then --If you kill yourself/Fall to your death (I *think* no wep=fall basically)
		SendDeathMessage(victim,killer:GetActiveWeapon().Class,killer)
		demote(victim)
	else --Else, if someone else killed you
		if (prevlev) > count() and GetGlobalInt("RoundState") == 1 then --If the killer's level is higher than the gun total...
			print("TestDone")
			RoundEnd(killer) --and we're still in round, finish the round
		elseif prevlev <= count() then --Or if it's just a normal kill, give them a level and their guns
			SendDeathMessage(victim,killer:GetActiveWeapon().Class,killer)
			if killer:GetActiveWeapon().Class == "gy_knife" then
				demote(victim)
			end
			killer:SetNWInt("level",prevlev+1)
			killer:SetNWInt("lifelevel",(killer:GetNWInt("lifelevel")+1))
			killer:GiveWeapons()
		end
		LevelMsg(killer,(prevlev+1),GetGlobalInt("RoundState")) 
	end
	
	if killer:GetNWInt("lifelevel") == 3 then
		KillStreak(killer)
	end
end
hook.Add( "PlayerDeath", "playerDeathTest", OnKill )


function KillStreak(ply)
	ply:SetNWInt("lifelevel",0)
	killstreaksound = { "gy/canttouch.wav", "gy/best.wav" }
	ply:EmitSound(((table.Random(killstreaksound))), 500, 100)
	GAMEMODE:SetPlayerSpeed(ply, 550, 550)
	ply:SetJumpPower( 300 )
	local trail = util.SpriteTrail(ply, 0, Color(255,0,0), false, 40, 30, 5.5, 1/(15+1)*0.5, "trails/plasma.vmt")
	timer.Simple(5.5,function() 
		GAMEMODE:SetPlayerSpeed(ply, 210, 350)
		trail:Remove()
		ply:SetJumpPower( 200 )
	end)
end



--Will message the killer his level and stuff
function LevelMsg(killer,level,RoundState)
	local wep = weplist[level]
		
	if wep == nil and (RoundState == 1) then --If you didn't, you must be on knife level, so you get this message
		PrintMessage(HUD_PRINTCENTER, (killer:GetName().." is on knife level!"))
	end
end

function SendDeathMessage(victim,weapon,killer)
	umsg.Start( "DeathNotif" )
		umsg.String (victim:GetName())
		umsg.String (weapon)
		umsg.String (killer:GetName())
	umsg.End()
end

function PrintDeathMessage(data) --Just for the server
	victim = data:ReadString()
	weapon = data:ReadString()
	killer = data:ReadString()
	ply = LocalPlayer()
	
	if victim ~= killer then --Not a suicide/fall
		print(killer.." wasted "..victim.." with "..weapon)
	else
		print(victim.." couldn't take it anymore")
	end
end
usermessage.Hook("DeathNotif",PrintDeathMessage)

function demote(ply)
	print(ply:GetName().." leveled down")
	local prevlevs = ply:GetNWInt("level")
	if prevlevs > 1 then
		ply:SetNWInt("level", prevlevs - 1)
	end
end
	
