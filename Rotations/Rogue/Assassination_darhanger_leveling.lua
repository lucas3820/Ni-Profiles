local data = ni.utils.require("darhanger_leveling.lua");

local poisonsmainhand = 
{43231, 43230, 21927, 8928, 8927, 8926, 6950, 6949, 6947}
local poisonsoffhand = 
{43233, 43232, 22054, 22053, 20844, 8985, 8984, 2893, 2892 }


local mainhandname = nil;
local offhandname = nil;
local function GetBestPoisonMainHand()
local level = UnitLevel("player")
for _, itemid in pairs (poisonsmainhand) do
local name, _, _, _, req = GetItemInfo(itemid)
	if GetItemCount(itemid, false, false) > 0 then
	if name and level >= req then
	mainhandname = name	
	--print(mainhandname)
	return true;
	end
	end
	end
	mainhandname = nil;
	return false;
	end
	
local function GetBestPoisonOffHand()
local level = UnitLevel("player")
for _, itemid in pairs (poisonsoffhand) do
local name, _, _, _, req = GetItemInfo(itemid)
	if GetItemCount(itemid, false, false) > 0 then
	if name and level >= req then
	offhandname = name	
	--print(offhandname)
	return true;
	end
	end
	end
	offhandname = nil;
	return false;
	end

--Spells Covnerted to Name
local sinisterstrike = GetSpellInfo(48638)
local fanofknives = GetSpellInfo(51723)
local garrote = GetSpellInfo(48676)
local ambush = GetSpellInfo(48691)
local vanish = GetSpellInfo(26889)
local envenom = GetSpellInfo(57993)
local rupture = GetSpellInfo(48672)
local mutilate = GetSpellInfo(48666)
local sliceanddice = GetSpellInfo(6774)
local eviscerate = GetSpellInfo(6760)
local backstab = GetSpellInfo(2590)

