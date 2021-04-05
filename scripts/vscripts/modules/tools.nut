// Squirrel
// Main Tools
// Powered by AP

g_aBilesToProcess <- [];
g_aAutoRocketJumpUsers <- [];
g_aAutoBileBoostUsers <- [];
g_aAutoGrenadeBoostUsers <- [];

if (!("g_bAutoTake" in this))
{
	g_bAutoShove <- array(MAXCLIENTS + 1, true);
	g_bAutoClimb <- array(MAXCLIENTS + 1, true);
	g_iClimbDirection <- array(MAXCLIENTS + 1, 1);

	g_aPropPhysicsModels <-
	[
		"models/props_junk/gascan001a.mdl"
		"models/props_equipment/oxygentank01.mdl"
		"models/props_junk/propanecanister001a.mdl"
		"models/props_junk/explosive_box001.mdl"
		"models/w_models/weapons/w_cola.mdl"
		"models/props_junk/gnome.mdl"
	];

	g_aUseEntitiesList <-
	[
		"prop_door_rotating_checkpoint"
		"prop_door_rotating"
		"upgrade_laser_sight"
		"upgrade_ammo_explosive"
		"upgrade_ammo_incendiary"
		"func_button"
	];

	g_aPrimaryWeaponList <-
	[
		"weapon_shotgun_chrome"
		"weapon_pumpshotgun"
		"weapon_shotgun_spas"
		"weapon_autoshotgun"
		"weapon_smg"
		"weapon_smg_silenced"
		"weapon_rifle"
		"weapon_rifle_ak47"
		"weapon_rifle_desert"
		"weapon_hunting_rifle"
		"weapon_sniper_military"
		"weapon_rifle_m60"
		"weapon_grenade_launcher"
		"weapon_smg_mp5"
		"weapon_rifle_sg552"
		"weapon_sniper_scout"
		"weapon_sniper_awp"
	];

	g_tItems <-
	{
		"ammo" : {classname = "weapon_ammo_spawn", model = "models/props/terror/ammo_stack.mdl"}
		"ammo_l4d" : {classname = "weapon_ammo_spawn", model = "models/props_unique/spawn_apartment/coffeeammo.mdl"}
		"upgradepack_incendiary" : {classname = "weapon_upgradepack_incendiary_spawn", model = "models/w_models/weapons/w_eq_incendiary_ammopack.mdl"}
		"upgradepack_explosive" : {classname = "weapon_upgradepack_explosive_spawn", model = "models/w_models/weapons/w_eq_explosive_ammopack.mdl"}
		"upgrade_ammo_incendiary" : {classname = "upgrade_ammo_incendiary", model = "models/props/terror/incendiary_ammo.mdl"}
		"upgrade_ammo_explosive" : {classname = "upgrade_ammo_explosive", model = "models/props/terror/exploding_ammo.mdl"}
		"upgrade_laser_sight" : {classname = "upgrade_laser_sight", model = "models/w_models/Weapons/w_laser_sights.mdl"}
		"pistol" : {classname = "weapon_pistol_spawn", model = "models/w_models/weapons/w_pistol_B.mdl"}
		"pistol_magnum" : {classname = "weapon_pistol_magnum_spawn", model = "models/w_models/weapons/w_desert_eagle.mdl"}
		"adrenaline" : {classname = "weapon_adrenaline_spawn", model = "models/w_models/weapons/w_eq_adrenaline.mdl"}
		"pain_pills" : {classname = "weapon_pain_pills_spawn", model = "models/w_models/weapons/w_eq_painpills.mdl"}
		"vomitjar" : {classname = "weapon_vomitjar_spawn", model = "models/w_models/weapons/w_eq_bile_flask.mdl"}
		"pipe_bomb" : {classname = "weapon_pipe_bomb_spawn", model = "models/w_models/weapons/w_eq_pipebomb.mdl"}
		"molotov" : {classname = "weapon_molotov_spawn", model = "models/w_models/weapons/w_eq_molotov.mdl"}
		"defibrillator" : {classname = "weapon_defibrillator_spawn", model = "models/w_models/weapons/w_eq_defibrillator.mdl"}
		"first_aid_kit" : {classname = "weapon_first_aid_kit_spawn", model = "models/w_models/weapons/w_eq_Medkit.mdl"}
		"shotgun_chrome" : {classname = "weapon_shotgun_chrome_spawn", model = "models/w_models/weapons/w_pumpshotgun_A.mdl"}
		"pumpshotgun" : {classname = "weapon_pumpshotgun_spawn", model = "models/w_models/weapons/w_shotgun.mdl"}
		"shotgun_spas" : {classname = "weapon_shotgun_spas_spawn", model = "models/w_models/weapons/w_shotgun_spas.mdl"}
		"autoshotgun" : {classname = "weapon_autoshotgun_spawn", model = "models/w_models/weapons/w_autoshot_m4super.mdl"}
		"smg" : {classname = "weapon_smg_spawn", model = "models/w_models/weapons/w_smg_uzi.mdl"}
		"smg_silenced" : {classname = "weapon_smg_silenced_spawn", model = "models/w_models/weapons/w_smg_a.mdl"}
		"smg_mp5" : {classname = "weapon_smg_mp5", model = "models/w_models/weapons/w_smg_mp5.mdl"}
		"rifle" : {classname = "weapon_rifle_spawn", model = "models/w_models/weapons/w_rifle_m16a2.mdl"}
		"rifle_ak47" : {classname = "weapon_rifle_ak47_spawn", model = "models/w_models/weapons/w_rifle_ak47.mdl"}
		"rifle_desert" : {classname = "weapon_rifle_desert_spawn", model = "models/w_models/weapons/w_desert_rifle.mdl"}
		"rifle_sg552" : {classname = "weapon_rifle_sg552", model = "models/w_models/weapons/w_rifle_sg552.mdl"}
		"hunting_rifle" : {classname = "weapon_hunting_rifle_spawn", model = "models/w_models/weapons/w_sniper_mini14.mdl"}
		"sniper_military" : {classname = "weapon_sniper_military_spawn", model = "models/w_models/weapons/w_sniper_military.mdl"}
		"sniper_scout" : {classname = "weapon_sniper_scout", model = "models/w_models/weapons/w_sniper_scout.mdl"}
		"sniper_awp" : {classname = "weapon_sniper_awp", model = "models/w_models/weapons/w_sniper_awp.mdl"}
		"rifle_m60" : {classname = "weapon_rifle_m60_spawn", model = "models/w_models/weapons/w_m60.mdl"}
		"grenade_launcher" : {classname = "weapon_grenade_launcher_spawn", model = "models/w_models/weapons/w_grenade_launcher.mdl"}
		"chainsaw" : {classname = "weapon_chainsaw_spawn", model = "models/weapons/melee/w_chainsaw.mdl"}
		"gascan" : {classname = "prop_physics", model = "models/props_junk/gascan001a.mdl"}
		"propanetank" : {classname = "prop_physics", model = "models/props_junk/propanecanister001a.mdl"}
		"oxygentank" : {classname = "prop_physics", model = "models/props_equipment/oxygentank01.mdl"}
		"fireworkcrate" : {classname = "prop_physics", model = "models/props_junk/explosive_box001.mdl"}
		"cola_bottles" : {classname = "prop_physics", model = "models/w_models/weapons/w_cola.mdl"}
		"gascan_scavenge" : {classname = "weapon_scavenge_item_spawn", model = "models/props_junk/gascan001a.mdl"}
		"baseball_bat" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_bat.mdl"}
		"cricket_bat" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_cricket_bat.mdl"}
		"crowbar" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_crowbar.mdl"}
		"electric_guitar" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_electric_guitar.mdl"}
		"fireaxe" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_fireaxe.mdl"}
		"frying_pan" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_frying_pan.mdl"}
		"golfclub" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_golfclub.mdl"}
		"katana" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_katana.mdl"}
		"machete" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_machete.mdl"}
		"tonfa" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_tonfa.mdl"}
		"shovel" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_shovel.mdl"}
		"pitchfork" : {classname = "weapon_melee_spawn", model = "models/weapons/melee/w_pitchfork.mdl"}
		"knife" : {classname = "weapon_melee_spawn", model = "models/w_models/weapons/w_knife_t.mdl"}
	};

	g_tTransitionLandmarks <-
	{
		"c1m1_hotel" : [2136.000, 4472.000, 1248.000, 2504.000, 5128.000, 512.000]
		"c1m2_streets" : [-7456.000, -4688.000, 448.000, 6758.820, -1426.180, 88.000]
		"c1m3_mall" : [-2048.000, -4576.000, 592.002, -2048.000, -4576.000, 592.002]
		"c2m1_highway" : [-880.000, -2592.000, -1028.000, 1653.000, 2786.000, 60.000]
		"c2m2_fairgrounds" : [-4864.000, -5504.000, 0.000, 4080.000, 2048.000, 0.000]
		"c2m3_coaster" : [-5248.000, 1664.000, 72.000, 3120.000, 3584.000, -120.000]
		"c2m4_barns" : [-896.000, 2240.000, -176.000, -896.000, 2240.000, -176.000]
		"c3m1_plankcountry" : [-2672.000, 400.000, 116.000, -8176.000, 7472.000, 72.000]
		"c3m2_swamp" : [7523.000, -960.000, 192.000, -5789.000, 2112.000, 192.000]
		"c3m3_shantytown" : [5008.000, -3776.000, 366.809, -5104.000, -1664.000, -81.191]
		"c4m1_milltown_a" : [4032.000, -1600.000, 296.250, 3776.000, -1728.000, 296.500]
		"c4m2_sugarmill_a" : [-1773.400, -13698.300, 138.250, -1773.400, -13698.300, 138.000]
		"c4m3_sugarmill_b" : [3776.000, -1728.000, 296.250, 4032.000, -1600.000, 296.250]
		"c4m4_milltown_b" : [4032.000, -1600.000, 296.250, 4032.000, -1600.000, 296.250]
		"c5m1_waterfront" : [-3904.000, -1264.000, -288.000, -3904.000, -1264.000, -288.000]
		"c5m2_park" : [-9856.000, -8032.000, -208.000, 6272.000, 8352.000, 48.000]
		"c5m3_cemetery" : [7240.000, -9664.000, 113.000, -3296.000, 4792.000, 77.000]
		"c5m4_quarter" : [1520.000, -3608.000, 128.000, -11984.000, 5760.000, 192.000]
		"c6m1_riverbank" : [-3960.950, 1376.150, 744.000, 3239.050, -1231.850, -280.000]
		"c6m2_bedlam" : [11272.000, 5056.000, -568.000, -2392.000, -464.000, -192.000]
		"c7m1_docks" : [1871.690, 2437.110, 184.000, 10703.700, 2437.110, 184.000]
		"c7m2_barge" : [-11080.300, 3123.700, 184.000, 1175.680, 3243.700, 176.000]
		"c8m1_apartment" : [2948.000, 3084.000, -219.023, 2948.000, 3084.000, 36.977]
		"c8m2_subway" : [10832.000, 4736.000, 41.000, 10832.000, 4736.000, 41.000]
		"c8m3_sewers" : [12469.500, 12559.000, 25.000, 12469.500, 12559.000, 25.000]
		"c8m4_interior" : [11555.400, 14884.600, 5545.000, 5539.400, 8356.600, 5545.000]
		"c9m1_alleys" : [281.000, -1356.000, -156.000, 280.000, -1292.000, -156.000]
		"c10m1_caves" : [-10912.000, -4962.410, 370.000, -11200.000, -8994.410, -510.000]
		"c10m2_drainage" : [-8211.000, -5502.000, -23.000, -8212.000, -5502.000, -17.000]
		"c10m3_ranchhouse" : [-2640.000, -128.000, 168.000, -3152.000, -128.000, 168.000]
		"c10m4_mainstreet" : [1240.000, -5440.000, -15.000, 1960.000, 4576.000, -23.000]
		"c11m1_greenhouse" : [5264.000, 2800.000, 68.000, 5264.000, 2800.000, 68.000]
		"c11m2_offices" : [7960.000, 6216.000, 41.000, -5368.000, -3016.000, 41.000]
		"c11m3_garage" : [-414.598, 3561.070, 320.000, -414.598, 3561.070, 320.000]
		"c11m4_terminal" : [3441.120, 4525.300, 161.000, -6558.880, 12025.300, 161.000]
		"c12m1_hilltop" : [-6527.000, -6768.000, 357.281, -6527.000, -6768.000, 357.281]
		"c12m2_traintunnel" : [-970.000, -10378.000, -58.719, -970.000, -10378.000, -58.719]
		"c12m3_bridge" : [7724.610, -11362.000, 449.000, 7724.610, -11362.000, 449.000]
		"c12m4_barn" : [10442.000, -354.553, -5.000, 10442.000, -354.553, -5.000]
		"c13m1_alpinecreek" : [1125.000, -966.000, 360.000, 8629.000, 7338.000, 504.000]
		"c13m2_southpinestream" : [326.000, 8807.000, -397.000, -4338.000, -5157.000, 104.000]
		"c13m3_memorialbridge" : [6314.500, -6065.600, 402.000, -3616.000, -9356.000, 376.000]
		"c14m1_junkyard" : [-3184.000, 10432.000, -64.000, 2160.000, -960.000, 512.000]
	};
}

