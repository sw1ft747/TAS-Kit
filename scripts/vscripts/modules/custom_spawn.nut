// Squirrel
// Custom CI Spawn for Finales
// Powered by AP

CustomSpawn <-
{
	aPanicTime = []
	aPauseTime = []
	aSpawnPoints = []
	aPanicSpawnPoints = []
	aPauseSpawnPoints = []

	iTankCount = 0
	iPanicNum = 0
	iPauseNum = 0

	flPanicTime = 0.0
	flPauseTime = 0.0

	bPanicStageStarted = false
	bPauseStageStarted = false

	hTriggerFinale = Entities.FindByClassname(null, "trigger_finale")

	Settings =
	{
		Enabled = false
		ChangePosition = true
		MaxTanksInFinale = 2
		PanicMinSpawnTime = 3.066666
		PauseMinSpawnTime = 7.066666
	}

	OnGameEvent_player_incapacitated = function(tParams)
	{
		if (tScriptedTankSpawn["bFinaleStarted"])
		{
			local hPlayer = GetPlayerFromUserID(tParams["userid"]);
			if (hPlayer && hPlayer.GetZombieType() == ZOMBIE_TANK)
			{
				if (CustomSpawn.iTankCount <= CustomSpawn.Settings.MaxTanksInFinale)
				{
					if (CustomSpawn.Settings.Enabled && CustomSpawn.iTankCount == CustomSpawn.Settings.MaxTanksInFinale)
					{
						local flTime = 0.0;

						foreach (time in CustomSpawn.aPanicTime)
						{
							local flTimeTemp = time - CustomSpawn.Settings.PanicMinSpawnTime;
							if (flTimeTemp > 0) flTime += time - CustomSpawn.Settings.PanicMinSpawnTime;
						}
						
						foreach (time in CustomSpawn.aPauseTime)
						{
							local flTimeTemp = time - CustomSpawn.Settings.PauseMinSpawnTime;
							if (flTimeTemp > 0) flTime += time - CustomSpawn.Settings.PauseMinSpawnTime;
						}
						
						SayMsg("Total loss time: " + flTime);

						if ("OnLastTankKilled" in ::Callbacks)
							::Callbacks.OnLastTankKilled();
					}
					sayf("Tank #%d died at time: %f", CustomSpawn.iTankCount, Time() - g_flFinaleStartTime);
				}
			}
		}
	}
};

function CustomSpawn::CalculatePointsWithinCircle(vecPos, flRadius, iPoints)
{
	local aPoints = [];

	for (local i = 0; i < iPoints; i++)
	{
		local flRandom = RandomFloat(0, 2 * PI);
		aPoints.push(vecPos + Vector(cos(flRandom), sin(flRandom), 0) * RandomFloat(0, flRadius));
	}

	return aPoints;
}

function CustomSpawn::CalculatePointsByLinearDirection(vecStart, vecEnd, iPoints, flMinAmplitude = 0.0, flMaxAmplitude = 0.0, bIncludeInitialVectors = true)
{
	local bAmplitude = false;

	if (flMinAmplitude != 0.0 && flMaxAmplitude != 0.0)
	{
		bAmplitude = true;
	}
	
	local vecSide;
	local vecDirection = vecEnd - vecStart;
	local vecDelta = Vector(vecDirection.x, vecDirection.y, vecDirection.z) / iPoints;
	local vecPos = vecStart;
	local aPoints = [];

	local function GetRandomVectorAmplitude()
	{
		return vecSide * RandomFloat(flMinAmplitude, flMaxAmplitude);
	}

	if (bAmplitude)
	{
		local vecNorm = vecDirection.Scale(1.0 / vecDirection.Length());
		vecSide = Vector(vecNorm.y, -vecNorm.x, vecNorm.z);
	}

	for (local i = 0; i < iPoints - 1; i++)
	{
		vecPos += vecDelta;
		if (bAmplitude)
		{
			aPoints.push(vecPos + GetRandomVectorAmplitude());
			continue;
		}
		aPoints.push(vecPos);
	}

	if (bIncludeInitialVectors)
	{
		if (bAmplitude)
		{
			vecStart += GetRandomVectorAmplitude();
			vecEnd += GetRandomVectorAmplitude();
		}

		aPoints.insert(0, vecStart);
		aPoints.push(vecEnd);
	}

	return aPoints;
}

function CustomSpawn::SetCommonPosition(hEntity, vecPos)
{
	NetProps.SetPropInt(hEntity, "m_nRenderFX", 15);
	hEntity.SetOrigin(vecPos);
	CreateTimer(0.1, function(hEntity){
		if (hEntity.IsValid()) NetProps.SetPropInt(hEntity, "m_nRenderFX", 16);
	}, hEntity);
}

