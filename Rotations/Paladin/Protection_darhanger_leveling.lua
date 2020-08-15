local data = ni.utils.require("darhanger_leveling.lua");
--Abilities convert
local sealofcorruption = GetSpellInfo(53736)
local sealofvengance = GetSpellInfo(31801)
local sealofcommand = GetSpellInfo(20375)
local sealofrighteousness = GetSpellInfo(21084)
local sacredshield = GetSpellInfo(53601)
local righteousfury = GetSpellInfo(25780)
local hammeroftherigheous = GetSpellInfo(53595)
local layonhands = GetSpellInfo(2800)
local divineprotection = GetSpellInfo(498)
local divinesacrifice = GetSpellInfo(64205)
local divineplea = GetSpellInfo(54428)
local handofreckoning = GetSpellInfo(62124)
local deathgripally = GetSpellInfo(49576)
local righteousdefence = GetSpellInfo(31789)
local holywrath = GetSpellInfo(48817)
local consecration = GetSpellInfo(48819)
local avengersshield = GetSpellInfo(48827)
local judgementoflight = GetSpellInfo(20271)
local judgementofwisdom = GetSpellInfo(53408)
local holyshield = GetSpellInfo(48952)
local handoffreedom = GetSpellInfo(1044)
local cleanse = GetSpellInfo(4987)
local shieldofrighteousness = GetSpellInfo(61411)
local conc = GetSpellInfo(26573)

local function available(spell)
	return ni.spell.available(spell, true);
	end

--Debuffs
local runeofblood = GetSpellInfo(72410)

--Racials for copypasting to other rotations
local willoftheforsaken = GetSpellInfo(7744)

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"AutoTarget",
	"Seal of Corruption/Vengeance",
	"Seal of Command",
	"Righteous Fury",
	"Sacred Shield",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial Stuff",
	"Lay on Hands (Self)",
	"Divine Protection",
	"Divine Sacrifice",
	"Divine Plea",
	"Hand of Reckoning (Ally)",
	"Hand of Reckoning",
	"Righteous Defence",
	"Hammer of the Righteous",
	"Holy Shield",	
	"Shield of Righteousness",
	"Holy Wrath",
	"Consecration",
	"Judgements (PRO)",
	"Avenger's Shield",
--	"Hand of Freedom (Player)",
	"Cleanse (Player)",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
			if ni.data.darhanger_leveling.UniPause() then
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
	["Seal of Corruption/Vengeance"] = function()
		local enemies = ni.unit.enemiesinrange("player", 5)
		if #enemies <= 1
		 and ni.spell.available(sealofcorruption) then
		 if not ni.player.buff(sealofcorruption)
		 and GetTime() - ni.data.darhanger_leveling.paladin.LastSeal > 3
		 and not ni.player.buff(sealofvengance) then
			ni.spell.cast(sealofcorruption)
			ni.data.darhanger_leveling.paladin.LastSeal = GetTime()
			return true
		end
	end
		if #enemies <= 1
		and ni.spell.available(sealofvengance) then
		if not ni.player.buff(sealofvengance) 
		 and GetTime() - ni.data.darhanger_leveling.paladin.LastSeal > 3
		 and not ni.player.buff(sealofcorruption) then
			ni.spell.cast(sealofvengance)
			ni.data.darhanger_leveling.paladin.LastSeal = GetTime()
			return true
			end
		end
		-- level shit
		if #enemies <= 1 
		and not ni.spell.available(sealofcorruption)
		and not ni.spell.available(sealofvengance) 
		and ni.spell.available(sealofrighteousness) then
		if not ni.player.buff(sealofrighteousness) 
		and UnitLevel("player") < 22
		and GetTime() - ni.data.darhanger_leveling.paladin.LastSeal > 3 then
		ni.spell.cast(sealofrighteousness)
		ni.data.darhanger_leveling.paladin.LastSeal = GetTime()
		return true
		end
		end
		
		if not ni.spell.available(sealofcorruption)
		and not ni.spell.available(sealofvengance) 
		and not ni.spell.available(sealofcommand) 
		and ni.spell.available(sealofrighteousness) then
		if not ni.player.buff(sealofrighteousness) 
		and not ni.player.buff(sealofcommand)
		and UnitLevel("player") < 22
		and GetTime() - ni.data.darhanger_leveling.paladin.LastSeal > 3 then
		ni.spell.cast(sealofrighteousness)
		ni.data.darhanger_leveling.paladin.LastSeal = GetTime()
		return true
		end
		end
	
			if #enemies <= 1
		and ni.spell.available(sealofvengance) then
		if not ni.player.buff(sealofvengance) 
		 and GetTime() - ni.data.darhanger_leveling.paladin.LastSeal > 3
		 and not ni.player.buff(sealofcorruption) then
			ni.spell.cast(sealofvengance)
			ni.data.darhanger_leveling.paladin.LastSeal = GetTime()
			return true
			end
		end
		end,
