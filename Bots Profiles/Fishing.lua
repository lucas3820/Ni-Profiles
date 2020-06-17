	-- Main settings and other Stuff / Главные настройки и другая шняга -- 
local Fishing = GetSpellInfo(7620); -- Not tuch!! / Не трогать от слова совсем!!
local FishBob = "Fishing Bobber"; -- Default enGB name "Fishing Bobber" - change according to localization // Дефолтное название в английском клиенте "Fishing Bobber" - измините его в зависимости от вашей локализации;
local settings = {
	UsedLure = 6532, -- Fill with lure ItemID ; Вставить ItemID приманки;
	UsedFishingPool = 6256, -- Default Startet Fishing Pool ItemID is 6256; Дефолтный ItemID стартовой удочки 6256, меняйте на свою;
	MainWeapon = nil, -- Default ItemID is nil, Fill it with your weapon id; Дефолтный ItemID пустой, вставьте айди своего оружия;
	OffHand = nil, -- Default ItemID is nil, Fill it with your weapon id or nil if you haven't off hand; Дефолтный ItemID пустой, вставьте айди своего оружия или оставить как есть если нету офф хэнда;
}
local function SirusCheck()
	if (GetRealmName() == "Frostmourne x1 - 3.3.5+"
	 or GetRealmName() == "Scourge x2 - 3.3.5a+"
	 or GetRealmName() == "Neltharion x3 - 3.3.5a+"
	 or GetRealmName() == "Sirus x10 - 3.3.5a+") then
		return true
	end
		return false
end
local function FullBag()
    local fullbags = 0
    for b = 0, 4 do
        if GetContainerNumFreeSlots(b) == 0 then
            fullbags = fullbags + 1
        end
    end
    return fullbags == 5
end
local popup_shown = false;
local locale = GetLocale()
local russian = false;
if locale == "ruRU" then
	russian = true
else
	russian = false
end	
	-- Not tuch!! / Не трогать от слова совсем!! -- 
local offset;
if ni.vars.build == 40300 then
	offset = 0xD4;
elseif ni.vars.build > 40300 then
	offset = 0xCC;
else
	offset = 0xBC;
end
local functionsent = 0;
	---------------
local queue = {
	"Window",
	"AFK",
	"Combat",
	"Revive",
	"Lure",
	"Pause",	
	"Fishing"
}
local queue2 = {
	"Window",
	"AFK",
	"Combat",
	"Revive",
	"Lure",
	"Pause",
	"Fishing (Sirus Only)"
}
local abilities = {
-----------------------------------
	["Window"] = function()
		if not popup_shown 
		 and russian == true then
		 ni.debug.popup("Modified Fishing Profile by DarhangeR (Original by Scott)", 
		"Добро пожаловать в профиль Рыбной ловли! Поддержка и общие вопросы в Discord > https://discord.gg/TEQEJYS.\n\n--Функции профиля--\n-Откройте файл Fishing.lua и добавьте нужные ItemID.")
		popup_shown = true;
		end
		if not popup_shown
		 and russian == false then
		 ni.debug.popup("Modified Fishing Profile by DarhangeR (Original by Scott)", 
		"Welcome to Fishing Profile! Support and more in Discord > https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-Open Fishing.lua and add proper ItemID.")
		popup_shown = true;
		end	
	end,
-----------------------------------	
	["AFK"] = function()
		if UnitIsAFK("player") then
			ni.player.runtext("/afk")
			return true
		end
	end,
-----------------------------------	
	["Combat"] = function()
		if UnitAffectingCombat("player") ~= nil
		 and IsEquippedItem(settings.UsedFishingPool)
		 and not UnitIsDeadOrGhost("player") then
			ni.spell.stopcasting()
			ni.spell.stopchanneling()
			EquipItemByName(settings.MainWeapon)
			EquipItemByName(settings.OffHand)
		end
		if UnitAffectingCombat("player") == nil
		 and not IsEquippedItem(settings.UsedFishingPool)
		 and not UnitIsDeadOrGhost("player") then
			EquipItemByName(settings.UsedFishingPool)	
			return true
		end
	end,
-----------------------------------	
	["Revive"] = function()	
		if UnitIsDeadOrGhost("player") then
			RepopMe()
			return true
		end
	end,
-----------------------------------	
	["Pause"] = function()
		if FullBag()
		 or IsMounted()
		 or UnitInVehicle("player")
		 or UnitIsDeadOrGhost("player")
		 or UnitCastingInfo("player") ~= nil
		 or UnitAffectingCombat("player")
		 or ni.player.ismoving() then
			return true
		end
	end,
-----------------------------------
	["Lure"] = function()
		local fp = GetWeaponEnchantInfo()
		 if ApplyLure 
		  and GetTime() - ApplyLure > 4 then 
		  ApplyLure = nil 
         end
 		if ApplyLure == nil then
		 ApplyLure = GetTime()
		if IsEquippedItem(settings.UsedFishingPool)
		 and UnitAffectingCombat("player") == nil 
		 and not fp
		 and ni.player.hasitem(settings.UsedLure) then
			ni.spell.stopchanneling()
			ni.player.useitem(settings.UsedLure)
			ni.player.useinventoryitem(16)
			ni.player.runtext("/click StaticPopup1Button1")
			return true
			end
		end
	end,
-----------------------------------
	["Fishing (Sirus Only)"] = function()
		if ni.player.islooting() then
			return
		end
		if UnitChannelInfo("player") then
			if GetTime() - functionsent > 1 then
				local playerguid = UnitGUID("player");
				for k, v in pairs(ni.objects) do
					if type(k) ~= "function" 
					 and (type(k) == "string" 
					 and type(v) == "table") then
						if v.name == FishBob then
								local ptr = ni.memory.objectpointer(v.guid);
								if ptr ~= nil then
									local result = ni.memory.read("byte", ptr, offset)
									if result == 1 then
										ni.player.interact(v.guid);
										functionsent = GetTime();
									return true;
								end
							end
						end
					end
				end
			end
		else
			ni.spell.delaycast(Fishing, nil, 1.5);
		end
	end,
-----------------------------------
	["Fishing"] = function()
		if ni.player.islooting() then
			return
		end
		if UnitChannelInfo("player") then
			if GetTime() - functionsent > 1 then
				local playerguid = UnitGUID("player");
				for k, v in pairs(ni.objects) do
					if type(k) ~= "function" 
					 and (type(k) == "string" 
					 and type(v) == "table") then
						if v.name == FishBob then
							local creator = v:creator();  -- If not loot fish delete this string  / если не лутает рыбу удалить эту строку;
							if tonumber(creator) == tonumber(playerguid) then -- and this string / и эту строку;
								local ptr = ni.memory.objectpointer(v.guid);
								if ptr ~= nil then
									local result = ni.memory.read("byte", ptr, offset)
									if result == 1 then
										ni.player.interact(v.guid);
										functionsent = GetTime();
										return true;
									end -- and this / и эту тоже;
								end
							end
						end
					end
				end
			end
		else
			ni.spell.delaycast(Fishing, nil, 1.5);
		end
	end,
}
	-- Not tuch!! / Не трогать от слова совсем!! -- 
local dynamicqueue = function()
    if SirusCheck() then
        return queue2
    end
		return queue
end
ni.bootstrap.rotation("Fishing", dynamicqueue, abilities)