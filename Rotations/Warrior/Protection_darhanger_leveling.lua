local data = ni.utils.require("darhanger_leveling.lua");

--Convert Abilities
local commandingshout = GetSpellInfo(47440)
local berserkerrage = GetSpellInfo(18499)
local enragebuff = GetSpellInfo(57522)
local fear = GetSpellInfo(6215)
local psychicscream = GetSpellInfo(8122)
local howlofterror = GetSpellInfo(5484)
local hibernate = GetSpellInfo(2637)
local intimidatingshout = GetSpellInfo(5246)
local seduction = GetSpellInfo(6358)
local rend = GetSpellInfo(47465)
local thunderclap = GetSpellInfo(47502)
local slam = GetSpellInfo(47475)
local cleave = GetSpellInfo(47520)
local heroicstrike = GetSpellInfo(47450)
local bloodpact = GetSpellInfo(6307)
local revenge = GetSpellInfo(57823)
local devastate = GetSpellInfo(47498)
local shieldslam = GetSpellInfo(47488)
local demoshout = GetSpellInfo(47437)


local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"AutoTarget",
	"Defensive Stance",
	"Commanding Shout",
	"Vigilance",
	"Berserker Rage",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Potions (Use)",
	"Racial Stuff",
	"Shield Bash (Interrupt)",
	"Last Stand",
	"Enraged Regeneration",
	"Shield Wall",
	"Low level Heroic Strike",
	"Taunt",
	"Taunt (Ally)",
	"Mocking Blow",
	"Demoralizing Shout",
	"Heroic Strike + Cleave (Filler)",
	"Revenge",
	"Rend",
	"Shield Block",
	"Shield Slam",
	"Thunder Clap",
	"Devastate",
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
	["Defensive Stance"] = function()
		local DS = GetShapeshiftForm()
		if DS ~= 2 and ni.spell.available(71) then 
			ni.spell.cast(71)
			return true
		end
	end,
-----------------------------------
	["Commanding Shout"] = function()
		if ni.player.buffs("commandingshout||bloodpact", "EXACT") then 
		 return false
	end
		if ni.spell.available(commandingshout) 
		 and ni.spell.isinstant(commandingshout) then
			ni.spell.cast(commandingshout)	
			return true
		end
	end,
-----------------------------------
	["Vigilance"] = function()
		if UnitExists("focus")
		 and UnitInRange("focus")
		 and not UnitIsDeadOrGhost("focus")
		 and not ni.unit.buff("focus", 50720) 
		 and ni.spell.valid("focus", 50720, false, true, true) then
			ni.spell.cast(50720, "focus")
			return true
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
		if ni.data.darhanger_leveling.tankStop()
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
	["Shield Bash (Interrupt)"] = function()
		if ni.spell.shouldinterrupt("target")
		 and ni.spell.isinstant(72) 
		 and ni.spell.available(72)
		 and GetTime() - ni.data.darhanger_leveling.LastInterrupt > 9
		 and ni.spell.valid("target", 72)  then
			ni.spell.castinterrupt("target")
			ni.data.darhanger_leveling.LastInterrupt  = GetTime()
			return true
		end
	end,
-----------------------------------
	["Last Stand"] = function()
		if ni.player.hp() < 25
		 and ni.spell.isinstant(12975) 
		 and ni.spell.available(12975) then
			ni.spell.cast(12975)
			return true
		end
	end,		 
-----------------------------------
	["Enraged Regeneration"] = function()
		local enrage = { 18499, 12292, 29131, 14204, 57522 }
		for i = 1, #enrage do
		 if ni.player.buff(enrage[i])
		 and ni.player.buff(12975)
		 and ni.spell.isinstant(55694) 
		 and ni.spell.available(55694) then 
			ni.spell.cast(55694)
		else
		 if not ni.player.buff(enrage[i])
		 and ni.spell.cd(2687) == 0
		 and ni.spell.isinstant(2687) 
		 and ni.spell.isinstant(55694) 
		 and ni.spell.available(55694) 
		 and ni.player.buff(12975) then
		      ni.spell.castspells("2687|55694")
				return true
				end
			end
		end
	end,
-----------------------------------
	["Shield Wall"] = function()
		if ni.player.hp() < 37
		 and ni.spell.isinstant(871) 
		 and ni.spell.available(871) then
			ni.spell.cast(871)
			return true
		end
	end,		 
-----------------------------------
	["Taunt"] = function()
		if UnitExists("targettarget") 
		 and not UnitIsDeadOrGhost("targettarget")
		 and UnitAffectingCombat("player")
		 and (ni.unit.debuff("targettarget", 72410) 
		 or ni.unit.debuff("targettarget", 72411) 
		 or ni.unit.threat("player", "target") < 2 )
		 and ni.spell.isinstant(355) 
		 and ni.spell.available(355)
		 and ni.data.darhanger_leveling.youInInstance()
		 and ni.spell.valid("target", 355, false, true, true) then
			ni.spell.cast(355)
			return true
		end
	end,