-----------------------------------
	["Seal of Command"] = function()
		local enemies = ni.unit.enemiesinrange("player", 5)
		if (#enemies > 1 or 
		UnitLevel("player") < 60) 
		and ni.spell.available(sealofcommand) then
		if not ni.player.buff(sealofcommand) 
		 and GetTime() - ni.data.darhanger_leveling.paladin.LastSeal > 3 then
			ni.spell.cast(sealofcommand)
			ni.data.darhanger_leveling.paladin.LastSeal = GetTime()
			return true
		end
		end
	end,	
-----------------------------------
	["Righteous Fury"] = function()
		if not ni.player.buff(righteousfury)
		 and ni.spell.available(righteousfury) then 		
			ni.spell.cast(righteousfury)
			return true
		end
	end,
-----------------------------------
	["Sacred Shield"] = function()
		if not ni.player.buff(sacredshield)  
		 and ni.spell.available(sacredshield) then
			ni.spell.cast(sacredshield, "player")
			return true
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if ni.data.darhanger_leveling.tankStop()
		or ni.data.darhanger_leveling.PlayerDebuffs()
		 or UnitCanAttack("player", "target") == nil
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
			if ni.player.power() < 20
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
		 and ni.data.darhanger_leveling.forsaken()
		 and ni.spell.available(7744) then
				ni.spell.cast(7744)
				return true
		end
		--- Horde race
		for i = 1, #hracial do
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsSpellKnown(hracial[i])
		 and ni.spell.available(hracial[i])
		 and ni.spell.valid("target", judgementofwisdom, true, true) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", judgementofwisdom, true, true)
		 and ni.player.hp() < 20
		 and IsSpellKnown(alracial[i])
		 and ni.spell.available(alracial[i]) then 
					ni.spell.cast(alracial[i])
					return true
				end
			end
		end,
-----------------------------------
	["Lay on Hands (Self)"] = function()
		local forb = ni.data.darhanger_leveling.paladin.forb()
		if ni.player.hp() < 20
		 and not forb
		 and ni.spell.isinstant(layonhands)
		 and ni.spell.available(layonhands) then
			ni.spell.cast(layonhands)
			return true
		end
	end,
-----------------------------------
	["Divine Protection"] = function()
		local forb = ni.data.darhanger_leveling.paladin.forb()
		if ni.player.hp() < 35
		 and not forb
		 and ni.spell.isinstant(divineprotection)
		 and ni.spell.available(divineprotection) then
			ni.spell.cast(divineprotection)
			return true
		end
	end,
-----------------------------------
	["Divine Sacrifice"] = function()
		if ni.player.hp() > 30
		 and ni.healing.averagehp(6) < 45
		 and ni.spell.isinstant(divinesacrifice)
		 and ni.spell.available(divinesacrifice) then
			ni.spell.cast(divinesacrifice)
			return true
		end
	end,
-----------------------------------
	["Divine Plea"] = function()
		if not ni.player.buff(divineplea) 
		 and ni.spell.isinstant(divineplea)
		 and ni.spell.available(divineplea) then
			ni.spell.cast(divineplea)
			return true
		end
	end,
-----------------------------------
	["Hand of Reckoning"] = function()
		if UnitExists("targettarget") 
		 and not UnitIsDeadOrGhost("targettarget")
		 and UnitAffectingCombat("player")
		 and (ni.unit.debuff("targettarget", 72410) 
		 or ni.unit.debuff("targettarget", 72448) 
		 or ni.unit.threat("player", "target") < 2 )
  		 and ni.spell.available(handofreckoning)
		 and ni.spell.isinstant(handofreckoning)
		 and ni.data.darhanger_leveling.youInInstance()
		 and ni.spell.valid("target", handofreckoning, false, true, true) then
			ni.spell.cast(handofreckoning)
			return true
		end
	end,
-----------------------------------
	["Hand of Reckoning (Ally)"] = function()
		local enemies = ni.unit.enemiesinrange("target", 30)
		for i = 1, #enemies do
		local threatUnit = enemies[i].guid
   		 if ni.unit.threat("player", threatUnit) ~= nil 
   		  and ni.unit.threat("player", threatUnit) <= 2
   		  and UnitAffectingCombat(threatUnit) 
   		  and not ni.spell.available(deathgripally)
  		  and ni.spell.available(handofreckoning)
		  and ni.spell.isinstant(handofreckoning)
		  and ni.data.darhanger_leveling.youInInstance()
   		  and ni.spell.valid(threatUnit, handofreckoning, false, true, true) then
			ni.spell.cast(handofreckoning, threatUnit)
			return true
			end
		end
	end,
