// Squirrel
// Chat Commands
// Powered by AP

function RestartRound()
{
	cvar("mp_restartgame", 1);
	cvar("host_timescale", 1);
}

function RestartSpeedrun_Cmd()
{
	RestartSpeedrun();
}

function EnableChangeLevel()
{
	EntFire("info_changelevel", "Enable");
}

function ChangeLevel()
{
	local hChangeLevel;
	if (hChangeLevel = Entities.FindByClassname(null, "info_changelevel"))
	{
		SendToServerConsole("map " + NetProps.GetPropString(hChangeLevel, "m_mapName"));
	}
}

function GetTransitionPosition(hPlayer)
{
	if (SessionState["MapName"] in g_tTransitionLandmarks)
	{
		local vecPos = hPlayer.GetOrigin();
		local hChangeLevel = Entities.FindByClassname(null, "info_changelevel");
		local aPoints = g_tTransitionLandmarks[SessionState["MapName"]];
		local vecCurrentLevel = Vector(aPoints[0], aPoints[1], aPoints[2]);
		local vecNextLevel = Vector(aPoints[3], aPoints[4], aPoints[5]);
		vecPos -= vecCurrentLevel;
		vecPos += vecNextLevel;
		if (SessionState["MapName"] == "c13m3_memorialbridge")
		{
			local flHeight = vecPos.z;
			vecPos = vecCurrentLevel - hPlayer.GetOrigin() + vecNextLevel;
			vecPos.z = flHeight;
		}
		sayf("%s: Vector(%.03f, %.03f, %.03f)", (hChangeLevel ? NetProps.GetPropString(hChangeLevel, "m_mapName") : "Origin"), vecPos.x, vecPos.y, vecPos.z);
	}
}

function ToggleHUD(hPlayer)
{
	if (g_tDataTable["hud"])
	{
		SayMsg("HUD has been disabled");
		EmitSoundOnClient("Buttons.snd11", hPlayer);
		g_Timer.HUD.Fields.timer_sec["flags"] = g_Timer.HUD.Fields.timer_sec["flags"] | HUD_FLAG_NOTVISIBLE;
		g_Timer.HUD.Fields.timer_ms["flags"] = g_Timer.HUD.Fields.timer_ms["flags"] | HUD_FLAG_NOTVISIBLE;
		g_Timer.HUD.Fields.timer_comma["flags"] = g_Timer.HUD.Fields.timer_comma["flags"] | HUD_FLAG_NOTVISIBLE;
		HUDSetLayout(g_Timer["HUD"]);
	}
	else
	{
		SayMsg("HUD has been enabled");
		EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
		g_Timer.HUD.Fields.timer_sec["flags"] = g_Timer.HUD.Fields.timer_sec["flags"] & ~HUD_FLAG_NOTVISIBLE;
		g_Timer.HUD.Fields.timer_ms["flags"] = g_Timer.HUD.Fields.timer_ms["flags"] & ~HUD_FLAG_NOTVISIBLE;
		g_Timer.HUD.Fields.timer_comma["flags"] = g_Timer.HUD.Fields.timer_comma["flags"] & ~HUD_FLAG_NOTVISIBLE;
		HUDSetLayout(g_Timer["HUD"]);
	}
	g_tDataTable["hud"] = !g_tDataTable["hud"];
	UpdateDataTable(g_tDataTable);
}

function ToggleFallDamage(hPlayer)
{
	if (g_tDataTable["fdmg"])
	{
		SayMsg("Fall Damage has been disabled");
		EmitSoundOnClient("Buttons.snd11", hPlayer);
	}
	else
	{
		SayMsg("Fall Damage has been enabled");
		EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
	}
	g_tDataTable["fdmg"] = !g_tDataTable["fdmg"];
	UpdateDataTable(g_tDataTable);
}

