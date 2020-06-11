local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"AutoTarget",
	"Battle Stance",
	"Battle Shout",
	"Enraged Regeneration",
	"Berserker Rage",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Bloodrage",
	"Bladestorm",
	"Victory Rush",
	"Shattering Throw",
	"Execute",
	"Heroic Strike + Cleave (Filler)",
	"Overpower",
	"Sweeping Strikes",
	"Thunder Clap",
	"Hamstring",
	"Rend",
	"Mortal Strike",
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
	["Battle Stance"] = function()
		local BS = GetShapeshiftForm()
		if BS ~= 1 then 
			ni.spell.cast(2457)
			return true
		end
	end,
-----------------------------------
	["Battle Shout"] = function()
		if ni.player.buffs("47436||48932||48934") then 
		 return false
	end
		if ni.spell.available(47436)
		 and ni.spell.isinstant(47436) then
			ni.spell.cast(47436)	
			return true
		end
	end,		 
-----------------------------------
	["Enraged Regeneration"] = function()
		local enrage = { 18499, 12292, 29131, 14204, 57522 }
		for i = 1, #enrage do
		 if ni.player.buff(enrage[i])
		 and ni.player.hp() < 25
		 and ni.spell.isinstant(55694) 		 
		 and ni.spell.available(55694) then 
			ni.spell.cast(55694)
		else
		 if not ni.player.buff(enrage[i])
		 and ni.spell.cd(2687) == 0
		 and ni.spell.isinstant(2687) 
		 and ni.spell.isinstant(55694) 
		 and ni.spell.available(55694)
		 and ni.player.hp() < 25 then
		      ni.spell.castspells("2687|55694")
				return true
				end
			end
		end
	end,		 
-----------------------------------
	["Berserker Rage"] = function()
		local bad = { 6215, 8122, 5484, 2637, 5246, 6358 }
		for i = 1, #bad do
		 if ni.player.debuff(bad[i])
		  and ni.spell.isinstant(18499) 
	          and ni.spell.available(18499) then
		      ni.spell.cast(18499)
		      return true
			end
		end
	end,	 
-----------------------------------
	["Combat specific Pause"] = function()
		local buff = { 33786, 21892, 40733, 69051 }
		local debuffs = nil
		for i,v in ipairs(buff) do
		  if ni.unit.buff("target",v) then debuffs = 1 end
		end
		if debuffs
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
	["Potions (Use)"] = function()
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
		 and ni.spell.valid("target", 48125, true, true) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 48125, true, true)
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
		 and IsSpellInRange(GetSpellInfo(47465), "target") == 1 then
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
		 and IsSpellInRange(GetSpellInfo(47465), "target") == 1 then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.data.darhanger.CDsaverTTD()
		 and IsSpellInRange(GetSpellInfo(47465), "target") == 1 then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------	
	["Bloodrage"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.power() < 65
		 and ni.player.hasglyph(58096)
		 and ni.spell.isinstant(2687) 
		 and ni.spell.available(2687)
		 and ni.spell.valid("target", 47465, true, true) then
			ni.spell.cast(2687)
			return true
		end
	end,
-----------------------------------
	["Bladestorm"] = function()
		local rend = ni.data.darhanger.warrior.rend()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and rend
		 and not ni.player.buff(65156)
		 and ni.spell.available(46924)
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 47465, true, true) then
			ni.spell.cast(46924)
			return true
		end
	end,
-----------------------------------
	["Victory Rush"] = function()
		if IsUsableSpell(GetSpellInfo(34428))
		 and ni.spell.isinstant(34428) 
		 and ni.spell.valid("target", 34428, true, true) then
			ni.spell.cast(34428, "target")
			return true
		end
	end,
-----------------------------------
	["Shattering Throw"] = function()
		local buff = { 642, 1022, 45438 }
		for i,v in ipairs(buff) do
		 local _,_,_,_,_,_,_,_,isRemovable = ni.unit.buff("target",v)
		 if isRemovable
		 and not ni.player.ismoving()
		 and ni.spell.available(64382) then
			ni.spell.cast(64382, "target")
			return true
			end
		end
	end,
-----------------------------------
	["Execute"] = function()
		if ni.player.power() > 30
		 and (ni.unit.hp("target") <= 20
		 or IsUsableSpell(GetSpellInfo(47471)))
		 and ni.spell.cd(47486) ~= 0
		 and ni.spell.isinstant(47471) 
		 and ni.spell.valid("target", 47471, true, true) then
			ni.spell.cast(47471)
			return true
		end
	end,
-----------------------------------
	["Sweeping Strikes"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if #enemies >= 1
		 and ni.spell.available(12328)
		 and ni.spell.valid("target", 47465, true, true) then
			ni.spell.cast(12328)
			return true
		end
	end,
-----------------------------------
	["Thunder Clap"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if #enemies >= 1
		 and ni.spell.available(47502, true)
		 and ni.spell.valid("target", 47465, true, true) then
			ni.spell.cast(47502)
			return true
		end
	end,
-----------------------------------
	["Hamstring"] = function()
		local hams = ni.data.darhanger.warrior.hams()
		if ni.unit.isplayer("target")
		 and (hams == nil or (hams - GetTime() <= 2))
		 and not ni.unit.isboss("target")
		 and ni.spell.isinstant(1715) 
		 and ni.spell.available(1715, true)
		 and ni.spell.valid("target", 1715, true, true) then
			ni.spell.cast(1715, "target")
			return true
		end
	end,
-----------------------------------
	["Rend"] = function()
		local rend = ni.data.darhanger.warrior.rend()
		if (rend == nil or (rend - GetTime() <= 2))
		 and ni.spell.isinstant(47465) 
		 and ni.spell.available(47465, true)
		 and ni.spell.valid("target", 47465, true, true) then
			ni.spell.cast(47465)
			return true
		end
	end,
-----------------------------------
	["Overpower"] = function()
		if IsUsableSpell(GetSpellInfo(7384))
		 and ni.spell.isinstant(7384) 
		 and ni.spell.available(7384, true)
		 and ni.spell.valid("target", 7384, true, true) then
			ni.spell.cast(7384, "target")
			return true
		end
	end,
-----------------------------------
	["Mortal Strike"] = function()
		if ni.spell.available(47486, true)
		 and ni.spell.isinstant(47486) 
		 and ni.spell.valid("target", 47486, true, true) then
			ni.spell.cast(47486)
			return true
		end
	end,
-----------------------------------
	["Heroic Strike + Cleave (Filler)"] = function()
		local enemies = ni.unit.enemiesinrange("target", 5)
		if IsSpellInRange(GetSpellInfo(47475), "target") == 1
		 and ni.spell.cd(47486) ~= 0 
		 and ni.player.power() > 35 then
			if #enemies >= 1	
			 and ni.spell.available(47520, true) 
			 and not IsCurrentSpell(47520) then
				ni.spell.cast(47520, "target")
			return true
		else
			if #enemies == 0
			 and ni.spell.available(47450, true)
			 and not IsCurrentSpell(47450) then
				ni.spell.cast(47450, "target")
			return true
				end
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Arms Warrior by DarhangeR for 3.3.5a", 
		 "Welcome to Arms Warrior Profile! Support and more in Discord > https://discord.gg/u4mtjws.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Arms_DarhangeR", queue, abilities, data)