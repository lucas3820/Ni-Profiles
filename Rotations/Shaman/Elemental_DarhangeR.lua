local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",	
	"Universal pause",
	"AutoTarget",
	"Enchant Weapon",
	"Water Shield",
	"Thunderstorm (Regen)",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Wind Shear (Interrupt)",
	"Totems pull",
	"Lava Burst",
	"Elemental Mastery",
	"Flame Shock",
	"Earth Shock",
	"Chain Lightning",
	"Cure Toxins",
	"Purge",
	"Lightning Bolt",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
		if ni.data.darhanger.UniPause() then
			return true
		end
	end,
-----------------------------------
	["AutoTarget"] = function()
		if UnitAffectingCombat("player")
		 and (not UnitExists("target")
		 or (UnitExists("target") 
		 and not UnitCanAttack("player", "target"))) then
			ni.player.runtext("/targetenemy")
		end
	end,
-----------------------------------
	["Enchant Weapon"] = function()
		local mh = GetWeaponEnchantInfo()
		if mh == nil 
		 and ni.spell.available(58790) then
			ni.spell.cast(58790)
			return true
		end
	end,
-----------------------------------
	["Water Shield"] = function()
		if not ni.player.buff(57960)
		 and ni.spell.isinstant(57960)
		 and ni.spell.available(57960) then
			ni.spell.cast(57960)
			return true
		end
	end,
-----------------------------------
	["Thunderstorm (Regen)"] = function()
		local enemies = ni.unit.enemiesinrange("player", 15)
		if #enemies == 0
		 and not UnitAffectingCombat("player")
		 and ni.player.power() < 80
		 and ni.spell.isinstant(59159)
		 and ni.spell.available(59159) then
			ni.spell.cast(59159)
			return true
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if ni.data.darhanger.casterStop()
		 or ni.data.darhanger.PlayerDebuffs()
		 or UnitCanAttack("player","target") == nil
		 or (UnitAffectingCombat("target") == nil 
		 and ni.unit.isdummy("target") == nil 
		 and UnitIsPlayer("target") == nil) then 
			return true
		end
	end,
-----------------------------------
	["Healthstone (Use)"] = function()
		local hstones = { 36892, 36893, 36894 }
		for i = 1, #hstones do
			if ni.player.hp() < 35
			 and ni.player.hasitem(hstones[i]) 
			 and ni.player.itemcd(hstones[i]) == 0 then
				ni.player.useitem(hstones[i])
				return true
			end
		end	
	end,
-----------------------------------
	["Heal Potions (Use)"] = function()
		local hpot = { 33447, 43569, 40087, 41166, 40067 }
		for i = 1, #hpot do
			if ni.player.hp() < 30
			 and ni.player.hasitem(hpot[i])
			 and ni.player.itemcd(hpot[i]) == 0 then
				ni.player.useitem(hpot[i])
				return true
			end
		end
	end,
-----------------------------------
	["Mana Potions (Use)"] = function()
		local mpot = { 33448, 43570, 40087, 42545, 39671 }
		for i = 1, #mpot do
			if ni.player.power() < 25
			 and ni.player.hasitem(mpot[i])
			 and ni.player.itemcd(mpot[i]) == 0  then
				ni.player.useitem(mpot[i])
				return true
			end
		end
	end,
-----------------------------------
	["Racial Stuff"] = function()
		local hracial = { 33697, 20572, 33702, 26297 }
		local alracial = { 20594, 28880 }
		--- Undead
		if ni.data.darhanger.forsaken()
		 and IsSpellKnown(7744)
		 and ni.spell.available(7744) then
				ni.spell.cast(7744)
				return true
		end
		--- Horde race
		for i = 1, #hracial do
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsSpellKnown(hracial[i])
		 and ni.spell.available(hracial[i])
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 49238, true, true) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 49238, true, true)
		 and ni.player.hp() < 20
		 and IsSpellKnown(alracial[i])
		 and ni.spell.available(alracial[i]) then 
					ni.spell.cast(alracial[i])
					return true
				end
			end
		end,
-----------------------------------
	["Use enginer gloves"] = function()
		if ni.player.slotcastable(10)
		 and ni.player.slotcd(10) == 0 
		 and ni.data.darhanger.CDsaverTTD()
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.valid("target", 49238) then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 49238) then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 49238) then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------		
	["Wind Shear (Interrupt)"] = function()
		if ni.spell.shouldinterrupt("target")
		 and ni.spell.available(57994)
		 and ni.spell.isinstant(57994)
		 and GetTime() - ni.data.darhanger.LastInterrupt > 9
		 and ni.spell.valid("target", 57994, true, true)  then
			ni.spell.castinterrupt("target")
			ni.data.darhanger.LastInterrupt = GetTime()
			return true
		end
	end,
