// Squirrel
// Auto Spitterboost
// Powered by AP

if (!("g_bAutoSB" in this)) g_bAutoSB <- array(MAXCLIENTS + 1, false);
if (!("g_flFactor" in this)) g_flFactor <- array(MAXCLIENTS + 1, 0.95);

tAutoSB <-
{
	OnPlayerDisconnect = function(tParams)
	{
		if (tParams["_player"])
		{
			g_bAutoSB[tParams["_player"].GetEntityIndex()] = false;
			g_flFactor[tParams["_player"].GetEntityIndex()] = 0.95;
		}
	}
	OnAbilityActivation = function(hSpitter, hPlayer)
	{
		if (hPlayer)
		{
			if (g_bAutoSB[hPlayer.GetEntityIndex()] && hPlayer.IsAlive() && !hPlayer.IsIncapacitated() && NetProps.GetPropEntity(hPlayer, "m_hGroundEntity"))
			{
				if (!NetProps.GetPropInt(hPlayer, "m_Local.m_bDucked") && !NetProps.GetPropInt(hPlayer, "m_Local.m_bDucking"))
				{
					if (NetProps.GetPropInt(hPlayer, "m_MoveType") == MOVETYPE_WALK && hPlayer.GetVelocity().LengthSqr() < 100 && hPlayer.GetOrigin().z - 5 > hSpitter.GetOrigin().z)
					{
						local flDistance = (hPlayer.GetOrigin() - (hSpitter.EyePosition() + (hPlayer.GetOrigin() - hSpitter.GetOrigin()).Normalize() * 24)).Length();
						local flJumpTime = 0.333374 + (flDistance / 900) - (0.63333 * g_flFactor[hPlayer.GetEntityIndex()]);
						if (flJumpTime >= 0)
						{
							SetScriptScopeVar(hSpitter, "__autosb_params__", {
								target = hPlayer
								spitter = hSpitter.GetEntityIndex()
								distance = flDistance
								jumptime = flJumpTime
								timer = CreateTimer(flJumpTime, function(hPlayer){
									if (hPlayer.IsValid()) hPlayer.SendInput(IN_JUMP);
								}, hPlayer)
							});
						}
					}
				}
			}
		}
	}
	bAbilityHasBeenActivated = array(MAXCLIENTS + 1, false)
	flAbilityActivationTime = array(MAXCLIENTS + 1, 0.0)
};

function AutoSB_Think()
{
	local hEntity;
	while (hEntity = Entities.FindByClassname(hEntity, "ability_spit"))
	{
		local hOwner = NetProps.GetPropEntity(hEntity, "m_hOwnerEntity");
		if (hOwner)
		{
			if (IsPlayerABot(hOwner))
			{
				local idx = hOwner.GetEntityIndex();
				if (NetProps.GetPropInt(hEntity, "m_bHasBeenActivated"))
				{
					if (!tAutoSB["bAbilityHasBeenActivated"][idx])
					{
						tAutoSB["bAbilityHasBeenActivated"][idx] = true;
						tAutoSB["flAbilityActivationTime"][idx] = Time();
						tAutoSB["OnAbilityActivation"](hOwner, NetProps.GetPropEntity(hOwner, "m_lookatPlayer"));
					}
				}
				else if (tAutoSB["bAbilityHasBeenActivated"][idx])
				{
					tAutoSB["bAbilityHasBeenActivated"][idx] = false;
				}
			}
		}
	}
	while (hEntity = Entities.FindByClassname(hEntity, "spitter_projectile"))
	{
		local hOwner = NetProps.GetPropEntity(hEntity, "m_hThrower");
		if (hOwner)
		{
			if (IsPlayerABot(hOwner))
			{
				local tParams;
				if (!KeyInScriptScope(hEntity, "spawned"))
				{
					if (KeyInScriptScope(hOwner, "__autosb_params__"))
					{
						local flDifference = Time() - tAutoSB["flAbilityActivationTime"][hOwner.GetEntityIndex()] - 0.333374;
						tParams = GetScriptScopeVar(hOwner, "__autosb_params__");
						tParams["jumptime"] += flDifference;
						tParams["timer"].m_flCallTime += flDifference;
						SetScriptScopeVar(hEntity, "__autosb_params__", tParams);
						RemoveScriptScopeKey(hOwner, "__autosb_params__")
					}
					SetScriptScopeVar(hEntity, "spawned", true);
				}
				if (KeyInScriptScope(hEntity, "__autosb_params__"))
				{
					tParams = GetScriptScopeVar(hEntity, "__autosb_params__");
					if (tParams["target"].IsValid())
					{
						if (NetProps.GetPropEntity(tParams["target"], "m_hGroundEntity") == hEntity)
						{
							if (!NetProps.GetPropVector(tParams["target"], "m_vecBaseVelocity").IsZero())
							{
								local flGainedSpeed = NetProps.GetPropVector(tParams["target"], "m_vecBaseVelocity").Length();
								local flGainedSpeed2D = NetProps.GetPropVector(tParams["target"], "m_vecBaseVelocity").Length2D();
								printl("-------- Auto Spitterboost --------");
								printf("Player (idx): %d\nSpitter (idx): %d\nJump time: %.03f\nDistance: %.03f\nGained speed: %.03f\nGained speed 2D: %.03f",
									tParams["target"].GetEntityIndex(),
									tParams["spitter"],
									tParams["jumptime"],
									tParams["distance"],
									flGainedSpeed,
									flGainedSpeed2D);
								printl("-----------------------------------");
								if ("OnSpitterBoostCompleted" in getroottable())
									::OnSpitterBoostCompleted(tParams["target"], PlayerInstanceFromIndex(tParams["spitter"]), flGainedSpeed, flGainedSpeed2D);
								RemoveScriptScopeKey(hEntity, "__autosb_params__");
							}
						}
					}
					else RemoveScriptScopeKey(hEntity, "__autosb_params__");
				}
			}
		}
	}
}

function SwitchAutoSB_Cmd(hPlayer)
{
	local idx = hPlayer.GetEntityIndex();
	g_bAutoSB[idx] ? EmitSoundOnClient("Buttons.snd11", hPlayer) : EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
	g_bAutoSB[idx] = !g_bAutoSB[idx];
}

function ChangeFactor_Cmd(hPlayer, sValue)
{
	if (sValue != CMD_EMPTY_ARGUMENT)
	{
		sValue = split(sValue, " ")[0];
		try {sValue = sValue.tofloat()}
		catch (error) {return};
		if (sValue > 0 && sValue < 2)
		{
			g_flFactor[hPlayer.GetEntityIndex()] = sValue;
			EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
		}
	}
}

function SwitchAutoSB(hPlayer)
{
	local idx = hPlayer.GetEntityIndex();
	sayf("[AutoSB] %s for %s", (g_bAutoSB[idx] ? "Disabled" : "Enabled"), hPlayer.GetPlayerName());
	g_bAutoSB[idx] = !g_bAutoSB[idx];
}

function ChangeAutoSBFactor(hPlayer, flFactor)
{
	if (typeof flFactor == "integer" || typeof flFactor == "float")
	{
		if (flFactor > 0 && flFactor < 2)
		{
			g_flFactor[hPlayer.GetEntityIndex()] = flFactor;
		}
	}
}

RegisterOnTickFunction("AutoSB_Think");

RegisterChatCommand("!autosb", SwitchAutoSB_Cmd, true);
RegisterChatCommand("!factor", ChangeFactor_Cmd, true, true);

HookEvent("player_disconnect", tAutoSB.OnPlayerDisconnect, tAutoSB);

printl("[AutoSB] Successfully executed");
