// Squirrel
// TAS Kit
// Powered by AP

const __TAS_KIT_VER__ = "1.0"
const __MAIN_PATH__ = "tas_kit/"

IncludeScript("modules/skipintro");
IncludeScript("modules/tls");
IncludeScript("modules/autosb");
IncludeScript("modules/fillbot");
IncludeScript("modules/tools");
IncludeScript("modules/custom_spawn");
IncludeScript("modules/speedrunner_tools");
IncludeScript("modules/chat_commands");
IncludeScript("modules/helper_utils");

cvar("sv_cheats", 1);
cvar("sv_client_min_interp_ratio", 0);
cvar("sv_vote_creation_timer", 0);
cvar("director_afk_timeout", 999999);
cvar("director_no_death_check", 1);
cvar("sb_all_bot_game", 1);
cvar("host_timescale", 1);
cvar("z_mega_mob_size", 50);

g_flFinaleStartTime <- null;
g_bSpeedrunStarted <- false;
if (!("g_bRestarting" in this)) g_bRestarting <- false;

__tEvents <- {};

g_tSegmentData <- {};

g_Timer <-
{
	HUD = {Fields = {}}
	previous_segment = 0.0
	start_time = 0.0
	time = 0.0
};

function UpdateDataTable(tData)
{
	local sData = "{";
	foreach (key, val in tData)
	{
		if (typeof val == "string") sData = format("%s\n\t%s = \"%s\"", sData, key, val);
		else if (typeof val == "float") sData = format("%s\n\t%s = %f", sData, key, val);
		else if (typeof val == "integer" || typeof val == "bool") sData = sData + "\n\t" + key + " = " + val;
	}
	sData = sData + "\n}\n";
	StringToFile(__MAIN_PATH__ + "data.nut", sData);
}

if (!("g_tDataTable" in this))
{
	g_tDataTable <- {
		timer = 3.0
		fdmg = true
		hud = true
	};
	local tData = FileToString(__MAIN_PATH__ + "data.nut");
	if (tData)
	{
		tData = compilestring("return " + tData)();
		foreach (key, val in g_tDataTable) if (key in tData) g_tDataTable.rawset(key, tData.rawget(key));
	}
	else printf("[TAS Kit] The data table was created in the 'left4dead2/ems/%s' folder\n", __MAIN_PATH__);
	UpdateDataTable(g_tDataTable);
	IncludeScript("modules/template");
}

