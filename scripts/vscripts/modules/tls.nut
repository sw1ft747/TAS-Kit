// Squirrel
// Totally Legit Scripts
// Powered by AP

enum eCanShoot
{
	False,
	Relatively,
	True
}

g_flAimbotDistance <- 3e3;
g_flAimbotDistanceSqr <- 9e6;
g_aPotentialTargets <- [];

if (!("g_bTLS" in this)) g_bTLS <- false;

if (!("g_iAimbotUsers" in this)) g_iAimbotUsers <- 0;
if (!("g_bHostAutoBhop" in this)) g_bHostAutoBhop <- false;
if (!("g_bAimbot" in this)) g_bAimbot <- array(MAXCLIENTS + 1, false);
if (!("g_bAimbot2" in this)) g_bAimbot2 <- array(MAXCLIENTS + 1, false);
if (!("g_bRagebot" in this)) g_bRagebot <- array(MAXCLIENTS + 1, false);
if (!("g_bAutoStrafer" in this)) g_bAutoStrafer <- array(MAXCLIENTS + 1, false);
if (!("g_bAutoBhop" in this)) g_bAutoBhop <- array(MAXCLIENTS + 1, true);

g_sAimbotProhibitedWeapon <-
[
	"weapon_melee"
	"weapon_pipe_bomb"
	"weapon_molotov"
	"weapon_vomitjar"
	"weapon_pain_pills"
	"weapon_adrenaline"
	"weapon_first_aid_kit"
	"weapon_defibrillator"
	"weapon_upgradepack_explosive"
	"weapon_upgradepack_incendiary"
	"weapon_fireworkcrate"
	"weapon_cola_bottles"
	"weapon_propanetank"
	"weapon_oxygentank"
	"weapon_gascan"
]

g_tAimbotScriptSoundsList <-
{
	aExceptions = ["weapon_pistol", "weapon_pistol_magnum", "weapon_grenade_launcher", "weapon_sniper_awp", "weapon_sniper_scout", "weapon_rifle_sg552", "weapon_smg_mp5"]

	weapon_smg = ["SMG.Fire", "SMG.FireIncendiary"]
	weapon_smg_silenced = ["SMG_Silenced.Fire", "SMG_Silenced.FireIncendiary"]

	weapon_pumpshotgun = ["Shotgun.Fire", "Shotgun.FireIncendiary"]
	weapon_shotgun_chrome = ["Shotgun_Chrome.Fire", "Shotgun_Chrome.FireIncendiary"]
	weapon_shotgun_spas = ["AutoShotgun_Spas.Fire", "AutoShotgun_Spas.FireIncendiary"]
	weapon_autoshotgun = ["AutoShotgun.Fire", "AutoShotgun.FireIncendiary"]

	weapon_rifle = ["Rifle.Fire", "Rifle.FireIncendiary"]
	weapon_rifle_ak47 = ["AK47.Fire", "AK47.FireIncendiary"]
	weapon_rifle_desert = ["Rifle_Desert.Fire", "Rifle_Desert.FireIncendiary"]
	weapon_rifle_m60 = ["M60.Fire", "M60.FireIncendiary"]

	weapon_hunting_rifle = ["HuntingRifle.Fire", "HuntingRifle.FireIncendiary"]
	weapon_sniper_military = ["Sniper_Military.Fire", "Sniper_Military.FireIncendiary"]

	weapon_pistol = ["Pistol_Silver.Fire", "Pistol.Fire", "Pistol.DualFire"]
	weapon_pistol_magnum = "Magnum.Fire"

	weapon_grenade_launcher = "GrenadeLauncher.Fire"

	weapon_sniper_awp = "Weapon_AWP.Single"
	weapon_sniper_scout = "Weapon_Scout.Single"
	weapon_rifle_sg552 = "Weapon_SG552.Single"
	weapon_smg_mp5 = "Weapon_MP5Navy.Single"
}

TLS <- {};

