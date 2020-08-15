local data = ni.utils.require("darhanger_leveling.lua");

local innerfire = GetSpellInfo(48168)
local prayeroffortitude = GetSpellInfo(48162)
local prayerofspirit = GetSpellInfo(48074)
local felintelligence = GetSpellInfo(57567)
local prayerofshadowprotection = GetSpellInfo(48170)
local shadowfiend = GetSpellInfo(34433)
local shadowworddeath = GetSpellInfo(48158)
local shadowwordpain = GetSpellInfo(48125)
local mindsear = GetSpellInfo(53023)
local shadowweaving = GetSpellInfo(15258)
local vampirictouch = GetSpellInfo(48160)
local devouringplague = GetSpellInfo(48300)
local mindblast = GetSpellInfo(48127)
local mindflay = GetSpellInfo(48156)


local popup_shown = false;
local queue = {
	"Window",	
	"AutoTarget",
	"Universal pause",
	"Inner Fire",
	"Prayer of Fortitude",
	"Prayer of Spirit",
	"Prayer of Shadow Protection",
	"Fear Ward",		
	"Vampiric Embrace",	
	"Shadowform",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",		
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Silence (Interrupt)",
	"Fade",
	"Dispersion",
	"Shadowfiend",		
	"Shadow Word: Death",
	"Mind Sear",
	"Shadow Word: Pain",
	"SWP AoE",
	"Vampiric Touch",
	"Devouring Plague",
	"Mind Flay",
}
local queue2 = {
	"Window",	
	"AutoTarget",
	"Universal pause",
	"Inner Fire",
	"Prayer of Fortitude",
	"Prayer of Spirit",
	"Prayer of Shadow Protection",
	"Fear Ward",		
	"Vampiric Embrace",	
	"Shadowform",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",		
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Silence (Interrupt)",
	"Fade",
	"Dispersion",
	"Shadowfiend",		
	"Shadow Word: Death",
	"Mind Sear",
	"Shadow Word: Pain",
	"SWP AoE",
	"Vampiric Touch",
	"Devouring Plague",
	"Mind Blast",
	"Mind Flay",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
			if data.UniPause() then
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
			return true
		end
	end,
-----------------------------------
	["Inner Fire"] = function()
		if not ni.player.buff(innerfire)
		 and ni.spell.available(innerfire) then
			ni.spell.cast(innerfire)
			return true
		end
	end,
-----------------------------------
	["Prayer of Fortitude"] = function()
		if ni.player.buff(prayeroffortitude)
		 or not IsUsableSpell(prayeroffortitude) then 
		 return false
	end
		if ni.spell.available(prayeroffortitude)
		 and ni.spell.isinstant(prayeroffortitude) then
			ni.spell.cast(prayeroffortitude)	
			return true
		end
	end,
-----------------------------------
	["Prayer of Spirit"] = function()
		if ni.player.buffs("prayerofspirit||felintelligence")
		 or not IsUsableSpell(prayerofspirit) then 
		 return false
	end
		if ni.spell.available(prayerofspirit) 
		 and ni.spell.isinstant(prayerofspirit) then
			ni.spell.cast(prayerofspirit)	
			return true
		end
	end,
-----------------------------------
	["Prayer of Shadow Protection"] = function()
		if ni.player.buff(prayerofshadowprotection)
		 or not IsUsableSpell(prayerofshadowprotection) then 
		 return false
	end
		if ni.spell.available(prayerofshadowprotection)
		 and ni.spell.isinstant(prayerofshadowprotection) then
			ni.spell.cast(prayerofshadowprotection)	
			return true
		end
	end,
-----------------------------------
	["Fear Ward"] = function()
		if not ni.player.buff(6346)
		 and ni.spell.isinstant(6346) 
		 and ni.spell.available(6346) then
			ni.spell.cast(6346, "player")
			return true
		end
	end,
-----------------------------------
	["Vampiric Embrace"] = function()
		if not ni.player.buff(15286)
		 and ni.spell.isinstant(15286) 
		 and ni.spell.available(15286) then
			ni.spell.cast(15286)
			return true
		end
	end,
-----------------------------------
	["Shadowform"] = function()
		if not ni.player.buff(15473) then
			ni.spell.cast(15473)
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
			data.petFollow()
		 else
		if UnitAffectingCombat("player")
		 and UnitExists("playerpet")
		 and ni.unit.hp("playerpet") > 60
		 and UnitExists("target")
		 and not UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then 
			data.petAttack()
			end
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if data.casterStop()
		 or data.PlayerDebuffs()
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
		 and ni.spell.valid("target", shadowwordpain, true, true) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", shadowwordpain, true, true)
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
		 and ni.spell.valid("target", shadowwordpain) then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.spell.valid("target", shadowwordpain) then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.spell.valid("target", shadowwordpain) then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------	
	["Silence (Interrupt)"] = function()
		if ni.spell.shouldinterrupt("target")
		 and ni.spell.available(15487)
		 and ni.spell.isinstant(15487)
		 and GetTime() - data.LastInterrupt > 9
		 and ni.spell.valid("target", 15487, true, true)  then
			ni.spell.castinterrupt("target")
			data.LastInterrupt = GetTime()
			return true
		end
	end,
-----------------------------------
	["Fade"] = function()
		if #ni.members > 1 
		 and ni.unit.threat("player") >= 2
		 and not ni.player.buff(586)
		 and ni.spell.isinstant(586) 
		 and ni.spell.available(586) then
			ni.spell.cast(586)
			return true
		end
	end,
-----------------------------------
	["Dispersion"] = function()
		if ( ni.player.power() < 20
		 or ni.player.hp() < 20 )
		 and ni.spell.isinstant(47585) 
		 and ni.spell.available(47585) then
			ni.spell.cast(47585)
			return true
		end
	end,
-----------------------------------
	["Shadowfiend"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.isinstant(shadowfiend)
		 and ni.spell.available(shadowfiend) then
			ni.spell.cast(shadowfiend, "target")
			return true
		end
	end,
-----------------------------------
	["Shadow Word: Death"] = function()
		if ni.unit.hp("target") <= 35
		 and ni.spell.available(shadowworddeath)
		 and ni.spell.isinstant(shadowworddeath)
		 and ni.spell.valid("target", shadowworddeath, false, true, true) then
			ni.spell.cast(shadowworddeath, "target")
			return true
		end
	end,
-----------------------------------
	["Mind Sear"] = function()
		if ni.vars.combat.aoe
		 and ni.spell.available(mindsear)
		 and not ni.player.ismoving() then
			ni.spell.cast(mindsear, "target")
			return true
		end
	end,
-----------------------------------
	["Shadow Word: Pain"] = function()
		local SWP = data.priest.SWP()		
		local sWeaving, _, _, count = ni.player.buff(shadowweaving)
		if not SWP
		 and sWeaving
		 and count == 5
		 and ni.spell.available(shadowwordpain)
		 and ni.spell.isinstant(shadowwordpain)
		 and ni.spell.valid("target", shadowwordpain, false, true, true)
		 and GetTime() - data.priest.lastSWP > 1 then
			ni.spell.cast(shadowwordpain, "target")
			data.priest.lastSWP = GetTime()
			return true
		end
	end,
-----------------------------------
	["SWP AoE"] = function()
		local enemies;
		if ni.rotation.custommod()
		 and UnitExists("target")
		 and ni.spell.available(shadowwordpain)
		 and ni.spell.isinstant(shadowwordpain)
		 and UnitCanAttack("player", "target") then
			enemies = ni.unit.enemiesinrange("target", 15)
			for i = 1, #enemies do
				local tar = enemies[i].guid; 
				if ni.unit.creaturetype(enemies[i].guid) ~= 8
				 and ni.unit.creaturetype(enemies[i].guid) ~= 11
				 and not ni.unit.debuffs(tar, "23920||35399||69056")
				 and not ni.unit.debuff(tar, shadowwordpain, "player")
				 and ni.spell.valid(enemies[i].guid, shadowwordpain, false, true, true) then
					ni.spell.cast(shadowwordpain, tar)
					return true
				end
			end
		end
	end,
-----------------------------------
	["Vampiric Touch"] = function()
		if not ni.player.ismoving()
		 and ni.unit.debuffremaining("target", vampirictouch, "player") < ni.spell.casttime(vampirictouch)
		 and ni.spell.available(vampirictouch)
		 and ni.spell.valid("target", vampirictouch, false, true, true)
		 and GetTime() - data.priest.lastvamp > 2 then
			ni.spell.cast(vampirictouch, "target")
			data.priest.lastvamp = GetTime()
			return true
		end
	end,
-----------------------------------
	["Devouring Plague"] = function()
		if ni.spell.available(devouringplague)
		 and ni.spell.isinstant(devouringplague)
		 and ni.unit.debuffremaining("target", devouringplague, "player") < 2.7
		 and ni.spell.valid("target", devouringplague, false, true, true) then  
			ni.spell.cast(devouringplague, "target")
			return true
		end
	end,
-----------------------------------
	["Mind Blast"] = function()
		if not ni.player.ismoving()
		 and ni.spell.available(mindblast)
		 and ni.spell.valid("target", mindblast, true, true) then
			ni.spell.cast(mindblast, "target")
			return true
		end
	end,
-----------------------------------
	["Mind Flay"] = function()
		if ni.spell.cd(mindblast)
		 and not ni.player.ismoving()
		 and ni.spell.available(mindflay)
		 and ni.spell.valid("target", mindblast, true, true) then
			ni.spell.cast(mindflay, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Shadow Priest by darhanger -- Modified by Xcesius for leveling", 
		 "Welcome to Shadow Priest Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For use Mind Sear configure AoE Toggle key.\n-For use Shadow Word:Pain AoE mode configure Custom Key Modifier and hold it for put spell on nearest enemies.")
		popup_shown = true;
		end 
	end,
}

local dynamicqueue = function()
    if data.priest.checkforSet(data.priest.itemsetT10, 4) then
        return queue
    end
		return queue2
end

ni.bootstrap.profile("Shadow_darhanger_leveling", dynamicqueue, abilities);