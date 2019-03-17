#include <a_samp>
#include <zcmd>
#include <sscanf2>

//=DEFINICJE=//

#include "modules/define.pwn"
#include "modules/kolory.pwn"
#include "modules/funkcje.pwn"

// == : KOMENDY DO ?DOWANIA FUNKCJI : == //

CMD:reloadbans(playerid, params[]) //podpi? logi
{
	if(IsPlayerAdminLevel(playerid, 1000))
	{
		GameTextForPlayer(playerid, "~r~RELOADBANS..", 3000, 4);
		SendRconCommand("reloadbans");
	}
	return 1;
}

CMD:gmx(playerid, params[]) //podpi? logi
{
	if(IsPlayerAdminLevel(playerid, 1000))
	{
		 SendClientMessage(playerid, COLOR_LIGHTMINT, "CMD_Info: Wykonywanie 'GMX' dla RCON! ");
		 GameTextForPlayer(playerid, "~r~GMX!..", 3000, 4);
		 SendRconCommand("gmx");
	}
	return 1;
}

CMD:loadpickup(playerid, params[]) //podpi? logi
{
	if(IsPlayerAdminLevel(playerid, 1000))
	{
		 GameTextForPlayer(playerid, "~r~LADOWANIE..", 3000, 4);
		 SetTimerEx("LoadPickupTime", 2000, 0,"d",playerid);
		 LoadPickup();
	}
	return 1;
}

CMD:loadactor(playerid, params[]) //podpi? logi
{
	if(IsPlayerAdminLevel(playerid, 1000))
	{
		 GameTextForPlayer(playerid, "~r~LADOWANIE..", 3000, 4);
		 SetTimerEx("LoadActorTimer", 2000, 0,"d",playerid);
		 LoadActor();
	}
	return 1;
}

CMD:loadtext3d(playerid, params[]) //podpi? logi
{
	if(IsPlayerAdminLevel(playerid, 1000))
	{
		 GameTextForPlayer(playerid, "~r~LADOWANIE..", 3000, 4);
		 SetTimerEx("Load3DTimer", 2000, 0,"d",playerid);
		 Load3DText();
	}
	return 1;
}

// == : KOMENDY DO ?DOWANIA FUNKCJI : == //

CMD:goto(playerid, params[]) //FLAGA ADMINA
{
	new value;
	if(!IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	if(sscanf(params, "u", value)) return SendClientMessage(playerid, COLOR_LIGHTRED, "U�YJ: /goto [id/nick]");            
	new Float:x, Float:y, Float:z;
	GetPlayerPos(value, x, y, z);
	SetPlayerPos(playerid, x, y, z);
	SendClientMessage(playerid, -1, "Teleportowa�e� si� do gracza");
	return 1;
}

CMD:tp(playerid, params[])
{
	new command[32], varchar[32];
	if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6))
	if (sscanf(params, "s[32]S()[32]", command, varchar)) {
		SendClientMessage(playerid, COLOR_GREY, "U�YCIE: /tp (dillimore/komi/motel/salon/remiza)");
		return 1;
	}

	if (!strcmp(command, "dillimore", true)) { 
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Pomy�lnie si� teleportowa�e�.");
		SetPlayerPos(playerid, 797.7998,-600.7216,16.3359);
	}

	if (!strcmp(command, "komi", true)) {   
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Pomy�lnie si� teleportowa�e�.");
		SetPlayerPos(playerid, 632.0640,-571.2114,16.3359);
	}

	if (!strcmp(command, "motel", true)) {   
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Pomy�lnie si� teleportowa�e�.");
		SetPlayerPos(playerid, 675.9067,-630.7064,16.3359);
	}
	
	if(!strcmp(command, "salon", true)) {
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Pomy�lnie si� teleportowa�e�.");
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerPos(playerid, 563.7422, -1368.5813, 52.5134);
	}
	
	if(!strcmp(command, "remiza", true)) {
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Pomy�lnie si� teleportowa�e�.");
		SetPlayerPos(playerid, 706.6948, -658.8431, 16.3538); 
	}
	return 1;
}

