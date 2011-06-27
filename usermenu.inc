/*
 Created: 07.04.2011
 Author: ZiGGi
*/

#if defined _user_menu_included
  #endinput
#endif

#define _user_menu_included
#pragma library user_menu


stock show_menu(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		return show_User_Menu(playerid);
	}
	else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		return show_Vehicle_Menu(playerid);
	}
	return 0;
}

// MSG ������ ������������ � user menu
stock show_User_Menu_Dialog(playerid,string_0[],string[])
{
	return ShowPlayerDialog(playerid,user_menu_Return_DialogID,DIALOG_STYLE_MSGBOX,
		string_0,
		string,
		"�����","�����"
	);
}
//

stock show_User_Menu(playerid)
{
	return ShowPlayerDialog(playerid,user_menu_DialogID,DIALOG_STYLE_LIST,
		"���� ������",
		"���������� � ���������\n\
		��� �������\n\
		����� ������\n\
		��������\n\
		�������\n\
		��������� ������\n\
		������������� ������\n\
		����� � ��������������\n\
		���������\n\
		������\n\
		",
		"��","������"
	);
}

stock show_Vehicle_Menu(playerid)
{
	new string[512],engine,lights,alarm,doors,bonnet,boot,objective;
	new vehicleid = GetPlayerVehicleID(playerid);
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	
	strcat(string,"�����������\n",sizeof(string));
	strcat(string,"���������\n",sizeof(string));
	strcat(string,"�������� �����\n",sizeof(string));
	strcat(string,"�������� ����\n",sizeof(string));
	
	if(lights == VEHICLE_PARAMS_ON) // ����
		strcat(string,"{FF0000}���������  ����\n",sizeof(string));
	else
		strcat(string,"{00FF00}�������� ����\n",sizeof(string));
	
	if(engine == VEHICLE_PARAMS_ON) // ����
		strcat(string,"{FF0000}��������� ���������\n",sizeof(string));
	else
		strcat(string,"{00FF00}�������� ���������\n",sizeof(string));

	if(bonnet == VEHICLE_PARAMS_ON) // �����
		strcat(string,"{FF0000}������� �����\n",sizeof(string));
	else
		strcat(string,"{00FF00}������� �����\n",sizeof(string));
	
	if(boot == VEHICLE_PARAMS_ON) // ��������
		strcat(string,"{FF0000}������� ��������\n",sizeof(string));
	else
		strcat(string,"{00FF00}������� ��������\n",sizeof(string));
		
	return ShowPlayerDialog(playerid,vehicle_menu_DialogID,DIALOG_STYLE_LIST,
		"���� ����������",
		string,
		"��","������"
	);
}
/*
stock usermenu_OnPlayerKeyStateChange(playerid,newkeys,oldkeys)
{
	#pragma unused newkeys,oldkeys
	show_menu(playerid);
	return 1;
}*/

