if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

if( CLIENT ) then
	SWEP.PrintName = "Knife";
	SWEP.Slot = 0;
	SWEP.SlotPos = 1;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	SWEP.IconLetter = "j"
	killicon.AddFont( "gy_knife", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end
SWEP.PrintName = "Knife"
SWEP.Class = "gy_knife"
SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.NextStrike = 0;
  
SWEP.ViewModel      = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel   = "models/weapons/w_knife_t.mdl"
  
-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.5 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 75	--Damage per Bullet
SWEP.Primary.NumShots		= 100		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= true	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"	--Ammo Type
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"

util.PrecacheSound("weapons/knife/knife_deploy1.wav")
util.PrecacheSound("weapons/knife/knife_hitwall1.wav")
util.PrecacheSound("weapons/knife/knife_hit1.wav")
util.PrecacheSound("weapons/knife/knife_hit2.wav")
util.PrecacheSound("weapons/knife/knife_hit3.wav")
util.PrecacheSound("weapons/knife/knife_hit4.wav")

function SWEP:Initialize()
	if( SERVER ) then
		self:SetWeaponHoldType( "melee" );
	end
	self.Hit = { 
	Sound( "weapons/knife/knife_hitwall1.wav" )};
	self.FleshHit = {
  	Sound( "weapons/knife/knife_hit1.wav" ),
	Sound( "weapons/knife/knife_hit2.wav" ),
	Sound( "weapons/knife/knife_hit3.wav" ),
  	Sound( "weapons/knife/knife_hit4.wav" ) };

end

function SWEP:Precache()
end

function SWEP:Deploy()
	self.Owner:EmitSound( "weapons/knife/knife_deploy1.wav" );
	return true;
end



function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not IsValid(self.Owner) then return end

   if self.Owner.LagCompensation then -- for some reason not always true
      self.Owner:LagCompensation(true)
   end

   local spos = self.Owner:GetShootPos()
   local sdest = spos + (self.Owner:GetAimVector() * 130)

   local tr_main = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
   local hitEnt = tr_main.Entity

   

   if IsValid(hitEnt) or tr_main.HitWorld then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      if not (CLIENT and (not IsFirstTimePredicted())) then
         local edata = EffectData()
         edata:SetStart(spos)
         edata:SetOrigin(tr_main.HitPos)
         edata:SetNormal(tr_main.Normal)

         --edata:SetSurfaceProp(tr_main.MatType)
         --edata:SetDamageType(DMG_CLUB)
         edata:SetEntity(hitEnt)

         if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
            util.Effect("BloodImpact", edata)
			self.Owner:EmitSound( self.FleshHit[math.random(1,#self.FleshHit)] )
			GAMEMODE:SetPlayerSpeed(hitEnt, 100, 90)
			timer.Simple(1.5,function() GAMEMODE:SetPlayerSpeed(hitEnt, 210, 350) end)

            -- does not work on players rah
            --util.Decal("Blood", tr_main.HitPos + tr_main.HitNormal, tr_main.HitPos - tr_main.HitNormal)

            -- do a bullet just to make blood decals work sanely
            -- need to disable lagcomp because firebullets does its own
            self.Owner:LagCompensation(false)
            self.Owner:FireBullets({Num=1, Src=spos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=5000, Damage=0})
         else
            util.Effect("Impact", edata)
			self.Owner:EmitSound( self.Hit[math.random(1,#self.Hit)] );
         end
      end
   else
      	self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
   end


   if CLIENT then
      -- used to be some shit here
   else -- SERVER

      -- Do another trace that sees nodraw stuff like func_button
      local tr_all = nil
      tr_all = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner})
      
      self.Owner:SetAnimation( PLAYER_ATTACK1 )

      if hitEnt and hitEnt:IsValid() then

         local dmg = DamageInfo()
         dmg:SetDamage(self.Primary.Damage)
         dmg:SetAttacker(self.Owner)
         dmg:SetInflictor(self.Weapon)
         dmg:SetDamageForce(self.Owner:GetAimVector() * 1500)
         dmg:SetDamagePosition(self.Owner:GetPos())
         dmg:SetDamageType(DMG_CLUB)

         hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)

--         self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )         

--         self.Owner:TraceHullAttack(spos, sdest, Vector(-16,-16,-16), Vector(16,16,16), 30, DMG_CLUB, 11, true)
--         self.Owner:FireBullets({Num=1, Src=spos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=20})
      
      else
--         if tr_main.HitWorld then
--            self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
--         else
--            self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
--         end

         -- See if our nodraw trace got the goods
      end
   end

   if self.Owner.LagCompensation then
      self.Owner:LagCompensation(false)
   end
end
