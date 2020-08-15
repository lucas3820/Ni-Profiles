local data = ni.utils.require("darhanger_leveling.lua");

local enemies = { };
local function ActiveEnemies()
	table.wipe(enemies);
	enemies = ni.unit.enemiesinrange("target", 7);
	for k, v in ipairs(enemies) do
		if ni.player.threat(v.guid) == -1 then
			table.remove(enemies, k);
		end
	end
	return #enemies;
end

local items = {
	settingsfile = "DarhangeR_DPS_Blood_Leveling.xml",
	{ type = "title", text = "Blood DPS DK by |c0000CED1DarhangeR" },
	{ type = "separator" },
	{ type = "title", text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "Raise Dead", tooltip = "Use spell on bosses or on cd active", enabled = false, key = "raisedead" },
	{ type = "entry", text = "Auto Interrupt", tooltip = "Auto check and interrupt all interruptible spells", enabled = true, key = "autointerrupt" },	
	{ type = "separator" },
	{ type = "title", text = "|cff00C957Defensive Settings" },
	{ type = "separator" },
	{ type = "entry", text = "Rune Tap", tooltip = "Use spell when player HP < %", enabled = false, value = 70, key = "runetap" },
	{ type = "entry", text = "Vampiric Blood", tooltip = "Use spell when player HP < %", enabled = false, value = 50, key = "vampblood" },
	{ type = "entry", text = "Mark of Blood", tooltip = "Use spell when player HP < %", enabled = false, value = 35, key = "markofblood" },
	{ type = "entry", text = "Icebound Fortitude", tooltip = "Use spell when player HP < %", enabled = true, value = 45, key = "iceboundfort" },
	{ type = "entry", text = "Healthstone", tooltip = "Use Warlock Healthstone (if you have) when player HP < %", enabled = true, value = 35, key = "healthstoneuse" },
	{ type = "entry", text = "Heal Potion", tooltip = "Use Heal Potions (if you have) when player HP < %", enabled = true, value = 30, key = "healpotionuse" },
	{ type = "separator" },
	{ type = "title", text = "|cffEE4000Rotation Settings"" },
	{ type = "separator" },
	{ type = "entry", text = "Blood Boil", tooltip = "Use spell when you have > 2 enemies instead of using Heart Strike", enabled = false, key = "boil" },	
	{ type = "separator" },
	{ type = "title", text = "Presence's" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 48266, text = "Blood Presence" },
		{ selected = false, value = 48263, text = "Frost Presence" },
		{ selected = false, value = 48265, text = "Unholy Presence" },
	}, key = "Presence" },
};
local function GetSetting(name)
    for k, v in ipairs(items) do
        if v.type == "entry"
         and v.key ~= nil
         and v.key == name then
            return v.value, v.enabled
        end
        if v.type == "dropdown"
         and v.key ~= nil
         and v.key == name then
            for k2, v2 in pairs(v.menu) do
                if v2.selected then
                    return v2.value
                end
            end
        end
        if v.type == "input"
         and v.key ~= nil
         and v.key == name then
            return v.value
        end
    end
end;
local function OnLoad()
	ni.GUI.AddFrame("Blood_DPS_darhanger_leveling", items);
end
local function OnUnLoad()  
	ni.GUI.DestroyFrame("Blood_DPS_darhanger_leveling");
end

--Convert Abilities
local hornofwinter = GetSpellInfo(57623)
local deathanddecay = GetSpellInfo(49938)
local hysteria = GetSpellInfo(49016)
local bloodstrike = GetSpellInfo(49930)
local icytouch = GetSpellInfo(49909)
local plaguestrike = GetSpellInfo(49921)
local pestilence = GetSpellInfo(50842)
local deathstrike = GetSpellInfo(49924)
local runestrike = GetSpellInfo(56815)
local bloodboil = GetSpellInfo(49941)
local heartstrike = GetSpellInfo(55262)
local deathcoil = GetSpellInfo(49895)
local runetap = GetSpellInfo(48982)