__tGameEventsListener <-
{
	OnWeaponFire = function(tParams)
	{
		local sWeapon = tParams["weapon"];
		local hPlayer = tParams["_player"];

		if (!IsPlayerABot(hPlayer) && !hPlayer.IsIncapacitated())
		{
			if (sWeapon != "vomitjar")
			{
				switch (sWeapon)
				{
				case "gascan":
				case "cola_bottles":
					local idx = hPlayer.GetEntityIndex();
					if (g_bAutoShove[idx] && !g_bFillBot[idx]) hPlayer.SendInput(IN_ATTACK2);
					return;

				case "propanetank":
				case "oxygentank":
				case "fireworkcrate":
					return;
				}
				
				if (sWeapon != "pipe_bomb" && sWeapon != "molotov")
				{
					for (local i = 0; i < tCB["aList"].len(); i++)
					{
						local tbl = tCB["aList"][i];

						if (tbl["common"].IsValid() && !tCB["TriggerCI"](tbl["common"], hPlayer, tbl["delay"], tbl["ignore_dist"]))
							continue;
						
						tCB["aList"].remove(i);
						i--;
					}
					return;
				}
				
				if (KeyInScriptScope(hPlayer, "grenadeboost"))
				{
					local tParams = GetScriptScopeVar(hPlayer, "grenadeboost");
					TP(hPlayer, null, QAngle(tParams["angle"], hPlayer.EyeAngles().y, 0.0), null);

					if (!tParams["target"].len())
					{
						local hPlayerTemp;
						while (hPlayerTemp = Entities.FindByClassname(hPlayerTemp, "player"))
						{
							if (hPlayer.IsSurvivor() && hPlayer.IsAlive() && hPlayer != hPlayerTemp && GetDistanceToEntity(hPlayer, hPlayerTemp, true) < 62500)
							{
								hPlayerTemp.SendInput(IN_JUMP);
							}
						}
					}
					else
					{
						foreach (player in tParams["target"])
						{
							if (player.IsValid())
							{
								player.SendInput(IN_JUMP);
							}
						}
					}

					if (tParams["jump"]) hPlayer.SendInput(IN_JUMP);

					CreateTimer(0.5, function(hPlayer){
						if (hPlayer.IsValid()) NetProps.SetPropInt(hPlayer, "m_afButtonForced", 0);
					}, hPlayer);

					RemoveScriptScopeKey(hPlayer, "grenadeboost");
					foreach (idx, player in g_aAutoGrenadeBoostUsers)
					{
						if (hPlayer == player)
						{
							g_aAutoGrenadeBoostUsers.remove(idx);
							break;
						}
					}
				}
			}
		}
	}

	OnTankSpawn = function(tParams)
	{
		if (tScriptedTankSpawn["bFinaleStarted"])
		{
			FinaleManager.iTankCount++;

			if (tScriptedTankSpawn["aScriptedSpawns"].len() > 0)
			{
				local hPlayer = tParams["_player"];
				local vecOrigin = tScriptedTankSpawn["aScriptedSpawns"][0];

				printf("[ScriptedTankSpawn] Changed current position of Tank (idx %d) to: %s", hPlayer.GetEntityIndex(), kvstr(vecOrigin));
				tParams["_player"].SetOrigin(vecOrigin);
				tScriptedTankSpawn["aScriptedSpawns"].remove(0);
			}

			if (FinaleManager.iTankCount <= FinaleManager.Settings.MaxTanksInFinale)
			{
				sayf("Tank #%d spawned at time: %f", FinaleManager.iTankCount, Time() - g_flFinaleStartTime);
			}
		}
	}

	OnFinaleStart = function(tParams)
	{
		g_flFinaleStartTime = Time();
		tScriptedTankSpawn["bFinaleStarted"] = true;
		PrintCurrentTime("Finale started at time:");

		if ("OnFinaleStart" in ::Callbacks)
			::Callbacks.OnFinaleStart();

		if (FinaleManager.Settings.Enabled)
		{
			if (!IsOnTickFunctionRegistered("FinaleManager.Think"))
				RegisterOnTickFunction("FinaleManager.Think");
		}
	}
};

tCB <-
{
	aList = []

	TriggerCI = function(hEntity, hPlayer, flDelay, bIgnoreDistance)
	{
		local flDistance = GetDistanceToEntity(hPlayer, hEntity);

		if (!bIgnoreDistance)
		{
			if (flDistance > 1825) return false;
			if (!g_bMapWithLongestAggressiveDistance && flDistance > 530) return false;
		}

		if (GetAngleBetweenEntities(hEntity, hPlayer, Vector(), true) > 75) return false;

		flDelay += flDistance > 235 ? ((flDistance + 185) / 700) : 0.5;
		NetProps.SetPropInt(hEntity, "m_nSequence", RandomInt(37, 39));

		if (flDelay > 0)
		{
			CreateTimer(flDelay, function(hEntity, hPlayer){
				if (hEntity.IsValid() && hPlayer.IsValid()) SendCommandToBot(BOT_CMD_ATTACK, hEntity, hPlayer);
			}, hEntity, hPlayer);
		}
		else
		{
			SendCommandToBot(BOT_CMD_ATTACK, hEntity, hPlayer)
		}

		return true;
	}
};

