local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",	
	"AutoTarget",
	"Universal pause",
	"Life Tap (Regen)",
	"Spell Stone",
	"Soulstone",
	"Healthstone",	
	"Fel Armor",
	"Fel Domination",
	"Summon pet (Fellhunter)",
	"Soul Link",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",		
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Spell Lock (Interrupt)",
	"Soulshatter",
	"Shadowflame",		
	"Life Tap (Glyph Buff)",
	"Life Tap",
	"Death Coil",
	"Shadow Bolt (Non cast)",
	"Curse of Elements",
	"Shadow Bolt (Shadow Mastery Check)",
	"Seed of Corruption",
	"Corruption AoE",
	"Life Tap (Moving)",
	"Haunt",
	"Unstable Affliction",
	"Corruption",
	"Curse of Agony",		
	"Drain Soul",
	"Shadow Bolt",
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
	["Spell Stone"] = function()
		if not GetWeaponEnchantInfo() 
		 and not ni.player.ismoving()
		 and not UnitAffectingCombat("player") then
		 if not ni.player.hasitem(41196)
		 and IsUsableSpell(GetSpellInfo(47888))
		 and ni.spell.available(47888) then
			ni.spell.cast(47888)
			return true
		 else
			ni.player.useitem(41196)
			ni.player.useinventoryitem(16)
			return true
			end
		end
	end,
-----------------------------------
	["Soulstone"] = function()
		if not ni.player.hasitem(36895)
		 and not ni.player.ismoving()
		 and not UnitAffectingCombat("player")
		 and IsUsableSpell(GetSpellInfo(47884))
		 and ni.spell.available(47884) then
			ni.spell.cast(47884)
			return true
		 else
		 if UnitExists("focus")
		 and UnitInRange("focus")
		 and ni.player.hasitem(36895)
		 and not UnitIsDeadOrGhost("focus")
		 and not ni.unit.buff("focus", 47883)
		 and not ni.player.ismoving()
		 and ni.player.itemcd(36895) == 0 then
			ni.player.useitem(36895, "focus")
			return true
			end
		end
	end,
-----------------------------------
	["Healthstone"] = function()
		local hstones = { 36892, 36893, 36894 }
		if ni.data.darhanger.warlock.Stones == nil then
			for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do
			for i = 1, #hstones do
			if GetContainerItemID(b, s) == hstones[i] then
				Stones = true;
			break
						end
					end
				end
			end
		end
		if Stones == nil
		and IsUsableSpell(GetSpellInfo(47878))
		and ni.spell.available(47878)
		and not ni.player.ismoving()
		and not UnitAffectingCombat("player") then
			ni.spell.cast(47878)
			return true
		end
	end,
-----------------------------------
	["Fel Armor"] = function()
		if not ni.player.buff(47893)
		 and ni.spell.available(47893)
		 and ni.spell.isinstant(47893) then
			ni.spell.cast(47893)
			return true
		end
	end,
-----------------------------------
	["Fel Domination"] = function()
		if not UnitExists("playerpet")
		 and ni.spell.isinstant(18708)
		 and ni.spell.available(ni.data.darhanger.warlock.petAffli)
		 and IsUsableSpell(GetSpellInfo(ni.data.darhanger.warlock.petAffli))
		 and ni.spell.available(18708) then
			ni.spell.cast(18708)
			return true
		end
	end,
-----------------------------------
	["Summon pet (Fellhunter)"] = function()
		if not UnitExists("playerpet")
		 and not ni.player.buff(61431)
		 and not ni.player.ismoving()
		 and not UnitAffectingCombat("player")
		 and IsUsableSpell(GetSpellInfo(ni.data.darhanger.warlock.petAffli))
		 and ni.spell.available(ni.data.darhanger.warlock.petAffli)
		 and GetTime() - ni.data.darhanger.warlock.LastSummon > 2 then
			ni.spell.cast(ni.data.darhanger.warlock.petAffli)
			ni.data.darhanger.warlock.LastSummon = GetTime()
			return true
		end
	end,
