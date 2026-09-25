-- Based on OratorTypeClass within Code/Combat/oratortypes.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class OratorTypeClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "OratorTypeClass"

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum OratorType
    STATIC.ORATOR_TYPE = {
        ORATOR_TYPE_START = enumBuilder:Set( 1000 ),
        ORATOR_GEEN       = enumBuilder:Set( 1000 ),
        ORATOR_GEGR       = enumBuilder:Next(),
        ORATOR_GEMG       = enumBuilder:Next(),
        ORATOR_GERS       = enumBuilder:Next(),
        ORATOR_GOEN       = enumBuilder:Next(),
        ORATOR_GOGR       = enumBuilder:Next(),
        ORATOR_GOMG       = enumBuilder:Next(),
        ORATOR_GORS       = enumBuilder:Next(),
        ORATOR_GOLS       = enumBuilder:Next(),
        ORATOR_GSEN       = enumBuilder:Next(),
        ORATOR_GSGR       = enumBuilder:Next(),
        ORATOR_GSMG       = enumBuilder:Next(),
        ORATOR_GSRS       = enumBuilder:Next(),
        ORATOR_GBMG       = enumBuilder:Next(),
        ORATOR_GBRS       = enumBuilder:Next(),

        ORATOR_MEIN       = enumBuilder:Next(),
        ORATOR_MOAC       = enumBuilder:Next(),
        ORATOR_MSTM       = enumBuilder:Next(),
        ORATOR_MBPT       = enumBuilder:Next(),
        ORATOR_MBRS       = enumBuilder:Next(),

        ORATOR_NEEN       = enumBuilder:Next(),
        ORATOR_NEFT       = enumBuilder:Next(),
        ORATOR_NEMG       = enumBuilder:Next(),
        ORATOR_NERS       = enumBuilder:Next(),
        ORATOR_NOEN       = enumBuilder:Next(),
        ORATOR_NOFT       = enumBuilder:Next(),
        ORATOR_NOMG       = enumBuilder:Next(),
        ORATOR_NORS       = enumBuilder:Next(),
        ORATOR_NSCW       = enumBuilder:Next(),
        ORATOR_NSEN       = enumBuilder:Next(),
        ORATOR_NSMG       = enumBuilder:Next(),
        ORATOR_NSRS       = enumBuilder:Next(),
        ORATOR_NSSS       = enumBuilder:Next(),
        ORATOR_NBFT       = enumBuilder:Next(),
        ORATOR_NBRS       = enumBuilder:Next(),
        ORATOR_NBMG       = enumBuilder:Next(),
        ORATOR_NOCP       = enumBuilder:Next(),
        ORATOR_NEFM       = enumBuilder:Next(),

        ORATOR_GCBL       = enumBuilder:Next(),
        ORATOR_GCFL       = enumBuilder:Next(),
        ORATOR_GCIM       = enumBuilder:Next(),
        ORATOR_GCTK       = enumBuilder:Next(),
        ORATOR_GCMP       = enumBuilder:Next(),
        ORATOR_GCP1       = enumBuilder:Next(),
        ORATOR_GCP2       = enumBuilder:Next(),
        ORATOR_GCP3       = enumBuilder:Next(),
        ORATOR_GCBB       = enumBuilder:Next(),
        ORATOR_GCF1       = enumBuilder:Next(),
        ORATOR_GCM1       = enumBuilder:Next(),
        ORATOR_GCM2       = enumBuilder:Next(),
        ORATOR_GCXN       = enumBuilder:Next(),
        ORATOR_GCXP       = enumBuilder:Next(),
        ORATOR_GCC1       = enumBuilder:Next(),
        ORATOR_GCC2       = enumBuilder:Next(),
        ORATOR_GCC3       = enumBuilder:Next(),
        ORATOR_GCC4       = enumBuilder:Next(),
        ORATOR_GCC5       = enumBuilder:Next(),
        ORATOR_GCC6       = enumBuilder:Next(),
        ORATOR_GCBS       = enumBuilder:Next(),
        ORATOR_GCLS       = enumBuilder:Next(),
        ORATOR_GCSO       = enumBuilder:Next(),

        ORATOR_NCXK       = enumBuilder:Next(),
        ORATOR_NCTK       = enumBuilder:Next(),
        ORATOR_NCXP       = enumBuilder:Next(),
        ORATOR_NCXS       = enumBuilder:Next(),
        ORATOR_NCGB       = enumBuilder:Next(),
        ORATOR_NCXT       = enumBuilder:Next(),

        ORATOR_CCFM       = enumBuilder:Next(),
        ORATOR_CCNC       = enumBuilder:Next(),
        ORATOR_CCSF       = enumBuilder:Next(),
        ORATOR_CCSM       = enumBuilder:Next(),
        ORATOR_CCCK       = enumBuilder:Next(),

        ORATOR_AVIS       = enumBuilder:Next(),

        ORATOR_RGS1       = enumBuilder:Next(),
        ORATOR_RGS2       = enumBuilder:Next(),
        ORATOR_RGS3       = enumBuilder:Next(),
        ORATOR_RGS4       = enumBuilder:Next(),
        ORATOR_RNS1       = enumBuilder:Next(),
        ORATOR_RNS2       = enumBuilder:Next(),
        ORATOR_RNS3       = enumBuilder:Next(),
        ORATOR_RNS4       = enumBuilder:Next(),

        ORATOR_EVAG       = enumBuilder:Next(),
        ORATOR_EVAL       = enumBuilder:Next(),
        ORATOR_EVAN       = enumBuilder:Next(),
        ORATOR_EVAC       = enumBuilder:Next(),

        ORATOR_VNCH       = enumBuilder:Next(),

        ORATOR_TYPE_MAX   = enumBuilder:Next(),
        ORATOR_TYPE_COUNT = -1
    }
    STATIC.ORATOR_TYPE.ORATOR_TYPE_COUNT = STATIC.ORATOR_TYPE.ORATOR_TYPE_MAX - STATIC.ORATOR_TYPE.ORATOR_TYPE_START
    local snapshotEnum = STATIC.ORATOR_TYPE