function ChangeTimerValue(hPlayer, sValue)
{
	if (sValue != CMD_EMPTY_ARGUMENT)
	{
		local sValue = split(sValue, " ")[0];
		try
		{
			sValue = sValue.tofloat();
			if (sValue >= 0)
			{
				g_tDataTable["timer"] = sValue;
				UpdateDataTable(g_tDataTable);
				EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
			}
		}
		catch (error)
		{
			EmitSoundOnClient("Buttons.snd11", hPlayer);
			return;
		}
	}
	else
	{
		sayf("Current countdown: %.01fs", g_tDataTable["timer"]);
	}
}

function Debug_Cmd(hPlayer, sValue)
{
	if (sValue == CMD_EMPTY_ARGUMENT)
	{
		if (!developer()) EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
		else EmitSoundOnClient("Buttons.snd11", hPlayer);
		cvar("developer", (!developer()).tointeger());
	}
	else
	{
		local args = split(sValue, " ");
		sValue = args[0];
		if (sValue == "nav")
		{
			if (hPlayer.IsHost())
			{
				if (!cvar("nav_edit", null, false)) EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
				else EmitSoundOnClient("Buttons.snd11", hPlayer);
				cvar("nav_edit", !cvar("nav_edit", null, false) ? 1 : 0);
			}
		}
		else if (sValue == "items")
		{
			if (DebugItems()) EmitSoundOnClient("Buttons.snd37", hPlayer);
			else EmitSoundOnClient("Buttons.snd11", hPlayer);
		}
		else if (sValue == "tp")
		{
			local vecPos = hPlayer.GetOrigin();
			local vecVel = hPlayer.GetVelocity();
			local eAngles = hPlayer.EyeAngles();
			sayf("TP(hPlayer, Vector(%.03f, %.03f, %.03f), QAngle(%.03f, %.03f, 0.000)%s);",
				vecPos.x, vecPos.y, vecPos.z, eAngles.x, eAngles.y, (vecVel.IsZero(0.0) ? "" : ", Vector(" + vecVel.x + ", " + vecVel.y + ", " + vecVel.z + ")"));
			EmitSoundOnClient("Buttons.snd37", hPlayer);
		}
		else if (sValue == "trigger")
		{
			cvar("developer", -1);
			SendToConsole("ent_bbox trigger_once");
			SendToConsole("ent_bbox trigger_multiple");
			SendToConsole("ent_bbox trigger_hurt");
		}
		else if (sValue == "start")
		{
			StartSpeedrun();
		}
		else if (sValue == "stop")
		{
			g_bSpeedrunStarted = false;
		}
		else if (sValue == "set")
		{
			if (args.len() == 2)
			{
				try {
					SetCurrentTime(args[1].tofloat());
				}
				catch (error) {
					return;
				}
			}
		}
		else if (sValue == "clear")
		{
			local hEntity;
			while (hEntity = Entities.FindByModel(hEntity, "models/extras/info_speech.mdl"))
				hEntity.Kill();
			EmitSoundOnClient("Buttons.snd37", hPlayer);
		}
		else if (sValue == "dir")
		{
			printl("===============  DirectorOptions  ===============");
			foreach (key, val in g_ModeScript.LocalScript.DirectorOptions)
			{
				printl(key + " = " + val);
				SayMsg(key + " = " + val);
			}
			printl("=================================================");
			foreach (key, val in g_ModeScript.DirectorOptions)
			{
				printl(key + " = " + val);
			}
		}
		else if (sValue == "tr")
		{
			if (hPlayer.IsHost())
			{
				if (g_bTriggerEditor)
				{
					DebugDrawClear();
					RemoveOnTickFunction("DisplayTrigger");
					EmitSoundOnClient("Buttons.snd11", hPlayer);
				}
				else
				{
					RegisterOnTickFunction("DisplayTrigger");
					ServerCommand("bind g \"script SetTriggerPoint()\"");
					ServerCommand("bind h \"script DumpTrigger()\"");
					sayf("[TriggerEditor] Added a bind to for creating points (G)");
					sayf("[TriggerEditor] Added a bind to for dumping a trigger (H)");
					EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
				}
				g_bTriggerEditor = !g_bTriggerEditor;
			}
		}
		else if (sValue == "dump")
		{
			if (hPlayer.IsHost())
				DumpTriggersToFile();
		}
	}
}

