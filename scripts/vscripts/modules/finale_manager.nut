// Squirrel
// Finale Manager
// Powered by AP

FinaleManager <-
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

	HookTriggerFinale = function()
	{
		FinaleManager.hTriggerFinale.__KeyValueFromString("FinalePause", "!caller,RunScriptCode,FinaleManager.OnFinalePause()");
		FinaleManager.hTriggerFinale.__KeyValueFromString("FinaleEscapeStarted", "!caller,RunScriptCode,FinaleManager.OnFinaleEscapeStarted()");
	}

	OnGameEvent_player_incapacitated = function(tParams)
	{
		if (tScriptedTankSpawn["bFinaleStarted"])
		{
			local hPlayer = GetPlayerFromUserID(tParams["userid"]);
			if (hPlayer && hPlayer.GetZombieType() == ZOMBIE_TANK)
			{
				if (FinaleManager.iTankCount <= FinaleManager.Settings.MaxTanksInFinale)
				{
					if (FinaleManager.Settings.Enabled && FinaleManager.iTankCount == FinaleManager.Settings.MaxTanksInFinale)
					{
						local flTime = 0.0;

						foreach (time in FinaleManager.aPanicTime)
						{
							local flTimeTemp = time - FinaleManager.Settings.PanicMinSpawnTime;
							if (flTimeTemp > 0) flTime += time - FinaleManager.Settings.PanicMinSpawnTime;
						}
						
						foreach (time in FinaleManager.aPauseTime)
						{
							local flTimeTemp = time - FinaleManager.Settings.PauseMinSpawnTime;
							if (flTimeTemp > 0) flTime += time - FinaleManager.Settings.PauseMinSpawnTime;
						}
						
						SayMsg("Total loss time: " + flTime);

						if ("OnLastTankKilled" in ::Callbacks)
							::Callbacks.OnLastTankKilled();
					}
					sayf("Tank #%d died at time: %f", FinaleManager.iTankCount, Time() - g_flFinaleStartTime);
				}
			}
		}
	}
};

function FinaleManager::CalculatePointsWithinCircle(vecPos, flRadius, iPoints)
{
	local aPoints = [];

	for (local i = 0; i < iPoints; i++)
	{
		local flRandom = RandomFloat(0, 2 * PI);
		aPoints.push(vecPos + Vector(cos(flRandom), sin(flRandom), 0) * RandomFloat(0, flRadius));
	}

	return aPoints;
}

function FinaleManager::CalculatePointsByLinearDirection(vecStart, vecEnd, iPoints, flMinAmplitude = 0.0, flMaxAmplitude = 0.0, bIncludeInitialVectors = true)
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

function FinaleManager::SetCommonPosition(hEntity, vecPos)
{
	NetProps.SetPropInt(hEntity, "m_nRenderFX", 15); // temporarily invisible state because CI's teleporting interpolatively 
	hEntity.SetOrigin(vecPos);
	CreateTimer(0.1, function(hEntity){
		if (hEntity.IsValid()) NetProps.SetPropInt(hEntity, "m_nRenderFX", 16);
	}, hEntity);
}

function FinaleManager::Think()
{
	if (FinaleManager.Settings.Enabled)
	{
		local hEntity;
		local iCount = 0;
		while (hEntity = Entities.FindByClassname(hEntity, "infected"))
		{
			if (!KeyInScriptScope(hEntity, "spawned"))
			{
				iCount++;
				SetScriptScopeVar(hEntity, "spawned", true);

				if (FinaleManager.aSpawnPoints.len() > 0 && !KeyInScriptScope(hEntity, "not_finale_ci"))
				{
					if (FinaleManager.Settings.ChangePosition)
					{
						FinaleManager.SetCommonPosition(hEntity, FinaleManager.aSpawnPoints[RandomInt(0, FinaleManager.aSpawnPoints.len() - 1)]);
						continue;
					}

					SetScriptScopeVar(SpawnZombie("infected", FinaleManager.aSpawnPoints[RandomInt(0, FinaleManager.aSpawnPoints.len() - 1)], null, false, true), "spawned", true);
					hEntity.Kill();
				}
			}
		}
		if (iCount > 0)
		{
			if (FinaleManager.bPanicStageStarted)
			{
				local flTime = Time() - FinaleManager.flPanicTime;

				FinaleManager.bPanicStageStarted = false;
				FinaleManager.aPanicTime.push(flTime);

				sayf("The wave spawned at time: %f (target: %f s)", flTime, FinaleManager.Settings.PanicMinSpawnTime); // 3.066666 - 6.066666 => 2 ticks * framerate + RandomFloat(1.0, 2.0) + RandomFloat(2.0, 4.0)
			}
			else if (FinaleManager.bPauseStageStarted)
			{
				local flTime = Time() - FinaleManager.flPauseTime;

				FinaleManager.bPauseStageStarted = false;
				FinaleManager.aPauseTime.push(flTime);

				sayf("The wave spawned at time: %f (target: %f s)", flTime, FinaleManager.Settings.PauseMinSpawnTime); // 7.066666 - 11.066666 => 2 ticks * framerate + RandomFloat(5.0, 7.0) + RandomFloat(2.0, 4.0)
			}
		}
	}
}

