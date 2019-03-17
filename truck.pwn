#include <a_samp>
//#include <nex-ac> //ANTY-CHEAT
#include <a_mysql>
//#include <foreach>
#include <YSI\y_ini>
#include <YSI_Data\y_foreach>
#include <streamer>
#include <zcmd>
#include <sscanf2>

/*>>>>>>MODULY<<<<<<*/

#include "modules/define.pwn" 			// Definicje
#include "modules/kolory.pwn" 			// Definicje kolorów
#include "modules/obiekty.pwn" 			// CreateObject
#include "modules/admin.pwn"			// Flagi, system administratora
#include "modules/doors.pwn"			// Drzwi
#include "modules/funkcje.pwn"			// Funkcje
#include "modules/groups.pwn"			// Grupy
//#include "modules/frakcje.pwn"			// System frakcji
#include "modules/prace.pwn" 			// Definicje kolorów
#include "modules/komendy.pwn"		// Komendy
//#include "modules/admincmd.pwn"		// Komendy Administratora
#include "modules/mysql.pwn"			// MYSQL
#include "modules/vehicle.pwn"  		// Pojazdy

/*>>>>>>DEFINICJE SERWERA<<<<<<*/

#undef MAX_PLAYERS
#define MAX_PLAYERS 50

//#define DEBUG 1
//debug definiujemy TYLKO w wersjach deweloperskich, jesli skrypt jest wpuszczany na publiczny serwer to odblokuje to dostep do wielu komend dajacych admina etc.

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>//
//>>>>>>>>>>>>>>> SAMP CALLBACK <<<<<<<<<<<<<<< //
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>//
public OnGameModeInit()
{
	// | MYSQL Connection //
	new MySQLOpt: option_id = mysql_init_options(), ticks = GetTickCount();
	mysql_set_option(option_id, AUTO_RECONNECT, true);
	Database = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATABASE, option_id);
	if(Database == MYSQL_INVALID_HANDLE || mysql_errno(Database) != 0)
	{
		printf("[MYSQL - ERROR] Nie udało sie połączyć z bazą danych[%s], serwer wyłącza sie. ERRNO CODE: %d", MYSQL_HOST, mysql_errno(Database));
		SendRconCommand("exit");
		return 1;
	}
	print("\n\n=========================================================================================");
	printf("\t   [MYSQL - SUCCESS] Połączenie z bazą danych[%s] powiodło się.", MYSQL_HOST);
	print("=========================================================================================\n\n");
	SetGameModeText(NAZWA" "WERSJA);

	// | USTAWIENIA ROZGRYWKI NA SERWERZE | //
	AllowInteriorWeapons(1); 			// Zezwolenie na broń w interiorach
	DisableInteriorEnterExits(); 		// Brak wejść do interiorów ze zwykłego GTA:SA
	EnableStuntBonusForAll(0); 			// Wyłączone stunty
	ManualVehicleEngineAndLights(); 	// Manualne włączanie silnika i świateł
	ShowNameTags(0); 					// Nametagi nad głową
	ManualVehicleEngineAndLights(); 	// Światła samochodów działają w dzień

	// | LADOWANIE FUNKCJI | //
	print("================== Ładowanie kluczowych modułów skryptu ==================\n");
	LoadGroups();		// Ładowanie grup
	//LoadFactions(); 	// Ładowanie frakcji
	//LoadDoors();		// Ładowanie drzwi
	LoadJob();			// Ładowanie prac dorywczych
	//LoadPickup(); 		// Ładowanie pickupów
	Load3DText();		// Ładowanie 3D Text
	LoadObjects();		// Ładowanie obiektów
	LoadActor(); 		// Ładowanie aktorów
	LoadTextDraw(); 	// Ładowanie textdrawów
	LoadVehicles(); 	// Ładowanie pojazdów
	LoadPetrolStations();
	TimeUpdater();		//realny czas
	print("\n================== Ładowanie kluczowych modułów skryptu ==================\n\n\n");
	printf("OnGameModeInit: %dms", GetTickCount() - ticks);

	// | TIMERY SKRYPTOWE | //
	SetTimer("AutoSaveInfo", 15*60*1000, true);
	SetTimer("UpdateTime", 1000 * 60, 1);
	
	for(new x = 0; x < sizeof(Compressor); x++)
	{
		CreateDynamic3DTextLabel("/kompresor - użyj aby napompować opony", -1, Compressor[x][0], Compressor[x][1], Compressor[x][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
	}
	return 1;
}

public OnGameModeExit()
{
	mysql_close(Database);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	new DB_Query[115];
	for(new xd=0; xd < 40; xd++) SendClientMessage(playerid, COLOR_WHITE, " ");
	SetPlayerColor(playerid, -1);
	GetPlayerIp(playerid, pInfo[playerid][IP], 32);
	// -- Czas na serwie --//
	gettime(hours, minutes);
    SetPlayerTime(playerid, hours, minutes);
	// -- Funkcje -- //
	RemoveBuildings(playerid);
	TogglePlayerSpectating(playerid, 1);
	SetTimerEx("LoginCamera", 3000, false, "d", playerid);
	TextDrawShowForPlayer(playerid, textdraw_0); //Santosproject
	// -- MYSQL -- //
	Corrupt_Check[playerid]++;
	mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT * FROM `accounts` WHERE `name` = '%e' LIMIT 1", pName(playerid));
	mysql_tquery(Database, DB_Query, "OnPlayerDataCheck", "ii", playerid, Corrupt_Check[playerid]);// wczytywnie hasla i uid
	// -- Nicki 3D -- //
	pInfo[playerid][Player3DText] = Create3DTextLabel(pName(playerid), COLOR_WHITE, 30.0, 40.0, 50.0, 30.0, 0, 0);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new DB_Query[600];
	if(Logged[playerid]) 
	{
		Corrupt_Check[playerid]++;
		mysql_format(Database, DB_Query, sizeof(DB_Query), "UPDATE `accounts` SET `faction` = '%d', `factionrank` = '%d', `factionleader` = '%d', `adminlevel` = '%d', ",\
		pInfo[playerid][Faction], pInfo[playerid][FactionRank], pInfo[playerid][FactionLeader], pInfo[playerid][AdminLevel]);
		mysql_format(Database, DB_Query, sizeof(DB_Query), "%s`drivinglicense` = '%d', `idcard` = '%d', `gamescore` = '%d', `job` = '%d', `money` = '%d', `skinid` = '%d', `hours` = '%d', `minutes` = '%d', `lastonline` = now(), `lastip` = '%s' WHERE `uid` = '%d'",\
		DB_Query, pInfo[playerid][PrawoJazdy], pInfo[playerid][Dowod], pInfo[playerid][Score], pInfo[playerid][Job], pInfo[playerid][Money], pInfo[playerid][Skin], pInfo[playerid][Hours], pInfo[playerid][Minutes], pInfo[playerid][IP], pInfo[playerid][UID]);
		mysql_tquery(Database, DB_Query);
		KillTimer(playerTimer[playerid]);
		KillTimer(updateTimer[playerid]);
	}
	format(DB_Query, sizeof(DB_Query), "%s opuścił serwer, kod wyjścia: %d", pName(playerid), reason);
	Log("/logs/disconnect.log", DB_Query);
	Logged[playerid] = false;
	ClearPlayerData(playerid);
	KillTimer(CuffsTimer[playerid]);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	EscapeString(inputtext);
	switch (dialogid)
	{
		case DIALOG_LOGIN: {
			if(!response) return Kick(playerid);
			new Salted_Key[65], string[128];
			SHA256_PassHash(inputtext, pInfo[playerid][Salt], Salted_Key, 65);
			if(strcmp(Salted_Key, pInfo[playerid][Password]) == 0)
			{
				mysql_format(Database, string, sizeof(string), "SELECT * FROM `bans` WHERE `userid` = '%d' LIMIT 1", pInfo[playerid][UID]);
				mysql_tquery(Database, string, "OnPlayerLogin", "i", playerid);
			}
			else {
				loginAttempts[playerid]--;
				if(loginAttempts[playerid] < 1) {
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_MSGBOX, DNAZWA " - Logowanie" , "{ff0000}Złe hasło!\nPrzekroczyłeś maksymalną ilość prób logowania, zostajesz wyrzucony z serwera.", "Wyjdź", "");
					SetTimerEx("KickEx", 100, 0, "i", playerid);
					return 0;
				}
				new String[256];
				format(String, sizeof(String), "{ff0000}Złe hasło! Liczba prób przed wyrzuceniem: %d/3 \n\n{FFFFFF}Witaj, %s.\n\n{0099FF}Konto o tym nicku jest już zarejestrowane.\n{0099FF}Wpisz poniżej swoje hasło aby przejść do gry!\n\n", loginAttempts[playerid], pName(playerid));
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, DNAZWA " - Logowanie" , String, "Zaloguj", "Wyjdź");
			}
		}
		case DIALOG_REGISTER: {
			if(!response) return Kick(playerid);
			if(strlen(inputtext) <= 5 || strlen(inputtext) > 60) {
				SendClientMessage(playerid, 0x969696FF, "Nieprawidłowa długość hasła. Musi być to wartość wynosząca conajmniej 5, ale nie wyższa niż 60.");
				new string[150];
				format(string, sizeof(string), "{FFFFFF}Witaj, %s.\n\n{0099FF}Te konto nie jest jeszcze zarejestrowane.\n{0099FF}Zarejestruj sie poniżej aby przejść do gry!\n\n", pName(playerid));
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, DNAZWA " - Rejestracja", string, "Zarejestruj", "Wyjdź");
			}
			else {
				for (new i = 0; i < 10; i++) pInfo[playerid][Salt][i] = random(79) + 47;
				pInfo[playerid][Salt][10] = 0;
				SHA256_PassHash(inputtext, pInfo[playerid][Salt], pInfo[playerid][Password], 65);
				new DB_Query[612];
				format(DB_Query, sizeof(DB_Query), "INSERT INTO `accounts` (`name`, `password`, `salt`, `skinid`, `money`, `hours`, `minutes`, `job`, `drivinglicense`, `idcard`, `gamescore`, `lastonline`, `createdate`)");
				mysql_format(Database, DB_Query, sizeof(DB_Query), "%s VALUES ('%s', '%s', '%s', '%d', '%d', '0', '0', '0', '0', '0', '%d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
				DB_Query, pName(playerid), pInfo[playerid][Password], pInfo[playerid][Salt], STARTING_SKIN, STARTING_MONEY, STARTING_GAMESCORE);
				mysql_tquery(Database, DB_Query, "OnPlayerRegister", "d", playerid);
			}
			return 0;
		}
		case RADIO_DIALOG: {
			if(response == 1) {
				switch(listitem) {
					case 0: PlayAudioStreamForPlayer(playerid, R_OFF);
					case 1: PlayAudioStreamForPlayer(playerid, R_RMF);
					case 2: PlayAudioStreamForPlayer(playerid, R_RMXX);
					case 3: PlayAudioStreamForPlayer(playerid, R_PARTY);
					case 4: PlayAudioStreamForPlayer(playerid, R_OPENFM);
				}
			}
		}
		case DIALOG_DESC: {
			new string[128];
			if(!response) return 0;
			if(isnull(inputtext)) return 0;
			if(strlen(inputtext) <= 4 || strlen(inputtext) > 60) return SendClientMessage(playerid, COLOR_GREY, "Twój opis musi mieć między 5 a 60 znaków!");
			if(response){
				if(Opis[playerid] == Text3D:INVALID_3DTEXT_ID && !strcmp(inputtext, "-", true)) {
				SendClientMessage(playerid, -1, "usunales se opis");
				Delete3DTextLabel(Opis[playerid]); 
				return 1;
				}
				format(string, sizeof(string), "Ustawiłeś sobie nowy opis: %s", inputtext);
				SendClientMessage(playerid, COLOR_GREY, string);
				if(!Opis[playerid]) {
					Opis[playerid] = Create3DTextLabel(inputtext, 0xC2A2DAAA, 30.0, 40.0,-0.5, 8.0, 0, 1);
					Attach3DTextLabelToPlayer(Opis[playerid], playerid, 0.0, 0.0, -0.7); 
				}
				else if(Opis[playerid]) {
					Update3DTextLabelText(Opis[playerid], 0xC2A2DAAA, inputtext); 
				}
			}
		}
		case INFO_JOB_DIALOG: {
			if(response == 1) {
				switch(listitem) {
					case 0:
					{
						SetPlayerCheckpoint(playerid, 795.0795,-289.9354,18.1515, 2.0);
						SendClientMessage(playerid, COLOR_WHITE, "{00cc00}GPS:{ffffff} Zaznaczono miejsce docelowe na mapie.");
						CJob1[playerid] = true;
					}
					case 1: SendClientMessage(playerid, -1, "Pracodawca nie podał siedziby firmy");
				}
			}
		}
		case DIALOG_FACTION_PANEL: {
			if(!response) return 0;
			if(response) {
				new factionid = pInfo[playerid][Faction], string[256] = "Lista członków: \n";
				switch(listitem) {
					case 0: { // zmien nazwe frakcji
						ShowPlayerDialog(playerid, DIALOG_FACTION_CHANGENAME, DIALOG_STYLE_INPUT, DNAZWA " - zmiana nazwy frakcji", "{ffffff}Wpisz poniżej nową nazwę dla swojej frakcji:", "Gotowe", "Anuluj");
					}
					case 1: { // spawn
						ShowPlayerDialog(playerid, DIALOG_FACTION_CHANGESPAWN, DIALOG_STYLE_MSGBOX, DNAZWA " - zmiana spawnu frakcji", "{ffffff}Jesteś pewny że chcesz zmienić spawn swojej organizacji?\nOd tego momentu jej członkowie będą spawnowali się w miejscu w którym stoisz.", "OK", "Anuluj");
					}
					case 2: { // lista czlonkow
						mysql_format(Database, string, sizeof(string),"SELECT `name`, `uid`, `factionrank` FROM `accounts` WHERE `faction` = '%d'", factionid);
						mysql_tquery(Database, string, "MYSQL_DialogFactionMembers", "ii", playerid, factionid);
					}
					case 3: { // zmien motd
						ShowPlayerDialog(playerid, DIALOG_FACTION_CHANGEMOTD, DIALOG_STYLE_INPUT, DNAZWA " - zmiana motd", "{ffffff}Wpisz poniżej nowy tekst który będzie wyświetlany przy spawnie:", "Gotowe", "Anuluj");
					}
				}
			}
		}
		case DIALOG_FACTION_CHANGENAME: {
			if(!response) return 0;
			if(response) {
				if(strlen(inputtext) <= 4 || strlen(inputtext) > 63) return ShowPlayerDialog(playerid, DIALOG_FACTION_CHANGENAME, DIALOG_STYLE_INPUT, DNAZWA " - zmiana nazwy frakcji", "{ff0000}MOTD musi zawierać od 4 do 63 znaków!\n\n{ffffff}Wpisz poniżej nową nazwę dla swojej frakcji:", "Gotowe", "Anuluj");
				new DB_Query[168];
				mysql_format(Database, DB_Query, sizeof(DB_Query), "UPDATE `factions` SET `name` = '%e' WHERE `uid` = '%d'", inputtext, pInfo[playerid][Faction]);
				mysql_tquery(Database, DB_Query);
				format(DB_Query, sizeof(DB_Query), "»» Pomyślnie zmieniłeś nazwę frakcji na %s.", inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, DB_Query);
				format(fInfo[pInfo[playerid][Faction]][Name], 64, "%s", inputtext);
				format(DB_Query, sizeof(DB_Query), "%s zmienił nazwę frakcji o UID %d na %s", pName(playerid), pInfo[playerid][Faction], inputtext);
				Log(LOG_DIR_FACTION, DB_Query);

			}
		}
		case DIALOG_FACTION_CHANGEMOTD: {
			if(!response) return 0;
			if(response) {
				if(strlen(inputtext) <= 4 || strlen(inputtext) > 63) return ShowPlayerDialog(playerid, DIALOG_FACTION_CHANGEMOTD, DIALOG_STYLE_INPUT, DNAZWA " - zmiana motd", "{ff0000}MOTD musi zawierać od 4 do 63 znaków!\n\n{ffffff}Wpisz poniżej nowy tekst który będzie wyświetlany przy spawnie:", "Gotowe", "Anuluj");
				new DB_Query[168];
				mysql_format(Database, DB_Query, sizeof(DB_Query), "UPDATE `factions` SET `motd` = '%e' WHERE `uid` = '%d'", inputtext, pInfo[playerid][Faction]);
				mysql_tquery(Database, DB_Query);
				format(DB_Query, sizeof(DB_Query), "»» Pomyślnie zmieniłeś MOTD na %s.", inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, DB_Query);
				format(fInfo[pInfo[playerid][Faction]][Motd], 64, "%s", inputtext);
				format(DB_Query, sizeof(DB_Query), "%s zmienił motd frakcji o UID %d na %s", pName(playerid), pInfo[playerid][Faction], inputtext);
				Log(LOG_DIR_FACTION, DB_Query);
			}
		}
		case DIALOG_FACTION_CHANGESPAWN: {
			if(!response) return 0;
			if(response) {
				new Float:X, Float:Y, Float:Z, DB_Query[168];
				GetPlayerPos(playerid, X, Y, Z);
				mysql_format(Database, DB_Query, sizeof(DB_Query), "UPDATE `factions` SET `spawnX` = '%f', `spawnY` = '%f', `spawnZ` = '%f' WHERE `uid` = '%d'", X, Y, Z, pInfo[playerid][Faction]);
				mysql_tquery(Database, DB_Query);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "»» Pomyślnie zmieniłeś lokalizację spawnu!");
				format(DB_Query, sizeof(DB_Query), "%s zmienił spawn frakcji o UID %d", pName(playerid), pInfo[playerid][Faction], inputtext);
				Log(LOG_DIR_FACTION, DB_Query);
			}
		}
		case DIALOG_SHOW_PLAYER_VEHICLES: {
			if(!response) return 0;
			if(response) {
				new vehid, name[41];
				sscanf(inputtext, "ds[41]", vehid, name);

				new vehuid = GetVehicleSpecialID(vehid);

				if(VehicleCache[vehuid][vSpawned] == VEHICLE_NO_SPAWNED)
				{
					/*if(pInfo[playerid][SpawnedVehicles] >= 3) // to sobie odblokujcie jak bedzie juz vip i te sprawy
					{
						if(pInfo[playerid][VIP] != false)
							return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacja", "Przekroczyłeś limit zespawnowanych pojazdów! Zakup konto premium aby móc spawnowować większą ilość!", "Zamknij", "");
					}*/

					SpawnVehicle(vehid);

					format(C_STRING, sizeof(C_STRING), "Twój pojazd %s (UID: %d) został pomyślnie zespawnowany!", name, vehid);
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacja - pojazd", C_STRING, "Zamknij", "");

					format(C_STRING, sizeof(C_STRING), "%s zespawnował pojazd o UID %d", pName(playerid), vehid);
					Log(LOG_DIR_VEHICLE, C_STRING);

				}
				else if(VehicleCache[vehuid][vSpawned] == VEHICLE_SPAWNED)
				{
					SaveVehicle(vehid, SAVE_VEHICLE_ALL);

					UnspawnVehicle(vehid);
					
					if(CP_TRACE_VEHICLE[playerid]) {
						DisablePlayerCheckpoint(playerid); }

					format(C_STRING, sizeof(C_STRING), "Twój pojazd %s (UID: %d) został odspawnowany!", name, vehid);
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacja - pojazd", C_STRING, "Zamknij", "");

					format(C_STRING, sizeof(C_STRING), "%s odspawnowal pojazd o UID %d", pName(playerid), vehid);
					Log(LOG_DIR_VEHICLE, C_STRING);
				}
			}

		}
		case DIALOG_SHOW_MENU_VEHICLE: {
			if(!response) return 0;
			if(response) {
				UpdateVehicleParamsEx(GetPlayerVehicleID(playerid), listitem);
			}
		}
		case DIALOG_SHOW_PLAYER_VEHICLES_TRA: {
			if(!response) return 0;
			if(response) {

				new vehid, name[41], Float:local_x, Float:local_y, Float:local_z;
				sscanf(inputtext, "ds[41]", vehid, name);

				new vehuid = GetVehicleSpecialID(vehid);

				GetVehiclePos(VehicleCache[vehuid][vID], local_x, local_y, local_z);

				SetPlayerCheckpoint(playerid, local_x, local_y, local_z, 5.0);

				CP_TRACE_VEHICLE[playerid] = true;

				format(C_STRING, sizeof(C_STRING), "Twój pojazd %s (UID: %d) został zaznaczony na mapie!", name, vehid);
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacja - pojazd", C_STRING, "Zamknij", "");

				format(C_STRING, sizeof(C_STRING), "%s namierzyl pojazd o UID %d", pName(playerid), vehid);
				Log(LOG_DIR_VEHICLE, C_STRING);
			}
		}
		case DIALOG_VEHICLE_SET_DESCRIPTION: {
			if(!response) return 0;
			if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_VEHICLE_SET_DESCRIPTION, DIALOG_STYLE_INPUT, DNAZWA " {ffffff}- informacja", "Wpisz poniżej opis, który chcesz ustawić dla pojazdu %s (UID: %d)", "Ustaw", "Zamknij");
			if(response) {
				
				new vehid = GetPlayerVehicleID(playerid);
				new x = GetVehicleSpecialID(GetVehicleUID(vehid));
				
				if(!strcmp(inputtext, "usun", true))
				{
					if(!IsValidDynamic3DTextLabel(VehicleCache[x][vDescription]))
						return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Pojazd nie ma ustawionego opisu!", "Zamknij", "");
					
					DestroyDynamic3DTextLabel(VehicleCache[x][vDescription]);
					
					format(C_STRING, sizeof(C_STRING), "Pomyślnie usunałeś opis z pojazdu %s (UID: %d)", VehicleCache[x][vName], VehicleCache[x][vUID]);
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
					
					format(C_STRING, sizeof(C_STRING), "%s (UID: %d) usunal opis z pojazdu %s (UID: %d)", pName(playerid), pInfo[playerid][UID], VehicleCache[x][vName], VehicleCache[x][vUID]);
					Log(LOG_DIR_VEHICLE, C_STRING);
					return 0;
				}
				
				if(IsValidDynamic3DTextLabel(VehicleCache[x][vDescription]))
					UpdateDynamic3DTextLabelText(VehicleCache[x][vDescription], -1, inputtext);
				else if(!IsValidDynamic3DTextLabel(VehicleCache[x][vDescription]))
					VehicleCache[x][vDescription] = CreateDynamic3DTextLabel(inputtext, -1, 0.0, 0.0, 0.0, 5.0, INVALID_PLAYER_ID, vehid);
				
				format(C_STRING, sizeof(C_STRING), "Pomyślnie ustawiłeś opis pojazdu %s (UID: %d). Opis: %s", VehicleCache[x][vName], VehicleCache[x][vUID], inputtext);
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
				
				format(C_STRING, sizeof(C_STRING), "%s (UID: %d) ustawil opis /%s/ dla pojazdu %s (UID: %d)", pName(playerid), pInfo[playerid][UID], inputtext, VehicleCache[x][vName], VehicleCache[x][vUID]);
				Log(LOG_DIR_VEHICLE, C_STRING);
			}
		}	
		case DIALOG_SALON_SELECT_CLASS: {
			if(!response) return 0;
			if(response) {
				LookVehiclesOfSalon(playerid, listitem); }
		}
		case DIALOG_DELETE_PETROL: {
			if(!response) return 0;
			if(response)
			{
				new x = GetPVarInt(playerid, "INDEX_PETROL");
				
				format(C_STRING, sizeof(C_STRING), "Pomyślnie usunąłeś stacje paliw {%s}%s {FFFFFF}(UID: %d)", PetrolCache[x][pColor], PetrolCache[x][pNameStation], PetrolCache[x][pUID]);
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
				
				format(C_STRING, sizeof(C_STRING), "%s (UID: %d) usunal stacje paliw %s (UID: %d)", pName(playerid), pInfo[playerid][UID], PetrolCache[x][pNameStation], PetrolCache[x][pUID]);
				Log(LOG_DIR_ADMIN, C_STRING);
				
				DestroyPetrolStation(x);
			}
		}
	}
	return 0;
}