--#endregion

--#region Imports


--#endregion


--#region Imported Enums
--#endregion

--- @class OratorTypeClass

STATIC.ORATOR_TYPE_NAMES = {
    "GEEN: GDI Enlisted Engineer",
	"GEGR: GDI Enlisted Grenadier",
	"GEMG: GDI Enlisted Mini-gunner",
	"GERS: GDI Enlisted Rocket Soldier",
	"GOEN: GDI Officer Engineer Officer",
	"GOGR: GDI Officer Grenadier Officer",
	"GOMG: GDI Officer Mini-gunner Officer",
	"GORS: GDI Officer Rocket Solider Officer",
	"GOLS: GDI Officer Logan Sheppard",
	"GSEN: GDI Special Forces Engineer",
	"GSGR: GDI Special Forces Grenadier",
	"GSMG: GDI Special Forces Mini-gunner",
	"GSRS: GDI Special Forces Rocket soldier",
	"GBMG: GDI Boss Havoc",
	"GBRS: GDI Boss Sydney Mobius",

	"MEIN: Mutant Enlisted Initiate",
	"MOAC: Mutant Officer Acolyte",
	"MSTM: Mutant Special Forces Templar",
	"MBPT: Mutant Boss Mutant Petrova",
	"MBRS: Mutant Boss Mutant Raveshaw",

	"NEEN: Nod Enlisted Engineer",
	"NEFT: Nod Enlisted Flame Thrower",
	"NEMG: Nod Enlisted Mini-gunner",
	"NERS: Nod Enlisted Rocket Soldier",
	"NOEN: Nod Officer Engineer Officer",
	"NOFT: Nod Officer Flame Thrower Officer",
	"NOMG: Nod Officer Mini-gunner Officer",
	"NORS: Nod Officer Rocket Solider Officer",
	"NSCW: Nod Special Forces Chem Warrior",
	"NSEN: Nod Special Forces Engineer",
	"NSMG: Nod Special Forces Mini-gunner",
	"NSRS: Nod Special Forces Rocket Soldier",
	"NSSS: Nod Special Forces Stealth Solder",
	"NBFT: Nod Boss Mendoza",
	"NBRS: Nod Boss Raveshaw",
	"NBMG: Nod Boss Sakura",
	"NOCP: Nod Officer Ship Captain",
	"NEFM: Nod Enlisted First Mate",

	"GCBL: GDI Civilian Brigadier Adam Locke",
	"GCFL: GDI Civilian Female Lieutenant",
	"GCIM: GDI Civilian Ignatio Mobius",
	"GCTK: GDI Civilian Technician",
	"GCMP: GDI Civilian MP's",
	"GCP1: GDI Civilian GDI Prisoner 1",
	"GCP2: GDI Civilian GDI Prisoner 2",
	"GCP3: GDI Civilian GDI Prisoner 3",
	"GCBB: GDI Civilian Resistance Babushka",
	"GCF1: GDI Civilian Resistance Female",
	"GCM1: GDI Civilian Resistance Male 1",
	"GCM2: GDI Civilian Resistance Male 2",
	"GCXN: GDI Civilian Nun",
	"GCXP: GDI Civilian Priest",
	"GCC1: GDI Civilian 1",
	"GCC2: GDI Civilian 2",
	"GCC3: GDI Civilian 3",
	"GCC4: GDI Civilian 4",
	"GCC5: GDI Civilian 5",
	"GCC6: GDI Civilian 6",
	"GCBS: GDI Civilian Brigadier Shepherd",
	"GCLS: GDI Civilian Logan Shepsherd",
	"GCSO: GDI Civilian UN Secretary Generl Charles Ovlivette",

	"NCXK: Civilian Kane",
	"NCTK: Nod Technician",
	"NCXP: Civilian Petrova",
	"NCXS: Civilian Seth",
	"NCGB: Nod Civilian Greg Brudette",
	"NCXT: Nod Civilian Technician",

	"CCFM: Neutral Civilian Farmer",
	"CCNC: Civilian Newscaster",
	"CCSF: Servant, Female",
	"CCSM: Servant, Male",
	"CCCK: Civilian Cook",

	"AVIS: Visceroid",

	"RGS1: GDI Radio Speaker 1",
	"RGS2: GDI Radio Speaker 2",
	"RGS3: GDI Radio Speaker 3",
	"RGS4: GDI Radio Speaker 4",
	"RNS1: Nod Radio Speaker 1",
	"RNS2: Nod Radio Speaker 2",
	"RNS3: Nod Radio Speaker 3",
	"RNS4: Nod Radio Speaker 4",

	"EVAG: EVA",
	"EVAL: Brigadier Adam Locke via EVA",
	"EVAN: Nod Public Announcement Speaker",
	"EVAC: Temple of Nod Computer (malfunctioning)",

	"VNCH: Transport Chinook Helicopter"
}

function STATIC.GetCount()
    return STATIC.ORATOR_TYPE.ORATOR_TYPE_COUNT
end

--- @param index integer
--- @return integer
function STATIC.GetId( index )
    local returnValue = 0

    if index >= 1 and index <= STATIC.ORATOR_TYPE.ORATOR_TYPE_COUNT then
        returnValue = STATIC.ORATOR_TYPE.ORATOR_TYPE_START + index
    end

    return returnValue
end

--- @param index integer
--- @return string
function STATIC.GetDescription( index )
    local returnValue = ""

    if index >= 1 and index <= STATIC.ORATOR_TYPE.ORATOR_TYPE_COUNT then
        returnValue = STATIC.ORATOR_TYPE_NAMES[index]
    end

    return returnValue
end
