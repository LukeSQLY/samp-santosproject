#include <a_samp>
#include <a_mysql>
#include <YSI\y_ini>
#include <YSI_Data\y_foreach>
#include <streamer>
#include <zcmd>
#include <sscanf2>

//#define DB_DEBUG

#if defined DB_DEBUG
	#define MYSQL_HOST	 			"localhost"
	#define MYSQL_USER 				"root"
	#define MYSQL_PASS 				""
	#define MYSQL_DATABASE 		"samp"
#endif

#if !defined DB_DEBUG
	#define MYSQL_HOST       		"94.23.90.14" 
	#define MYSQL_USER       		"db_36017" 
	#define MYSQL_PASS        		"JYr221WqqlJj" 
	#define MYSQL_DATABASE    	"db_36017"
#endif


// ------------------------------------------------------------------------------------------
//	------------------------------ PUBLIC ------------------------------
// ------------------------------------------------------------------------------------------

forward OnPlayerDataCheck(playerid, corrupt_check);
public OnPlayerDataCheck(playerid, corrupt_check)
{
	if(corrupt_check != Corrupt_Check[playerid]) return Kick(playerid);
	new string[150];
	if(cache_num_rows() > 0) {
		cache_get_value_int(0, "uid", pInfo[playerid][UID]);  
		cache_get_value(0, "password", pInfo[playerid][Password], 65);
		cache_get_value(0, "salt", pInfo[playerid][Salt], 11);
		pInfo[playerid][PlayerCache] = cache_save();
		format(string, sizeof(string), "{FFFFFF}Witaj, %s.\n\n{0099FF}Konto o tym nicku jest ju¿ zarejestrowane.\n{0099FF}Wpisz poni¿ej swoje has³o aby przejœæ do gry!\n\n", pName(playerid));
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, DNAZWA " -  Logowanie" , string, "Zaloguj", "WyjdŸ");
	}
	else {
		format(string, sizeof(string), "{FFFFFF}Witaj, %s.\n\n{0099FF}Te konto nie jest jeszcze zarejestrowane.\n{0099FF}Zarejestruj siê ponizej aby przejœæ do gry!\n\n", pName(playerid));
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, DNAZWA " -  Rejestracja" , string, "Zarejestruj", "WyjdŸ");
	}
	return 1;
}

