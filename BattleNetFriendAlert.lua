--------------------------------------------------------------------------------------------------------------------------------------------
-- Initialize Variables
--------------------------------------------------------------------------------------------------------------------------------------------
local NS = select( 2, ... );
local L = NS.localization;
NS.addon = ...;
NS.title = GetAddOnMetadata( NS.addon, "Title" );
NS.versionString = "3.4";
NS.version = tonumber( NS.versionString );
--
NS.interval = 3; -- Seconds between ScanFriends()
NS.friends = {};
NS.icons = {
	["DST2"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Destiny2:14|t",
	["WTCG"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WTCG:14|t",
	["WoW"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WoW:14|t",
	["S1"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-SC:14|t",
	["D3"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-D3:14|t",
	["VIPR"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-CallOfDutyBlackOps4:14|t",
	["Hero"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-HotS:14|t",
	["Pro"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Overwatch:14|t",
	["App"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14|t", -- Blizzard Battle.net App (Desktop)
	["S2"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-SC2:14|t",
	--["CLNT"] -- Unknown
	["BSAp"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14|t", -- Blizzard Battle.net App (Mobile)
	--
	["Friend"] = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:16:16:0:0:32:32:2:30:2:30|t",
};
NS.games = {
	["DST2"] = L["Destiny 2"],
	["WTCG"] = L["Hearthstone"],
	["WoW"] = L["World of Warcraft"],
	["S1"] = L["StarCraft: Remastered"],
	["VIPR"] = L["Call of Duty: Black Ops 4"],
	["D3"] = L["Diablo III"],
	["Hero"] = L["Heroes of the Storm"],
	["Pro"] = L["Overwatch"],
	["App"] = L["In App"],
	["S2"] = L["StarCraft II"],
	--["CLNT"] -- Unknown
	["BSAp"] = L["Mobile"],
};
--------------------------------------------------------------------------------------------------------------------------------------------
-- Miscellaneous Functions
--------------------------------------------------------------------------------------------------------------------------------------------
NS.BNPlayerLink = function ( accountName, bnetIDAccount )
	return string.format( "|HBNplayer:%s:%s|h[%s]|h", accountName, bnetIDAccount, accountName );
end
--
NS.ScanFriends = function ()
	if BNConnected() then
		for index = 1, BNGetNumFriends() do
			local bnetIDAccount,accountName,_,_,characterName,_,game = BNGetFriendInfo( index );
			if game and NS.friends[bnetIDAccount] and NS.friends[bnetIDAccount]["game"] then -- Make sure friend is online now and was online during last scan
				if game ~= NS.friends[bnetIDAccount]["game"] then -- Alert, friend has switched games (App and BSAp are considered "games")
					if game == "App" or game == "BSAp" then
						if NS.friends[bnetIDAccount]["game"] ~= "App" and NS.friends[bnetIDAccount]["game"] ~= "BSAp" then -- Friend only "stopped playing" if they were previously playing a "game" other than App or BSAp
							NS.AddMessageToWindow( NS.icons["Friend"] .. string.format( L["%s stopped playing (%s%s)."], NS.BNPlayerLink( accountName, bnetIDAccount ), NS.icons[game], NS.games[game] ) );
						end
					else
						NS.AddMessageToWindow( NS.icons["Friend"] .. string.format( L["%s is now playing (%s%s)."], NS.BNPlayerLink( accountName, bnetIDAccount ), ( NS.icons[game] or L["Unknown Game"] ), ( characterName or ( NS.icons[game] and NS.games[game] or "" ) ) ) );
						PlaySound( 18019 ); -- UI_BnetToast
					end
				end
			end
			-- Record latest friend info
			NS.friends[bnetIDAccount] = NS.friends[bnetIDAccount] or {};
			NS.friends[bnetIDAccount]["game"] = game;
		end
	end
	-- Scan again in interval seconds
	C_Timer.After( NS.interval, NS.ScanFriends );
end
--
NS.AddMessageToWindow = function ( msg )
	local frameNum;
	if NS.db["window"] then
		for i = 1, NUM_CHAT_WINDOWS do
			if GetChatWindowInfo( i ) == NS.db["window"] and _G["ChatFrame" .. i .. "Tab"]:IsShown() then
				frameNum = i;
				break;
			end
		end
	end
	--
	local ChatFrame = frameNum and _G["ChatFrame" .. frameNum] or DEFAULT_CHAT_FRAME;
	ChatFrame:AddMessage( msg, BATTLENET_FONT_COLOR["r"], BATTLENET_FONT_COLOR["g"], BATTLENET_FONT_COLOR["b"] );
	if NS.db["flash"] then
		FCF_FlashTab( ChatFrame );
	end
end
--
NS.Print = function( msg )
	print( ORANGE_FONT_COLOR_CODE .. "<|r" .. NORMAL_FONT_COLOR_CODE .. NS.addon .. "|r" .. ORANGE_FONT_COLOR_CODE .. ">|r " .. msg );
end
--
NS.DefaultSavedVariables = function()
	return {
		["version"] = NS.version,
		["window"] = nil,
		["flash"] = true,
	};
end
--
NS.Upgrade = function()
	local vars = NS.DefaultSavedVariables();
	local version = NS.db["version"];
	-- 2.5
	--if version < 2.5 then
		-- Updates
	--end
	--
	NS.db["version"] = NS.version;
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Slash Command(s)
--------------------------------------------------------------------------------------------------------------------------------------------
NS.SlashCmdHandler = function ( cmd )
	if cmd and string.match( cmd, "^window " ) or cmd == "window" then
		------------------------------------------------------------------------------------------
		-- Window
		------------------------------------------------------------------------------------------
		local _,window = strsplit( " ", strtrim( cmd ), 2 );
		--
		if window and window ~= "" then
			if window == "default" then
				NS.db["window"] = nil; -- Default
				NS.Print( GREEN_FONT_COLOR_CODE .. string.format( L["Window reset to DEFAULT_CHAT_FRAME."], CHAT_DEFAULT ) .. FONT_COLOR_CODE_CLOSE );
			else
				local frameNum;
				for i = 1, NUM_CHAT_WINDOWS do
					if GetChatWindowInfo( i ) == window and _G["ChatFrame" .. i .. "Tab"]:IsShown() then
						frameNum = i;
						break;
					end
				end
				if frameNum then
					NS.db["window"] = window; -- Set
					NS.Print( GREEN_FONT_COLOR_CODE .. string.format( L["%s - Window found and set successfully."], window ) .. FONT_COLOR_CODE_CLOSE );
				else
					NS.Print( RED_FONT_COLOR_CODE .. string.format( L["Window \"%s\" not found, please check the name and try again."], window ) .. FONT_COLOR_CODE_CLOSE );
				end
			end
		else
			NS.Print( BATTLENET_FONT_COLOR_CODE .. string.format( L["Window: %s"], ( NS.db["window"] and NS.db["window"] or CHAT_DEFAULT ) ) .. FONT_COLOR_CODE_CLOSE );
		end
	elseif cmd and string.match( cmd, "^flash " ) or cmd == "flash" then
		------------------------------------------------------------------------------------------
		-- Flash
		------------------------------------------------------------------------------------------
		local _,flash = strsplit( " ", strtrim( cmd ), 2 );
		--
		if flash and flash ~= "" then
			flash = strlower( flash );
			if flash == "on" or flash == "off" then
				NS.db["flash"] = ( flash == "on" and true ) or false;
				NS.Print( GREEN_FONT_COLOR_CODE .. string.format( L["%s - Flash set successfully."], ( NS.db["flash"] and "On" or "Off" ) ) .. FONT_COLOR_CODE_CLOSE );
			else
				return NS.SlashCmdHandler(); -- Help
			end
		else
			NS.Print( BATTLENET_FONT_COLOR_CODE .. string.format( L["Flash: %s"], ( NS.db["flash"] and "On" or "Off" ) ) .. FONT_COLOR_CODE_CLOSE );
		end
	else
		------------------------------------------------------------------------------------------
		-- Help
		------------------------------------------------------------------------------------------
		print( BATTLENET_FONT_COLOR_CODE .. NS.title .. FONT_COLOR_CODE_CLOSE );
		print( YELLOW_FONT_COLOR_CODE .. "/bnfa window <name> : Set the name of the window to use for alerts. Use \"default\" to reset to DEFAULT_CHAT_FRAME." .. FONT_COLOR_CODE_CLOSE );
		print( YELLOW_FONT_COLOR_CODE .. "/bnfa flash <setting> on|off : Enable or disable chat tab flash on alert." .. FONT_COLOR_CODE_CLOSE );
	end
end
--
SLASH_BATTLENETFRIENDALERT1 = "/battlenetfriendalert";
SLASH_BATTLENETFRIENDALERT2 = "/bnfa";
SlashCmdList["BATTLENETFRIENDALERT"] = function ( msg ) NS.SlashCmdHandler( msg ) end;
--------------------------------------------------------------------------------------------------------------------------------------------
-- EventsFrame
--------------------------------------------------------------------------------------------------------------------------------------------
local f = CreateFrame( "Frame", "BNFAEventsFrame", UIParent );
f:SetScript( "OnEvent", function ( self, event, ... )
	if 		event == "PLAYER_LOGIN" then
		------------------------------------------------------------------------------------------------------------------------------------
		-- Start Scanning Friends
		------------------------------------------------------------------------------------------------------------------------------------
		self:UnregisterEvent( event );
		C_Timer.After( NS.interval, NS.ScanFriends );
	elseif	event == "ADDON_LOADED" then
		------------------------------------------------------------------------------------------------------------------------------------
		-- SavedVariables
		------------------------------------------------------------------------------------------------------------------------------------
		if IsAddOnLoaded( NS.addon ) then
			self:UnregisterEvent( event );
			-- Defaults
			if not BATTLENETFRIENDALERT_SAVEDVARIABLES then
				BATTLENETFRIENDALERT_SAVEDVARIABLES = NS.DefaultSavedVariables();
			end
			-- Make Local
			NS.db = BATTLENETFRIENDALERT_SAVEDVARIABLES;
			-- Upgrade
			if NS.db["version"] < NS.version then
				NS.Upgrade();
			end
		end
	end
end );
f:RegisterEvent( "ADDON_LOADED" );
f:RegisterEvent( "PLAYER_LOGIN" );
