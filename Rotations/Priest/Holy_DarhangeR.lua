local data = {"DarhangeR.lua"}

local popup_shown = false;
local queue = {
	"Window",
	"Universal pause",
	"Inner Fire",
	"Prayer of Fortitude",
	"Prayer of Spirit",
	"Prayer of Shadow Protection",
	"Fear Ward",			
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",		
	"Racial Stuff",
	"Shadowfiend",
	"Fade",
	"Desperate Prayer",	
	"Inner Focus",
	"Divine Hymn",
	"Tank Heal",
	"Guardian Spirit",
	"Flash Heal",
	"Prayer of Healing (Renew Build)",
	"Renew All",
	"Abolish Disease",
	"Dispel Magic",
	"Circle of Healing",
}
local queue2 = {
	"Window",	
	"Stutter cast pause",
	"Universal pause",
	"Inner Fire",
	"Prayer of Fortitude",
	"Prayer of Spirit",
	"Prayer of Shadow Protection",
	"Fear Ward",			
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",		
	"Racial Stuff",
	"Shadowfiend",
	"Fade",
	"Desperate Prayer",	
	"Inner Focus",
	"Divine Hymn",
	"Tank Heal",
	"Guardian Spirit",
	"Greater Heal",
	"Flash Heal",
	"Prayer of Healing",
	"Renew",
	"Abolish Disease",
	"Dispel Magic",
	"Circle of Healing",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
		if ni.data.darhanger.UniPause() then
			return true
		end
	end,
-----------------------------------
	["Inner Fire"] = function()
		if not ni.player.buff(48168)
		 and ni.spell.available(48168) then
			ni.spell.cast(48168)
			return true
		end
	end,
-----------------------------------
	["Prayer of Fortitude"] = function()
		if ni.player.buff(48162)
		 or not IsUsableSpell(GetSpellInfo(48162)) then 
		 return false
	end
		if ni.spell.available(48162)
		 and ni.spell.isinstant(48162) then
			ni.spell.cast(48162)	
			return true
		end
	end,
-----------------------------------
	["Prayer of Spirit"] = function()
		if ni.player.buffs("48074||57567")
		 or not IsUsableSpell(GetSpellInfo(48074)) then 
		 return false
	end
		if ni.spell.available(48074) 
		 and ni.spell.isinstant(48074) then
			ni.spell.cast(48074)	
			return true
		end
	end,
-----------------------------------
	["Prayer of Shadow Protection"] = function()
		if ni.player.buff(48170)
		 or not IsUsableSpell(GetSpellInfo(48170)) then 
		 return false
	end
		if ni.spell.available(48170)
		 and ni.spell.isinstant(48170) then
			ni.spell.cast(48170)	
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
	["Combat specific Pause"] = function()
		if UnitAffectingCombat("player") then
			return false
		end
		for i = 1, #ni.members do
		if UnitAffectingCombat(ni.members[i].unit) then
				return false
			end
		end
			return true
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
		 and ni.spell.valid("target", 48125, true, true) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 48125, true, true)
		 and ni.player.hp() < 20
		 and IsSpellKnown(alracial[i])
		 and ni.spell.available(alracial[i]) then 
					ni.spell.cast(alracial[i])
					return true
				end
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
	["Desperate Prayer"] = function()
		if ni.player.hp() < 20
		 and IsSpellKnown(48173)
		 and ni.spell.isinstant(48173) 
		 and ni.spell.available(48173) then
			ni.spell.cast(48173)
			return true
		end
	end,
-----------------------------------
	["Shadowfiend"] = function()
		if ni.player.power() < 37
		 and ni.spell.isinstant(34433)
		 and ni.spell.available(34433) then
			ni.spell.cast(34433, "target")
			return true
		end
	end,
-----------------------------------
	["Inner Focus"] = function()
		if ni.healing.averagehp(9) < 35
		 and ni.spell.isinstant(14751)
		 and ni.spell.available(14751)
		 and ni.spell.isinstant(48066)
		 and ni.spell.available(48066)
		 and ni.spell.available(64843)
		 and not ni.unit.debuff("player", 6788)
		 and not ni.unit.buff("player", 48066, "player") then
			ni.spell.cast(48066, "player")
			ni.spell.cast(14751)
			return true
		end
	end,
