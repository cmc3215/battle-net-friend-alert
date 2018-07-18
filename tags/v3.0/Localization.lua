--------------------------------------------------------------------------------------------------------------------------------------------
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
--@localization(locale="enUS", format="lua_additive_table")@
-- deDE
elseif GetLocale() == "deDE" then
--@localization(locale="deDE", format="lua_additive_table")@
-- esES
elseif GetLocale() == "esES" then
--@localization(locale="esES", format="lua_additive_table")@
-- frFR
elseif GetLocale() == "frFR" then
--@localization(locale="frFR", format="lua_additive_table")@
-- itIT
elseif GetLocale() == "itIT" then
--@localization(locale="itIT", format="lua_additive_table")@
-- koKR
elseif GetLocale() == "koKR" then
--@localization(locale="koKR", format="lua_additive_table")@
-- ptBR
elseif GetLocale() == "ptBR" then
--@localization(locale="ptBR", format="lua_additive_table")@
-- ruRU
elseif GetLocale() == "ruRU" then
--@localization(locale="ruRU", format="lua_additive_table")@
-- zhCN
elseif GetLocale() == "zhCN" then
--@localization(locale="zhCN", format="lua_additive_table")@
-- zhTW
elseif GetLocale() == "zhTW" then
--@localization(locale="zhTW", format="lua_additive_table")@
end
