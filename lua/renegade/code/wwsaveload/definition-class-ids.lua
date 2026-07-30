-- Based on the enums within Code/wwsaveload/definitionclassids.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DefinitionClassIds
local STATIC = CNC.CreateExport()


STATIC.DEF_CLASSID_START = 0x00001000
STATIC.DEF_CLASSID_RANGE = 0x00001000

local function NextSuperClassId( n )
    return STATIC.DEF_CLASSID_START + ( n * STATIC.DEF_CLASSID_RANGE )
end

--#region Exported Enums

    --- "  
    --- DefinitionClassID  
    --- Note: The following enum should contain ALL of the class IDs for definitions
    --- in the entire system (to guarantee they are unique). Each super-class is
    --- allocated a range of class IDs.  Use the [SuperClassIdFromClassId] function to
    --- determine which super class a particular class ID belongs to.  
    --- "  
    --- @enum ClassId
    STATIC.CLASS_ID = {
        TERRAIN			= NextSuperClassId( 0 ),
        TILE			= NextSuperClassId( 1 ),
        GAME_OBJECTS	= NextSuperClassId( 2 ),
        LIGHT			= NextSuperClassId( 3 ),
        SOUND			= NextSuperClassId( 4 ),
        WAYPATH			= NextSuperClassId( 5 ),
        ZONE			= NextSuperClassId( 6 ),
        TRANSITION		= NextSuperClassId( 7 ),
        PHYSICS			= NextSuperClassId( 8 ),
        EDITOR_OBJECTS	= NextSuperClassId( 9 ),
        MUNITIONS		= NextSuperClassId( 10 ),
        DUMMY_OBJECTS	= NextSuperClassId( 11 ),
        BUILDINGS		= NextSuperClassId( 12 ),
        TWIDDLERS		= NextSuperClassId( 13 ),
        GLOBAL_SETTINGS	= NextSuperClassId( 14 )
    }
--#endregion

--- @param classId integer
function STATIC.SuperClassIdFromClassId( classId )
    -- "Which id-range does it fall under?"
    local delta = classId - STATIC.DEF_CLASSID_START

    -- Approximating integer division with floor (praying for positive results)
    local numRanges = math.floor( delta / STATIC.DEF_CLASSID_RANGE )

    return STATIC.DEF_CLASSID_START + ( numRanges * STATIC.DEF_CLASSID_RANGE )
end