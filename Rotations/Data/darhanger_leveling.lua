local dontdispel = { 68786, 34917, 34919, 48159, 48160, 30404, 30405, 31117, 34438, 35183, 43522, 47841, 47843, 65812, 68154, 68155, 68156, 44461, 55359, 55360, 55361, 55362, 61429, 30108, 34914, 74562, 74792, 70867, 70338, 70405 };
for k, v in pairs(dontdispel) do
    ni.healing.debufftoblacklist(v);
end
local cbuff = { 59301, 642, 31224, 23920, 33786, 19263, 21892, 40733, 45438, 69051, 69056, 20223 };
local mbuff = { 59301, 45438, 33786, 21892, 40733, 69051 };
local tbuff = { 59301, 45438, 33786, 21892, 40733, 19263, 1022, 69051 };
local forsdebuff = { 6215, 8122, 5484, 2637, 5246, 6358, 605, 22686 };
local pbuff = { 430, 433, 25990, 58984 };
local pdebuff = { 52509 };
local _, class = UnitClass("player");
---Hunter Converts
local moonfiredebuff = GetSpellInfo(48463)
local insectswarmdebuff = GetSpellInfo(48468)
local mangledebuff = GetSpellInfo(48564)
local laceratedebuff = GetSpellInfo(48568)
local manglecatdebuff = GetSpellInfo(48566)
local ripdebuff = GetSpellInfo(49800)
local rakedebuff = GetSpellInfo(48574)
local tigerbuff = GetSpellInfo(50213)
local savagebuff = GetSpellInfo(52610)
---Hunter Converts
local serpentstingdebuff = GetSpellInfo(49001)
local viperstringdebuff = GetSpellInfo(3034)
local scorpstringdebuff = GetSpellInfo(3043)
local explobuff = GetSpellInfo(60053)
----Mage Converts
local scorchdebuff = GetSpellInfo(22959)
local livingbombdebuff = GetSpellInfo(55360)
local frostnovadebuff = GetSpellInfo(42917)
local fingersoffrost = GetSpellInfo(44545)
local renddebuff = GetSpellInfo(47465)
---Rogue Converts
local envenombuff = GetSpellInfo(57993)
local sliceanddicebuff = GetSpellInfo(6774)
local rupturedebuff = GetSpellInfo(48672)
local garrotedebuff = GetSpellInfo(48676)



	-- Debuger -- 
local function changedebug(msg)
	if msg == "on" then
	 ni.vars.debug = true;
	elseif msg == "off" then
	 ni.vars.debug = false;
	 else
	 print("Only commands are on/off\nFor example:\n/dardebug on\n/dardebug off");
	end
end
SLASH_DARDEBUG1 = "/dardebug";
SlashCmdList["DARDEBUG"] = changedebug;

local data = {
	LastDispel = 0, 
	LastInterrupt = 0,
	
		-- Vars for Universal Pause --
	PlayerBuffs = function()
		for _, v in ipairs(pbuff) do
		 if ni.unit.buff("player", v) then 
		     return true
			end
		end
		     return false
	end,
	
		-- Check Start Fight --
	CDsaver = function(t)
	if ni.vars.combat.time ~= 0 
	 and GetTime() - ni.vars.combat.time > 7
	 and ni.unit.hp(t) >= 5 then
		     return true
		end
		     return false
	end,
				
		-- Check Start Fight with TTD --
	CDsaverTTD = function(t)
	if ni.vars.combat.time ~= 0 
	 and GetTime() - ni.vars.combat.time > 5 
	 and ni.unit.ttd(t) > 35
	 and ni.unit.hp(t) >= 5 then
		     return true
		end
		     return false
	end,

		-- Universal Pause --
	UniPause = function()
	if ni.spell.gcd()
	 or IsMounted()
	 or UnitInVehicle("player")
	 or UnitIsDeadOrGhost("target") 
	 or UnitIsDeadOrGhost("player")
	 or UnitChannelInfo("player") ~= nil
	 or UnitCastingInfo("player") ~= nil
	 or ni.vars.combat.casting == true
	 or data.PlayerBuffs()
	 or (not UnitAffectingCombat("player")
	 and ni.vars.followEnabled) then
		     return true
		end
		     return false
	end,
	
	PlayerDebuffs = function()
		for _, v in ipairs(pdebuff) do
		 if ni.unit.debuff("player", v) then 
		     return true
			end
		end
		     return false
	end,
	
	
    -- Vars for Combat Pause --
	casterStop = function()
		for _, v in ipairs(cbuff) do
		 if ni.unit.buff("target", v) then 
		     return true
			end
		end
		     return false
	end,
	
	
	
	meleeStop = function()
		for _, v in ipairs(mbuff) do
		 if ni.unit.buff("target", v) then 
		     return true
			end
		end
		     return false
	end,
	
	tankStop = function()
		for _, v in ipairs(tbuff) do
		 if ni.unit.buff("target", v) then 
		     return true
			end
		end
		     return false
	end,
	
	-- Will of the Forsaken
	forsaken = function()
		for _, v in ipairs(forsdebuff) do
		 if ni.player.debuff(v) then 
		     return true
			end
		end
		    return false
	end,
	
	-- Check Instance / Raid --
	youInInstance = function()
		if IsInInstance()
		 and select(2, GetInstanceInfo()) == "party" then
		     return true
		end
		    return false
	end,

	youInRaid = function()
		if IsInInstance()
		 and select(2, GetInstanceInfo()) == "raid" then
		     return true
		end
		    return false
	end,
			
	-- Pet Follow / Attack Function -- 
	petFollow = function()
		local pet = ni.objects["pet"]
		if not pet:exists() then
			return
		end
		local oldPetDistance = petDistance;
		petDistance = pet:distance("player")
		local distanceThreshold = 1
		if not oldPetDistance 
		 or petDistance - oldPetDistance > distanceThreshold then
			ni.player.runtext("/petfollow");
		end
	end,
	
	petAttack = function()
		local pet = ni.objects["pet"]
		if not pet:exists() then
			return
		end
		if not pet:combat() then
			ni.player.runtext("/petattack")
			petDistance = nil
		end

		if pet:combat() then
			ni.player.runtext("/petattack")
			petDistance = nil
		end
	end	
}
local classlower = string.lower(class);
if classlower == "deathknight" then
	classlower = "dk";
