/*

	About: money admin command
	Author: ziggi

*/

#if defined _admin_cmd_money_included
	#endinput
#endif

#define _admin_cmd_money_included
#pragma library admin_cmd_money

COMMAND:money(playerid, params[])
{
	if (!IsPlayerAdm(playerid)) {
		return 0;
	}

	new
		subcmd[5],
		subparams[32],
		amount;

	if (sscanf(params, "s[5]s[32]I(0)", subcmd, subparams, amount)) {
		SendClientMessage(playerid, COLOR_RED, _(ADMIN_COMMAND_MONEY_HELP));
		return 1;
	}

	new
		targetid = INVALID_PLAYER_ID;

	if (strcmp(subparams, "all", true) == 0) {
		targetid = -1;
	} else if (sscanf(subparams, "u", targetid)) {
		SendClientMessage(playerid, -1, _(ADMIN_COMMAND_MONEY_TARGET_ERROR));
		return 1;
	}

	new
		string[MAX_LANG_VALUE_STRING],
		targetname[MAX_PLAYER_NAME + 1],
		playername[MAX_PLAYER_NAME + 1];

	GetPlayerName(playerid, playername, sizeof(playername));

	if (targetid != -1) {
		GetPlayerName(targetid, targetname, sizeof(targetname));
	}

	if (strcmp(subcmd, "set", true) == 0) {
		if (targetid == -1) {
			foreach (new id : Player) {
				SetPlayerMoney(id, amount);
			}

			format(string, sizeof(string), _(ADMIN_COMMAND_MONEY_SET_ALL), playername, playerid, amount);
			SendClientMessageToAll(-1, string);
		} else {
			SetPlayerMoney(targetid, amount);

			format(string, sizeof(string), _(ADMIN_COMMAND_MONEY_SET_PLAYER), playername, playerid, amount);
			SendClientMessage(targetid, -1, string);
		}
	} else if (strcmp(subcmd, "get", true) == 0) {
		if (!IsPlayerConnected(targetid)) {
			SendClientMessage(playerid, -1, _(ADMIN_COMMAND_MONEY_TARGET_ERROR));
			return 1;
		}

		amount = GetPlayerMoney(targetid);

		format(string, sizeof(string), _(ADMIN_COMMAND_MONEY_GET), targetname, targetid, amount);
		SendClientMessage(playerid, -1, string);
	} else if (strcmp(subcmd, "give", true) == 0) {
		if (targetid == -1) {
			foreach (new id : Player) {
				GivePlayerMoney(id, amount);
			}

			format(string, sizeof(string), _(ADMIN_COMMAND_MONEY_GIVE_ALL), playername, playerid, amount);
			SendClientMessageToAll(-1, string);
		} else {
			GivePlayerMoney(targetid, amount);

			format(string, sizeof(string), _(ADMIN_COMMAND_MONEY_GIVE_PLAYER), playername, playerid, amount);
			SendClientMessage(targetid, -1, string);
		}
	}

	return 1;
}