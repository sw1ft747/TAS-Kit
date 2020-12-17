// Squirrel
// Helper Utils
// Powered by AP

g_sTriggersDump <- "";
g_bTriggerEditor <- false;
g_aTriggerPoints <- [null, null];

if (!("g_aOfficialMaps" in getroottable()))
{
	::g_aOfficialMaps <-
	[
		"c1m1_hotel"
		"c1m2_streets"
		"c1m3_mall"
		"c1m4_atrium"
		"c2m1_highway"
		"c2m2_fairgrounds"
		"c2m3_coaster"
		"c2m4_barns"
		"c2m5_concert"
		"c3m1_plankcountry"
		"c3m2_swamp"
		"c3m3_shantytown"
		"c3m4_plantation"
		"c4m1_milltown_a"
		"c4m2_sugarmill_a"
		"c4m3_sugarmill_b"
		"c4m4_milltown_b"
		"c4m5_milltown_escape"
		"c5m1_waterfront"
		"c5m2_park"
		"c5m3_cemetery"
		"c5m4_quarter"
		"c5m5_bridge"
		"c6m1_riverbank"
		"c6m2_bedlam"
		"c6m3_port"
		"c7m1_docks"
		"c7m2_barge"
		"c7m3_port"
		"c8m1_apartment"
		"c8m2_subway"
		"c8m3_sewers"
		"c8m4_interior"
		"c8m5_rooftop"
		"c9m1_alleys"
		"c9m2_lots"
		"c10m1_caves"
		"c10m2_drainage"
		"c10m3_ranchhouse"
		"c10m4_mainstreet"
		"c10m5_houseboat"
		"c11m1_greenhouse"
		"c11m2_offices"
		"c11m3_garage"
		"c11m4_terminal"
		"c11m5_runway"
		"c12m1_hilltop"
		"c12m2_traintunnel"
		"c12m3_bridge"
		"c12m4_barn"
		"c12m5_cornfield"
		"c13m1_alpinecreek"
		"c13m2_southpinestream"
		"c13m3_memorialbridge"
		"c13m4_cutthroatcreek"
		"c14m1_junkyard"
		"c14m2_lighthouse"
	];

	::g_aOfficialBeginMaps <-
	[
		"c1m1_hotel"
		"c2m1_highway"
		"c3m1_plankcountry"
		"c4m1_milltown_a"
		"c5m1_waterfront"
		"c6m1_riverbank"
		"c7m1_docks"
		"c8m1_apartment"
		"c9m1_alleys"
		"c10m1_caves"
		"c11m1_greenhouse"
		"c12m1_hilltop"
		"c13m1_alpinecreek"
		"c14m1_junkyard"
	];

	::g_aOfficialMapsWithLongestAggressiveDistance <-
	[
		"c1m1_hotel"
		"c1m2_streets"
		"c1m3_mall"
		"c1m4_atrium"
		"c4m1_milltown_a"
		"c4m2_sugarmill_a"
		"c4m3_sugarmill_b"
		"c4m4_milltown_b"
		"c4m5_milltown_escape"
		"c5m1_waterfront"
		"c5m2_park"
		"c5m3_cemetery"
		"c5m4_quarter"
		"c5m5_bridge"
		"c13m1_alpinecreek"
		"c13m2_southpinestream"
		"c13m3_memorialbridge"
		"c13m4_cutthroatcreek"
	];

	::g_aCEDAPopulationMaps <-
	[
		"c1m1_hotel"
		"c1m2_streets"
		"c1m3_mall"
		"c1m4_atrium"
		"c7m1_docks"
		"c7m2_barge"
		"c7m3_port"
	];

	::g_bOfficialMap <- g_aOfficialMaps.find(SessionState["MapName"]) != null;
	::g_bBeginMap <- g_aOfficialBeginMaps.find(SessionState["MapName"]) != null;
	::g_bMapWithLongestAggressiveDistance <- g_aOfficialMapsWithLongestAggressiveDistance.find(SessionState["MapName"]) != null;
	::g_bContainsCEDAPopulation <- g_aCEDAPopulationMaps.find(SessionState["MapName"]) != null;
}