forward OnPlayerLogin(playerid);
public OnPlayerLogin(playerid) 
{
	banCache[playerid] = cache_save();
	cache_set_active(banCache[playerid]);
	if(cache_num_rows() > 0) {
		new reason[64], issuerName[24], date[64], string[256], title[64], uid;
		cache_get_value_int(0, "uid", uid);
		cache_get_value(0, "reason", reason, 64);
		cache_get_value(0, "issuername", issuerName, 24);
		cache_get_value(0, "date", date, 64);
		format(title, sizeof(title), "BAN [UID: %d]", uid);
		format(string, sizeof(string), "{ffffff}Twoje konto jest zbanowane!\n\nNadaj¹cy: {f25715}%s{ffffff}\nPowód: {f25715}%s{ffffff}\nData: {f25715}%s{ffffff}\n\nApelowaæ od kary mo¿esz na forum.", issuerName, reason, date);
		ShowPlayerDialog(playerid, 21377, DIALOG_STYLE_MSGBOX, title, string, "Zamknij", "");
		SetTimerEx("KickEx", 500, 0, "i", playerid);
		return 0;
	}
	else 
	{
		new string[128]; //stringdo logowan
		cache_set_active(pInfo[playerid][PlayerCache]);
		cache_get_value_int(0, "uid", pInfo[playerid][UID]);            	
		cache_get_value_int(0, "gamescore", pInfo[playerid][Score]);
		cache_get_value_int(0, "money", pInfo[playerid][Money]);
		cache_get_value_int(0, "adminlevel", pInfo[playerid][AdminLevel]);            
		cache_get_value_int(0, "skinid", pInfo[playerid][Skin]);
		cache_get_value_int(0, "hours", pInfo[playerid][Hours]); 
		cache_get_value_int(0, "minutes", pInfo[playerid][Minutes]);
		cache_get_value_int(0, "drivinglicense", pInfo[playerid][PrawoJazdy]);
		cache_get_value_int(0, "idcard", pInfo[playerid][Dowod]);
		cache_get_value_int(0, "faction", pInfo[playerid][Faction]);
		cache_get_value_int(0, "factionrank", pInfo[playerid][FactionRank]);
		cache_get_value_int(0, "factionleader", pInfo[playerid][FactionLeader]); 
		/*printf("\n\n------------------------------\n");
		printf("UID: %d", pInfo[playerid][UID]);
		printf("\nGS: %d", pInfo[playerid][Score]);
		printf("\nMoney: %d", pInfo[playerid][Money]);
		printf("\nAdminlvl: %d", pInfo[playerid][AdminLevel]);
		printf("\nSkin: %d", pInfo[playerid][Skin]);
		printf("\nHours: %d", pInfo[playerid][Hours]);
		printf("\nMinutes: %d", pInfo[playerid][Minutes]);
		printf("\ndrivinglicense: %d", pInfo[playerid][PrawoJazdy]);
		printf("\nidcard: %d", pInfo[playerid][Dowod]);
		printf("\nfaction: %d", pInfo[playerid][Faction]);
		printf("\nfactionl: %d", pInfo[playerid][FactionLeader]);
		printf("\n------------------------------\n\n");*/
		SetPlayerScore(playerid, pInfo[playerid][Score]);        		
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, pInfo[playerid][Money]);
		cache_delete(pInfo[playerid][PlayerCache]); //usuwamy cache bo niepotrzebny juz
		pInfo[playerid][PlayerCache] = MYSQL_INVALID_CACHE;
		Logged[playerid] = true;
		pInfo[playerid][Cuffs] = INVALID_PLAYER_ID;
		//CheckSpawn(playerid); - funkcja do ustalania miejsca spawnu [OFFLINE]
		//----- nadawanie statystyk
		SetPlayerScore(playerid, pInfo[playerid][Score]);        		
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, pInfo[playerid][Money]);
		//------ 3dtext
		Attach3DTextLabelToPlayer(pInfo[playerid][Player3DText], playerid, 0.0, 0.0, 0.18);
		UpdatePlayer3DName(playerid);
		//------ timery
		playerTimer[playerid] = SetTimerEx("AddPlayerTime", 60*1000, true, "i", playerid);
		updateTimer[playerid] = SetTimerEx("UpdatePlayerData", 5*1000, true, "i", playerid);
		SetTimerEx("DrawSpawn", 100, false, "i", playerid);
		//-----
		format(string, sizeof(string), "%s, witaj na serwerze!", pName(playerid));
		//SendClientMessage(playerid, COLOR_WHITE, "Jesteœ aktywnym donatorem do {f9cc00}26.06.2018");
		if(pInfo[playerid][AdminLevel] >= 1 && pInfo[playerid][AdminLevel] <= 5) strcat(string, " Posiadasz aktywny status {007eff}supportera");
		if(pInfo[playerid][AdminLevel] >= 6 && pInfo[playerid][AdminLevel] <= 999) strcat(string, " Posiadasz aktywny status {993333}gamemastera");
		if(pInfo[playerid][AdminLevel] >= 1000) strcat(string, " Posiadasz aktywny status {ff0000}administratora");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[@I] %s zalogowa³ siê na serwerze [DB-UID: %d | ID: %d] ", pName(playerid), pInfo[playerid][UID], playerid);
		AdminWarning(COLOR_ADMINCHAT, string);
	}
	return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
	new string[150], DB_Query[256];
	format(string, sizeof(string), "[ACv2]: %s zarejestrowa³ siê na serwerze ", pName(playerid));
	
	AdminWarning(COLOR_SPECIALGOLD, string);
	SendClientMessage(playerid, COLOR_GREY, "Pomyœlnie zarejestrowa³eœ siê! Teraz siê zaloguj!");
	
	Corrupt_Check[playerid]++;
	mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT * FROM `accounts` WHERE `name` = '%e' LIMIT 1", pName(playerid));
	mysql_tquery(Database, DB_Query, "OnPlayerDataCheck", "ii", playerid, Corrupt_Check[playerid]);// wczytywnie hasla i uid
	
	format(string, sizeof(string), "{FFFFFF}Witaj, %s.\n\n{0099FF}Konto o tym nicku jest ju¿ zarejestrowane.\n{0099FF}Wpisz poni¿ej swoje has³o aby przejœæ do gry!\n\n", pName(playerid));
	ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, DNAZWA " -  Logowanie" , string, "Zaloguj", "Wyjdz");
	return 1;
}

forward OnAdminUnBanPlayer(playerid);
public OnAdminUnBanPlayer(playerid)
{
	if(!cache_num_rows()) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Nie poprawny nick!");
		
	new temp[40], uid, DB_Query[128], name[MAX_PLAYER_NAME];
	
	cache_get_value(0, 0, temp);
	uid = strval(temp);
	
	cache_get_value(0, 1, temp);
	format(name, sizeof(name), temp);
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT `userid` FROM `bans` WHERE `userid` = '%d' LIMIT 1", uid);
	mysql_tquery(Database, DB_Query, "OnBanDelete", "iis", playerid, uid, name);
	return 1;
}