local popup_shown = false;
local queue = {	
	"Window",
	"Poison Weapon",
	"Universal pause",
	"Combat specific Pause",
	"Auto Attack",
	"Healthstone (Use)",
	"Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Kick (Interrupt)",
	"Tricks of the Trade",
	"Fan of Knives",
	"Riposte",
	"Garrote/Ambush",
	"Cold Blood",
	"Vanish",
	"Rupture Dump",
	"Hunger For Blood",
	"Mutilate",
	--"Backstab",
	"Sinister Strike",
	"Slice and Dice",
	"Eviscerate low T2D",
	"Eviscerate",
	"Envenom"
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
			if ni.data.darhanger_leveling.UniPause() then
			return true
		end
	end,
	
-----------------------------------
	["Auto Attack"] = function()
		if not IsCurrentSpell(6603)
		and not ni.player.buff(1784) then
			ni.spell.cast(6603);
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
        local mh, _, _, oh = GetWeaponEnchantInfo()
        if applypoison 
         and GetTime() - applypoison > 4 then 
            applypoison = nil 
        end
        if UnitAffectingCombat("player") == nil 
		and ni.data.darhanger_leveling.UniPausenoatk()
        and applypoison == nil then
        applypoison = GetTime()
        if not mh and GetBestPoisonMainHand() then
            ni.player.useitem(mainhandname)
            ni.player.useinventoryitem(16)
            ni.player.runtext("/click StaticPopup1Button1")
            return true
        end
        if not oh and GetBestPoisonOffHand()
        and UnitLevel("player") >= 30 then
            ni.player.useitem(offhandname)
            ni.player.useinventoryitem(17)
			ni.player.runtext("/click StaticPopup1Button1")
            return true
            end
            if not oh and GetBestPoisonMainHand()  
            and UnitLevel("player") < 30 then
            ni.player.useitem(mainhandname)
            ni.player.useinventoryitem(17)
            ni.player.runtext("/click StaticPopup1Button1")
            return true
        end
        end
    end,
-----------------------------------
	["Combat specific Pause"] = function()
		if ni.data.darhanger_leveling.meleeStop()
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
		 and GetTime() - ni.data.darhanger_leveling.LastInterrupt > 9
		 and ni.spell.valid("target", 1766, true, true)  then
			ni.spell.castinterrupt("target")
			ni.data.darhanger_leveling.LastInterrupt  = GetTime()
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
	["Garrote/Ambush"] = function()
		local OGar = ni.data.darhanger_leveling.rogue.OGar()
		if ni.player.buff(1784)
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") ) then
		  if not OGar
		   and ni.player.isbehind("target")
		   and ni.spell.available(garrote)
		   and ni.spell.valid("target", garrote, true, true) then
			  ni.spell.cast(garrote, "target")
			  return true
		end
		  if OGar
		   and ni.player.isbehind("target")
		   and ni.spell.available(ambush)
		   and ni.spell.valid("target", ambush, true, true) then
			  ni.spell.cast(ambush, "target")
			  return true
			end
		end
	end,
-----------------------------------
	["Vanish"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") ) 
		 and not ni.player.buff(58427)
		 and ni.spell.isinstant(vanish)
		 and ni.spell.available(vanish)
		 and IsSpellInRange(sinisterstrike, "target") == 1 then
			ni.spell.cast(vanish)
			return true
		end
	end,
-----------------------------------
	["Cold Blood"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and GetComboPoints("player") == 5
		 and IsUsableSpell(envenom)
		 and ni.spell.isinstant(14177)
		 and ni.spell.available(14177)
		 and ni.spell.available(envenom)
		 and ni.spell.valid("target", envenom, true, true) then
			ni.spell.castspells("14177|envenom")
			return true
		end
	end,
-----------------------------------
	["Rupture Dump"] = function()
	--Use Rapture when Hunger not usable
		local Rup = ni.data.darhanger_leveling.rogue.Rup()
		local Hunger = ni.data.darhanger_leveling.rogue.Hunger()
		 if GetComboPoints("player") > 1
		 and not IsUsableSpell(GetSpellInfo(51662))
		 and( Hunger == nil or ( Hunger - GetTime() <= 7 ) )
		 and ( not ni.player.buff(1784)
		 and not ni.spell.available(vanish) 
		 or not IsUsableSpell(GetSpellInfo(51662)))
		 and ni.spell.isinstant(rupture)
		 and ni.spell.valid("target", rupture, true, true) then
			ni.spell.cast(rupture, "target")
			return true
		end
	end,
-----------------------------------
	["Hunger For Blood"] = function()
		local Hunger = ni.data.darhanger_leveling.rogue.Hunger()
		if IsUsableSpell(GetSpellInfo(51662))
		 and ni.spell.available(51662)
		 and ni.spell.isinstant(51662)
		 and( Hunger == nil or ( Hunger - GetTime() <= 3 ) )
		 and IsSpellInRange(sinisterstrike, "target") == 1  then
			ni.spell.cast(51662)
			return true
		end
	end,
-----------------------------------
	["Sinister Strike"] = function()
		if GetComboPoints("player") < 5
		 and not ni.spell.available(mutilate)
		 and UnitLevel("player") < 50
         and ni.spell.available(sinisterstrike)
		 and ni.spell.isinstant(sinisterstrike)
		 and ni.spell.valid("target", sinisterstrike, true, true) then
			ni.spell.cast(sinisterstrike, "target")
			return true
		end
	end,
	-----------------------------------
	["Backstab"] = function()
		if GetComboPoints("player") < 5
		 and not ni.spell.available(mutilate)
		 and ni.player.isbehind("target")
         and ni.spell.available(backstab)
		 and ni.spell.isinstant(backstab)
		 and ni.spell.valid("target", backstab, true, true, true) then
			ni.spell.cast(backstab, "target")
			return true
		end
	end,
	
	["Eviscerate"] = function()
		if GetComboPoints("player") >= 5
		 and not ni.spell.available(envenom)
         and ni.spell.available(eviscerate)
		 and ni.spell.isinstant(eviscerate)
		 and ni.spell.valid("target", eviscerate, true, true) then
			ni.spell.cast(eviscerate, "target")
			return true
		end
	end,
	
	["Eviscerate low T2D"] = function()
		if GetComboPoints("player") >= 2
		 and not ni.spell.available(envenom)
		 and ni.unit.ttd("target") < 5
         and ni.spell.available(eviscerate)
		 and ni.spell.isinstant(eviscerate)
		 and ni.spell.valid("target", eviscerate, true, true) then
			ni.spell.cast(eviscerate, "target")
			return true
		end
	end,
	["Mutilate"] = function()
		if GetComboPoints("player") < 5
		 and ni.spell.available(mutilate)
		 and ni.spell.isinstant(mutilate)
		 and ni.spell.valid("target", mutilate, true, true) then
			ni.spell.cast(mutilate, "target")
			return true
		end
	end,
-----------------------------------
	["Slice and Dice"] = function()
		local SnD = ni.data.darhanger_leveling.rogue.SnD()
		if GetComboPoints("player") > 3
		 and( SnD == nil or ( SnD - GetTime() <= 4 ) )
		 and ni.spell.available(sliceanddice)
		 and ni.spell.isinstant(sliceanddice)
		 and IsSpellInRange(sinisterstrike, "target") == 1  then
			ni.spell.cast(sliceanddice)
			return true
		end
	end,
-----------------------------------
	["Envenom"] = function()
		local Hunger = ni.data.darhanger_leveling.rogue.Hunger()
		local envenomdata = ni.data.darhanger_leveling.rogue.envenom()
		local SnD = ni.data.darhanger_leveling.rogue.SnD()
		if ni.spell.available(envenom)
		 and Hunger
		 and ni.spell.isinstant(envenom)
		 and ni.spell.valid("target", envenom, true, true) then
		  if GetComboPoints("player") >= 5
		  and envenomdata == nil then
			ni.spell.cast(envenom, "target")
			return true
          end
		  if GetComboPoints("player") >= 5
		  and ni.player.power() > 60 then
			ni.spell.cast(envenom, "target")
			return true
          end
		  if GetComboPoints("player") >= 2
		  and ( SnD and SnD - GetTime() < 4 ) then
			ni.spell.cast(envenom, "target")
			return true
			end
		end
	end,	  
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Assassination Rogue by darhanger -- Modified by Xcesius for leveling", 
		 "Welcome to Assassination Rogue Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-Focus ally target for use TofT on it or put tank name to Tank Overrides and press Enable Main.\n-For use Fan of Knives configure AoE Toggle key.")		
		popup_shown = true;
		end 
	end,
}
	
ni.bootstrap.profile("Assassination_darhanger_leveling", queue, abilities);