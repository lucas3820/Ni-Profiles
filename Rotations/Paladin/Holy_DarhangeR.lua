local data = {"DarhangeR.lua"}

--Abilities convert
local sealofwisdom = GetSpellInfo(20166)
local sealoflight = GetSpellInfo(20165)
local sacredshield = GetSpellInfo(53601)
local layonhands = GetSpellInfo(48788)
local divineprotection = GetSpellInfo(498)
local divinesacrifice = GetSpellInfo(64205)
local divineplea = GetSpellInfo(54428)
local holywrath = GetSpellInfo(48817)
local judgementoflight = GetSpellInfo(20271)
local judgementofwisdom = GetSpellInfo(53408)
local holyshield = GetSpellInfo(48952)
local handoffreedom = GetSpellInfo(1044)
local cleanse = GetSpellInfo(4987)
local beaconoflight = GetSpellInfo(53563)
local divinefavor = GetSpellInfo(20616)
local holyshock = GetSpellInfo(48825)
local holylight = GetSpellInfo(48782)
local flashoflight = GetSpellInfo(48785)
local infusionoflight = GetSpellInfo(54149)


local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"Seal of Wisdom/Light",
	"Cancel Righteous Fury",
	"Divine Plea",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial Stuff",
	"Divine Shield",
	"Cleanse",
	"Judgement of Light",
	"Aura Mastery",
	"Hand of Sacrifice",
	"Hand of Salvation",
	"Hand of Protection",
	"Avenging Wrath",
	"Divine Illumination T10",
	"Divine Illumination",
	"Tank Heal",
	"Holy Light",
	"Holy Shock",
	"Flash of Light",
	"Hand of Freedom",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
			if ni.data.darhanger.UniPause() then
			return true
		end
	end,
-----------------------------------
	["Seal of Wisdom/Light"] = function()
		if ni.spell.available(sealofwisdom)
		 and ni.player.hasglyph(54940)
		 and not ni.player.buff(sealofwisdom) then 
			ni.spell.cast(sealofwisdom)
			return true
		end
		if ni.spell.available(sealoflight)
		 and ni.player.hasglyph(54943)
		 and not ni.player.buff(sealoflight) then 
			ni.spell.cast(sealoflight)
			return true
		else
		if not ni.player.hasglyph(54943)
		 and not ni.player.hasglyph(54940)
		 and not ni.player.buff(sealofwisdom) then
			ni.spell.cast(sealofwisdom)
		    return true
			end
		end
	end,
-----------------------------------
	["Cancel Righteous Fury"] = function()
		local p="player" for i = 1,40 
		do local _,_,_,_,_,_,_,u,_,_,s=UnitBuff(p,i)
			if u==p and s==25780 then
				CancelUnitBuff(p,i) 
				break;
			end
		end 
	end,
-----------------------------------
	["Divine Plea"] = function()
		if not ni.player.buff(54428) 
		 and ni.player.power() < 60 
		 and ni.spell.available(54428) then
			ni.spell.cast(54428)
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
		if IsSpellKnown(7744)
		 and ni.data.darhanger.forsaken()
		 and ni.spell.available(7744) then
				ni.spell.cast(7744)
				return true
		end
		--- Horde race
		for i = 1, #hracial do
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsSpellKnown(hracial[i])
		 and ni.spell.available(hracial[i])
		 and ni.spell.valid("target", 20271, false, true, true) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 20271, false, true, true)
		 and ni.player.hp() < 20
		 and IsSpellKnown(alracial[i])
		 and ni.spell.available(alracial[i]) then 
					ni.spell.cast(alracial[i])
					return true
				end
			end
		end,
-----------------------------------
	["Divine Shield"] = function()
		local forb = ni.data.darhanger.paladin.forb()
		if ni.player.hp() < 22
		 and not forb
		 and ni.spell.isinstant(642)
		 and ni.spell.available(642) then
			ni.spell.cast(642)
			return true
		end
	end,
-----------------------------------
	["Judgement of Light"] = function()
		if ni.spell.available(judgementoflight)
		 and ni.members[1].hp > 75
		 and ni.spell.isinstant(judgementoflight)
		 and ni.spell.valid("target", judgementoflight, false, true, true) then
			ni.spell.cast(judgementoflight, "target")
			return true
		end
	end,
-----------------------------------
	["Aura Mastery"] = function()
		if ni.healing.averagehp(4) < 60
		 and ni.spell.isinstant(31821)	
		 and ni.spell.available(31821) then
			ni.spell.cast(31821)
			return true
		end
	end,