tScriptedTankSpawn <-
{
	aScriptedSpawns = []
	bFinaleStarted = false
};

tCommonInfectedRecorder <-
{
	flStartTime = 0.0
	buffer = ""
};

tZombieList <-
{
	infected = ZOMBIE_NORMAL
	smoker = ZOMBIE_SMOKER
	boomer = ZOMBIE_BOOMER
	hunter = ZOMBIE_HUNTER
	spitter = ZOMBIE_SPITTER
	jockey = ZOMBIE_JOCKEY
	charger = ZOMBIE_CHARGER
	tank = ZOMBIE_TANK
	witch = ZOMBIE_WITCH
	witch_bride = ZSPAWN_WITCHBRIDE
};

PrecacheEntityFromTable({classname = "prop_dynamic", model = "models/props_unique/spawn_apartment/coffeeammo.mdl"});

function SpawnBileEffect(vecOrigin)
{
	local hGoalChase = SpawnEntityFromTable("info_goal_infected_chase", {
		origin = vecOrigin
	});

	local hEffect = SpawnEntityFromTable("info_particle_system", {
		origin = vecOrigin
		start_active = 1
		effect_name = "vomit_jar"
	});

	AcceptEntityInput(hGoalChase, "Enable");
	AcceptEntityInput(hGoalChase, "Kill", "", 15.0);
	AcceptEntityInput(hEffect, "Kill", "", 15.0);
	EmitSoundOn("CedaJar.Explode", hEffect);

	return {
		effect = hEffect
		goal_chase = hGoalChase
	};
}

function SpawnBarrel(vecOrigin, eAngles = null)
{
	if (!eAngles) eAngles = QAngle(0, RandomInt(0, 360), 0);
	return SpawnEntityFromTable("prop_fuel_barrel", {
		origin = vecOrigin
		angles = kvstr(eAngles)
		targetname = "task_ent_barrel"
		model = "models/props_industrial/barrel_fuel.mdl"
		BasePiece = "models/props_industrial/barrel_fuel_partb.mdl"
		FlyingPiece01 = "models/props_industrial/barrel_fuel_parta.mdl"
		DetonateParticles = "weapon_pipebomb"
		FlyingParticles = "barrel_fly"
		DetonateSound = "BaseGrenade.Explode"
	});
}

function SpawnItem(sName, vecOrigin, eAngles = null, iCount = 1, flRadius = 0.0, bPhysicsWeapon = false, sTargetName = "task_ent_item")
{
	if (sName in g_tItems)
	{
		if (!eAngles) eAngles = QAngle(0, RandomInt(0, 360), 0);
		if (iCount <= 0) iCount = 1;
		if (flRadius > 0) RemoveItemWithin(vecOrigin, flRadius);

		local sClass = g_tItems[sName]["classname"];
		local tParams = {targetname = sTargetName, origin = vecOrigin, angles = kvstr(eAngles)};
		tParams.rawset((sClass != "prop_physics" ? "count" : "model"), (sClass != "prop_physics" ? iCount : g_tItems[sName]["model"]));

		if (sName == "ammo" || sName == "ammo_l4d")
		{
			tParams["model"] <- g_tItems[sName]["model"];
		}
		else if (sClass == "weapon_melee_spawn")
		{
			tParams["melee_weapon"] <- sName;
		}
		else if (bPhysicsWeapon)
		{
			if (sName == "gascan_scavenge")
			{
				sClass = "weapon_gascan";
				tParams["skin"] <- 1;
			}
			else if (sClass.find("_spawn") != null)
			{
				sClass = sClass.slice(0, -6);
			}
			else if (sName == "cola_bottles")
			{
				sClass = "weapon_cola_bottles";
			}
		}
		else if (sName == "gascan_scavenge")
		{
			local hEntity;
			tParams["model"] <- g_tItems[sName]["model"];
			tParams["glowstate"] <- 0;
			tParams["spawnflags"] <- 2;
			tParams["disableshadows"] <- 1;

			AcceptEntityInput(hEntity = SpawnEntityFromTable(sClass, tParams), "SpawnItem");
			return hEntity; // AcceptEntityInput(hEntity, "TurnGlowsOn");
		}
		return SpawnEntityFromTable(sClass, tParams);
	}
	printl("[SpawnItem] Invalid name");
}

function SpawnZombie(sName, vecOrigin, eAngles = null, bIdle = false, bRush = false, bFastSpawn = true)
{
	if (sName in tZombieList)
	{
		local sTargetName = "task_zombie_si";
		
		switch (sName)
		{
		case "tank":
		case "witch":
		case "witch_bridge":
			sTargetName = "task_zombie_boss";
			break;

		case "infected":
			sTargetName = "task_zombie_ci";
			break;
		}

		if (sTargetName[12] == 98 && "ProhibitBosses" in g_ModeScript.LocalScript.DirectorOptions && g_ModeScript.LocalScript.DirectorOptions.ProhibitBosses)
		{
			SayMsg("[SpawnZombie] Bosses are prohibited to spawn right now!");
		}

		if (!eAngles)
		{
			eAngles = QAngle(0, RandomInt(0, 360), 0);
		}

		if (sName == "infected" && !bFastSpawn)
		{
			local hEntity = SpawnEntityFromTable("infected", {origin = vecOrigin, angles = kvstr(eAngles), targetname = sTargetName});
			if (bIdle) ReapplyInfectedFlags(INFECTED_FLAG_CANT_SEE_SURVIVORS | INFECTED_FLAG_CANT_HEAR_SURVIVORS | INFECTED_FLAG_CANT_FEEL_SURVIVORS, hEntity);
			else if (bRush) NetProps.SetPropInt(hEntity, "m_mobRush", 1);
			return hEntity;
		}

		local sClass = sName;
		if (["infected", "witch", "witch_bridge"].find(sName) == null)
		{
			sClass = "player";
		}
		else if (sName == "witch_bride")
		{
			sClass = "witch";
			PrecacheEntityFromTable({classname = "prop_dynamic", model = "models/infected/witch_bride.mdl"});
		}

		local hEntity;
		local aEntities = [];

		while (hEntity = Entities.FindByClassname(hEntity, sClass)) aEntities.push(hEntity);

		ZSpawn({type = tZombieList[sName], pos = vecOrigin});

		while (hEntity = Entities.FindByClassname(hEntity, sClass))
		{
			if (aEntities.find(hEntity) == null)
			{
				if (hEntity.IsPlayer())
				{
					if (bIdle) hEntity.SetSenseFlags(BOT_CANT_FEEL | BOT_CANT_HEAR | BOT_CANT_SEE);
				}
				else
				{
					TP(hEntity, null, eAngles, null);
					if (bIdle) ReapplyInfectedFlags(INFECTED_FLAG_CANT_SEE_SURVIVORS | INFECTED_FLAG_CANT_HEAR_SURVIVORS | INFECTED_FLAG_CANT_FEEL_SURVIVORS, hEntity);
					else if (bRush) NetProps.SetPropInt(hEntity, "m_mobRush", 1);
				}
				hEntity.__KeyValueFromString("targetname", sTargetName);
				return hEntity;
			}
		}
	}
	printl("[SpawnZombie] Invalid name");
}

function SpawnCommon(sName, vecOrigin, eAngles = null, flDelay = 0.0)
{
	if (!eAngles) eAngles = QAngle(0, RandomInt(0, 360), 0);
	if (typeof sName == "string")
	{
		if (sName.find("common_") != null || sName == "infected")
		{
			if (sName == "infected")
			{
				sName =
				[
					"common_male_tshirt_cargos"
					"common_male_tankTop_jeans"
					"common_male_dressShirt_jeans"
					"common_female_tankTop_jeans"
					"common_female_tshirt_skirt"
				]
				sName = format("%s", sName[RandomInt(0, sName.len() - 1)]);
			}
			local hEntity = SpawnEntityFromTable("commentary_zombie_spawner", {origin = vecOrigin, angles = kvstr(eAngles)});
			AcceptEntityInput(hEntity, "SpawnZombie", sName, flDelay);
			AcceptEntityInput(hEntity, "Kill", "", flDelay);
			return;
		}
	}
	printl("[SpawnCommon] Invalid argument");
}

function SpawnCommonWithBile(vecOrigin, eAngles = null, bIgnoreCEDAPopulation = false)
{
	if (!bIgnoreCEDAPopulation && !g_bContainsCEDAPopulation) return;
	if (!eAngles) eAngles = QAngle(0, RandomInt(0, 360), 0);

	local hEntity;
	local aEntities = [];

	while (hEntity = Entities.FindByClassname(hEntity, "infected"))
		aEntities.push(hEntity);

	SpawnCommon("common_male_ceda", vecOrigin, kvstr(eAngles));

	CreateTimer(0.01, function(aEntities){
		local hEntity;
		while (hEntity = Entities.FindByClassname(hEntity, "infected"))
		{
			if (aEntities.find(hEntity) == null)
			{
				if (NetProps.GetPropString(hEntity, "m_ModelName") == "models/infected/common_male_ceda.mdl")
				{
					if (!KeyInScriptScope(hEntity, "spawned_with_bile"))
					{
						SetScriptScopeVar(hEntity, "spawned_with_bile", true);
						NetProps.SetPropInt(hEntity, "m_nFallenFlags", 1);
						break;
					}
				}
			}
		}
	}, aEntities);
}

