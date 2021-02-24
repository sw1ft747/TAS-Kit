// SourcePawn
// Input Emulator

#include <sourcemod>
#include <sdktools>

#define MAXSPEED 450.0

int g_fButtons[MAXPLAYERS + 1] = {0, ...};

public Plugin myinfo =
{
	name = "Input Emulator",
	author = "Sw1ft",
	description = "Input Emulator for L4D2",
	version = "1.0",
	url = "http://steamcommunity.com/profiles/76561198397776991"
}

public void OnPluginStart()
{
	if (GetEngineVersion() != Engine_Left4Dead2)
	{
		PrintToChatAll("[Input Emulator] Plugin supports only L4D2 engine");
		return;
	}
	HookEvent("player_disconnect", OnPlayerDisconnect);
	RegConsoleCmd("sm_input", InputEmulator);
}

public Action InputEmulator(int client, int args)
{
	if (args >= 2)
	{
		int buttons, idx;
		char sArgument[32];

		GetCmdArg(1, sArgument, sizeof(sArgument));
		idx = StringToInt(sArgument);

		GetCmdArg(2, sArgument, sizeof(sArgument));
		buttons = StringToInt(sArgument);

		g_fButtons[Clamp(idx, 0, MAXPLAYERS)] = buttons;
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3])
{
	if (IsClientInGame(client) && IsPlayerAlive(client))
	{
		if (g_fButtons[client])
		{
			float flVelocity[2];
			int mask = g_fButtons[client];

			if (mask & IN_FORWARD) flVelocity[0] += MAXSPEED;
			if (mask & IN_BACK) flVelocity[0] -= MAXSPEED;
			if (mask & IN_MOVERIGHT) flVelocity[1] += MAXSPEED;
			if (mask & IN_MOVELEFT) flVelocity[1] -= MAXSPEED;

			if (flVelocity[0] != 0.0 || flVelocity[1] != 0.0)
			{
				vel[0] = flVelocity[0];
				vel[1] = flVelocity[1];
			}
			
			buttons |= mask;
		}
	}

	return Plugin_Continue;
}

public OnPlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	g_fButtons[client] = 0;
}

int Clamp(int n, int min, int max)
{
	return n < min ? min : (n > max ? max : n);
}