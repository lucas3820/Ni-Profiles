local data = ni.utils.require("darhanger_leveling.lua");

--Abilities convert
local sealofcorruption = GetSpellInfo(53736)
local sealofvengance = GetSpellInfo(31801)
local sealofcommand = GetSpellInfo(20375)
local sealofrighteousness = GetSpellInfo(21084)
local layonhands = GetSpellInfo(48788)
local flashoflight = GetSpellInfo(48785)
local exorcism = GetSpellInfo(48801)
local judgementofwisdom = GetSpellInfo(53408)
local holywrath = GetSpellInfo(48817)
local conc = GetSpellInfo(48819)
local hammerofwrath = GetSpellInfo(48806)
local crusaderstrike = GetSpellInfo(35395)
local hammeroftherighteous = GetSpellInfo(53595)
local scaredshield = GetSpellInfo(53601)

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"Auto Attack",
--	"AutoTarget",
--	"Seal of Corruption/Vengeance",
--	"Seal of Command",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Lay on Hands (Self)",
	"Divine Shield",
	"Divine Protection",
	"Flash of Light (Self)",
	"Hand of Protection",
	"Aura Mastery",
	"Hand of Freedom (Player)",
	"Divine Plea",
	"Sacred Shield",
	"Avenging Wrath",
	"Hammer of Wrath",	
	"Judgement of Wisdom",
	"Divine Storm",
	"Crusader Strike",
	"Holy Wrath",
	"Cleanse (Player)",
	"Consecration",
	"Exorcism",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
			if ni.data.darhanger_leveling.UniPause() then
			return true
		end
	end,
-----------------------------------
	["Auto Attack"] = function()
		if not IsCurrentSpell(6603) then
			ni.spell.cast(6603);
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
	["Combat specific Pause"] = function()
		if ni.data.darhanger_leveling.meleeStop()
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
		 and ni.unit.inmelee("player", "target")
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.unit.inmelee("player", "target")
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
		 and ni.unit.inmelee("player", "target") then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.unit.inmelee("player", "target") then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.unit.inmelee("player", "target") then
			ni.player.useinventoryitem(14)
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
	["Divine Shield"] = function()
		local forb = ni.data.darhanger_leveling.paladin.forb()
		if ni.player.hp() < 20
		 and not forb
		 and ni.spell.available(642) then
			ni.spell.cast(642)
			return true
		end
	end,
-----------------------------------
	["Divine Protection"] = function()
		local forb = ni.data.darhanger_leveling.paladin.forb()
		if ni.player.hp() < 35
		 and not forb
		 and ni.spell.available(498) then
			ni.spell.cast(498)
			return true
		end
	end,
-----------------------------------
	["Flash of Light (Self)"] = function()
		local aow = ni.data.darhanger_leveling.paladin.aow()
		if ni.player.hp() < 90
		 and aow
		 and ni.spell.isinstant(flashoflight)
		 and not ni.spell.available(exorcism)
		 and ni.spell.available(flashoflight) then
			ni.spell.cast(flashoflight, "player")
			return true
		end
	end,
-----------------------------------
	["Hand of Protection"] = function()
		for i = 1, #ni.members do		 
		 if ni.members[i].hp < 12
		 and not ni.members[i].isTank
		 and not UnitIsDeadOrGhost(ni.members[i].unit)
		 and not ni.unit.buff(ni.members[i].unit, 1038)
		 and not ni.unit.buff(ni.members[i].unit, 6940)
		 and not ni.unit.buff(ni.members[i].unit, 10278)
		 and not ni.unit.debuff(ni.members[i].unit, 25771)	 
		 and ni.spell.available(10278, ni.members[i].unit)
		 and ni.spell.valid(ni.members[i].unit, 10278, false, true, true) then 
			ni.spell.cast(10278, ni.members[i].unit)
			return true
			end
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
	["Divine Plea"] = function()
		if ni.player.power() < 60
		 and not ni.player.buff(54428)
		 and ni.spell.isinstant(54428) 		 
		 and ni.spell.available(54428) then
			ni.spell.cast(54428)
			return true
		end
	end,
-----------------------------------
	["Sacred Shield"] = function()
		if not ni.player.buff(53601)  
		 and ni.spell.isinstant(53601) 
		 and ni.spell.available(53601) then
			ni.spell.cast(53601, "player")
			return true
		end
	end,
