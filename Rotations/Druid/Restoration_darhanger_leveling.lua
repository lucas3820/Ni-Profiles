local data = ni.utils.require("darhanger_leveling.lua");

--Ability Convert
local giftofthewild = GetSpellInfo(48470)
local thorns = GetSpellInfo(53307)
local moonkinform = GetSpellInfo(24858)
local innervate = GetSpellInfo(29166)
local faeriefiredr = GetSpellInfo(770)
local lifebloom = GetSpellInfo(48451)
local regrowth = GetSpellInfo(48443)
local rejuvenation = GetSpellInfo(48441)
local tranquility = GetSpellInfo(48447)
local healingtouch = GetSpellInfo(48378)
local swiftmend = GetSpellInfo(18562)
local wildgrowth = GetSpellInfo(53251)
local nourish = GetSpellInfo(50464)

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"Gift of the Wild",
	--"Thorns",
	--"Tree of Life",
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
			if data.UniPause() then
			return true
		end
	end,
-----------------------------------
	["Gift of the Wild"] = function()
		if ni.player.buff(giftofthewild)
		 or not IsUsableSpell(giftofthewild) then 
		 return false
	end
		if ni.spell.available(giftofthewild)
		 and ni.spell.isinstant(giftofthewild) then
			ni.spell.cast(giftofthewild)	
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
		 and not ni.player.buff(innervate)
		 and ni.spell.available(innervate) then
			ni.spell.cast(innervate)
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
		 local lbtank, _, _, lbtank_count, _, _, lbtank_time = ni.unit.buff(tank, lifebloom, "player")
		 local rgtank, _, _, _, _, _, rgtank_time = ni.unit.buff(tank, regrowth, "player")
		 local rjtank, _, _, _, _, _, rjtank_time = ni.unit.buff(tank, rejuvenation, "player")
		-- Buff Thorns on MT -- 
		if ni.spell.available(thorns)
		 and ni.spell.isinstant(thorns)
		 and not ni.unit.buff(tank, thorns)
		 and ni.spell.valid(tank, thorns, false, true, true) then
			ni.spell.cast(thorns, tank)
			return true
		end
		-- Heal MT with Lifebloom --
		if ni.spell.available(lifebloom)
		 and ni.spell.isinstant(lifebloom)
		 and (not lbtank
		 or (lbtank and lbtank_count < 3))
		 and ni.spell.valid(tank, lifebloom, false, true, true) then
			ni.spell.cast(lifebloom, tank)
			return true
		end
		-- Heal MT with Regrowth --
		if ni.spell.available(regrowth)
		 and (not rgtank
		 or (rgtank and rgtank_time - GetTime() < 2))
		 and GetTime() - data.druid.lastRegrowth > 2
		 and not ni.player.ismoving() 
		 and ni.spell.valid(tank, regrowth, false, true, true) then
			data.druid.lastRegrowth = GetTime()
			ni.spell.cast(regrowth, tank)
			return true
		end
		-- Heal MT with Rejuvenation --
		if ni.spell.available(rejuvenation)
		 and ni.spell.isinstant(rejuvenation)
		 and (not rjtank
		 or (rjtank and rjtank_time - GetTime() < 2))
		 and ni.spell.valid(tank, rejuvenation, false, true, true) then
			ni.spell.cast(rejuvenation, tank)
			return true
			end
		end
		-- Off Tank heal
		if offTank ~= nil
		 and UnitExists(offTank) then
		 local rgotank, _, _, _, _, _, rgotank_time = ni.unit.buff(offTank, regrowth, "player")
		 local rjotank, _, _, _, _, _, rjotank_time = ni.unit.buff(offTank, rejuvenation, "player")
		 -- Buff Thorns on OT -- 
		if ni.spell.available(thorns)
		 and ni.spell.isinstant(thorns)
		 and not ni.unit.buff(tank, thorns)
		 and ni.spell.valid(tank, thorns, false, true, true) then
			ni.spell.cast(thorns, tank)
			return true
		end
		-- Heal OT with Regrowth --
		if ni.spell.available(regrowth)
		 and (not rgotank
		 or (rgotank and rgotank_time - GetTime() < 2))
		 and GetTime() - data.druid.lastRegrowth > 2
		 and not ni.player.ismoving() 
		 and ni.spell.valid(offTank, regrowth, false, true, true) then
			data.druid.lastRegrowth = GetTime()
			ni.spell.cast(regrowth, offTank)
			return true
		end
		-- Heal OT with Rejuvenation --
		if ni.spell.available(rejuvenation)
		 and ni.spell.isinstant(rejuvenation)
		 and (not rjotank
		 or (rjotank and rjotank_time - GetTime() < 2))
		 and ni.spell.valid(offTank, rejuvenation, false, true, true) then
			ni.spell.cast(rejuvenation, offTank)
			return true
			end
		end
	end,
