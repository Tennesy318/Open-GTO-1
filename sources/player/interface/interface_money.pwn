/*

	About: money interface system
	Author:	ziggi

*/

#if defined _player_money_int_included
	#endinput
#endif

#define _player_money_int_included

/*
	Vars
*/

static
	gGiveTimer[MAX_PLAYERS];

/*
	Callbacks
*/

/*
	OnPlayerConnect
*/

public OnPlayerConnect(playerid)
{
	PlayerMoneyTD_CreateTextDraw(playerid);

	#if defined PlayerMoneyTD_OnPlayerConnect
		return PlayerMoneyTD_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect PlayerMoneyTD_OnPlayerConnect
#if defined PlayerMoneyTD_OnPlayerConnect
	forward PlayerMoneyTD_OnPlayerConnect(playerid);
#endif

/*
	OnPlayerDisconnect
*/

public OnPlayerDisconnect(playerid, reason)
{
	PlayerMoneyTD_DestroyTextDraw(playerid);

	#if defined PMoneyTD_OnPlayerDisconnect
		return PMoneyTD_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect PMoneyTD_OnPlayerDisconnect
#if defined PMoneyTD_OnPlayerDisconnect
	forward PMoneyTD_OnPlayerDisconnect(playerid, reason);
#endif

/*
	OnPlayerSpawn
*/

public OnPlayerSpawn(playerid)
{
	PlayerMoneyTD_Show(playerid);

	#if defined PlayerMoneyTD_OnPlayerSpawn
		return PlayerMoneyTD_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif

#define OnPlayerSpawn PlayerMoneyTD_OnPlayerSpawn
#if defined PlayerMoneyTD_OnPlayerSpawn
	forward PlayerMoneyTD_OnPlayerSpawn(playerid);
#endif

/*
	OnPlayerInterfaceChanged
*/

public OnPlayerInterfaceChanged(playerid, PlayerInterface:componentid, PlayerInterfaceParams:paramid, oldvalue, newvalue)
{
	if (!PlayerMoneyTD_IsValidComponent(componentid)) {
	#if defined PlayerMoneyTD_OnPlayerIntChng
		return PlayerMoneyTD_OnPlayerIntChng(playerid, componentid, paramid, oldvalue, newvalue);
	#else
		return 1;
	#endif
	}

	if (paramid == PIP_Visible) {
		new
			PlayerText:td_temp;

		td_temp = PlayerText:GetPlayerInterfaceParam(playerid, componentid, PIP_TextDraw);

		if (newvalue) {
			if (componentid == PI_MoneyMoney) {
				PlayerMoneyTD_UpdateString(playerid, GetPlayerMoney(playerid));
			}

			switch (componentid) {
				case PI_MoneyPlus: {
					if (gGiveTimer[playerid] != 0) {
						PlayerTextDrawShow(playerid, td_temp);
					}
				}
				default: {
					PlayerTextDrawShow(playerid, td_temp);
				}
			}
		} else {
			PlayerTextDrawHide(playerid, td_temp);
		}
	}

	#if defined PlayerMoneyTD_OnPlayerIntChng
		return PlayerMoneyTD_OnPlayerIntChng(playerid, componentid, paramid, oldvalue, newvalue);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerInterfaceChanged
	#undef OnPlayerInterfaceChanged
#else
	#define _ALS_OnPlayerInterfaceChanged
#endif

#define OnPlayerInterfaceChanged PlayerMoneyTD_OnPlayerIntChng
#if defined PlayerMoneyTD_OnPlayerIntChng
	forward PlayerMoneyTD_OnPlayerIntChng(playerid, PlayerInterface:componentid, PlayerInterfaceParams:paramid, oldvalue, newvalue);
#endif

/*
	Functions
*/

stock PlayerMoneyTD_CreateTextDraw(playerid)
{
	new
		PlayerText:td_temp;

	td_temp = CreatePlayerTextDraw(playerid, 622.705993, 78.500000, "border");
	PlayerTextDrawLetterSize(playerid, td_temp, 0.000000, 3.060781);
	PlayerTextDrawTextSize(playerid, td_temp, 494.470367, 0.000000);
	PlayerTextDrawAlignment(playerid, td_temp, 1);
	PlayerTextDrawColor(playerid, td_temp, 0);
	PlayerTextDrawUseBox(playerid, td_temp, true);
	PlayerTextDrawBoxColor(playerid, td_temp, -5963726);
	PlayerTextDrawSetShadow(playerid, td_temp, 137);
	PlayerTextDrawSetOutline(playerid, td_temp, 0);
	PlayerTextDrawFont(playerid, td_temp, 0);

	SetPlayerInterfaceParam(playerid, PI_MoneyBorder, PIP_TextDraw, td_temp);

	td_temp = CreatePlayerTextDraw(playerid, 622.117553, 79.916656, "background");
	PlayerTextDrawLetterSize(playerid, td_temp, 0.000000, 2.776468);
	PlayerTextDrawTextSize(playerid, td_temp, 495.529388, 76.999984);
	PlayerTextDrawAlignment(playerid, td_temp, 1);
	PlayerTextDrawColor(playerid, td_temp, -1);
	PlayerTextDrawUseBox(playerid, td_temp, true);
	PlayerTextDrawBoxColor(playerid, td_temp, 286331391);
	PlayerTextDrawSetShadow(playerid, td_temp, 0);
	PlayerTextDrawSetOutline(playerid, td_temp, 88);
	PlayerTextDrawBackgroundColor(playerid, td_temp, -572662273);
	PlayerTextDrawFont(playerid, td_temp, 1);

	SetPlayerInterfaceParam(playerid, PI_MoneyBackground, PIP_TextDraw, td_temp);

	td_temp = CreatePlayerTextDraw(playerid, 615.0, 82.0, " ");
	PlayerTextDrawLetterSize(playerid, td_temp, 0.44, 2.16);
	PlayerTextDrawAlignment(playerid, td_temp, 3);
	PlayerTextDrawColor(playerid, td_temp, -1);
	PlayerTextDrawSetShadow(playerid, td_temp, 0);
	PlayerTextDrawSetOutline(playerid, td_temp, 0);
	PlayerTextDrawBackgroundColor(playerid, td_temp, 51);
	PlayerTextDrawFont(playerid, td_temp, 1);
	PlayerTextDrawSetProportional(playerid, td_temp, 1);

	SetPlayerInterfaceParam(playerid, PI_MoneyMoney, PIP_TextDraw, td_temp);

	td_temp = CreatePlayerTextDraw(playerid, 615.0, 106.0, " ");
	PlayerTextDrawLetterSize(playerid, td_temp, 0.44, 2.16);
	PlayerTextDrawAlignment(playerid, td_temp, 3);
	PlayerTextDrawColor(playerid, td_temp, -1);
	PlayerTextDrawSetShadow(playerid, td_temp, 0);
	PlayerTextDrawSetOutline(playerid, td_temp, 1);
	PlayerTextDrawBackgroundColor(playerid, td_temp, 0x00000033);
	PlayerTextDrawFont(playerid, td_temp, 1);
	PlayerTextDrawSetProportional(playerid, td_temp, 1);

	SetPlayerInterfaceParam(playerid, PI_MoneyPlus, PIP_TextDraw, td_temp);
}

stock PlayerMoneyTD_DestroyTextDraw(playerid)
{
	PlayerMoneyTD_Hide(playerid);

	PlayerTextDrawDestroy(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyBorder, PIP_TextDraw));
	PlayerTextDrawDestroy(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyBackground, PIP_TextDraw));
	PlayerTextDrawDestroy(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyMoney, PIP_TextDraw));
	PlayerTextDrawDestroy(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyPlus, PIP_TextDraw));
}

