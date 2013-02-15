CreateClientConVar( "gy_nextwep_enabled", "1", true, false )
CreateClientConVar( "gy_nextwep_delay", ".4", true, false )
include( "shared.lua" )
include( "cl_hud.lua" )
include( "wepgen.lua" )
include( "cl_scoreboard.lua" )
include( "mapchange.lua" )
AddCSLuaFile( "mapchange.lua" )
if CLIENT then
InitializeFonts()
end