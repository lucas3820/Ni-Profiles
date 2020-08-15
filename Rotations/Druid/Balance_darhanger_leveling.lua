local data = ni.utils.require("darhanger_leveling.lua");

--Ability Convert
local giftofthewild = GetSpellInfo(48470)
local thorns = GetSpellInfo(53307)
local moonkinform = GetSpellInfo(24858)
local innervate = GetSpellInfo(29166)
local faeriefiredr = GetSpellInfo(770)
local hurricane = GetSpellInfo(48467)
local starfall = GetSpellInfo(53201)
local wrath = GetSpellInfo(48461)
local moonfire = GetSpellInfo(48463)
local insectswarm = GetSpellInfo(48468)
local starfire = GetSpellInfo(48465)



local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"AutoTarget",
	"Gift of the Wild",
	"Innervate",		
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",		
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Barkskin",
	"Faerie Fire",
	"Hurricane",
	"Eclipses",
	"Starfall",
	"Force of Nature",	
	"Insect Swarm",
	"Moonfire",
	"Wrath",
	"Starfire",
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
	["Moonkin Form"] = function()
		if not ni.player.buff(moonkinform)
		 and ni.spell.available(moonkinform)
		 and not ni.player.buff(33357) then
			ni.spell.cast(moonkinform)
			return true
		end
	end,
-----------------------------------
	["Innervate"] = function()
		if ni.player.power() < 30
		 and not ni.player.buff(innvervate)
		 and ni.spell.isinstant(innvervate)
		 and ni.spell.available(innvervate) then
			ni.spell.cast(innvervate)
			return true
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if ni.data.darhanger_leveling.casterStop()
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
			if ni.player.power() < 35
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
		 and ni.spell.valid("target", 48461) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 48461)
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
		 and ni.spell.valid("target", 48461) then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.spell.valid("target", 48461) then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.spell.valid("target", 48461) then
			ni.player.useinventoryitem(14)
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
	["Faerie Fire"] = function()
		local mFaerieFire = ni.data.darhanger_leveling.druid.mFaerieFire() 
		local fFaerieFire = ni.data.darhanger_leveling.druid.fFaerieFire() 
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and not fFaerieFire
		 and not mFaerieFire
		 and ni.spell.isinstant(faeriefiredr)
		 and ni.spell.available(faeriefiredr) then
			ni.spell.cast(faeriefiredr, target)
			return true
		end
	end,
-----------------------------------
	["Hurricane"] = function()
		if ni.vars.combat.aoe
		 and not ni.player.ismoving()
	         and ni.spell.available(hurricane) then
			ni.spell.castat(hurricane, "target")
			return true
		end
	end,
-----------------------------------
	["Starfall"] = function()
		if ni.rotation.custommod()
		 and ni.spell.isinstant(starfall)
		 and ni.spell.available(starfall)
		 and ni.spell.valid("target", wrath) then
			ni.spell.cast(starfall)
			return true
		end
	end,
-----------------------------------
	["Force of Nature"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		and ni.spell.isinstant(33831)
		and ni.spell.available(33831) then
			ni.spell.castat(33831, "target")
			return true
		end
	end,
-----------------------------------
	["Moonfire"] = function()
		local mFire = ni.data.darhanger_leveling.druid.mFire()
		local solar = ni.data.darhanger_leveling.druid.solar()
		if ni.spell.available(moonfire)
		 and (ni.player.ismoving()
		 and (not mFire
		 or (mFire and mFire - GetTime() < 6 )))
		 or ((not solar 
		 or (solar and solar - GetTime() > 5))
		 and not mFire)
		 and ni.spell.isinstant(moonfire)
		 and ni.spell.valid("target", moonfire, true, true) then
			ni.spell.cast(moonfire, "target")
			return true
		end
	end,
-----------------------------------
	["Insect Swarm"] = function()
		local iSwarm = ni.data.darhanger_leveling.druid.iSwarm()
		local lunar = ni.data.darhanger_leveling.druid.lunar()
		if ni.spell.available(insectswarm)
		 and (ni.player.ismoving()
		 and (not iSwarm
		 or (iSwarm and iSwarm - GetTime() < 2 )))
		 or ((not lunar 
		 or (lunar and lunar - GetTime() > 1))
		 and not iSwarm)
		 and ni.spell.isinstant(insectswarm)
		 and ni.spell.valid("target", insectswarm, false, true, true) then
			ni.spell.cast(insectswarm, "target")
			return true
		end
	end,
-----------------------------------
	["Eclipses"] = function()
		if not eclipse 
		 then eclipse = "solar" 
		 end

		if ni.player.buff(48517)
		 then eclipse = "solar"
		 elseif ni.player.buff(48518)
		 then eclipse = "lunar" 
		end
	end,
-----------------------------------
	["Wrath"] = function()
		if eclipse == "solar"
		 and not ni.player.ismoving()
		 and ni.spell.available(wrath)
		 and ni.spell.valid("target", wrath, true, true) then
			ni.spell.cast(wrath, "target")
			return true
		end
	end,
-----------------------------------
	["Starfire"] = function()
		if eclipse == "lunar"
		 and not ni.player.ismoving() 
		 and ni.spell.available(starfire)
		 and ni.spell.valid("target", starfire, true, true) then
			ni.spell.cast(starfire, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Balance Druid by darhanger for 3.3.5a -- Modified by Xcesius for leveling", 
		 "Welcome to Balance Druid Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For use Hurricane configure AoE Toggle key.\n-For use Starfall configure Custom Key Modifier and hold it for use it.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("Balance_darhanger_leveling", queue, abilities);