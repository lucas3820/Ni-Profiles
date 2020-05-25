local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",	
	"Stutter cast pause",
	"Universal pause",
	"AutoTarget",
	"Gift of the Wild",
	"Thorns",
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
		if IsMounted()
		 or UnitInVehicle("player")
		 or UnitIsDeadOrGhost("target") 
		 or UnitIsDeadOrGhost("player")
		 or UnitChannelInfo("player")
		 or UnitCastingInfo("player")
		 or ni.unit.buff("target", 59301)
		 or ni.unit.buff("player", GetSpellInfo(430))
		 or ni.unit.buff("player", GetSpellInfo(433))
		 or (not UnitAffectingCombat("player")
		 and ni.vars.followEnabled) then
			return true
		end
	end,
-----------------------------------
	["Stutter cast pause"] = function()
		if ni.spell.gcd()
		 or ni.vars.CastStarted == true then
			return true
		end
	end,
-----------------------------------
	["AutoTarget"] = function()
		if UnitAffectingCombat("player")
		 and (not UnitExists("target")
		 or (UnitExists("target") and not UnitCanAttack("player", "target"))) then
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
	["Cat Form"] = function()
		if not ni.player.buff(768)
		 and ni.spell.available(768) then
			ni.spell.cast(768)
			return true
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if ni.data.darhanger.meleeStop()
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
	["Use enginer gloves"] = function()
		if ni.player.slotcastable(10) 
		 and ni.player.slotcd(10) == 0
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsSpellInRange(GetSpellInfo(49800), "target") == 1 then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and IsSpellInRange(GetSpellInfo(49800), "target") == 1 then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0
		 and IsSpellInRange(GetSpellInfo(49800), "target") == 1 then
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
	["Tigers Fury"] = function()
		local berserk = ni.data.darhanger.druid.berserk()
		if berserk == nil
		 and ni.spell.isinstant(50213)
		 and ni.spell.available(50213)
		 and ni.player.power() < 30 then
			ni.spell.cast(50213)
			return true
		end
	end,
-----------------------------------
	["Berserk"] = function()
		local berserk = ni.data.darhanger.druid.berserk()
		local savage = ni.data.darhanger.druid.savage() 
		local tiger = ni.data.darhanger.druid.tiger() 
		local rip = ni.data.darhanger.druid.rip()
		local mangle = ni.data.darhanger.druid.mangle()
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
		local savage = ni.data.darhanger.druid.savage() 
		local rip = ni.data.darhanger.druid.rip()
		local mangle = ni.data.darhanger.druid.mangle()
		if ni.spell.available(48577)
		 and mangle
		 and ( savage ~= nil and ( savage - GetTime() > 11 ) )
		 and ( rip ~= nil and ( rip - GetTime() > 8 ) )
		 and ni.spell.isinstant(48577)
		 and GetComboPoints("player") >= 5
		 and ni.spell.valid("target", 48574, true, true) then
			ni.spell.cast(48577, "target")
			return true
		end
	end,
-----------------------------------
	["Savage Roar"] = function()
		local savage = ni.data.darhanger.druid.savage() 
		local mangle = ni.data.darhanger.druid.mangle()
		if ni.spell.available(52610)
		 and mangle
		 and ( savage == nil or ( savage - GetTime() <= 2 ) )
		 and GetComboPoints("player") >= 1
		 and ni.spell.isinstant(48574)
		 and ni.spell.valid("target", 48574, true, true) then
			ni.spell.cast(52610)
			return true
		end
	end,
-----------------------------------
	["Rip"] = function()
		local mangle = ni.data.darhanger.druid.mangle()
		local rip = ni.data.darhanger.druid.rip()
		if GetComboPoints("player") >= 5
		 and ni.spell.available(52610)
		 and mangle
		 and ( rip == nil or ( rip - GetTime() <= 2 ) )
		 and ni.spell.isinstant(49800)
		 and ni.spell.valid("target", 49800, true, true) then
			ni.spell.cast(49800, "target")
			return true
		end
	end,
-----------------------------------
	["Savage Roar()"] = function()
		local savage = ni.data.darhanger.druid.savage() 
		local mangle = ni.data.darhanger.druid.mangle()
		local rip = ni.data.darhanger.druid.rip()
		if ni.spell.available(52610)
		 and GetComboPoints("player") >= 3
		 and mangle
		 and ( savage == nil or ( savage - GetTime() <= 8 ) )
		 and ( savage == nil or ( savage and rip == nil ) 
		 or ( savage and rip and rip - GetTime() >= -3 ) ) 
		 and ni.spell.isinstant(52610)
		 and ni.spell.valid("target", 48574, true, true) then
			ni.spell.cast(52610)
			return true
		end
	end,
-----------------------------------
	["Mangle (Cat)"] = function()
		local mangle = ni.data.darhanger.druid.mangle()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if ni.spell.available(48566)
		 and ( #enemies == 1 or #enemies < 2 )
		 and ( mangle == nil or ( mangle - GetTime() <= 2 ) )
		 and ni.spell.isinstant(48566)		 
		 and ni.spell.valid("target", 48566, true, true) then
			ni.spell.cast(48566, "target")
			return true
		end
	end,
-----------------------------------
	["Swipe (Cat)"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if ni.spell.available(62078)
		 and #enemies > 2
		 and ni.spell.isinstant(62078)	
		 and ni.spell.valid("target", 48566, true, true) then
			ni.spell.cast(62078, "target")
			return true
		end
	end,
-----------------------------------
	["Rake"] = function()
		local mangle = ni.data.darhanger.druid.mangle()
		local rake = ni.data.darhanger.druid.rake()
		if ni.spell.available(48574)
		 and mangle
		 and ni.spell.isinstant(48574)	
		 and ( rake == nil or ( rake - GetTime() <= 1 ) )
		 and ni.spell.valid("target", 48574, true, true) then
			ni.spell.cast(48574, "target")
			return true
		end
	end,
-----------------------------------
	["Shred"] = function()
		local savage = ni.data.darhanger.druid.savage()
		local mangle = ni.data.darhanger.druid.mangle()
		local rake = ni.data.darhanger.druid.rake()
		local rip = ni.data.darhanger.druid.rip()
		local berserk = ni.data.darhanger.druid.berserk()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if ni.spell.available(48572)
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
				ni.spell.cast(48572, "target")
				return true
			else
				ni.spell.cast(48566, "target")
				return true
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Feral Cat Druid by DarhangeR", 
		 "Welcome to Feral Cat Druid Profile! Support and more in Discord > https://discord.gg/u4mtjws.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Feral_Cat_DarhangeR", queue, abilities, data)