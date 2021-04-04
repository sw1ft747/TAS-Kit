// Squirrel
// (c) noa1mbot

/*
	This include-file converts SourceMod commands to the VScript environment. All listed plugins must be installed in order to work properly.
	Speedrunner Tools: https://forums.alliedmods.net/showthread.php?t=304789
	Movement Reader: https://forums.alliedmods.net/showthread.php?t=309141
	Note that, some functions are related with a native function SendToConsole(), execution of them is delayed by one frame.
*/

//========================================================================================================================
// SourceMod Commands
//========================================================================================================================

function ClientCommand(hPlayer, sCmd)
{
	if (hPlayer && hPlayer.IsValid())
		SendToConsole(format("sm_ccmd %d \"%s\"", hPlayer.GetEntityIndex(), sCmd));
}

//============================================================
//============================================================

function SetClientName(hPlayer, sName)
{
	if (hPlayer && hPlayer.IsValid())
		SendToConsole(format("sm_name %d \"%s\"", hPlayer.GetEntityIndex(), sName));
}

//============================================================
//============================================================

function SetTeam(survName)
{
	local bValue = false;
	local hPlayer = null;
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		if (hPlayer != Ent("!player") && hPlayer.IsSurvivor() && !IsPlayerABot(hPlayer)) return;
		if (IsPlayerABot(hPlayer)) bValue = true;
	}
	if (bValue)
	{
		SendToConsole("sb_add; sb_add; sb_add");
		ClientCommand(Ent("!player"), "sb_takecontrol " + survName);
		SendToConsole("kick Nick; kick Rochelle; kick Coach; kick Ellis");
		SendToConsole("kick Bill; kick Zoey; kick Louis; kick Francis");
		SendToConsole("sm_fake; sm_fake; sm_fake");
		return;
	}
	printl("[SetTeam] Add in the game at least 1 bot to execute.");
}

//============================================================
//============================================================

function CallVote(hCaller, sCmd)
{
	if (g_bRestarting || !hCaller || !hCaller.IsValid()) return;
	if (IsPlayerABot(hCaller)) Say(null, "[CallVote] Vote being called by a bot!", false);
	ClientCommand(hCaller, "callvote ChangeDifficulty " + sCmd);
	local hPlayer = null;
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		if (hCaller != hPlayer && !IsPlayerABot(hPlayer))
		{
			ClientCommand(hPlayer, "Vote Yes");
		}
	}
}

//============================================================
//============================================================

function PlayerReplace(hPlayer, hPlayer2)
{
	if (hPlayer && hPlayer2 && hPlayer.IsValid() && hPlayer2.IsValid())
		SendToConsole(format("sm_replace %d %d", hPlayer.GetEntityIndex(), hPlayer2.GetEntityIndex()));
}

//============================================================
//============================================================

function AutoKick(hCaller, hPlayer)
{
	if (g_bRestarting) return;
	if (!("AKTable" in getroottable()))
	{
		AKTable <-
		{
			playersList = []
			OnGameEvent_round_end = function(event)
			{
				if (playersList.len() > 0)
				{
					SendToConsole("sb_add; sb_add; sb_add");

					for (local i = 0; i < playersList.len(); i++)
					{
						local hPlayer = playersList[i];
						if (IsPlayer(hPlayer) && !hPlayer.IsSurvivor())
						{
							ClientCommand(hPlayer, "sb_takecontrol " + ["Nick", "Rochelle", "Coach", "Ellis"][NetProps.GetPropInt(hPlayer, "m_survivorCharacter")]);
							playersList.remove(i);
							i--;
						}
					}

					SendToConsole("nb_delete_all survivor");
				}
			}
		}
		__CollectEventCallbacks(AKTable, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
	}
	if (IsPlayer(hCaller) && IsPlayer(hPlayer))
	{
		ST_Idle(hPlayer);
		if (IsPlayerABot(hPlayer = GetPlayerFromCharacter(NetProps.GetPropInt(hPlayer, "m_survivorCharacter"))))
		{
			if (IsPlayerABot(hCaller)) Say(null, "[AutoKick] Vote being called by a bot!", false);
			AKTable.playersList.append(GetOwner(hPlayer));
			ClientCommand(hCaller, "callvote Kick " + hPlayer.GetPlayerUserId());
			hPlayer = null;
			while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
			{
				if (hCaller != hPlayer && !IsPlayerABot(hPlayer))
				{
					ClientCommand(hPlayer, "Vote Yes");
				}
			}
		}
	}
}

//============================================================
//============================================================

function ST_Idle(hPlayer, bMode = false)
{
	if (!IsPlayer(hPlayer) || !hPlayer || !hPlayer.IsValid()) return;
	Convars.SetValue(bMode ? "st_idletake" : "st_idle", hPlayer.GetEntityIndex());
}

//============================================================
//============================================================

function ST_PlayerReplace(hPlayer, hPlayer2)
{
	if (!IsPlayer(hPlayer) || !IsPlayer(hPlayer2)) return;
	Convars.SetValue("st_idlereplace", format("%d %d", hPlayer.GetEntityIndex(), hPlayer2.GetEntityIndex()));
}

//============================================================
//============================================================

function ST_MR(hPlayer = null, eMode = 0, sFileName = null, bNoTeleport = false)
{
	if (hPlayer == null) hPlayer = PlayerInstanceFromIndex(1);
	if (!IsPlayer(hPlayer)) return;
	if (eMode == 3) return Convars.SetValue("st_mr_split", hPlayer.GetEntityIndex());
	if (sFileName == null) sFileName = "default";
	Convars.SetValue("st_mr_force_file", eMode == 2 ? "default" : sFileName);
	Convars.SetValue("st_mr_no_teleport", bNoTeleport.tointeger());
	Convars.SetValue(eMode ? "st_mr_play" : "st_mr_record", hPlayer.GetEntityIndex());
}

//============================================================
//============================================================

function ST_MRStop(hPlayer = null)
{
	if (IsPlayer(hPlayer)) return Convars.SetValue("st_mr_stop_player", hPlayer.GetEntityIndex());
	hPlayer = null;
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		Convars.SetValue("st_mr_stop_player", hPlayer.GetEntityIndex());
	}
}

//========================================================================================================================
//Utils
//========================================================================================================================

if (!("g_Utils" in this))
{
	g_Utils <-
	{
		botOwner = array(MAXCLIENTS + 1, null)
		OnGameEvent_player_bot_replace = function(event)
		{
			botOwner[GetPlayerFromUserID(event.bot).GetEntityIndex()] = GetPlayerFromUserID(event.player);
		}
	}
}
__CollectEventCallbacks(g_Utils, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);

//============================================================
//============================================================

function GetOwner(client)
{
	if (type(client) == "instance") return g_Utils.botOwner[client.GetEntityIndex()];
	if (type(client) == "integer") return g_Utils.botOwner[client];
	if (type(client) == "string") return g_Utils.botOwner[Entities.FindByName(null, client).GetEntityIndex()];
	return null;
}

//============================================================
//============================================================

function IsFakeClient(hPlayer)
{
	if (hPlayer.GetNetworkIDString() == "BOT" && !IsPlayerABot(hPlayer)) return true;
	return false;
}

//============================================================
//============================================================

function IsHuman(hPlayer)
{
	if (hPlayer.GetNetworkIDString() != "BOT") return true;
	return false;
}

//============================================================
//============================================================

function IsPlayer(hPlayer)
{
	if (type(hPlayer) == "instance" && hPlayer.IsValid() && hPlayer.IsPlayer()) return true;
	return false;
}
