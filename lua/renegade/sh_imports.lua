-- Handles exporting classes from their scripts and and importing them as dependencies elsewhere

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ImportsLib
local LIB = {}
LIB.Class = "ImportsLib"

--- @type table<string, table>
--- @private
LIB.ExportedTables = {}

--- For keeping track of which static constructors have already been run to avoid running them twice
--- @type table<string, boolean>
--- @private
LIB.RunStaticConstructors = {}

--- A prefix that will be added to the front of all paths passed to the Import function  
--- For example: Setting this to `"my-addon"` would turn an Import path from `"some-dir/cool-script.lua"` to `"my-addon/some-dir/cool-script.lua"`
LIB.ImportPathPrefix = "renegade"

--- Applies the ImportPathPrefix to a given path
--- @param path string
--- @return string prefixedPath
function LIB.PrefixPath( path )
    -- If the path already has the prefix, don't add it again
    if string.StartsWith( path, LIB.ImportPathPrefix ) then
        return path
    end

    -- Ensure the path has a leading slash
    if not string.StartsWith( path, "/" ) then
        path = "/" .. path
    end

    -- Add the prefix
    path = LIB.ImportPathPrefix .. path

    return path
end

--- Retrieves or creates a table for a new class or library to populate for importing into other scripts as a dependency
--- Other scripts can import this script's exported table by importing this script's file path starting with `/lua/` and ending in `.lua`
--- @vararg table? The parent meta tables for the newly created table to inherit from
--- @return table # The table for this class or library to use.
function LIB.CreateExport( ... )
    local path
    --[[ Get the calling script's file path ]] do
        local info = debug.getinfo( 2 )
        local fullFilePath = info.source

        local startPos, endPos, _ = string.find( fullFilePath, "/lua", nil, true )

        if not endPos then
            error( "Could not parse export script path. It does not appear to be a Lua file: " .. fullFilePath )
        end

        path = string.sub( fullFilePath, endPos + 2 ):Trim()
    end

    local tbl = LIB.ExportedTables[path]

    -- If this has already been exported, re-use the existing table
    if tbl then
        return tbl
    end

    -- If we haven't exported this file before, create a new table for it
    tbl = {}

    -- Set up inheritance if a parent was given
    local parents = { ... }
    if #parents ~= 0 then
        tbl.ParentClasses = parents
        setmetatable( tbl, tbl )

        if #parents == 1 then
            -- Single parent inheritance can be simple
            tbl.__index = parents[1]
        else
            -- Multi-parent inheritance requires some extra complexity

            --- @param key any
            --- @return any
            function tbl:__index( key )
                for _, parent in ipairs( tbl.ParentClasses ) do
                    if parent[key] then
                        return parent[key]
                    end
                end
            end
        end
    end

    LIB.ExportedTables[path] = tbl
    return tbl
end

--- Returns an exported table exported from a script, only executing the script if it has not been imported elsewhere already.
--- @param path string The file path, ending in .lua, of the script to import
--- @return table
function LIB.Import( path )
    typecheck.AssertArgType( LIB.Class, 1, path, "string" )

    path = path:Trim()
    path = LIB.PrefixPath( path )

    -- Execute the script if it hasn't already been imported elsewhere
    local tbl = LIB.ExportedTables[path]
    if tbl == nil then
        if not file.Exists( path, "LUA" ) then
            error( "Cannot import missing file: " .. path )
        end

        include( path )

        -- Confirm that the script exported something for us to import
        tbl = LIB.ExportedTables[path]
        if tbl == nil then
            typecheck.Error( LIB.Class, "Import", "No table was exported by script: " .. path )
            error()
        end

        -- Call the post-load static constructor
        if LIB.RunStaticConstructors[path] == nil and isfunction( tbl.StaticConstructor ) then
            LIB.RunStaticConstructors[path] = true
            tbl.StaticConstructor()
        end
    end

    return tbl
end

CNC.Import = LIB.Import
CNC.CreateExport = LIB.CreateExport
