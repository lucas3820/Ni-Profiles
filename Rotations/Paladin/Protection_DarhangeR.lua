local data = {"DarhangeR.lua"}

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
	"Avenging Wrath",
	"Holy Wrath",
	"Consecration",
	"Avenger's Shield",
	"Judgements (PRO)",
	"Holy Shield",	
	"Hammer of the Righteous",
	"Hand of Freedom (Player)",
	"Cleanse (Player)",
	"Shield of Righteousness",
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
	["Seal of Corruption/Vengeance"] = function()
		local enemies = ni.unit.enemiesinrange("target", 5)
		if #enemies < 1
		 and IsSpellKnown(53736)
		 and ni.spell.available(53736) then
		 if not ni.player.buff(53736)
		 and GetTime() - ni.data.darhanger.paladin.LastSeal > 3
		 and not ni.player.buff(31801) then
			ni.spell.cast(53736)
			ni.data.darhanger.paladin.LastSeal = GetTime()
			return true
		end
	end
		if #enemies < 1
		and IsSpellKnown(31801)
		and ni.spell.available(31801) then
		if not ni.player.buff(31801) 
		 and GetTime() - ni.data.darhanger.paladin.LastSeal > 3
		 and not ni.player.buff(53736) then
			ni.spell.cast(31801)
			ni.data.darhanger.paladin.LastSeal = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Seal of Command"] = function()
		local enemies = ni.unit.enemiesinrange("target", 5)
		if #enemies > 1	
		 and IsSpellKnown(20375)
		 and ni.spell.available(20375)
		 and GetTime() - ni.data.darhanger.paladin.LastSeal > 3
		 and not ni.player.buff(20375) then 
			ni.spell.cast(20375)
			ni.data.darhanger.paladin.LastSeal = GetTime()
			return true
		end
	end,
-----------------------------------
	["Righteous Fury"] = function()
		if not ni.player.buff(25780)
		 and ni.spell.available(25780) then 		
			ni.spell.cast(25780)
			return true
		end
	end,
-----------------------------------
	["Sacred Shield"] = function()
		if not ni.player.buff(53601)  
		 and ni.spell.available(53601) then
			ni.spell.cast(53601, "player")
			return true
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if ni.data.darhanger.tankStop()
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
		 and ni.spell.valid("target", 53595, true, true) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 53595, true, true)
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
		local forb = ni.data.darhanger.paladin.forb()
		if ni.player.hp() < 20
		 and not forb
		 and ni.spell.isinstant(48788)
		 and ni.spell.available(48788) then
			ni.spell.cast(48788)
			return true
		end
	end,
-----------------------------------
	["Divine Protection"] = function()
		local forb = ni.data.darhanger.paladin.forb()
		if ni.player.hp() < 35
		 and not forb
		 and ni.spell.isinstant(498)
		 and ni.spell.available(498) then
			ni.spell.cast(498)
			return true
		end
	end,
-----------------------------------
	["Divine Sacrifice"] = function()
		if ni.player.hp() > 30
		 and ni.healing.averagehp(6) < 45
		 and ni.spell.isinstant(64205)
		 and ni.spell.available(64205) then
			ni.spell.cast(64205)
			return true
		end
	end,
-----------------------------------
	["Divine Plea"] = function()
		if not ni.player.buff(54428) 
		 and ni.spell.isinstant(54428)
		 and ni.spell.available(54428) then
			ni.spell.cast(54428)
			return true
		end
	end,
