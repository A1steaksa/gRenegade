-- This is the kernel file for Command & Conquer Renegade content in Garry's Mod
-- It is responsible for starting the rest of the addon.

--- The global table containing all addon content for Command & Conquer: Renegade
--- @class Renegade
CNC_RENEGADE = CNC_RENEGADE or {}
local CNC = CNC_RENEGADE


--#region Helper Functions

    --- Iterates over all files within a directory and its sub-directories and calls a given function with each file's path passed as the arugment 
    --- @param directoryPath string The directory to search through
    --- @param gameLocation string The virtual folder structure location to search (E.g. DATA or THIRDPARTY)
    --- @param func fun( filePath: string )
    function CNC_RENEGADE.IterateFilesRecursively( directoryPath, gameLocation, func )
        if not string.EndsWith( directoryPath, "/" ) then directoryPath = directoryPath .. "/" end
        local files, directories = file.Find( directoryPath .. "*", gameLocation )

        -- Run the function on each file in the directory
        for _, file in ipairs( files ) do
            func( directoryPath .. file )
        end

        -- Recurse on each sub-directory
        for _, directory in ipairs( directories ) do
            local nextDir = directoryPath .. directory .. "/"
            CNC_RENEGADE.IterateFilesRecursively( nextDir, gameLocation, func )
        end
    end

    --- Finds all files within a directory and call a function for each file, passing in the file's path 
    --- @param directoryPath string The directory to search through
    --- @param gameLocation string The virtual folder structure location to search (E.g. DATA or THIRDPARTY)
    --- @param func fun( filePath: string )
    function CNC_RENEGADE.IterateFiles( directoryPath, gameLocation, func )
        if not string.EndsWith( directoryPath, "/" ) then directoryPath = directoryPath .. "/" end
        local files, directories = file.Find( directoryPath .. "*", gameLocation )

        -- Run the function on each file in the directory
        for _, file in ipairs( files ) do
            func( directoryPath .. file )
        end
    end
--#endregion


--[[ Load Shared Foundational Libraries ]] do
    -- For libraries that support the Renegade code but are not themselves from Renegade.
    -- (Class, file loading, debugging, etc.)

    -- Logging is first so we can report failures
    include( "renegade/sh_print.lua" )

    -- Type checking so we can detect failures
    include( "renegade/sh_typecheck.lua" )

    -- Imports to allow non-global libraries to load
    include( "renegade/sh_imports.lua" )

    include( "renegade/sh_robustclass.lua" )
    include( "renegade/sh_debugdraw.lua" )
    include( "renegade/sh_binary-conversion.lua" )
    include( "renegade/sh_convars.lua" )
end

-- Server-Side Garry's Mod Init
if SERVER then
    -- Let clients know that we're running the serverside component
    SetGlobal2Bool( "A1_Renegade_ServerRunning", true )

    --[[ Send Files to Clients ]] do

        -- Shared scripts
        CNC.IterateFiles( "renegade/", "LUA", AddCSLuaFile )
        CNC.IterateFiles( "renegade/bridges", "LUA", AddCSLuaFile )
        CNC.IterateFilesRecursively( "renegade/code", "LUA", AddCSLuaFile )

        -- Client-only scripts
        CNC.IterateFiles( "renegade/client/", "LUA", AddCSLuaFile )

        -- Fonts
        resource.AddFile( "resource/fonts/54251___.ttf" )
        resource.AddFile( "resource/fonts/ARI_____.ttf" )

        -- Materials
        CNC.IterateFilesRecursively( "materials/renegade/", "THIRDPARTY", resource.AddFile )
        CNC.IterateFilesRecursively( "materials/models/cnc_renegade/", "THIRDPARTY", resource.AddFile )

        -- Models
        CNC.IterateFilesRecursively( "models/cnc_renegade/", "THIRDPARTY", resource.AddFile )
    end

    -- Run non-Renegade Server scripts
    CNC.IterateFilesRecursively( "renegade/server/", "LUA", include )
end

-- Client-Side Garry's Mod Init
if CLIENT then
    -- Hide the default HUD
    -- TODO: Replace this with a per-element system in a menu somewhere that ties in with ConVars for enabling/disabling individual HUD elements
    include( "renegade/client/cl_hide-hud.lua" )
end

-- Execute Renegade's entrypoint script 
--- @type MainLoopClass
local mainLoopClass = CNC.Import( "code/commando/main-loop.lua" )
mainLoopClass.GameMainLoop()