-----------------------------------
	["Divine Hymn"] = function()
		if ni.player.buff(14751)
		 and not ni.player.ismoving()
		 and ni.spell.available(64843)
		 and UnitChannelInfo("player") == nil then
			ni.spell.cast(64843)
			return true
		end
	end,
-----------------------------------
	["Tank Heal"] = function()
		local tank, offTank = ni.tanks()
		local seren, _, _, count = ni.player.buff(63734)
		-- Main Tank Heal
		if UnitExists(tank) then
		 local rnewtank, _, _, _, _, _, rnewtank_time = ni.unit.buff(tank, 48068, "player")
		 local pwstank, _, _, _, _, _, pwstank_time = ni.unit.buff(tank, 48066, "player")
		 local pmendtank = ni.unit.buff(tank, 48113, "player")
		 local ws = ni.unit.debuff(tank, 6788)
		-- Heal MT with Renew 
		if ni.spell.available(48068)
		 and ni.spell.isinstant(48068)
		 and (not rnewtank
		 or (rnewtank and rnewtank_time - GetTime() < 2))
		 and ni.spell.valid(tank, 48068, false, true, true) then
			ni.spell.cast(48068, tank)
			return true
		end
		-- Put PW:S on MT
		if ni.data.darhanger.youInInstance()
		 and ni.spell.available(48066)
		 and ni.spell.isinstant(48066)
		 and not ws
		 and (not pwstank
		 or (pwstank and pwstank_time - GetTime() < 0.7))
		 and ni.spell.valid(tank, 48066, false, true, true) then
			ni.spell.cast(48066, tank)
			return true
		end
		-- Put PoF Mending on MT
		 if ni.spell.available(48113)
		 and ni.spell.isinstant(48113)
		 and not pmendtank 
		 and ni.spell.available(48113)
		 and ni.spell.valid(tank, 48113, false, true, true) then
			ni.spell.cast(48113, tank)
			return true
		end
		-- Greater Heal on MT
		if tank ~= nil
		 and ni.unit.hp(tank) < 50
		 and (seren and count >= 2)
		 and not ni.player.ismoving()
		 and ni.spell.available(48063)
		 and ni.spell.valid(tank, 48063, false, true, true) then		 
			ni.spell.cast(48063, tank)
			return true
		end
		-- Flash Heal on MT
		if tank ~= nil
		and ni.unit.hp(tank) < 80
		and ni.spell.available()
		and not ni.player.ismoving()
		and ni.spell.valid(tank, 48071, false, true, true) then
			ni.spell.cast(48071, tank)	
			return
		end
		-- Binding Heal on MT
		if tank ~= nil
		 and ni.unit.hp(tank) < 75
		 and ni.player.hp() < 75	
		 and not ni.player.ismoving()
		 and ni.spell.available(48120)
		 and ni.spell.valid(tank, 48120, false, true, true) then
			ni.spell.cast(48120, tank)
			return
			end			
		end
		-- Off Tank heal
		if offTank ~= nil
		 and UnitExists(offTank) then
		 local rnewotank, _, _, _, _, _, rnewotank_time = ni.unit.buff(offTank, 48068, "player")
		 local pwotank, _, _, _, _, _, pwotank_time = ni.unit.buff(offTank, 48066, "player")
		 local ws = ni.unit.debuff(offTank, 6788)
		-- Heal Off with Renew 
		if ni.spell.available(48068)
		 and ni.spell.isinstant(48068) 
		 and (not rnewotank
		 or (rnewotank and rnewotank_time - GetTime() < 2))
		 and ni.spell.valid(offTank, 48068, false, true, true) then
			ni.spell.cast(48068, offTank)
			return true
		 end
		-- Put PW:S on Off
		if ni.data.darhanger.youInInstance()
		 and ni.spell.available(48066)
		 and ni.spell.isinstant(48066)
		 and not ws
		 and (not pwotank
		 or (pwotank and pwotank_time - GetTime() < 0.7))
		 and ni.spell.valid(offTank, 48066, false, true, true) then
			ni.spell.cast(48066, offTank)
			return true
		end
		-- Greater Heal on Off
		if offTank ~= nil
		 and ni.unit.hp(offTank) < 50
		 and (seren and count >= 2)
		 and not ni.player.ismoving()
		 and ni.spell.available(48063)
		 and ni.spell.valid(offTank, 48063, false, true, true) then		 
			ni.spell.cast(48063, offTank)
			return true
		end
		-- Flash Heal on Off
		if offTank ~= nil
		and ni.unit.hp(offTank) < 80
		and ni.spell.available()
		and not ni.player.ismoving()
		and ni.spell.valid(offTank, 48071, false, true, true) then
			ni.spell.cast(48071, offTank)	
			return
		end
		-- Binding Heal on Off
		if offTank ~= nil
		 and ni.unit.hp(offTank) < 75
		 and ni.player.hp() < 75	
		 and not ni.player.ismoving()
		 and ni.spell.available(48120)
		 and ni.spell.valid(offTank, 48120, false, true, true) then
			ni.spell.cast(48120, offTank)
			return
			end		
		end
	end,