-----------------------------------
	["Taunt (Ally)"] = function()
		local enemies = ni.unit.enemiesinrange("target", 30)
		for i = 1, #enemies do
		local threatUnit = enemies[i].guid
   		 if ni.unit.threat("player", threatUnit) ~= nil 
   		  and ni.unit.threat("player", threatUnit) <= 2
   		  and UnitAffectingCombat(threatUnit)
		  and ni.spell.isinstant(355) 
   		  and ni.spell.available(355)
		  and ni.data.darhanger_leveling.youInInstance()
   		  and ni.spell.valid(threatUnit, 355, false, true, true) then
			ni.spell.cast(355, threatUnit)
			return true
			end
		end
	end,
-----------------------------------
	["Mocking Blow"] = function()
		if UnitExists("targettarget") 
		 and not UnitIsDeadOrGhost("targettarget")
		 and UnitAffectingCombat("player")
		 and (ni.unit.debuff("targettarget", 72410) 
		 or ni.unit.debuff("targettarget", 72411) 
		 or ni.unit.threat("player", "target") < 2)
		 and ni.spell.cd(355) ~= 0
		 and ni.spell.isinstant(694) 
		 and ni.spell.available(694)
		 and ni.spell.valid("target", 694, true, true) then
			ni.spell.cast(694)
			return true
		end
	end,
-----------------------------------
	["Revenge"] = function()
		if IsUsableSpell(revenge)
		 and ni.spell.isinstant(revenge) 
		 and ni.spell.available(revenge, true)
		 and ni.spell.valid("target", revenge, true, true) then
			ni.spell.cast(revenge, "target")
			return true
		end
	end,
-----------------------------------
	["Rend"] = function()
		local rend = ni.data.darhanger_leveling.warrior.rend()
		if ni.unit.isboss("target")
		 and (rend == nil or (rend - GetTime() <= 2))
		 and ni.spell.isinstant(rend) 
		 and ni.spell.available(rend, true)
		 and ni.spell.valid("target", rend, true, true) then
			ni.spell.cast(rend)
			return true
		end
	end,
-----------------------------------
	["Shield Block"] = function()
		if ni.player.hp() < 80
		 and ni.spell.available(2565, true)
		 and ni.spell.valid("target", devastate) then
			ni.spell.cast(2565)
			return true
		end
	end,		 
-----------------------------------
	["Shield Slam"] = function()
		if ni.spell.available(shieldslam, true)
		 and ni.spell.isinstant(shieldslam) 
		 and ni.spell.valid("target", shieldslam, true, true) then
			ni.spell.cast(shieldslam)
			return true
		end
	end,
-----------------------------------
	["Thunder Clap"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if #enemies >= 1
		 and ni.spell.available(thunderclap, true)
		 and ni.spell.valid("target", thunderclap, true, true) then
			ni.spell.cast(thunderclap)
			return true
		end
	end,
-----------------------------------
	["Demoralizing Shout"] = function()
		local enemies;
		if UnitExists("target")
		 and UnitCanAttack("player", "target") then
			enemies = ni.unit.enemiesinrange("target", 8)
			for i = 1, # enemies do
				local tar = enemies[i].guid;
				if ni.unit.creaturetype(enemies[i].guid) ~= 8 
				 and not ni.unit.debuff(tar, demoshout)
				 and GetTime() - ni.data.darhanger_leveling.warrior.LastShout > 4
				 and ni.spell.available(demoshout) then
					ni.spell.cast(demoshout, tar)
					ni.data.darhanger_leveling.warrior.LastShout = GetTime()
					return true
				end
			end
		end
	end,
-----------------------------------
	["Devastate"] = function()
		if ni.spell.available(devastate, true)
		 and ni.spell.isinstant(devastate) 
		 and ni.spell.valid("target", devastate, true, true) then
			ni.spell.cast(devastate)
			return true
		end
	end,
	
	["Low level Heroic Strike"] = function()
	if ni.spell.available(heroicstrike, true)
			 and not IsCurrentSpell(heroicstrike) 
			 and ni.spell.isinstant(heroicstrike)
			 and UnitLevel("player") <= 15
			 and UnitPower("player") >= 15 then
				ni.spell.cast(heroicstrike, "target")
			end
			end,
				
-----------------------------------
	["Heroic Strike + Cleave (Filler)"] = function()
		local enemies = ni.unit.enemiesinrange("target", 5)
		if IsSpellInRange(slam, "target") == 1
		 and ni.spell.cd(mortalstrike) ~= 0 
		 and ni.player.power() > 35 then
			if #enemies >= 1	
			 and ni.spell.available(cleave, true) 
			 and not IsCurrentSpell(cleave) then
				ni.spell.cast(cleave, "target")
			return true
		else
			if #enemies == 0
			 and ni.spell.available(heroicstrike, true)
			 and not IsCurrentSpell(heroicstrike) then
				ni.spell.cast(heroicstrike, "target")
			return true
				end
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Protection Warrior by darhanger for 3.3.5a -- Modified by Xcesius for leveling",  
		 "Welcome to Protection Warrior Profile! Support and more in DiscordDiscord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-Focus ally target for use Vigilance on it")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("Protection_darhanger_leveling", queue, abilities);