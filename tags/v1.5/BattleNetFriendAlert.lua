--------------------------------------------------------------------------------------------------------------------------------------------
-- Initialize Variables
--------------------------------------------------------------------------------------------------------------------------------------------
local NS = select( 2, ... );
NS.interval = 3; -- Seconds between ScanFriends()
NS.friends = {};
NS.icons = {
	["Friend"] = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:16:16:0:0:32:32:2:30:2:30|t",
	["App"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14|t",
	["WoW"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WoW:14|t",
	["D3"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-D3:14|t",
	["WTCG"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WTCG:14|t",
	["Hero"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-HotS:14|t",
	["S2"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-SC2:14|t",
};
local L = NS.localization;
--------------------------------------------------------------------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------------------------------------------------------------------
NS.BNPlayerLink = function( presenceName, presenceID )
	return string.format( "|HBNplayer:%s:%s|h[%s]|h", presenceName, presenceID, presenceName );
end

--
NS.ScanFriends = function()
	if BNConnected() then
		for index = 1, BNGetNumFriends() do
			local presenceID,presenceName,_,_,characterName,_,game = BNGetFriendInfo( index );
			if game and NS.friends[presenceID] and NS.friends[presenceID]["game"] then -- Make sure friend is online now and was online during last scan
				if game ~= NS.friends[presenceID]["game"] then -- Alert, friend has switched games (App considered a game)
					if game == "App" then
						print( BATTLENET_FONT_COLOR_CODE .. NS.icons["Friend"] .. string.format( L["%s stopped playing (%sIn Battle.net)."], NS.BNPlayerLink( presenceName, presenceID ), NS.icons[game] ) .. FONT_COLOR_CODE_CLOSE );
					else
						print( BATTLENET_FONT_COLOR_CODE .. NS.icons["Friend"] .. string.format( L["%s is now playing (%s%s)."], NS.BNPlayerLink( presenceName, presenceID ), NS.icons[game], characterName ) .. FONT_COLOR_CODE_CLOSE );
						PlaySound( "UI_BnetToast" );
					end
				end
			end
			-- Record latest friend info
			NS.friends[presenceID] = { ["game"] = game };
		end
	end
	-- Scan again in interval seconds
	C_Timer.After( NS.interval, NS.ScanFriends );
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- EventsFrame
--------------------------------------------------------------------------------------------------------------------------------------------
local f = CreateFrame( "Frame", "BNFAEventsFrame", UIParent );
f:SetScript( "OnEvent", function () C_Timer.After( NS.interval, NS.ScanFriends ); end ); -- Scan interval seconds after PLAYER_LOGIN
f:RegisterEvent( "PLAYER_LOGIN" );