-----------------------------------
	["Soul Link"] = function()
		if ni.spell.available(19028)
		 and UnitExists("playerpet")
		 and not ni.player.buff(19028)
		 and ni.spell.isinstant(19028) then
			ni.spell.cast(19028)
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
	["Life Tap (Regen)"] = function()
		if not UnitAffectingCombat("player")
		 and ni.player.power() < 85
		 and ni.player.hp() > 35
		 and ni.spell.isinstant(57946) then
			ni.spell.cast(57946)
			return true
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
			if ni.player.power() < 35
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
		 and ni.data.darhanger.forsaken()
		 and ni.spell.available(7744) then
				ni.spell.cast(7744)
				return true
		end
		--- Horde race
		for i = 1, #hracial do
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsSpellKnown(hracial[i])
		 and ni.spell.available(hracial[i])
		 and ni.spell.valid("target", 47809) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 47809)
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
		 and ni.spell.valid("target", 47809) then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.spell.valid("target", 47809) then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.spell.valid("target", 47809) then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------		
	["Spell Lock (Interrupt)"] = function()
		if ni.spell.shouldinterrupt("target")
		 and IsSpellKnown(19647, true)
		 and GetSpellCooldown(19647) == 0
		 and GetTime() - ni.data.darhanger.LastInterrupt > 9 then
			ni.spell.castinterrupt("target")
			ni.data.darhanger.LastInterrupt = GetTime()
			return true
		end
	end,
-----------------------------------	
	["Soulshatter"] = function()
		if #ni.members > 1
		 and ni.unit.threat("player") >= 2
		 and ni.spell.cd(29858) == 0
		 and ni.spell.isinstant(29858) 
		 and IsUsableSpell(GetSpellInfo(29858)) then 
			ni.spell.cast(29858)
			return true
		end
	end,
-----------------------------------
	["Shadowflame"] = function()	
		if ni.player.distance("target") < 6
		 and ni.spell.available(61290)
		 and ni.spell.isinstant(61290) then
			ni.spell.cast(61290)
			return true
		end
	end,
-----------------------------------
	["Life Tap (Glyph Buff)"] = function()
		if ni.player.hasglyph(63320)
		 and not ni.player.buff(63321)
		 and ni.spell.isinstant(57946) then
			ni.spell.cast(57946)
			return true
		end
	end,
-----------------------------------
	["Life Tap"] = function()
		if ni.player.power() <= 20
		 and ni.player.hp() > 50
		 and ni.spell.isinstant(57946) then
			ni.spell.cast(57946)
			return true
		end
	end,
-----------------------------------
	["Life Tap (Moving)"] = function()
		local elem = ni.data.darhanger.warlock.elem()
		local CotE = ni.data.darhanger.warlock.CotE()
		local eplag = ni.data.darhanger.warlock.eplag()
		local earmoon = ni.data.darhanger.warlock.earmoon()
		local agony = ni.data.darhanger.warlock.agony()
		if ni.player.ismoving()
		 and ni.player.power() < 75
		 and ni.player.hp() > 50
		 and (elem or CotE or eplag or earmoon or agony)
		 and ni.unit.debuffremaining("target", 47813, "player")
		 and ni.unit.debuffremaining("target", 59164, "player")
		 and ni.unit.debuffremaining("target", 47843, "player")
		 and ni.spell.isinstant(57946) then
			ni.spell.cast(57946)
			return true
		end
	end,
-----------------------------------
	["Death Coil"] = function()
		if ni.player.hp() < 47
		 and ni.spell.available(47860)
		 and ni.spell.isinstant(47860)
		 and ni.spell.valid("target", 47860, true, true) then
			ni.spell.cast(47860, "target")
			return true
		end
	end,
-----------------------------------
	["Seed of Corruption"] = function()
	    local seed = ni.data.darhanger.warlock.seed()
		if ni.vars.combat.aoe
		 and not seed
		 and ni.spell.available(47836)
		 and ni.spell.valid("target", 47836, false, true, true) then
			ni.spell.cast(47836, "target")
			return true
		end
	end,
-----------------------------------
	["Shadow Bolt (Non cast)"] = function()
		if ( ni.player.buff(17941) 
		 or ni.player.buff(34936) )
		 and ni.spell.available(47809)
		 and ni.spell.valid("target", 47809, true, true) then
			ni.spell.cast(47809, "target")
			return true
		end
	end,
-----------------------------------
	["Shadow Bolt (Shadow Mastery Check)"] = function()
		if select(5, GetTalentInfo(3,1)) >= 4
		 and not ni.unit.debuff("target", 17800)
		 and not ni.unit.debuff("target", 22959)
		 and ni.spell.available(47809)
		 and ni.spell.valid("target", 47809, true, true)
		 and GetTime() - ni.data.darhanger.warlock.LastShadowbolt > 3 then
			ni.spell.cast(47809, "target")
			ni.data.darhanger.warlock.LastShadowbolt = GetTime()
			return true
		end
	end,