g_ConVar_Aimbot <- CreateConVar("tls_aimbot", 1, "integer", 0, 1);
g_ConVar_AimbotRadius <- CreateConVar("tls_aimbot_radius", g_flAimbotDistance, "float", 0);
g_ConVar_AimbotEmitSound <- CreateConVar("tls_aimbot_emit_shoot_sound", 1, "integer", 0, 1);
g_ConVar_AimbotNoDoTraceLine <- CreateConVar("tls_aimbot_ignore_obstacles", 0, "integer", 0, 1);
g_ConVar_AimAnyTime <- CreateConVar("tls_aim_anytime", 0, "integer", 0, 1);
g_ConVar_AimToHead <- CreateConVar("tls_aim_to_head", 1, "integer", 0, 1);
g_ConVar_Ragebot <- CreateConVar("tls_ragebot", 1, "integer", 0, 1);
g_ConVar_AutoStrafer <- CreateConVar("tls_autostrafer", 1, "integer", 0, 1);
g_ConVar_AutoStraferFactor <- CreateConVar("tls_autostrafer_factor", 0.75, "float", 0.01, 1);
g_ConVar_AutoBhop <- CreateConVar("tls_autobhop", 1, "integer", 0, 1);

function BitInMask(iBit, iMask, bReturnInt)
{
	if (iMask & iBit) return bReturnInt ? 1 : true;
	else return bReturnInt ? 0 : false;
}

function PrecacheScriptSounds(hPlayer)
{
	foreach (key, val in g_tAimbotScriptSoundsList)
	{
		if (key == "aExceptions")
		{
			continue;
		}
		if (typeof val == "array")
		{
			for (local i = 0; i < val.len(); i++)
			{
				hPlayer.PrecacheScriptSound(val[i]);
			}
		}
		else hPlayer.PrecacheScriptSound(val);
	}
	SetScriptScopeVar(hPlayer, "script_sounds_precached", true);
	printf("[TLS] Script sounds precached for player %s", hPlayer.GetPlayerName());
}

function EmitShootSound(hPlayer)
{
	local sSound;
	local hWeapon = hPlayer.GetActiveWeapon();
	local sClass = hWeapon.GetClassname();
	if (g_tAimbotScriptSoundsList.aExceptions.find(sClass))
	{
		if (sClass == "weapon_pistol")
		{
			local aSounds = g_tAimbotScriptSoundsList.rawget(sClass);
			if (NetProps.GetPropInt(hWeapon, "m_hasDualWeapons"))
			{
				sSound = ((NetProps.GetPropInt(hWeapon, "m_iClip1") % 2) ? aSounds[1] : aSounds[2])
			}
			else
			{
				sSound = aSounds[0];
			}
		}
		else
		{
			sSound = g_tAimbotScriptSoundsList.rawget(sClass);
		}
	}
	else
	{
		sSound = g_tAimbotScriptSoundsList.rawget(sClass)[BitInMask(UPGRADE_INCENDIARY_AMMO, NetProps.GetPropInt(hWeapon, "m_upgradeBitVec"), true)];
	}
	EmitSoundOnClient(sSound, hPlayer);
}

function IsPlayerUsingAimbot(hPlayer)
{
	if (GetConVarBool(g_ConVar_Aimbot) && g_bAimbot[hPlayer.GetEntityIndex()]) return true;
	return false;
}

function IsPlayerUsingRagebot(hPlayer)
{
	if (GetConVarBool(g_ConVar_Ragebot) && g_bRagebot[hPlayer.GetEntityIndex()]) return true;
	return false;
}

function IsPlayerCanSeeEntity(hPlayer, hTarget, vecPos)
{
	local hEntity = DoTraceLine(hPlayer.EyePosition(), (vecPos - hPlayer.EyePosition()).Normalize(), eTrace.Type_Hit, g_flAimbotDistance, eTrace.Mask_Shot, hPlayer);
	if (hEntity)
	{
		if (hEntity == hTarget || hEntity.GetRootMoveParent() == hTarget) return true;
		if (hEntity.IsPlayer() && hEntity.IsSurvivor() && hEntity.IsAttackedBySI() && hEntity.GetSIAttacker() == hTarget) return true;
	}
	return false;
}