stock usermenu_OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
	#pragma unused inputtext
	switch(dialogid)
	{
		case user_menu_Return_DialogID:
		{
			if(response) show_menu(playerid);
			else return 1;
		}
		case user_menu_DialogID:
		{
			if(!response) return 1;
			new string[1024];
			switch(listitem)
			{
				case 0: // ���������� � ���������
				{
					new vip_status[MAX_NAME];
					if(GetPlayerVIP(playerid) == 1) format(vip_status,sizeof(vip_status),"�� %s",GetPlayerVIPDate(playerid));
					else set(vip_status,"���");
					format(string,sizeof(string),
						"�������: %d, ���� �� ������: %d\n\
						\n\
						�����: %s, ������: %s\n\
						\n\
						������: $%d, ������ � �����: $%d, ����� �����: $%d\n\
						\n\
						�������: %d, �������: %d\n\
						�����: %d\n\
						�����: %d\n\
						\n\
						����� ������: %s\n\
						VIP ������: %s",
						GetPlayerLevel(playerid),
						GetXPToLevel(playerid, GetPlayerLevel(playerid) + 1),
						
						GetPlayerGangName(playerid),GetLevelName(GetPlayerLevel(playerid)),
						
						oGetPlayerMoney(playerid),GetPlayerBankMoney(playerid),GetPlayerTotalMoney(playerid),
						
						GetPlayerKills(playerid),GetPlayerDeaths(playerid),GetPlayerJailed(playerid),GetPlayerMuted(playerid),
						
						ConvertFightIdToName( GetPlayerFightStyleUsed(playerid) ),
						vip_status
					);
					return show_User_Menu_Dialog(playerid,"���������� � ���������",string);
				}
				case 1: // ��� �������
				{
					new count = 0;
					for(new id=0;id<sizeof(Businesses);id++)
					{
						if(!strcmp(Businesses[id][Business_Owner], oGetPlayerName(playerid), true))
						{
							count++;
							format(string,sizeof(string),"%s'%s' ������� ���������� $%d\n",string,Businesses[id][Business_Name],Businesses[id][Business_Vault]);
						}
					}
					if(count == 0) set(string,"�� �� �������� ������� ��������.");
					return show_User_Menu_Dialog(playerid,"��� �������",string);
				}
				case 2: // ����� ������
				{
					showFightStyleMenu(playerid);
					return 1;
				}
				case 3: // ��������
				{
					show_User_Menu(playerid);
					return 1;
				}
				case 4: // �������
				{
					SetPlayerHealth(playerid,0.0);
					return 1;
				}
				case 5: // ��������� ������
				{
					CheckPlayerLevel(playerid);
					return show_User_Menu_Dialog(playerid,"��������� ������","�� ����������� ���������� �� ����� ������.");
				}
				case 6: // ������������� ������
				{
					new idsa = 0,
						admins[MAX_STRING],
						moders[MAX_STRING];
					for(new id=0;id<=GetPlayerLastID();id++)
					{
						if(!IsPlayerConnected(id) || IsPlayerNPC(id)) continue;
						if(IsPlayerAdmin(id) || IsPlayerAdm(id))
						{
							format(admins,sizeof(admins),"%s%s(%d)\n",admins,oGetPlayerName(id),id);
							idsa++;
						}
						if(IsPlayerMod(id))
						{
							format(moders,sizeof(moders),"%s%s(%d)\n",moders,oGetPlayerName(id),id);
							idsa++;
						}
					}
					if(idsa == 0)
						format(string,sizeof(string),"� ������ ������ � ���� ��� ���������������, �� ��� �� ������ ��� ��� �� ����� �� ���� ���������.");
					else format(string,sizeof(string),
						"�������������:\n\
						%s\n\
						\n\
						���������:\n\
						%s\n",
						admins,moders
					);
					return show_User_Menu_Dialog(playerid,"������������� ������",string);
				}
				case 7: // ����� � ��������������
				{
					show_User_Menu(playerid);
					return 1;
				}
				case 8: // ���������
				{
					show_User_Menu(playerid);
					return 1;
				}
				case 9: // ������
				{
					show_User_Menu_Dialog(playerid,
						"���������� � ������",
						"{AFE7FF}�� ������� �������:\n\
						\n\
						\t{FFFFFF}Open - Grand Theft Online {AA3333}"VERSION"{FFFFFF}.\n\
						\n\
						\n\
						{00C0DD}������ {AFE7FF}Iain Gilbert\n\
						\n\
						{00C0DD}����������:{AFE7FF}\n\
									\t\tPeter Steenbergen\n\
									\t\tRobin Kikkert\n\
									\t\tAsturel\n\
									\t\tDmitry Frolov (FP)\n\
									\t\tOpen-GTO Team:\n\
									\t\t\tCurrent: ZiGGi, SLICK\n\
									\t\t\tPrevious: GhostTT, heufix, Elbi\n\
						\n\
						{00C0DD}��������� ������������: {AFE7FF}\n\
									\t\tMX_Master(mxINI,Chat-Guard)\n\
									\t\twups(Default map icons)\n\
						\n\
						"
					);
					return 1;
				}
			}
			return 1;
		}
		case vehicle_menu_DialogID:
		{
			if(!response) return 1;
			new engine,lights,alarm,doors,bonnet,boot,objective;
			new vehicleid = GetPlayerVehicleID(playerid);
			GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
			switch(listitem)
			{
				case 0:// �����������
				{
					show_Vehicle_Menu(playerid);
					return 1;
				}
				case 1:// ���������
				{
					show_Vehicle_Menu(playerid);
					return 1;
				}
				case 2:// �����
				{
					show_Vehicle_Menu(playerid);
					return 1;
				}
				case 3:// ����
				{
					show_Vehicle_Menu(playerid);
					return 1;
				}
				case 4:// ����
				{
					if(lights == VEHICLE_PARAMS_ON)
						SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_OFF,alarm,doors,bonnet,boot,objective);
					else
						SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_ON,alarm,doors,bonnet,boot,objective);
					return 1;
				}
				case 5:// ���������
				{
					if(engine == VEHICLE_PARAMS_ON)
						SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
					else
						SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
					return 1;
				}
				case 6:// �����
				{
					if(bonnet == VEHICLE_PARAMS_ON)
						SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,VEHICLE_PARAMS_OFF,boot,objective);
					else
						SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,VEHICLE_PARAMS_ON,boot,objective);
					return 1;
				}
				case 7:// ��������
				{
					if(boot == VEHICLE_PARAMS_ON)
						SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_OFF,objective);
					else
						SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_ON,objective);
					return 1;
				}
			}
			return 1;
		}
	}
	return 1;
}