function SpawnCommonForCB(vecOrigin, eAngles = null, flAttackDelay = 0.0, hTarget = null, bIgnoreDistance = false, sTargetName = "task_ent_cb")
{
	if (!eAngles) eAngles = QAngle(0, RandomInt(0, 360), 0);

	local hEntity = SpawnEntityFromTable("infected", {targetname = sTargetName, origin = vecOrigin, angles = kvstr(eAngles)});
	ReapplyInfectedFlags(INFECTED_FLAG_CANT_SEE_SURVIVORS | INFECTED_FLAG_CANT_HEAR_SURVIVORS | INFECTED_FLAG_CANT_FEEL_SURVIVORS, hEntity);

	if (flAttackDelay == null)
	{
		return hEntity;
	}

	if (hTarget)
	{
		tCB["TriggerCI"](hEntity, hTarget, flAttackDelay, bIgnoreDistance);
		return hEntity;
	}

	tCB["aList"].push({common = hEntity, delay = flAttackDelay, ignore_dist = bIgnoreDistance});
	return hEntity;
}

function SpawnTrigger(sName, vecOrigin, vecMaxs = Vector(64, 64, 128), vecMins = Vector(-64, -64, 0), sFunction = "OnTriggerTouch", iType = TR_CLIENTS, sOutput = "OnStartTouch", sClass = "trigger_multiple")
{
	local hEntity = SpawnEntityFromTable(sClass, {
		targetname = sName
		origin = vecOrigin
		spawnflags = iType
	});

	hEntity.ValidateScriptScope();
	hEntity.__KeyValueFromVector("maxs", vecMaxs);
	hEntity.__KeyValueFromVector("mins", vecMins);
	hEntity.__KeyValueFromInt("solid", 2);

	if (sFunction) hEntity.__KeyValueFromString(sOutput, format("!caller,RunScriptCode,%s()", sFunction));
	if (iType & TR_OFF) AcceptEntityInput(hEntity, "Disable");

	return hEntity;
}

function RemoveItemByName(sName)
{
	local iCount = 0;
	if (sName == null)
	{
		foreach (name, tbl in g_tItems) iCount += RemoveItem(name);
		return iCount;
	}
	if (sName in g_tItems)
	{
		local hEntity;
		if (sName == "gascan_scavenge")
		{
			while (hEntity = Entities.FindByClassname(hEntity, "weapon_scavenge_item_spawn"))
			{
				hEntity.Kill();
				iCount++;
			}
			while (hEntity = Entities.FindByClassname(hEntity, "weapon_gascan"))
			{
				if (NetProps.GetPropInt(hEntity, "m_nSkin") == 1)
				{
					hEntity.Kill();
					iCount++;
				}
			}
		}
		else
		{
			while (hEntity = Entities.FindByModel(hEntity, g_tItems[sName]["model"]))
			{
				hEntity.Kill();
				iCount++;
			}
		}
		return iCount;
	}
	printl("[SpawnItem] Invalid name");
}

function RemoveItemWithin(vecPos, flRadius)
{
	local hEntity;
	local iCount = 0;
	while (hEntity = Entities.FindInSphere(hEntity, vecPos, flRadius))
	{
		local sClass = hEntity.GetClassname();
		if (sClass.find("weapon_") != null || sClass.find("upgrade_ammo_") != null || sClass == "upgrade_laser_sight" || sClass == "prop_physics")
		{
			foreach (tbl in g_tItems)
			{
				if (NetProps.GetPropString(hEntity, "m_ModelName") == tbl["model"] || sClass == "weapon_scavenge_item_spawn")
				{
					hEntity.Kill();
					iCount++;
					break;
				}
			}
		}
	}
	return iCount;
}

function TakeItem(hPlayer, hItem, bSetPreviousAngles = true, bSetVelocityDirectionAngles = false)
{
    local sClass = hItem.GetClassname();
	if ((sClass.find("weapon_") != null && sClass.find("_weapon_") == null) || sClass == "prop_physics")
	{
		if (sClass == "prop_physics")
		{
			if (g_aPropPhysicsModels.find(NetProps.GetPropString(hItem, "m_ModelName")) == null) return;
			else if (hPlayer.GetActiveWeapon() == hItem) return;
		}
		else if (NetProps.GetPropEntity(hItem, "m_hOwnerEntity") != null || !NetProps.GetPropInt(hItem, "m_itemCount")) return;

		if ((hItem.GetOrigin() - hPlayer.EyePosition()).LengthSqr() <= 10712.897477)
		{
			local eAngles = hPlayer.EyeAngles();

			TP(hPlayer, null, hItem.GetOrigin() - hPlayer.EyePosition(), null, true);
			hPlayer.SendInput(IN_USE);

			if (bSetPreviousAngles)
			{
				RunNextTickFunction(TP, hPlayer, null, eAngles, null);
			}
			else if (bSetVelocityDirectionAngles)
			{
				local vecVel = hPlayer.GetVelocity();
				if (vecVel.x != 0 || vecVel.y != 0) RunNextTickFunction(TP, hPlayer, null, QAngle(eAngles.x, atan2(vecVel.y, vecVel.x) * Math.Rad2Deg), null);
			}
		}
	}
}

function TakeNearestItem(hPlayer, bSetPreviousAngles = true, bSetVelocityDirectionAngles = false, bFindNearestItem = true, sClassname = null)
{
    local hEntity, lastEnt;
    while (hEntity = Entities.Next(hEntity))
    {
		local sClass = hEntity.GetClassname();
		if ((sClass.find("weapon_") != null && sClass.find("_weapon_") == null) || sClass == "prop_physics")
		{
			if (bFindNearestItem || sClass == sClassname)
			{
				if (sClass == "prop_physics")
				{
					if (g_aPropPhysicsModels.find(NetProps.GetPropString(hEntity, "m_ModelName")) == null) continue;
					else if (hPlayer.GetActiveWeapon() == hEntity) continue;
				}
				else if (NetProps.GetPropEntity(hEntity, "m_hOwnerEntity") || !NetProps.GetPropInt(hEntity, "m_itemCount")) continue;

				local flDistanceSqr = (hEntity.GetOrigin() - hPlayer.EyePosition()).LengthSqr();
				if (flDistanceSqr <= 10712.897477)
				{
					if (lastEnt)
					{
						if (flDistanceSqr < (lastEnt.GetOrigin() - hPlayer.EyePosition()).LengthSqr())
							lastEnt = hEntity;

						continue;
					}
					lastEnt = hEntity;
				}
			}
		}
    }
    if (lastEnt)
    {
		local eAngles = hPlayer.EyeAngles();

		TP(hPlayer, null, lastEnt.GetOrigin() - hPlayer.EyePosition(), null, true);
		hPlayer.SendInput(IN_USE);

		if (bSetPreviousAngles)
		{
			RunNextTickFunction(TP, hPlayer, null, eAngles, null);
		}
		else if (bSetVelocityDirectionAngles)
		{
			local vecVel = hPlayer.GetVelocity();
			if (vecVel.x != 0 || vecVel.y != 0) RunNextTickFunction(TP, hPlayer, null, QAngle(eAngles.x, atan2(vecVel.y, vecVel.x) * Math.Rad2Deg), null);
		}
    }
}

function TakeNearestItemByClassname(hPlayer, sClassname, bSetPreviousAngles = true, bSetVelocityDirectionAngles = false)
{
	TakeNearestItem(hPlayer, bSetPreviousAngles, bSetVelocityDirectionAngles, false, sClassname);
}

function UseEntity(hPlayer, hEntity, bSetPreviousAngles = true, bSetVelocityDirectionAngles = false)
{
    local sClass = hEntity.GetClassname();
	if (g_aUseEntitiesList.find(sClass) != null)
	{
		if ((sClass == "func_button" || sClass == "prop_door_rotating") && NetProps.GetPropInt(hEntity, "m_bLocked"))
			return;

		if ((sClass == "upgrade_ammo_explosive" || sClass == "upgrade_ammo_incendiary") && NetProps.GetPropInt(hEntity, "m_iUsedBySurvivorsMask") & (1 << hPlayer.GetEntityIndex() - 1))
			return;

		if (sClass == "upgrade_laser_sight")
		{
			if (hPlayer.GetActiveWeapon()) return;
			if (g_aPrimaryWeaponList.find(hPlayer.GetActiveWeapon().GetClassname()) == null) return;
			else if (NetProps.GetPropInt(hPlayer.GetActiveWeapon(), "m_upgradeBitVec") & eUpgrade.Laser) return;
		}

		if ((hEntity.GetOrigin() - hPlayer.EyePosition()).LengthSqr() <= 9539.79442)
		{
			local eAngles = hPlayer.EyeAngles();

			TP(hPlayer, null, hEntity.GetOrigin() - hPlayer.EyePosition(), null, true);

			if (sClass == "prop_door_rotating_checkpoint" || sClass == "prop_door_rotating")
			{
				if (!NetProps.GetPropInt(hEntity, "m_eDoorState")) AcceptEntityInput(hEntity, "PlayerOpen", "", 0.0, hPlayer);
				else AcceptEntityInput(hEntity, "PlayerClose", "", 0.0, hPlayer);
			}
			else
			{
				hPlayer.SendInput(IN_USE);
			}

			if (bSetPreviousAngles)
			{
				RunNextTickFunction(TP, hPlayer, null, eAngles, null);
			}
			else if (bSetVelocityDirectionAngles)
			{
				local vecVel = hPlayer.GetVelocity();
				if (vecVel.x != 0 || vecVel.y != 0) RunNextTickFunction(TP, hPlayer, null, QAngle(eAngles.x, atan2(vecVel.y, vecVel.x) * Math.Rad2Deg), null);
			}
		}
	}
}

