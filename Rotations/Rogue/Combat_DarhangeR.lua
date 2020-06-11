local data = {"DarhangeR.lua"}

local poisonsmainhand = 
{43231, 43230, 21927, 8928, 8927, 8926, 6950, 6949, 6947}
local poisonoffhand = 
{43233, 43232, 22054, 22053, 20844, 8985, 8984, 2893, 2892 }

local mainhandpoison = nil
local offhandpoison = nil
local function GetBestPoisonMainHand()
local level = UnitLevel("player")
for _, itemid in pairs(poisonsmainhand) do
local name, _, _, _, req = GetItemInfo(itemid)
	if mainhandpoison == name then -- we don't need to spam update out mainhand poison
	return end
	if name and req >= level then
	mainhandpoison = name
			end
		end
	end
local function GetBestPoisonOffHand()
local level = UnitLevel("player")
for _, itemid in pairs(poisonoffhand) do
local name, _, _, _, req = GetItemInfo(itemid)
	if offhandpoison == name then -- we don't need to spam update out offhand poison
	return end
	if name and req >= level then
	offhandpoison = name
			end
		end
	end

--Spells Covnerted to Name
local sinisterstrike = GetSpellInfo(48638)
local fanofknives = GetSpellInfo(51723)
local garrote = GetSpellInfo(48676)
local ambush = GetSpellInfo(48691)
local vanish = GetSpellInfo(26889)
local rupture = GetSpellInfo(48672)
local mutilate = GetSpellInfo(48666)
local sliceanddice = GetSpellInfo(6774)
local eviscerate = GetSpellInfo(48668)

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"AutoTarget",
--	"Poison Weapon",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Kick (Interrupt)",
	"Tricks of the Trade",
	"Fan of Knives",
	"Riposte",
	"Adrenaline Rush",
	"Blade Flurry",
	"Killing Spree",
	"Slice and Dice",
	"Sinister Strike",
	"Rupture",
	"Eviscerate Dump",
	"Eviscerate",
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
    ["Poison Weapon"] = function()
		GetBestPoisonMainHand();
		GetBestPoisonOffHand();
		local mh, _, _, oh = GetWeaponEnchantInfo()
		if applypoison 
		 and GetTime() - applypoison > 4 then 
			applypoison = nil 
		end
		if UnitAffectingCombat("player") == nil 
		and applypoison == nil then
		applypoison = GetTime()
		
		if(mainhandpoison == nil or offhandpoison == nil) then
		return end
		
		if mh == nil 
		 and ni.player.hasitem(mainhandpoison) then
			ni.player.useitem(mainhandpoison)
			ni.player.useinventoryitem(16)
			return true
		end
		if oh == nil
		 and ni.player.hasitem(offhandpoison) then
			ni.player.useitem(offhandpoison)
			ni.player.useinventoryitem(17)
			return true
			end
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
		 and IsSpellInRange(sinisterstrike, "target") == 1 then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if IsSpellInRange(sinisterstrike, "target") == 1
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
		 and IsSpellInRange(sinisterstrike, "target") == 1 then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and IsSpellInRange(sinisterstrike, "target") == 1 then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0
		 and IsSpellInRange(sinisterstrike, "target") == 1 then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------	
	["Kick (Interrupt)"] = function()
		if ni.spell.shouldinterrupt("target")
		 and ni.spell.available(1766)
		 and ni.spell.isinstant(1766)
		 and GetTime() - ni.data.darhanger.LastInterrupt > 9
		 and ni.spell.valid("target", 1766, true, true)  then
			ni.spell.castinterrupt("target")
			ni.data.darhanger.LastInterrupt  = GetTime()
			return true
		end
	end,
-----------------------------------	
	["Tricks of the Trade"] = function()
		if ( ni.unit.threat("player", "target") >= 2
		 or ni.vars.combat.cd or ni.unit.isboss("target") )
		 and UnitExists("focus")
		 and ni.spell.available(57934)
		 and ni.spell.valid("focus", 57934, false, true, true) then
			ni.spell.cast(57934, "focus")
			return true
		else 
		local tank = ni.tanks()
		if ( ni.unit.threat("player", "target") >= 2
		 or ni.vars.combat.cd or ni.unit.isboss("target") )
		  and not UnitExists("focus")
		  and ni.spell.available(57934)
		  and ni.spell.valid(tank, 57934, false, true, true) then
			ni.spell.cast(57934, tank)
			return true
			end
		end
	end,
-----------------------------------
	["Fan of Knives"] = function()
		if ni.vars.combat.aoe
		 and ni.spell.available(fanofknives)
		 and ni.spell.isinstant(fanofknives)
		 and ni.spell.valid("target", sinisterstrike, true, true) then
			ni.spell.castat(fanofknives, "target")
			ni.player.runtext("/targetlasttarget")
			return true
		end
	end,
