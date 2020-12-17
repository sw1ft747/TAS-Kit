// Squirrel
// Custom Spawn for finales
// Powered by AP

CustomSpawn <-
{
	aPanicTime = []
	aRelaxTime = []
	aSpawnPoints = []
	aPanicSpawnPoints = []
	aRelaxSpawnPoints = []

	iTankCount = 0
	iPanicNum = 0
	iRelaxNum = 0

	flPanicTime = 0.0
	flRelaxTime = 0.0

	bPanicStageStarted = false
	bRelaxStageStarted = false

	hTriggerFinale = Entities.FindByClassname(null, "trigger_finale")

	Settings =
	{
		Enabled = false
		MaxTanksInFinale = 2
		PanicMinSpawnTime = 3.133301
		RelaxMinSpawnTime = 7.133331
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
						foreach (time in CustomSpawn.aPanicTime) flTime += time - CustomSpawn.Settings.PanicMinSpawnTime;
						foreach (time in CustomSpawn.aRelaxTime) flTime += time - CustomSpawn.Settings.RelaxMinSpawnTime;
						SayMsg("Total loss time: " + flTime);
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
		if (hEntity.IsValid())
			NetProps.SetPropInt(hEntity, "m_nRenderFX", 16);
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
			hEntity.ValidateScriptScope();
			if (!("spawned" in hEntity.GetScriptScope()))
			{
				hEntity.GetScriptScope()["spawned"] <- true;
				if (CustomSpawn.aSpawnPoints.len() > 0)
				{
					if (!("not_finale_ci" in hEntity.GetScriptScope()))
					{
						CustomSpawn.SetCommonPosition(hEntity, CustomSpawn.aSpawnPoints[RandomInt(0, CustomSpawn.aSpawnPoints.len() - 1)]);
					}
				}
				iCount++;
			}
		}
		if (iCount > 0)
		{
			if (CustomSpawn.bPanicStageStarted)
			{
				local flTime = Time() - CustomSpawn.flPanicTime;
				CustomSpawn.bPanicStageStarted = false;
				CustomSpawn.aPanicTime.push(flTime);
				sayf("The wave spawned at time: %f (target: %f s)", flTime, CustomSpawn.Settings.PanicMinSpawnTime); // 3.133301 - 6.067383
			}
			else if (CustomSpawn.bRelaxStageStarted)
			{
				local flTime = Time() - CustomSpawn.flRelaxTime;
				CustomSpawn.bRelaxStageStarted = false;
				CustomSpawn.aRelaxTime.push(flTime);
				sayf("The wave spawned at time: %f (target: %f s)", flTime, CustomSpawn.Settings.RelaxMinSpawnTime); // 7.133331 - 11.067383
			}
		}
	}
}

function CustomSpawn::OnBeginCustomStage(iNum, iType)
{
	if ("OnBeginCustomStage" in getroottable())
		::OnBeginCustomStage(iNum, iType);

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
				hEntity.ValidateScriptScope();
				if (!("not_finale_ci" in hEntity.GetScriptScope()))
				{
					hEntity.GetScriptScope()["not_finale_ci"] <- true;
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
		CustomSpawn.iRelaxNum++;
		CustomSpawn.flRelaxTime = Time();
		CustomSpawn.aSpawnPoints.clear();
		CustomSpawn.bRelaxStageStarted = true;
		if (CustomSpawn.aRelaxSpawnPoints.len() > 0)
		{
			CustomSpawn.aSpawnPoints.extend(CustomSpawn.aRelaxSpawnPoints[0]);
			CustomSpawn.aRelaxSpawnPoints.remove(0);
		}
		sayf("RELAX #%d at time: %f", CustomSpawn.iRelaxNum, Time() - g_flFinaleStartTime);
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