function UseNearestEntity(hPlayer, bSetPreviousAngles = true, bSetVelocityDirectionAngles = false, bFindNearestEntity = true, sClassname = null)
{
    local hEntity, lastEnt;
    while (hEntity = Entities.Next(hEntity))
    {
		local sClass = hEntity.GetClassname();
		if (g_aUseEntitiesList.find(sClass) != null)
		{
			if (bFindNearestEntity || sClass == sClassname)
			{
				if ((sClass == "func_button" || sClass == "prop_door_rotating") && NetProps.GetPropInt(hEntity, "m_bLocked"))
					continue;

				if ((sClass == "upgrade_ammo_explosive" || sClass == "upgrade_ammo_incendiary") && NetProps.GetPropInt(hEntity, "m_iUsedBySurvivorsMask") & (1 << hPlayer.GetEntityIndex() - 1))
					continue;

				if (sClass == "upgrade_laser_sight")
				{
					if (!hPlayer.GetActiveWeapon()) continue;
					if (g_aPrimaryWeaponList.find(hPlayer.GetActiveWeapon().GetClassname()) == null) continue;
					else if (NetProps.GetPropInt(hPlayer.GetActiveWeapon(), "m_upgradeBitVec") & eUpgrade.Laser) continue;
				}

				local flDistanceSqr = (hEntity.GetOrigin() - hPlayer.EyePosition()).LengthSqr();
				if (flDistanceSqr <= 9539.79442)
				{
					if (lastEnt)
					{
						if (flDistanceSqr < (lastEnt.GetOrigin() - hPlayer.EyePosition()).LengthSqr())
							lastEnt = hEntity;

						continue;
					}
					lastEnt = hEntity;
				}
			}
		}
    }
    if (lastEnt)
    {
		local eAngles = hPlayer.EyeAngles();
		local sClass = lastEnt.GetClassname();

		TP(hPlayer, null, lastEnt.GetOrigin() - hPlayer.EyePosition(), null, true);

		if (sClass == "prop_door_rotating_checkpoint" || sClass == "prop_door_rotating")
		{
			if (!NetProps.GetPropInt(lastEnt, "m_eDoorState")) AcceptEntityInput(lastEnt, "PlayerOpen", "", 0.0, hPlayer);
			else AcceptEntityInput(lastEnt, "PlayerClose", "", 0.0, hPlayer);
		}
		else hPlayer.SendInput(IN_USE);

		if (bSetPreviousAngles)
		{
			RunNextTickFunction(TP, hPlayer, null, eAngles, null);
		}
		else if (bSetVelocityDirectionAngles)
		{
			local vecVel = hPlayer.GetVelocity();
			if (vecVel.x != 0 || vecVel.y != 0) RunNextTickFunction(TP, hPlayer, null, QAngle(eAngles.x, atan2(vecVel.y, vecVel.x) * Math.Rad2Deg), null);
		}
    }
}

function UseNearestEntityByClassname(hPlayer, sClassname, bSetPreviousAngles = true, bSetVelocityDirectionAngles = false)
{
	UseNearestEntity(hPlayer, bSetPreviousAngles, bSetVelocityDirectionAngles, false, sClassname);
}

function ScriptedTP(hPlayerFrom, hPlayerTo, flTime = 6.1, bStuckTeleport = false, nMode = 0)
{
	if (!hPlayerFrom.IsAlive() || hPlayerFrom.IsIncapacitated())
	{
		SayMsg("[ScriptedTP] Invalid player");
		return;
	}

	if (!bStuckTeleport && !hPlayerTo.IsAlive())
	{
		SayMsg("[ScriptedTP] Invalid leader");
		return;
	}

	if (flTime > 0)
	{
		if (nMode)
		{
			local sFunction, sCharName;
			getroottable()[sFunction = "_scripted_tp" + UniqueString()] <- function(sCharName)
			{
				local hBot = Ent("!" + sCharName);
				if (hBot && IsPlayerABot(hBot))
					SendCommandToBot(BOT_CMD_RESET, hBot);
			}

			RegisterOnTickFunction(sFunction, (sCharName = GetCharacterDisplayName(hPlayerFrom)));
			CreateTimer(nMode < 2 ? 0.2 : 4.0, function(sFunction, sCharName){
				if (IsOnTickFunctionRegistered(sFunction, sCharName))
				{
					RemoveOnTickFunction(sFunction, sCharName);
					delete getroottable()[sFunction];
				}
			}, sFunction, sCharName);
		}

		CreateTimer(flTime, function(sCharName, sLeaderCharName, bStuckTeleport){
			ScriptedTP(Ent("!" + sCharName), Ent("!" + sLeaderCharName), 0.0, bStuckTeleport);
		}, GetCharacterDisplayName(hPlayerFrom), GetCharacterDisplayName(hPlayerTo), bStuckTeleport);
		return;
	}

	if (bStuckTeleport)
	{
		hPlayerTo = null;

		local hEntity, flDistanceSqrTemp;
		local flDistanceSqr = eTrace.Distance;
		while (hEntity = Entities.FindByClassname(hEntity, "player"))
		{
			if (hEntity.IsSurvivor() && hEntity.IsAlive() && hEntity != hPlayerFrom && (flDistanceSqrTemp = GetDistanceToEntity(hPlayerFrom, hEntity, true)) < flDistanceSqr)
			{
				flDistanceSqr = flDistanceSqrTemp;
				hPlayerTo = hEntity;
			}
		}

		if (!hPlayerTo) return SayMsg("[ScriptedTP] No player to teleport");
		if (IsPlayerABot(hPlayerFrom)) SayMsg("[ScriptedTP] Done, but player a bot");

		hPlayerFrom.__KeyValueFromVector("origin", hPlayerTo.GetOrigin());
		SendToConsole(format("echo %.03f >> [ScriptedTP] Completed scripted stuck warp", GetCurrentTime()));
		return;
	}
	
	if (IsPlayerABot(hPlayerTo)) SayMsg("[ScriptedTP] Done, but leader a bot");
	if (!IsPlayerABot(hPlayerFrom)) SayMsg("[ScriptedTP] Done, but player isn't idle");
	if (GetDistanceToEntity(hPlayerTo, hPlayerFrom, true) < 225e4) sayf("[ScriptedTP] Done, but distance (%.01f) between players is too close", GetDistanceToEntity(hPlayerTo, hPlayerFrom));

	local vecForward = hPlayerTo.EyeAngles().Forward(); vecForward.z = 0.0;
	hPlayerFrom.SetOrigin(hPlayerTo.GetOrigin() + vecForward * -10);

	SendToConsole(format("echo %.03f >> [ScriptedTP] Completed scripted warp", GetCurrentTime()));
}

function RemoveInvSlot(hPlayer, iSlot)
{
	iSlot = Math.Clamp(iSlot, 0, 5);
	local tInv = {};
	GetInvTable(hPlayer, tInv);
	iSlot = "slot" + iSlot;
	if (iSlot in tInv) tInv[iSlot].Kill();
}

function AddScriptedTankSpawn(vecOrigin)
{
	if (vecOrigin instanceof Vector)
	{
		tScriptedTankSpawn["aScriptedSpawns"].push(vecOrigin);
		printl("[ScriptedTankSpawn] Added a new spawn position. Total count: " + tScriptedTankSpawn["aScriptedSpawns"].len())
		return true;
	}
	return false;
}

function StartRecordingCI()
{
	if (!IsOnTickFunctionRegistered("RecordCI_Think"))
	{
		RegisterOnTickFunction("RecordCI_Think");
		tCommonInfectedRecorder["flStartTime"] = Time();
		tCommonInfectedRecorder["buffer"] = "";
		return;
	}

	printl("[RecordCI] Already recording..");
}

function StopRecordingCI(sFileName = "default")
{
	if (IsOnTickFunctionRegistered("RecordCI_Think"))
	{
		RemoveOnTickFunction("RecordCI_Think");
		StringToFile("ci_recorder/" + sFileName + ".txt", tCommonInfectedRecorder["buffer"]);
	}
}

