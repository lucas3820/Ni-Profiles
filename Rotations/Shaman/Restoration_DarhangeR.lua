local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"Enchant Weapon",
	"Water Shield",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial Stuff",
	"Wind Shear (Interrupt)",
	"Tank Heal",
	"Lesser Healing Wave",
	"Chain Heal Spam",
	"Chain Heal",
	"Riptide",
	"Cleanse Spirit",
	"Cure Toxins",
	"Purge",
	"Healing Wave",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
		if ni.data.darhanger.UniPause() then
			return true
		end
	end,
-----------------------------------
	["Enchant Weapon"] = function()
		local mh, _, _, oh = GetWeaponEnchantInfo()
		if mh == nil 
		 and ni.spell.available(51994) then
			ni.spell.cast(51994)
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
	["Combat specific Pause"] = function()
		if UnitAffectingCombat("player") then
			return false
		end
		for i = 1, #ni.members do
		if UnitAffectingCombat(ni.members[i].unit) then
				return false
			end
		end
			return true
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
	["Tank Heal"] = function()
		local main = ni.tanks()
		-- Main Tank Heal
		if UnitExists(main) then
		 local earthshield, _, _, _, _, _, earthshield_time = ni.unit.buff(main, 49284, "player")
		 local Otearthshield = ni.unit.buff(main, 49284)
		 -- Put Earth Shield on MT
		 if not Otearthshield
		 and not earthshield
		 and ni.spell.isinstant(49284)		 
		 and ni.spell.available(49284)
		 and ni.spell.valid(main, 49284, false, true, true) then
			ni.spell.cast(49284, main)
			return true
		end
		if main ~= nil
		 and ni.unit.hp(main) < 30
		 and ni.spell.isinstant(16188)
		 and ni.spell.available(16188)
		 and ni.spell.available(49273)
		 and ni.spell.valid(main, 49273, false, true, true) then
			ni.spell.cast(16188)
			ni.spell.cast(49273, main)			
			return true
			end
		end
	end,
