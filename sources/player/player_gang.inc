/*
	
	About: player gang
	Author: ziggi

*/

#if defined _player_gang_included
	#endinput
#endif

#define _player_gang_included
#pragma library player_gang

/*
	Defines
*/

#if !defined MAX_GANG_INVITES
	#define MAX_GANG_INVITES 3
#endif

#if !defined MAX_GANG_INVITE_TIME
	#define MAX_GANG_INVITE_TIME 60
#endif

/*
	Enums
*/

enum e_Player_Invited_Gang_Info {
	e_pigID,
	e_pigTime,
}

/*
	Vars
*/

static
	gPlayerGangID[MAX_PLAYERS],
	gPlayerGangName[MAX_PLAYERS][MAX_NAME],
	gPlayerInvitedGang[MAX_PLAYERS][MAX_GANG_INVITES][e_Player_Invited_Gang_Info],
	gPlayerGangMemberID[MAX_PLAYERS char];

/*
	Invite ID
*/

stock IsPlayerInvitedInAnyGang(playerid) {
	for (new i = 0; i < MAX_GANG_INVITES; i++) {
		if (gPlayerInvitedGang[playerid][i][e_pigID] != INVALID_GANG_ID) {
			return 1;
		}
	}

	return 0;
}

stock IsPlayerInvitedInGang(playerid, gangid) {
	for (new i = 0; i < MAX_GANG_INVITES; i++) {
		if (gPlayerInvitedGang[playerid][i][e_pigID] == gangid) {
			return 1;
		}
	}

	return 0;
}

stock GetPlayerInvitedGangArrayID(playerid, invited_gangs[], &size) {
	size = 0;

	for (new i = 0; i < MAX_GANG_INVITES; i++) {
		if (gPlayerInvitedGang[playerid][i][e_pigID] != INVALID_GANG_ID) {
			invited_gangs[size++] = gPlayerInvitedGang[playerid][i][e_pigID];
		}
	}

	return size != 0;
}

stock SetPlayerInvitedGangID(playerid, gangid, bool:status) {
	for (new i = 0; i < MAX_GANG_INVITES; i++) {
		if (status) {
			if (gPlayerInvitedGang[playerid][i][e_pigID] == INVALID_GANG_ID) {
				gPlayerInvitedGang[playerid][i][e_pigID] = gangid;
				gPlayerInvitedGang[playerid][i][e_pigTime] = gettime();
				return 1;
			}
		} else {
			if (gPlayerInvitedGang[playerid][i][e_pigID] == gangid) {
				gPlayerInvitedGang[playerid][i][e_pigID] = INVALID_GANG_ID;
				gPlayerInvitedGang[playerid][i][e_pigTime] = 0;
				return 1;
			}
		}
	}

	return 0;
}

stock GetPlayerInvitedGangArrayTime(playerid, invited_times[], &size)
{
	size = 0;

	for (new i = 0; i < MAX_GANG_INVITES; i++) {
		if (gPlayerInvitedGang[playerid][i][e_pigID] != INVALID_GANG_ID) {
			invited_times[size++] = gPlayerInvitedGang[playerid][i][e_pigTime];
		}
	}

	return size != 0;
}

stock CheckPlayerInvitedGangTime(playerid)
{
	new
		current_time = gettime();

	for (new i = 0; i < MAX_GANG_INVITES; i++) {
		if (current_time >= MAX_GANG_INVITE_TIME + gPlayerInvitedGang[playerid][i][e_pigTime]) {
			SetPlayerInvitedGangID(playerid, gPlayerInvitedGang[playerid][i][e_pigID], false);
		}
	}
}

/*
	IsPlayersTeammates
*/

stock IsPlayersTeammates(...)
{
	new gangid = GetPlayerGangID(getarg(0));
	if (gangid == INVALID_GANG_ID) {
		return 0;
	}

	for (new i = numargs() - 1; i != 0; i--) {
		if (gangid != GetPlayerGangID(getarg(i))) {
			return 0;
		}
	}

	return 1;
}

/*
	GangName
*/

stock GetPlayerGangName(playerid, name[], const size = sizeof(name)) {
	strmid(name, gPlayerGangName[playerid], 0, strlen(gPlayerGangName[playerid]), size);
}

stock ReturnPlayerGangName(playerid) {
	return gPlayerGangName[playerid];
}

stock SetPlayerGangName(playerid, name[]) {
	strmid(gPlayerGangName[playerid], name, 0, strlen(name), MAX_NAME);
}

/*
	GangID
*/

stock IsPlayerInGang(playerid) {
	return gPlayerGangID[playerid] != INVALID_GANG_ID;
}

stock GetPlayerGangID(playerid) {
	return gPlayerGangID[playerid];
}

stock SetPlayerGangID(playerid, gangid) {
	gPlayerGangID[playerid] = gangid;
}


/*
	GangMemberID
*/

stock GetPlayerGangMemberID(playerid) {
	return gPlayerGangMemberID{playerid};
}

stock SetPlayerGangMemberID(playerid, memberid) {
	gPlayerGangMemberID{playerid} = memberid;
}

/*
	Player Color
*/

stock GetPlayerGangColor(playerid)
{
	new gangid = GetPlayerGangID(playerid);

	if (gangid != INVALID_GANG_ID) {
		return Gang_GetColor(gangid);
	}

	return COLOR_PLAYER;
}
