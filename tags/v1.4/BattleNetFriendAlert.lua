--------------------------------------------------------------------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------------------------------------------------------------------
local BNFA_INTERVAL = 3;
local BNFA_TOTAL_ELAPSED = 0;
local BNFA_FRIENDS = {};
local BNFA_ICON = {
	["Friend"] = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:16:16:0:0:32:32:2:30:2:30|t",
	["App"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14|t",
	["WoW"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WoW:14|t",
	["D3"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-D3:14|t",
	["WTCG"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WTCG:14|t",
	["Hero"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-HotS:14|t",
	["S2"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-SC2:14|t",
};
local L = BNFA_LOCALIZATION;
--------------------------------------------------------------------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------------------------------------------------------------------
function BNFA_ScanFriendsTimer( self, elapsed )
	BNFA_TOTAL_ELAPSED = BNFA_TOTAL_ELAPSED + elapsed;
	if BNFA_TOTAL_ELAPSED >= BNFA_INTERVAL then
		self:SetScript( "OnUpdate", nil );
		BNFA_ScanFriends();
		BNFA_TOTAL_ELAPSED = 0;
		self:SetScript( "OnUpdate", BNFA_ScanFriendsTimer );
	end
end

--
function BNFA_HBNPlayer( presenceName, presenceID )
	return string.format( "|HBNplayer:%s:%s|h[%s]|h", presenceName, presenceID, presenceName );
end

--
function BNFA_ScanFriends()
	if BNConnected() then
		local total, online = BNGetNumFriends();
		--
		for index = 1, total do
			local presenceID,presenceName,_,_,characterName,_,game,_,_,_,_,_,_,_,_,_ = BNGetFriendInfo( index ); -- presenceID, presenceName, battleTag, isBattleTagPresence, characterName, toonID, game, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, broadcastTime, canSoR = BNGetFriendInfo( friendIndex )
			-- Make sure friend is online now and was online during last scan
			if game and BNFA_FRIENDS[presenceID] and BNFA_FRIENDS[presenceID]["game"] then
				-- Alert, friend has switched games (App considered a game)
				if game ~= BNFA_FRIENDS[presenceID]["game"] then
					if game == "App" then
						print( BATTLENET_FONT_COLOR_CODE .. BNFA_ICON["Friend"] .. string.format( L["%s stopped playing (%sIn Battle.net)."], BNFA_HBNPlayer( presenceName, presenceID ), BNFA_ICON[game] ) .. "|r" );
					else
						print( BATTLENET_FONT_COLOR_CODE .. BNFA_ICON["Friend"] .. string.format( L["%s is now playing (%s%s)."], BNFA_HBNPlayer( presenceName, presenceID ), BNFA_ICON[game], characterName ) .. "|r" );
						PlaySound( "UI_BnetToast" );
					end
				end
			end
			-- Record latest friend info
			BNFA_FRIENDS[presenceID] = { ["game"] = game };
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------------------------------------------------------------------
local f = CreateFrame( "Frame", "BNFA_EventsFrame", UIParent );
f:SetScript( "OnEvent", function ( self, event, ... )
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent( "PLAYER_LOGIN" );
		self:SetScript( "OnEvent", nil );
		self:SetScript( "OnUpdate", BNFA_ScanFriendsTimer );
	end
end );
f:RegisterEvent( "PLAYER_LOGIN" );