-----------------------------------
	["Avenging Wrath"] = function()
		if ( ni.vars.CD or ni.unit.isboss("target") )
		 and ni.spell.isinstant(31884) 
		 and ni.spell.available(31884)
		 and ni.spell.valid("target", 35395) then
			ni.spell.cast(31884)
			return true
		end
	end,
-----------------------------------
	["Judgement of Wisdom"] = function()
		if ni.spell.available(judgementofwisdom)
		 and ni.spell.isinstant(judgementofwisdom) 
		 and ni.spell.valid("target", judgementofwisdom, false, true, true) then
			ni.spell.cast(judgementofwisdom, "target")
			return true
		end
	end,
-----------------------------------
	["Divine Storm"] = function()
		if ni.spell.available(53385)
		 and ni.spell.isinstant(53385) 
		 and ni.spell.valid("target", 35395) then
			ni.spell.cast(53385, "target")
			return true
		end
	end,
-----------------------------------
	["Crusader Strike"] = function()
		if ni.spell.available(crusaderstrike)
		 and ni.spell.isinstant(crusaderstrike) 
		 and ni.spell.valid("target", crusaderstrike, true, true) then
			ni.spell.cast(crusaderstrike, "target")
			return true
		end
	end,
-----------------------------------
	["Holy Wrath"] = function()
		if ni.vars.combat.aoe
		 and ni.spell.isinstant(holywrath)
		 and ni.spell.available(holywrath)
		 and ni.spell.valid("target", hammeroftherighteous, true, true) then
			ni.spell.cast(holywrath, "target")
			return true
		end
	end,
-----------------------------------
	["Consecration"] = function()
		if ni.player.power() > 30
		 and ni.spell.isinstant(conc)
		 and ni.spell.available(conc)
		 and ni.unit.inmelee("player", "target") 
		 and ni.spell.valid("target", judgementofwisdom) then
			ni.spell.cast(conc, "target")
			return true
		end
	end,
-----------------------------------
	["Exorcism"] = function()
		local aow = ni.data.darhanger_leveling.paladin.aow()
		local artofwartalent = select(5, GetTalentInfo(3,17))
		if (aow or artofwartalent == 0)
		 and ni.spell.isinstant(exorcism)
		 and ni.spell.available(exorcism)
		 and ni.spell.valid("target", exorcism, true, true) then
			ni.spell.cast(exorcism, "target")
			return true
		end
	end,
-----------------------------------
	["Hammer of Wrath"] = function()
		if (ni.unit.hp("target") <= 20
		 or IsUsableSpell(hammerofwrath))
		 and ni.spell.isinstant(hammerofwrath)
		 and ni.spell.available(hammerofwrath)
		 and ni.spell.valid("target", hammerofwrath, true, true) then
			ni.spell.cast(hammerofwrath, "target")
			return true
		end
	end,
-----------------------------------	
	["Hand of Freedom (Player)"] = function()
		local debuff = { 45524, 1715, 3408, 59638, 20164, 25809, 31589, 51585, 50040, 50041, 31124, 122, 44614, 1604, 339, 45334, 58179, 61391, 19306, 19185, 35101, 5116, 2974, 61394, 54644, 50245, 50271, 54706, 4167, 33395, 55080, 11113, 6136, 120, 116, 44614, 31589, 20170, 31125, 3409, 26679, 64695, 63685, 8056, 8034, 18118, 18223, 63311, 23694, 1715, 12323, 39965, 55536, 13099, 29703, 32859, 32065 }
		for i = 1, #debuff do
		if ni.player.debuff(debuff[i])
		 and ni.player.ismoving()
		 and ni.spell.isinstant(1044)
		 and ni.spell.available(1044) then
			ni.spell.cast(1044, "player")
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
		 and ni.spell.available(4987)
		 and GetTime() - ni.data.darhanger_leveling.LastDispel > 2
		 and ni.healing.candispel("player")
		 and ni.spell.valid("player", 4987, false, true, true) then
			ni.spell.cast(4987, "player")
			ni.data.darhanger_leveling.LastDispel = GetTime()
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Retribution Paladin by darhanger for 3.3.5a -- Modified by Xcesius for leveling", 
		 "Welcome to Retribution Paladin Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For use Holy Wrath configure AoE Toggle key.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("Retri_darhanger_leveling", queue, abilities);