-----------------------------------	
	["Totems pull"] = function()
		if not tContains(UnitName("target"), ni.IgnoreUnits) then
		 local fireTotem = select(2, GetTotemInfo(1))
		 local totem_distance = ni.unit.distance("target", "totem1")
		 local target_distance = ni.player.distance("target")
		 if ni.spell.valid("target", 49238)
		 and (fireTotem == ""
		 or (fireTotem ~= ""
		 and target_distance ~= nil
		 and target_distance < 36
		 and totem_distance ~= nil
		 and totem_distance > 40))
		 and not ni.player.ismoving() then
			ni.spell.cast(66842)
			return true
			end
		end
	end,
-----------------------------------
	["Elemental Mastery"] = function()
	    local flameshock = ni.data.darhanger.shaman.flameshock()
	    if ( ni.vars.CD or ni.unit.isboss("target") )
		 and flameshock
		 and ni.spell.isinstant(16166)
		 and not ni.spell.available(60043)
		 and ni.spell.available(16166)
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 49238, true, true) then
			ni.spell.castspells("16166|49238")
			return true
		end
	end,
-----------------------------------
	["Flame Shock"] = function()
		if ni.unit.debuffremaining("target", 49233, "player") < 2
		 and ni.spell.isinstant(49233)
		 and ni.spell.available(49233)
		 and ni.spell.valid("target", 49233, true, true) then
			ni.spell.cast(49233, "target")
			return true
		end
	end,
-----------------------------------
	["Earth Shock"] = function()
		local flameshock = ni.data.darhanger.shaman.flameshock()
		if ni.player.ismoving()
		 and flameshock
		 and ni.spell.isinstant(49231)
		 and ni.spell.available(49231)
		 and ni.spell.valid("target", 49231, true, true) then
			ni.spell.cast(49231, "target")
			return true
		end
	end,
-----------------------------------
	["Lava Burst"] = function()
		local flameshock = ni.data.darhanger.shaman.flameshock()
		if flameshock
		 and not ni.player.ismoving()
		 and ni.spell.available(60043)
		 and ni.spell.valid("target", 60043, true, true) then
			ni.spell.cast(60043, "target")
			return true
		end
	end,
-----------------------------------
	["Chain Lightning"] = function()
		local enemies = ni.unit.enemiesinrange("target", 10)
		if ( #enemies > 1 or #enemies == 1 ) 
		 and ni.spell.available(49271)
		 and not ni.player.ismoving()
		 and ni.spell.valid("target", 49271, true, true) then
			ni.spell.cast(49271, "target")
			return true
		end
	end,
-----------------------------------
	["Cure Toxins"] = function()
		local zone = GetZoneText()
		if zone == "The Ruby Sanctum" then
			return false
		end
		 if ni.player.debufftype("Disease|Poison")
		 and ni.spell.available(526)
		 and ni.spell.isinstant(526)
		 and GetTime() - ni.data.darhanger.LastDispel > 2		 
		 and ni.spell.valid("player", 526, false, true, true) then
			ni.spell.cast(526, "player")
			ni.data.darhanger.LastDispel = GetTime()
			return true
		end
	end,
-----------------------------------
	["Purge"] = function()
		local buff = {48068, 48066, 61301, 43039, 43020, 48441, 11841, 43046, 18100 }
		for i,v in ipairs(buff) do
		 local name, icon, _, _, _, _, _, canPurge = ni.unit.buff("target",v)
		 if canPurge
		 and GetTime() - ni.data.darhanger.shaman.LastPurge > 2.5
		 and ni.spell.isinstant(8012)
		 and ni.spell.available(8012)
		 and ni.spell.valid("player", 8012, true, true)then
			ni.spell.cast(8012, "target")
			ni.data.darhanger.shaman.LastPurge = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Lightning Bolt"] = function()
		if ni.spell.available(49238)
		 and not ni.player.ismoving()
		 and ni.spell.valid("target", 49238, true, true) then
			ni.spell.cast(49238, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Elemental Shaman by DarhangeR for 3.3.5a", 
		 "Welcome to Elemental Shaman Profile! Support and more in Discord > https://discord.gg/u4mtjws.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Elemental_DarhangeR", queue, abilities, data)