function OnGameplayStart()
{
	InitializeHUD();
	if (SessionState["MapName"] == "c6m1_riverbank") PrecacheEntityFromTable({classname = "prop_dynamic", model = "models/infected/witch.mdl"});
	if (g_bRestarting)
	{
		try {
			RemoveHooks();
			if (IncludeScript("main", this = getroottable()))
			{
				__SkipIntro();
				InitializeHooks();
				Countdown(3);

				if ("Cvars" in this)
				{
					foreach (key, val in Cvars)
					{
						cvar(key, val.tostring());
					}
				}

				if ("Survivors" in this)
				{
					local hPlayer, aVars, bIdle, eAngles, vecPos;
					foreach (char, tbl in Survivors)
					{
						bIdle = false;
						vecPos = null;
						eAngles = null;
						aVars = array(8, null);
						if (tbl.rawin("origin"))
						{
							if (tbl["origin"])
							{
								aVars[0] = tbl["origin"];
								vecPos = tbl["origin"];
							}
						}
						if (tbl.rawin("angles"))
						{
							if (tbl["angles"])
							{
								aVars[1] = tbl["angles"];
								eAngles = tbl["angles"];
							}
						}
						if (tbl.rawin("velocity")) if (tbl["velocity"]) aVars[2] = tbl["velocity"];
						if (tbl.rawin("health")) if (tbl["health"] != null) aVars[3] = tbl["health"];
						if (tbl.rawin("buffer")) if (tbl["buffer"] != null) aVars[4] = tbl["buffer"];
						if (tbl.rawin("revives")) if (tbl["revives"] != null) aVars[5] = tbl["revives"];
						if (tbl.rawin("idle")) if (tbl["idle"]) bIdle = true;
						if (tbl.rawin("Inventory")) {
							if (tbl["Inventory"])
							{
								local sActiveWeapon;
								local aWeaponList = [];
								local aInv = array(7, null);
								local tInv = tbl["Inventory"];
								if (tInv.rawin("active_slot") && !tInv.rawin("slot5"))
								{
									if (tInv["active_slot"])
									{
										local sSlot = tInv["active_slot"];
										sActiveWeapon = (sSlot.slice(-1).tointeger() < 2 ? tInv[sSlot]["weapon"] : tInv[sSlot]);
									}
								}
								foreach (slot, val in tInv)
								{
									if (val)
									{
										if (slot == "slot0" || slot == "slot1") aWeaponList.push(val["weapon"]);
										else if (slot != "slot5" && slot != "active_slot") aWeaponList.push(val);
									}
								}
								if (sActiveWeapon)
								{
									for (local i = 0; i < aWeaponList.len(); i++)
									{
										if (aWeaponList[i] == sActiveWeapon)
										{
											aWeaponList.push(aWeaponList[i]);
											aWeaponList.remove(i);
											break;
										}
									}
								}
								else if (tInv.rawin("slot5"))
								{
									if (tInv["slot5"])
									{
										aWeaponList.push(tInv["slot5"]);
									}
								}
								aInv[0] = aWeaponList;
								aInv[1] = sActiveWeapon;
								if (tInv.rawin("slot0"))
								{
									if (tInv["slot0"])
									{
										local iClip, iAmmo, iUpgradeAmmo;
										if (tInv["slot0"].rawin("clip")) aInv[2] = tInv["slot0"]["clip"];
										if (tInv["slot0"].rawin("ammo")) aInv[3] = tInv["slot0"]["ammo"];
										if (tInv["slot0"].rawin("upgrade_type")) aInv[4] = tInv["slot0"]["upgrade_type"];
										if (tInv["slot0"].rawin("upgrade_clip")) aInv[5] = tInv["slot0"]["upgrade_clip"];
									}
								}
								if (tInv.rawin("slot1"))
								{
									if (tInv["slot1"])
									{
										if (tInv["slot1"].rawin("clip")) aInv[6] = tInv["slot1"]["clip"];
									}
								}
								aVars[6] = aInv;
							}
						}
						if ("Actions" in tbl) if (tbl["Actions"]) aVars[7] = tbl["Actions"];
						if (hPlayer = Entities.FindByName(null, "!" + char))
						{
							if (vecPos || eAngles)
							{
								TP(hPlayer, vecPos, eAngles);
							}
							if (bIdle)
							{
								if (hPlayer.IsHost()) SendToServerConsole("go_away_from_keyboard");
								SendToServerConsole("sm_idle " + hPlayer.GetEntityIndex());
							}
						}
						g_tSegmentData[char] <- aVars;
					}
				}

				if ("__OnGameplayStart" in this)
					::__OnGameplayStart();

				printl("[TAS Kit]\nAuthor: Sw1ft\nVersion: " + __TAS_KIT_VER__);
				SendToServerConsole("echo Loaded the custom script file");
				return;
			}
			else
			{
				g_bRestarting = false;
				SayMsg("File 'main.nut' not found in the '.../scripts/vscripts' folder");
			}
		}
		catch (error) {
			g_bRestarting = false;
			SayMsg("An error has occurred while executing the script file");
			SayMsg("Check the console for more information");
		}
	}
	EntFire("info_changelevel", "Disable");
	printl("[TAS Kit]\nAuthor: Sw1ft\nVersion: " + __TAS_KIT_VER__);
}

function IssueSurvivorEquipment(hPlayer, vecPos, eAngles, vecVel, iHealth, flHealthBuffer, iRevivies, aInventory, funcActions)
{
	if (vecPos || eAngles || vecVel) TP(hPlayer, vecPos, eAngles, vecVel);
	if (iHealth != null) hPlayer.SetHealth(iHealth);
	if (flHealthBuffer != null) hPlayer.SetHealthBuffer(flHealthBuffer);
	if (iRevivies != null) hPlayer.SetReviveCount(iRevivies);
	if (aInventory) {
		foreach (weapon in aInventory[0]) // aWeaponList
			hPlayer.GiveItem(weapon);
		if (aInventory[1]) // sActiveWeapon
		{
			if (hPlayer.IsHost()) SendToServerConsole("use weapon_" + aInventory[1]);
			else SendToServerConsole(format("sm_ccmd %d \"use weapon_%s\"", hPlayer.GetEntityIndex(), aInventory[1]));
		}
		if (aInventory[4] != null) // iUpgradeType
			hPlayer.GiveUpgrade(aInventory[4]);
		if (aInventory[2] != null || aInventory[3] != null || aInventory[5] != null) // iPrimaryWeaponClip, iPrimaryWeaponAmmo, iUpgradeClip
			hPlayer.SetAmmo(eInventoryWeapon.Primary, aInventory[2], aInventory[3], aInventory[5]);
		if (aInventory[6] != null) // iSecondaryWeaponClip
			hPlayer.SetAmmo(eInventoryWeapon.Secondary, aInventory[6]);
	}
	if (funcActions) funcActions(hPlayer);
}

