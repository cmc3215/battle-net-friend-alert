﻿--------------------------------------------------------------------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------------------------------------------------------------------
local NS = select( 2, ... );
--------------------------------------------------------------------------------------------------------------------------------------------
NS.localization = setmetatable( {}, { __index = function( self, key )
	self[key] = key; -- Use original phrase for undefined keys
	return key;
end } );
--
local L = NS.localization;
-- enUS, enGB
if GetLocale() == "enUS" or GetLocale() == "enGB" then
-- L["%s is now playing (%s%s)."] = ""
-- L["%s stopped playing (%sIn Battle.net)."] = ""
-- L["World of Warcraft"] = ""
-- L["Diablo III"] = ""
-- L["Hearthstone"] = ""
-- L["Heroes of the Storm"] = ""
-- L["StarCraft II"] = ""
-- L["Overwatch"] = ""
-- deDE
elseif GetLocale() == "deDE" then
-- esES
elseif GetLocale() == "esES" then
-- frFR
elseif GetLocale() == "frFR" then
-- itIT
elseif GetLocale() == "itIT" then
-- koKR
elseif GetLocale() == "koKR" then
-- ptBR
elseif GetLocale() == "ptBR" then
-- ruRU
elseif GetLocale() == "ruRU" then
-- zhCN
elseif GetLocale() == "zhCN" then
-- zhTW
elseif GetLocale() == "zhTW" then
end
