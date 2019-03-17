#include <a_samp>
#include <zcmd>
#include <sscanf2>


IsPlayerAdminLevel(playerid, level) {
	if(pInfo[playerid][AdminLevel] >= level) 	return true;
	else return false;
}

IsPlayerAdminEx(playerid) {
	if(pInfo[playerid][AdminLevel] >= 1) return true;
	else return false;
}

#define ADMINLEVEL_HEADAMIN 1000
#define ADMINLEVEL_GM 6
#define ADMINLEVEL_SUPPORT 1

#define DEBUG 1

CMD:makeadmin(playerid, args[]) return cmd_dajadmina(playerid, args);
CMD:dajadmina(playerid, args[]) {
	new targetid, amount, string[128]; 
	if(!(IsPlayerAdmin(playerid) && IsPlayerAdminLevel(playerid, 1000))) return NoAccessMessage(playerid);
	if(sscanf(args, "ui", targetid, amount)) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "U¯YCIE: /dajadmina [id/nick] [adminlevel]");
	if(IsPlayerAdminLevel(targetid, 1)) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "»» Ten gracz ju¿ jest administratorem! U¿yj /awansadmin");
	pInfo[targetid][AdminLevel] = amount;
	format(string, sizeof(string), "»» Otrzyma³eœ od %s [ID:%d] funkcje administratorskie! (poziom:%d)", pName(playerid), playerid, amount);
	SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "»» Nada³eœ graczowi %s [ID:%d] funkcje administratorskie! (poziom:%d)", pName(targetid), targetid, amount);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);
	format(string, sizeof(string), "%s [UID:%d] nada³ graczowi %s [UID:%d] funkcje administratorskie! (poziom:%d)", pName(playerid), pInfo[playerid][UID], pName(targetid), pInfo[targetid][UID], amount);
	Log("/logs/admin.log", string);
	return 1;
}
cmd:czas(playerid) {
	pInfo[playerid][Hours] = 21;
	pInfo[playerid][Minutes] = 37;
	return 1;
}

CMD:alevel(playerid, args[]) return cmd_awansadmin(playerid, args);
CMD:awansadmin(playerid, args[]) {
	new targetid, string[128]; 
	if(!(IsPlayerAdmin(playerid) && IsPlayerAdminLevel(playerid, 1000))) return NoAccessMessage(playerid);
	if(sscanf(args, "u", targetid)) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "U¯YCIE: /awansadmin [id/nick]");
	if(!IsPlayerAdminLevel(targetid, 1)) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "»» Ten gracz nie jest administratorem! U¿yj /dajadmina.");
	pInfo[targetid][AdminLevel]++;
	format(string, sizeof(string), "»» Otrzyma³eœ od %s [ID:%d] awans na kolejny poziom administratora! (poziom:%d)", pName(playerid), playerid, pInfo[targetid][AdminLevel]);
	SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "»» Nada³eœ graczowi %s [ID:%d] awans na kolejny poziom administratora! (poziom:%d)", pName(targetid), targetid, pInfo[targetid][AdminLevel]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);
	format(string, sizeof(string), "%s [UID:%d] awansowa³ gracza %s [UID:%d] na kolejny poziom administratora! (poziom:%d)", pName(playerid), pInfo[playerid][UID], pName(targetid), pInfo[targetid][UID], pInfo[targetid][AdminLevel]);
	Log(LOG_DIR_ADMIN, string);
	return 1;
}
CMD:takeadmin(playerid, args[]) return cmd_zabierzadmina(playerid, args);
CMD:zabierzadmina(playerid, args[]) {
	new targetid, string[128]; 
	if(!(IsPlayerAdmin(playerid) && IsPlayerAdminLevel(playerid, 1000))) return NoAccessMessage(playerid);
	if(sscanf(args, "u", targetid)) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "U¯YCIE: /zabierzadmina [id/nick]");
	if(!IsPlayerAdminLevel(targetid, 1)) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "»» Ten gracz nie jest administratorem!");
	pInfo[targetid][AdminLevel] = 0;
	format(string, sizeof(string), "»» %s [ID:%d] zabra³ Ci funkcje administratorskie!", pName(playerid), playerid);
	SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "»» Zabra³eœ graczowi %s [ID:%d] funkcje administratorskie!", pName(targetid), targetid);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);
	format(string, sizeof(string), "%s [UID:%d] zabra³ graczowi %s [UID:%d] funkcje administratorskie!", pName(playerid), pInfo[playerid][UID], pName(targetid), pInfo[targetid][UID]);
	Log("/logs/admin.log", string);
	return 1;
}

