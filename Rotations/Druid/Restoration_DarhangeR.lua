local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"Gift of the Wild",
	"Thorns",
	"Tree of Life",
	"Innervate",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial Stuff",
	"Barkskin",
	"Tank Heal",
	"Tranquility",
	"Nature's Swiftness",
	"Swiftmend",
	"Wild Growth",
	"Rejuvenation",		
	"Nourish",
	"Wild Growth all",
	"Remove Curse",
	"Abolish Poison",	
	"Rejuvenation all",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
		if ni.data.darhanger.UniPause() then
			return true
		end
	end,
-----------------------------------
	["Gift of the Wild"] = function()
		if ni.player.buff(48470)
		 or not IsUsableSpell(GetSpellInfo(48470)) then 
		 return false
	end
		if ni.spell.available(48470)
		 and ni.spell.isinstant(48470) then
			ni.spell.cast(48470)	
			return true
		end
	end,
-----------------------------------
	["Thorns"] = function()
		if not ni.player.buff(53307)
		 and ni.spell.available(53307)
		 and ni.spell.isinstant(53307)
		 and UnitAffectingCombat("player") == nil then
			ni.spell.cast(53307)
			return true
		end
	end,
-----------------------------------
	["Tree of Life"] = function()
		if not ni.player.buff(33891)
		 and ni.spell.available(33891) then
			ni.spell.cast(33891)
			return true
		end
	end,
-----------------------------------
	["Innervate"] = function()
		if ni.player.power() < 30
		 and not ni.player.buff(29166)
		 and ni.spell.available(29166) then
			ni.spell.cast(29166)
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
			if ni.player.power() < 35
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
		 and ni.spell.valid("target", 48461) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 48461)
		 and ni.player.hp() < 20
		 and IsSpellKnown(alracial[i])
		 and ni.spell.available(alracial[i]) then 
					ni.spell.cast(alracial[i])
					return true
				end
			end
		end,
-----------------------------------	
	["Barkskin"] = function()
		if ni.player.hp() < 35
		 and ni.spell.isinstant(22812)
		 and ni.spell.available(22812) then
			ni.spell.cast(22812)
			return true
		end
	end,
-----------------------------------
	["Tank Heal"] = function()
		local tank, offTank = ni.tanks()
		-- Main Tank Heal
		if UnitExists(tank) then
		 local lbtank, _, _, lbtank_count, _, _, lbtank_time = ni.unit.buff(tank, 48451, "player")
		 local rgtank, _, _, _, _, _, rgtank_time = ni.unit.buff(tank, 48443, "player")
		 local rjtank, _, _, _, _, _, rjtank_time = ni.unit.buff(tank, 48441, "player")
		-- Buff Thorns on MT -- 
		if ni.spell.available(53307)
		 and ni.spell.isinstant(53307)
		 and not ni.unit.buff(tank, 53307)
		 and ni.spell.valid(tank, 53307, false, true, true) then
			ni.spell.cast(53307, tank)
			return true
		end
		-- Heal MT with Lifebloom --
		if ni.spell.available(48451)
		 and ni.spell.isinstant(48451)
		 and (not lbtank
		 or (lbtank and lbtank_count < 3))
		 and ni.spell.valid(tank, 48451, false, true, true) then
			ni.spell.cast(48451, tank)
			return true
		end
		-- Heal MT with Regrowth --
		if ni.spell.available(48443)
		 and (not rgtank
		 or (rgtank and rgtank_time - GetTime() < 2))
		 and GetTime() - ni.data.darhanger.druid.lastRegrowth > 2
		 and not ni.player.ismoving() 
		 and ni.spell.valid(tank, 48443, false, true, true) then
			ni.data.darhanger.druid.lastRegrowth = GetTime()
			ni.spell.cast(48443, tank)
			return true
		end
		-- Heal MT with Rejuvenation --
		if ni.spell.available(48441)
		 and ni.spell.isinstant(48441)
		 and (not rjtank
		 or (rjtank and rjtank_time - GetTime() < 2))
		 and ni.spell.valid(tank, 48441, false, true, true) then
			ni.spell.cast(48441, tank)
			return true
			end
		end
		-- Off Tank heal
		if offTank ~= nil
		 and UnitExists(offTank) then
		 local rgotank, _, _, _, _, _, rgotank_time = ni.unit.buff(offTank, 48443, "player")
		 local rjotank, _, _, _, _, _, rjotank_time = ni.unit.buff(offTank, 48441, "player")
		 -- Buff Thorns on OT -- 
		if ni.spell.available(53307)
		 and ni.spell.isinstant(53307)
		 and not ni.unit.buff(tank, 53307)
		 and ni.spell.valid(tank, 53307, false, true, true) then
			ni.spell.cast(53307, tank)
			return true
		end
		-- Heal OT with Regrowth --
		if ni.spell.available(48443)
		 and (not rgotank
		 or (rgotank and rgotank_time - GetTime() < 2))
		 and GetTime() - ni.data.darhanger.druid.lastRegrowth > 2
		 and not ni.player.ismoving() 
		 and ni.spell.valid(offTank, 48443, false, true, true) then
			ni.data.darhanger.druid.lastRegrowth = GetTime()
			ni.spell.cast(48443, offTank)
			return true
		end
		-- Heal OT with Rejuvenation --
		if ni.spell.available(48441)
		 and ni.spell.isinstant(48441)
		 and (not rjotank
		 or (rjotank and rjotank_time - GetTime() < 2))
		 and ni.spell.valid(offTank, 48441, false, true, true) then
			ni.spell.cast(48441, offTank)
			return true
			end
		end
	end,