function IsPlayerCanShoot(hPlayer, bIgnoreWeaponCondition)
{
	if (hPlayer.IsAlive() && !hPlayer.IsHangingFromLedge())
	{
		if (NetProps.GetPropInt(hPlayer, "m_MoveType") != MOVETYPE_LADDER)
		{
			local hWeapon = hPlayer.GetActiveWeapon();
			if (hWeapon)
			{
				if (g_sAimbotProhibitedWeapon.find(hWeapon.GetClassname()) == null)
				{
					if (NetProps.GetPropFloat(hWeapon, "m_flNextPrimaryAttack") - Time() < 0.2)
					{
						if (NetProps.GetPropInt(hWeapon, "m_iClip1") > 0)
						{
							return eCanShoot.True;
						}
					}
					if (bIgnoreWeaponCondition)
					{
						return eCanShoot.Relatively;
					}
				}
			}
		}
	}
	return eCanShoot.False;
}

function GetEntityPosition(hEntity, sClass)
{
	local vecPos;
	if (sClass == "player")
	{
		local iType = hEntity.GetZombieType();
		if (iType != ZOMBIE_TANK)
		{
			local bAimToHead = GetConVarBool(g_ConVar_AimToHead);
			switch (iType)
			{
			case ZOMBIE_SMOKER:
				vecPos = hEntity.GetBodyPosition(bAimToHead ? 1.15 : 0.95);
				break;

			case ZOMBIE_BOOMER:
				vecPos = hEntity.GetBodyPosition(bAimToHead ? 1.05 : 0.8);
				break;

			case ZOMBIE_HUNTER:
				vecPos = hEntity.GetBodyPosition(bAimToHead ? 0.85 : 0.7);
				break;

			case ZOMBIE_SPITTER:
				vecPos = hEntity.GetBodyPosition(bAimToHead ? 1.15 : 0.9);
				break;

			case ZOMBIE_CHARGER:
				if (NetProps.GetPropInt(NetProps.GetPropEntity(hEntity, "m_customAbility"), "m_isCharging")) vecPos = hEntity.GetBodyPosition(0.75);
				else vecPos = bAimToHead ? hEntity.EyePosition() : hEntity.GetBodyPosition(0.85);
				break;
			
			case ZOMBIE_JOCKEY:
				if (NetProps.GetPropEntity(hEntity, "m_jockeyVictim")) vecPos = hEntity.GetBodyPosition(1.3);
				else vecPos = hEntity.GetBodyPosition(bAimToHead ? 0.55 : 0.5);
				break;
			}
		}
		else
		{
			vecPos = hEntity.GetBodyPosition(0.8);
		}
	}
	else if (sClass == "infected" || sClass == "witch")
	{
		if (KeyInScriptScope(hEntity, "trace_hull"))
		{
			if (GetConVarBool(g_ConVar_AimToHead)) vecPos = GetScriptScopeVar(hEntity, "trace_hull").GetOrigin();
			else vecPos = hEntity.GetOrigin() + (GetScriptScopeVar(hEntity, "trace_hull").GetOrigin() - hEntity.GetOrigin()) * 0.8;
		}
	}
	return vecPos;
}

