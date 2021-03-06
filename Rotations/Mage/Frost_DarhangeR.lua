local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",	
	"AutoTarget",
	"Universal pause",
	"Arcane Brilliance",
	"Molten Armor",
	"Focus Magic",
	"Summon Water Elemental (hasglyph)",	
	"Cancel Ice Block",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",		
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Counterspell (Interrupt)",
	"Freeze (Pet)",
	"Cancel Ice Block",
	"Evocation",
	"Evocation Healing",
	"Spellsteal",
	"Icy Veins",
	"Mirror Image",
	"Summon Water Elemental",
	"Cold Snap",
	"Frostfire Bolt (Non Cast)",
	"Blizzard",
	"Cone of Cold",
	"Remove Curse (Player)",	
	"Deep Freeze",
	"Ice Lance",
	"Frostbolt",	
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
	["Arcane Brilliance"] = function()
		if ni.player.buffs("43002||61316||57567||42995||61024")
		 or not IsUsableSpell(GetSpellInfo(43002)) then 
		 return false
	end
		if ni.spell.available(43002)
		 and ni.spell.isinstant(43002) then
			ni.spell.cast(43002)	
			return true
		end
	end,
-----------------------------------
	["Molten Armor"] = function()
		if not ni.player.buff(43046)
		 and ni.spell.isinstant(43046) 
		 and ni.spell.available(43046) then
			ni.spell.cast(43046)
			return true
		end
	end,
-----------------------------------
	["Focus Magic"] = function()
		if IsSpellKnown(54646)
		 and UnitExists("focus")
		 and UnitInRange("focus")
		 and ni.spell.isinstant(54646) 
		 and ni.spell.available(54646)
		 and not UnitIsDeadOrGhost("focus")
		 and not ni.unit.buff("focus", 54646) then
			ni.spell.cast(54646, "focus")
		end
	end,
-----------------------------------
	["Summon Water Elemental (hasglyph)"] = function()
		if ni.player.hasglyph(70937)
		 and not ni.player.buff(61431)
		 and not UnitExists("playerpet")
		 and ni.spell.available(31687)
		 and IsUsableSpell(GetSpellInfo(31687)) then
			ni.spell.cast(31687)
			return true
		end
	end,
-----------------------------------
	["Cancel Ice Block"] = function()
			local p="player" for i = 1,40 
			do local _,_,_,_,_,_,_,u,_,_,s=UnitBuff(p,i)		
			if ni.player.hp() > 60
			and u==p and s==45438 then
				CancelUnitBuff(p,i) 
				break;
			end
		end 
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if ni.data.darhanger.casterStop()
		 or ni.data.darhanger.PlayerDebuffs()
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
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 42897) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 42897)
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
		 and ni.data.darhanger.CDsaverTTD()
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.valid("target", 42842)  then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 42842) then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 42842) then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------
	["Pet Attack/Follow"] = function()
		if ni.unit.hp("playerpet") < 20
		 and UnitExists("playerpet")
		 and UnitExists("target")
		 and UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then
			ni.data.darhanger.petFollow()
		 else
		if UnitAffectingCombat("player")
		 and UnitExists("playerpet")
		 and ni.unit.hp("playerpet") > 60
		 and UnitExists("target")
		 and not UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then 
			ni.data.darhanger.petAttack()
			end
		end
	end,
-----------------------------------
	["Counterspell (Interrupt)"] = function()
		if ni.spell.shouldinterrupt("target")
		 and ni.spell.available(2139)
		 and ni.spell.isinstant(2139) 
		 and GetTime() - ni.data.darhanger.LastInterrupt > 9
		 and ni.spell.valid("target", 2139, true, true)  then
			ni.spell.castinterrupt("target")
			ni.data.darhanger.LastInterrupt = GetTime()
			return true
		end
	end,
-----------------------------------		
	["Freeze (Pet)"] = function()
		if ni.rotation.custommod()
		 and IsSpellKnown(33395, true)
		 and GetSpellCooldown(33395) == 0 then
			ni.spell.castat(33395, "target")
			return true
		end
	end,
-----------------------------------	
	["Ice Block"] = function()
		if ni.player.hp() < 23
		 and ni.spell.isinstant(45438)
		 and ni.spell.available(45438) then
			ni.spell.cast(45438)
			return true
		end
	end,
-----------------------------------
	["Evocation"] = function()
		if ni.player.power() < 20
		 and not ni.player.ismoving()
		 and UnitChannelInfo("player") == nil
		 and ni.spell.available(12051) then
			ni.spell.cast(12051)
			return true
		end
	end,
-----------------------------------
	["Evocation Healing"] = function()
		if ni.player.hp() < 30
		 and not ni.player.ismoving()
		 and ni.player.hasglyph(56380)
		 and UnitChannelInfo("player") == nil
		 and ni.spell.available(12051) then
			ni.spell.cast(12051)
			return true
		end
	end,
