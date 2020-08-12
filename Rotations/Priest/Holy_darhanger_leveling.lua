local data = {"darhanger_leveling.lua"}

local innerfire = GetSpellInfo(48168)
local prayeroffortitude = GetSpellInfo(48162)
local prayerofspirit = GetSpellInfo(48074)
local felintelligence = GetSpellInfo(57567)
local prayerofshadowprotection = GetSpellInfo(48170)
local shadowfiend = GetSpellInfo(34433)
local desperateprayer = GetSpellInfo(48173)
local divinehymn = GetSpellInfo(64843)
local painsupression = GetSpellInfo(33206)
local powerwordshield = GetSpellInfo(48066)
local prayerofmending = GetSpellInfo(48113)
local prayerofhealing = GetSpellInfo(48072)
local renew = GetSpellInfo(48068)
local biningheal = GetSpellInfo(48120)
local flashheal = GetSpellInfo(48071)
local penance = GetSpellInfo(53007)
local greaterheal = GetSpellInfo(48063)
local circleofhealing = GetSpellInfo(48089)


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
			if ni.data.darhanger_leveling.UniPause() then
			return true
		end
	end,
-----------------------------------
	["Inner Fire"] = function()
		if not ni.player.buff(innerfire)
		 and ni.spell.available(innerfire) then
			ni.spell.cast(innerfire)
			return true
		end
	end,
-----------------------------------
	["Prayer of Fortitude"] = function()
		if ni.player.buff(prayeroffortitude)
		 or not IsUsableSpell(prayeroffortitude) then 
		 return false
	end
		if ni.spell.available(prayeroffortitude)
		 and ni.spell.isinstant(prayeroffortitude) then
			ni.spell.cast(prayeroffortitude)	
			return true
		end
	end,
-----------------------------------
	["Prayer of Spirit"] = function()
		if ni.player.buffs("prayerofspirit||felintelligence")
		 or not IsUsableSpell(prayerofspirit) then 
		 return false
	end
		if ni.spell.available(prayerofspirit) 
		 and ni.spell.isinstant(prayerofspirit) then
			ni.spell.cast(prayerofspirit)	
			return true
		end
	end,
-----------------------------------
	["Prayer of Shadow Protection"] = function()
		if ni.player.buff(prayerofshadowprotection)
		 or not IsUsableSpell(prayerofshadowprotection) then 
		 return false
	end
		if ni.spell.available(prayerofshadowprotection)
		 and ni.spell.isinstant(prayerofshadowprotection) then
			ni.spell.cast(prayerofshadowprotection)	
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
		 and IsSpellKnown(desperateprayer)
		 and ni.spell.isinstant(desperateprayer) 
		 and ni.spell.available(desperateprayer) then
			ni.spell.cast(desperateprayer)
			return true
		end
	end,
-----------------------------------
	["Shadowfiend"] = function()
		if ni.player.power() < 37
		 and ni.spell.isinstant(shadowfiend)
		 and ni.spell.available(shadowfiend) then
			ni.spell.cast(shadowfiend, "target")
			return true
		end
	end,
-----------------------------------
	["Inner Focus"] = function()
		if ni.healing.averagehp(9) < 35
		 and ni.spell.isinstant(14751)
		 and ni.spell.available(14751)
		 and ni.spell.isinstant(powerwordshield)
		 and ni.spell.available(powerwordshield)
		 and ni.spell.available(divinehymn)
		 and not ni.unit.debuff("player", 6788)
		 and not ni.unit.buff("player", powerwordshield, "player") then
			ni.spell.cast(powerwordshield, "player")
			ni.spell.cast(14751)
			return true
		end
	end,
-----------------------------------
	["Divine Hymn"] = function()
		if ni.player.buff(14751)
		 and not ni.player.ismoving()
		 and ni.spell.available(divinehymn)
		 and UnitChannelInfo("player") == nil then
			ni.spell.cast(divinehymn)
			return true
		end
	end,
