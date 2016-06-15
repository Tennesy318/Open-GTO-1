/*

	About: money system
	Author:	ziggi

*/

#if defined _pl_money_included
	#endinput
#endif

#define _pl_money_included

/*
	Vars
*/

static
	gPlayerMoney[MAX_PLAYERS];

/*
	Functions
*/

stock SetPlayerMoney(playerid, money)
{
	gPlayerMoney[playerid] = money;
	SetPlayerMoneyTextDraw(playerid, money);
}

stock REDEF_GivePlayerMoney(playerid, money)
{
	if (money == 0) {
		return 1;
	}

	new player_money = GetPlayerMoney(playerid);

	if (money + player_money < 0) {
		return 0;
	}

	if (money > MAX_MONEY - player_money) {
		money = MAX_MONEY - player_money;
		Log_Game("player: %s(%d): is on max money", ReturnPlayerName(playerid), playerid);
	}

	GivePlayerMoneyTextDraw(playerid, money);
	SetPlayerMoney(playerid, player_money + money);
	return 1;
}

stock REDEF_GetPlayerMoney(playerid)
{
	return gPlayerMoney[playerid];
}