function SetTriggerPoint()
{
	if (!g_bTriggerEditor) return;
	local hPlayer = GetHostPlayer();
	if (hPlayer)
	{
		if (!g_aTriggerPoints[0])
		{
			SayMsg("[SetTriggerPoint] First point set");
			EmitSoundOnClient("Buttons.snd37", hPlayer);
			g_aTriggerPoints[0] = hPlayer.GetOrigin();
			return;
		}
		else if (!g_aTriggerPoints[1])
		{
			SayMsg("[SetTriggerPoint] Second point set");
			EmitSoundOnClient("Buttons.snd37", hPlayer);
			g_aTriggerPoints[1] = hPlayer.GetOrigin();
			return;
		}
		SayMsg("[SetTriggerPoint] Reset of current points");
		g_aTriggerPoints[0] = null;
		g_aTriggerPoints[1] = null;
		SetTriggerPoint();
	}
}

function DumpTrigger()
{
	if (!g_aTriggerPoints[0] || !g_aTriggerPoints[1] || !g_bTriggerEditor)
	{
		SayMsg("[DumpTrigger] Not enough vector points");
		return;
	}
	local hPlayer = GetHostPlayer();
	if (hPlayer)
	{
		local sDump;
		local vecPos = g_aTriggerPoints[0];
		local flPitch = g_aTriggerPoints[1].x - g_aTriggerPoints[0].x;
		local flYaw = g_aTriggerPoints[1].y - g_aTriggerPoints[0].y;
		local flRoll = g_aTriggerPoints[1].z - g_aTriggerPoints[0].z;
		if (flPitch < 0 && flYaw < 0)
		{
			flPitch *= -1;
			flYaw *= -1;
			vecPos -= Vector(flPitch, flYaw, 0);
		}
		else if (flPitch > 0 && flYaw < 0)
		{
			flYaw *= -1;
			vecPos -= Vector(0, flYaw, 0);
		}
		else if (flPitch < 0 && flYaw > 0)
		{
			flPitch *= -1;
			vecPos -= Vector(flPitch, 0, 0);
		}
		if (flRoll > 0)
		{
			sDump = format("SpawnTrigger(\"trigger_area\", Vector(%.03f, %.03f, %.03f), Vector(%.03f, %.03f, %.03f), Vector());", vecPos.x, vecPos.y, vecPos.z, flPitch, flYaw, flRoll);
			sayf("Result:\n%s", sDump);
		}
		else
		{
			sDump = format("SpawnTrigger(\"trigger_area\", Vector(%.03f, %.03f, %.03f), Vector(%.03f, %.03f, 0.000), Vector(0.000, 0.000, %.03f));", vecPos.x, vecPos.y, vecPos.z, flPitch, flYaw, flRoll);
			sayf("Result:\n%s", sDump);
		}
		g_sTriggersDump += sDump + "\n";
		EmitSoundOnClient("Buttons.snd4", hPlayer);
		g_aTriggerPoints[0] = null;
		g_aTriggerPoints[1] = null;
	}
}

function DumpTriggersToFile()
{
	local hPlayer = GetHostPlayer();
	if (hPlayer && g_bTriggerEditor && g_sTriggersDump != "")
	{
		StringToFile(__MAIN_PATH__ + "triggers_dump.nut", g_sTriggersDump);
		EmitSoundOn("Buttons.snd4", hPlayer);
		g_sTriggersDump = "";
	}
}

function DisplayTrigger()
{
	if (!g_bTriggerEditor) return;
	local hPlayer = GetHostPlayer();
	if (hPlayer)
	{
		if (g_aTriggerPoints[0])
		{
			local vecPos = g_aTriggerPoints[0];
			local _vecPos = (g_aTriggerPoints[1] != null ? g_aTriggerPoints[1] : hPlayer.GetOrigin());
			local flPitch = _vecPos.x - g_aTriggerPoints[0].x;
			local flYaw = _vecPos.y - g_aTriggerPoints[0].y;
			local flRoll = _vecPos.z - g_aTriggerPoints[0].z;
			if (flPitch < 0 && flYaw < 0)
			{
				flPitch *= -1;
				flYaw *= -1;
				vecPos -= Vector(flPitch, flYaw, 0);
			}
			else if (flPitch > 0 && flYaw < 0)
			{
				flYaw *= -1;
				vecPos -= Vector(0, flYaw, 0);
			}
			else if (flPitch < 0 && flYaw > 0)
			{
				flPitch *= -1;
				vecPos -= Vector(flPitch, 0, 0);
			}
			DebugDrawClear();
			DebugDrawBox(vecPos, Vector(flPitch, flYaw, flRoll), Vector(), 232, 0, 232, 100, 1e6);
			return;
		}
		DebugDrawClear();
	}
}