function CustomSpawn::Think()
{
	if (CustomSpawn.Settings.Enabled)
	{
		local hEntity;
		local iCount = 0;
		while (hEntity = Entities.FindByClassname(hEntity, "infected"))
		{
			if (!KeyInScriptScope(hEntity, "spawned"))
			{
				iCount++;
				SetScriptScopeVar(hEntity, "spawned", true);
				if (CustomSpawn.aSpawnPoints.len() > 0 && !KeyInScriptScope(hEntity, "not_finale_ci"))
				{
					if (CustomSpawn.Settings.ChangePosition)
					{
						CustomSpawn.SetCommonPosition(hEntity, CustomSpawn.aSpawnPoints[RandomInt(0, CustomSpawn.aSpawnPoints.len() - 1)]);
						continue;
					}

					SetScriptScopeVar(SpawnZombie("infected", CustomSpawn.aSpawnPoints[RandomInt(0, CustomSpawn.aSpawnPoints.len() - 1)], null, false, true), "spawned", true);
					hEntity.Kill();
				}
			}
		}
		if (iCount > 0)
		{
			if (CustomSpawn.bPanicStageStarted)
			{
				local flTime = Time() - CustomSpawn.flPanicTime;
				CustomSpawn.bPanicStageStarted = false;
				CustomSpawn.aPanicTime.push(flTime);
				sayf("The wave spawned at time: %f (target: %f s)", flTime, CustomSpawn.Settings.PanicMinSpawnTime); // 3.066666 - 6.066666 => 2 ticks * framerate + RandomFloat(1.0, 2.0) + RandomFloat(2.0, 4.0)
			}
			else if (CustomSpawn.bPauseStageStarted)
			{
				local flTime = Time() - CustomSpawn.flPauseTime;
				CustomSpawn.bPauseStageStarted = false;
				CustomSpawn.aPauseTime.push(flTime);
				sayf("The wave spawned at time: %f (target: %f s)", flTime, CustomSpawn.Settings.PauseMinSpawnTime); // 7.066666 - 11.066666 => 2 ticks * framerate + RandomFloat(5.0, 7.0) + RandomFloat(2.0, 4.0)
			}
		}
	}
}

function CustomSpawn::OnBeginCustomStage(iNum, iType)
{
	if ("OnBeginCustomStage" in ::Callbacks)
		::Callbacks.OnBeginCustomStage(iNum, iType);

	if (!CustomSpawn.Settings.Enabled)
		return;

	local PANIC = 0;
	local TANK = 1;
	local DELAY = 2;

	CustomSpawn.aSpawnPoints.clear();

	if (iType == PANIC)
	{
		CustomSpawn.iPanicNum++;
		CustomSpawn.flPanicTime = Time();
		CustomSpawn.bPanicStageStarted = true;
		if (CustomSpawn.iPanicNum == 1)
		{
			local hEntity;
			while (hEntity = Entities.FindByClassname(hEntity, "infected"))
			{
				if (!KeyInScriptScope(hEntity, "not_finale_ci"))
				{
					SetScriptScopeVar(hEntity, "not_finale_ci", true);
				}
			}
		}
		if (CustomSpawn.aPanicSpawnPoints.len() > 0)
		{
			CustomSpawn.aSpawnPoints.extend(CustomSpawn.aPanicSpawnPoints[0]);
			CustomSpawn.aPanicSpawnPoints.remove(0);
		}
		sayf("PANIC #%d at time: %f", CustomSpawn.iPanicNum, Time() - g_flFinaleStartTime);
		return;
	}

	if (iType == DELAY && CustomSpawn.iTankCount >= CustomSpawn.Settings.MaxTanksInFinale)
	{
		if (IsOnTickFunctionRegistered("CustomSpawn.Think"))
			RemoveOnTickFunction("CustomSpawn.Think");
	}

	sayf("%s #%d at time: %f", (iType == PANIC ? "PANIC" : iType == TANK ? "TANK" : iType == DELAY ? "DELAY" : "UNKNOWN"), iNum, Time() - g_flFinaleStartTime);
}

function CustomSpawn::OnFinalePause()
{
	if (CustomSpawn.Settings.Enabled)
	{
		CustomSpawn.iPauseNum++;
		CustomSpawn.flPauseTime = Time();
		CustomSpawn.aSpawnPoints.clear();
		CustomSpawn.bPauseStageStarted = true;

		if (CustomSpawn.aPauseSpawnPoints.len() > 0)
		{
			CustomSpawn.aSpawnPoints.extend(CustomSpawn.aPauseSpawnPoints[0]);
			CustomSpawn.aPauseSpawnPoints.remove(0);
		}

		if ("OnFinalePause" in ::Callbacks)
			::Callbacks.OnFinalePause();

		sayf("PAUSE #%d at time: %f", CustomSpawn.iPauseNum, Time() - g_flFinaleStartTime);
	}
}

function CustomSpawn::OnFinaleEscapeStarted()
{
	if (CustomSpawn.Settings.Enabled)
		SayMsg("Finale escape started: " + (Time() - g_flFinaleStartTime));
}

if (CustomSpawn.hTriggerFinale)
{
	CustomSpawn.hTriggerFinale.__KeyValueFromString("FinalePause", "!caller,RunScriptCode,CustomSpawn.OnFinalePause()");
	CustomSpawn.hTriggerFinale.__KeyValueFromString("FinaleEscapeStarted", "!caller,RunScriptCode,CustomSpawn.OnFinaleEscapeStarted()");
}

__CollectEventCallbacks(CustomSpawn, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);

printl("[Custom Spawn] Successfully executed");
