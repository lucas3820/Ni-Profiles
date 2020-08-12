local data = {"darhanger_leveling.lua"}
--Ability Convert
local giftofthewild = GetSpellInfo(48470)
local thorns = GetSpellInfo(53307)
local faeriefiredr = GetSpellInfo(16857)
local direbearform = GetSpellInfo(9634)
local bearform = GetSpellInfo(5487)
local swipebear = GetSpellInfo(48562)
local maul = GetSpellInfo(48480)
local manglebear = GetSpellInfo(48564)
local lacerate = GetSpellInfo(48568)
local demoroar = GetSpellInfo(48560)
local rip = GetSpellInfo(49800)

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"AutoTarget",
	"Gift of the Wild",
--	"Thorns",
	"Bear Form",
	"Dire Bear Form",
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
		if not ni.player.buff(thorns)
		 and ni.spell.available(thorns)
		 and ni.spell.isinstant(thorns)
		 and UnitAffectingCombat("player") == nil then
			ni.spell.cast(thorns)
			return true
		end
	end,
-----------------------------------
	["Bear Form"] = function()
		if not ni.spell.available(9634)
		 not not ni.player.buff(5487)
		 and ni.spell.available(5487) then
			ni.spell.cast(5487)
			return true
		end
	end,
-----------------------------------
	["Dire Bear Form"] = function()
		if not ni.player.buff(9634)
		 and ni.spell.available(9634) then
			ni.spell.cast(9634)
			return true
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if ni.data.darhanger_leveling.tankStop()
		or ni.data.darhanger_leveling.PlayerDebuffs()
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
		 and IsSpellInRange(rip, "target") == 1 then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if IsSpellInRange(rip, "target") == 1
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
		 and ni.data.darhanger_leveling.youInInstance()
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
		  and ni.data.darhanger_leveling.youInInstance()
   		  and ni.spell.valid(threatUnit, 6795, false, true, true) then
			ni.spell.cast(6795, threatUnit)
			return true
			end
		end
	end,
-----------------------------------
	["Faerie Fire"] = function()
		local mFaerieFire = ni.data.darhanger_leveling.druid.mFaerieFire() 
		local fFaerieFire = ni.data.darhanger_leveling.druid.fFaerieFire() 
		if not fFaerieFire
		 and not mFaerieFire
		 and ni.spell.isinstant(faeriefiredr)
		 and ni.spell.available(faeriefiredr) then
			ni.spell.cast(faeriefiredr, "target")
			return true
		end
	end,
-----------------------------------
	["Swipe (Bear)"] = function()
		local enemies = ni.unit.enemiesinrange("player", 7)
		if ni.spell.available(swipebear)
		 and #enemies > 1
		 and IsSpellInRange(manglebear, "target") == 1 then
			if ni.spell.available(maul, true)
			 and not IsCurrentSpell(maul) then 
				ni.spell.cast(maul, "target")
		end
				ni.spell.cast(swipebear, "target")
			return true;
		end
	end,

-----------------------------------
	["Mangle (Bear)"] = function()
		if ni.spell.available(manglebear)
		 and ni.spell.isinstant(manglebear)
		 and ni.spell.valid("target", manglebear, true, true) then
			ni.spell.cast(manglebear, "target")
			return true
		end
	end,		
-----------------------------------
	["Lacerate"] = function()
		local lacerate, _, _, count = ni.unit.debuff("target", lacerate, "player")
		local bmangle = ni.data.darhanger_leveling.druid.bmangle()  
		if (lacerate == nil
		 or count < 5 or ni.unit.debuffremaining("target", lacerate, "player") < 3)
		 and bmangle
		 and ni.spell.isinstant(lacerate)
		 and ni.spell.available(lacerate)
		 and ni.spell.valid("target", lacerate, true, true) then 
			ni.spell.cast(lacerate, "target")
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
				 and not ni.unit.debuff(tar, demoroar)
				 and GetTime() - ni.data.darhanger_leveling.druid.LastShout > 4
				 and ni.spell.available(demoroar) then
					ni.spell.cast(demoroar, tar)
					ni.data.darhanger_leveling.druid.LastShout = GetTime()
					return true
				end
			end
		end
	end,
-----------------------------------
	["Maul"] = function()
		if ni.spell.available(maul, true)
		 and not IsCurrentSpell(maul)
		 and IsSpellInRange(manglebear, "target") == 1 then
			ni.spell.cast(maul, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Feral Bear Druid by darhanger for 3.3.5a -- Modified by Xcesius for leveling", 
		 "Welcome to Feral Bear Druid Profile! Support and more in Discord > https://discord.gg/u4mtjws.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Feral_Bear_darhanger_leveling", queue, abilities, data) 