-----------------------------------
	["Lesser Healing Wave"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 35
		 and ni.spell.available(49276)
		 and not ni.player.ismoving()
		 and ni.spell.valid(ni.members[i].unit, 49276, false, true, true) then
			ni.spell.cast(49276, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Riptide"] = function()
		if ni.spell.available(61301) 
		 and ni.spell.isinstant(61301) then
		-- Lowest member Tank but one member more need heal
		 if ni.members[1].hp < 85
		  and ni.unit.buff(ni.members[1].unit, 49284, "player")
		  and ni.members[2].hp + 12.5 < 85
		  and ni.spell.valid(ni.members[2].unit, 61301, false, true, true) then
			ni.spell.cast(61301, ni.members[2].unit)
			return true
		end
		 -- Lowest member Tank and nobody else
		 if ni.members[1].hp < 85
		  and ni.unit.buff(ni.members[1].unit, 49284, "player")
		  and ni.members[2].hp + 12.5 >= 85
		  and ni.spell.valid(ni.members[1].unit, 61301, false, true, true) then
			ni.spell.cast(61301, ni.members[1].unit)
			return true
		end
		 -- Lowest member isn't Tank
		 if ni.members[1].hp < 85
		  and not ni.unit.buff(ni.members[1].unit, 49284, "player")
		  and ni.spell.valid(ni.members[1].unit, 61301, false, true, true) then
			ni.spell.cast(61301, ni.members[1].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Healing Wave"] = function()
		if ni.spell.available(49273)
		 and not ni.player.ismoving() then
		-- Lowest member Tank but one member more need heal
		 if ni.members[1].hp < 70
		  and ni.unit.buff(ni.members[1].unit, 49284, "player")
		  and ni.members[2].hp + 5 < 70
		  and ni.spell.valid(ni.members[2].unit, 49273, false, true, true) then
			ni.spell.cast(49273, ni.members[2].unit)
			return true
		end
		 -- Lowest member Tank and nobody else
		if ni.members[1].hp < 70
		  and ni.unit.buff(ni.members[1].unit, 49284, "player")
		  and ni.members[2].hp + 5 >= 70
		  and ni.spell.valid(ni.members[1].unit, 49273, false, true, true) then
			ni.spell.cast(49273, ni.members[1].unit)
			return true
		end
		 -- Lowest member isn't Tank
		if ni.members[1].hp < 70
		  and ni.spell.valid(ni.members[1].unit, 49273, false, true, true) then
			ni.spell.cast(49273, ni.members[1].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Cleanse Spirit"] = function()
		local zone = GetZoneText()
		if zone == "The Ruby Sanctum" then
			return false
		end 
		for i = 1, #ni.members do
		 if ni.unit.debufftype(ni.members[i].unit, "Poison|Disease|Curse")	 
		 and ni.spell.available(2782)
		 and ni.spell.isinstant(2782)
		 and ni.healing.candispel(ni.members[i].unit)
		 and GetTime() - ni.data.darhanger.LastDispel > 2
		 and ni.spell.valid(ni.members[i].unit, 2782, false, true, true) then
			ni.spell.cast(2782, ni.members[i].unit)
			ni.data.darhanger.LastDispel = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Cure Toxins"] = function()
		local zone = GetZoneText()
		if zone == "The Ruby Sanctum" then
			return false
		end 
		for i = 1, #ni.members do
		if not IsSpellKnown(51886)
		 and ni.unit.debufftype(ni.members[i].unit, "Poison|Disease")	 
		 and ni.spell.available(526)
		 and ni.spell.isinstant(526)
		 and ni.healing.candispel(ni.members[i].unit)
		 and GetTime() - ni.data.darhanger.LastDispel > 2
		 and ni.spell.valid(ni.members[i].unit, 526, false, true, true) then
			ni.spell.cast(526, ni.members[i].unit)
			ni.data.darhanger.LastDispel = GetTime()
			return true
			end
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
	["Chain Heal"] = function()
		for i = 1, #ni.members do
		local friends = #ni.unit.friendsinrange(ni.members[i].unit, 9)
		if ni.spell.available(55459) 
		 and not ni.player.ismoving() then
		-- Heal party/raid with Chain Heal
		if ni.healing.averagehp(3) < 75
		 and ni.members[i].hp < 80
		 and ni.player.hasglyph(55437)
		 and friends > 2
		 and ni.spell.valid(ni.members[i].unit, 55459, false, true, true) then
			ni.spell.cast(55459, ni.members[i].unit)
			return true
		end
		-- Heal party/raid with Chain Heal	
		if ni.healing.averagehp(2) < 75
		 and ni.members[i].hp < 80
		 and friends > 1
		 and ni.spell.valid(ni.members[i].unit, 55459, false, true, true) then
				ni.spell.cast(55459, ni.members[i].unit)
				return true
				end	
			end
		end
	end,
-----------------------------------
	["Chain Heal Spam"] = function()
		for i = 1, #ni.members do
		local friends = #ni.unit.friendsinrange(ni.members[i].unit, 9)
		if ni.vars.combat.aoe
		 and ni.spell.available(55459) 
		 and not ni.player.ismoving() then
		-- Heal party/raid with Chain Heal	
		if ni.healing.averagehp(2) < 90
		 and ni.members[i].hp < 95
		 and friends > 1
		 and ni.spell.valid(ni.members[i].unit, 55459, false, true, true) then
				ni.spell.cast(55459, ni.members[i].unit)
				return true
				end	
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Restoration Shaman by DarhangeR for 3.3.5a", 
		 "Welcome to Restoration Shaman Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For enable priority healing Main Tank put tank name to Tank Overrides and press Enable Main.\n-For enable Chain of Heal Spam  configure AoE Toggle key.")		
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Restoration_DarhangeR", queue, abilities, data)