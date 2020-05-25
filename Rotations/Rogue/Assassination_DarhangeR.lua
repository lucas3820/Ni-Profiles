local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",
	"Stutter cast pause",
	"Universal pause",
	"AutoTarget",
	"Poison Weapon",
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
	"Garrote/Ambush",
	"Cold Blood",
	"Vanish",
	"Rupture Dump",
	"Hunger For Blood",
	"Mutilate",
	"Slice and Dice",
	"Envenom",
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
    ["Poison Weapon"] = function()
		local mh, _, _, oh = GetWeaponEnchantInfo()
		if applypoison 
		 and GetTime() - applypoison > 4 then 
			applypoison = nil 
		end
		if UnitAffectingCombat("player") == nil 
		and applypoison == nil then
		applypoison = GetTime()
		if mh == nil 
		 and ni.player.hasitem(43231) then
			ni.player.useitem(43231)
			ni.player.useinventoryitem(16)
			return true
		end
		if oh == nil
		 and ni.player.hasitem(43233) then
			ni.player.useitem(43233)
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
		 and IsSpellInRange(GetSpellInfo(48638), "target") == 1 then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if IsSpellInRange(GetSpellInfo(48638), "target") == 1
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
		 and IsSpellInRange(GetSpellInfo(48638), "target") == 1 then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and IsSpellInRange(GetSpellInfo(48638), "target") == 1 then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0
		 and IsSpellInRange(GetSpellInfo(48638), "target") == 1 then
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
		 and ni.spell.available(51723)
		 and ni.spell.isinstant(51723)
		 and ni.spell.valid("target", 48638, true, true) then
			ni.spell.castat(51723, "target")
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
		local OGar = ni.data.darhanger.rogue.OGar()
		if ni.player.buff(1784)
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") ) then
		  if not OGar
		   and ni.player.isbehind("target")
		   and ni.spell.available(48676)
		   and ni.spell.valid("target", 48676, true, true) then
			  ni.spell.cast(48676, "target")
			  return true
		end
		  if OGar
		   and ni.player.isbehind("target")
		   and ni.spell.available(48691)
		   and ni.spell.valid("target", 48691, true, true) then
			  ni.spell.cast(48691, "target")
			  return true
			end
		end
	end,
-----------------------------------
	["Vanish"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") ) 
		 and not ni.player.buff(58427)
		 and ni.spell.isinstant(26889)
		 and ni.spell.available(26889)
		 and IsSpellInRange(GetSpellInfo(48638), "target") == 1 then
			ni.spell.cast(26889)
			return true
		end
	end,
-----------------------------------
	["Cold Blood"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and GetComboPoints("player") == 5
		 and IsUsableSpell(GetSpellInfo(57993))
		 and ni.spell.isinstant(14177)
		 and ni.spell.available(14177)
		 and ni.spell.available(57993)
		 and ni.spell.valid("target", 57993, true, true) then
			ni.spell.castspells("14177|57993")
			return true
		end
	end,
-----------------------------------
	["Rupture Dump"] = function()
	--Use Rapture when Hunger not usable
		local Rup = ni.data.darhanger.rogue.Rup()
		local Hunger = ni.data.darhanger.rogue.Hunger()
		 if GetComboPoints("player") > 1
		 and not IsUsableSpell(GetSpellInfo(51662))
		 and( Hunger == nil or ( Hunger - GetTime() <= 7 ) )
		 and ( not ni.player.buff(1784)
		 and not ni.spell.available(26889) 
		 or not IsUsableSpell(GetSpellInfo(51662)))
		 and ni.spell.isinstant(48672)
		 and ni.spell.valid("target", 48672, true, true) then
			ni.spell.cast(48672, "target")
			return true
		end
	end,
-----------------------------------
	["Hunger For Blood"] = function()
		local Hunger = ni.data.darhanger.rogue.Hunger()
		if IsUsableSpell(GetSpellInfo(51662))
		 and ni.spell.available(51662)
		 and ni.spell.isinstant(51662)
		 and( Hunger == nil or ( Hunger - GetTime() <= 3 ) )
		 and IsSpellInRange(GetSpellInfo(48638), "target") == 1  then
			ni.spell.cast(51662)
			return true
		end
	end,
-----------------------------------
	["Mutilate"] = function()
		if GetComboPoints("player") < 5
		 and ni.spell.available(48666)
		 and ni.spell.isinstant(48666)
		 and ni.spell.valid("target", 48666, true, true) then
			ni.spell.cast(48666, "target")
			return true
		end
	end,
-----------------------------------
	["Slice and Dice"] = function()
		local SnD = ni.data.darhanger.rogue.SnD()
		if GetComboPoints("player") > 3
		 and( SnD == nil or ( SnD - GetTime() <= 4 ) )
		 and ni.spell.available(6774)
		 and ni.spell.isinstant(6774)
		 and IsSpellInRange(GetSpellInfo(48638), "target") == 1  then
			ni.spell.cast(6774)
			return true
		end
	end,
-----------------------------------
	["Envenom"] = function()
		local Hunger = ni.data.darhanger.rogue.Hunger()
		local envenom = ni.data.darhanger.rogue.envenom()
		local SnD = ni.data.darhanger.rogue.SnD()
		if ni.spell.available(57993)
		 and Hunger
		 and ni.spell.isinstant(57993)
		 and IsUsableSpell(GetSpellInfo(57993)) 
		 and ni.spell.valid("target", 57993, true, true) then
		  if GetComboPoints("player") >= 5
		  and envenom == nil then
			ni.spell.cast(57993, "target")
			return true
          end
		  if GetComboPoints("player") >= 5
		  and ni.player.power() > 80 then
			ni.spell.cast(57993, "target")
			return true
          end
		  if GetComboPoints("player") >= 2
		  and ( SnD and SnD - GetTime() < 4 ) then
			ni.spell.cast(57993, "target")
			return true
			end
		end
	end,	  
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Assassination Rogue by DarhangeR", 
		 "Welcome to Assassination Rogue Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-Focus ally target for use TofT on it or put tank name to Tank Overrides and press Enable Main.\n-For use Fan of Knives configure AoE Toggle key.")		
		popup_shown = true;
		end 
	end,
}
	
ni.bootstrap.rotation("Assassination_DarhangeR", queue, abilities, data)