-----------------------------------
	["Hand of Sacrifice"] = function()
	    for i = 1, #ni.members do
		if ni.members[i].range
		 and ni.members[i].hp < 18
		 and not ni.members[i].istank
		 and not UnitIsDeadOrGhost(ni.members[i].unit)
		 and not ni.unit.buff(ni.members[i].unit, 1038)
		 and not ni.unit.buff(ni.members[i].unit, 6940)
		 and not ni.unit.buff(ni.members[i].unit, 10278)
		 and ni.spell.isinstant(6940)	
		 and ni.spell.available(6940)
		 and ni.spell.valid(ni.members[i].unit, 6940, false, true, true) then
			ni.spell.cast(6940, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Hand of Salvation"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].threat >= 2
		 and not ni.members[i].istank
		 and not UnitIsDeadOrGhost(ni.members[i].unit)
		 and not ni.unit.buff(ni.members[i].unit, 1038)
		 and not ni.unit.buff(ni.members[i].unit, 6940)
		 and not ni.unit.buff(ni.members[i].unit, 10278)
		 and ni.spell.isinstant(1038)			 
		 and ni.spell.available(1038)
		 and ni.spell.valid(ni.members[i].unit, 1038, false, true, true) then 
			ni.spell.cast(1038, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Hand of Protection"] = function()
		for i = 1, #ni.members do		 
		 if ni.members[i].hp < 25
		 and not ni.members[i].istank
		 and not UnitIsDeadOrGhost(ni.members[i].unit)
		 and not ni.unit.buff(ni.members[i].unit, 1038)
		 and not ni.unit.buff(ni.members[i].unit, 6940)
		 and not ni.unit.buff(ni.members[i].unit, 10278)
		 and not ni.unit.debuff(ni.members[i].unit, 25771)
		 and ni.spell.isinstant(10278)		 
		 and ni.spell.available(10278)
		 and ni.spell.valid(ni.members[i].unit, 10278, false, true, true) then 
			ni.spell.cast(10278, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Avenging Wrath"] = function()
		if ni.data.darhanger.youInInstance()
		 and ni.healing.averagehp(4) < 50
		 and ni.spell.isinstant(31821)
		 and ni.spell.available(31821) then
			ni.spell.cast(31821)
			return true
		end
		if ni.data.darhanger.youInRaid()
		 and ni.healing.averagehp(7) < 50
		 and ni.spell.isinstant(31821)
		 and ni.spell.available(31821) then
			ni.spell.cast(31821)
			return true
		end
	end,
-----------------------------------
	["Divine Illumination T10"] = function()
		if ni.data.darhanger.paladin.checkforSet(ni.data.darhanger.paladin.itemsetT10, 2) then 
		 if ni.data.darhanger.youInInstance()
		 and ni.healing.averagehp(5) < 50
		 and ni.spell.isinstant(31842)
		 and ni.spell.available(31842) then
			ni.spell.cast(31842)
			return true
			end
		else
		if ni.data.darhanger.youInRaid()
		 and ni.healing.averagehp(9) < 50
		 and ni.spell.isinstant(31842)
		 and ni.spell.available(31842) then
			ni.spell.cast(31842)
			return true
			end
		end
	end,
-----------------------------------
	["Divine Illumination"] = function()
		if not ni.player.buff(31842) 
		 and ni.player.power() < 15
		 and not ni.spell.available(54428)
		 and ni.spell.isinstant(31842)
		 and ni.spell.available(31842) then
			ni.spell.cast(31842)
			return true
		end
	end,
-----------------------------------
	["Tank Heal"] = function()
		local main = ni.tanks()
		-- Main Tank Heal
		if UnitExists(main) then
		 local BofLtank, _, _, _, _, _, BofLtank_time = ni.unit.buff(main, beaconoflight, "player")
		 local SCtank, _, _, _, _, _, SCtank_time = ni.unit.buff(main, sacredshield, "player")
		 local SelfSCtank = ni.unit.buff(main, sacredshield)
		 local forbtank = ni.unit.debuff(main, 25771)
		if (not BofLtank
		 or (BofLtank and BofLtank_time - GetTime() < 2))
		 and ni.spell.isinstant(beaconoflight)
		 and ni.spell.available(beaconoflight)
		 and ni.spell.valid(main, beaconoflight, false, true, true) then
			ni.spell.cast(beaconoflight, main)
			return true
		end
		 if not SelfSCtank
		 and not (SCtank
		 or (SCtank and SCtank_time - GetTime() < 2))
		 and ni.spell.isinstant(sacredshield)		 
		 and ni.spell.available(sacredshield)
		 and ni.spell.valid(main, sacredshield, false, true, true) then
			ni.spell.cast(sacredshield, main)
			return true
		end
		 if main ~= nil
		 and ni.unit.hp(main) < 12
		 and not forbtank
		 and ni.spell.isinstant(layonhands)
		 and ni.spell.available(layonhands)
		 and ni.spell.valid(main, layonhands, false, true, true) then
			ni.spell.cast(layonhands, main)
			return true
		end
		 if main ~= nil
		 and ni.unit.hp(main) < 25
		 and ni.spell.isinstant(divinefavor)
		 and ni.spell.available(divinefavor)
		 and ni.spell.available(holyshock)
		 and ni.spell.valid(main, holyshock, false, true, true) then
			ni.spell.castspells("divinefavor|holyshock", main)
			return true
			end
		end
	end,
-----------------------------------
	["Holy Light"] = function()
		if ni.members[1].hp < 40
		 and ni.spell.available(holylight)
		 and not ni.player.ismoving()
		 and ni.spell.valid(ni.members[1].unit, holylight, false, true, true) then
			ni.spell.cast(holylight, ni.members[1].unit)
			return true
		end
	end,
-----------------------------------
	["Holy Shock"] = function()
		if ni.spell.available(holyshock) then
		-- Lowest member Tank but one member more need heal
		 if ni.members[1].hp < 75
		  and ni.unit.buff(ni.members[1].unit, beaconoflight, "player")
		  and ni.members[2].hp + 12.5 < 75
		  and ni.spell.valid(ni.members[2].unit, holyshock, false, true, true) then
			ni.spell.cast(holyshock, ni.members[2].unit)
			return true
		end
		 -- Lowest member Tank and nobody else
		 if ni.members[1].hp < 75
		  and ni.unit.buff(ni.members[1].unit, beaconoflight, "player")
		  and ni.members[2].hp + 12.5 >= 75
		  and ni.spell.valid(ni.members[1].unit, holyshock, false, true, true) then
			ni.spell.cast(holyshock, ni.members[1].unit)
			return true
		end
		 -- Lowest member isn't Tank
		 if ni.members[1].hp < 75
		  and not ni.unit.buff(ni.members[1].unit, beaconoflight, "player")
		  and ni.spell.valid(ni.members[1].unit, holyshock, false, true, true) then
			ni.spell.cast(holyshock, ni.members[1].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Flash of Light"] = function()
		if ni.spell.available(flashoflight)
		 and not ni.player.ismoving() 
		 or ni.unit.buff("player", infusionoflight) then
		-- Lowest member Tank but one member more need heal
		 if ni.members[1].hp < 85
		  and ni.unit.buff(ni.members[1].unit, beaconoflight, "player")
		  and ni.members[2].hp + 5 < 85
		  and ni.spell.valid(ni.members[2].unit, flashoflight, false, true, true) then
			ni.spell.cast(flashoflight, ni.members[2].unit)
			return true
		end
		 -- Lowest member Tank and nobody else
		if ni.members[1].hp < 85
		  and ni.unit.buff(ni.members[1].unit, beaconoflight, "player")
		  and ni.members[2].hp + 5 >= 85
		  and ni.spell.valid(ni.members[1].unit, flashoflight, false, true, true) then
			ni.spell.cast(flashoflight, ni.members[1].unit)
			return true
		end
		 -- Lowest member isn't Tank
		if ni.members[1].hp < 85
		  and ni.spell.valid(ni.members[1].unit, flashoflight, false, true, true) then
			ni.spell.cast(flashoflight, ni.members[1].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Cleanse"] = function()
		local zone = GetZoneText()
		if zone == "The Ruby Sanctum" then
			return false
		end 
		for i = 1, #ni.members do
		if ni.unit.debufftype(ni.members[i].unit, "Magic|Disease|Poison")
		 and ni.spell.available(4987)
		 and ni.spell.isinstant(4987)
		 and ni.healing.candispel(ni.members[i].unit)
		 and GetTime() - ni.data.darhanger.LastDispel > 2
		 and ni.spell.valid(ni.members[i].unit, 4987, false, true, true) then
			ni.spell.cast(4987, ni.members[i].unit)
			ni.data.darhanger.LastDispel = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Hand of Freedom"] = function()
		local debuffs = { 45524, 1715, 3408, 59638, 20164, 25809, 31589, 51585, 50040, 50041, 31124, 122, 44614, 1604, 339, 45334, 58179, 61391, 19306, 19185, 35101, 5116, 2974, 61394, 54644, 50245, 50271, 54706, 4167, 33395, 55080, 11113, 6136, 120, 116, 44614, 31589, 20170, 31125, 3409, 26679, 64695, 63685, 8056, 8034, 18118, 18223, 63311, 23694, 1715, 12323, 39965, 55536, 13099, 29703, 32859, 32065 }
		for s=1, #debuffs do
		for i = 1, #ni.members do
		local ally = ni.members[i].unit
		 if ni.unit.debuff(ally, debuffs[s])
		 and ni.spell.available(1044)
		 and ni.spell.isinstant(1044)
		 and ni.unit.ismoving(ally)
		 and ni.spell.valid(ni.members[i].unit, 1044, false, true, true) then
			ni.spell.cast(1044, ni.members[i].unit)
			return true
			    end
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Holy Paladin by DarhangeR for 3.3.5a -- Modified by Xcesius for leveling", 
		 "Welcome to Holy Paladin Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For enable priority healing Main Tank put tank name to Tank Overrides and press Enable Main")	
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Holy_DarhangeR", queue, abilities, data)