/*

CMD:aduty(playerid)
{
	if(IsPlayerAdminLevel(playerid, 1000)) {
		if(aduty == false);
		{
			new string[128];
			GameTextForPlayer(playerid, "~w~Admin DUTY - ~g~ON", 5000, 6);
			SendClientMessage(playerid, COLOR_WHITE, "Wchodzisz na s�u�b� g��wnego {ff0000}Administratora{ffffff} wszystkie u�yte przez Ciebie komendy s� rejestrowane"); 
			format(string, sizeof(string), "[ACv2] %s wchodzi na s�u�b� Administratora!", pName(playerid));
			AdminWarning(COLOR_YELLOW, string, 1);
			new Text3D:label = Create3DTextLabel("HeadAdministrator", COLOR_PANICRED, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, -0.7);
			aduty = true;
			return 1;
		}
		if(aduty == true);
		{
			new string[128];
			GameTextForPlayer(playerid, "~w~Admin DUTY - ~g~ON", 5000, 6);
			SendClientMessage(playerid, COLOR_WHITE, "Wchodzisz na s�u�b� g��wnego {ff0000}Administratora{ffffff} wszystkie u�yte przez Ciebie komendy s� rejestrowane"); 
			format(string, sizeof(string), "[ACv2] %s wchodzi na s�u�b� Administratora!", pName(playerid));
			AdminWarning(COLOR_YELLOW, string, 1);
			new Text3D:label = Create3DTextLabel("HeadAdministrator", COLOR_PANICRED, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, -0.7);
			aduty = true;
			return 1;

		}

	}
	return 1;
}

*/

CMD:fly(playerid, params[])
{
	if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6) || IsPlayerAdminLevel(playerid, 1))
	{
		new Float:x, Float:y, Float:z;
		if((flying[playerid] = !flying[playerid]))
		{
			GetPlayerPos(playerid, x, y, z);
			SetPlayerPos(playerid, x, y, z+5);
			GameTextForPlayer(playerid, "~w~FLYMODE ~g~ON", 5000, 4);
			SetPlayerArmour(playerid, 1000000000.0);
			SetPlayerHealth(playerid, 1000000000.0);
			SetTimerEx("AdminFly", 100, 0, "d", playerid);
		}
		else
		{
			GetPlayerPos(playerid, x, y, z);
			SetPlayerPos(playerid, x, y, z+0.5);
			ClearAnimations(playerid);
			GameTextForPlayer(playerid, "~w~FLYMODE ~r~OFF", 5000, 4);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 100.0);
			return 1;
		}
	}
	else SendClientMessage(playerid, 0xB4B5B7FF, "Nie jeste� Administratorem!");
	return 1;
}

CMD:strona(playerid)
{
	new text[128];
	if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6) || IsPlayerAdminLevel(playerid, 1))
	format(text, sizeof(text), "{00bfff}%s [%d]{ffffff} || Odwied� nasz� stron� pod adresem www.santosproject.pl", pName(playerid), playerid);
	SendClientMessageToAll(COLOR_WHITE, text);
	return 1;
}

//kary

CMD:kick(playerid, params[]) {

	new targetid, string[500], reason[64], title[64];
	if(!IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6) || IsPlayerAdminLevel(playerid, 1)) return NoAccessMessage(playerid);
	if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, COLOR_GREY, "U�CIE: /kick [id/nick] [pow�d]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B��D: Ten gracz nie jest po��czony!");
	format(string, sizeof(string), "%s[ID:%i] wyrzuci� z serwera %s, pow�d: %s", pName(playerid), playerid, pName(targetid), reason);
	Log("/logs/admincmd.log", string);
	SendClientMessageToAll(COLOR_RED, string); {
	format(title, sizeof(title), "{ff0000}Otrzymano kar�");   
	format(string, sizeof(string), "{ffffff}Zostajesz wyrzucony z serwera!\n\nNadaj�cy: {f25715}%s{ffffff}\nPow�d: {f25715}%s{ffffff}\n\nJe�li uwa�sz kar� za �le nadan� zr�b SS z tego komunikatu", pName(playerid), reason);
	ShowPlayerDialog(targetid, 21377, DIALOG_STYLE_MSGBOX, title, string, "Zamknij", "");
	}
	SetTimerEx("KickEx", 500, 0, "i", targetid);
	return 1;
}

CMD:unban(playerid, params[])
{	
	if(!IsPlayerAdminLevel(playerid, 2)) return NoAccessMessage(playerid);
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "U�YCIE: /unban [Nick]");
	
	new DB_Query[128];
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT `uid`, `name` FROM `accounts` WHERE `name` = '%s' LIMIT 1", params);
	mysql_tquery(Database, DB_Query, "OnAdminUnBanPlayer", "i", playerid);
	return 1;
}