-----------------------------------
	["Curse of Elements"] = function()
		local elem = ni.data.darhanger.warlock.elem()
		local CotE = ni.data.darhanger.warlock.CotE()
		local eplag = ni.data.darhanger.warlock.eplag()
		local earmoon = ni.data.darhanger.warlock.earmoon()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") 
		or UnitHealthMax("target") > 450000 )
		 and not (elem or CotE or eplag or earmoon)
		 and ni.spell.available(47865)
		 and ni.spell.valid("target", 47865, false, true, true)	
		 and GetTime() - ni.data.darhanger.warlock.LastCurse > 2 then
			ni.spell.cast(47865, "target")
			ni.data.darhanger.warlock.LastCurse = GetTime()
			return true
		end
	end,
-----------------------------------
	["Corruption AoE"] = function()
		local enemies;
		if UnitExists("target")
		 and ni.spell.available(47813)
		 and ni.spell.isinstant(47813)
		 and UnitCanAttack("player", "target") then
			enemies = ni.unit.enemiesinrange("target", 15)
			for i = 1, #enemies do
				local tar = enemies[i].guid; 
				if ni.unit.creaturetype(enemies[i].guid) ~= 8
				 and ni.unit.creaturetype(enemies[i].guid) ~= 11
				 and not ni.unit.debuffs(tar, "23920||35399||69056")
				 and not ni.unit.debuff(tar, 47813, "player")
				 and not ni.unit.debuff(tar, 47836, "player")
				 and ni.spell.valid(enemies[i].guid, 47813, false, true, true) then
					ni.spell.cast(47813, tar)
					return true
				end
			end
		end
	end,
-----------------------------------
	["Haunt"] = function()
		if not ni.player.ismoving()
		 and ni.spell.available(59164)
		 and ni.spell.valid("target", 59164, true, true)
		 and ni.unit.debuffremaining("target", 59164, "player") < ni.spell.casttime(59164)
		 and GetTime() - ni.data.darhanger.warlock.LastHaunt > 2 then
			ni.spell.cast(59164, "target")
			ni.data.darhanger.warlock.LastHaunt = GetTime()
			return true
		end
	end,
-----------------------------------
	["Corruption"] = function()
		local corruption = ni.data.darhanger.warlock.corruption()
		local seed = ni.data.darhanger.warlock.seed()	
		if ni.spell.available(47813)
		 and not corruption
		 and not seed
		 and ni.spell.isinstant(47813)
		 and ni.spell.valid("target", 47813, false, true, true)
		 and GetTime() - ni.data.darhanger.warlock.LastCorrupt > 1.5 then
			ni.spell.cast(47813, "target")
			ni.data.darhanger.warlock.LastCorrupt = GetTime()
			return true
		end
	end,	
-----------------------------------
	["Unstable Affliction"] = function()
		if not ni.player.ismoving()
		 and ni.unit.debuffremaining("target", 47843, "player") < ni.spell.casttime(47843)
		 and ni.spell.available(47843)
		 and ni.spell.valid("target", 47843, false, true, true)
		 and GetTime() - ni.data.darhanger.warlock.LastUA > 2 then
			ni.spell.cast(47843, "target")
			ni.data.darhanger.warlock.LastUA = GetTime()
			return true
		end
	end,
-----------------------------------
	["Curse of Agony"] = function()
		local elem = ni.data.darhanger.warlock.elem()
		local doom = ni.data.darhanger.warlock.doom()
		local agony = ni.data.darhanger.warlock.agony()
		if not elem
		 and not doom
		 and not agony
		 and ni.spell.available(47864)
		 and ni.spell.isinstant(47864)
		 and ni.spell.valid("target", 47864, false, true, true)
		 and GetTime() - ni.data.darhanger.warlock.LastCurse > 1 then
			ni.spell.cast(47864, "target")
			ni.data.darhanger.warlock.LastCurse = GetTime()
			return true
		end
	end,
-----------------------------------
	["Drain Soul"] = function()
		local haunt = ni.data.darhanger.warlock.haunt()
		if not ni.player.ismoving()
		 and haunt
		 and ni.unit.hp("target") <= 25
		 and ni.spell.available(47855)
		 and ni.spell.valid("target", 47855, true, true) then
			ni.spell.cast(47855, "target")
			return true
		end
	end,
-----------------------------------
	["Shadow Bolt"] = function()
		if not ni.player.ismoving()
		 and ni.spell.available(47809)
		 and ni.spell.valid("target", 47809, true, true) then
			ni.spell.cast(47809, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Affliction Warlock by DarhangeR -- Modified by Xcesius for leveling", 
		 "Welcome to Affliction Warlock Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For use Seed of Corruption configure AoE Toggle key.\n-Focus target for use Soulstone.\n-For better experience make Pet passive.")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.rotation("Affliction_DarhangeR", queue, abilities, data)