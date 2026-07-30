-- Based on the global functions within Code/Combat/assets.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class AssetsClass
local STATIC = CNC.CreateExport()
STATIC.Class = "AssetsClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums
--#endregion


--#region Imports

    --- @type IniClass
    local iniClass = CNC.Import( "code/wwlib/ini.lua" )

    --- @type FileFactoryClass
    local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )
--#endregion


--#region Imported Enums
--#endregion


--- @class AssetsClass

--[[ INI File Access ]] do

    --- @param fileName string
    --- @return IniInstance
    function STATIC.GetIni( fileName )
        local ini

        local iniFile = fileFactoryClass.TheFileFactory:GetFile( fileName )
        if iniFile ~= nil then
            if iniFile:IsAvailable() then
                ini = iniClass.New( iniFile )
            end
            fileFactoryClass.TheFileFactory:ReturnFile( iniFile )
        else
            section.Error( "INI file does not exist or cannot be read: '", fileName, "'" )
        end

        return ini
    end

    --- @param pIni IniInstance
    --- @param fileName string
    function STATIC.SaveIni( pIni, fileName )
        typecheck.NotImplementedError()
    end
end

--[[ Path Stripping ]] do

    --- @param fileName string
    --- @return string newName
    function STATIC.StripPathFromFileName( fileName )
        typecheck.NotImplementedError()
    end

    --- @param fileName string
    --- @return string newName
    function STATIC.GetRenderObjNameFromFileName( fileName )
        typecheck.NotImplementedError()
    end
end

--[[ Asset Access ]] do

    --- @param fileName string
    --- @return RenderObjInstance
    function STATIC.CreateRenderObjectFromFileName( fileName )
        typecheck.NotImplementedError()
    end

    --- @param fileName string
    --- @param mipLevelCount MipCountType? [Default: All]
    --- @return IMaterial
    function STATIC.GetMaterialFromFilename( fileName, mipLevelCount )
        typecheck.NotImplementedError()
    end
end

--[[ Filenames ]] do

    --- @param modelName string
    --- @param animFileName string
    --- @return string animName
    function STATIC.CreateAnimationName( animFileName, modelName )
        typecheck.NotImplementedError()
    end
end