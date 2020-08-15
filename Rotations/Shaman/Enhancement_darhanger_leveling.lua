local data = ni.utils.require("darhanger_leveling.lua");

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"AutoTarget",
	--"Enchant Weapon",
	"Lightning Shield",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Wind Shear (Interrupt)",
	"Totems pull",
	"Magma Totem",
	"Feral Spirit",
	"Shamanistic Rage",
	"Purge",
	"Cure Toxins",
	"Healing Wave",
	"Chain Lightning/Bolt",
	"Fire Nova",
	"Stormstrike",
	"Flame Shock",
	"Earth Shock",
	"Lava Lash",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
			if data.UniPause() then
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
		local mh, _, _, oh = GetWeaponEnchantInfo()
		if mh == nil 
		 and ni.spell.available(58804) then
			ni.spell.cast(58804)
			return true
		end
		if oh == nil
		 and ni.spell.available(58790) then
			ni.spell.cast(58790)
			return true
		end
	end,
-----------------------------------
    ["Lightning Shield"] = function()
		local shield, _, _, count = ni.player.buff(49281)
		 if not shield
		 or count < 2
		 and ni.spell.isinstant(49281)
		 and ni.spell.available(49281) then
			ni.spell.cast(49281)
			return true
		end
	end,
-----------------------------------
	["Pet Attack/Follow"] = function()
		if ni.unit.hp("playerpet") < 20
		 and UnitExists("playerpet")
		 and UnitExists("target")
		 and UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then
			data.petFollow()
		 else
		if UnitAffectingCombat("player")
		 and UnitExists("playerpet")
		 and ni.unit.hp("playerpet") > 60
		 and UnitExists("target")
		 and not UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then 
			data.petAttack()
			end
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if data.meleeStop()
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
		if IsSpellKnown(7744)
		 and data.forsaken()
		 and ni.spell.available(7744) then
				ni.spell.cast(7744)
				return true
		end
		--- Horde race
		for i = 1, #hracial do
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsSpellKnown(hracial[i])
		 and ni.spell.available(hracial[i])
		 and ni.spell.valid("target", 17364) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 17364)
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
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.valid("target", 17364) then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.spell.valid("target", 17364) then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.spell.valid("target", 17364) then
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
		 and GetTime() - data.LastInterrupt > 9
		 and ni.spell.valid("target", 57994, true, true)  then
			ni.spell.castinterrupt("target")
			data.LastInterrupt = GetTime()
			return true
		end
	end,
-----------------------------------
	["Totems pull"] = function()
		if not tContains(UnitName("target"), ni.IgnoreUnits) then
		 local earthTotem = select(2, GetTotemInfo(2))
		 local totem_distance = ni.unit.distance("target", "totem1")
		 local target_distance = ni.player.distance("target")
		 if ni.spell.valid("target", 17364)
		 and (earthTotem == ""
		 or (earthTotem ~= ""
		 and target_distance ~= nil
		 and target_distance < 6
		 and totem_distance ~= nil
		 and totem_distance > 10))
		 and not ni.player.ismoving() then
			ni.spell.cast(66842)
			return true
			end
		end
	end,
-----------------------------------
	["Magma Totem"] = function()
		if not tContains(UnitName("target"), ni.IgnoreUnits) then
 		 local fireTotem = select(2, GetTotemInfo(1))
		 local totem_distance = ni.unit.distance("target", "totem1")
		 local target_distance = ni.player.distance("target")
		 if ni.spell.valid("target", 17364)
		 and (fireTotem == ""
		 or (fireTotem ~= ""
		 and target_distance ~= nil
		 and target_distance < 6
		 and totem_distance ~= nil
		 and totem_distance > 10))
		 and not ni.player.ismoving() then
			ni.spell.cast(58734)
			return true
			end
		end
	end,
-----------------------------------
	["Shamanistic Rage"] = function()
		if ( ni.vars.CD or ni.unit.isboss("target") )
		 and ni.spell.available(30823)
		 and ni.spell.valid("target", 17364) then
			ni.spell.cast(30823, "target")
			return true
		end
		if ni.player.power() < 35
		 and ni.spell.available(30823)
		 and ni.spell.valid("target", 17364) then
			ni.spell.cast(30823, "target")
			return true
		end
	end,