end
data[classlower] = { };
if classlower == "dk" then
	data[classlower].LastIcy = 0;
	data[classlower].icy = function()
		return select(7, ni.unit.debuff("target", 55095, "player")) 
	end;
	data[classlower].plague = function() 
		return select(7, ni.unit.debuff("target", 55078, "player")) 
	end;
		-- Sirus Custom T5 --
	local itemsetT5 = {
	81241, 80867, 80861, 80927, 82812
	};
		-- Check Item Set --
	data[classlower].checkforSet = function(t, pieces)
		local count = 0
		for _, v in ipairs(t) do
			if IsEquippedItem(v) then
				count = count + 1;
			end
		end
		if count >= pieces then
			return true
		else
			return false
		end
	end
elseif classlower == "druid" then
	data[classlower].LastShout = 0;
	data[classlower].lastRegrowth = 0;
	data[classlower].mFaerieFire = function() 
		return select(7, ni.unit.debuff("target", 770)) 
	end;
	data[classlower].fFaerieFire = function() 
		return select(7, ni.unit.debuff("target", 16857)) 
	end
	data[classlower].iSwarm = function()
		return select(7, ni.unit.debuff("target", insectswarmdebuff, "player")) 
	end
	data[classlower].mFire = function() 
		return select(7, ni.unit.debuff("target", moonfiredebuff, "player")) 
	end
	data[classlower].lunar = function() 
		return select(7, ni.unit.buff("player", 48517)) 
	end
	data[classlower].solar = function() 
		return select(7, ni.unit.buff("player", 48518)) 
	end
	data[classlower].berserk = function() 
		return select(11, ni.unit.buff("player", 50334))
	end
	data[classlower].bmangle = function()
		return select(7, ni.unit.debuff("target", mangledebuff))
	end
	data[classlower].lacerate = function() 
		return select(7, ni.unit.debuff("target", laceratedebuff, "player"))
	end
	data[classlower].mangle = function() 
		return select(7, ni.unit.debuff("target", manglecatdebuff)) 
	end
	data[classlower].rip = function() 
		return select(7, ni.unit.debuff("target", ripdebuff, "player")) 
	end
	data[classlower].rake = function() 
		return select(7, ni.unit.debuff("target", rakedebuff, "player"))
	end
	data[classlower].tiger = function() 
		return ni.unit.buff("player", tigerbuff) 
	end
	data[classlower].savage = function() 
		return select(7, ni.unit.buff("player", savagebuff)) 
	end
elseif classlower == "hunter" then
	data[classlower].LastMD = 0;
	data[classlower].LastScat = 0;
	data[classlower].serpstring = function() 
		return select(7, ni.unit.debuff("target", serpentstingdebuff, "player")) 
	end
	data[classlower].viperstring = function() 
		return select(7, ni.unit.debuff("target", viperstringdebuff, "player")) 
	end
	data[classlower].scorpstring = function() 
		return select(7, ni.unit.debuff("target", scorpstringdebuff, "player")) 
	end
	data[classlower].exploshot = function() 
		return select(7, ni.unit.debuff("target", explobuff, "player")) 
	end
elseif classlower == "mage" then
	data[classlower].LastScorch = 0;
	data[classlower].Scorch = function()
		return ni.unit.debuff("target", scorchdebuff, "player")
	end
	data[classlower].LBomb = function() 
		return ni.unit.debuff("target", livingbombdebuff, "player") 
	end
	data[classlower].fnova = function() 
		return ni.unit.debuff("target", frostnovadebuff, "player") 
	end
	data[classlower].fbite = function() 
		return ni.unit.debuff("target", 12494, "player") 
	end
	data[classlower].freeze = function() 
		return ni.unit.debuff("target", 33395, "player") 
	end
	data[classlower].FoF = function() 
		return ni.player.buff(fingersoffrost) 
	end
