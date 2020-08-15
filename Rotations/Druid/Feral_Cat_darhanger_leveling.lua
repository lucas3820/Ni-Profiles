local data = ni.utils.require("darhanger_leveling.lua");

local giftofthewild = GetSpellInfo(48470)
local thorns = GetSpellInfo(53307)
local faeriefiredr = GetSpellInfo(16857)
local tigersfury = GetSpellInfo(50213)
local ferociousbite = GetSpellInfo(48577)
local rake = GetSpellInfo(48574)
local savageroar = GetSpellInfo(52610)
local rip = GetSpellInfo(49800)
local mangle = GetSpellInfo(48566)
local catswipe = GetSpellInfo(62078)
local shred = GetSpellInfo(48572)


local popup_shown = false;
local queue = {
	"Window",	
	"Universal pause",
	"AutoTarget",
	"Gift of the Wild",
	--"Thorns",
	"Cat Form",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Barkskin",
	"Survival Instincts",
	"Faerie Fire",
	"Berserk",
	"Tigers Fury",		
	"Savage Roar",
	"Swipe (Cat)",
	"Rip",
	"Savage Roar()",
	"Mangle (Cat)",
	"Rake",
	"Shred",
	"Ferocious Bite",
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
	["Cat Form"] = function()
		if not ni.player.buff(768)
		 and ni.spell.available(768) then
			ni.spell.cast(768)
			return true
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
		if data.forsaken()
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
	["Use enginer gloves"] = function()
		if ni.player.slotcastable(10) 
		 and ni.player.slotcd(10) == 0
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsSpellInRange(rip, "target") == 1 then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and IsSpellInRange(rip, "target") == 1 then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0
		 and IsSpellInRange(rip, "target") == 1 then
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
	["Survival Instincts"] = function()
		if ni.player.hp() < 25
		 and ni.spell.isinstant(61336)
		 and ni.spell.available(61336) then
			ni.spell.cast(61336)
			return true
		end
	end,
-----------------------------------
	["Faerie Fire"] = function()
		local mFaerieFire = data.druid.mFaerieFire() 
		local fFaerieFire = data.druid.fFaerieFire() 
		if not fFaerieFire
		 and not mFaerieFire
		 and ni.spell.isinstant(faeriefiredr)
		 and ni.spell.available(faeriefiredr) then
			ni.spell.cast(faeriefiredr, "target")
			return true
		end
	end,
-----------------------------------
	["Tigers Fury"] = function()
		local berserk = data.druid.berserk()
		if berserk == nil
		 and ni.spell.isinstant(tigersfury)
		 and ni.spell.available(tigersfury)
		 and ni.player.power() < 30 then
			ni.spell.cast(tigersfury)
			return true
		end
	end,
-----------------------------------
	["Berserk"] = function()
		local berserk = data.druid.berserk()
		local savage = data.druid.savage() 
		local tiger = data.druid.tiger() 
		local rip = data.druid.rip()
		local mangle = data.druid.mangle()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and tiger == nil
		 and mangle
		 and ni.spell.isinstant(50334)
		 and ni.spell.available(50334)
		 and ni.player.power() < 35
		 and ( savage ~= nil and savage - GetTime() > 8 )
		 and ( rip ~= nil and rip - GetTime() > 8 ) then
			ni.spell.cast(50334)
			return true
		end
	end,
-----------------------------------
	["Ferocious Bite"] = function()
		local savage = data.druid.savage() 
		local rip = data.druid.rip()
		local mangle = data.druid.mangle()
		if ni.spell.available(ferociousbite)
		 and mangle
		 and ( savage ~= nil and ( savage - GetTime() > 11 ) )
		 and ( rip ~= nil and ( rip - GetTime() > 8 ) )
		 and ni.spell.isinstant(ferociousbite)
		 and GetComboPoints("player") >= 5
		 and ni.spell.valid("target", rake, true, true) then
			ni.spell.cast(ferociousbite, "target")
			return true
		end
	end,
-----------------------------------
	["Savage Roar"] = function()
		local savage = data.druid.savage() 
		local mangle = data.druid.mangle()
		if ni.spell.available(savageroar)
		 and mangle
		 and ( savage == nil or ( savage - GetTime() <= 2 ) )
		 and GetComboPoints("player") >= 1
		 and ni.spell.isinstant(rake)
		 and ni.spell.valid("target", rake, true, true) then
			ni.spell.cast(savageroar)
			return true
		end
	end,
-----------------------------------
	["Rip"] = function()
		local mangle = data.druid.mangle()
		local rip = data.druid.rip()
		if GetComboPoints("player") >= 5
		 and ni.spell.available(savageroar)
		 and mangle
		 and ( rip == nil or ( rip - GetTime() <= 2 ) )
		 and ni.spell.isinstant(rip)
		 and ni.spell.valid("target", rip, true, true) then
			ni.spell.cast(rip, "target")
			return true
		end
	end,
-----------------------------------
	["Savage Roar()"] = function()
		local savage = data.druid.savage() 
		local mangle = data.druid.mangle()
		local rip = data.druid.rip()
		if ni.spell.available(savageroar)
		 and GetComboPoints("player") >= 3
		 and mangle
		 and ( savage == nil or ( savage - GetTime() <= 8 ) )
		 and ( savage == nil or ( savage and rip == nil ) 
		 or ( savage and rip and rip - GetTime() >= -3 ) ) 
		 and ni.spell.isinstant(savageroar)
		 and ni.spell.valid("target", rake, true, true) then
			ni.spell.cast(savageroar)
			return true
		end
	end,
-----------------------------------
	["Mangle (Cat)"] = function()
		local mangle = data.druid.mangle()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if ni.spell.available(mangle)
		 and ( #enemies == 1 or #enemies < 2 )
		 and ( mangle == nil or ( mangle - GetTime() <= 2 ) )
		 and ni.spell.isinstant(mangle)		 
		 and ni.spell.valid("target", mangle, true, true) then
			ni.spell.cast(mangle, "target")
			return true
		end
	end,
-----------------------------------
	["Swipe (Cat)"] = function()
		local enemies = ni.unit.enemiesinrange("player", 7)
		if ni.spell.available(catswipe)
		 and #enemies > 2
		 and ni.spell.isinstant(catswipe)	
		 and ni.spell.valid("target", mangle, true, true) then
			ni.spell.cast(catswipe, "target")
			return true
		end
	end,
-----------------------------------
	["Rake"] = function()
		local mangle = data.druid.mangle()
		local rake = data.druid.rake()
		if ni.spell.available(rake)
		 and mangle
		 and ni.spell.isinstant(rake)	
		 and ( rake == nil or ( rake - GetTime() <= 1 ) )
		 and ni.spell.valid("target", rake, true, true) then
			ni.spell.cast(rake, "target")
			return true
		end
	end,
-----------------------------------
	["Shred"] = function()
		local savage = data.druid.savage()
		local mangle = data.druid.mangle()
		local rake = data.druid.rake()
		local rip = data.druid.rip()
		local berserk = data.druid.berserk()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if ni.spell.available(shred)
		 and mangle
		 and ( #enemies == 1 or #enemies < 2 )
		 and ((GetComboPoints("player") <= 4
		 or ( rip - GetTime() <= 1 ) )
		 and rake ~= nil
		 and rake - GetTime() > 0.5
		 and ( ni.player.power() >= 80 or berserk
		 or (ni.spell.cd(50213) == 0
		 or ni.spell.cd(50213) <= 3 ) )
		 or ( GetComboPoints("player") <= 0 
		 and ( savage == nil 
		 or ( savage - GetTime() <= 2 ) ) ) ) then 
			if ni.player.isbehind("target") then
				ni.spell.cast(shred, "target")
				return true
			else
				ni.spell.cast(mangle, "target")
				return true
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Feral Cat Druid by darhanger for 3.3.5a -- Modified by Xcesius for leveling", 
		 "Welcome to Feral Cat Druid Profile! Support and more in Discord > https://discord.gg/u4mtjws.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("Feral_Cat_darhanger_leveling", queue, abilities);