function XClip_Cmd(hPlayer, sValue)
{
	if (sValue != CMD_EMPTY_ARGUMENT)
	{
		local sValue = split(sValue, " ")[0];
		if (sValue == "fast")
		{
			hPlayer.SetOrigin(hPlayer.GetOrigin() + VMath.Forward2D(hPlayer.EyeAngles()) * -10);
			ClientCommand(hPlayer, "sm_idle");
			ClientCommand(hPlayer, "sm_take");
		}
		else if (sValue == "exact")
		{
			local vecForward = hPlayer.EyeAngles().Forward(); vecForward.z = 0.0;
			hPlayer.SetOrigin(hPlayer.GetOrigin() + vecForward * -10);
			ClientCommand(hPlayer, "sm_idle");
			ClientCommand(hPlayer, "sm_take");
		}
		else if (sValue == "double")
		{
			hPlayer.SetOrigin(hPlayer.GetOrigin() + VMath.Forward2D(hPlayer.EyeAngles()) * -20);
			ClientCommand(hPlayer, "sm_idle");
			ClientCommand(hPlayer, "sm_take");
		}
	}
}

function Picker_Cmd(hPlayer)
{
	local bFound = true;
	local hEntity = hPlayer.DoTraceLine();
	if (hEntity)
	{
		local eAngles;
		local vecPos = hEntity.GetOrigin();
		local sClass = hEntity.GetClassname();
		if (sClass == "player")
		{
			if (!NetProps.GetPropInt(hEntity, "m_iObserverMode") && hEntity.IsAlive())
			{
				if (hEntity.IsSurvivor())
				{
					eAngles = hEntity.EyeAngles();
					local vecVel = hEntity.GetVelocity();
					sayf("TP(hPlayer, Vector(%.03f, %.03f, %.03f), QAngle(%.03f, %.03f, 0.000)%s);",
						vecPos.x, vecPos.y, vecPos.z, eAngles.x, eAngles.y, (vecVel.IsZero(0.0) ? "" : ", Vector(" + vecVel.x + ", " + vecVel.y + ", " + vecVel.z + ")"));
				}
				else
				{
					local aType = ["smoker", "boomer", "hunter", "spitter", "jockey", "charger", "witch", "tank"];
					sayf("Function:\nSpawnZombie(\"%s\", Vector(%.03f, %.03f, %.03f));", aType[hEntity.GetZombieType() - 1], vecPos.x, vecPos.y, vecPos.z);
				}
			}
		}
		else if (sClass.find("weapon_") != null || sClass.find("upgrade_") != null || sClass == "prop_physics")
		{
			eAngles = hEntity.GetAngles();
			foreach (item, tbl in g_tItems)
			{
				if (NetProps.GetPropString(hEntity, "m_ModelName") == tbl["model"])
				{
					local sName = item;
					local sAddition = "";
					if (sName.find("gascan") != null && NetProps.GetPropInt(hEntity, "m_nSkin") == 1)
					{
						if (NetProps.GetPropInt(hEntity, "m_iTeamNum")) sAddition = ", 0.0, true";
						sName = "gascan_scavenge"
					}
					sayf("Function:\nSpawnItem(\"%s\", Vector(%.03f, %.03f, %.03f), QAngle(%.03f, %.03f, %.03f), %d%s);",
						sName, vecPos.x, vecPos.y, vecPos.z, eAngles.x, eAngles.y, eAngles.z, NetProps.GetPropInt(hEntity, "m_itemCount"), sAddition);
					EmitSoundOnClient("Buttons.snd37", hPlayer);
					return;
				}
			}
		}
		else if (sClass == "witch")
		{
			eAngles = hEntity.GetAngles();
			sayf("Function:\nSpawnZombie(\"witch\", Vector(%.03f, %.03f, %.03f), QAngle(%.03f, %.03f, %.03f));", vecPos.x, vecPos.y, vecPos.z, eAngles.x, eAngles.y, eAngles.z);
		}
		else if (sClass == "infected")
		{
			eAngles = hEntity.GetAngles();
			sayf("Function:\nSpawnCommon(\"%s\", Vector(%.03f, %.03f, %.03f), QAngle(%.03f, %.03f, %.03f));",
				split(NetProps.GetPropString(hEntity, "m_ModelName"), "/").top().slice(0, -4), vecPos.x, vecPos.y, vecPos.z, eAngles.x, eAngles.y, eAngles.z);
		}
		else if (sClass == "prop_fuel_barrel")
		{
			eAngles = hEntity.GetAngles();
			sayf("Function:\nSpawnBarrel(Vector(%.03f, %.03f, %.03f), QAngle(%.03f, %.03f, %.03f));", vecPos.x, vecPos.y, vecPos.z, eAngles.x, eAngles.y, eAngles.z);
		}
		else bFound = false;
		
	}
	else bFound = false;
	EmitSoundOnClient(bFound ? "Buttons.snd37" : "Buttons.snd11", hPlayer);
}

