local ply = FindMetaTable("Player")

local teams = {}
teams[0] = {name = "Gaymers"}

function ply:SetGamemodeTeam( n )
	if not teams[n] then return false end
	
	self:SetTeam( n )
	--self:GiveWeapons()
	return true
end

function ply:GiveWeapons()
	self:StripWeapons()
	local y = self:GetNWInt("level")
	local weppast = weplist[y-1]
	local wep = weplist[y]
	local wepnext = weplist[y+1]
	
	if wep ~= nil then
		self:Give(wep)
		self:Give("gy_knife")
		self:Give("func_gy_trans")
		self:SelectWeapon("func_gy_trans") --For whatever reason, if I don't swap to another weapon and then...
		timer.Simple(.01,function() self:SelectWeapon(wep);self:StripWeapon("func_gy_trans") end) --...swap to the new weapon, the new weapon doesn't do the draw anim
	else
		self:Give("gy_crowbar")
		self:Give("func_gy_trans") --I made a silent transitive weapon to avoid the SHING of the knife's draw sound
		self:SelectWeapon("func_gy_trans") 
		timer.Simple(.01,function() self:SelectWeapon("gy_crowbar");self:StripWeapon("func_gy_trans") end)
	end

end 

function GM:GetFallDamage( ply, speed )
	return speed/10 --Top of GM13's Flatgrass deals about 88 damage
end

function GM:PlayerDeathThink( pl )

	if (  pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) or (GetGlobalInt("RoundState") == 2) then return end

	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
	
		pl:Spawn()
		
	end
	
end