-----------------------------------
	["Righteous Defence"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].range
		 and not UnitIsDeadOrGhost(ni.members[i].unit) then
		 local tarCount = #ni.unit.unitstargeting(ni.members[i].guid)
		 end
		  if tarCount ~= nil and tarCount >= 1
		   and ni.spell.available(righteousdefence)
		   and ni.spell.isinstant(righteousdefence)
		   and not ni.members[i].istank
		   and ni.unit.threat(ni.members[i].guid) >= 2
		   and ni.spell.valid(ni.members[i].unit, righteousdefence, false, true, true) then
				ni.spell.cast(righteousdefence, ni.members[i].unit)
				return true
				end
			end
	end,
-----------------------------------
	["Holy Wrath"] = function()
		if ni.vars.combat.aoe
		 and ni.spell.available(holywrath)
		 and ni.spell.isinstant(holywrath)
		 and ni.spell.valid("target", hammeroftherigheous) then
			ni.spell.cast(holywrath, "target")
			return true
		end
	end,
-----------------------------------
	["Consecration"] = function()
		if ni.player.power() > 30
		 and ni.spell.available(conc)
		 and ni.spell.isinstant(conc)
		 and ni.unit.inmelee("player", "target") 
		 and not ni.unit.ismoving("target")
		 and ni.spell.valid("target", judgementofwisdom) then
			ni.spell.cast(conc, "target")
			return true
			end
	end,
-----------------------------------
	["Avenger's Shield"] = function()
		local enemies = ni.unit.enemiesinrange("target", 5)
		if #enemies > 1
		 and ni.spell.isinstant(avengersshield)
		 and ni.spell.available(avengersshield)
		 and ni.spell.valid("target", avengersshield) then
			ni.spell.cast(avengersshield, "target")
			return true
		end
	end,
-----------------------------------
	["Judgements (PRO)"] = function()
		if ni.spell.available(judgementoflight)
		 and ni.spell.isinstant(judgementoflight)		
		 and ni.spell.valid("target", judgementoflight, false, true, true) then
			if ni.player.power() < 90
			and ni.player.hp() >= 50 then
				ni.spell.cast(judgementofwisdom, "target")
			else
				ni.spell.cast(judgementoflight, "target")
				return true
			end
		end
	end,
-----------------------------------
	["Holy Shield"] = function()
		if not ni.player.buff(holyshield)
		 and ni.spell.isinstant(holyshield)
		 and ni.spell.available(holyshield)
		 and ni.unit.inmelee("player", "target")
		 and ni.spell.valid("target", judgementofwisdom) then
			ni.spell.cast(holyshield, "target")
			return true
		end
	end,
-----------------------------------
	["Hammer of the Righteous"] = function()
		if ni.spell.available(hammeroftherigheous)
		 and ni.spell.isinstant(hammeroftherigheous)
		 and ni.spell.valid("target", hammeroftherigheous, true, true) then
			ni.spell.cast(hammeroftherigheous, "target")
			return true
		end
	end,
-----------------------------------	
	["Hand of Freedom (Player)"] = function()
		local debuff = { 45524, 1715, 3408, 59638, 20164, 25809, 31589, 51585, 50040, 50041, 31124, 122, 44614, 1604, 339, 45334, 58179, 61391, 19306, 19185, 35101, 5116, 2974, 61394, 54644, 50245, 50271, 54706, 4167, 33395, 55080, 11113, 6136, 120, 116, 44614, 31589, 20170, 31125, 3409, 26679, 64695, 63685, 8056, 8034, 18118, 18223, 63311, 23694, 1715, 12323, 39965, 55536, 13099, 29703, 32859, 32065 };
		for i = 1, #debuff do
		if ni.player.debuff(debuff[i])
		 and ni.player.ismoving()
		 and ni.spell.isinstant(handoffreedom)
		 and ni.spell.available(handoffreedom) then
			ni.spell.cast(handoffreedom, "player")
			return true
			end
		end
	end,
-----------------------------------
	["Cleanse (Player)"] = function()
		local zone = GetZoneText()
		if zone == "The Ruby Sanctum" then
			return false
		end
		 if ni.player.debufftype("Magic|Disease|Poison")
		 and ni.spell.available(cleanse)
		 and GetTime() - ni.data.darhanger_leveling.LastDispel > 2
		 and ni.healing.candispel("player")
		 and ni.spell.valid("player", cleanse, false, true, true) then
			ni.spell.cast(cleanse, "player")
			ni.data.darhanger_leveling.LastDispel = GetTime()
			return true
		end
	end,
-----------------------------------
	["Shield of Righteousness"] = function()
		if ni.spell.available(shieldofrighteousness)
		 and ni.spell.isinstant(shieldofrighteousness)
		 and ni.spell.valid("target", shieldofrighteousness, true, true) then
			ni.spell.cast(shieldofrighteousness, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Protection Paladin by darhanger for 3.3.5a -- Modified by Xcesius for leveling",  
		 "Welcome to Protection Paladin Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For use Holy Wrath configure AoE Toggle key.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("Protection_darhanger_leveling", queue, abilities);