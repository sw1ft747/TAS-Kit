// Squirrel
// TAS Kit
// Powered by AP

class CScriptPluginTASKit extends IScriptPlugin
{
	function Load()
	{
		local roottable = getroottable();

		this.LoadModules(roottable);

		cvar("sv_cheats", 1);
		cvar("sv_client_min_interp_ratio", 0);
		cvar("sv_vote_creation_timer", 0);
		cvar("director_afk_timeout", 999999);
		cvar("director_no_death_check", 1);
		cvar("sb_all_bot_game", 1);
		cvar("host_timescale", 1);
		cvar("z_mega_mob_size", 50);
		cvar("director_panic_wave_pause_max", 5);

		HookEvent("player_falldamage", __tEvents.OnPlayerFallDamage, __tEvents);

		InitializeHUD();
		InitializeMapParams();

		if (g_bRestarting)
		{
			try {
				RemoveHooks();
				Callbacks.clear();
				if (IncludeScript("main", roottable))
				{
					__SkipIntro();
					InitializeHooks();
					Countdown(3);

					if ("Cvars" in roottable)
					{
						foreach (key, val in Cvars)
						{
							cvar(key, val.tostring());
						}
					}

					if ("Survivors" in roottable)
					{
						local hPlayer, aVars, bIdle, eAngles, vecPos;
						foreach (char, tbl in Survivors)
						{
							bIdle = false;
							vecPos = null;
							eAngles = null;
							aVars = array(8, null);

							if (tbl.rawin("origin") && tbl["origin"])
							{
								aVars[0] = tbl["origin"];
								vecPos = tbl["origin"];
							}

							if (tbl.rawin("angles") && tbl["angles"])
							{
								aVars[1] = tbl["angles"];
								eAngles = tbl["angles"];
							}

							if (tbl.rawin("velocity") && tbl["velocity"]) aVars[2] = tbl["velocity"];

							if (tbl.rawin("health") && tbl["health"] != null) aVars[3] = tbl["health"];

							if (tbl.rawin("buffer") && tbl["buffer"] != null) aVars[4] = tbl["buffer"];

							if (tbl.rawin("revives") && tbl["revives"] != null) aVars[5] = tbl["revives"];

							if (tbl.rawin("idle") && tbl["idle"]) bIdle = true;

							if (tbl.rawin("Inventory") && tbl["Inventory"]) {
								local aWeaponList = [];
								local aInv = array(7, null);
								local tInv = tbl["Inventory"];
								local sActiveWeapon, bDual;

								if (tInv.rawin("active_slot") && !tInv.rawin("slot5") && tInv["active_slot"])
								{
									local sSlot = tInv["active_slot"];
									sActiveWeapon = (sSlot.slice(-1).tointeger() < 2 ? tInv[sSlot]["weapon"] : tInv[sSlot]);
								}

								if (tInv.rawin("slot0") && tInv["slot0"])
								{
									if (tInv["slot0"].rawin("clip")) aInv[2] = tInv["slot0"]["clip"];
									if (tInv["slot0"].rawin("ammo")) aInv[3] = tInv["slot0"]["ammo"];
									if (tInv["slot0"].rawin("upgrade_type")) aInv[4] = tInv["slot0"]["upgrade_type"];
									if (tInv["slot0"].rawin("upgrade_clip")) aInv[5] = tInv["slot0"]["upgrade_clip"];
								}

								if (tInv.rawin("slot1") && tInv["slot1"])
								{
									if (tInv["slot1"].rawin("clip")) aInv[6] = tInv["slot1"]["clip"];
									bDual = tInv["slot1"].rawin("dual") && tInv["slot1"]["dual"];
								}

								foreach (slot, val in tInv)
								{
									if (val)
									{
										if (slot == "slot0")
										{
											aWeaponList.push(val["weapon"]);
										}
										else if (slot == "slot1")
										{
											if (bDual && val["weapon"] == "pistol") aWeaponList.push("pistol");
											aWeaponList.push(val["weapon"]);
										}
										else if (slot != "slot5" && slot != "active_slot")
										{
											aWeaponList.push(val);
										}
									}
								}

								if (sActiveWeapon)
								{
									for (local i = 0; i < aWeaponList.len(); i++)
									{
										if (aWeaponList[i] == sActiveWeapon)
										{
											if (bDual && sActiveWeapon == "pistol")
											{
												aWeaponList.push("pistol");
												aWeaponList.remove(i + 1);
											}
											aWeaponList.push(aWeaponList[i]);
											aWeaponList.remove(i);
										}
									}
								}
								else if (tInv.rawin("slot5") && tInv["slot5"])
								{
									aWeaponList.push(tInv["slot5"]);
								}

								aInv[0] = aWeaponList;
								aInv[1] = sActiveWeapon;
								aVars[6] = aInv;
							}

							if ("Actions" in tbl && tbl["Actions"]) aVars[7] = tbl["Actions"];

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

					if ("OnGameplayStart" in ::Callbacks)
						::Callbacks.OnGameplayStart();

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

	function Unload()
	{

	}

	function OnRoundStartPost()
	{
		
	}

	function OnRoundEnd()
	{

	}

	function AdditionalClassMethodsInjected()
	{

	}

	function GetClassName() { return m_sClassName; }

	function GetScriptPluginName() { return m_sScriptPluginName; }

	function GetInterfaceVersion() { return m_InterfaceVersion; }

	function LoadModules(scope)
	{
		IncludeScript("modules/speedrunner_tools", scope);
		IncludeScript("modules/helper_utils", scope);
		IncludeScript("modules/skipintro", scope);
		IncludeScript("modules/tls", scope);
		IncludeScript("modules/autosb", scope);
		IncludeScript("modules/fillbot", scope);
		IncludeScript("modules/tools", scope);
		IncludeScript("modules/finale_manager", scope);
		IncludeScript("modules/chat_commands", scope);
		IncludeScript("auto_execution", scope);
	}

	function _set(key, val) { throw null; }

	static m_InterfaceVersion = 1;
	static m_sClassName = "CScriptPluginTASKit";
	static m_sScriptPluginName = "TAS Kit";
}

const __TAS_KIT_VER__ = "1.3"
const __MAIN_PATH__ = "tas_kit/"

__tEvents <- {};
Callbacks <- {};
g_tSegmentData <- {};

g_flFinaleStartTime <- null;
g_bSpeedrunStarted <- false;

g_TASKit <- CScriptPluginTASKit();

if (!("g_bRestarting" in this)) g_bRestarting <- false;
if (!("g_bApplyMapParams" in this)) g_bApplyMapParams <- true;

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
		switch (typeof val)
		{
		case "string":
			sData = format("%s\n\t%s = \"%s\"", sData, key, val);
			break;
		
		case "float":
			sData = format("%s\n\t%s = %f", sData, key, val);
			break;
		
		case "integer":
		case "bool":
			sData = sData + "\n\t" + key + " = " + val;
			break;
		}
	}
	sData = sData + "\n}\n";
	StringToFile(__MAIN_PATH__ + "data.nut", sData);
}

if (!("g_tDataTable" in this))
{
	g_tDataTable <-
	{
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
	else
	{
		printf("[TAS Kit] The data table was created in the 'left4dead2/ems/%s' folder\n", __MAIN_PATH__);
	}

	UpdateDataTable(g_tDataTable);
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

		if ("OnSpeedrunRestart" in ::Callbacks)
			::Callbacks.OnSpeedrunRestart();
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
	if (g_sMapName == "c5m5_bridge") EntFire("trigger_heli", "AddOutput", "OnEntireTeamStartTouch !caller,RunScriptCode,PrintTime()");
	if (g_sMapName == "c13m4_cutthroatcreek") EntFire("trigger_boat", "AddOutput", "OnEntireTeamStartTouch !caller,RunScriptCode,PrintTime()");

	EntFire("prop_door_rotating_checkpoint", "AddOutput", "OnFullyClosed !caller,RunScriptCode,OnCheckpointDoorClosed()");
	EntFire("info_changelevel", "AddOutput", "OnStartTouch !caller,RunScriptCode,OnCheckpointDoorClosed()");

	HookEvent("player_death", __tEvents.OnPlayerDeath, __tEvents);
	HookEvent("player_disconnect", __tEvents.OnPlayerDisconnect, __tEvents);
	HookEvent("finale_vehicle_leaving", __tEvents.OnFinaleVehicleLeaving, __tEvents);
	HookEvent("map_transition", __tEvents.OnMapTransition, __tEvents);
}

function InitializeMapParams()
{
	if (!g_bApplyMapParams)
		return;

	switch (g_sMapName)
	{
	case "c1m3_mall":
		// remove random mid-way path
		local hTrigger;
		if (hTrigger = Entities.FindByClassnameNearest("trigger_once", Vector(1608, -1056, 396), 5.0))
		{
			hTrigger.__KeyValueFromString("targetname", "minifinale_trigger");
			EntFire("minifinale_trigger", "AddOutput", "OnTrigger relay_stairwell_close,Trigger", 0.5);
			EntFire("director_query", "Kill");
			EntFire("compare_minifinale", "Kill");
		}
		// remove random escalator path
		hTrigger = null;
		if (hTrigger = Entities.FindByClassnameNearest("trigger_once", Vector(557.41, -2189.91, 336), 5.0))
		{
			hTrigger.__KeyValueFromString("targetname", "escalator_trigger");
			EntFire("escalator_trigger", "AddOutput", "OnTrigger relay_elevator_path_06,Trigger");
			EntFire("case_path", "Kill");
			EntFire("relay_director_set_*", "Kill");
			EntFire("director_query_elevator_*", "Kill");
		}
		break;

	case "c2m4_barns":
		// remove random fence
		EntFire("randompath_1_*", "Kill");
		break;

	case "c2m5_concert":
		// use left side for incoming heli, faster by ~2 seconds
		EntFire("stadium_exit_right_relay", "Disable");
		EntFire("stadium_exit_right_template", "Kill");
		EntFire("stadium_exit_left_relay", "Enable");
		EntFire("stadium_exit_left_template", "ForceSpawn");

		CreateTimer(0.1, function(){
			EntFire("stadium_exit_right_relay", "Disable");
			EntFire("stadium_exit_right_template", "Kill");
			EntFire("stadium_exit_left_relay", "Enable");
			EntFire("stadium_exit_left_template", "ForceSpawn");
		});
		break;

	case "c5m3_cemetery":
		// remove random cemetery path
		local hEntity;
		if (hEntity = Entities.FindByName(null, "case_maze_config")) hEntity.Kill();
		EntFire("Path_*", "Kill");
		EntFire("template_Path_C", "ForceSpawn");
		break;

	case "c6m1_riverbank":
		PrecacheEntityFromTable({classname = "prop_dynamic", model = "models/infected/witch.mdl"});
		break;
		
	case "c7m1_docks":
		// custom intro with 3 biles for convenient start
		local flCvarValue = cvar("sv_infected_ceda_vomitjar_probability");
		EntFire("infected_spawner", "Kill");
		cvar("sv_infected_ceda_vomitjar_probability", 0.0);
		SpawnCommonWithBile(Vector(13716.000, 3108.000, 44.000), QAngle(0.000, 208.500, 0.000));
		SpawnCommonWithBile(Vector(13556.000, 2480.000, 44.000), QAngle(0.000, 148.500, 0.000));
		SpawnCommonWithBile(Vector(13572.000, 2674.000, 44.000), QAngle(0.000, 133.500, 0.000));
		SpawnCommon("common_male_tankTop_jeans", Vector(13440.000, 2496.000, 44.000), QAngle(0.000, 137.000, 0.000));
		SpawnCommon("common_male_tankTop_jeans", Vector(13444.000, 2858.000, 44.000), QAngle(0.000, 253.500, 0.000));
		SpawnCommon("common_female_tankTop_jeans", Vector(13392.000, 2662.000, 44.000), QAngle(0.000, 193.500, 0.000));
		SpawnCommon("common_female_tankTop_jeans", Vector(13061.300, 2490.920, 36.065), QAngle(0.000, 103.500, 0.000));
		SpawnCommon("common_male_ceda", Vector(13934.000, 2962.000, 47.000), QAngle(0.000, 208.500, 0.000));
		SpawnCommon("common_male_ceda", Vector(13224.000, 2660.000, 42.214), QAngle(0.000, 343.500, 0.000));
		SpawnCommon("common_male_ceda", Vector(13425.500, 2935.290, 80.000), QAngle(0.000, 173.500, 0.000));
		CreateTimer(0.01, cvar, "sv_infected_ceda_vomitjar_probability", flCvarValue);
		break;
	}
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

			if (g_bBeginMap)
				continue;

			local tInv = {};
			GetInvTable(hPlayer, tInv);

			foreach (key, val in tInv)
				val.Kill();
		}
	}
}

function Countdown(iValue)
{
	if (iValue == 3)
	{
		Countdown_Think();
		RegisterOnTickFunction("Countdown_Think");

		CreateTimer(g_tDataTable["timer"] / 3.0, Countdown, 2);
		CreateTimer(g_tDataTable["timer"] / 3.0 * 2.0, Countdown, 1);
		CreateTimer(g_tDataTable["timer"], Countdown, 0);
	}

	if (iValue == 0)
	{
		RemoveOnTickFunction("Countdown_Think");
		StartSpeedrun();

		local hPlayer;
		local bFreezeL4D1Survivors = false;
		local aL4D1Characters = ["Louis", "Zoey", "Bill", "Francis"];

		if (["c6m1_riverbank", "c6m3_port"].find(g_sMapName) != null)
		{
			bFreezeL4D1Survivors = true;
		}

		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			if (hPlayer.IsSurvivor())
			{
				if (bFreezeL4D1Survivors && IsPlayerABot(hPlayer) && aL4D1Characters.find(hPlayer.GetPlayerName()) != null)
					continue;

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

		if (!FinaleManager.hTriggerFinale)
		{
			if (FinaleManager.hTriggerFinale = Entities.FindByClassname(null, "trigger_finale"))
				FinaleManager.HookTriggerFinale();
		}

		if ("OnSpeedrunStart" in ::Callbacks)
			::Callbacks.OnSpeedrunStart();

		return;
	}

	SayMsg(iValue);
}

function __tEvents::OnMapTransition(tParams) PrintTime();

function __tEvents::OnFinaleVehicleLeaving(tParams) PrintTime();

function __tEvents::OnPlayerDeath(tParams) OnCheckpointDoorClosed();

function __tEvents::OnPlayerDisconnect(tParams) OnCheckpointDoorClosed();

function __tEvents::OnPlayerFallDamage(tParams) if (g_tDataTable["fdmg"]) sayf("Player %s fdmg %.01f", tParams["_player"].GetPlayerName(), tParams["damage"]);

g_ScriptPluginsHelper.AddScriptPlugin(g_TASKit);