function RemoveHooks()
{
	this = getroottable();
	if ("Cvars" in this) delete ::Cvars;
	if ("Survivors" in this) delete ::Survivors;
	if ("OnSpeedrunStart" in this) delete ::OnSpeedrunStart;
	if ("OnSpeedrunRestart" in this) delete ::OnSpeedrunRestart;
	if ("OnFinaleStart" in this) delete ::OnFinaleStart;
	if ("OnRocketJumpCompleted" in this) delete ::OnRocketJumpCompleted;
	if ("OnBileBoostCompleted" in this) delete ::OnBileBoostCompleted;
	if ("OnSpitterBoostCompleted" in this) delete ::OnSpitterBoostCompleted;
	if ("OnBeginCustomStage" in this) delete ::OnBeginCustomStage;
	if ("__OnGameplayStart" in this) delete ::__OnGameplayStart;
}

function OnCheckpointDoorClosed()
{
	if (!g_bRestarting)
	{
		EntFire("info_changelevel", "CheckpointDoorClosed");
	}
}

function RestartSpeedrun()
{
	if (!g_bRestarting)
	{
		g_bRestarting = true;
		cvar("mp_restartgame", 1);
		cvar("host_timescale", 1);
		SayMsg("Restarting...");
		EntFire("info_changelevel", "Disable");
		if ("OnSpeedrunRestart" in getroottable()) ::OnSpeedrunRestart();
	}
}

function StartSpeedrun()
{
	g_bRestarting = false;
	g_bSpeedrunStarted = true;
	g_Timer["start_time"] = Time();
}

function PrintTime()
{
	if (g_bSpeedrunStarted)
	{
		local flTime;
		if (g_flFinaleStartTime != null)
		{
			flTime = Time() - g_flFinaleStartTime;
			sayf("Finale event time: %.03f %s", flTime, (flTime >= 60 ? ("(" + ToClock(flTime) + ")") : ""));
		}
		if (g_Timer["previous_segment"] > 0)
		{
			flTime = g_Timer["previous_segment"] + g_Timer["time"];
			sayf("Total time: %.03f %s", flTime, (flTime >= 60 ? ("(" + ToClock(flTime) + ")") : ""));
		}
		sayf("Segment time: %.03f %s", g_Timer["time"], (g_Timer["time"] >= 60 ? ("(" + ToClock(g_Timer["time"]) + ")") : ""));
		cvar("host_timescale", 1.0);
		g_bSpeedrunStarted = false;
		g_bRestarting = true;
	}
}

function InitializeHooks()
{
	if (SessionState["MapName"] == "c5m5_bridge")
		EntFire("trigger_heli", "AddOutput", "OnEntireTeamStartTouch !caller,RunScriptCode,PrintTime()");
	else if (SessionState["MapName"] == "c13m4_cutthroatcreek")
		EntFire("trigger_boat", "AddOutput", "OnEntireTeamStartTouch !caller,RunScriptCode,PrintTime()");

	EntFire("prop_door_rotating_checkpoint", "AddOutput", "OnFullyClosed !caller,RunScriptCode,OnCheckpointDoorClosed()");
	EntFire("info_changelevel", "AddOutput", "OnStartTouch !caller,RunScriptCode,OnCheckpointDoorClosed()");

	HookEvent("player_death", __tEvents.OnPlayerDeath, __tEvents);
	HookEvent("player_disconnect", __tEvents.OnPlayerDisconnect, __tEvents);
	HookEvent("finale_vehicle_leaving", __tEvents.OnFinaleVehicleLeaving, __tEvents);
	HookEvent("map_transition", __tEvents.OnMapTransition, __tEvents);
}