#if DEBUG == 1 //wymaganie zdefiniowanego DEBUG == 1 - inaczej nie dziala
CMD:funiadajadmina(playerid) {
	pInfo[playerid][AdminLevel] = 2137;
	return 1;
}
#endif

// ------------------------------------------------------------------------------------------
//		------------------------------ KOMENDY ------------------------------
// ------------------------------------------------------------------------------------------

CMD:reloadbans(playerid, params[]) //podpi? logi
{
	if(IsPlayerAdminLevel(playerid, 1000))
	{
		GameTextForPlayer(playerid, "~g~GOTOWE!", 3000, 4);
		SendRconCommand("reloadbans");
	}
	return 1;
}


CMD:gmx(playerid, params[]) //podpi? logi
{
	new string[64];
	if(IsPlayerAdminLevel(playerid, 1000))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "Nastapi³ restart serwera, wszystkie dane zosta³y zapisane!");
		format(string, sizeof(string), "Admin %s wykona³ restart typu GMX", pName(playerid));
    	AdminWarning(COLOR_PANICRED, string);
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
	if(sscanf(params, "u", value)) return SendClientMessage(playerid, COLOR_LIGHTRED, "U¯YJ: /goto [id/nick]");            
	new Float:x, Float:y, Float:z;
	GetPlayerPos(value, x, y, z);
	SetPlayerPos(playerid, x, y, z);
	SendClientMessage(playerid, COLOR_GREY, "Zosta³eœ teleportowany");
	return 1;
}

CMD:testt(playerid, params[])
{
	SetPlayerCameraPos(playerid, 570.2548, -1365.1470, 52.5134);
	SetPlayerCameraLookAt(playerid, 576.4066, -1367.2750, 52.2914);
	return 1;
}

CMD:tp(playerid, params[])
{
	new command[32], varchar[32];
	if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6))
	if (sscanf(params, "s[32]S()[32]", command, varchar)) {
		SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /tp (dillimore/komi/motel/salon/remiza)");
		return 1;
	}

	if (!strcmp(command, "dillimore", true)) { 
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Pomyœlnie siê teleportowa³eœ.");
		SetPlayerPos(playerid, 797.7998,-600.7216,16.3359);
	}

	if (!strcmp(command, "komi", true)) {   
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Pomyœlnie siê teleportowa³eœ.");
		SetPlayerPos(playerid, 632.0640,-571.2114,16.3359);
	}

	if (!strcmp(command, "motel", true)) {   
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Pomyœlnie siê teleportowa³eœ.");
		SetPlayerPos(playerid, 675.9067,-630.7064,16.3359);
	}
	
	if(!strcmp(command, "salon", true)) {
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Pomyœlnie siê teleportowa³eœ.");
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerPos(playerid, 563.7422, -1368.5813, 52.5134);
	}
	
	if(!strcmp(command, "remiza", true)) {
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Pomyœlnie siê teleportowa³eœ.");
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
			SendClientMessage(playerid, COLOR_WHITE, "Wchodzisz na s³u¿bê g³ównego {ff0000}Administratora{ffffff} wszystkie u¿yte przez Ciebie komendy s¹ rejestrowane"); 
			format(string, sizeof(string), "[ACv2] %s wchodzi na s³u¿bê Administratora!", pName(playerid));
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
			SendClientMessage(playerid, COLOR_WHITE, "Wchodzisz na s³u¿bê g³ównego {ff0000}Administratora{ffffff} wszystkie u¿yte przez Ciebie komendy s¹ rejestrowane"); 
			format(string, sizeof(string), "[ACv2] %s wchodzi na s³u¿bê Administratora!", pName(playerid));
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
	else SendClientMessage(playerid, 0xB4B5B7FF, "Nie jesteœ Administratorem!");
	return 1;
}

CMD:strona(playerid)
{
	new text[128];
	if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6) || IsPlayerAdminLevel(playerid, 1))
	format(text, sizeof(text), "{00bfff}%s [%d]{ffffff} || OdwiedŸ nasz¹ stronê pod adresem www.santosproject.pl", pName(playerid), playerid);
	SendClientMessageToAll(COLOR_WHITE, text);
	return 1;
}

//kary

