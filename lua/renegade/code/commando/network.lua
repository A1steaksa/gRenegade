-- Based on cNetwork within Code/Commando/cnetwork.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class NetworkClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "NetworkClass"

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--- @class NetworkClass
--- @field PServerConnection any
--- @field PClientConnection any
--- @field SensibleUpdates any
--- @field Receiver any
--- @field NetworkReceiver any
--- @field ClientString any
--- @field ClientEnumerationString any
--- @field LastServerConnectionStateBad any
--- @field ExeKey any
--- @field ExeCrc any
--- @field StringsCrc any
--- @field MessageToSend any
--- @field Command any
--- @field GraphingY any
--- @field BandwidthBarLength any
--- @field BandwidthScaler any
--- @field NetHandler any
--- @field Fps any
--- @field ThinkCount any
--- @field PClientStatList any
--- @field PServerStatListGroup any
--- @field HaveDoneTeamChangeDialog any
--- @field HaveDoneMotdDialog any
--- @field VisTable any

function STATIC.ComputeExeKey()
  typecheck.NotImplementedError()
end

function STATIC.OnetimeInit()
  typecheck.NotImplementedError()
end

function STATIC.OnetimeShutdown()
  typecheck.NotImplementedError()
end

function STATIC.Update()
  typecheck.NotImplementedError()
end

function STATIC.Save()
  typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
function STATIC.Load( cload )
  typecheck.NotImplementedError()
end

function STATIC.GetDistancePriority()
  typecheck.NotImplementedError()
end

function STATIC.UpdateFps()
  typecheck.NotImplementedError()
end

function STATIC.GetFps()
  typecheck.NotImplementedError()
end

function STATIC.GetThinkCount()
  typecheck.NotImplementedError()
end

function STATIC.ShellCommand()
  typecheck.NotImplementedError()
end

function STATIC.ServerPacketHandler()
  typecheck.NotImplementedError()
end

function STATIC.ClientPacketHandler()
  typecheck.NotImplementedError()
end

function STATIC.ServerBrokenConnectionHandler()
  typecheck.NotImplementedError()
end

function STATIC.ClientBrokenConnectionHandler()
  typecheck.NotImplementedError()
end

function STATIC.AcceptHandler()
  typecheck.NotImplementedError()
end

function STATIC.RefusalHandler()
  typecheck.NotImplementedError()
end

function STATIC.ConnectionHandler()
  typecheck.NotImplementedError()
end

function STATIC.ApplicationAcceptanceHandler()
  typecheck.NotImplementedError()
end

function STATIC.EvictionHandler()
  typecheck.NotImplementedError()
end

function STATIC.IAmClient()
  return CLIENT
end

function STATIC.IAmServer()
  return SERVER
end

function STATIC.IAmOnlyClient()
  typecheck.NotImplementedError()
end

function STATIC.IAmOnlyServer()
  return SERVER and not CLIENT
end

function STATIC.IAmClientServer()
  return SERVER and CLIENT
end

function STATIC.IAmGod()
  typecheck.NotImplementedError()
end

function STATIC.SendObjectUpdate()
  typecheck.NotImplementedError()
end

function STATIC.TellClientAboutDynamicObjects()
  typecheck.NotImplementedError()
end

function STATIC.TellClientAboutDeleteNotifications()
  typecheck.NotImplementedError()
end

function STATIC.TellServerAboutDynamicObjects()
  typecheck.NotImplementedError()
end

function STATIC.ServerKillConnection()
  typecheck.NotImplementedError()
end

function STATIC.SetReceiver()
  typecheck.NotImplementedError()
end

function STATIC.ProcessEvictionSc()
  typecheck.NotImplementedError()
end

function STATIC.CleanupAfterClient()
  typecheck.NotImplementedError()
end

function STATIC.DeletePlayerObjects()
  typecheck.NotImplementedError()
end

function STATIC.RemovePlayer()
  typecheck.NotImplementedError()
end

function STATIC.TestForTeamDefaulting()
  typecheck.NotImplementedError()
end

function STATIC.PacketGraph()
  typecheck.NotImplementedError()
end

function STATIC.WatchPackets()
  typecheck.NotImplementedError()
end

function STATIC.BandwidthGraph()
  typecheck.NotImplementedError()
end

function STATIC.WatchBandwidth()
  typecheck.NotImplementedError()
