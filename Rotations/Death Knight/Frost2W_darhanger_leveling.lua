local data = ni.utils.require("darhanger_leveling.lua");

local hornofwinter = GetSpellInfo(57623)
local deathanddecay = GetSpellInfo(49938)
local hysteria = GetSpellInfo(49016)
local bloodstrike = GetSpellInfo(49930)
local icytouch = GetSpellInfo(49909)
local plaguestrike = GetSpellInfo(49921)
local pestilence = GetSpellInfo(50842)
local deathstrike = GetSpellInfo(49924)
local runestrike = GetSpellInfo(56815)
local bloodboil = GetSpellInfo(49941)
local heartstrike = GetSpellInfo(55262)
local deathcoil = GetSpellInfo(49895)
local howlingblast = GetSpellInfo(51411)
local obliterate = GetSpellInfo(51425)
local froststrike = GetSpellInfo(55268)


local popup_shown = false;
local queue = {
	"Window",		
	"Universal pause",
	"AutoTarget",
	"Blood presence check",
	"Horn of Winter",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Mind Freeze (Interrupt)",
	"Icebound Fort",
	"Death and Decay",
	"Unbreakable Armor",
	"Raise Dead",
	"Empower Rune Weapon",
	"Icy Touch",
	"Plague Strike",
	"Pestilence (AoE)",
	"Pestilence (Renew)",
	"Howling Blast",
	"Howling Blast (AoE)",
	"Frost Strike (Kill)",
	"Death Strike",
	"Obliterate Dump",
	"Obliterate",
	"Frost Strike",
	"Rune Strike",
	"Blood Strike",
	"Frost Strike 2",
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
	["Blood presence check"] = function()
		if not ni.player.buff(48266)
		 and ni.spell.isinstant(48266)
		 and ni.spell.available(48266) then
			ni.spell.cast(48266)
			return true
		end
	end,
-----------------------------------
	["Horn of Winter"] = function()
		if not ni.player.buff(hornofwinter)
		 and ni.spell.isinstant(hornofwinter) 
		 and ni.spell.available(hornofwinter) then 		
			ni.spell.cast(hornofwinter)
			return true
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if ni.data.darhanger_leveling.meleeStop()
		or ni.data.darhanger_leveling.PlayerDebuffs()
		 or UnitCanAttack("player","target") == nil
		 or (UnitAffectingCombat("target") == nil 
		 and ni.unit.isdummy("target") == nil 
		 and UnitIsPlayer("target") == nil) then 
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
			ni.data.darhanger_leveling.petFollow()
		 else
		if UnitAffectingCombat("player")
		 and UnitExists("playerpet")
		 and ni.unit.hp("playerpet") > 60
		 and UnitExists("target")
		 and not UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then 
			ni.data.darhanger_leveling.petAttack()
			end
		end
	end,
-----------------------------------
	["Healthstone (Use)"] = function()
		local hstones = { 36892, 36893, 36894 }
		for i = 1, #hstones do
			if ni.player.hp() < 30
			 and ni.player.hasitem(hstones[i]) 
			 and ni.player.itemcd(hstones[i]) == 0 then
				ni.player.useitem(hstones[i])
				return true
			end
		end	
	end,
-----------------------------------
	["Potions (Use)"] = function()
		local hpot = { 33447, 43569, 40087, 41166, 40067 }
		for i = 1, #hpot do
			if ni.player.hp() < 35
			 and ni.player.hasitem(hpot[i])
			 and ni.player.itemcd(hpot[i]) == 0 then
				ni.player.useitem(hpot[i])
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
		 and IsSpellInRange(GetSpellInfo(49930), "target") == 1 then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if IsSpellInRange(bloodstrike, "target") == 1
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
		 and IsSpellInRange(bloodstrike, "target") == 1 then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and IsSpellInRange(bloodstrike, "target") == 1 then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and IsSpellInRange(bloodstrike, "target") == 1 then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------
	["Mind Freeze (Interrupt)"] = function()
		if ni.spell.shouldinterrupt("target")
		 and ni.spell.isinstant(47528)
		 and ni.spell.available(47528)
		 and GetTime() - ni.data.darhanger_leveling.LastInterrupt > 9
		 and ni.spell.valid("target", 47528, true, true)  then
			ni.spell.castinterrupt("target")
			ni.data.darhanger_leveling.LastInterrupt = GetTime()
			return true
		end
	end,
-----------------------------------
	["Icebound Fort"] = function()
		if ni.player.hp() < 45
		 and ni.spell.isinstant(48792)
		 and ni.spell.available(48792) then
			ni.spell.cast(48792)
			return true
		end
	end,
-----------------------------------
	["Death and Decay"] = function()
		if ni.vars.combat.aoe
		 and ni.spell.isinstant(deathanddecay)
		 and ni.spell.cd(deathanddecay) == 0 then
			ni.spell.castatqueue(deathanddecay, "target")
			return true
		end
	end,
-----------------------------------
	["Unbreakable Armor"] = function()
		local _, BR = ni.rune.frostrunecd()
		local _, DR = ni.rune.deathrunecd()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.isinstant(51271)
		 and ni.spell.available(51271)
		 and ni.spell.valid("target", bloodstrike, true, true) then
			if BR == 0 and DR == 0
			and ni.spell.cd(45529) == 0 then
				ni.spell.cast(45529)
				ni.spell.cast(51271)
			return true
		else
				ni.spell.cast(51271)
			return true
			end
		end
	end,
-----------------------------------
	["Raise Dead"] = function()
		if not UnitExists("playerpet")
		 and not ni.player.buff(61431)
		 and ni.spell.available(46584)
		 and ni.spell.isinstant(46584)
		 and not ni.spell.available(51271)
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsUsableSpell(46584)
		 and ( ni.player.hasitem(37201) 
		 or	ni.player.hasglyph(60200) ) then
			ni.spell.cast(46584)
			return true
		end
	end,
-----------------------------------
	["Empower Rune Weapon"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.rune.available() == 0
		 and ni.spell.isinstant(47568)
		 and ni.spell.available(47568) then
			ni.spell.cast(47568)
			return true
		end
	end,
	-----------------------------------
	["Death Strike"] = function()
		local _, FR = ni.rune.frostrunecd()
		local _, UR = ni.rune.unholyrunecd()
		local _, DR = ni.rune.deathrunecd()
		local icy = ni.data.darhanger_leveling.dk.icy()
		local plague = ni.data.darhanger_leveling.dk.plague()
		if not (ni.data.darhanger_leveling.youInInstance()
		 or not ni.data.darhanger_leveling.youInRaid() )
		 and ni.player.hp() < 50
		 and ((FR >= 1 and UR >= 1)
		 or (FR >= 1 and DR >= 1)
		 or (DR >= 1 and UR >= 1)
		 or (DR == 2))
		 and plague
		 and icy
	         and ni.spell.isinstant(deathstrike)
		 and ni.spell.available(deathstrike)
		 and ni.spell.valid("target", deathstrike, true, true) then
			ni.spell.cast(deathstrike, "target")
			return true
		end
	end,
-----------------------------------
	["Icy Touch"] = function()
		local icy = ni.data.darhanger_leveling.dk.icy()
		if ( icy == nil or ( icy - GetTime() <= 2 ) )
		 and ni.spell.available(icytouch)
		 and ni.spell.isinstant(icytouch)
		 and ni.spell.valid("target", icytouch, true, true) then
			ni.spell.cast(icytouch, "target")
			return true
		end
	end,
-----------------------------------	
	["Plague Strike"] = function()
		local plague = ni.data.darhanger_leveling.dk.plague()
		if ( plague == nil or ( plague - GetTime() <= 2 ) )
	     and ni.spell.available(plaguestrike)
		 and ni.spell.isinstant(plaguestrike)
		 and ni.spell.valid("target", plaguestrike, true, true) then
			ni.spell.cast(plaguestrike, "target")
			return true
		end
	end,
-----------------------------------
	["Pestilence (AoE)"] = function()
		local icy = ni.data.darhanger_leveling.dk.icy()
		local plague = ni.data.darhanger_leveling.dk.plague()
		local enemies = ni.unit.enemiesinrange("target", 7)
		local _, BR = ni.rune.bloodrunecd()
		local _, DR = ni.rune.deathrunecd()
		if #enemies >= 1 then
		 if ( BR >= 1 or DR >= 1 )
		 and icy
		 and plague
		 and UnitExists("target")
		 and UnitCanAttack("player", "target")
		 and ni.spell.isinstant(pestilence)
		 and ni.spell.valid("target", pestilence, true, true) then
		  for i = 1, #enemies do
		   if ni.unit.creaturetype(enemies[i].guid) ~= 8
		    and ni.unit.creaturetype(enemies[i].guid) ~= 11
		    and (not ni.unit.debuff(enemies[i].guid, 55078, "player")
		    or not ni.unit.debuff(enemies[i].guid, 55095, "player")) then
				ni.spell.cast(pestilence)
						return true
					end
				end
			end
		end
	end,
-----------------------------------
	["Pestilence (Renew)"] = function()
		local icy = ni.data.darhanger_leveling.dk.icy()
		local plague = ni.data.darhanger_leveling.dk.plague()
		local _, BR = ni.rune.bloodrunecd()
		local _, DR = ni.rune.deathrunecd()
		if ( BR >= 1 or DR >= 1 )
		 and ni.player.hasglyph(63334)
		 and ni.spell.valid("target", pestilence, true, true)
		 and ( ( icy ~= nil and icy - GetTime() <= 5 )
		 or ( plague ~= nil and plague - GetTime() <= 5 ) ) then 
			ni.spell.cast(pestilence)
			return true
		end
	end,
-----------------------------------
	["Howling Blast"] = function()
		if ni.player.buff(59052)
		 and ni.player.power() < 90		
		 and ni.spell.available(howlingblast)
		 and ni.spell.isinstant(howlingblast)
		 and ni.spell.valid("target", howlingblast, true, true) then
			ni.spell.cast(howlingblast, "target")
			return true
		end
	end,
-----------------------------------
	["Howling Blast (AoE)"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if ni.player.buff(51124)
		 and #enemies >= 2
		 and ni.player.power() < 90
		 and ni.spell.available(howlingblast)
		 and ni.spell.isinstant(howlingblast)
		 and ni.spell.valid("target", howlingblast, true, true) then
			ni.spell.cast(howlingblast, "target")
			return true
		end
	end,
-----------------------------------
	["Obliterate Dump"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		local _, FR = ni.rune.frostrunecd()
		local _, UR = ni.rune.unholyrunecd()
		local _, DR = ni.rune.deathrunecd()
		local icy = ni.data.darhanger_leveling.dk.icy()
		local plague = ni.data.darhanger_leveling.dk.plague()
		if #enemies >= 2
		 and ((FR >= 1 and UR >= 1)
		 or (FR >= 1 and DR >= 1)
		 or (DR >= 1 and UR >= 1)
		 or (DR == 2))			 
		 and plague
		 and icy
		 and ni.player.power() < 90
		 and not ni.player.buff(51124)
		 and ni.spell.isinstant(obliterate)
		 and ni.spell.available(obliterate)
		 and ni.spell.valid("target", obliterate, true, true) then
			ni.spell.cast(obliterate, "target")
			return true
		end
	end,
-----------------------------------
	["Obliterate"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		local _, FR = ni.rune.frostrunecd()
		local _, UR = ni.rune.unholyrunecd()
		local _, DR = ni.rune.deathrunecd()
		local icy = ni.data.darhanger_leveling.dk.icy()
		local plague = ni.data.darhanger_leveling.dk.plague()
		if ( #enemies < 1 or #enemies == 1 )
		 and ((FR >= 1 and UR >= 1)
		 or (FR >= 1 and DR >= 1)
		 or (DR >= 1 and UR >= 1)
		 or (DR == 2))			 
		 and plague
		 and icy
		 and ni.player.power() < 90
		 and ni.spell.isinstant(obliterate)
		 and ni.spell.available(obliterate)
		 and ni.spell.valid("target", obliterate, true, true) then
			ni.spell.cast(obliterate, "target")
			return true
		end
	end,
-----------------------------------
	["Rune Strike"] = function()
		if IsUsableSpell(runestrike)
		 and ni.spell.available(runestrike, true)
		 and not IsCurrentSpell(runestrike)
		 and ni.spell.valid("target", runestrike, true, true) then
			ni.spell.cast(runestrike, "target")
			return true
		end
	end,
-----------------------------------
	["Frost Strike (Kill)"] = function()
		local icy = ni.data.darhanger_leveling.dk.icy()
		local plague = ni.data.darhanger_leveling.dk.plague()
		if ni.player.buff(51124)
		and plague
		and icy
		and ni.spell.isinstant(froststrike)
		and ni.spell.available(froststrike)
		and ni.spell.valid("target", froststrike, true, true) then
			ni.spell.cast(froststrike, "target")
			return true
		end
	end,
-----------------------------------
	["Frost Strike"] = function()
		local icy = ni.data.darhanger_leveling.dk.icy()
		local plague = ni.data.darhanger_leveling.dk.plague()
		if ni.player.power() > 96
		and plague
		and icy
		and ni.spell.isinstant(froststrike)
		and ni.spell.available(froststrike)
		and ni.spell.valid("target", froststrike, true, true) then
			ni.spell.cast(froststrike, "target")
			return true
		end
	end,
-----------------------------------
	["Frost Strike 2"] = function()
		local icy = ni.data.darhanger_leveling.dk.icy()
		local plague = ni.data.darhanger_leveling.dk.plague()
		if ni.player.power() >= 32
		and plague
		and icy
		and ni.spell.isinstant(froststrike)
		and ni.spell.available(froststrike)
		and ni.spell.valid("target", froststrike, true, true) then
			ni.spell.cast(froststrike, "target")
			return true
		end
	end,
-----------------------------------
	["Blood Strike"] = function()
		local _, BR = ni.rune.bloodrunecd()
		local icy = ni.data.darhanger_leveling.dk.icy()
		local plague = ni.data.darhanger_leveling.dk.plague()
		if BR >= 1
		 and plague
		 and icy
		 and ni.player.power() < 95
		 and ni.spell.isinstant(bloodstrike)
		 and ni.spell.available(bloodstrike)
		 and ni.spell.valid("target", bloodstrike, true, true) then
			ni.spell.cast(bloodstrike, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Frost DW DPS Deathknight by darhanger  for 3.3.5a -- Modified by Xcesius for leveling", 
		 "Welcome to Frost Dual Wield DPS Deathknight Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For use Death and Decay configure AoE Toggle key.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("Frost2W_darhanger_leveling", queue, abilities);