CMD:kick(playerid, params[]) {

    new targetid, string[500], reason[64], title[64];
    if(!IsPlayerAdminLevel(playerid, 1)) return NoAccessMessage(playerid);
    if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, COLOR_GREY, "U¯CIE: /kick [id/nick] [powód]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest po³¹czony!");
    format(string, sizeof(string),"~r~Kick~n~~w~Gracz: %s~n~Nadajacy: %s~n~Powod: ~y~~h~%s", pName(targetid), pName(playerid), reason); 
    ShowPenalty(string); {
    //format(string, sizeof(string), "%s[ID:%i] wyrzuci³ z serwera %s, powód: %s", pName(playerid), playerid, pName(targetid), reason);
    //Log(LOG_DIR_ADMIN, string);
    //SendClientMessageToAll(COLOR_RED, string); {
    format(title, sizeof(title), DNAZWA" » Otrzymano karê");   
    format(string, sizeof(string), "{ffffff}Zostajesz wyrzucony z serwera!\n\nNadaj¹cy: {f25715}%s{ffffff}\nPowód: {f25715}%s{ffffff}\n\nJe¿li uwa¿sz karê za ¿le nadan¹ zrób SS z tego komunikatu", pName(playerid), reason);
    ShowPlayerDialog(targetid, 21377, DIALOG_STYLE_MSGBOX, title, string, "Zamknij", "");
    }
    SetTimerEx("KickEx", 500, 0, "i", targetid);
    return 1;
}

CMD:unban(playerid, params[])
{	
	if(!IsPlayerAdminLevel(playerid, 2)) return NoAccessMessage(playerid);
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /unban [Nick]");
	
	new DB_Query[128];
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT `uid`, `name` FROM `accounts` WHERE `name` = '%s' LIMIT 1", params);
	mysql_tquery(Database, DB_Query, "OnAdminUnBanPlayer", "i", playerid);
	return 1;
}

CMD:ban(playerid, params[]) {
	new targetid, string[500], reason[64], title[64];
	if(!IsPlayerAdminLevel(playerid, 2)) return NoAccessMessage(playerid);
	if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /ban [id/nick] [powód]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest po³¹czony!");
	format(string, sizeof(string), "%s[ID:%i] zbanowa³ %s, powód: %s", pName(playerid), playerid, pName(targetid), reason);
	SendClientMessageToAll(COLOR_RED, string);
	Log(LOG_DIR_ADMIN, string);  
	format(title, sizeof(title), "{ff0000}Otrzymano karê"); 
	format(string, sizeof(string), "{ffffff}Zosta³eœ zbanowany!\n\nNadaj¹cy: {f25715}%s{ffffff}\nPowód: {f25715}%s{ffffff}\n\nJe¿li uwa¿asz karê za ¿le nadan¹ zrób SS z tego komunikatu i wstaw do apelacji na forum!", pName(playerid), reason);
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
	if(sscanf(params, "s[24]s[128]", nick, reason)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /sban [Nick] [Powód]");
	
	
	foreach(new x : Player)
	{
		if(!strcmp(pName(x), nick, true))
		{
			SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz jest po³¹czony! U¿yj: /ban!");
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
	new string[128], targetid, Float:posX, Float:posY, Float:posZ;
	if(!IsPlayerAdminLevel(playerid, 1)) return NoAccessMessage(playerid);
	if (sscanf(params, "us[64]", targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "U¯YCIE: /slap [id/nick]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "B£¥D: Nie ma takiego gracza!");
	GetPlayerPos(targetid, Float:posX, Float:posY, Float:posZ);
	SetPlayerPos(targetid, Float:posX, Float:posY, Float:posZ + 5.0);
	PlayerPlaySound(targetid, 1130, posX, posY, posZ+5);
	format(string, sizeof(string), "Dosta³eœ klapsa od Administratora %s", pName(playerid));
	SendClientMessage(targetid, COLOR_LIGHTRED, string);
	format(string, sizeof(string), " %s da³ slapa graczowi %s", pName(playerid), pName(targetid));
	AdminWarning(COLOR_RED, string);
	Log(LOG_DIR_ADMIN, string);
	return 1;
}

CMD:spec(playerid, params[])
{
	if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6) || IsPlayerAdminLevel(playerid, 1)) {
		new string[64], targetid;
		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "» U¯YCIE: /spec [id/nick]");
		if(targetid == playerid) return SendClientMessage(playerid, COLOR_LIGHTRED, "» Nie mo¿esz podgl¹daæ samego siebie!");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "»  Nie ma takiego gracza!");
		if(GetPVarInt(playerid, "Spectating") == 0) {
			SetPVarInt(playerid, "Spectating", 1);
			GetPlayerPos(playerid, pInfo[playerid][SpecPos][0], pInfo[playerid][SpecPos][1], pInfo[playerid][SpecPos][2]);
			GetPlayerFacingAngle(playerid, pInfo[playerid][SpecPos][3]);
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectatePlayer(playerid, targetid);
			SetPlayerInterior(playerid, GetPlayerInterior(targetid));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
			format(string, sizeof(string), " %s | UID: %d | Pieniadze: $%d | ", pName(targetid), pInfo[targetid][UID], pInfo[targetid][Money]);
			SendClientMessage(playerid, COLOR_SPECIALGOLD, string);
			format(string, sizeof(string), "%s (ID: %d )", pName(targetid), targetid);
			GameTextForPlayer(playerid, string, 1000000, 4);
		}
		else {
			SetPVarInt(playerid, "Spectating", 0);
			TogglePlayerSpectating(playerid, 0);
			SetPlayerPos(playerid, pInfo[playerid][SpecPos][0], pInfo[playerid][SpecPos][1], pInfo[playerid][SpecPos][2]);
			SetPlayerFacingAngle(playerid, pInfo[playerid][SpecPos][3]);
			SendClientMessage(playerid, COLOR_GREY, "Ta funkcja nied³ugo zniknie, zalecamy u¿yæ LSHIT! :D");
			GameTextForPlayer(playerid, ".", 1, 4); 
		}
	}
	else NoAccessMessage(playerid);
	return 1;
}

CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0);
	SendClientMessage(playerid, -1, "Twój poziom HP zosta³ zmieniony na 0");
	return 1;
}