local popup_shown = false;
local queue = {

	"Window",
	"Universal pause",
	"AutoTarget",
	"Presence check",
	"Horn of Winter",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Mind Freeze (Interrupt)",
	"Icebound Fort",
	"Mark of Blood",
	"Rune Tap",
	"Vamp Blood",
	"Death and Decay",
	"Hyst",
	"Raise Dead",
	"Empower Rune Weapon",
	"Icy Touch",
	"Plague Strike",
	"Icy Touch (Aggro)",
	"Blood Strike",
	"Pestilence (AoE)",
	"Pestilence (Renew)",
	"Dance Rune",
	"Death Coil (Max runpower)",		
	"Death Strike",
	"Rune Strike",
	"Blood Boil",
	"Heart Strike",
	"Death Coil"
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
	["Presence check"] = function()
		local presence = GetSetting("Presence");		
		if not ni.player.buff(presence)
		 and ni.spell.isinstant(presence)
		 and ni.spell.available(presence) then
			ni.spell.cast(presence)
			return true
		end
	end,
-----------------------------------
	["Horn of Winter"] = function()
		if not ni.player.buff(hornofwinter)
		 and ni.spell.isinstant(hornofwinter) 
		 and ni.spell.available(hornofwinter) then 		
			ni.spell.cast(hornofwinter)
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
	["Pet Attack/Follow"] = function()
		if ni.unit.hp("playerpet") < 20
		 and UnitExists("playerpet")
		 and UnitExists("target")
		 and UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then
			data.petFollow()
		 else
		if UnitAffectingCombat("player")
		 and UnitExists("playerpet")
		 and ni.unit.hp("playerpet") > 60
		 and UnitExists("target")
		 and not UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then 
			data.petAttack()
			end
		end
	end,
-----------------------------------
	["Healthstone (Use)"] = function()
		local value, enabled = GetSetting("healthstoneuse");
		local hstones = { 36892, 36893, 36894 }
		for i = 1, #hstones do
			if enabled
			 and ni.player.hp() < value
			 and ni.player.hasitem(hstones[i]) 
			 and ni.player.itemcd(hstones[i]) == 0 then
				ni.player.useitem(hstones[i])
				return true
			end
		end	
	end,
-----------------------------------	
	["Raise Dead"] = function()
		local _, enabled = GetSetting("raisedead")
		if enabled
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.data.darhanger.CDsaverTTD("target")
		 and not ni.unit.exists("playerpet")
		 and not ni.player.buff(61431)
		 and ni.spell.isinstant(46584)
		 and ni.spell.available(46584)
		 and IsUsableSpell(GetSpellInfo(46584))
		 and ( ni.player.hasitem(37201)
		 or	ni.player.hasglyph(60200) ) then
			ni.spell.cast(46584)
			return true
		end
	end,
-----------------------------------
	["Potions (Use)"] = function()
		local value, enabled = GetSetting("healpotionuse");
		local hpot = { 33447, 43569, 40087, 41166, 40067 }
		for i = 1, #hpot do
			if enabled
			 and ni.player.hp() < value
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
		 and IsSpellInRange(bloodstrike, "target") == 1 then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if IsSpellInRange(bloodstrike, "target") == 1
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
		 and ni.data.darhanger.CDsaverTTD("target")
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and IsSpellInRange(bloodstrike, "target") == 1 then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.data.darhanger.CDsaverTTD("target")
		 and IsSpellInRange(bloodstrike, "target") == 1 then
			ni.player.useinventoryitem(13)
		else
		 if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.data.darhanger.CDsaverTTD("target")
		 and IsSpellInRange(bloodstrike, "target") == 1 then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------
	["Mind Freeze (Interrupt)"] = function()
	local _, enabled = GetSetting("autointerrupt")
		if enabled	
		 and ni.spell.shouldinterrupt("target")
		 and ni.spell.isinstant(47528)
		 and ni.spell.available(47528)
		 and GetTime() - data.LastInterrupt > 9
		 and ni.spell.valid("target", 47528, true, true)  then
			ni.spell.castinterrupt("target")
			data.LastInterrupt = GetTime()
			return true
		end
	end,
-----------------------------------
	["Icebound Fort"] = function()
		local value, enabled = GetSetting("iceboundfort");
		if enabled
		 and ni.player.hp() < value
		 and ni.spell.isinstant(48792)
		 and ni.spell.available(48792) 
		 and not ni.player.buff(48792) then
			ni.spell.cast(48792)
			return true
		end
	end,
-----------------------------------
	["Vamp Blood"] = function()
		local value, enabled = GetSetting("vampblood");
		local _, BR = ni.rune.bloodrunecd()
		if enabled
		 and ni.player.hp() < value
		 and BR >= 1
		 and ni.spell.isinstant(55233)
		 and ni.spell.available(55233)
		 and not ni.player.buff(55233) then
			ni.spell.cast(55233)
			return true
		end
	end,
-----------------------------------
	["Death and Decay"] = function()
		if ni.vars.combat.aoe
		 and ni.spell.isinstant(deathanddecay) 
		 and ni.spell.cd(deathanddecay) == 0 then
		 then
			ni.spell.castatqueue(deathanddecay, "target")
			return true
		end
	end,
-----------------------------------
	["Hyst"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.isinstant(hysteria)
		 and ni.spell.available(hysteria)
		 and IsSpellInRange(bloodstrike, "target") == 1 then
		  if not ni.unit.exists("focus")
		  and not ni.player.buff(hysteria) then
			ni.spell.cast(hysteria, "player")
			return true
		else
		 if ni.unit.exists("focus")
		 and UnitInRange("focus")
		 and not UnitIsDeadOrGhost("focus")
		 and ni.spell.isinstant(hysteria)
		 and ni.spell.available(hysteria)
		 and not ni.unit.buff("focus", hysteria) then
			ni.spell.cast(hysteria, "focus")
			return true
			     end
			end
		end
	end,
-----------------------------------
	["Empower Rune Weapon"] = function()
		if ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.rune.available() == 0
		 and ni.spell.isinstant(47568)
		 and ni.spell.available(47568) then
			ni.spell.cast(47568)
			return true
		end
	end,
-----------------------------------
	["Icy Touch"] = function()
		local icy = data.dk.icy()
		if ( icy == nil or ( icy - GetTime() <= 2 ) )
		 and ni.spell.available(icytouch)		
		 and ni.spell.isinstant(icytouch)
		 and ni.spell.valid("target", icytouch, true, true) then
			ni.spell.cast(icytouch, "target")
			return true
		end
	end,
-----------------------------------
	["Plague Strike"] = function()
		local plague = data.dk.plague()
		if ( plague == nil or ( plague - GetTime() <= 2 ) )
		 and ni.spell.available(plaguestrike)	
		 and ni.spell.isinstant(plaguestrike)
		 and ni.spell.valid("target", plaguestrike, true, true) then
			ni.spell.cast(plaguestrike, "target")
			return true
		end
	end,
	
	-----------------------------------
	["Blood Strike"] = function()
		local _, BR = ni.rune.bloodrunecd()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		if not IsSpellKnown(heartstrike)
		 and BR >= 1
		 and ( #enemies == 1 or #enemies < 2 )
		 and plague
		 and icy
		 and ni.spell.isinstant(bloodstrike)
		 and ni.spell.available(bloodstrike)
		 and ni.spell.valid("target", bloodstrike, true, true) then
			ni.spell.cast(bloodstrike, "target")
			return true
		end
	end,	
-------------------------------------------
	["Mark of Blood"] = function()
		local value, enabled = GetSetting("markofblood");
		local _, BR = ni.rune.bloodrunecd()
		if enabled
		 and BR >= 1
		 and ni.player.hp() < value
		 and ni.spell.isinstant(49005)
		 and ni.spell.available(49005)
		 and not ni.unit.debuff("target", 49005, "player") then
			ni.spell.cast(49005, "target")
			return true
		end
	end,
-------------------------------------------	
	["Rune Tap"] = function()
		local value, enabled = GetSetting("runetap");
		local _, BR = ni.rune.bloodrunecd()
		if enabled
		 and ni.player.hp() < value then
		  if BR >= 1
		   and ni.spell.isinstant(runetap)
		   and ni.spell.available(runetap) then 
			ni.spell.cast(runetap)
			return true
		   end
		  if BR < 1
		   and ni.spell.isinstant(45529)
		   and ni.spell.available(45529)
		   and ni.spell.cd(48982) == 0 then
			ni.spell.cast(45529)
			return true
			end
		end
	 end,

-----------------------------------
	["Pestilence (AoE)"] = function()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
	    local enemies = ni.unit.enemiesinrange("target", 7)
		local _, BR = ni.rune.bloodrunecd()
		local _, DR = ni.rune.deathrunecd()
		if ( BR >= 1 or DR >= 1 )
		 and icy
		 and plague
		 and ni.spell.isinstant(50842)
		 and ni.spell.valid("target", 50842, true, true) then
		 if ActiveEnemies() >= 1 then
		  for i = 1, #enemies do
		   if ni.unit.creaturetype(enemies[i].guid) ~= 8
		    and ni.unit.creaturetype(enemies[i].guid) ~= 11
		    and (not ni.unit.debuff(enemies[i].guid, 55078, "player")
		    or not ni.unit.debuff(enemies[i].guid, 55095, "player")) then
				ni.spell.cast(50842, "target")
						return true
					end
				end
			end
		end
	end,
-----------------------------------
	["Pestilence (Renew)"] = function()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		local _, BR = ni.rune.bloodrunecd()
		local _, DR = ni.rune.deathrunecd()
		if ni.player.hasglyph(63334)
		 and ni.spell.valid("target", pestilence, true, true)
		 and ( ( icy ~= nil and icy - GetTime() <= 4.5 )
		 or ( plague ~= nil and plague - GetTime() <= 4.5 ) ) then 
		 if BR == 0 and DR == 0
		 and ni.spell.cd(45529) == 0 then
			ni.spell.cast(45529)
			ni.spell.cast(pestilence)
			return true
		else
			ni.spell.cast(pestilence)
			return true
			end
		end
	end,
-----------------------------------
	["Dance Rune"] = function()
		if ni.spell.available(49028)
		 and ni.spell.isinstant(49028)
		 and ( ni.vars.combat.cd or ni.unit.isboss("target") )
		 and ni.spell.valid("target", 49930, true, true) then
			ni.spell.cast(49028, "target")
			return true
		end
	end,
-----------------------------------
	["Death Strike"] = function()
		local _, FR = ni.rune.frostrunecd()
		local _, UR = ni.rune.unholyrunecd()
		local _, DR = ni.rune.deathrunecd()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		if ((FR >= 1 and UR >= 1)
		 or (FR >= 1 and DR >= 1)
		 or (DR >= 1 and UR >= 1)
		 or (DR == 2))			 
		 and plague
		 and icy
		 and ni.player.power() < 80	
		 and ni.spell.isinstant(deathstrike)
		 and ni.spell.available(deathstrike)
		 and ni.spell.valid("target", deathstrike, true, true) then
			ni.spell.cast(deathstrike, "target")
			return true
		end
	end,
-----------------------------------
	["Rune Strike"] = function()
		if IsUsableSpell(runestrike)
		 and ni.spell.available(runestrike, true)
		 and not IsCurrentSpell(runestrike)
		 and ni.spell.valid("target", runestrike, true, true) then
			ni.spell.cast(runestrike, "target")
			return true
		end
	end,
-----------------------------------
	["Blood Boil"] = function()
		local _, BR = ni.rune.bloodrunecd()
		local _, DR = ni.rune.deathrunecd()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		local _, enabled = GetSetting("boil")
		if enabled 
		 and ( BR >= 1 or DR >= 1 )
		 and ActiveEnemies() > 2
		 and plague
		 and icy
		 and ni.player.power() < 80	
		 and ni.spell.isinstant(bloodboil)
		 and ni.spell.available(bloodboil)
		 and ni.spell.valid("target", heartstrike, true, true) then
			ni.spell.cast(bloodboil, "target")
			return true
		end	
	end,
-----------------------------------
	["Heart Strike"] = function()
		local _, BR = ni.rune.bloodrunecd()
		local _, DR = ni.rune.deathrunecd()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		local _, enabled = GetSetting("boil")
		if ( BR >= 1 or DR >= 1 )
		 and not enabled
		 and plague
		 and icy
		 and ni.player.power() < 80
		 and ni.spell.isinstant(heartstrike)
		 and ni.spell.available(heartstrike)
		 and ni.spell.valid("target", heartstrike, true, true) then
			ni.spell.cast(heartstrike, "target")
			return true
		end
	end,
-----------------------------------
	["Death Coil"] = function()
		if ni.spell.available(deathcoil)
		 and ni.spell.isinstant(deathcoil)
		 and ni.spell.valid("target", deathcoil, true, true) then
			ni.spell.cast(deathcoil, "target")
			return true
		end
	end,
-----------------------------------
	["Death Coil (Max runpower)"] = function()
		if ni.player.power() > 80
		 and ni.spell.available(deathcoil)
		 and ni.spell.isinstant(deathcoil)
		 and ni.spell.valid("target", deathcoil, true, true) then
			ni.spell.cast(deathcoil, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		ni.debug.popup("Blood DPS Deathknight by darhanger for 3.3.5a -- Modified by Xcesius for leveling", 
		 "Welcome to Blood DPS Deathknight Profile! Support and more in Discord > https://discord.gg/u4mtjws.\n\n--Profile Function--\n-For use Death and Decay configure AoE Toggle key.\n-Focus ally target for use Hysteria on it.")	
		popup_shown = true;
		end 
	end,
}
ni.bootstrap.profile("Blood_DPS_darhanger_leveling", queue, abilities, OnLoad, OnUnLoad);