function GetNearestEntity(hPlayer)
{
	local idx = 0;
	local length = g_aPotentialTargets.len();
	local flDistanceSqr = g_flAimbotDistanceSqr;
	local vecPos, hTarget;

	while (idx < length)
	{
		local hEntity;
		if (hEntity = g_aPotentialTargets[idx])
		{
			try {
				if (hEntity.IsPlayer())
				{
					if (hEntity.IsIncapacitated() || hEntity.GetHealth() < 1)
					{
						g_aPotentialTargets.remove(idx);
						length--;
						continue;
					}
				}
				else if (hEntity.GetHealth() < 1)
				{
					g_aPotentialTargets.remove(idx);
					length--;
					continue;
				}
			}
			catch (error) {
				g_aPotentialTargets.remove(idx);
				length--;
				continue;
			}

			local flDistanceSqrTemp = (hEntity.GetOrigin() - hPlayer.EyePosition()).LengthSqr();
			if (flDistanceSqrTemp < flDistanceSqr)
			{
				local vecPosTemp = GetEntityPosition(hEntity, hEntity.GetClassname());
				if (vecPosTemp)
				{
					if (!GetConVarBool(g_ConVar_AimbotNoDoTraceLine))
					{
						if (!IsPlayerCanSeeEntity(hPlayer, hEntity, vecPosTemp))
						{
							idx++;
							continue;
						}
					}
					flDistanceSqr = flDistanceSqrTemp;
					hTarget = hEntity;
					vecPos = vecPosTemp;
				}
			}
		}
		idx++;
	}

	return {
		target = hTarget
		position = vecPos
	};
}

function SetAnglesToNearestEntity(hPlayer)
{
	local tParams = GetNearestEntity(hPlayer);
	if (tParams["target"])
	{
		if (tParams["target"].GetClassname() != "infected") tParams["position"] -= tParams["target"].GetVelocity() * (NetProps.GetPropFloat(hPlayer, "m_fLerpTime") * 1.25);
		hPlayer.SetForwardVector(tParams["position"] - hPlayer.EyePosition());
		return tParams["target"];
	}
	return null;
}

function OnAttackPress(hPlayer)
{
	if (g_bTLS && GetConVarBool(g_ConVar_Aimbot))
	{
		local idx = hPlayer.GetEntityIndex();
		if (g_bAimbot2[idx] && !g_bAimbot[idx] && !IsPlayerUsingRagebot(hPlayer))
		{
			if (IsPlayerCanShoot(hPlayer, GetConVarBool(g_ConVar_AimAnyTime)) > eCanShoot.False)
			{
				SetAnglesToNearestEntity(hPlayer);
			}
		}
	}
}

function OnAlt1Press(hPlayer)
{
	if (g_bHostAutoBhop)
	{
		if (hPlayer.IsHost())
		{
			if (hPlayer.IsAlive())
			{
				if (!NetProps.GetPropEntity(hPlayer, "m_hGroundEntity"))
				{
					if (NetProps.GetPropInt(hPlayer, "m_MoveType") != MOVETYPE_LADDER)
					{
						SendToConsole("-jump");
						return;
					}
				}
				SendToConsole("+jump");
				CreateTimer(0.01, function(hPlayer){
					if (!(hPlayer.GetButtonMask() & IN_ALT1)) SendToConsole("-jump");
				}, hPlayer);
			}
		}
	}
}

function OnAlt2Press(hPlayer)
{
	if (g_bTLS && GetConVarBool(g_ConVar_Aimbot))
	{
		if (g_bAimbot[hPlayer.GetEntityIndex()] && !IsPlayerUsingRagebot(hPlayer))
		{
			if (IsPlayerCanShoot(hPlayer, GetConVarBool(g_ConVar_AimAnyTime)) > eCanShoot.False)
			{
				SetAnglesToNearestEntity(hPlayer);
			}
			if (hPlayer.IsHost())
			{
				SendToConsole("+attack");
				CreateTimer(0.01, function(hPlayer){
					if (!(hPlayer.GetButtonMask() & IN_ALT2)) SendToConsole("-attack");
				}, hPlayer);
			}
			else
			{
				NetProps.SetPropInt(hPlayer, "m_afButtonForced", NetProps.GetPropInt(hPlayer, "m_afButtonForced") | IN_ATTACK);
				CreateTimer(0.01, function(hPlayer){
					if (!(hPlayer.GetButtonMask() & IN_ALT2)) NetProps.SetPropInt(hPlayer, "m_afButtonForced", NetProps.GetPropInt(hPlayer, "m_afButtonForced") & ~IN_ATTACK);
				}, hPlayer);
			}
		}
	}
}

