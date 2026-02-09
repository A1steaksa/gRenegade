-- This is the kernel file for Command & Conquer Renegade content in Garry's Mod
-- It is responsible for starting the rest of the addon.

--- The global table containing all addon content for Command & Conquer: Renegade
--- @class Renegade
CNC_RENEGADE = CNC_RENEGADE or {}
local CNC = CNC_RENEGADE


--#region Helper Functions

    --- Iterates over all files within a directory and its sub-directories and calls a given function with each file's path passed as the arugment 
    --- @param name string
    --- @param path string
    --- @param func fun( filePath: string )
    local function IterateFilesRecursively( name, path, func )
        if not string.EndsWith( name, "/" ) then name = name .. "/" end
        local files, directories = file.Find( name .. "*", path )

        -- Run the function on each file in the directory
        for _, file in ipairs( files ) do
            func( name .. file )
        end

        -- Recurse on each sub-directory
        for _, directory in ipairs( directories ) do
            local nextDir = name .. directory .. "/"
            IterateFilesRecursively( nextDir, path, func )
        end
    end

    --- Finds all files within a directory and call a function for each file, passing in the file's path 
    --- @param name string
    --- @param path string
    --- @param func fun( filePath: string )
    local function IterateFiles( name, path, func )
        if not string.EndsWith( name, "/" ) then name = name .. "/" end
        local files, directories = file.Find( name .. "*", path )

        -- Run the function on each file in the directory
        for _, file in ipairs( files ) do
            func( name .. file )
        end
    end
--#endregion


--[[ Load Shared Foundational Libraries ]] do
    -- For libraries that support the Renegade code but are not themselves from Renegade.
    -- (Class, file loading, debugging, etc.)

    -- Logging is first so we can report failures
    include( "renhud/sh_print.lua" )

    -- Type checking so we can detect failures
    include( "renhud/sh_typecheck.lua" )

    -- Imports to allow non-global libraries to load
    include( "renhud/sh_imports.lua" )

    include( "renhud/sh_robustclass.lua" )
    include( "renhud/sh_debugdraw.lua" )
    include( "renhud/sh_binary-conversion.lua" )
    include( "renhud/sh_convars.lua" )
end

-- Server-Side Garry's Mod Init
if SERVER then
    -- Let clients know that we're running the serverside component
    SetGlobal2Bool( "A1_Renegade_ServerRunning", true )

    --[[ Send Files to Clients ]] do

        -- Shared scripts
        IterateFiles( "renhud/", "LUA", AddCSLuaFile )
        IterateFiles( "renhud/bridges", "LUA", AddCSLuaFile )
        IterateFilesRecursively( "renhud/code", "LUA", AddCSLuaFile )

        -- Client-only scripts
        IterateFiles( "renhud/client/", "LUA", AddCSLuaFile )

        -- Fonts
        resource.AddFile( "resource/fonts/54251___.ttf" )
        resource.AddFile( "resource/fonts/ARI_____.ttf" )

        -- Materials
        IterateFilesRecursively( "materials/renhud/", "THIRDPARTY", resource.AddFile )
        IterateFilesRecursively( "materials/models/cnc_renegade/", "THIRDPARTY", resource.AddFile )

        -- Models
        IterateFilesRecursively( "models/cnc_renegade/", "THIRDPARTY", resource.AddFile )
    end

    -- Run non-Renegade Server scripts
    IterateFilesRecursively( "renhud/server/", "LUA", include )
end

-- Client-Side Garry's Mod Init
if CLIENT then
    -- Hide the default HUD
    -- TODO: Replace this with a per-element system in a menu somewhere that ties in with ConVars for enabling/disabling individual HUD elements
    include( "renhud/client/cl_hide-hud.lua" )
end

-- Execute Renegade's entrypoint script 
--- @type MainLoopClass
local mainLoopClass = CNC.Import( "code/commando/main-loop.lua" )
mainLoopClass.GameMainLoop()
