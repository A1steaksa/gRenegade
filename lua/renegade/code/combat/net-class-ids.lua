-- Based on the enums within Code/Combat/netclassids.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class NetClassId
local STATIC = CNC.CreateExport()

--#region Imports

    --- @type EnumBuilderClass
    local enumBaseClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion

local enumBuilder = enumBaseClass.New()


--[[ Script-Created Objects ]] do

    STATIC.NETCLASSID_GAMEOBJ                 = enumBuilder:Set( 1000 )
    STATIC.NETCLASSID_SCTEXTOBJ               = enumBuilder:Next()
	STATIC.NETCLASSID_PLAYERKILL              = enumBuilder:Next()
	STATIC.NETCLASSID_WIN                     = enumBuilder:Next()
	STATIC.NETCLASSID_PURCHASERESPONSEEVENT   = enumBuilder:Next()
	STATIC.NETCLASSID_CONSOLECOMMANDEVENT     = enumBuilder:Next()
	STATIC.NETCLASSID_RESETWINSEVENT          = enumBuilder:Next()
	STATIC.NETCLASSID_SVRGOODBYEEVENT         = enumBuilder:Next()
	STATIC.NETCLASSID_GAMEOPTIONSEVENT        = enumBuilder:Next()
	STATIC.NETCLASSID_EVICTIONEVENT           = enumBuilder:Next()
	STATIC.NETCLASSID_TEAM                    = enumBuilder:Next()
	STATIC.NETCLASSID_PLAYER                  = enumBuilder:Next()
	STATIC.NETCLASSID_GAMEDATAUPDATEEVENT     = enumBuilder:Next()
	STATIC.NETCLASSID_SCPINGRESPONSEEVENT     = enumBuilder:Next()
	STATIC.NETCLASSID_SCEXPLOSIONEVENT        = enumBuilder:Next()
	STATIC.NETCLASSID_SCOBELISKEVENT          = enumBuilder:Next()
	STATIC.NETCLASSID_SCANNOUNCEMENT          = enumBuilder:Next()
	STATIC.NETCLASSID_GAMESPYSCCHALLENGEEVENT = enumBuilder:Next()
end


--[[ C-Created Objects ]] do

    ETCLASSID_CLIENTCONTROL                    = enumBuilder:Next()
    NETCLASSID_CSTEXTOBJ                       = enumBuilder:Next()
    NETCLASSID_SUICIDEEVENT                    = enumBuilder:Next()
    NETCLASSID_CHANGETEAMEVENT                 = enumBuilder:Next()
    NETCLASSID_MONEYEVENT                      = enumBuilder:Next()
    NETCLASSID_WARPEVENT                       = enumBuilder:Next()
    NETCLASSID_PURCHASEREQUESTEVENT            = enumBuilder:Next()
    NETCLASSID_CLIENTGOODBYEEVENT              = enumBuilder:Next()
    NETCLASSID_BIOEVENT                        = enumBuilder:Next()
    NETCLASSID_LOADINGEVENT                    = enumBuilder:Next()
    NETCLASSID_GODMODEEVENT                    = enumBuilder:Next()
    NETCLASSID_VIPMODEEVENT                    = enumBuilder:Next()
    NETCLASSID_SCOREEVENT                      = enumBuilder:Next()
    NETCLASSID_CLIENTBBOEVENT                  = enumBuilder:Next()
    NETCLASSID_CLIENTFPS                       = enumBuilder:Next()
    NETCLASSID_CSPINGREQUESTEVENT              = enumBuilder:Next()
    NETCLASSID_CSDAMAGEEVENT                   = enumBuilder:Next()
    NETCLASSID_REQUESTKILLEVENT                = enumBuilder:Next()
    NETCLASSID_CSCONSOLECOMMANDEVENT           = enumBuilder:Next()
    NETCLASSID_CSHINT                          = enumBuilder:Next()
    NETCLASSID_CSANNOUNCEMENT                  = enumBuilder:Next()
    NETCLASSID_DONATEEVENT                     = enumBuilder:Next()
    NETCLASSID_GAMESPYCSCHALLENGERESPONSEEVENT = enumBuilder:Next()
end