CMD:ban(playerid, params[]) {
	new targetid, string[500], reason[64], title[64];
	if(!IsPlayerAdminLevel(playerid, 2)) return NoAccessMessage(playerid);
	if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, COLOR_GREY, "U�YCIE: /ban [id/nick] [pow�d]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B��D: Ten gracz nie jest po��czony!");
	format(string, sizeof(string), "%s[ID:%i] zbanowa� %s, pow�d: %s", pName(playerid), playerid, pName(targetid), reason);
	SendClientMessageToAll(COLOR_RED, string);
	Log("/logs/admincmd.log", string);  
	format(title, sizeof(title), "{ff0000}Otrzymano kar�"); 
	format(string, sizeof(string), "{ffffff}Zosta�e� zbanowany!\n\nNadaj�cy: {f25715}%s{ffffff}\nPow�d: {f25715}%s{ffffff}\n\nJe�li uwa�asz kar� za �le nadan� zr�b SS z tego komunikatu i wstaw do apelacji na forum!", pName(playerid), reason);
	ShowPlayerDialog(targetid, 21377, DIALOG_STYLE_MSGBOX, title, string, "Zamknij", "");
	mysql_format(Database, string, sizeof(string), "INSERT INTO bans (userid, reason, issuername, date) VALUES ('%d', '%e', '%e', now())", pInfo[targetid][UID], reason, pName(playerid));
	mysql_tquery(Database, string);
	SetTimerEx("KickEx", 500, 0, "i", targetid);
	return 1;
}

CMD:pban(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1)) return NoAccessMessage(playerid);
	new nick[24], reason[128];
	if(sscanf(params, "s[24]s[128]", nick, reason)) return SendClientMessage(playerid, COLOR_GREY, "U�YCIE: /sban [Nick] [Pow�d]");
	
	
	foreach(new x : Player)
	{
		if(!strcmp(pName(x), nick, true))
		{
			SendClientMessage(playerid, COLOR_GREY, "B��D: Ten gracz jest po��czony! U�yj: /ban!");
			return 1;
		}
	}
	
	
	new DB_Query[128];
	mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT `uid` FROM `accounts` WHERE `name` = '%s'  LIMIT 1", nick);
	mysql_tquery(Database, DB_Query, "OnAdminOfflineBanPlayer", "iss", playerid, nick, reason);
	return 1;
}

CMD:slap(playerid, params[])
{
	new string[128], targetid, reason[64], Float:posX, Float:posY, Float:posZ;
	if(!IsPlayerAdminLevel(playerid, 1)) return NoAccessMessage(playerid);
	if (sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, COLOR_LIGHTRED, "U�YCIE: /slap [id/nick] [pow�d]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "B��D: Nie ma takiego gracza!");
	GetPlayerPos(targetid, Float:posX, Float:posY, Float:posZ);
	SetPlayerPos(targetid, Float:posX, Float:posY, Float:posZ + 5.0);
	format(string, sizeof(string), "Dosta�e� klapsa od Administratora %s, pow�d: %s", pName(playerid), reason);
	SendClientMessage(targetid, COLOR_LIGHTRED, string);
	format(string, sizeof(string), " %s da� slapa graczowi %s, pow�d: %s", pName(playerid), pName(targetid), reason);
	AdminWarning(COLOR_RED, string);
	Log("/logs/admincmd.log", string);
	return 1;
}

CMD:spec(playerid, params[])
{
	if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6) || IsPlayerAdminLevel(playerid, 1)) {
		new string[64], targetid;
		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "� U�YCIE: /spec [id/nick]");
		if(targetid == playerid) return SendClientMessage(playerid, COLOR_LIGHTRED, "� Nie mo�esz podgl�da� samego siebie!");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "�  Nie ma takiego gracza!");
		if(GetPVarInt(playerid, "Spectating") == 0) {
			SetPVarInt(playerid, "Spectating", 1);
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectatePlayer(playerid, targetid);
			SetPlayerInterior(playerid, GetPlayerInterior(targetid));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
			format(string, sizeof(string), "Podgl�dasz gracza: %s | UID: %d | Kasa: $%d | ", pName(targetid), pInfo[targetid][UID], pInfo[targetid][Money]);
			SendClientMessage(playerid, COLOR_SPECIALGOLD, string);
			//format(string, sizeof(string), "Aby wy��czy� podgl�d u�yj komendy /spec %d", targetid);
			//SendClientMessage(playerid, COLOR_GREY, string);
			format(string, sizeof(string), "%s (ID: %d)", pName(targetid), targetid);
			GameTextForPlayer(playerid, string, 1000000, 4);
		}
		else {
			SetPVarInt(playerid, "Spectating", 0);
			TogglePlayerSpectating(playerid, 0);
			SendClientMessage(playerid, COLOR_GREY, "Wy��czy�e� podgl�d SPEC");
			GameTextForPlayer(playerid, ".", 1, 4); 
		}
	}
	else NoAccessMessage(playerid);
	return 1;
}

CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0);
	SendClientMessage(playerid, -1, "Tw�j poziom HP zosta� zmieniony na 0");
	return 1;
}

CMD:report(playerid, params[])
{
	new string[128], targetid, reason[100];
	if (sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, COLOR_LIGHTRED, "U�YCIE: /report [id/nick] [pow�d]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "B��D: Nie ma takiego gracza!");
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "��  Wys�ano zg�oszenie do Administracji! :)");
	format(string, sizeof(string), "{ff0000}[REPORT]{ffffff} %s [%d] zg�oszone ID: %d, Pow�d: {ff0000}%s", pName(playerid), playerid, targetid, reason);
	AdminWarning(COLOR_WHITE, string);
	return 1;
}

CMD:ctz(playerid, args[]) return cmd_createtruckzone(playerid, args);
CMD:createtruckzone(playerid, args[]) {
	new string[128], Float:x, Float:y, Float:z;
	if(IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	GetPlayerPos(playerid, Float:x, Float:y, Float:z);
	mysql_format(Database, string, sizeof(string), "INSERT INTO truckzones (posx, posy, posz) VALUES ('%f', '%f', '%f')",Float:x, Float:y, Float:z);
	mysql_tquery(Database, string);
	format(string, sizeof(string), "�� Pomy�lnie utworzono stref� za�adunkow� na koordynatach X: [%f] Y: [%f] Z: [%f]", x, y, z);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s[ID: %d] stworzy� stref� za�adunku na koordynatach X: [%f] Y: [%f] Z: [%f]",pName(playerid), playerid, x, y, z);
	Log("/logs/admincmd.log", string);
	return 1;
}

CMD:gethere(playerid, params[])
{
    new string[128], targetid, Float:X, Float:Y, Float:Z;
    if (sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "U�YCIE: /gethere [id/nick]");
    if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6) || IsPlayerAdminLevel(playerid, 1))
    GetPlayerPos(playerid, Float:X, Float:Y, Float:Z);
    SetPlayerPos(targetid, Float:X, Float:Y, Float:Z);
    format(string, sizeof(string), "Zosta�e� teleportowany do Administratora {ff0000}%s [%d]", pName(playerid), playerid);
    SendClientMessage(targetid, COLOR_WHITE, string);
    format(string, sizeof(string), "Teleportowa�e� do siebie gracza {f9cc00}%s [%d]", pName(targetid), playerid);
    SendClientMessage(targetid, COLOR_WHITE, string);
    return 1;
}

CMD:setgun(playerid, params[])
{
    new string[128], targetid, gun, ammo;
    if (sscanf(params, "udd", targetid, gun, ammo)) return SendClientMessage(playerid, COLOR_GREY, "U�YCIE: /setgun [id/nick] [id broni] [ammo]");
    if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6))
    GivePlayerWeapon(targetid, gun, ammo);
    format(string, sizeof(string),  "Da�e� graczowi {f9cc00}%s{ffffff} bro� o UID {f9cc00}%d{ffffff} z dodatkow� amunicj� {f9cc00}[%d]{ffffff} ", pName(targetid), gun, ammo);
    SendClientMessage(playerid, COLOR_WHITE, string);
    format(string, sizeof(string),  "Otrzyma�e� bro� UID %d [A: %d] od Administratora {f9cc00}%s", gun, ammo, pName(playerid));
    SendClientMessage(targetid, COLOR_WHITE, string);
    format(string, sizeof(string), "[ %s przekaza� bro� o UID %d z amunicj� %d dla gracza %s ]", pName(playerid), gun, ammo, pName(targetid));
    AdminWarning(COLOR_SPECIALGOLD, string);
    format(string, sizeof(string), "Admin %s przekazal %s [ID: %d | UID %d ] bron UID %d z amunicja %d", pName(playerid), pName(targetid), targetid, pInfo[targetid][UID], gun, ammo);
    Log("/logs/setgun.log", string);
    return 1;
}

CMD:cc(playerid, params[])
{
    if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6))
    for(new xd=0; xd < 90; xd++) SendClientMessageToAll(COLOR_WHITE, " ");
    SendClientMessageToAll(COLOR_PANICRED, "�� Czat globalny zosta� wyczyszczony!");
    return 1;
}