function SpawnRecordedCI(sFileName = "default")
{
	local buffer = FileToString("ci_recorder/" + sFileName + ".txt");

	if (buffer == null)
	{
		printl("[SpawnRecordedCI] Couldn't find file");
		return;
	}

	try {
		local aTimeSplits = split(buffer, "@");
		local index = aTimeSplits.len() - 1;

		foreach (idx, time_split in aTimeSplits)
		{
			local data = split(time_split, ":");

			CreateTimer(data[0].tofloat(), function(sData, bEnd){
				compilestring(sData)();
				if (bEnd) printl("[SpawnRecordedCI] Finished.");
			}, data[1], idx == index);
		}
	}
	catch (error) {
		printl("[SpawnRecordedCI] Failed to parse file");
	}
}

function OpenSafeRoomDoor(bOpen = false)
{
	if (bOpen)
	{
		local hEntity;
		while (hEntity = Entities.FindByClassname(hEntity, "prop_door_rotating_checkpoint"))
		{
			local sModel = NetProps.GetPropString(hEntity, "m_ModelName");
			if (sModel == "models/props_doors/checkpoint_door_01.mdl" || sModel == "models/props_doors/checkpoint_door_-01.mdl" || sModel == "models/lighthouse/checkpoint_door_lighthouse01.mdl")
			{
				local hPlayer, hPlayerTemp;
				local flDistanceSqr = 250000.0;
				local flDistanceSqrTemp = 0.0;

				while (hPlayerTemp = Entities.FindByClassname(hPlayerTemp, "player"))
				{
					if (hPlayerTemp.IsSurvivor() && (flDistanceSqrTemp = (hEntity.GetOrigin() - hPlayerTemp.GetOrigin()).LengthSqr()) < flDistanceSqr)
					{
						flDistanceSqr = flDistanceSqrTemp;
						hPlayer = hPlayerTemp;
					}
				}

				AcceptEntityInput(hEntity, "PlayerOpen", "", 0.0, hPlayer);
				break;
			}
		}
	}
	else
	{
		if (!IsOnTickFunctionRegistered("OpenSafeRoomDoor", true))
		{
			OpenSafeRoomDoor(true);
			RegisterOnTickFunction("OpenSafeRoomDoor", true);
			CreateTimer(0.6, RemoveOnTickFunction, "OpenSafeRoomDoor", true);
		}
	}
}

function CloseSafeRoomDoor(bBeginningDoor = true)
{
	local hEntity;
	while (hEntity = Entities.FindByClassname(hEntity, "prop_door_rotating_checkpoint"))
	{
		local sModel = NetProps.GetPropString(hEntity, "m_ModelName");
		if (bBeginningDoor ? (sModel == "models/props_doors/checkpoint_door_01.mdl" || sModel == "models/props_doors/checkpoint_door_-01.mdl" || sModel == "models/lighthouse/checkpoint_door_lighthouse01.mdl")
			: (sModel == "models/props_doors/checkpoint_door_02.mdl" || sModel == "models/lighthouse/checkpoint_door_lighthouse02.mdl"))
		{
			local hPlayer, hPlayerTemp;
			local flDistanceSqr = 250000.0;
			local flDistanceSqrTemp = 0.0;

			while (hPlayerTemp = Entities.FindByClassname(hPlayerTemp, "player"))
			{
				if (hPlayerTemp.IsSurvivor() && (flDistanceSqrTemp = (hEntity.GetOrigin() - hPlayerTemp.GetOrigin()).LengthSqr()) < flDistanceSqr)
				{
					flDistanceSqr = flDistanceSqrTemp;
					hPlayer = hPlayerTemp;
				}
			}

			AcceptEntityInput(hEntity, "PlayerClose", "", 0.0, hPlayer);
			break;
		}
	}
}

function DumpInfected()
{
	local iCount = 0;
	local sData = "";
	local hEntity, vecPos;
	local aType = ["smoker", "boomer", "hunter", "spitter", "jockey", "charger", "witch", "tank"];

	while (hEntity = Entities.FindByClassname(hEntity, "player"))
	{
		if (!hEntity.IsSurvivor() && !hEntity.IsIncapacitated() && !NetProps.GetPropInt(hEntity, "m_iObserverMode") && !NetProps.GetPropInt(hEntity, "m_isGhost"))
		{
			local vecPos = hEntity.GetOrigin();
			sData += format("SpawnZombie(\"%s\", Vector(%.03f, %.03f, %.03f));\n", aType[hEntity.GetZombieType() - 1], vecPos.x, vecPos.y, vecPos.z);
			iCount++;
		}
	}

	hEntity = null;
	while (hEntity = Entities.FindByClassname(hEntity, "infected"))
	{
		if (hEntity.GetHealth() > 0 && NetProps.GetPropInt(hEntity, "movetype") != MOVETYPE_NONE)
		{
			local vecPos = hEntity.GetOrigin();
			sData += format("SpawnCommon(\"%s\", Vector(%.03f, %.03f, %.03f), QAngle(0.0, %.03f, 0.0));\n",
				split(NetProps.GetPropString(hEntity, "m_ModelName"), "/").top().slice(0, -4), vecPos.x, vecPos.y, vecPos.z, hEntity.GetAngles().y);
			iCount++;
		}
	}

	hEntity = null;
	while (hEntity = Entities.FindByClassname(hEntity, "witch"))
	{
		if (hEntity.GetHealth() > 0)
		{
			local vecPos = hEntity.GetOrigin();
			sData += format("SpawnZombie(\"witch\", Vector(%.03f, %.03f, %.03f), QAngle(0.0, %.03f, 0.0));\n", vecPos.x, vecPos.y, vecPos.z, hEntity.GetAngles().y);
			iCount++;
		}
	}

	if (iCount > 0)
	{
		StringToFile(__MAIN_PATH__ + "zdump.nut", sData);
		printl("[DumpInfected] Total zombies written: " + iCount);
		printf("[DumpInfected] The dump file 'left4dead2/ems/%szdump.nut' has been created", __MAIN_PATH__);
		EmitSoundOnClient("Buttons.snd4", GetHostPlayer());
	}
}

function DebugItems(sItemName = null)
{
	local iCount = 0;
	local hEntity, sModel;

	if (sItemName != null)
	{
		switch (sItemName)
		{
		case "gascan":			sModel = "models/props_junk/gascan001a.mdl";			break;
		case "propanetank":		sModel = "models/props_junk/propanecanister001a.mdl";	break;
		case "oxygentank":		sModel = "models/props_equipment/oxygentank01.mdl";		break;
		case "fireworkcrate":	sModel = "models/props_junk/explosive_box001.mdl";		break;
		case "cola_bottles":	sModel = "models/w_models/weapons/w_cola.mdl";			break;
		}
	}

	while (hEntity = Entities.Next(hEntity))
	{
		local sClass = hEntity.GetClassname();
		if ((sClass.find("weapon_") != null && sClass.find("_spawn") != null) || sClass.find("upgrade_") != null ||
			sClass == "prop_fuel_barrel" || sClass == "prop_physics" || sClass == "weapon_gascan" || sClass == "weapon_cola_bottles")
		{
			if (sModel)
			{
				if (NetProps.GetPropString(hEntity, "m_ModelName") != sModel)
					continue;
			}

			if (!NetProps.GetPropEntity(hEntity, "m_hOwner"))
			{
				if (sItemName)
				{
					if (sItemName in g_tItems)
					{
						if (NetProps.GetPropString(hEntity, "m_ModelName") != g_tItems[sItemName]["model"])
							continue;
					}
					else if (!sModel && sClass.find(sItemName) == null)
					{
						continue;
					}
					printf("[Debug Items] Specific item (idx %d) found: %s", hEntity.GetEntityIndex(), ("setpos_exact " + kvstr(hEntity.GetOrigin())));
				}

				SpawnEntityFromTable("prop_dynamic", {
					targetname = "task_debug_" + sClass
					model = "models/extras/info_speech.mdl"
					glowstate = 3
					disableshadows = 1
					origin = hEntity.GetOrigin() + Vector(0, 0, 25)
					angles = "0 " + RandomInt(0, 360) + " 0"
				});
				iCount++;
			}
		}
	}

	if (iCount > 0) SayMsg("[Debug Items] Total count: " + iCount);
	return iCount;
}

function PrintCurrentTime(sMsg = null, bTimerFormat = false)
{
	if (sMsg == null) sMsg = "";
	sayf("%s %s", sMsg, (bTimerFormat ? ToClock(g_Timer["time"]) : g_Timer["time"].tostring()));
}

function GetCurrentTime(bTimerFormat = false)
{
	return bTimerFormat ? ToClock(g_Timer["time"]) : g_Timer["time"];
}

function SetCurrentTime(flTime)
{
	if (flTime >= 0)
	{
		flTime = flTime.tofloat();
		g_Timer["start_time"] = Time() - flTime;
		g_Timer.HUD.Fields.timer_sec["dataval"] = g_Timer["time"] = flTime;
		g_Timer.HUD.Fields.timer_ms["dataval"] = split(format("%.03f", flTime), ".")[1];
		HUDSetLayout(g_Timer["HUD"]);
	}
}

function SetPreviousSegmentTime(flTime)
{
	if (flTime > 0)
	{
		g_Timer["previous_segment"] = flTime;
	}
}

function EnableLedgeHang(hPlayer)
{
	AcceptEntityInput(hPlayer, "EnableLedgeHang");
}

function DisableLedgeHang(hPlayer)
{
	AcceptEntityInput(hPlayer, "DisableLedgeHang");
}

