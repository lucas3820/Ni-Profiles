local data = ni.utils.require("darhanger_leveling.lua");

--Abilities Convert
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
	"Pain Suppression",
	"Power Word: Shield (Emergency)",
	"Prayer of Mending",
	"Penance (Emergency)",
	"Power Word: Shield (All)",
	"Prayer of Healing",
	"Renew",
	"Binding Heal",
	"Abolish Disease",
	"Dispel Magic",
	"Flash Heal",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
			if data.UniPause() then
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
		 and data.forsaken()
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
		-- Main Tank Heal
		if UnitExists(tank) then
		 local rnewtank, _, _, _, _, _, rnewtank_time = ni.unit.buff(tank, renew, "player")
		 local pwstank, _, _, _, _, _, pwstank_time = ni.unit.buff(tank, powerwordshield, "player")
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
		if ni.spell.available(powerwordshield)
		 and ni.spell.isinstant(powerwordshield)
		 and not ws
		 and (not pwstank
		 or (pwstank and pwstank_time - GetTime() < 0.7))
		 and ni.spell.valid(tank, powerwordshield, false, true, true) then
			ni.spell.cast(powerwordshield, tank)
			return true
			end
		end
		-- Off Tank heal
		if offTank ~= nil
		 and UnitExists(offTank) then
		 local rnewotank, _, _, _, _, _, rnewotank_time = ni.unit.buff(offTank, renew, "player")
		 local pwotank, _, _, _, _, _, pwotank_time = ni.unit.buff(offTank, powerwordshield, "player")
		 local ws = ni.unit.debuff(offTank, 6788)
		-- Heal OT with Renew 
		if ni.spell.available(renew)
		 and ni.spell.isinstant(renew) 
		 and (not rnewotank
		 or (rnewotank and rnewotank_time - GetTime() < 2))
		 and ni.spell.valid(offTank, renew, false, true, true) then
			ni.spell.cast(renew, offTank)
			return true
		 end
		-- Put PW:S on OT
		if ni.spell.available(powerwordshield)
		 and ni.spell.isinstant(powerwordshield)
		 and not ws
		 and (not pwotank
		 or (pwotank and pwotank_time - GetTime() < 0.7))
		 and ni.spell.valid(offTank, powerwordshield, false, true, true) then
			ni.spell.cast(powerwordshield, offTank)
			return true
			end
		end
	end,
-----------------------------------
	["Pain Suppression"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 20
		 and ni.spell.available(painsupression)
		 and ni.spell.isinstant(painsupression)
		 and ni.spell.valid(ni.members[i].unit, painsupression, false, true, true) then
			ni.spell.cast(painsupression, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Power Word: Shield (Emergency)"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].range
		 and not UnitIsDeadOrGhost(ni.members[i].unit) then
		 local tarCount = #ni.unit.unitstargeting(ni.members[i].guid)
		 local pws,_,_,_,_,_,pwsTime = ni.unit.buff(ni.members[i].unit, powerwordshield, "player")
		 local ws = ni.unit.debuff(ni.members[i].unit, 6788)
		  if tarCount ~= nil and tarCount >= 1
		   and not ws
                   and not (pws
                   or (pws and pwsTime - GetTime() < 0.7))
		   and ni.spell.isinstant(powerwordshield)
		   and ni.spell.available(powerwordshield, ni.members[i].unit)
		   and ni.unit.threat(ni.members[i].guid) >= 2
		   and ni.spell.valid(ni.members[i].unit, powerwordshield, false, true, true) then
				ni.spell.cast(powerwordshield, ni.members[i].unit)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Prayer of Mending"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 95
		 and ni.spell.isinstant(prayerofmending)
		 and ni.spell.available(prayerofmending)
		 and  not ni.unit.buff(ni.members[i].unit, prayerofmending, "player")
		 and ni.spell.valid(ni.members[i].unit, prayerofmending, false, true, true) then
			ni.spell.cast(prayerofmending, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Penance (Emergency)"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].range then
		 local tarCount = #ni.unit.unitstargeting(ni.members[i].guid)
		  if (ni.members[i].hp < 80
		  or (tarCount ~= nil and tarCount >= 1))
		  and not ni.player.ismoving()
		  and ni.spell.isinstant(penance)
		  and ni.spell.available(penance)
		  and ni.spell.valid(ni.members[i].unit, penance, false, true, true) then
				ni.spell.cast(penance, ni.members[i].unit)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Power Word: Shield (All)"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].range
		 and not UnitIsDeadOrGhost(ni.members[i].unit) then
		  local pws,_,_,_,_,_,pwsTime = ni.unit.buff(ni.members[i].unit, powerwordshield, "player")
		  local ws = ni.unit.debuff(ni.members[i].unit, 6788)
		  if ni.members[i].hp < 95
		   and not ws
		   and not (pws
		   or (pws and pwsTime - GetTime() < 0.7))
		   and ni.spell.isinstant(powerwordshield)
		   and ni.spell.available(powerwordshield)
		   and ni.spell.valid(ni.members[i].unit, powerwordshield, false, true, true) then
				ni.spell.cast(powerwordshield, ni.members[i].unit)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Prayer of Healing"] = function()
		for i = 1, #ni.members do
		if ni.spell.available(prayerofhealing2)
		 and not ni.player.ismoving() then 
		 -- Heal party with Prayer
		if ni.healing.averagehp(3) < 75
		 and ni.members[i].hp < 75
		 and ni.spell.valid(ni.members[i].unit, prayerofhealing, false, true, true) then
			ni.spell.cast(prayerofhealing, ni.members[i].unit)
			return true
		end
		 -- Heal raid with Prayer
		if data.youInRaid()
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
	["Renew"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].hp < 90
		 and ni.spell.isinstant(renew)
		 and ni.spell.available(renew)
		 and not ni.unit.buff(ni.members[i].unit, renew, "player")
		 and ni.spell.valid(ni.members[i].unit, renew, false, true, true) then
			ni.spell.cast(renew, ni.members[i].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Binding Heal"] = function()
		for i = 1, #ni.members do
		 if ni.members[i].hp < 75
		 and ni.player.hp() < 75
		 and ni.spell.available(biningheal)
		 and not ni.player.ismoving()
		 and ni.spell.valid(ni.members[i].unit, biningheal, false, true, true) then
			ni.spell.cast(biningheal, ni.members[i].unit)
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
		 and GetTime() - data.LastDispel > 2
		 and not ni.unit.buff(ni.members[i].unit, 552)
		 and ni.spell.valid(ni.members[i].unit, 552, false, true, true) then
			ni.spell.cast(552, ni.members[i].unit)
			data.LastDispel = GetTime()
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
		 and GetTime() - data.LastDispel > 2
		 and ni.spell.valid(ni.members[i].unit, 988, false, true, true) then
			ni.spell.cast(988, ni.members[i].unit)
			data.LastDispel = GetTime()
			return true
			end
		end
	end,
-----------------------------------
	["Flash Heal"] = function()
		for i = 1, #ni.members do
		if ni.members[i].hp < 65
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
		  ni.debug.popup("Discipline Priest by darhanger -- Modified by Xcesius for leveling", 
		 "Welcome to Discipline Priest Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For enable priority healing Main Tank & Off Tank put tank name to Tank Overrides and press Enable Main/Off")
		popup_shown = true;
		end 
	end,
}

ni.bootstrap.profile("Discipline_darhanger_leveling", queue, abilities);