-----------------------------------
	["Guardian Spirit"] = function()
		for i = 1, #ni.members do
		if  ni.members[i].hp < 20
		 and ni.spell.available(47788)
		 and ni.spell.isinstant(47788)
		 and ni.spell.available(48063)
		 and ni.spell.valid(ni.members[i].unit, 47788, false, true, true)
		 and ni.spell.valid(ni.members[i].unit, 48063, false, true, true) then
			ni.spell.cast(47788, ni.members[i].unit)
			ni.spell.cast(48063, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Circle of Healing"] = function()
		for i = 1, #ni.members do
		if ni.spell.available(48089)
		 and ni.spell.isinstant(48089) then 
		 -- Heal party with Circle
		if ni.healing.averagehp(3) < 85
		 and ni.members[i].hp < 85
		 and ni.spell.valid(ni.members[i].unit, 48089, false, true, true) then
			ni.spell.cast(48089, ni.members[i].unit)
			return true
			end
		end
		 -- Heal raid with Circle
		if not ni.player.hasglyph(55675)
		 and ni.data.darhanger.youInRaid()
		 and ni.healing.averagehp(4) < 85
		 and ni.members[i].hp < 85
		 and ni.spell.valid(ni.members[i].unit, 48089, false, true, true) then
			ni.spell.cast(48089, ni.members[i].unit)
			return true
		end
		-- Heal raid with Circle + Glyph
		if ni.player.hasglyph(55675)
		 and ni.data.darhanger.youInRaid()
		 and ni.members[i].hp < 85
		 and ni.healing.averagehp(5) < 85
		 and ni.spell.valid(ni.members[i].unit, 48089, false, true, true) then
			ni.spell.cast(48089, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Renew"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].hp < 90
		 and (ni.player.power() < 55
		 or ni.player.ismoving())
		 and ni.spell.available(48068)
		 and ni.spell.isinstant(48068)
		 and not ni.unit.buff(ni.members[i].unit, 48068, "player")
		 and ni.spell.valid(ni.members[i].unit, 48068, false, true, true) then
			ni.spell.cast(48068, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Renew All"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].hp < 95
		 and ni.spell.available(48068)
		 and ni.spell.isinstant(48068)
		 and not ni.unit.buff(ni.members[i].unit, 48068, "player")
		 and ni.spell.valid(ni.members[i].unit, 48068, false, true, true) then
			ni.spell.cast(48068, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Prayer of Healing (Renew Build)"] = function()
		local seren, _, _, count = ni.player.buff(63734)
		for i = 1, #ni.members do
		if ni.spell.available(48072)
		 and ni.spell.cd(48089) ~= 0
		 and not ni.player.ismoving() then 
		 -- Heal party with Prayer
		if ni.healing.averagehp(3) < 75
		 and ni.members[i].hp < 75
		 and ni.spell.valid(ni.members[i].unit, 48072, false, true, true) then
			ni.spell.cast(48072, ni.members[i].unit)
			return true
		end
		 -- Heal raid with Prayer
		if ni.data.darhanger.youInRaid()
		 and ni.healing.averagehp(4) < 75
		 and ni.members[i].hp < 75
		 and ni.spell.valid(ni.members[i].unit, 48072, false, true, true) then
			ni.spell.cast(48072, ni.members[i].unit)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Prayer of Healing"] = function()
		local seren, _, _, count = ni.player.buff(63734)
		for i = 1, #ni.members do
		if ni.spell.available(48072)
		 and (seren and count >= 2)
		 and ni.spell.cd(48089) ~= 0
		 and not ni.player.ismoving() then 
		 -- Heal party with Prayer
		if ni.healing.averagehp(3) < 75
		 and ni.members[i].hp < 75
		 and ni.spell.valid(ni.members[i].unit, 48072, false, true, true) then
			ni.spell.cast(48072, ni.members[i].unit)
			return true
		end
		 -- Heal raid with Prayer
		if ni.data.darhanger.youInRaid()
		 and ni.healing.averagehp(4) < 75
		 and ni.members[i].hp < 75
		 and ni.spell.valid(ni.members[i].unit, 48072, false, true, true) then
			ni.spell.cast(48072, ni.members[i].unit)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Greater Heal"] = function()
		local seren, _, _, count = ni.player.buff(63734)
		for i = 1, #ni.members do
		if ni.members[i].hp < 50
		 and (seren and count >= 2)
		 and ni.spell.available(48063)
		 and ni.spell.valid(ni.members[i].unit, 48063, false, true, true) then
			ni.spell.cast(48063, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Abolish Disease"] = function()
		local zone = GetZoneText()
		if zone == "The Ruby Sanctum" then
			return false
		end 
		for i = 1, #ni.members do
		if ni.unit.debufftype(ni.members[i].unit, "Disease")
		 and ni.spell.available(552)
		 and ni.spell.isinstant(552)
		 and ni.healing.candispel(ni.members[i].unit)
		 and GetTime() - ni.data.darhanger.LastDispel > 2
		 and not ni.unit.buff(ni.members[i].unit, 552)
		 and ni.spell.valid(ni.members[i].unit, 552, false, true, true) then
			ni.spell.cast(552, ni.members[i].unit)
			ni.data.darhanger.LastDispel = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Dispel Magic"] = function()
		local zone = GetZoneText()
		if zone == "The Ruby Sanctum" then
			return false
		end 
		for i = 1, #ni.members do
		if ni.unit.debufftype(ni.members[i].unit, "Magic")
		 and ni.spell.available(988)
		 and ni.spell.isinstant(988)
		 and ni.healing.candispel(ni.members[i].unit)
		 and GetTime() - ni.data.darhanger.LastDispel > 2
		 and ni.spell.valid(ni.members[i].unit, 988, false, true, true) then
			ni.spell.cast(988, ni.members[i].unit)
			ni.data.darhanger.LastDispel = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Flash Heal"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 70
		 and ni.spell.available(48071)
		 and ni.spell.valid(ni.members[i].unit, 48071, false, true, true) then
			ni.spell.cast(48071, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		  ni.debug.popup("Holy Priest by DarhangeR for 3.3.5a", 
		 "Welcome to Holy Priest Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For enable priority healing Main Tank & Off Tank put tank name to Tank Overrides and press Enable Main/Off\n-For chose Renew Build or Serendipity Build type: /renew")
		popup_shown = true;
		end 
	end,
}

local renewBuild = false;
	-- Priest stuff --
local function renew(msg)
	if msg == "on" then
	 renewBuild = true;
	elseif msg == "off" then
	 renewBuild = false;
	 else
	 print("Only commands are on/off\nFor enable Renew Build:\n/renew on\n/renew off");
	end
end
SLASH_RENEW1 = "/renew";
SlashCmdList["RENEW"] = renew;

local dynamicqueue = function()
    if renewBuild == true then
        return queue
    end
		return queue2
end

ni.bootstrap.rotation("Holy_DarhangeR", dynamicqueue, abilities, data)