forward OnBanDelete(playerid, uid, name[]);
public OnBanDelete(playerid, uid, name[])
{
	if(!cache_num_rows()) return SendClientMessage(playerid, COLOR_GREY, "B£AD: Ten gracz nie jest zbanowany!");
	
	new DB_Query[64];
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "DELETE FROM `bans` WHERE `userid` = '%d'", uid);
	mysql_tquery(Database, DB_Query);
	
	format(C_STRING, sizeof(C_STRING), "Pomyœlnie odbanowano %s (UID: %d)!", name, uid);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff} - Informacja", C_STRING, "Zamknij", "");
	
	format(C_STRING, sizeof(C_STRING), "%s (UID: %d) odbanowal %s (UID: %d)", pName(playerid), pInfo[playerid][UID], name, uid);
	Log("/logs/admincmd.log", C_STRING); 

	format(C_STRING, sizeof(C_STRING), "OFFLINE %s zosta³ odbanowany przez Administratora %s (ID: %d) %s", name, pName(playerid), playerid);
	SendClientMessageToAll(COLOR_RED, C_STRING);
	return 1;
}

forward OnAdminOfflineBanPlayer(playerid, nick[], reason[]);
public OnAdminOfflineBanPlayer(playerid, nick[], reason[])
{
    if(!cache_num_rows())
        return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki gracz nie istnieje!");
    
    new temp[30], uid, DB_Query[256], string[128];
    cache_get_value(0, 0, temp);
    uid = strval(temp);
    
    mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT `reason` FROM `bans` WHERE `userid` = '%d' LIMIT 1", uid);
    mysql_tquery(Database, DB_Query, "IsPlayerBannedCheck", "i", playerid);
    
    if(GetPVarInt(playerid, "BANNED") == 0)
    {
        mysql_format(Database, DB_Query, sizeof(DB_Query), "INSERT INTO `bans` (`userid`, `reason`, `issuername`, `date`) VALUES ('%d', '%s', '%s', CURRENT_TIMESTAMP)", uid, reason, pName(playerid));
        mysql_tquery(Database, DB_Query);
        
        format(C_STRING, sizeof(C_STRING), "Pomyœlnie zbanowa³eœ %s (UID: %d) z powodem: %s!", nick, uid, reason);
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
        
        format(C_STRING, sizeof(C_STRING), "%s (UID: %d) zbanowal offline gracza %s (UID: %d) z powodem %s", pName(playerid), pInfo[playerid][UID], nick, uid, reason);
        Log("/logs/admincmd.log", C_STRING);
        

        format(string, sizeof(string),"~r~Ban (OFFLINE)~n~~w~Gracz: %s~n~Nadajacy: %s~n~Powod: ~y~~h~%s", nick, pName(playerid), reason); 
        ShowPenalty(string);
        //format(C_STRING, sizeof(C_STRING), "OFFLINE %s zosta³ zbanowany przez Administratora %s (ID: %d) Powód: %s", nick, pName(playerid), playerid, reason);
        //SendClientMessageToAll(COLOR_RED, C_STRING);
        return 1;
    }
    return 1;
}



// ------------------------------------------------------------------------------------------
//			------------------------------ RESZTA ------------------------------
// ------------------------------------------------------------------------------------------

stock ClearPlayerData(playerid) {
	//===rozne==
	loginAttempts[playerid] = 3;
	//===enum pinfo==
	pInfo[playerid][AdminLevel] = 0;
	pInfo[playerid][Score] = 0;
	pInfo[playerid][Money] = 0;
	pInfo[playerid][Skin] = 0;
	pInfo[playerid][Hours] = 0;
	pInfo[playerid][Minutes] = 0;
	pInfo[playerid][Job] = 0;
	pInfo[playerid][Faction] = 0;
	pInfo[playerid][FactionRank] = 0;
	pInfo[playerid][FactionLeader] = 0;
	pInfo[playerid][PrawoJazdy] = 0;
	pInfo[playerid][Dowod] = 0;
	pInfo[playerid][AntyDM] = 0;
	pInfo[playerid][Cuffs] = INVALID_PLAYER_ID;
	Delete3DTextLabel(pInfo[playerid][Player3DText]);
	//===cache===
	cache_delete(banCache[playerid]);
	banCache[playerid] = MYSQL_INVALID_CACHE;
	cache_delete(pInfo[playerid][PlayerCache]);
	pInfo[playerid][PlayerCache] = MYSQL_INVALID_CACHE;
}