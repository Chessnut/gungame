AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "wepgen.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "mapchange.lua" )
include("entdel.lua")
include("mapchange.lua" )
include("cl_init.lua")
include("player.lua")
include("wepgen.lua")
include("rounds.lua")
resource.AddFile("sound/gy/canttouch.wav")
resource.AddFile("sound/gy/boomhead.wav")
resource.AddFile("sound/gy/best.wav")

RandomizeWeapons()

function GM:Initialize( )
	SetGlobalInt("round",0)
	RoundStart()
	timer.Simple(1,function() ClearEnts() end)
	util.AddNetworkString("wepcl")
	util.AddNetworkString("maplist")
	util.AddNetworkString("mapback")
	SetGlobalInt("RoundState", 1)
	models =
	{
	"models/player/gasmask.mdl",
	"models/player/leet.mdl",
	"models/player/Phoenix.mdl",
	"models/player/riot.mdl"
	}
	killstreaksound = { "gy/canttouch.wav", "gy/best.wav" }
	if not ConVarExists("gy_rounds") then
		CreateConVar("gy_rounds",5,{FCVAR_NOTIFY,FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "Determines how many rounds there are per map")
	end
	SetGlobalInt("MaxRounds", GetConVarNumber("gy_rounds"))
end



function GM:PlayerConnect( name, ip )
	PrintMessage( HUD_PRINTTALK, name.. " has joined the game." )
end

function GM:PlayerInitialSpawn( ply )
	PrintMessage( HUD_PRINTTALK, ply:GetName().. " has spawned." )
	ply:SetNWInt("level",1)
	--ply:SetGamemodeTeam( 0 )
	ply:SetModel(table.Random(models))
	net.Start("wepcl")
		net.WriteTable(weplist)
	net.Send(ply)
	ply:SetNWInt("wins", 0)
	CreateClientConVar( "gy_nextwep_enabled", "1", true, false )
	CreateClientConVar( "gy_nextwep_delay", ".4", true, false )
	concommand.Add("gy_print_weplist",(function(ply,cmd,args)
	net.Start("wepcl")
		net.WriteTable(weplist)
	net.Send(ply)
	end))
	ply:SetNWBool("voted",false)
end

function GM:PlayerAuthed( ply, steamID, uniqueID )
	print("Player "..ply:Nick().." has authed.")
end

function GM:PlayerDisconnected(ply)
	PrintMessage( HUD_PRINTTALK, ply:GetName() .. " has left the server." )
end

function GM:PlayerSpawn( ply )
	local RS = GetGlobalInt("RoundState")
	if RS ~= 2 then
		ply:SetNWInt("lifelevel",0)
		local y = ply:GetNWInt("level")
		local wep = weplist[y]
		ply:GiveWeapons()
		if wep ~= nil then
			GAMEMODE:SetPlayerSpeed(ply, 210, 350)
		else
			GAMEMODE:SetPlayerSpeed(ply, 250, 480) --Knife
		end
		ply:SetJumpPower( 200 )
		
		ply:GodEnable()
		timer.Simple(1.5,function() ply:GodDisable() end) --Spawn protection, maybe disable on shoot?
	end
end

function GM:PlayerDeath( Victim, Inflictor, Attacker )
end	

function ScaleDamage( ply, hitgroup, dmginfo )
 
	// More damage if we're shot in the head
	if ply:Crouching() then
		dmginfo:ScaleDamage(.9)
	end
	 if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 1.3 )
		if dmginfo:GetDamage()*1.3 > ply:Health() then
			dmginfo:GetAttacker():EmitSound("gy/boomhead.wav", 290, 100)
		end
	 end
end
 
hook.Add("ScalePlayerDamage","ScaleDamage",ScaleDamage)