-----------------------------------
	["Spellsteal"] = function()
		local buff = { 43242, 31884, 2825, 32182, 1719, 17, 33763, 6940, 67108, 67107, 66228, 67009 }
		for i,v in ipairs(buff) do
		 local _,_,_,_,_,_,_,_,isStealable = ni.unit.buff("target",v)
		 if isStealable
		 and ni.spell.isinstant(30449) 
		 and ni.spell.available(30449)
		 and ni.spell.valid("target", 30449, true, true) then
			ni.spell.cast(30449, "target")
			return true
			end
		end
	end,
-----------------------------------
	["Icy Veins"] = function()
		if IsSpellKnown(12472)
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.isinstant(12472) 
		 and ni.spell.available(12472)
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 42842) then
			ni.spell.cast(12472)
			return true
		end
	end,
-----------------------------------
	["Mirror Image"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.isinstant(55342) 
		 and ni.spell.available(55342)
		 and ni.data.darhanger.CDsaverTTD()
		 and ni.spell.valid("target", 42842) then
			ni.spell.cast(55342, "target")
			ni.player.runtext("/petattack")
			return true
		end
	end,
-----------------------------------
	["Summon Water Elemental"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and not UnitExists("playerpet")
		 and ni.spell.isinstant(31687) 
		 and ni.spell.available(31687)
		 and ni.data.darhanger.CDsaverTTD()
		 and IsUsableSpell(GetSpellInfo(31687)) then
			ni.spell.cast(31687)
			return true
		end
	end,
-----------------------------------
	["Cold Snap"] = function()
		if not ni.spell.available(12472)
		 and not ni.player.buff(12472)
		 and ni.spell.isinstant(11958) 
		 and ni.spell.available(11958)
		 and ni.data.darhanger.CDsaverTTD()
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.valid("target", 42842) then
			ni.spell.cast(11958)
			return true
		end
	end,
-----------------------------------
	["Frostfire Bolt (Non Cast)"] = function()
		if ni.player.buff(57761)
		 and ni.spell.isinstant(47610) 
		 and ni.spell.available(47610)
		 and ni.spell.valid("target", 47610, true, true) then
			ni.spell.cast(47610, "target")
			return true
		end
	end,
-----------------------------------
	["Deep Freeze"] = function()
		local fnova = ni.data.darhanger.mage.fnova()
		local fbite = ni.data.darhanger.mage.fbite()
		local freeze = ni.data.darhanger.mage.freeze()
		local FoF = ni.data.darhanger.mage.FoF()
		if ( fnova or fbite or freeze or FoF )
		 and ni.spell.isinstant(44572) 
		 and ni.spell.available(44572)
		 and ni.spell.valid("target", 44572, true, true) then
			ni.spell.cast(44572, "target")
			return true
		end
	end,
-----------------------------------
	["Ice Lance"] = function()
		local fnova = ni.data.darhanger.mage.fnova()
		local fbite = ni.data.darhanger.mage.fbite()
		local freeze = ni.data.darhanger.mage.freeze()
		local FoF = ni.data.darhanger.mage.FoF()
		if ( fnova or fbite or freeze or FoF or ni.player.ismoving() )
		 and ni.spell.isinstant(42914) 
		 and ni.spell.available(42914)
		 and not ni.spell.available(44572)
		 and ni.spell.valid("target", 42914, true, true) then
			ni.spell.cast(42914, "target")
			return true
		end
	end,
-----------------------------------
	["Frostbolt"] = function()
		if ni.spell.available(42842)
		 and not ni.player.ismoving()
		 and ni.spell.valid("target", 42842, true, true) then
			ni.spell.cast(42842, "target")
			return true
		end
	end,
-----------------------------------
	["Remove Curse (Player)"] = function()
		 if ni.player.debufftype("Curse")
		  and ni.spell.isinstant(475)
		  and ni.spell.available(475)
		  and ni.healing.candispel("player")
		  and GetTime() - ni.data.darhanger.LastDispel > 5
		  and ni.spell.valid("player", 475, false, true, true) then
			ni.spell.cast(475, "player")
			ni.data.darhanger.LastDispel = GetTime()
			return true
		end
	end,
-----------------------------------
	["Cone of Cold"] = function()	
		if ni.spell.available(42931)
		 and ni.player.distance("target") < 6
		 and ni.spell.isinstant(44572) then
			ni.spell.cast(42931)
			return true
		end
	end,
-----------------------------------
	["Blizzard"] = function()
		if ni.vars.combat.aoe
		 and not ni.player.ismoving()
		 and ni.spell.available(42940) then
			ni.spell.castat(42940, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Frost Mage by DarhangeR for 3.3.5a", 
		 "Welcome to Frost Mage Profile! Support and more in Discord > https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-For use Blizzard configure AoE Toggle key.\n-Focus target for use Focus Magic (If learned).")		
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Frost_DarhangeR", queue, abilities, data)