-----------------------------------
	["Tank Heal"] = function()
		local tank, offTank = ni.tanks()
		local seren, _, _, count = ni.player.buff(63734)
		-- Main Tank Heal
		if UnitExists(tank) then
		 local rnewtank, _, _, _, _, _, rnewtank_time = ni.unit.buff(tank, renew, "player")
		 local pwstank, _, _, _, _, _, pwstank_time = ni.unit.buff(tank, powerwordshield, "player")
		 local pmendtank = ni.unit.buff(tank, prayerofmending, "player")
		 local ws = ni.unit.debuff(tank, 6788)
		-- Heal MT with Renew 
		if ni.spell.available(renew)
		 and ni.spell.isinstant(renew)
		 and (not rnewtank
		 or (rnewtank and rnewtank_time - GetTime() < 2))
		 and ni.spell.valid(tank, renew, false, true, true) then
			ni.spell.cast(renew, tank)
			return true
		end
		-- Put PW:S on MT
		if ni.data.darhanger_leveling.youInInstance()
		 and ni.spell.available(powerwordshield)
		 and ni.spell.isinstant(powerwordshield)
		 and not ws
		 and (not pwstank
		 or (pwstank and pwstank_time - GetTime() < 0.7))
		 and ni.spell.valid(tank, powerwordshield, false, true, true) then
			ni.spell.cast(powerwordshield, tank)
			return true
		end
		-- Put PoF Mending on MT
		 if ni.spell.available(prayerofmending)
		 and ni.spell.isinstant(prayerofmending)
		 and not pmendtank 
		 and ni.spell.available(prayerofmending)
		 and ni.spell.valid(tank, prayerofmending, false, true, true) then
			ni.spell.cast(prayerofmending, tank)
			return true
		end
		-- Greater Heal on MT
		if tank ~= nil
		 and ni.unit.hp(tank) < 50
		 and (seren and count >= 2)
		 and not ni.player.ismoving()
		 and ni.spell.available(greaterheal)
		 and ni.spell.valid(tank, greaterheal, false, true, true) then		 
			ni.spell.cast(greaterheal, tank)
			return true
		end
		-- Flash Heal on MT
		if tank ~= nil
		and ni.unit.hp(tank) < 80
		and ni.spell.available()
		and not ni.player.ismoving()
		and ni.spell.valid(tank, flashheal, false, true, true) then
			ni.spell.cast(flashheal, tank)	
			return
		end
		-- Binding Heal on MT
		if tank ~= nil
		 and ni.unit.hp(tank) < 75
		 and ni.player.hp() < 75	
		 and not ni.player.ismoving()
		 and ni.spell.available(biningheal)
		 and ni.spell.valid(tank, biningheal, false, true, true) then
			ni.spell.cast(biningheal, tank)
			return
			end			
		end
		-- Off Tank heal
		if offTank ~= nil
		 and UnitExists(offTank) then
		 local rnewotank, _, _, _, _, _, rnewotank_time = ni.unit.buff(offTank, renew, "player")
		 local pwotank, _, _, _, _, _, pwotank_time = ni.unit.buff(offTank, powerwordshield, "player")
		 local ws = ni.unit.debuff(offTank, 6788)
		-- Heal Off with Renew 
		if ni.spell.available(renew)
		 and ni.spell.isinstant(renew) 
		 and (not rnewotank
		 or (rnewotank and rnewotank_time - GetTime() < 2))
		 and ni.spell.valid(offTank, renew, false, true, true) then
			ni.spell.cast(renew, offTank)
			return true
		 end
		-- Put PW:S on Off
		if ni.data.darhanger_leveling.youInInstance()
		 and ni.spell.available(powerwordshield)
		 and ni.spell.isinstant(powerwordshield)
		 and not ws
		 and (not pwotank
		 or (pwotank and pwotank_time - GetTime() < 0.7))
		 and ni.spell.valid(offTank, powerwordshield, false, true, true) then
			ni.spell.cast(powerwordshield, offTank)
			return true
		end
		-- Greater Heal on Off
		if offTank ~= nil
		 and ni.unit.hp(offTank) < 50
		 and (seren and count >= 2)
		 and not ni.player.ismoving()
		 and ni.spell.available(greaterheal)
		 and ni.spell.valid(offTank, greaterheal, false, true, true) then		 
			ni.spell.cast(greaterheal, offTank)
			return true
		end
		-- Flash Heal on Off
		if offTank ~= nil
		and ni.unit.hp(offTank) < 80
		and ni.spell.available()
		and not ni.player.ismoving()
		and ni.spell.valid(offTank, flashheal, false, true, true) then
			ni.spell.cast(flashheal, offTank)	
			return
		end
		-- Binding Heal on Off
		if offTank ~= nil
		 and ni.unit.hp(offTank) < 75
		 and ni.player.hp() < 75	
		 and not ni.player.ismoving()
		 and ni.spell.available(biningheal)
		 and ni.spell.valid(offTank, biningheal, false, true, true) then
			ni.spell.cast(biningheal, offTank)
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
		 and ni.spell.available(greaterheal)
		 and ni.spell.valid(ni.members[i].unit, 47788, false, true, true)
		 and ni.spell.valid(ni.members[i].unit, greaterheal, false, true, true) then
			ni.spell.cast(47788, ni.members[i].unit)
			ni.spell.cast(greaterheal, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Circle of Healing"] = function()
		for i = 1, #ni.members do
		if ni.spell.available(circleofhealing)
		 and ni.spell.isinstant(circleofhealing) then 
		 -- Heal party with Circle
		if ni.healing.averagehp(3) < 85
		 and ni.members[i].hp < 85
		 and ni.spell.valid(ni.members[i].unit, circleofhealing, false, true, true) then
			ni.spell.cast(circleofhealing, ni.members[i].unit)
			return true
			end
		end
		 -- Heal raid with Circle
		if not ni.player.hasglyph(55675)
		 and ni.data.darhanger_leveling.youInRaid()
		 and ni.healing.averagehp(4) < 85
		 and ni.members[i].hp < 85
		 and ni.spell.valid(ni.members[i].unit, circleofhealing, false, true, true) then
			ni.spell.cast(circleofhealing, ni.members[i].unit)
			return true
		end
		-- Heal raid with Circle + Glyph
		if ni.player.hasglyph(55675)
		 and ni.data.darhanger_leveling.youInRaid()
		 and ni.members[i].hp < 85
		 and ni.healing.averagehp(5) < 85
		 and ni.spell.valid(ni.members[i].unit, circleofhealing, false, true, true) then
			ni.spell.cast(circleofhealing, ni.members[i].unit)
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
		 and ni.spell.available(renew)
		 and ni.spell.isinstant(renew)
		 and not ni.unit.buff(ni.members[i].unit, renew, "player")
		 and ni.spell.valid(ni.members[i].unit, renew, false, true, true) then
			ni.spell.cast(renew, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Renew All"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].hp < 95
		 and ni.spell.available(renew)
		 and ni.spell.isinstant(renew)
		 and not ni.unit.buff(ni.members[i].unit, renew, "player")
		 and ni.spell.valid(ni.members[i].unit, renew, false, true, true) then
			ni.spell.cast(renew, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Prayer of Healing (Renew Build)"] = function()
		local seren, _, _, count = ni.player.buff(63734)
		for i = 1, #ni.members do
		if ni.spell.available(prayerofhealing)
		 and ni.spell.cd(circleofhealing) ~= 0
		 and not ni.player.ismoving() then 
		 -- Heal party with Prayer
		if ni.healing.averagehp(3) < 75
		 and ni.members[i].hp < 75
		 and ni.spell.valid(ni.members[i].unit, prayerofhealing, false, true, true) then
			ni.spell.cast(prayerofhealing, ni.members[i].unit)
			return true
		end
		 -- Heal raid with Prayer
		if ni.data.darhanger_leveling.youInRaid()
		 and ni.healing.averagehp(4) < 75
		 and ni.members[i].hp < 75
		 and ni.spell.valid(ni.members[i].unit, prayerofhealing, false, true, true) then
			ni.spell.cast(prayerofhealing, ni.members[i].unit)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Prayer of Healing"] = function()
		local seren, _, _, count = ni.player.buff(63734)
		for i = 1, #ni.members do
		if ni.spell.available(prayerofhealing)
		 and (seren and count >= 2)
		 and ni.spell.cd(circleofhealing) ~= 0
		 and not ni.player.ismoving() then 
		 -- Heal party with Prayer
		if ni.healing.averagehp(3) < 75
		 and ni.members[i].hp < 75
		 and ni.spell.valid(ni.members[i].unit, prayerofhealing, false, true, true) then
			ni.spell.cast(prayerofhealing, ni.members[i].unit)
			return true
		end
		 -- Heal raid with Prayer
		if ni.data.darhanger_leveling.youInRaid()
		 and ni.healing.averagehp(4) < 75
		 and ni.members[i].hp < 75
		 and ni.spell.valid(ni.members[i].unit, prayerofhealing, false, true, true) then
			ni.spell.cast(prayerofhealing, ni.members[i].unit)
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
		 and ni.spell.available(greaterheal)
		 and ni.spell.valid(ni.members[i].unit, greaterheal, false, true, true) then
			ni.spell.cast(greaterheal, ni.members[i].unit)
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
		 and GetTime() - ni.data.darhanger_leveling.LastDispel > 2
		 and not ni.unit.buff(ni.members[i].unit, 552)
		 and ni.spell.valid(ni.members[i].unit, 552, false, true, true) then
			ni.spell.cast(552, ni.members[i].unit)
			ni.data.darhanger_leveling.LastDispel = GetTime()
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
		 and GetTime() - ni.data.darhanger_leveling.LastDispel > 2
		 and ni.spell.valid(ni.members[i].unit, 988, false, true, true) then
			ni.spell.cast(988, ni.members[i].unit)
			ni.data.darhanger_leveling.LastDispel = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Flash Heal"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 70
		 and ni.spell.available(flashheal)
		 and ni.spell.valid(ni.members[i].unit, flashheal, false, true, true) then
			ni.spell.cast(flashheal, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		  ni.debug.popup("Holy Priest by darhanger -- Modified by Xcesius for leveling",  
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

ni.bootstrap.rotation("Holy_darhanger_leveling", dynamicqueue, abilities, data)