function FinaleManager::OnBeginCustomStage(iNum, iType)
{
	if ("OnBeginCustomStage" in ::Callbacks)
		::Callbacks.OnBeginCustomStage(iNum, iType);

	if (!FinaleManager.Settings.Enabled)
		return;

	local PANIC = 0;
	local TANK = 1;
	local DELAY = 2;
	local SCRIPTED = 3;

	FinaleManager.aSpawnPoints.clear();

	if (iType == PANIC)
	{
		FinaleManager.iPanicNum++;
		FinaleManager.flPanicTime = Time();
		FinaleManager.bPanicStageStarted = true;

		if (FinaleManager.iPanicNum == 1)
		{
			local hEntity;
			while (hEntity = Entities.FindByClassname(hEntity, "infected"))
			{
				if (!KeyInScriptScope(hEntity, "not_finale_ci"))
					SetScriptScopeVar(hEntity, "not_finale_ci", true);
			}
		}

		if (FinaleManager.aPanicSpawnPoints.len() > 0)
		{
			FinaleManager.aSpawnPoints.extend(FinaleManager.aPanicSpawnPoints[0]);
			FinaleManager.aPanicSpawnPoints.remove(0);
		}

		sayf("PANIC #%d at time: %f", FinaleManager.iPanicNum, Time() - g_flFinaleStartTime);
		return;
	}

	if (iType == DELAY && FinaleManager.iTankCount >= FinaleManager.Settings.MaxTanksInFinale)
	{
		if (IsOnTickFunctionRegistered("FinaleManager.Think"))
			RemoveOnTickFunction("FinaleManager.Think");
	}

	sayf("%s #%d at time: %f", (iType == PANIC ? "PANIC" : iType == TANK ? "TANK" : iType == DELAY ? "DELAY" : iType == SCRIPTED ? "SCRIPTED" : "ERROR"), iNum, Time() - g_flFinaleStartTime);
}

function FinaleManager::OnFinalePause()
{
	if (FinaleManager.Settings.Enabled)
	{
		FinaleManager.iPauseNum++;
		FinaleManager.flPauseTime = Time();
		FinaleManager.aSpawnPoints.clear();
		FinaleManager.bPauseStageStarted = true;

		if (FinaleManager.aPauseSpawnPoints.len() > 0)
		{
			FinaleManager.aSpawnPoints.extend(FinaleManager.aPauseSpawnPoints[0]);
			FinaleManager.aPauseSpawnPoints.remove(0);
		}

		if ("OnFinalePause" in ::Callbacks)
			::Callbacks.OnFinalePause();

		sayf("PAUSE #%d at time: %f", FinaleManager.iPauseNum, Time() - g_flFinaleStartTime);
	}
}

function FinaleManager::OnFinaleEscapeStarted()
{
	if (FinaleManager.Settings.Enabled)
		SayMsg("Finale escape started: " + (Time() - g_flFinaleStartTime));
}

if (FinaleManager.hTriggerFinale) FinaleManager.HookTriggerFinale();

__CollectEventCallbacks(FinaleManager, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);

printl("[Custom Spawn] Successfully executed");