elseif classlower == "paladin" then
	data[classlower].LastSeal = 0;
	data[classlower].forb = function() 
		return ni.player.debuff(25771) 
	end
	data[classlower].aow = function() 
		return ni.player.buff(59578) 
	end
	data[classlower].itemsetT10 = { 
		51270, 51271, 51272, 51273, 51274, 51165, 51166, 51167, 51168, 51169, 50865, 50866, 50867, 50868, 50869
	};
	-- Check Item Set --
	data[classlower].checkforSet = function(t, pieces)
		local count = 0
		for _, v in ipairs(t) do
			if IsEquippedItem(v) then
				count = count + 1
			end
		end
		if count >= pieces then
			return true
		else
			return false
		end
	end
elseif classlower == "priest" then
	data[classlower].lastvamp = 0;
	data[classlower].lastSWP = 0;
	data[classlower].lastPlague = 0;
	data[classlower].vamp = function()
		return select(7, ni.unit.debuff("target", 48160, "player")) 
	end
	data[classlower].SWP = function() 
		return select(7, ni.unit.debuff("target", 48125, "player")) 
	end
	data[classlower].dplague = function() 
		return select(7, ni.unit.debuff("target", 48300, "player")) 
	end
		-- Crimson Acolyte's Regalia --
	data[classlower].itemsetT10 = {
		51255, 51256, 51257, 51258, 51259, 51180, 51181, 51182, 51183, 51184, 50391, 50392, 50393, 50394, 50396
	};
	-- Check Item Set --
	data[classlower].checkforSet = function(t, pieces)
		local count = 0
		for _, v in ipairs(t) do
			if IsEquippedItem(v) then
				count = count + 1
			end
		end
		if count >= pieces then
			return true
		else
			return false
		end
	end
elseif classlower == "rogue" then
	data[classlower].SnD = function() 
		return select(7, ni.player.buff(sliceanddicebuff))	
	end
	data[classlower].Hunger = function() 
		return select(7, ni.player.buff(63848)) 
	end
	data[classlower].envenom = function() 
		return select(7, ni.player.buff(envenombuff)) 
	end
	data[classlower].Rup = function() 
		return select(7, ni.unit.debuff("target", rupturedebuff, "player")) 
	end
	data[classlower].Gar = function() 
		return select(7, ni.unit.debuff("target", garrotedebuff, "player")) 
	end
	data[classlower].OGar = function() 
		return select(7, ni.unit.debuff("target", garrotedebuff)) 
	end	
elseif classlower == "shaman" then
	data[classlower].LastPurge = 0;
	data[classlower].flameshock = function() 
		return select(7, ni.unit.debuff("target", 49233, "player")) 
	end
elseif classlower == "warlock" then
	data[classlower].petAffli = 691;
	data[classlower].petDest = 688;
	data[classlower].petDemo = 30146;
	data[classlower].LastSummon = 0;
	data[classlower].LastCorrupt = 0;
	data[classlower].LastCurse = 0;
	data[classlower].LastShadowbolt = 0;
	data[classlower].Lastimmolate = 0;
	data[classlower].LastUA = 0;
	data[classlower].LastHaunt = 0;
	data[classlower].LastSeed = 0;
	data[classlower].Stones = nil;
	data[classlower].CotE = function()
		return select(7, ni.unit.debuff("target", 47865))
	end
	data[classlower].elem = function()
		return select(7, ni.unit.debuff("target", 47865, "player"))
	end
	data[classlower].doom = function()
		return select(7, ni.unit.debuff("target", 47867, "player"))
	end
	data[classlower].agony = function()
		return select(7, ni.unit.debuff("target", 47864, "player"))
	end
	data[classlower].corruption = function()
		return select(7, ni.unit.debuff("target", 47813, "player"))
	end
	data[classlower].seed = function()
		return select(7, ni.unit.debuff("target", 47836, "player"))
	end
	data[classlower].haunt = function()
		return select(7, ni.unit.debuff("target", 59164, "player"))
	end
	data[classlower].ua = function()
		return select(7, ni.unit.debuff("target", 47843, "player"))
	end
	data[classlower].immolate = function()
		return select(7, ni.unit.debuff("target", 47811, "player"))
	end
	data[classlower].eplag = function() 
		return  ni.unit.debuff("target", 51735) 
	end
	data[classlower].earmoon = function()
		return ni.unit.debuff("target", 60433) 
	end
	-- Sirus Custom T4 --
	data[classlower].itemsetT4 = {
		28963, 28964, 28966, 28967, 28968, 100400, 100401, 100402, 100403, 100404
	};
	-- Check Item Set --
	data[classlower].checkforSet = function(t, pieces)
		local count = 0
		for _, v in ipairs(t) do
			if IsEquippedItem(v) then
				count = count + 1
			end
		end
		if count >= pieces then
			return true
		else
			return false
		end
	end
elseif classlower == "warrior" then
	data[classlower].LastShout = 0;
	data[classlower].rend = function() 
		return select(7, ni.unit.debuff("target", renddebuff, "player"))
	end
	data[classlower].hams = function() 
		return select(7, ni.unit.debuff("target", 1715, "player")) 
	end
end
return data;