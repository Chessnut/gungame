hl2dments = {
	"item_ammo_pistol",
   "item_box_buckshot",
   "item_ammo_smg1",
   "item_ammo_357",
   "item_ammo_357_large",
   "item_ammo_revolver", -- zm
   "item_ammo_ar2",
   "item_ammo_ar2_large",
   "item_ammo_smg1_grenade",
   "item_battery",
   "item_healthkit",
   "item_suitcharger",
   "item_ammo_ar2_altfire",
   "item_rpg_round",
   "item_ammo_crossbow",
   "item_healthvial",
   "item_healthcharger",
   "item_ammo_crate",
   "item_item_crate",
   "weapon_smg1",
   "weapon_shotgun",
   "weapon_ar2",
   "weapon_357",
   "weapon_crossbow",
   "weapon_rpg",
   "weapon_slam",
   "weapon_frag",
   "weapon_crowbar"
	}

function ClearEnts()
	for k,v in pairs(ents.GetAll()) do
		for j,c in pairs(hl2dments) do
			if v:GetClass() == c then
				v:Remove()
			end
		end
	end
end