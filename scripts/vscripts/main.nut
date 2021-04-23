// Squirrel

//SkipIntro(); // skip intro of a custom campaign if such is defined

SetPreviousSegmentTime(0.0); // put here (instead of '0.0') the time you got from the previous segment(s); for example: 129.133

Cvars <- // console variables manager; format: cvar_name = value(string or number)
{
	mp_gamemode = "Coop"
	z_difficulty = "Easy"

	director_no_bosses = 0
	director_no_mobs = 0
	director_no_specials = 0

	god = 0
	z_common_limit = 30
	sv_infinite_ammo = 0
	host_timescale = 1.0

	sb_stop = 0
	nb_blind = 0
	nb_stop = 0
};

Survivors <- {}; // characters customization

Survivors["coach"] <- // make sure that the character name is in lowercase
{
	origin = null // position; format (for velocity too):  Vector( 0, 0, 0 )
	angles = null // camera angles; format:  QAngle( 0, 0, 0 )
	velocity = null // make a value 'null' if you don't want to apply anything or just remove a specified parameter

	health = 100
	buffer = 0.0 // temporary health
	revives = null // count of revives (2 - black&white)
	idle = false // doesn't work without Speedrunner Tools (SourceMod) except the host player

	Inventory =
	{
		active_slot = "slot1"
		
		slot0 = // primary weapon
		{
			weapon = "rifle"
			clip = 50
			ammo = 100
			upgrade_type = UPGRADE_INCENDIARY_AMMO // UPGRADE_INCENDIARY_AMMO, UPGRADE_EXPLOSIVE_AMMO or UPGRADE_LASER_SIGHT (don't apply 'upgrade_clip' if you use laser sight only)
			upgrade_clip = 35 // 'upgrade_clip' should be less than or equal to 'clip' !!
		}

		slot1 = // secondary weapon
		{
			weapon = "pistol_magnum"
			dual = false
			clip = 5
		}

		slot2 = "pipe_bomb" // throwable
		slot3 = "first_aid_kit" // medkit/defib
		slot4 = "pain_pills" // pills/adrenaline
		//slot5 = "gascan" // physics objects
	}

	Actions = function(hPlayer)
	{
		// do some stuff here
	}
}

Survivors["ellis"] <- // just copypaste the Coach's table params to extend settings of these survivors
{
	health = 100
}

Survivors["nick"] <- // for L4D survivors use their names: coach -> louis, ellis -> francis, nick -> bill, rochelle -> zoey
{
	health = 100
}

Survivors["rochelle"] <-
{
	health = 100
}

function OnTriggerTouch()
{
	if (activator && activator.IsSurvivor() && !g_bRestarting)
	{
		// sName - name of a trigger
		// activator - player who activated a trigger
		local sName = caller.GetName();
		if (sName == "trigger_area1")
		{

		}
		else if (sName == "trigger_area2")
		{
			
		}
	}
}

function Callbacks::OnGameplayStart() // do some stuff when the round has started
{
	
}

function Callbacks::OnSpeedrunStart() // do some stuff when the countdown is over
{
	cvar("host_timescale", 0.5);
}

function Callbacks::OnSpeedrunRestart() // do some stuff when the speedrun is about to restart
{
	
}

function Callbacks::OnFinaleStart() // do some stuff when the finale has been started
{

}

function Callbacks::OnFinalePause() // called during pause stage of panic event in the finale
{
	
}

function Callbacks::OnLastTankKilled() // called after killing a specified amount of Tanks in the finale (FinaleManager.Settings.MaxTanksInFinale)
{

}

function Callbacks::OnRocketJumpCompleted(hPlayer, hBooster, flGainedSpeed, flGainedSpeed2D)
{

}

function Callbacks::OnBileBoostCompleted(hPlayer, hBooster, flGainedSpeed, flGainedSpeed2D)
{

}

function Callbacks::OnSpitterBoostCompleted(hPlayer, hSpitter, flGainedSpeed, flGainedSpeed2D)
{

}

function Callbacks::OnBeginCustomStage(iNum, iType)
{
	local ERROR = -1;
	local PANIC = 0;
	local TANK = 1;
	local DELAY = 2;
	local SCRIPTED = 3;

	if (iType == PANIC)
	{

	}
	else if (iType == TANK)
	{

	}
	else if (iType == DELAY)
	{

	}
}
