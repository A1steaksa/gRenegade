-- Based on SaveLoadSystemClass within Code/wwsaveload/saveload.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SaveLoadSystemClass
local STATIC = CNC.CreateExport()
local CLASS = "SaveLoadSystemClass"
local isHotload = not table.IsEmpty( STATIC )

--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class SaveLoadSystemClass
    --- @field PointerRemapper PointerRemapInstance
    --- @field PostLoadList PostLoadableInstance[]

    --- @type table<SaveLoadSubSystemInstance, boolean>
    STATIC.LoadedSubSystems = {}

    --- @type table<integer, SaveLoadSubSystemInstance>
    STATIC.IdToSubSystem = {}

    --- @type table<PersistFactoryInstance, boolean>
    STATIC.LoadedFactories = {}

    --- @type table<integer, PersistFactoryInstance>
    STATIC.IdToFactory = {}

    --[[ Save-Load Interface ]] do
        -- "  
        -- To create a file, ask each sub-system to save itself.  
        -- To load a file just open it and pass it to the load method.  
        -- "  

        --- @param csave ChunkSaveInstance
        --- @param subsystem SaveLoadSubSystemInstance
        --- @return boolean
        function STATIC.Save( csave, subsystem )
            local ok = true

            if subsystem:ContainsData() then
                csave:BeginChunk( subsystem:ChunkId() )
                -- Why is this not just setting the value?  
                -- Great question. Ask Westwood.
                ok = ok and subsystem:Save( csave )
                csave:EndChunk()
            end

            return ok
        end

        --- @param cload ChunkLoadInstance
        --- @param autoPostLoad boolean
        --- @return boolean
        function STATIC.Load( cload, autoPostLoad )
            --STATIC.PointerRemapper:Reset()

            local ok = true

            -- "Load each chunk we encounter and link the manager into the PostLaod list"
            while cload:OpenChunk() do
                local sys = STATIC.FindSubSystem( cload:CurChunkId() )

                if sys then
                    ok = ok and sys:Load( cload )
                end
                cload:CloseChunk()
            end

            -- "Process all of the pointer remap requests"
            --STATIC.PointerRemapper:Process()
            --STATIC.PointerRemapper:Reset()

            -- "Call PostLoad on each PersistClass that wanted post-load"
            if autoPostLoad then
                STATIC.PostLoadProcessing()
            end

            return ok
        end

        --- @return boolean true
        function STATIC.PostLoadProcessing()
            -- "Call PostLoad on each [PersistInstance] that wanted post-load"
            for _, obj in ipairs( STATIC.PostLoadList ) do
                -- Omitted network update
                obj:OnPostLoad()
                obj:SetPostLoadRegistered( false )
            end

            return true
        end
    end

    --- "Look up the persist factory for a given chunk id"
    --- @param chunkId integer
    --- @return PersistFactoryInstance
    function STATIC.FindPersistFactory( chunkId )
        return STATIC.IdToFactory[chunkId]
    end

    --[[ Post-Load Interface ]] do

        --- "An object being loaded can ask for a callback after all objects have been loaded..."
        --- @param obj PostLoadableInstance
        function STATIC.RegisterPostLoadCallback( obj )
            typecheck.NotImplementedError()
        end
    end

    --[[ Pointer Remapping Interface ]] do

        function STATIC.RegisterPointer()
            typecheck.NotImplementedError()
        end

        function STATIC.RequestPointerRemap()
            typecheck.NotImplementedError()
        end

        function STATIC.RequestRefCountedPointerRemap()
            typecheck.NotImplementedError()
        end
    end

    --[[ Internal SaveLoadSystem Functions ]] do

        --- Attempts to unregister everything from the save-load system
        function STATIC.ResetAllRegisters()

            STATIC.PostLoadList = {}

            STATIC.IdToFactory      = {}
            STATIC.LoadedFactories  = {}

            STATIC.IdToSubSystem    = {}
            STATIC.LoadedSubSystems = {}
        end

        ---@param subsys SaveLoadSubSystemInstance
        function STATIC.RegisterSubSystem( subsys )
            print( "Registering sub-system: \"" .. subsys:Name() .. "\" with Chunk ID: " .. subsys:ChunkId() )
            STATIC.LinkSubSystem( subsys )
        end

        ---@param subsys SaveLoadSubSystemInstance
        function STATIC.UnregisterSubSystem( subsys )
            STATIC.UnlinkSubSystem( subsys )
        end

        ---@param chunkId integer
        ---@return SaveLoadSubSystemInstance?
        function STATIC.FindSubSystem( chunkId )
            return STATIC.IdToSubSystem[chunkId]
        end


        ---@param factory PersistFactoryInstance
        function STATIC.RegisterPersistFactory( factory )
            print( "Registering persist factory with Chunk ID: " .. factory:ChunkId() )
            STATIC.LinkFactory( factory )
        end

        ---@param factory PersistFactoryInstance
        function STATIC.UnregisterPersistFactory( factory )
            typecheck.NotImplementedError()
        end


        ---@param subsys SaveLoadSubSystemInstance
        function STATIC.LinkSubSystem( subsys )
            if STATIC.LoadedSubSystems[subsys] then
                error( "Sub-systems should never register twice!" )
                return
            end

            if STATIC.IdToSubSystem[subsys:ChunkId()] then
                error( "Sub-system chunk ID re-use detected!" )
            end

            STATIC.LoadedSubSystems[subsys] = true
            STATIC.IdToSubSystem[subsys:ChunkId()] = subsys
        end

        ---@param subsys SaveLoadSubSystemInstance
        function STATIC.UnlinkSubSystem( subsys )
            typecheck.NotImplementedError()
        end

        ---@param factory PersistFactoryInstance
        function STATIC.LinkFactory( factory )

            if STATIC.LoadedFactories[factory] then
                error( "Factories should never register twice!" )
            end

            local chunkId = factory:ChunkId()

            if not chunkId then
                error( "Persist Factory does not have a valid chunk ID: " .. ( chunkId ~= nil and chunkId or "nil" ) )
            end

            if STATIC.IdToFactory[chunkId] then
                error( "Persist Factory chunk ID re-use detected!" )
            end

            STATIC.LoadedFactories[factory] = true
            STATIC.IdToFactory[chunkId] = factory
        end

        ---@param factory PersistFactoryInstance
        function STATIC.UnlinkFactory( factory )
            typecheck.NotImplementedError()
        end


        ---@param obj PostLoadableInstance
        ---@return boolean
        function STATIC.IsPostLoadCallbackRegistered( obj )
            typecheck.NotImplementedError()
        end
    end
end