// Squirrel
// Skip Intro

function __SkipIntro()
{
	if (g_bBeginMap)
	{
		switch (SessionState["MapName"])
		{
		case "c1m1_hotel":
			EntFire("sound_chopperleave", "Kill");
			EntFire("rescue_chopper", "Kill");
			EntFire("lcs_intro", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("director", "FinishIntro", null, 0.1);
			EntFire("director", "ReleaseSurvivorPositions", null, 0.1);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c2m1_highway":
			EntFire("lcs_intro", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("director", "FinishIntro", null, 0.1);
			EntFire("director", "ReleaseSurvivorPositions", null, 0.1);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c3m1_plankcountry":
			EntFire("lcs_intro", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("director", "ReleaseSurvivorPositions", null, 0.1);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c4m1_milltown_a":
			EntFire("PugTug", "Kill");
			EntFire("@skybox_PugTug", "Kill");
			EntFire("lcs_intro", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("@director", "FinishIntro", null, 0.1);
			EntFire("@director", "ReleaseSurvivorPositions", null, 0.1);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c5m1_waterfront":
			EntFire("orator", "Kill");
			EntFire("tug_boat_intro", "Kill");
			EntFire("@skybox_tug_boat_intro", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("director", "FinishIntro", null, 0.1);
			EntFire("director", "ReleaseSurvivorPositions", null, 0.1);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c6m1_riverbank":
			EntFire("@director", "FinishIntro");
			EntFire("@director", "AddOutput", "targetname director_temp");
			EntFire("director_temp", "AddOutput", "targetname @director", 0.1);
			EntFire("fade_intro", "Kill");
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c7m1_docks":
			EntFire("civilian_gunfire", "Kill");
			EntFire("intro_killer", "Kill");
			EntFire("intro_train_steam1", "Kill");
			EntFire("intro_train_steam2", "Kill");
			EntFire("intro_train_steam3", "Kill");
			EntFire("train", "AddOutput", "origin 13168.001, 2768.000, 50.000");
			EntFire("infected_chase", "Kill");
			EntFire("infected_spawner", "Kill");
			EntFire("fade_outro_1", "Kill");
			EntFire("fade_outro_4", "Kill");
			EntFire("director", "ReleaseSurvivorPositions", null, 0.1);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c8m1_apartment":
			EntFire("lcs_intro_survivors", "Kill");
			EntFire("tarp_sound", "Kill");
			EntFire("tarp_animated", "Kill");
			EntFire("ghostAnim", "Kill");
			EntFire("sound_chopper", "Kill");
			EntFire("helicopter_speaker", "Kill");
			EntFire("helicopter_animated", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("director", "FinishIntro", null, 0.3);
			EntFire("director", "ReleaseSurvivorPositions", null, 0.3);
			EntFire("camera_intro_airplane", "Kill");
			break;

		case "c9m1_alleys":
			EntFire("lcs_intro", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("@director", "FinishIntro", null, 0.1);
			EntFire("@director", "ReleaseSurvivorPositions", null, 0.1);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c10m1_caves":
			EntFire("lcs_intro", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("director", "FinishIntro", null, 0.3);
			EntFire("director", "ReleaseSurvivorPositions", null, 0.3);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c11m1_greenhouse":
			EntFire("light_hanging03", "AddOutput", "targetname ");
			EntFire("light_hanging02", "AddOutput", "targetname ");
			EntFire("light_hanging01", "AddOutput", "targetname ");
			EntFire("greenhouse_panel02", "Kill");
			EntFire("greenhouse_panel01", "Kill");
			EntFire("greenhouse_particles", "Kill");
			EntFire("sound_airplane_intro", "Kill");
			EntFire("airplane_animated_intro", "Kill");
			EntFire("lcs_intro_airport_01", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("director", "FinishIntro", null, 0.3);
			EntFire("director", "ReleaseSurvivorPositions", null, 0.3);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c12m1_hilltop":
			EntFire("lcs_intro", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("director", "FinishIntro", null, 0.3);
			EntFire("director", "ReleaseSurvivorPositions", null, 0.3);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;

		case "c13m1_alpinecreek":
			EntFire("gamesound", "PlaySound");
			EntFire("lcs_intro", "Kill");
			EntFire("scene_relay", "Kill");
			EntFire("b_Signboard01", "Kill");
			EntFire("fade_intro", "Kill");
			EntFire("director", "FinishIntro", null, 0.1);
			EntFire("director", "ReleaseSurvivorPositions", null, 0.1);
			EntFire("point_viewcontrol_survivor", "Kill");
			break;
		}
	}
	else
	{
		switch (SessionState["MapName"])
		{
		case "uf1_boulevard":
			EntFire("fade_intro", "Kill");
			EntFire("director", "FinishIntro", null, 0.1);
			EntFire("director", "ReleaseSurvivorPositions", null, 0.1);
			EntFire("point_viewcontrol_survivor", "Kill");
			EntFire("intro_window_zombie", "Kill");
			EntFire("carsplode_relay", "Kill");
			EntFire("intro_chopper_sound", "Kill");
			EntFire("intro_chopper_mover", "Kill");
			EntFire("gateRestaurantFront_Broken", "Kill"); // The RNG way killer
			EntFire("gateRestaurantFront_Intact", "Kill");
			EntFire("gateRestaurantFront_Doors", "Kill");
			break;
		}
	}
}

function SkipIntro()
{
	EntFire("camera_intro_airplane", "Disable", null, 0.1);
	EntFire("airplane_animated_intro", "Kill");
	EntFire("env_fade", "AddOutput", "duration 0");
	EntFire("env_fade", "Fade");
	EntFire("env_fade", "Kill", null, 1.0);
	EntFire("director", "FinishIntro", null, 0.1);
	EntFire("director", "FinishIntro", null, 0.3);
	EntFire("director", "ReleaseSurvivorPositions", null, 0.1);
	EntFire("@director", "FinishIntro", null, 0.1);
	EntFire("@director", "ReleaseSurvivorPositions", null, 0.1);
	EntFire("point_viewcontrol_survivor", "Disable", null, 0.1);
}
