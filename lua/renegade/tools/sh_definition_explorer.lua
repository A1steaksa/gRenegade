--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DefinitionExplorer
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DefinitionExplorer"

if not CLIENT then return end

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ToolsLib
	local toolsLib = CNC.Import( "sh_tools.lua" )

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

	--- @type PlayerLib
	local playerLib = CNC.Import( "sh_players.lua" )
--#endregion

--#region Imported Enums
--#endregion


--- @class DefinitionExplorerState
--- @field X number
--- @field Y number


--- @class DefinitionExplorer

--- @param previousState DefinitionExplorerState
--- @return HotloadableDFrame
function STATIC.OpenTool( previousState )
local frame = vgui.Create( "HotloadableDFrame" )
    frame:SetTitle( "Definition Explorer" )
    frame:SetSize( 1200, 600 )
    frame:Center()
    frame:MakePopup()

    local menuBar = vgui.Create( "DMenuBar", frame )
    menuBar:DockMargin( -3, -6, -3, 0 )

    local list = frame:Add( "DListView" )
    list:Dock( FILL )
    list:AddColumn( "ID" )
    list:AddColumn( "Type" )
    list:AddColumn( "Name" )
    list:AddColumn( "Path" )

    --[[ Definition Type Filter ]] do

        -- Get each unique definition class
        local definitionClasses = {}
        for id, definition in pairs( definitionManagerClass.IdToDefinition ) do
            if definitionClasses[definition.Class] == nil then
                definitionClasses[definition.Class] = true
            end
        end

        local definitionTypeMenu = menuBar:AddMenu( "Definition Type" ) --[[@as DMenu]]

        -- The "None" option should re-populate the list with all definitions
        definitionTypeMenu:AddOption( "None", function()
            list:Clear()

            for _, definition in pairs( definitionManagerClass.IdToDefinition ) do
                list:AddLine( definition.Id, definition.Class, definition.Name )
            end
        end )

        -- Add each unique definiiton class to the list and make selecting them re-populate the list with only 
        -- definitions matching that class
        for definitionClass, _ in pairs( definitionClasses ) do
            --- @param panel DMenuOption
            definitionTypeMenu:AddOption( definitionClass, function( panel )
                list:Clear()

                for _, definition in pairs( definitionManagerClass.IdToDefinition ) do
                    if definition.Class == panel:GetText() then
                        local path = nil
                        if definition.Class == "HumanPhysicsDefinitionInstance" then
                            --- @cast definition HumanPhysicsDefinitionInstance
                            path = definition.ModelName
                        end

                        local line = list:AddLine( definition.Id, definition.Class, definition.Name, path ) --[[@as DListView_Line]]

                        line.OnSelect = function( self )
                            local soldier = playerLib.GetPlayerSoldier( LocalPlayer() )
                            if soldier == nil then return end

                            local definition = definitionManagerClass.FindDefinition( definition.Id )
                            if definition == nil then return end

                            if definition.Class ~= "SoldierGameObjectDefinitionInstance" then
                                return
                            end

                            --- @cast definition SoldierGameObjectDefinitionInstance
                            soldier:ReInit( definition )
                        end
                    end
                end
            end )
        end

        if previousState ~= nil then
            frame:SetPos( previousState.X, previousState.Y )
        end

        --- @return DefinitionExplorerState
        function frame:ExportState()
            return {
                X = self:GetX(),
                Y = self:GetY(),
            }
        end

    end

    return frame
end

toolsLib.RegisterTool( "ren_definition_explorer", STATIC.OpenTool )