function TLS::OnWeaponFire(tParams)
{
	if (g_bTLS && GetConVarBool(g_ConVar_AimbotEmitSound))
	{
		if (!tParams["_player"].IsHost())
		{
			if (IsPlayerUsingAimbot(tParams["_player"]) || IsPlayerUsingRagebot(tParams["_player"]))
			{
				EmitShootSound(tParams["_player"]);
			}
		}
	}
}

function TLS::OnPlayerFirstSpawn(tParams)
{
	if (!IsPlayerABot(tParams["_player"])) PrecacheScriptSounds(tParams["_player"]);
}

function TLS::OnPlayerDisconnect(tParams)
{
	if (tParams["_player"] && tParams["_player"].IsValid())
	{
		local idx = tParams["_player"].GetEntityIndex();
		if (g_bAimbot[idx] || g_bAimbot2[idx] || g_bRagebot[idx])
			g_iAimbotUsers--;
		g_bAimbot[idx] = false;
		g_bAimbot2[idx] = false;
		g_bRagebot[idx] = false;
		g_bAutoStrafer[idx] = false;
		g_bAutoBhop[idx] = true;
	}
}

function TLS::OnConVarAimbotRadiusChange(ConVar, LastValue, NewValue)
{
	g_flAimbotDistance = NewValue;
	g_flAimbotDistanceSqr = NewValue * NewValue;
}