public OnPlayerSpawn(playerid)
{
	gettime(hours, minutes);
    SetPlayerTime(playerid, hours, minutes);
	SetPlayerSkin(playerid, pInfo[playerid][Skin]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	GetPlayerPos(playerid, pInfo[playerid][BWPos][0], pInfo[playerid][BWPos][1], pInfo[playerid][BWPos][2]);
	GetPlayerFacingAngle(playerid, pInfo[playerid][BWPos][3]);
	SetTimerEx("bw_yes", 1000, 0, "i", playerid);
	GameTextForPlayer(playerid, "NIEPRZYTOMNY!", 15000, 1);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(!Logged[playerid]) return 0;
	new textstring[128];
	if(text[0] == '@') {
		text[0] = ' ';
		if(!IsPlayerAdminEx(playerid)) return 0;
		if(IsPlayerAdminLevel(playerid, 1000)) format(textstring, sizeof(textstring), "[H@] %s: %s", pName(playerid), text);
		else if(IsPlayerAdminLevel(playerid, 6)) format(textstring, sizeof(textstring), "[Administrator] %s: %s", pName(playerid), text);
		else if(IsPlayerAdminLevel(playerid, 1)) format(textstring, sizeof(textstring), "[Supporter] %s: %s", pName(playerid), text);
		foreach(new p : Player) {
			if(IsPlayerAdminEx(p)) SendClientMessage(p, COLOR_ADMINCHAT, textstring);
		}
		format(textstring, sizeof(textstring), CGLOBAL "ADMINCHAT: %s[%d]: %s", pName(playerid), playerid, text);
		print(textstring);
		return 0;
	}
	if(pInfo[playerid][AdminLevel] >= 1000) format(textstring, sizeof(textstring), CGLOBAL " {FF0000} %s {6495ED}[%d] {FFFFFF}: %s", pName(playerid), playerid, text);
	if(pInfo[playerid][AdminLevel] >= 6 && pInfo[playerid][AdminLevel] <= 999) format(textstring, sizeof(textstring), CGLOBAL " {993333} %s {6495ED}[%d] {FFFFFF}: %s", pName(playerid), playerid, text);
	else if(pInfo[playerid][AdminLevel] >= 1 && pInfo[playerid][AdminLevel] <= 5)  format(textstring, sizeof(textstring), CGLOBAL " {007EFF} %s {6495ED}[%d] {FFFFFF}: %s", pName(playerid), playerid, text);
	else format(textstring, sizeof(textstring), CGLOBAL " %s {6495ED}[%d]{FFFFFF}: %s", pName(playerid), playerid, text);
	SendClientMessageToAll(COLOR_WHITE, textstring);
	Log("/logs/chat.log", textstring);
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new Float:pos_player[3];
	GetPlayerPos(playerid, pos_player[0], pos_player[1], pos_player[2]);
	
	if(!ispassenger || IsPlayerAdminLevel(playerid, 1000))
	{
		new vehuid = GetVehicleUID(vehicleid);
		new vehid = GetVehicleSpecialID(vehuid);
		
		if(VehicleCache[vehid][vType] == OWNER_PLAYER)
		{
			if(VehicleCache[vehid][vOwner] != pInfo[playerid][UID])
			{
				SetPlayerPos(playerid, pos_player[0], pos_player[1], pos_player[2]);
				ClearAnimations(playerid);
				
				GameTextForPlayer(playerid, "~r~Nie jestes wlascicielem tego pojazdu!", 3000, 5);
				return 1;
			}
		}
		else if(VehicleCache[vehid][vType] == OWNER_FACTION)
		{
			if(VehicleCache[vehid][vOwner] != pInfo[playerid][Faction])
			{
				SetPlayerPos(playerid, pos_player[0], pos_player[1], pos_player[2]);
				ClearAnimations(playerid);
				
				GameTextForPlayer(playerid, "~r~Nie mozesz wsiasc do tego pojazdu!", 3000, 5);
				return 1;
			}
			else if(VehicleCache[vehid][vOwner] == pInfo[playerid][Faction] && VehicleCache[vehid][vRankNumber] > pInfo[playerid][FactionRank])
			{
				SetPlayerPos(playerid, pos_player[0], pos_player[1], pos_player[2]);
				ClearAnimations(playerid);
				
				GameTextForPlayer(playerid, "~r~Nie mozesz wsiasc do tego pojazdu!", 3000, 5);
				return 1;
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(CJob1[playerid]) {
		SendClientMessage(playerid, COLOR_WHITE, "{ff0000}GPS:{ffffff} Dojechałeś na miejsce.");
		ShowPlayerDialog(playerid, DIALOG_JOB_GRASS, DIALOG_STYLE_MSGBOX, DNAZWA" - Prace dorywcza", "W tym miejscu możesz dołaczyć do pracy dorywczej jako Kosiarz trawy\n Aby dołaczyć do pracy użyj {f9cc00}/dolacz ", "Dołacz", "Zamknij");
		DisablePlayerCheckpoint(playerid);
		CJob1[playerid] = false;
	}

	if(CP_TRACE_VEHICLE[playerid]) {
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}
public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	new string[128];
	SendClientMessage(playerid, COLOR_LIGHTRED, "Jeżeli uważasz, że to błąd zrób SS z tej linijki i wklej do zgłoszenia || CODE:01OVM");
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{f9cc00}ACv2", "{ffffff}Zostajesz wyrzucony z serwera przez AC, KOD: #1 ", "Ok", "Zamknij");
	format(string, sizeof(string), "[ACv2]: %s został wyrzucony z serwera | Kod #1 ", pName(playerid));
	AdminWarning(COLOR_LIGHTGREEN, string);
	SetTimerEx("KickEx", 1000, 0, "i", playerid);
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	new string[128];
	SendClientMessage(playerid, COLOR_LIGHTRED, "Jeżeli uważasz, że to błąd zrób SS z tej linijki i wklej do zgłoszenia || CODE:02OVPJ");
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{f9cc00}ACv2", "{ffffff}Zostajesz wyrzucony z serwera przez AC, KOD: #2 ", "Ok", "Zamknij");
	format(string, sizeof(string), "[ACv2]: %s został wyrzucony z serwera | Kod #2 ", pName(playerid));
	AdminWarning(COLOR_LIGHTGREEN, string);
	SetTimerEx("KickEx", 1000, 0, "i", playerid);
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_SPRINT | KEY_WALK)) return cmd_drzwi(playerid, "przejdz"); //------WEJSCIE NA PRZYCISK
	//------------ ODPALANIE SILNIKA ----------------
	if(newkeys == KEY_YES)
	{
		if(IsPlayerInAnyVehicle(playerid)) {
			new vehicleid = GetPlayerVehicleID(playerid), engine = 0, lights = 0, alarm = 0, doors = 0, bonnet = 0, boot = 0, objective = 0, Float:x, Float:y, Float:z;
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
			if(engine == 1) {
				GetPlayerPos(playerid,Float:x,Float:y,Float:z);
				for(new i = 0; i <= MAX_PLAYERS; i++) {
					if(IsPlayerInRangeOfPoint(i,20.0,Float:x,Float:y,Float:z)) {
						new string[128];
						format(string, sizeof(string), "* %s wyłącza silnik pojazdu.", pName(playerid));
						SendClientMessage(i, COLOR_PURPLE, string);
					}
				}
				SetVehicleParamsEx(vehicleid, 0, 0, alarm, doors, bonnet, boot, objective);
				return 1;
			}
			else {
				GetPlayerPos(playerid,Float:x,Float:y,Float:z);
				for(new i = 0; i <= MAX_PLAYERS; i++) {
					if(IsPlayerInRangeOfPoint(i,20.0,Float:x,Float:y,Float:z)) {
						new string[128];
						format(string, sizeof(string), "* %s uruchamia silnik pojazdu.", pName(playerid));
						SendClientMessage(i, COLOR_PURPLE, string);
					}
				}
				SetVehicleParamsEx(vehicleid, 1, 0, alarm, doors, bonnet, boot, objective);
			}
			return 1;
		}
	}
	//------------ ODPALANIE SILNIKA END----------------
	//--------------------------------------------------
	if(newkeys == KEY_JUMP)
	{
		if(GetPVarInt(playerid, "Spectating"))
		if(IsPlayerAdminLevel(playerid, 1)) {
			TogglePlayerSpectating(playerid, 0);
			SetPlayerPos(playerid, pInfo[playerid][SpecPos][0], pInfo[playerid][SpecPos][1], pInfo[playerid][SpecPos][2]);
			SetPlayerFacingAngle(playerid, pInfo[playerid][SpecPos][3]);
			SetPVarInt(playerid, "Spectating", 0);
			GameTextForPlayer(playerid, ".", 1, 4); 
		} 
	}
	//-------------- SALON ------------------
	//---------------------------------------
	if(newkeys & KEY_JUMP)
	{
		if(IsPlayerLookingVehicle[playerid] == true)
		{
			new index = SalonVeh[playerid][sIndex];
			new class = SalonVeh[playerid][sClass];
			
			if(class == CLASS_VEHICLE_STANDARD)
			{		
				index++;
				
				DestroyVehicle(SalonVeh[playerid][sVID]);
				//DestroyDynamic3DTextLabel(SalonVeh[playerid][sLabel]);
				
				SalonVeh[playerid][sVID] = CreateVehicle(VehiclesOfClassStandard[index][0], -1649.0459, 1206.8979, 21.1987, 40.4627, random(126), random(126), -1, 0);
				SetVehicleVirtualWorld(SalonVeh[playerid][sVID], playerid+200);
		
				SalonVeh[playerid][sIndex] = index;
		
				format(C_STRING, sizeof(C_STRING), "{33CCCC}%s\n{FFFFFF}\nCena: $%d\nKlasa standardowa\nMaks. prędkość: %d\nUżyj /zakup aby zakupić pojazd", VehiclesOfClassStandard[index][3], VehiclesOfClassStandard[index][1], VehiclesOfClassStandard[index][2]);
				UpdateDynamic3DTextLabelText(SalonVeh[playerid][sLabel], -1, C_STRING);
				
				if(index == sizeof(VehiclesOfClassStandard))
					return SalonVeh[playerid][sIndex] = 0;
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	new targetip[32], string[128];
	foreach(new pid : Player) {
		GetPlayerIp(pid, targetip, sizeof targetip);
		if(strcmp(ip, targetip) == 0) {
			format(string, sizeof(string), "[RCON WARNING] %s [ID:%d] próbował zalogować się na RCON(kod wyjściowy: %d)", pName(pid), pid, success);
			Log("/logs/rcon.log", string);
			AdminWarning(COLOR_RED, string);
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(IsPlayerAdminLevel(playerid, 6)) {
		new str[16];
		valstr(str, clickedplayerid);
		cmd_sprawdzstats(playerid, str);
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(!Logged[playerid]) {
		SendClientMessage(playerid, COLOR_RED, "WARNING: Nie jesteś zalogowany.");
		return 0;
	}
	PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
	return 1;
}