stock PlayerMoneyTD_IsValidComponent(PlayerInterface:componentid)
{
	switch (componentid) {
		case PI_MoneyBorder, PI_MoneyBackground, PI_MoneyMoney, PI_MoneyPlus: {
			return 1;
		}
	}
	return 0;
}

stock PlayerMoneyTD_Show(playerid)
{
	if (GetPlayerInterfaceParam(playerid, PI_MoneyBorder, PIP_Visible) && IsPlayerInterfaceVisible(playerid)) {
		PlayerTextDrawShow(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyBorder, PIP_TextDraw));
	}
	if (GetPlayerInterfaceParam(playerid, PI_MoneyBackground, PIP_Visible) && IsPlayerInterfaceVisible(playerid)) {
		PlayerTextDrawShow(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyBackground, PIP_TextDraw));
	}
	if (GetPlayerInterfaceParam(playerid, PI_MoneyMoney, PIP_Visible) && IsPlayerInterfaceVisible(playerid)) {
		PlayerTextDrawShow(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyMoney, PIP_TextDraw));
	}
}

stock PlayerMoneyTD_Hide(playerid)
{
	PlayerTextDrawHide(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyBorder, PIP_TextDraw));
	PlayerTextDrawHide(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyBackground, PIP_TextDraw));
	PlayerTextDrawHide(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyMoney, PIP_TextDraw));
}

stock PlayerMoneyTD_UpdateString(playerid, value)
{
	if (!GetPlayerInterfaceParam(playerid, PI_MoneyMoney, PIP_Visible) || !IsPlayerInterfaceVisible(playerid)) {
		return;
	}

	new PlayerText:td_money = PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyMoney, PIP_TextDraw);

	if (value < 0) {
		PlayerTD_Update(playerid, td_money, 0xDD0000FF, -value, .prefix = "-$");
	} else {
		PlayerTD_Update(playerid, td_money, 0xFFFFFFFF, value, .prefix = "$");
	}
}

stock PlayerMoneyTD_Give(playerid, value)
{
	if (!GetPlayerInterfaceParam(playerid, PI_MoneyPlus, PIP_Visible) || !IsPlayerInterfaceVisible(playerid)) {
		return;
	}

	if (value == 0) {
		return;
	}

	new PlayerText:td_money_plus = PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyPlus, PIP_TextDraw);

	if (value < 0) {
		PlayerTD_Update(playerid, td_money_plus, 0xDD0000FF, -value, .prefix = "-$");
	} else {
		PlayerTD_Update(playerid, td_money_plus, 0x00DD00FF, value, .prefix = "+$");
	}

	if (gGiveTimer[playerid] != 0) {
		KillTimer(gGiveTimer[playerid]);
	}

	gGiveTimer[playerid] = SetTimerEx("PlayerMoneyTD_GiveHide", 3000, 0, "i", playerid);
}

forward PlayerMoneyTD_GiveHide(playerid);
public PlayerMoneyTD_GiveHide(playerid)
{
	PlayerTextDrawHide(playerid, PlayerText:GetPlayerInterfaceParam(playerid, PI_MoneyPlus, PIP_TextDraw));
	gGiveTimer[playerid] = 0;
}