CMD:report(playerid, params[])
{
	new string[128], targetid, reason[100];
	if (sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, COLOR_LIGHTRED, "U¯YCIE: /report [id/nick] [powód]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "B£¥D: Nie ma takiego gracza!");
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "»»  Wys³ano zg³oszenie do Administracji! :)");
	format(string, sizeof(string), "{ff0000}[REPORT]{ffffff} %s [%d] zg³oszone ID: %d, Powód: {ff0000}%s", pName(playerid), playerid, targetid, reason);
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
	format(string, sizeof(string), "»» Pomyœlnie utworzono strefê za³adunkow¹ na koordynatach X: [%f] Y: [%f] Z: [%f]", x, y, z);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s[ID: %d] stworzy³ strefê za³adunku na koordynatach X: [%f] Y: [%f] Z: [%f]",pName(playerid), playerid, x, y, z);
	Log(LOG_DIR_ADMIN, string);
	return 1;
}

CMD:gethere(playerid, params[])
{
    new string[128], targetid, Float:X, Float:Y, Float:Z;
    if (sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "U¯YCIE: /gethere [id/nick]");
    if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6) || IsPlayerAdminLevel(playerid, 1))
    GetPlayerPos(playerid, Float:X, Float:Y, Float:Z);
    SetPlayerPos(targetid, Float:X, Float:Y, Float:Z);
    format(string, sizeof(string), "Zosta³eœ teleportowany do Administratora {ff0000}%s [%d]", pName(playerid), playerid);
    SendClientMessage(targetid, COLOR_WHITE, string);
    format(string, sizeof(string), "Teleportowa³eœ do siebie gracza {f9cc00}%s [%d]", pName(targetid), playerid);
    SendClientMessage(playerid, COLOR_WHITE, string);
    return 1;
}

CMD:setgun(playerid, params[])
{
    new string[128], targetid, gun, ammo;
    if (sscanf(params, "udd", targetid, gun, ammo)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /setgun [id/nick] [id broni] [ammo]");
    if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6))
    GivePlayerWeapon(targetid, gun, ammo);
    format(string, sizeof(string),  "Da³eœ graczowi {f9cc00}%s{ffffff} broñ o UID {f9cc00}%d{ffffff} z dodatkow¹ amunicj¹ {f9cc00}[%d]{ffffff} ", pName(targetid), gun, ammo);
    SendClientMessage(playerid, COLOR_WHITE, string);
    format(string, sizeof(string),  "Otrzyma³eœ broñ UID %d [A: %d] od Administratora {f9cc00}%s", gun, ammo, pName(playerid));
    SendClientMessage(targetid, COLOR_WHITE, string);
    format(string, sizeof(string), "[ %s przekaza³ broñ o UID %d z amunicj¹ %d dla gracza %s ]", pName(playerid), gun, ammo, pName(targetid));
    AdminWarning(COLOR_SPECIALGOLD, string);
    format(string, sizeof(string), "%s przekazal %s [ID: %d | UID %d ] bron UID %d z amunicja %d", pName(playerid), pName(targetid), targetid, pInfo[targetid][UID], gun, ammo);
    Log("/logs/setgun.log", string);
    return 1;
}

CMD:cc(playerid, params[])
{
    if(IsPlayerAdminLevel(playerid, 6)) return NoAccessMessage(playerid);
    for(new i=0; i < 90; i++) SendClientMessageToAll(COLOR_WHITE, " ");
    SendClientMessageToAll(COLOR_PANICRED, "»» Czat globalny zosta³ wyczyszczony!");
    return 1;
}

