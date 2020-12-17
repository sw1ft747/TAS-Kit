// Squirrel
// Fill Bot
// Powered by AP

g_bFillBot <- array(MAXCLIENTS + 1, false);

g_aFillBot_OnAdrenalineUse <- [];

function FillBot_Think(hPlayer)
{
	if (!hPlayer.IsValid())
	{
		RemoveOnTickFunction("FillBot", hPlayer);
	}
	else if (hPlayer.IsAlive() && !hPlayer.IsIncapacitated())
	{
		if (!hPlayer.GetActiveWeapon() || hPlayer.GetActiveWeapon().GetClassname() != "weapon_gascan")
		{
			local hEntity;
			if (hEntity = Entities.FindByClassnameNearest("weapon_gascan", hPlayer.EyePosition(), 105.495))
			{
				if (!NetProps.GetPropEntity(hEntity, "m_hOwnerEntity") && !NetProps.GetPropInt(hEntity, "m_bPerformingAction"))
				{
					TakeItem(hPlayer, hEntity, false);
				}
			}
		}
		else if (!CEntity(hPlayer).GetScriptScopeVar("is_pouring"))
		{
			local hEntity;
			if (hEntity = Entities.FindByClassnameNearest("point_prop_use_target", hPlayer.EyePosition(), 65))
			{
				if (!IsPropUseTargetUsed(hEntity))
				{
					hPlayer.SetForwardVector(hEntity.GetOrigin() - hPlayer.EyePosition());
					StartPouring(hPlayer);
				}
			}
		}
	}
}

function OnItemPickup(tParams)
{
	if (g_bFillBot[tParams["_player"].GetEntityIndex()])
	{
		if (tParams["item"] == "gascan")
		{
			local hEntity;
			if (hEntity = Entities.FindByClassnameNearest("point_prop_use_target", tParams["_player"].EyePosition(), 65))
			{
				if (!IsPropUseTargetUsed(hEntity))
				{
					tParams["_player"].SetForwardVector(hEntity.GetOrigin() - tParams["_player"].EyePosition());
					StartPouring(tParams["_player"]);
				}
			}
		}
	}
}

function OnAdrenalineUse(tParams)
{
	foreach (idx, player in g_aFillBot_OnAdrenalineUse)
	{
		if (tParams["_player"] == player)
		{
			SwitchFillBot(player);
			g_aFillBot_OnAdrenalineUse.remove(idx);
			break;
		}
	}
}

function OnGasCanPourCompleted(tParams)
{
	if (g_bFillBot[tParams["_player"].GetEntityIndex()])
		StopPouring(tParams["_player"]);
}

function OnGasCanPourInterrupted(tParams)
{
	if (g_bFillBot[tParams["_player"].GetEntityIndex()])
		StopPouring(tParams["_player"]);
}

function OnGasCanPourBlocked(tParams)
{
	if (g_bFillBot[tParams["_player"].GetEntityIndex()])
		StopPouring(tParams["_player"]);
}

function StartPouring(hPlayer)
{
	NetProps.SetPropInt(hPlayer, "m_afButtonForced", NetProps.GetPropInt(hPlayer, "m_afButtonForced") | IN_ATTACK);
	CEntity(hPlayer).SetScriptScopeVar("is_pouring", true);
}

function StopPouring(hPlayer)
{
	NetProps.SetPropInt(hPlayer, "m_afButtonForced", NetProps.GetPropInt(hPlayer, "m_afButtonForced") & ~IN_ATTACK);
	CEntity(hPlayer).SetScriptScopeVar("is_pouring", false);
}

function IsPropUseTargetUsed(hEntity)
{
	return NetProps.GetPropEntity(hEntity, "m_useActionOwner") ? true : false;
}

function ActivateFillBot_OnAdrenalineUse(hPlayer)
{
	foreach (idx, player in g_aFillBot_OnAdrenalineUse)
		if (hPlayer == player)
			return;

	g_aFillBot_OnAdrenalineUse.push(hPlayer);
	StopPouring(hPlayer);
}

function SwitchFillBot(hPlayer)
{
	if (IsOnTickFunctionRegistered("FillBot_Think", hPlayer))
	{
		g_bFillBot[hPlayer.GetEntityIndex()] = false;
		RemoveOnTickFunction("FillBot_Think", hPlayer);
		SayMsg("[FillBot] Disabled for " + hPlayer.GetPlayerName());
	}
	else
	{
		g_bFillBot[hPlayer.GetEntityIndex()] = true;
		RegisterOnTickFunction("FillBot_Think", hPlayer);
		SayMsg("[FillBot] Enabled for " + hPlayer.GetPlayerName());
	}
	StopPouring(hPlayer);
}

HookEvent("item_pickup", OnItemPickup);
HookEvent("adrenaline_used", OnAdrenalineUse);
HookEvent("gascan_pour_completed", OnGasCanPourCompleted);
HookEvent("gascan_pour_interrupted", OnGasCanPourInterrupted);
HookEvent("gascan_pour_blocked", OnGasCanPourBlocked);

RegisterChatCommand("!fillbot", SwitchFillBot, true);

printl("[FillBot] Successfully executed");