function Trigger_Cmd(hPlayer)
{
	local vecPos = hPlayer.GetOrigin();
	sayf("Function:\nSpawnTrigger(\"trigger_area\", Vector(%.03f, %.03f, %.03f));", vecPos.x, vecPos.y, vecPos.z);
	SpawnEntityFromTable("prop_dynamic", {
		targetname = "task_trigger_dump"
		model = "models/extras/info_speech.mdl"
		glowstate = 3
		disableshadows = 1
		origin = vecPos + Vector(0, 0, 25)
		angles = "0 " + RandomInt(0, 360) + " 0"
	});
	EmitSoundOnClient("Buttons.snd37", hPlayer);
}

function Find_Cmd(hPlayer, sValue)
{
	if (sValue != CMD_EMPTY_ARGUMENT) EmitSoundOnClient(DebugItems(sValue = split(sValue, " ")[0]) ? "Buttons.snd37" : "Buttons.snd11", hPlayer);
	else EmitSoundOnClient(DebugItems() ? "Buttons.snd37" : "Buttons.snd11", hPlayer);
}

function Coordinates_Cmd(hPlayer)
{
	local vecPos = hPlayer.GetOrigin();
	local vecVel = hPlayer.GetVelocity();
	local eAngles = hPlayer.EyeAngles();
	sayf("Dump for %s:\nPosition: Vector(%.03f, %.03f, %.03f)\nAngles:   QAngle(%.03f, %.03f, 0.000)%s",
		hPlayer.GetPlayerName(), vecPos.x, vecPos.y, vecPos.z, eAngles.x, eAngles.y, (vecVel.IsZero(0.0) ? "" : "\nVelocity: Vector(" + vecVel.x + ", " + vecVel.y + ", " + vecVel.z + ")"));
	EmitSoundOnClient("Buttons.snd37", hPlayer);
}

function DumpInfected_Cmd()
{
	DumpInfected();
}

//=========================================================
// TLS Commands
//=========================================================

function SwitchAutoBhop_Cmd(hPlayer)
{
	if (GetConVarBool(g_ConVar_AutoBhop))
	{
		local idx = hPlayer.GetEntityIndex();
		if (g_bAutoBhop[idx])
		{
			NetProps.SetPropInt(hPlayer, "m_afButtonDisabled", NetProps.GetPropInt(hPlayer, "m_afButtonDisabled") & ~IN_JUMP);
			EmitSoundOnClient("Buttons.snd11", hPlayer);
		}
		else EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
		g_bAutoBhop[idx] = !g_bAutoBhop[idx];
	}
}

function SwitchHostAutoBhop_Cmd(hPlayer)
{
	if (hPlayer.IsHost())
	{
		if (g_bHostAutoBhop)
		{
			SendToConsole("-alt1;-jump");
			SendToConsole("bind SPACE +jump");
			EmitSoundOnClient("Buttons.snd11", hPlayer);
		}
		else
		{
			SendToConsole("alias +host_bhop \"+jump;+alt1\"");
			SendToConsole("alias -host_bhop \"-jump;-alt1\"");
			SendToConsole("bind SPACE +host_bhop");
			EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
		}
		g_bHostAutoBhop = !g_bHostAutoBhop;
	}
}