CMD:setvw(playerid, params[])
{
	new string[128], targetid, value;
	if(IsPlayerAdminLevel(playerid, 1)) return NoAccessMessage(playerid);
	if(sscanf(params, "ud", targetid, value)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /setvw [id/nick] [VW]");
	SetPlayerVirtualWorld(targetid, value);
	format(string, sizeof(string), "Twój VW zosta³ zmieniony na %d przez Admina %s", value, pName(playerid));
	ShowPlayerDialog(targetid, 443, DIALOG_STYLE_MSGBOX, DNAZWA" » Informacja", string, "Zamknij", "");
	format(string, sizeof(string), "Zmieni³eœ graczowi %s VW na %d", pName(targetid), value);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s zmieni³ VW %s na %d", pName(playerid), pName(targetid), value);
	printf(string);
	Log("/logs/setvw.log", string);
	return 1;
}

CMD:setint(playerid, params[])
{
	new string[128], targetid, value;
	if(IsPlayerAdminLevel(playerid, 1)) return NoAccessMessage(playerid);
	if(sscanf(params, "ud", targetid, value)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /setint [id/nick] [VW]");
	SetPlayerInterior(targetid, value);
	format(string, sizeof(string), "Twój interior zosta³ zmieniony na %d przez %s", value, pName(playerid));
	ShowPlayerDialog(targetid, 443, DIALOG_STYLE_MSGBOX, DNAZWA" » Informacja", string, "Zamknij", "");
	format(string, sizeof(string), "Zmieni³eœ graczowi %s interior na [ID: %d]", pName(targetid), value);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), " %s zmienil interior %s na %d", pName(playerid), pName(targetid), value);
	printf(string);
	Log(LOG_DIR_ADMIN, string);
	return 1;
}

CMD:setcarvw(playerid, params[])
{
	new string[128], carid, value;
	if(IsPlayerAdminLevel(playerid, 1)) return NoAccessMessage(playerid);
	if (sscanf(params, "dd", carid, value)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /setcarvw [VUID] [VW]");
	SetVehicleVirtualWorld(carid, value);
	format(string, sizeof(string), "%s zmieni³ VW pojazdu [VUID: %d] na %d", pName(playerid), carid, value);
    AdminWarning(COLOR_SPECIALGOLD, string);
	Log(LOG_DIR_ADMIN, string);
	return 1;
}

CMD:setskin(playerid, params[])
{
	new string[128], targetid, skinid;
	if(!IsPlayerAdminLevel(playerid, 6)) return NoAccessMessage(playerid);
	if(sscanf(params, "ud", targetid, skinid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /setskin [ID] [SKINID]");
	SetPlayerSkin(targetid, skinid);
	pInfo[targetid][Skin] = skinid;
	format(string, sizeof(string), "Twój skin zosta³ zmieniony na %d przez Admina %s", skinid, pName(playerid));
	ShowPlayerDialog(targetid, 443, DIALOG_STYLE_MSGBOX, DNAZWA" » Informacja", string, "Zamknij", "");
	format(string, sizeof(string), "Zmieni³eœ graczowi %s [UID: %d] skin na %d", pName(targetid), pInfo[playerid][UID], skinid);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), " %s zmienil skin gracza %s [%d] na %d", pName(playerid), pName(targetid), pInfo[playerid][UID], skinid);
	printf(string);
	Log(LOG_DIR_ADMIN, string);
	return 1;
}

/*CMD:fixv(playerid, params[])
{
	new string[64];
	if(IsPlayerAdminLevel(playerid, 1000) || IsPlayerAdminLevel(playerid, 6))
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Nie znajdujesz siê w pojeŸdzie!");
	if(IsPlayerInVehicle(playerid, GetPlayerVehicleID(playerid)))
	SetVehicleHealth(GetPlayerVehicleID(playerid), 1000);
	RepairVehicle(GetPlayerVehicleID(playerid));
	format(string, sizeof(string), "Pomyœlnie naprawiono pojazd VID: %d", GetPlayerVehicleID(playerid));
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "» Admin %s naprawi³ sobie pojazd [VID: %d] /fixv", pName(playerid), GetPlayerVehicleID(playerid));
    AdminWarning(COLOR_SPECIALGOLD, string);
	return 1;
}*/

/* test warunków tak : nie
CMD:over(playerid, params[])
{
	new string[128];
	format(string, sizeof(string), "Over jest superancki? %s", (pInfo[playerid][AdminLevel] == 1000 ? ("Tak") : ("Nie")));
	SendClientMessage(playerid, -1, string);
	return 1;
}
*/