-----------------------------------
	["Riposte"] = function()
		if IsSpellKnown(14251)
		 and IsUsableSpell(GetSpellInfo(14251)) 
		 and ni.spell.isinstant(14251)
		 and ni.spell.available(14251)
		 and ni.spell.valid("target", 14251, true, true) then
			ni.spell.castqueue(14251, "target")
			return true
		end
	end,
-----------------------------------
	["Blade Flurry"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") or ni.vars.combat.aoe )
		 and ni.spell.available(13877)
		 and ni.spell.isinstant(13877)
		 and not ni.spell.available(51690)
		 and IsSpellInRange(sinisterstrike, "target") == 1 then
			ni.spell.cast(13877)
			return true
		end
	end,
-----------------------------------
	["Adrenaline Rush"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.power() < 35
		 and ni.spell.isinstant(13750)
		 and ni.spell.available(13750)
		 and not ni.spell.available(51690)
		 and IsSpellInRange(sinisterstrike, "target") == 1 then
			ni.spell.cast(13750)
			return true
		end
	end,
-----------------------------------
	["Killing Spree"] = function()
		local SnD = ni.data.darhanger.rogue.SnD()
		if SnD
		 and ni.spell.isinstant(51690)
		 and ni.spell.available(51690)
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsSpellInRange(sinisterstrike, "target") == 1 then
			ni.spell.cast(51690, "target")
			return true
		end
	end,
-----------------------------------
	["Slice and Dice"] = function()
		local SnD = ni.data.darhanger.rogue.SnD()
		if GetComboPoints("player") > 3
		 and( SnD == nil or ( SnD - GetTime() <= 4 ) )
		 and ni.spell.isinstant(sliceanddice)
		 and ni.spell.available(sliceanddice)
		 and ni.spell.valid("target", sinisterstrike) then
			ni.spell.cast(sliceanddice)
			return true
		end
	end,
-----------------------------------
	["Sinister Strike"] = function()
		local enemies = ni.unit.enemiesinrange("target", 7)
		if GetComboPoints("player") < 5
		 and ni.spell.isinstant(sinisterstrike)
		 and ni.spell.available(sinisterstrike)
		 and ( #enemies == 1 or #enemies < 3 )
		 and ni.spell.valid("target", sinisterstrike, true, true) then
			ni.spell.cast(sinisterstrike, "target")
			return true
		end
	end,
-----------------------------------
	["Rupture"] = function()
		local SnD = ni.data.darhanger.rogue.SnD()
		local Rup = ni.data.darhanger.rogue.Rup()
		if ni.player.hasglyph(56801)
		 and GetComboPoints("player") == 5
		 and ( Rup == nil or ( Rup - GetTime() <= 3 ) )
		 and ( SnD and ( SnD - GetTime() > 5 ) )
		 and ni.spell.isinstant(rupture)
		 and ni.spell.available(rupture)
		 and ni.spell.valid("target", rupture, true, true) then
			ni.spell.cast(rupture, "target")
			return true
		end
	end,
-----------------------------------
	["Eviscerate Dump"] = function()
		local SnD = ni.data.darhanger.rogue.SnD()
		local Rup = ni.data.darhanger.rogue.Rup()
		if ni.player.hasglyph(56801)
		 and GetComboPoints("player") == 5
		 and Rup
		 and ( SnD and ( SnD - GetTime() > 5 ) )
		 and ni.spell.isinstant(eviscerate)
		 and ni.spell.available(eviscerate)
		 and ni.spell.valid("target", eviscerate, true, true) then
			ni.spell.cast(eviscerate, "target")
			return true
		end
	end,
-----------------------------------
	["Eviscerate"] = function()
		local SnD = ni.data.darhanger.rogue.SnD()
		if ni.player.hasglyph(56802)
		 and GetComboPoints("player") == 5
		 and ( SnD and ( SnD - GetTime() > 5 ) )
		 and ni.spell.isinstant(eviscerate)
		 and ni.spell.available(eviscerate)
		 and ni.spell.valid("target", eviscerate, true, true) then
			ni.spell.cast(eviscerate, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Combat Rogue by DarhangeR -- Modified by Xcesius for leveling", 
		 "Welcome to Combat Rogue Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-Focus ally target for use TofT on it or put tank name to Tank Overrides and press Enable Main.\n-Rotation developed for Rupture or Eviscerate builds.\n-For chose build use Glyph of Rupture or Glyph of Eviscerate.\n-For use Fan of Knives configure AoE Toggle key.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Combat_DarhangeR", queue, abilities, data)