function EnableAutoClimb()
{
	if (!IsOnTickFunctionRegistered("AutoClimb_Think"))
		RegisterOnTickFunction("AutoClimb_Think");
}

function DisableAutoClimb()
{
	if (IsOnTickFunctionRegistered("AutoClimb_Think"))
	{
		RemoveOnTickFunction("AutoClimb_Think");
		foreach (player in CollectPlayers()) RemoveScriptScopeKey(player, "auto_climb");
	}
}

function EnableAutoBileBreaker()
{
	if (!IsOnTickFunctionRegistered("AutoBileBreaker_Think"))
		RegisterOnTickFunction("AutoBileBreaker_Think");
}

function DisableAutoBileBreaker()
{
	if (IsOnTickFunctionRegistered("AutoBileBreaker_Think"))
		RemoveOnTickFunction("AutoBileBreaker_Think");
}

function AutoBoost_IsValid(hPlayer)
{
	if (!KeyInScriptScope(hPlayer, "rocketjump") && !KeyInScriptScope(hPlayer, "bileboost") && !KeyInScriptScope(hPlayer, "grenadeboost"))
	{
		if (hPlayer.IsSurvivor() && hPlayer.IsAlive() && !hPlayer.IsIncapacitated())
		{
			return true;
		}
	}
	return false;
}

function AutoBoost_IsCanShoot(hPlayer, aPlayers, hTarget, flRadius, bMethod2D, bIgnorePlayersOnGround)
{
	if (hTarget)
	{
		if (bIgnorePlayersOnGround && NetProps.GetPropEntity(hTarget, "m_hGroundEntity"))
			return false;

		return GetDistanceToEntity(hPlayer, hTarget, true, bMethod2D) < flRadius;
	}
	else
	{
		local hPlayerTemp;
		for (local i = 0; i < aPlayers.len(); i++)
		{
			hPlayerTemp = aPlayers[i];
			if (!IsPlayerABot(hPlayerTemp) && hPlayerTemp.IsAlive() && hPlayerTemp != hPlayer)
			{
				if (bIgnorePlayersOnGround && NetProps.GetPropEntity(hPlayerTemp, "m_hGroundEntity"))
					continue;

				if (GetDistanceToEntity(hPlayer, hPlayerTemp, true, bMethod2D) < flRadius)
					return true;
			}
		}
		return false;
	}
}

function AutoRocketJump(hPlayer, eAngles, flRadius = 61.0, bMethod2D = false, bDuck = true, hTarget = null, bIgnorePlayersOnGround = false)
{
	if (AutoBoost_IsValid(hPlayer))
	{
		SetScriptScopeVar(hPlayer, "rocketjump", {
			angles = eAngles.Forward()
			method = bMethod2D
			radius = (flRadius == null) ? (bMethod2D ? 625.0 : 3721.0) : flRadius * flRadius
			duck = bDuck ? IN_DUCK : 0
			ignore = bIgnorePlayersOnGround
			target = hTarget
			debug_time = 0.0
			release = false
		});
		ClientCommand(hPlayer, "use weapon_grenade_launcher");
		g_aAutoRocketJumpUsers.push(hPlayer);
	}
}

function AutoBileBoost(hPlayer, eAngles, flRadius = 80.0, bMethod2D = false, bDuck = true, bJump = false, hTarget = null, bIgnorePlayersOnGround = false)
{
	if (AutoBoost_IsValid(hPlayer))
	{
		SetScriptScopeVar(hPlayer, "bileboost", {
			angles = eAngles.Forward()
			method = bMethod2D
			radius = (flRadius == null) ? (bMethod2D ? 3600.0 : 6400.0) : flRadius * flRadius
			duck = bDuck ? IN_DUCK : 0
			jump = bJump ? IN_JUMP : 0
			ignore = bIgnorePlayersOnGround
			target = hTarget
			debug_time = 0.0
			release = false
		});
		ClientCommand(hPlayer, "use weapon_vomitjar");
		g_aAutoBileBoostUsers.push(hPlayer);
	}
}

function AutoGrenadeBoost(hPlayer, flPitch, aTargets = [], bDuck = true, bJump = false)
{
	if (AutoBoost_IsValid(hPlayer))
	{
		if (typeof aTargets == "instance") aTargets = [aTargets];
		else if (typeof aTargets != "array") return;

		local tInv = {};
		GetInvTable(hPlayer, tInv);

		SetScriptScopeVar(hPlayer, "grenadeboost", {
			angle = flPitch
			jump = bJump ? IN_JUMP : 0
			target = aTargets
		});

		if ("slot2" in tInv)
		{
			if (tInv["slot2"].GetClassname() == "weapon_molotov") ClientCommand(hPlayer, "use weapon_molotov");
			else ClientCommand(hPlayer, "use weapon_pipe_bomb");
		}

		NetProps.SetPropInt(hPlayer, "m_afButtonForced", bDuck ? IN_DUCK : 0);
		g_aAutoGrenadeBoostUsers.push(hPlayer);
	}
}

function RemoveAutoBoost(hPlayer = null)
{
	if (hPlayer)
	{
		RemoveScriptScopeKey(hPlayer, "rocketjump");
		RemoveScriptScopeKey(hPlayer, "bileboost");
		RemoveScriptScopeKey(hPlayer, "grenadeboost");

		foreach (idx, player in g_aAutoRocketJumpUsers)
		{
			if (hPlayer == player)
			{
				g_aAutoRocketJumpUsers.remove(idx);
				break;
			}
		}

		foreach (idx, player in g_aAutoBileBoostUsers)
		{
			if (hPlayer == player)
			{
				g_aAutoBileBoostUsers.remove(idx);
				break;
			}
		}

		foreach (idx, player in g_aAutoGrenadeBoostUsers)
		{
			if (hPlayer == player)
			{
				g_aAutoGrenadeBoostUsers.remove(idx);
				break;
			}
		}

		NetProps.SetPropInt(hPlayer, "m_afButtonForced", NetProps.GetPropInt(hPlayer, "m_afButtonForced") & ~(IN_ATTACK | IN_DUCK));
		return;
	}
	
	g_aAutoRocketJumpUsers.clear();
	g_aAutoBileBoostUsers.clear();
	g_aAutoGrenadeBoostUsers.clear();

	foreach (player in CollectPlayers())
	{
		RemoveScriptScopeKey(player, "rocketjump");
		RemoveScriptScopeKey(player, "bileboost");
		RemoveScriptScopeKey(player, "grenadeboost");

		NetProps.SetPropInt(player, "m_afButtonForced", NetProps.GetPropInt(player, "m_afButtonForced") & ~(IN_ATTACK | IN_DUCK));
	}
}

function AutoClimb_Think()
{
	local hPlayer;
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		if (hPlayer.IsSurvivor())
		{
			if (!KeyInScriptScope(hPlayer, "auto_climb"))
			{
				SetScriptScopeVar(hPlayer, "auto_climb", {
					on_ladder = false
					direction = null
				});
			}

			local idx = hPlayer.GetEntityIndex();
			local tParams = GetScriptScopeVar(hPlayer, "auto_climb");

			if (NetProps.GetPropInt(hPlayer, "m_MoveType") == MOVETYPE_LADDER)
			{
				if (!tParams["on_ladder"])
				{
					local hLadder, hLadderTemp, flDistanceSqrTemp;
					local vecPos = hPlayer.GetOrigin();
					local flDistanceSqr = 1e9;

					while (hLadderTemp = Entities.FindByClassname(hLadderTemp, "func_simpleladder"))
					{
						local vecOrigin = VectorLerp(NetProps.GetPropVector(hLadderTemp, "m_Collision.m_vecMins"), NetProps.GetPropVector(hLadderTemp, "m_Collision.m_vecMaxs"), 0.5);
						if ((flDistanceSqrTemp = (vecOrigin - vecPos).LengthSqr()) < flDistanceSqr)
						{
							flDistanceSqr = flDistanceSqrTemp;
							hLadder = hLadderTemp;
						}
					}

					if (!hLadder) continue;

					local vecNormal = NetProps.GetPropVector(hLadder, "m_climbableNormal");
					local eAngles = VectorToQAngle(vecNormal);

					eAngles.x = 90.0;
					eAngles.y -= 90.0;

					tParams["on_ladder"] = true;
					tParams["direction"] = eAngles.Forward();

					if (g_bAutoClimb[idx] && g_iClimbDirection[idx])
					{
						SendToConsole("sm_input " + hPlayer.GetEntityIndex() + " " + (g_iClimbDirection[idx] == 1 ? IN_BACK | IN_MOVELEFT : IN_FORWARD | IN_MOVERIGHT));
					}
				}

				if (g_iClimbDirection[idx])
				{
					hPlayer.SetForwardVector(tParams["direction"]);
				}

				continue;
			}
			else if (tParams["on_ladder"])
			{
				SendToConsole("sm_input " + hPlayer.GetEntityIndex() + " 0");
			}

			tParams["on_ladder"] = false;
		}
	}
}