end

function STATIC.LatencyGraph()
  typecheck.NotImplementedError()
end

function STATIC.LastContactGraph()
  typecheck.NotImplementedError()
end

function STATIC.ListSizeGraph()
  typecheck.NotImplementedError()
end

function STATIC.ListTimeGraph()
  typecheck.NotImplementedError()
end

function STATIC.ListPacketSizeGraph()
  typecheck.NotImplementedError()
end

function STATIC.WatchLatency()
  typecheck.NotImplementedError()
end

function STATIC.WatchLastContact()
  typecheck.NotImplementedError()
end

function STATIC.WatchSizeLists()
  typecheck.NotImplementedError()
end

function STATIC.WatchTimeLists()
  typecheck.NotImplementedError()
end

function STATIC.WatchPacketSizeLists()
  typecheck.NotImplementedError()
end

function STATIC.SimulationWarnings()
  typecheck.NotImplementedError()
end

function STATIC.ConnectionStatusChangeFeedback()
  typecheck.NotImplementedError()
end

function STATIC.ClientSendPacket()
  typecheck.NotImplementedError()
end

function STATIC.ServerSendPacket()
  typecheck.NotImplementedError()
end

function STATIC.ServerSendPacketToAllConnected()
  typecheck.NotImplementedError()
end

function STATIC.ShowWelcomeMessage()
  typecheck.NotImplementedError()
end

function STATIC.GetMyPlayerObject()
  typecheck.NotImplementedError()
end

function STATIC.GetMyTeamNumber()
  typecheck.NotImplementedError()
end

function STATIC.GetMyColor()
  typecheck.NotImplementedError()
end

function STATIC.GetClientString()
  typecheck.NotImplementedError()
end

function STATIC.GetClientEnumerationString()
  typecheck.NotImplementedError()
end

function STATIC.GetServerRhost()
  typecheck.NotImplementedError()
end

function STATIC.GetClientRhost()
  typecheck.NotImplementedError()
end

function STATIC.GetServerRhostThresholdPriority()
  typecheck.NotImplementedError()
end

function STATIC.GetClientRhostThresholdPriority()
  typecheck.NotImplementedError()
end

function STATIC.GetMyId()
  typecheck.NotImplementedError()
end

function STATIC.GetExeKey()
  typecheck.NotImplementedError()
end

function STATIC.GetExeCrc()
  typecheck.NotImplementedError()
end

function STATIC.GetStringsCrc()
  typecheck.NotImplementedError()
end

function STATIC.SetDesiredFrameSleepMs()
  typecheck.NotImplementedError()
end

function STATIC.SetSimulatedPacketLossPc()
  typecheck.NotImplementedError()
end

function STATIC.SetSimulatedPacketDuplicationPc()
  typecheck.NotImplementedError()
end

function STATIC.SetSimulatedLatencyRangeMs()
  typecheck.NotImplementedError()
end

function STATIC.SetSpamCount()
  typecheck.NotImplementedError()
end

function STATIC.GetSimulatedLatencyRangeMs()
  typecheck.NotImplementedError()
end

function STATIC.SetGraphingY()
  typecheck.NotImplementedError()
end

function STATIC.InitClient()
  typecheck.NotImplementedError()
end

function STATIC.InitServer()
  typecheck.NotImplementedError()
end

function STATIC.CleanupServer()
  typecheck.NotImplementedError()
end

function STATIC.CleanupClient()
  typecheck.NotImplementedError()
end

function STATIC.Flush()
  typecheck.NotImplementedError()
end

function STATIC.SwitchTeam()
  typecheck.NotImplementedError()
end

function STATIC.EnableWaitingPlayers()
  typecheck.NotImplementedError()
end

function STATIC.GetDataFilesCrc()
  typecheck.NotImplementedError()
end

function STATIC.SharedClientAndServerThink()
  typecheck.NotImplementedError()
end

function STATIC.ClientThink()
  typecheck.NotImplementedError()
end

function STATIC.ServerThink()
  typecheck.NotImplementedError()
end

function STATIC.HibernationThink()
  typecheck.NotImplementedError()
end

function STATIC.EndGameTest()
  typecheck.NotImplementedError()
end

function STATIC.IntermissionOverProcessing()
  typecheck.NotImplementedError()
end

function STATIC.PeekTempVisTable()
  typecheck.NotImplementedError()
end