-----------------------------------
	["Feral Spirit"] = function()
		if ( ni.vars.CD or ni.unit.isboss("target") )
		 and not UnitExists("playerpet")
		 and ni.spell.isinstant(51533)
                 and ni.spell.available(51533)
		 and ni.spell.valid("target", 17364) then
			ni.spell.cast(51533)
			return true
		end
	end,
-----------------------------------
	["Chain Lightning/Bolt"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		local maelstrom, _, _, maelstrom_stacks = ni.player.buff(53817)
		if maelstrom_stacks == 5 then
		 if ( #enemies > 1 or #enemies == 1 )
		 and ni.spell.isinstant(49271)
		 and ni.spell.available(49271)
		 or not ni.spell.valid("target", 17364)
		 and ni.spell.valid("target", 49271, true, true) then 
			ni.spell.cast(49271, "target")
			return true
		end
		if not ni.spell.available(49271)
		 and ni.spell.isinstant(49238)
		 and ni.spell.available(49238)
		 and ni.spell.valid("target", 49238, true, true) then 
			ni.spell.cast(49238, "target")
			return true
		end
		 if #enemies < 1
		 and ni.spell.isinstant(49238)
		 and ni.spell.available(49238)
		 or not ni.spell.valid("target", 17364)
		 and ni.spell.valid("target", 49238, true, true) then 
		 	ni.spell.cast(49238, "target")
			return true
			end	
		end
	end,
-----------------------------------
	["Healing Wave"] = function()
		local maelstrom, _, _, maelstrom_stacks = ni.player.buff(53817)
		if maelstrom_stacks == 5
		 and ni.player.hp() < 60
		 and ni.spell.isinstant(49273)
		 and ni.spell.available(49273) then
		 	ni.spell.cast(49273, "player")
			return true
		end	
	end,
-----------------------------------
	["Fire Nova"] = function()
		local totem_distance = ni.unit.distance("target", "totem1")
		local target_distance = ni.player.distance("target")
		if ni.spell.available(61657)
		 and not ni.spell.available(49231)
		 and not ni.spell.available(17364)
		 and not ni.spell.available(60103) 
		 and fireTotem ~= ""
		 and target_distance < 7
		 and totem_distance < 7
		 and ni.spell.isinstant(61657)
		 and ni.spell.valid("target", 17364) then
		 	ni.spell.cast(61657)
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
		if ni.unit.debuffremaining("target", 49233, "player") > 4
		 and ni.spell.isinstant(49231)
		 and ni.spell.available(49231)
		 and ni.spell.valid("target", 49231, true, true) then
			ni.spell.cast(49231, "target")
			return true
		end
	end,
-----------------------------------
	["Stormstrike"] = function()
		local maelstrom, _, _, maelstrom_stacks = ni.player.buff(53817)
		if (maelstrom == nil
		 or maelstrom_stacks < 5)
		 and ni.spell.isinstant(17364)
		 and ni.spell.available(17364)
		 and ni.spell.valid("target", 17364, true, true) then
			ni.spell.cast(17364, "target")
			return true
		end
	end,
-----------------------------------
	["Lava Lash"] = function()
		local maelstrom, _, _, maelstrom_stacks = ni.player.buff(53817)
		if (maelstrom == nil
		 or maelstrom_stacks < 5)	
		 and ni.spell.isinstant(60103)
		 and ni.spell.available(60103)
		 and ni.spell.valid("target", 60103, true, true) then
			ni.spell.cast(60103, "target")
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
		 and GetTime() - data.LastDispel > 2		 
		 and ni.spell.valid("player", 526, false, true, true) then
			ni.spell.cast(526, "player")
			data.LastDispel = GetTime()
			return true
		end
	end,
-----------------------------------
	["Purge"] = function()
		local buff = {48068, 48066, 61301, 43039, 43020, 48441, 11841, 43046, 18100 }
		for i,v in ipairs(buff) do
		 local name, icon, _, _, _, _, _, canPurge = ni.unit.buff("target",v)
		 if canPurge
		 and GetTime() - data.shaman.LastPurge > 2.5
		 and ni.spell.isinstant(8012)
		 and ni.spell.available(8012)
		 and ni.spell.valid("player", 8012, true, true)then
			ni.spell.cast(8012, "target")
			data.shaman.LastPurge = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Enhancement Shaman by darhanger -- Modified by Xcesius for leveling", 
		 "Welcome to Enhancement Shaman Profile! Support and more in Discord > https://discord.gg/u4mtjws.")	
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("Enhancement_darhanger_leveling", queue, abilities);