function AutoBileBreaker_Think()
{
	local hEntity;
	while (hEntity = Entities.FindByClassname(hEntity, "vomitjar_projectile"))
	{
		if (!KeyInScriptScope(hEntity, "auto_bile_breaker"))
		{
			SetScriptScopeVar(hEntity, "auto_bile_breaker", {
				distance = (1 << 30)
			});
			g_aBilesToProcess.push(hEntity);
		}
	}

	for (local i = 0; i < g_aBilesToProcess.len(); i++)
	{
		if ((hEntity = g_aBilesToProcess[i]).IsValid())
		{
			local hPlayer;
			local bThrowerOnly = true;
			local bAtleastOnceProcessed = false;
			local tScope = GetScriptScopeVar(hEntity, "auto_bile_breaker");

			while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
			{
				if (NetProps.GetPropEntity(hEntity, "m_hThrower") != hPlayer)
				{
					bThrowerOnly = false;
					if (hPlayer.IsSurvivor() && hPlayer.IsAlive())
					{
						local flDistanceSqr = (hEntity.GetOrigin() - hPlayer.GetOrigin()).LengthSqr();

						if (flDistanceSqr < tScope["distance"])
						{
							tScope["distance"] = flDistanceSqr;
							bAtleastOnceProcessed = true;
						}

						if (tScope["distance"] <= 10)
						{
							bAtleastOnceProcessed = false;
							break;
						}
					}
				}
			}

			if (tScope["distance"] > 4900 || bAtleastOnceProcessed || bThrowerOnly)
				continue;

			SpawnBileEffect(hEntity.GetOrigin());
			hEntity.Kill();
		}
		
		g_aBilesToProcess.remove(i);
		i--;
	}
}

function AutoBoost_Think()
{
	if (g_aAutoRocketJumpUsers.len() > 0 || g_aAutoBileBoostUsers.len() > 0)
	{
		local hPlayer;
		local aPlayers = [];

		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			if (hPlayer.IsSurvivor() && hPlayer.IsAlive())
			{
				aPlayers.push(hPlayer);
			}
		}

		for (local i = 0; i < g_aAutoRocketJumpUsers.len(); i++)
		{
			if ((hPlayer = g_aAutoRocketJumpUsers[i]).IsValid())
			{
				local tParams = GetScriptScopeVar(hPlayer, "rocketjump");
				if (!tParams["release"])
				{
					TP(hPlayer, null, tParams["angles"], null, true);

					if (AutoBoost_IsCanShoot(hPlayer, aPlayers, tParams["target"], tParams["radius"], tParams["method"], tParams["ignore"]))
					{
						NetProps.SetPropInt(hPlayer, "m_afButtonForced", IN_ATTACK | tParams["duck"]);

						CreateTimer(0.01, function(hPlayer){
							if (hPlayer.IsValid()) NetProps.SetPropInt(hPlayer, "m_afButtonForced", 0);
						}, hPlayer);

						tParams["debug_time"] = Time() + 0.5;
						tParams["release"] = true;
						continue;
					}

					NetProps.SetPropInt(hPlayer, "m_afButtonForced", tParams["duck"]);
					continue;
				}
				if (tParams["debug_time"] > Time())
				{
					for (local l = 0; l < aPlayers.len(); l++)
					{
						local hEntity;
						if (hEntity = NetProps.GetPropEntity(aPlayers[l], "m_hGroundEntity"))
						{
							if (NetProps.GetPropEntity(hEntity, "m_hThrower") == hPlayer && hEntity.GetClassname() == "grenade_launcher_projectile")
							{
								if (!NetProps.GetPropVector(aPlayers[l], "m_vecBaseVelocity").IsZero())
								{
									local flGainedSpeed = NetProps.GetPropVector(aPlayers[l], "m_vecBaseVelocity").Length();
									local flGainedSpeed2D = NetProps.GetPropVector(aPlayers[l], "m_vecBaseVelocity").Length2D();

									printl("----------- Auto Rocketjump -----------");
									printf("Player (idx): %d\nBooster (idx): %d\nAngles: %s\nGained speed: %.03f\nGained speed 2D: %.03f",
										aPlayers[l].GetEntityIndex(),
										hPlayer.GetEntityIndex(),
										kvstr(VectorToQAngle(tParams["angles"])),
										flGainedSpeed,
										flGainedSpeed2D);
									printl("--------------------------------------");

									if ("OnRocketJumpCompleted" in ::Callbacks)
										::Callbacks.OnRocketJumpCompleted(aPlayers[l], hPlayer, flGainedSpeed, flGainedSpeed2D);

									RemoveScriptScopeKey(hPlayer, "rocketjump");

									g_aAutoRocketJumpUsers.remove(i);
									i--;
									continue;
								}
							}
						}
					}
					continue;
				}
				RemoveScriptScopeKey(hPlayer, "rocketjump");
			}
			g_aAutoRocketJumpUsers.remove(i);
			i--;
		}

		for (local j = 0; j < g_aAutoBileBoostUsers.len(); j++)
		{
			if ((hPlayer = g_aAutoBileBoostUsers[j]).IsValid())
			{
				local tParams = GetScriptScopeVar(hPlayer, "bileboost");
				if (!tParams["release"])
				{
					TP(hPlayer, null, tParams["angles"], null, true);

					if (AutoBoost_IsCanShoot(hPlayer, aPlayers, tParams["target"], tParams["radius"], tParams["method"], tParams["ignore"]))
					{
						NetProps.SetPropInt(hPlayer, "m_afButtonForced", tParams["jump"] | tParams["duck"]);

						CreateTimer(0.25, function(hPlayer){
							if (hPlayer.IsValid()) NetProps.SetPropInt(hPlayer, "m_afButtonForced", 0);
						}, hPlayer);

						tParams["debug_time"] = Time() + 0.5;
						tParams["release"] = true;
						continue;
					}

					NetProps.SetPropInt(hPlayer, "m_afButtonForced", IN_ATTACK | tParams["duck"]);
					continue;
				}
				if (tParams["debug_time"] > Time())
				{
					for (local l = 0; l < aPlayers.len(); l++)
					{
						local hEntity;
						if (hEntity = NetProps.GetPropEntity(aPlayers[l], "m_hGroundEntity"))
						{
							if (NetProps.GetPropEntity(hEntity, "m_hThrower") == hPlayer && hEntity.GetClassname() == "vomitjar_projectile")
							{
								if (!NetProps.GetPropVector(aPlayers[l], "m_vecBaseVelocity").IsZero())
								{
									local flGainedSpeed = NetProps.GetPropVector(aPlayers[l], "m_vecBaseVelocity").Length();
									local flGainedSpeed2D = NetProps.GetPropVector(aPlayers[l], "m_vecBaseVelocity").Length2D();

									printl("----------- Auto Bileboost -----------");
									printf("Player (idx): %d\nBooster (idx): %d\nAngles: %s\nGained speed: %.03f\nGained speed 2D: %.03f",
										aPlayers[l].GetEntityIndex(),
										hPlayer.GetEntityIndex(),
										kvstr(VectorToQAngle(tParams["angles"])),
										flGainedSpeed,
										flGainedSpeed2D);
									printl("--------------------------------------");

									if ("OnBileBoostCompleted" in ::Callbacks)
										::Callbacks.OnBileBoostCompleted(aPlayers[l], hPlayer, flGainedSpeed, flGainedSpeed2D);

									RemoveScriptScopeKey(hPlayer, "bileboost");

									g_aAutoBileBoostUsers.remove(j);
									j--;
									continue;
								}
							}
						}
					}
					continue;
				}
				RemoveScriptScopeKey(hPlayer, "bileboost");
			}
			g_aAutoBileBoostUsers.remove(j);
			j--;
		}
	}
}

function RecordCI_Think()
{
	local hEntity;
	local bProcessed = false;
	local sData = "@" + (Time() - tCommonInfectedRecorder["flStartTime"]) + ":\n";

	while (hEntity = Entities.FindByClassname(hEntity, "infected"))
	{
		if (!KeyInScriptScope(hEntity, "recorded"))
		{
			bProcessed = true;
			SetScriptScopeVar(hEntity, "recorded", true);

			local vecPos = hEntity.GetOrigin();
			sData += format("SpawnCommon(\"%s\",Vector(%.03f, %.03f, %.03f),QAngle(0.0, %.03f, 0.0));\n",
				split(NetProps.GetPropString(hEntity, "m_ModelName"), "/").top().slice(0, -4), vecPos.x, vecPos.y, vecPos.z, hEntity.GetAngles().y);
		}
	}

	if (bProcessed)
	{
		tCommonInfectedRecorder["buffer"] += sData;
	}
}

function TimescaleListener()
{
	local t = 10 * (1.0 / cvar("host_timescale", null, false));
	if (t != cvar("sv_player_stuck_tolerance", null, false))
		cvar("sv_player_stuck_tolerance", t);
}

RegisterOnTickFunction("AutoClimb_Think");
RegisterOnTickFunction("AutoBoost_Think");
RegisterOnTickFunction("TimescaleListener");

HookEvent("weapon_fire", __tGameEventsListener.OnWeaponFire, __tGameEventsListener);
HookEvent("tank_spawn", __tGameEventsListener.OnTankSpawn, __tGameEventsListener);
HookEvent("finale_start", __tGameEventsListener.OnFinaleStart, __tGameEventsListener);