-----------------------------------
	["Hand of Reckoning"] = function()
		if UnitExists("targettarget") 
		 and not UnitIsDeadOrGhost("targettarget")
		 and UnitAffectingCombat("player")
		 and (ni.unit.debuff("targettarget", 72410) 
		 or ni.unit.debuff("targettarget", 72411) 
		 or ni.unit.threat("player", "target") < 2 )
  		 and ni.spell.available(62124)
		 and ni.spell.isinstant(62124)
		 and ni.data.darhanger.youInInstance()
		 and ni.spell.valid("target", 62124, false, true, true) then
			ni.spell.cast(62124)
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
   		  and not ni.spell.available(49576)
  		  and ni.spell.available(62124)
		  and ni.spell.isinstant(62124)
		  and ni.data.darhanger.youInInstance()
   		  and ni.spell.valid(threatUnit, 62124, false, true, true) then
			ni.spell.cast(62124, threatUnit)
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
		  if tarCount ~= nil and tarCount >= 1
		   and ni.spell.available(31789)
		   and ni.spell.isinstant(31789)
		   and not ni.members[i].istank
		   and ni.unit.threat(ni.members[i].guid) >= 2
		   and ni.spell.valid(ni.members[i].unit, 31789, false, true, true) then
				ni.spell.cast(31789, ni.members[i].unit)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Avenging Wrath"] = function()
		if ( ni.vars.CD or ni.unit.isboss("target") )
		 and ni.spell.isinstant(31884) 
		 and ni.spell.available(31884)
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 35395) then
			ni.spell.cast(31884)
			return true
		end
	end,
-----------------------------------
	["Holy Wrath"] = function()
		if ni.vars.combat.aoe
		 and ni.spell.available(48817)
		 and ni.spell.isinstant(48817)
		 and ni.spell.valid("target", 53595) then
			ni.spell.cast(48817, "target")
			return true
		end
	end,
-----------------------------------
	["Consecration"] = function()
		if ni.player.power() > 30
		 and ni.spell.available(48819)
		 and ni.spell.isinstant(48819)
		 and ni.spell.valid("target", 53595) then
			ni.spell.cast(48819, "target")
			return true
		end
	end,
-----------------------------------
	["Avenger's Shield"] = function()
		local enemies = ni.unit.enemiesinrange("target", 5)
		if #enemies > 1
		 and ni.spell.isinstant(48827)
		 and ni.spell.available(48827)
		 and ni.spell.valid("target", 48827) then
			ni.spell.cast(48827, "target")
			return true
		end
	end,
-----------------------------------
	["Judgements (PRO)"] = function()
		if ni.spell.available(20271)
		 and ni.spell.isinstant(20271)		
		 and ni.spell.valid("target", 20271, false, true, true) then
			if ni.player.power() < 30
			and ni.player.hp() >= 70 then
				ni.spell.cast(53408, "target")
			else
				ni.spell.cast(20271, "target")
				return true
			end
		end
	end,
-----------------------------------
	["Holy Shield"] = function()
		if not ni.player.buff(48952)
		 and ni.spell.isinstant(48952)
		 and ni.spell.available(48952)
		 and ni.spell.valid("target", 53595) then
			ni.spell.cast(48952, "target")
			return true
		end
	end,
-----------------------------------
	["Hammer of the Righteous"] = function()
		if ni.spell.available(53595)
		 and ni.spell.isinstant(53595)
		 and ni.spell.valid("target", 53595, true, true) then
			ni.spell.cast(53595, "target")
			return true
		end
	end,
-----------------------------------	
	["Hand of Freedom (Player)"] = function()
		local debuff = { 45524, 1715, 3408, 59638, 20164, 25809, 31589, 51585, 50040, 50041, 31124, 122, 44614, 1604, 339, 45334, 58179, 61391, 19306, 19185, 35101, 5116, 2974, 61394, 54644, 50245, 50271, 54706, 4167, 33395, 55080, 11113, 6136, 120, 116, 44614, 31589, 20170, 31125, 3409, 26679, 64695, 63685, 8056, 8034, 18118, 18223, 63311, 23694, 1715, 12323, 39965, 55536, 13099, 29703, 32859, 32065 };
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
		 and GetTime() - ni.data.darhanger.LastDispel > 2
		 and ni.healing.candispel("player")
		 and ni.spell.valid("player", 4987, false, true, true) then
			ni.spell.cast(4987, "player")
			ni.data.darhanger.LastDispel = GetTime()
			return true
		end
	end,
-----------------------------------
	["Shield of Righteousness"] = function()
		if ni.spell.available(61411)
		 and ni.spell.isinstant(61411)
		 and ni.spell.valid("target", 61411, true, true) then
			ni.spell.cast(61411, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Protection Paladin by DarhangeR for 3.3.5a", 
		 "Welcome to Protection Paladin Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For use Holy Wrath configure AoE Toggle key.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Protection_DarhangeR", queue, abilities, data)