function InitializeHUD()
{
	if (g_tDataTable["hud"])
	{
		g_Timer["start_time"] = 0.0;
		g_Timer.HUD.Fields["timer_sec"] <- {slot = HUD_LEFT_TOP, dataval = 0.0, flags = HUD_FLAG_AS_TIME | HUD_FLAG_ALIGN_RIGHT};
		g_Timer.HUD.Fields["timer_ms"] <- {slot = HUD_LEFT_BOT, dataval = "000", flags = HUD_FLAG_NOBG};
		g_Timer.HUD.Fields["timer_comma"] <- {slot = HUD_MID_TOP, dataval = "'", flags = HUD_FLAG_NOBG};
		HUDSetLayout(g_Timer["HUD"]);
	}
	else
	{
		g_Timer.HUD.Fields["timer_sec"] <- {slot = HUD_LEFT_TOP, dataval = 0.0, flags = HUD_FLAG_AS_TIME | HUD_FLAG_ALIGN_RIGHT | HUD_FLAG_NOTVISIBLE};
		g_Timer.HUD.Fields["timer_ms"] <- {slot = HUD_LEFT_BOT, dataval = "000", flags = HUD_FLAG_NOBG | HUD_FLAG_NOTVISIBLE};
		g_Timer.HUD.Fields["timer_comma"] <- {slot = HUD_MID_TOP, dataval = "'", flags = HUD_FLAG_NOBG | HUD_FLAG_NOTVISIBLE};
	}
	RegisterOnTickFunction("HUD_Think");
}

function HUD_Think()
{
	if (g_tDataTable["hud"] && g_bSpeedrunStarted)
	{
		local flTime = Time() - g_Timer["start_time"];
		g_Timer["time"] = flTime;
		g_Timer.HUD.Fields.timer_sec["dataval"] = flTime;
		g_Timer.HUD.Fields.timer_ms["dataval"] = split(format("%.03f", flTime), ".")[1];
		HUDSetLayout(g_Timer["HUD"]);
	}
}

function Countdown_Think()
{
	local hPlayer;
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		if (hPlayer.IsSurvivor())
		{
			NetProps.SetPropInt(hPlayer, "m_fFlags", NetProps.GetPropInt(hPlayer, "m_fFlags") | FL_FROZEN);
			if (g_bBeginMap) continue;
			local tInv = {};
			GetInvTable(hPlayer, tInv);
			foreach (key, val in tInv)
			{
				val.Kill();
			}
		}
	}
}

function Countdown(iValue)
{
	if (iValue == 3)
	{
		Countdown_Think();
		RegisterOnTickFunction("Countdown_Think");
		CreateTimer(g_tDataTable["timer"] / 3, Countdown, 2);
		CreateTimer(g_tDataTable["timer"] / 3 * 2, Countdown, 1);
		CreateTimer(g_tDataTable["timer"], Countdown, 0);
	}
	if (iValue == 0)
	{
		RemoveOnTickFunction("Countdown_Think");
		StartSpeedrun();
		local hPlayer;
		local bFreezeL4D1Survivors = false;
		local aL4D1Characters = ["Louis", "Zoey", "Bill", "Francis"];
		if (["c6m1_riverbank", "c6m3_port"].find(SessionState["MapName"]) != null)
		{
			bFreezeL4D1Survivors = true;
		}
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			if (hPlayer.IsSurvivor())
			{
				if (bFreezeL4D1Survivors)
				{
					if (IsPlayerABot(hPlayer) && aL4D1Characters.find(hPlayer.GetPlayerName()) != null)
					{
						continue;
					}
				}
				NetProps.SetPropInt(hPlayer, "m_fFlags", NetProps.GetPropInt(hPlayer, "m_fFlags") & ~FL_FROZEN);
				AcceptEntityInput(hPlayer, "DisableLedgeHang");
				local sCharacter = GetCharacterDisplayName(hPlayer).tolower();
				if (sCharacter in g_tSegmentData)
				{
					local aVars = [this, hPlayer];
					aVars.extend(g_tSegmentData[sCharacter]);
					IssueSurvivorEquipment.acall(aVars);
				}
			}
		}
		g_tSegmentData.clear();
		if (!CustomSpawn.hTriggerFinale) CustomSpawn.hTriggerFinale = Entities.FindByClassname(null, "trigger_finale");
		if ("OnSpeedrunStart" in getroottable()) ::OnSpeedrunStart();
		return;
	}
	SayMsg(iValue);
}

function __tEvents::OnMapTransition(tParams) PrintTime();

function __tEvents::OnFinaleVehicleLeaving(tParams) PrintTime();

function __tEvents::OnPlayerDeath(tParams) OnCheckpointDoorClosed();

function __tEvents::OnPlayerDisconnect(tParams) OnCheckpointDoorClosed();

function __tEvents::OnPlayerFallDamage(tParams) if (g_tDataTable["fdmg"]) sayf("Player %s fdmg %.01f", tParams["_player"].GetPlayerName(), tParams["damage"]);

HookEvent("player_falldamage", __tEvents.OnPlayerFallDamage, __tEvents);