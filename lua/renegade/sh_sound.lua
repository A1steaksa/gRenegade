-- This library handles networking and loading audio files

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SoundLib
local LIB = CNC.CreateExport()
local isHotload = not table.IsEmpty( LIB )
LIB.Class = "SoundLib"

--#region Exported Enums
--#endregion

--#region Imports

	--- @type WWAudioClass
	local wWAudioClass = CNC.Import( "code/wwaudio/ww-audio.lua" )
--#endregion

--#region Imported Enums
--#endregion

--- @class SoundLib

if SERVER then
    util.AddNetworkString( "A1_Renegade_Sound" )

    --- @param definitionId integer
    --- @param position Vector
    --- @param classIdHint integer
    function LIB.PlaySound( definitionId, position, classIdHint )
        net.Start( "A1_Renegade_Sound" )

        net.WriteInt( definitionId, 32 )
        net.WriteVector( position )
        net.WriteInt( classIdHint, 32 )

        net.Broadcast()
    end
end

if CLIENT then
    net.Receive( "A1_Renegade_Sound", function()
        local definitionId  = net.ReadInt( 32 )
        local position      = net.ReadVector()
        local classIdHint   = net.ReadInt( 32 )

        wWAudioClass.GetInstance():CreateInstantSound( definitionId, position, nil, 0, classIdHint )
    end )
end