function TLS_Think()
{
	if (!g_bTLS) return;

	local hEntity;
	local aSurvivors = [];
	local bRagebot = GetConVarBool(g_ConVar_Ragebot);
	local bAutoBhop = GetConVarBool(g_ConVar_AutoBhop);
	local bAutoStrafer = GetConVarBool(g_ConVar_AutoStrafer);
	local flFactor = GetConVarFloat(g_ConVar_AutoStraferFactor);

	if (g_iAimbotUsers > 0)
	{
		local trace_hull_ent;
		g_aPotentialTargets.clear();

		while (hEntity = Entities.FindByClassname(hEntity, "infected"))
		{
			if (hEntity.GetHealth() > 0 && NetProps.GetPropInt(hEntity, "movetype") != MOVETYPE_NONE)
			{
				if (KeyInScriptScope(hEntity, "trace_hull"))
				{
					g_aPotentialTargets.push(hEntity);
				}
				else
				{
					trace_hull_ent = SpawnEntityFromTable("info_target", {});
					AttachEntity(hEntity, trace_hull_ent, "head");
					SetScriptScopeVar(hEntity, "trace_hull", trace_hull_ent);
				}
			}
		}

		hEntity = null;
		while (hEntity = Entities.FindByClassname(hEntity, "witch"))
		{
			if (hEntity.GetHealth() > 0 && NetProps.GetPropFloat(hEntity, "m_rage") >= 1.0)
			{
				if (KeyInScriptScope(hEntity, "trace_hull"))
				{
					g_aPotentialTargets.push(hEntity);
				}
				else
				{
					trace_hull_ent = SpawnEntityFromTable("info_target", {});
					AttachEntity(hEntity, trace_hull_ent, "leye");
					SetScriptScopeVar(hEntity, "trace_hull", trace_hull_ent);
				}
			}
		}
	}

	hEntity = null;
	while (hEntity = Entities.FindByClassname(hEntity, "player"))
	{
		local idx = hEntity.GetEntityIndex();

		if (g_iAimbotUsers > 0)
		{
			if (hEntity.IsSurvivor())
			{
				aSurvivors.push(hEntity);
			}
			else if (!hEntity.IsIncapacitated() && NetProps.GetPropInt(hEntity, "m_iObserverMode") == 0 && !NetProps.GetPropInt(hEntity, "m_isGhost"))
			{
				g_aPotentialTargets.push(hEntity);
			}
		}

		if (bAutoBhop)
		{
			if (hEntity.IsAlive() && !hEntity.IsIncapacitated())
			{
				if (g_bAutoBhop[idx])
				{
					local buttons = NetProps.GetPropInt(hEntity, "m_afButtonDisabled");
					if (!NetProps.GetPropEntity(hEntity, "m_hGroundEntity") && NetProps.GetPropInt(hEntity, "m_MoveType") == MOVETYPE_WALK)
					{
						NetProps.SetPropInt(hEntity, "m_afButtonDisabled", buttons | IN_JUMP);
					}
					else
					{
						NetProps.SetPropInt(hEntity, "m_afButtonDisabled", buttons & ~IN_JUMP);
					}
				}
			}
		}

		if (bAutoStrafer && g_bAutoStrafer[idx])
		{
			if (!IsPlayerUsingAimbot(hEntity) && !g_bAimbot2[idx])
			{
				if (!(NetProps.GetPropInt(hEntity, "m_fFlags") & FL_ONGROUND) && NetProps.GetPropInt(hEntity, "m_MoveType") == MOVETYPE_WALK)
				{
					local vecVel = hEntity.GetVelocity();
					if (vecVel.x != 0 && vecVel.y != 0)
					{
						local eAngles = hEntity.EyeAngles();
						local flYaw = atan(vecVel.y / vecVel.x) * Math.Rad2Deg;
						if (vecVel.x < 0) flYaw += 180;
						eAngles.y += Math.NormalizeAngle((Math.NormalizeAngle(flYaw) - eAngles.y)) * flFactor;
						TP(hEntity, null, eAngles, null);
					}
				}
			}
		}
	}

	if (aSurvivors.len() > 0)
	{
		foreach (hPlayer in aSurvivors)
		{
			if (bRagebot && g_bRagebot[hPlayer.GetEntityIndex()])
			{
				local bHost = hPlayer.IsHost();
				local bCanShoot = IsPlayerCanShoot(hPlayer, GetConVarBool(g_ConVar_AimAnyTime));

				if (bCanShoot > eCanShoot.False)
				{
					if (SetAnglesToNearestEntity(hPlayer))
					{
						if (bCanShoot == eCanShoot.True)
						{
							if (bHost) SendToConsole("+attack");
							else NetProps.SetPropInt(hPlayer, "m_afButtonForced", NetProps.GetPropInt(hPlayer, "m_afButtonForced") | IN_ATTACK);
							continue;
						}
					}
				}

				if (bHost) SendToConsole("-attack");
				else NetProps.SetPropInt(hPlayer, "m_afButtonForced", NetProps.GetPropInt(hPlayer, "m_afButtonForced") & ~IN_ATTACK);
			}
		}
	}
}

function SwitchAutoBhop(hPlayer)
{
	if (GetConVarBool(g_ConVar_AutoBhop))
	{
		local idx = hPlayer.GetEntityIndex();
		if (g_bAutoBhop[idx]) NetProps.SetPropInt(hPlayer, "m_afButtonDisabled", NetProps.GetPropInt(hPlayer, "m_afButtonDisabled") & ~IN_JUMP);
		sayf("[Auto-Bunnyhop] %s for %s", (g_bAutoBhop[idx] ? "Disabled" : "Enabled"), hPlayer.GetPlayerName());
		g_bAutoBhop[idx] = !g_bAutoBhop[idx];
	}
}