-----------------------------------
	["Tranquility"] = function()
		if ni.healing.averagehp(9) < 35
		 and not ni.player.ismoving()
		 and ni.spell.available(48447) 
		 and UnitChannelInfo("player") == nil then
			ni.spell.cast(48447)
			return true
		end
	end,
-----------------------------------
	["Nature's Swiftness"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 40
		 and ni.spell.available(17116)
		 and ni.spell.available(48378)
		 and ni.spell.valid(ni.members[i].unit, 48378, false, true, true) then
			ni.spell.cast(17116)
			ni.spell.cast(48378, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Swiftmend"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 50
		 and ni.spell.available(18562)
		 and ni.spell.isinstant(18562)
		 and ni.spell.valid(ni.members[i].unit, 18562, false, true, true)
		 and (ni.unit.buff(ni.members[i].unit, 48441, "player")
		 or ni.unit.buff(ni.members[i].unit, 48443, "player")) then
			ni.spell.cast(18562, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Wild Growth"] = function()
		if ni.healing.averagehp(4) < 95
		 and ni.spell.available(53251)
		 and ni.spell.isinstant(18562)
		 and ni.spell.valid(ni.members[1].unit, 53251, false, true, true) then
			ni.spell.cast(53251, ni.members[1].unit)
			return true
		end
	end,
-----------------------------------
	["Rejuvenation"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].hp < 95
		 and ni.spell.available(48441)
		 and ni.spell.isinstant(48441)
		 and not ni.unit.buff(ni.members[i].unit, 48441, "player")
		 and ni.spell.valid(ni.members[i].unit, 48441, false, true, true) then
			ni.spell.cast(48441, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Nourish"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 75
		 and ni.spell.available(50464)
		 and (ni.unit.buff(ni.members[i].unit, 48441, "player")
		 or ni.unit.buff(ni.members[i].unit, 48443, "player")
		 or ni.unit.buff(ni.members[i].unit, 48451, "player")
		 or ni.unit.buff(ni.members[i].unit, 53251, "player"))
		 and ni.spell.valid(ni.members[i].unit, 50464, false, true, true) then
			ni.spell.cast(50464, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Wild Growth all"] = function()
		if ni.healing.averagehp(6) < 100
		 and ni.spell.available(53251)
		 and ni.spell.isinstant(53251)
		 and ni.spell.valid(ni.members[1].unit, 53251, false, true, true) then
			ni.spell.cast(53251, ni.members[1].unit)
			return true
		end
	end,
-----------------------------------
	["Remove Curse"] = function()
		local zone = GetZoneText()
		if zone == "The Ruby Sanctum" then
			return false
		end 
		for i = 1, #ni.members do
		 if ni.unit.debufftype(ni.members[i].unit, "Curse")	 
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
	["Abolish Poison"] = function()
		local zone = GetZoneText()
		if zone == "The Ruby Sanctum" then
			return false
		end 
		for i = 1, #ni.members do
		 if ni.unit.debufftype(ni.members[i].unit, "Poison")	 
		 and ni.spell.available(2893)
		 and ni.spell.isinstant(2893)
		 and ni.healing.candispel(ni.members[i].unit)
		 and GetTime() - ni.data.darhanger.LastDispel > 2
		 and not ni.unit.buff(ni.members[i].unit, 2893)
		 and ni.spell.valid(ni.members[i].unit, 2893, false, true, true) then
			ni.spell.cast(2893, ni.members[i].unit)
			ni.data.darhanger.LastDispel = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Rejuvenation all"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp <= 100
		 and ni.spell.available(48411)
		 and ni.spell.isinstant(48411)
		 and not ni.unit.buff(ni.members[i].unit, 48441, "player")
		 and ni.spell.valid(ni.members[i].unit, 48441, false, true, true) then
			ni.spell.cast(48441, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Restoration Druid by DarhangeR for 3.3.5a", 
		 "Welcome to Restoration Druid Profile! Support and more in Discord > https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-For enable priority healing Main Tank & Off Tank put tank name to Tank Overrides and press Enable Main/Off")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Restoration_DarhangeR", queue, abilities, data)