function SwitchAimbot_Cmd(hPlayer)
{
	if (GetConVarBool(g_ConVar_Aimbot))
	{
		local idx = hPlayer.GetEntityIndex();
		local bHost = hPlayer.IsHost();
		if (g_bAimbot[idx])
		{
			if (bHost)
			{
				SendToConsole("-alt2;-attack");
				SendToConsole("bind MOUSE1 +attack");
			}
			EmitSoundOnClient("Buttons.snd11", hPlayer);
			g_iAimbotUsers--;
		}
		else
		{
			if (bHost)
			{
				SendToConsole("bind MOUSE1 +alt2");
			}
			EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
			g_iAimbotUsers++;
		}
		g_bAimbot[idx] = !g_bAimbot[idx];
	}
}

function SwitchAimbot2_Cmd(hPlayer)
{
	if (GetConVarBool(g_ConVar_Aimbot))
	{
		local idx = hPlayer.GetEntityIndex();
		if (g_bAimbot2[idx])
		{
			EmitSoundOnClient("Buttons.snd11", hPlayer);
			g_iAimbotUsers--;
		}
		else
		{
			EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
			g_iAimbotUsers++;
		}
		g_bAimbot2[idx] = !g_bAimbot2[idx];
	}
}

function SwitchRageBot_Cmd(hPlayer)
{
	if (GetConVarBool(g_ConVar_Ragebot))
	{
		local idx = hPlayer.GetEntityIndex();
		if (g_bRagebot[idx])
		{
			EmitSoundOnClient("Buttons.snd11", hPlayer);
			g_iAimbotUsers--;
		}
		else
		{
			EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
			g_iAimbotUsers++;
		}
		g_bRagebot[idx] = !g_bRagebot[idx];
	}
}

function SwitchAutoStrafer_Cmd(hPlayer)
{
	local idx = hPlayer.GetEntityIndex();
	if (g_bAutoStrafer[idx]) EmitSoundOnClient("Buttons.snd11", hPlayer);
	else EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
	g_bAutoStrafer[idx] = !g_bAutoStrafer[idx];
}

function AdditionalClassMethodsInjected()
{
	RegisterChatCommand("!rst", RestartRound);
	RegisterChatCommand("!restart", RestartSpeedrun_Cmd);
	RegisterChatCommand("!changeon", EnableChangeLevel);
	RegisterChatCommand("!nextlevel", ChangeLevel);
	RegisterChatCommand("!transit", GetTransitionPosition, true);
	RegisterChatCommand("!hud", ToggleHUD, true);
	RegisterChatCommand("!fdmg", ToggleFallDamage, true);
	RegisterChatCommand("!timer", ChangeTimerValue, true, true);
	RegisterChatCommand("!pick", Picker_Cmd, true);
	RegisterChatCommand("!crds", Coordinates_Cmd, true);
	RegisterChatCommand("!find", Find_Cmd, true, true);
	RegisterChatCommand("!dbg", Debug_Cmd, true, true);
	RegisterChatCommand("!xclip", XClip_Cmd, true, true);
	RegisterChatCommand("!trigger", Trigger_Cmd, true);
	RegisterChatCommand("!zdump", DumpInfected_Cmd);

	// TLS Commands
	RegisterChatCommand("!bhop", SwitchAutoBhop_Cmd, true);
	RegisterChatCommand("!bhop2", SwitchHostAutoBhop_Cmd, true);
	RegisterChatCommand("!aimbot", SwitchAimbot_Cmd, true);
	RegisterChatCommand("!aimbot2", SwitchAimbot2_Cmd, true);
	RegisterChatCommand("!ragebot", SwitchRageBot_Cmd, true);
	RegisterChatCommand("!autostrafer", SwitchAutoStrafer_Cmd, true);
}