function SwitchHostAutoBhop(hPlayer)
{
	if (hPlayer.IsHost())
	{
		if (g_bHostAutoBhop)
		{
			SendToConsole("-alt1;-jump");
			SendToConsole("bind SPACE +jump");
		}
		else
		{
			SendToConsole("alias +host_bhop \"+jump;+alt1\"");
			SendToConsole("alias -host_bhop \"-jump;-alt1\"");
			SendToConsole("bind SPACE +host_bhop");
		}
		sayf("[Host Auto-Bunnyhop] %s for %s", (g_bHostAutoBhop ? "Disabled" : "Enabled"), hPlayer.GetPlayerName());
		g_bHostAutoBhop = !g_bHostAutoBhop;
	}
}

function SwitchAimbot(hPlayer)
{
	if (GetConVarBool(g_ConVar_Aimbot) && hPlayer.IsSurvivor())
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
			g_iAimbotUsers--;
		}
		else
		{
			if (bHost) SendToConsole("bind MOUSE1 +alt2");
			g_iAimbotUsers++;
		}
		sayf("[Aimbot] %s for %s", (g_bAimbot[idx] ? "Disabled" : "Enabled"), hPlayer.GetPlayerName());
		g_bAimbot[idx] = !g_bAimbot[idx];
	}
}

function SwitchAimbot2(hPlayer)
{
	if (GetConVarBool(g_ConVar_Aimbot) && hPlayer.IsSurvivor())
	{
		local idx = hPlayer.GetEntityIndex();
		if (g_bAimbot2[idx]) g_iAimbotUsers--;
		else g_iAimbotUsers++;
		sayf("[Aimbot #2] %s for %s", (g_bAimbot2[idx] ? "Disabled" : "Enabled"), hPlayer.GetPlayerName());
		g_bAimbot2[idx] = !g_bAimbot2[idx];
	}
}

function SwitchRageBot(hPlayer)
{
	if (GetConVarBool(g_ConVar_Ragebot) && hPlayer.IsSurvivor())
	{
		local idx = hPlayer.GetEntityIndex();
		if (g_bRagebot[idx])
		{
			g_iAimbotUsers--;
			if (hPlayer.IsHost()) SendToConsole("-attack");
			else NetProps.SetPropInt(hPlayer, "m_afButtonDisabled", NetProps.GetPropInt(hPlayer, "m_afButtonDisabled") & ~IN_ATTACK);
		}
		else
		{
			g_iAimbotUsers++;
		}
		sayf("[Ragebot] %s for %s", (g_bRagebot[idx] ? "Disabled" : "Enabled"), hPlayer.GetPlayerName());
		g_bRagebot[idx] = !g_bRagebot[idx];
	}
}

function SwitchAutoStrafer(hPlayer)
{
	local idx = hPlayer.GetEntityIndex();
	sayf("[Auto-Strafer] %s for %s", (g_bAutoStrafer[idx] ? "Disabled" : "Enabled"), hPlayer.GetPlayerName());
	g_bAutoStrafer[idx] = !g_bAutoStrafer[idx];
}

function EnableAutoBhopForEveryone()
{
	if (GetConVarBool(g_ConVar_AutoBhop))
	{
		local hPlayer, idx;
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			idx = hPlayer.GetEntityIndex();
			if (!g_bAutoBhop[idx])
			{
				g_bAutoBhop[idx] = true;
			}
		}
		SayMsg("[Auto-Bunnyhop] Enabled for everyone");
	}
}

function DisableAutoBhopForEveryone()
{
	if (GetConVarBool(g_ConVar_AutoBhop))
	{
		local hPlayer, idx;
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			idx = hPlayer.GetEntityIndex();
			if (g_bAutoBhop[idx])
			{
				NetProps.SetPropInt(hPlayer, "m_afButtonDisabled", NetProps.GetPropInt(hPlayer, "m_afButtonDisabled") & ~IN_JUMP);
				g_bAutoBhop[idx] = false;
			}
		}
		SayMsg("[Auto-Bunnyhop] Disabled for everyone");
	}
}

