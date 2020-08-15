local data = ni.utils.require("darhanger_leveling.lua");

--Abilities 
local aspectdragonhawk = GetSpellInfo(61847)
local aspectviper = GetSpellInfo(34074)
local mendpet = GetSpellInfo(48990)
local huntersmark = GetSpellInfo(53338)
local volley = GetSpellInfo(58434)
local freezingarrow = GetSpellInfo(60192)
local steadyshot = GetSpellInfo(49052)
local killcommand = GetSpellInfo(34026)
local mangoosebite = GetSpellInfo(53339)
local raptorstrike = GetSpellInfo(48996)
local killshot = GetSpellInfo(61006)
local trueshot = GetSpellInfo(19506)
local arcaneshot = GetSpellInfo(49045)
local chimerashot = GetSpellInfo(53209)
local aimedshot = GetSpellInfo(49050)
local multishot = GetSpellInfo(49048)
local serpentsting = GetSpellInfo(49001)


local popup_shown = false;
local queue = {
	"Window",
	"Cancel Deterrence",
	"Universal pause",
	"AutoTarget",
	"Aspect of the Dragonhawk",
	"Aspect of the Viper",
	"Pet:Heart of the Phoenix",
	"Mend Pet",
	"Hunter's Mark",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Deterrence",
	"Wing Clip",
	"Volley",
	"Freezing Arrow",
	"Rapid Fire",
	"Bestial Wrath",
	"Pet:Call of the Wild",
	"Kill Command",
	"Misdirection",
	"Feign Death",
	"Mongoose Bite",
	"Raptor Strike",
	"Tranquilizing Shot",
	"Kill Shot",
	"Multi-Shot (AoE)",
	"Serpent Sting",
	"Arcane Shot",
	"Aimed Shot",
	"Steady Shot",
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
	["Aspect of the Dragonhawk"] = function()
		if not ni.player.buff(aspectdragonhawk)
		 and ni.spell.available(aspectdragonhawk)
		 and ni.spell.isinstant(aspectdragonhawk)
		 and ni.player.power() > 85 then
			ni.spell.cast(aspectdragonhawk)
			return true
		end
	end,
-----------------------------------
	["Aspect of the Viper"] = function()
		if not ni.player.buff(aspectviper)
		 and ni.spell.available(aspectviper)
		 and ni.spell.isinstant(aspectdragonhawk)
		 and ni.player.power() < 15 then
			ni.spell.cast(aspectviper)
			return true
		end
	end,
-----------------------------------
	["Pet Attack/Follow"] = function()
		if ni.unit.hp("playerpet") < 20
		 and UnitExists("playerpet")
		 and UnitExists("target")
		 and UnitIsUnit("target", "pettarget")
		 and ni.unit.buff("pet", 48990)
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
	["Mend Pet"] = function()
		if ni.unit.hp("playerpet") < 80
		 and not ni.unit.buff("pet", mendpet)
		 and UnitExists("playerpet")
		 and UnitInRange("playerpet")
		 and ni.spell.isinstant(mendpet)
		 and ni.spell.available(mendpet)
		 and not UnitIsDeadOrGhost("playerpet") then
			ni.spell.cast(mendpet)
			return true
		end
	end,
-----------------------------------
	["Hunter's Mark"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") ) 
		 and not ni.unit.debuff("target", huntersmark)
		 and ni.spell.available(huntersmark)
		 and ni.spell.isinstant(huntersmark)		 
		 and ni.spell.valid("target", huntersmark, true, true) then
			ni.spell.cast(huntersmark)
			return true
		end
	end,
-----------------------------------
	["Cancel Deterrence"] = function()
		local p="player" for i = 1,40 
		do local _,_,_,_,_,_,_,u,_,_,s=ni.player.buff(p,i)
		 if ni.player.hp() > 45
		 and u==p and s==19263 then
				CancelUnitBuff(p,i)
				break 
			end
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if data.meleeStop()
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
		 and ni.spell.valid("target", 49052) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 49052)
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
		 and ni.spell.valid("target", 49052) then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.spell.valid("target", 49052) then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.spell.valid("target", 49052) then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------
	["Deterrence"] = function()
		if ni.player.hp() < 25
		 and ni.spell.isinstant(19263)
		 and ni.spell.available(19263) then
			ni.spell.cast(19263)
			return true
		end
	end,
-----------------------------------
	["Wing Clip"] = function()
		if ni.player.distance("target") < 2
		 and not ni.unit.debuff("target", 2974)
		 and ni.spell.isinstant(2974)
		 and ni.spell.available(2974)
		 and ni.spell.valid("target", 53339, true, true) then
			ni.spell.cast(2974, "target")
			return true
		end
	end,
-----------------------------------
	["Volley"] = function()
		if ni.vars.combat.aoe
		 and not ni.player.ismoving()
		 and ni.spell.available(volley) then
			ni.spell.castat(volley, "target")
			return true
		end
	end,
-----------------------------------
	["Freezing Arrow"] = function()
		if ni.rotation.custommod()
		 and ni.spell.isinstant(freezingarrow)
		 and ni.spell.available(freezingarrow) then
			ni.spell.castat(freezingarrow, "target")
			return true
		end
	end,
-----------------------------------
	["Rapid Fire"] = function()
		if ( ni.vars.CD or ni.unit.isboss("target") )
		 and not ni.player.buff(3045)
		 and ni.player.buff(aspectdragonhawk)
		 and ni.spell.available(3045)
		 and ni.spell.isinstant(3045)
		 and ni.spell.valid("target", steadyshot) then
			ni.spell.cast(3045)
			return true
		end
	end,
-----------------------------------
	["Bestial Wrath"] = function()
		if ( ni.vars.CD or ni.unit.isboss("target") )
		 and UnitExists("playerpet")
		 and UnitInRange("playerpet")
		 and ni.spell.available(19574)
		 and ni.spell.isinstant(19574)
		 and ni.spell.valid("target", steadyshot) then
			ni.spell.cast(19574)
			return true
		end
	end,		
-----------------------------------
	["Pet:Call of the Wild"] = function()
		if ( ni.vars.CD or ni.unit.isboss("target") )
		 and IsSpellKnown(53434, true)
		 and GetSpellCooldown(53434) == 0 then
			ni.spell.cast(53434)
			return true
		end
	end,
-----------------------------------
	["Pet:Heart of the Phoenix"] = function()
		if ( ni.vars.CD or ni.unit.isboss("target") )
		 and IsSpellKnown(55709, true)
		 and GetSpellCooldown(55709) == 0 then
			ni.spell.cast(55709)
			return true
		end
	end,
-----------------------------------
	["Kill Command"] = function()
		if ( ni.vars.CD or ni.unit.isboss("target") )
		 and UnitExists("playerpet")
		 and ni.spell.isinstant(killcommand)
		 and ni.spell.available(killcommand)
		 and ni.spell.valid("target", steadyshot) then
			ni.spell.cast(killcommand)
			return true
		end
	end,
-----------------------------------
	["Misdirection"] = function()
		if ( ni.unit.threat("player", "target") >= 2
		 or ni.vars.CD or ni.unit.isboss("target") )
		 and UnitExists("focus")
		 and UnitInRange("focus")
		 and ni.spell.available(34477)
		 and not UnitIsDeadOrGhost("focus") then
			ni.spell.cast(34477, "focus")
			data.hunter.LastMD = GetTime()
			return true
		else 
		if ( ni.unit.threat("player", "target") >= 2
		 or ni.vars.CD or ni.unit.isboss("target") )
		  and not UnitExists("focus")
		  and UnitExists("playerpet")
		  and UnitInRange("playerpet")
		  and ni.spell.available(34477)
		  and not UnitIsDeadOrGhost("playerpet") then
			ni.spell.cast(34477, "playerpet")
			data.hunter.LastMD = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Feign Death"] = function()
		if ni.unit.threat("player", "target") >= 2
		 and UnitExists("focus")
		 and ni.spell.isinstant(5384)
		 and ni.spell.available(5384)
		 and not ni.spell.available(34477)
		 and GetTime() - data.hunter.LastMD > 3
		 and ni.spell.available(5384) then
			ni.spell.cast(5384)
			return true
		end
	end,
-----------------------------------
	["Mongoose Bite"] = function()
		if ni.spell.available(mangoosebite)
	 	 and ni.spell.isinstant(mangoosebite)
		 and ni.spell.available(mangoosebite)
		 and ni.spell.valid("target", mangoosebite, true, true) then
			ni.spell.cast(mangoosebite, "target")
			return true
		end
	end,
-----------------------------------
	["Raptor Strike"] = function()
		if ni.spell.available(raptorstrike, true)
		 and ni.spell.valid("target", mangoosebite, true, true) then
			ni.spell.cast(raptorstrike, "target")
			return true
		end
	end,
-----------------------------------
	["Kill Shot"] = function()
		if (ni.unit.hp("target") <= 20
		 or IsUsableSpell(killshot))
		 and ni.player.buff(aspectdragonhawk)
		 and ni.spell.available(killshot)
		 and ni.spell.valid("target", killshot, true, true) then
			ni.spell.cast(killshot, "target")
			return true
		end
	end,
-----------------------------------
	["Multi-Shot (AoE)"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if #enemies >= 2
		 and ni.spell.available(multishot)
		 and ni.spell.valid("target", multishot, true, true) then
			ni.spell.cast(multishot, "target")
			return true
		end
	end,
-----------------------------------
	["Serpent Sting"] = function()
		local serpstring = data.hunter.serpstring()
		if (serpstring == nil or (serpstring - GetTime() <= 2))	 
		 and ni.spell.available(serpentsting)
		 and ni.spell.valid("target", serpentsting, true, true) then
			ni.spell.cast(serpentsting, "target")
			return true
		end
	end,
-----------------------------------
	["Arcane Shot"] = function()
		if ni.spell.available(arcaneshot)
		 and ni.spell.valid("target", arcaneshot, true, true) then
			ni.spell.cast(arcaneshot, "target")
			return true
		end
	end,	
-----------------------------------
	["Aimed Shot"] = function()
		if ni.spell.available(aimedshot)	
		 and ni.spell.valid("target", aimedshot, true, true) then
			ni.spell.cast(aimedshot, "target")
			return true
		end
	end,
-----------------------------------
	["Steady Shot"] = function()
		if not ni.player.ismoving()
		 and ni.spell.cd(steadyshot)
		 and ni.spell.available(steadyshot)
		 and ni.spell.valid("target", steadyshot, true, true) then
			ni.spell.cast(steadyshot, "target")
			return true
		end
	end,
-----------------------------------
	["Tranquilizing Shot"] = function()
		if ni.unit.bufftype("target", "Enrage|Magic")
		 and ni.spell.available(19801)
		 and ni.spell.valid("target", 19801, true, true) then
			ni.spell.cast(19801, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		ni.debug.popup("Beast Mastery Hunter by darhanger for 3.3.5a -- Modified by Xcesius for leveling", 
		"Welcome to Beast Mastery Hunter Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For use Volley configure AoE Toggle key.\n-Focus target for use Misdirection & Feign Death.\n-For use Freezing Arrow configure Custom Key Modifier and hold it for use it.\n-For better experience make Pet passive.")	
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("BeastMaster_darhanger_leveling", queue, abilities);