-----------------------------------
	["Tranquility"] = function()
		if ni.healing.averagehp(9) < 35
		 and not ni.player.ismoving()
		 and ni.spell.available(tranquility) 
		 and UnitChannelInfo("player") == nil then
			ni.spell.cast(tranquility)
			return true
		end
	end,
-----------------------------------
	["Nature's Swiftness"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 40
		 and ni.spell.available(17116)
		 and ni.spell.available(healingtouch)
		 and ni.spell.valid(ni.members[i].unit, healingtouch, false, true, true) then
			ni.spell.cast(17116)
			ni.spell.cast(healingtouch, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Swiftmend"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 50
		 and ni.spell.available(swiftmend)
		 and ni.spell.isinstant(swiftmend)
		 and ni.spell.valid(ni.members[i].unit, swiftmend, false, true, true)
		 and (ni.unit.buff(ni.members[i].unit, rejuvenation, "player")
		 or ni.unit.buff(ni.members[i].unit, regrowth, "player")) then
			ni.spell.cast(swiftmend, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Wild Growth"] = function()
		if ni.healing.averagehp(4) < 95
		 and ni.spell.available(wildgrowth)
		 and ni.spell.isinstant(swiftmend)
		 and ni.spell.valid(ni.members[1].unit, wildgrowth, false, true, true) then
			ni.spell.cast(wildgrowth, ni.members[1].unit)
			return true
		end
	end,
-----------------------------------
	["Rejuvenation"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].hp < 95
		 and ni.spell.available(rejuvenation)
		 and ni.spell.isinstant(rejuvenation)
		 and not ni.unit.buff(ni.members[i].unit, rejuvenation, "player")
		 and ni.spell.valid(ni.members[i].unit, rejuvenation, false, true, true) then
			ni.spell.cast(rejuvenation, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Nourish"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 75
		 and ni.spell.available(nourish)
		 and (ni.unit.buff(ni.members[i].unit, rejuvenation, "player")
		 or ni.unit.buff(ni.members[i].unit, regrowth, "player")
		 or ni.unit.buff(ni.members[i].unit, lifebloom, "player")
		 or ni.unit.buff(ni.members[i].unit, wildgrowth, "player"))
		 and ni.spell.valid(ni.members[i].unit, nourish, false, true, true) then
			ni.spell.cast(nourish, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Wild Growth all"] = function()
		if ni.healing.averagehp(6) < 100
		 and ni.spell.available(wildgrowth)
		 and ni.spell.isinstant(wildgrowth)
		 and ni.spell.valid(ni.members[1].unit, wildgrowth, false, true, true) then
			ni.spell.cast(wildgrowth, ni.members[1].unit)
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
		 and GetTime() - data.LastDispel > 2
		 and ni.spell.valid(ni.members[i].unit, 2782, false, true, true) then
			ni.spell.cast(2782, ni.members[i].unit)
			data.LastDispel = GetTime()
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
		 and GetTime() - data.LastDispel > 2
		 and not ni.unit.buff(ni.members[i].unit, 2893)
		 and ni.spell.valid(ni.members[i].unit, 2893, false, true, true) then
			ni.spell.cast(2893, ni.members[i].unit)
			data.LastDispel = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Rejuvenation all"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp <= 100
		 and ni.spell.available(rejuvenation)
		 and ni.spell.isinstant(rejuvenation)
		 and not ni.unit.buff(ni.members[i].unit, rejuvenation, "player")
		 and ni.spell.valid(ni.members[i].unit, rejuvenation, false, true, true) then
			ni.spell.cast(rejuvenation, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Restoration Druid by darhanger for 3.3.5a -- Modified by Xcesius for leveling", 
		 "Welcome to Restoration Druid Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For enable priority healing Main Tank & Off Tank put tank name to Tank Overrides and press Enable Main/Off")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("Restoration_darhanger_leveling", queue, abilities);