function EnableAimbotForEveryone()
{
	if (GetConVarBool(g_ConVar_Aimbot))
	{
		local hPlayer, idx;
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			if (hPlayer.IsSurvivor())
			{
				if (!g_bAimbot[idx = hPlayer.GetEntityIndex()])
				{
					if (hPlayer.IsHost()) SendToConsole("bind MOUSE1 +alt2");
					g_iAimbotUsers++;
					g_bAimbot[idx] = true;
				}
			}
		}
		SayMsg("[Aimbot] Enabled for everyone");
	}
}

function DisableAimbotForEveryone()
{
	if (GetConVarBool(g_ConVar_Aimbot))
	{
		local hPlayer, idx;
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			if (hPlayer.IsSurvivor())
			{
				if (g_bAimbot[idx = hPlayer.GetEntityIndex()])
				{
					if (hPlayer.IsHost())
					{
						SendToConsole("-alt2;-attack");
						SendToConsole("bind MOUSE1 +attack");
					}
					g_iAimbotUsers--;
					g_bAimbot[idx] = false;
				}
			}
		}
		SayMsg("[Aimbot] Disabled for everyone");
	}
}

function EnableAimbot2ForEveryone()
{
	if (GetConVarBool(g_ConVar_Aimbot))
	{
		local hPlayer, idx;
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			if (hPlayer.IsSurvivor())
			{
				if (!g_bAimbot2[idx = hPlayer.GetEntityIndex()])
				{
					g_iAimbotUsers++;
					g_bAimbot2[idx] = true;
				}
			}
		}
		SayMsg("[Aimbot2] Enabled for everyone");
	}
}

function DisableAimbot2ForEveryone()
{
	if (GetConVarBool(g_ConVar_Aimbot))
	{
		local hPlayer, idx;
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			if (hPlayer.IsSurvivor())
			{
				if (g_bAimbot2[idx = hPlayer.GetEntityIndex()])
				{
					g_iAimbotUsers--;
					g_bAimbot2[idx] = false;
				}
			}
		}
		SayMsg("[Aimbot2] Disabled for everyone");
	}
}

function EnableRagebotForEveryone()
{
	if (GetConVarBool(g_ConVar_Ragebot))
	{
		local hPlayer, idx;
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			if (hPlayer.IsSurvivor())
			{
				if (!g_bRagebot[idx = hPlayer.GetEntityIndex()])
				{
					g_iAimbotUsers++;
					g_bRagebot[idx] = true;
				}
			}
		}
		SayMsg("[Ragebot] Enabled for everyone");
	}
}

function DisableRagebotForEveryone()
{
	if (GetConVarBool(g_ConVar_Ragebot))
	{
		local hPlayer, idx;
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			if (hPlayer.IsSurvivor())
			{
				if (g_bRagebot[idx = hPlayer.GetEntityIndex()])
				{
					if (hPlayer.IsHost()) SendToConsole("-attack");
					else NetProps.SetPropInt(hPlayer, "m_afButtonDisabled", NetProps.GetPropInt(hPlayer, "m_afButtonDisabled") & ~IN_ATTACK);
					g_iAimbotUsers--;
					g_bRagebot[idx] = false;
				}
			}
		}
		SayMsg("[Ragebot] Disabled for everyone");
	}
}

RegisterOnTickFunction("TLS_Think");

RegisterButtonListener(IN_ALT1, "OnAlt1Press", eButtonType.Hold, eTeam.Survivor);
RegisterButtonListener(IN_ALT2, "OnAlt2Press", eButtonType.Hold, eTeam.Survivor);
RegisterButtonListener(IN_ATTACK, "OnAttackPress", eButtonType.Hold, eTeam.Survivor);

HookEvent("weapon_fire", TLS.OnWeaponFire, TLS);
HookEvent("player_disconnect", TLS.OnPlayerDisconnect, TLS);
HookEvent("player_first_spawn", TLS.OnPlayerFirstSpawn, TLS);

g_ConVar_AimbotRadius.AddChangeHook(TLS.OnConVarAimbotRadiusChange);

printl("[TLS] Successfully executed");
