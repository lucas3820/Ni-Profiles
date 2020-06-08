local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"AutoTarget",
	"Gift of the Wild",
	"Thorns",
	"Bear Form",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Potions (Use)",
	"Racial Stuff",
	"Barkskin",
	"Frenzied Regeneration",
	"Survival Instincts",
	"Growl",
	"Growl (Ally)",
	"Faerie Fire",
	"Enrage",
	"Demoralizing Roar",
	"Mangle (Bear)",
	"Swipe (Bear)",
	"Maul",
	"Lacerate",
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
	["Bear Form"] = function()
		if not ni.player.buff(9634)
		 and ni.spell.available(9634) then
			ni.spell.cast(9634)
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
		 and IsSpellInRange(GetSpellInfo(49800), "target") == 1 then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if IsSpellInRange(GetSpellInfo(49800), "target") == 1
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
	["Survival Instincts"] = function()
		if ni.player.hp() < 30
		 and ni.spell.isinstant(61336)
		 and ni.spell.available(61336) then
			ni.spell.cast(61336)
			return true
		end
	end,
-----------------------------------
	["Frenzied Regeneration"] = function()
		if ni.player.buff(61336)
		 and ni.spell.isinstant(22842)
		 and ni.spell.available(22842) then
			ni.spell.cast(22842)
			return true
		end
	end,
-----------------------------------
	["Enrage"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.power() < 65
		 and ni.spell.isinstant(5229)
		 and ni.spell.available(5229)
		 and IsSpellInRange(GetSpellInfo(48564), "target") == 1 then
			ni.spell.cast(5229)
			return true
		end
	end,
-----------------------------------
	["Growl"] = function()
		if UnitExists("targettarget") 
		 and not UnitIsDeadOrGhost("targettarget")
		 and UnitAffectingCombat("player")
		 and (ni.unit.debuff("targettarget", 72410) 
		 or ni.unit.debuff("targettarget", 72411) 
		 or ni.unit.threat("player", "target") < 2 )
		 and ni.spell.available(6795)
		 and ni.spell.isinstant(6795)
		 and ni.data.darhanger.youInInstance()
		 and ni.spell.valid("target", 6795, false, true, true) then
			ni.spell.cast(6795)
			return true
		end
	end,
-----------------------------------
	["Growl (Ally)"] = function()
		local enemies = ni.unit.enemiesinrange("target", 30)
		for i = 1, #enemies do
		local threatUnit = enemies[i].guid
   		 if ni.unit.threat("player", threatUnit) ~= nil 
   		  and ni.unit.threat("player", threatUnit) <= 2
   		  and UnitAffectingCombat(threatUnit) 
		  and ni.spell.available(6795)
		  and ni.spell.isinstant(6795)
		  and ni.data.darhanger.youInInstance()
   		  and ni.spell.valid(threatUnit, 6795, false, true, true) then
			ni.spell.cast(6795, threatUnit)
			return true
			end
		end
	end,
-----------------------------------
	["Faerie Fire"] = function()
		local mFaerieFire = ni.data.darhanger.druid.mFaerieFire() 
		local fFaerieFire = ni.data.darhanger.druid.fFaerieFire() 
		if not fFaerieFire
		 and not mFaerieFire
		 and ni.spell.isinstant(16857)
		 and ni.spell.available(16857) then
			ni.spell.cast(16857, "target")
			return true
		end
	end,
-----------------------------------
	["Swipe (Bear)"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if ni.spell.available(48562)
		 and #enemies >= 1
		 and IsSpellInRange(GetSpellInfo(48564), "target") == 1 then
			if ni.spell.available(48480, true)
			 and not IsCurrentSpell(48480) then 
				ni.spell.cast(48480, "target")
		end
				ni.spell.cast(48562, "target")
			return true;
		end
	end,

-----------------------------------
	["Mangle (Bear)"] = function()
		if ni.spell.available(48564)
		 and ni.spell.isinstant(48564)
		 and ni.spell.valid("target", 48564, true, true) then
			ni.spell.cast(48564, "target")
			return true
		end
	end,		
-----------------------------------
	["Lacerate"] = function()
		local lacerate, _, _, count = ni.unit.debuff("target", 48568, "player")
		local bmangle = ni.data.darhanger.druid.bmangle()  
		if (lacerate == nil
		 or count < 5 or ni.unit.debuffremaining("target", 48568, "player") < 3)
		 and bmangle
		 and ni.spell.isinstant(48568)
		 and ni.spell.available(48568)
		 and ni.spell.valid("target", 48568, true, true) then 
			ni.spell.cast(48568, "target")
			return true
		end
	end,
-----------------------------------
	["Demoralizing Roar"] = function()
		local enemies;
		if UnitExists("target")
		 and UnitCanAttack("player", "target") then
			enemies = ni.unit.enemiesinrange("target", 8)
			for i = 1, # enemies do
				local tar = enemies[i].guid;
				if ni.unit.creaturetype(enemies[i].guid) ~= 8 
				 and not ni.unit.debuff(tar, 48560)
				 and GetTime() - ni.data.darhanger.druid.LastShout > 4
				 and ni.spell.available(48560) then
					ni.spell.cast(48560, tar)
					ni.data.darhanger.druid.LastShout = GetTime()
					return true
				end
			end
		end
	end,
-----------------------------------
	["Maul"] = function()
		if ni.spell.available(48480, true)
		 and not IsCurrentSpell(48480)
		 and IsSpellInRange(GetSpellInfo(48564), "target") == 1 then
			ni.spell.cast(48480, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Feral Bear Druid by DarhangeR for 3.3.5a", 
		 "Welcome to Feral Bear Druid Profile! Support and more in Discord > https://discord.gg/u4mtjws.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Feral_Bear_DarhangeR", queue, abilities, data) 