#define MAX_GROUPS 100

enum e_group {
	UID,
	groupName[32],
	groupColor[12],
	Float:spawnPos[3],
	spawnInt,
	spawnVw,
	groupType,

}
new gInfo[MAX_GROUPS][e_group];

#define GROUP_TYPE_NONE 				0
#define GROUP_TYPE_POLICE 			1
#define GROUP_TYPE_EMS 				2
#define GROUP_TYPE_FAMILY 			3
#define GROUP_TYPE_CRIMINAL 		4
#define GROUP_TYPE_BUSINESS 		5
#define GROUP_TYPE_TAXI					6
#define GROUP_TYPE_WORKSHOP	7

#define DIALOG_GROUP_MEMBERS	2000

new Iterator:Group<MAX_GROUPS>;

#define LOG_DIR_GROUPS			"/logs/groups.log"


// ------------------------------------------------------------------------------------------
//			--------------------------- FUNKCJE ----------------------------
// ------------------------------------------------------------------------------------------



LoadGroups() {
	mysql_tquery(Database, "SELECT * FROM `groups`", "MYSQL_LoadGroups");
	return 1;
}

forward MYSQL_LoadGroups();
public MYSQL_LoadGroups() {
	new temp[64], loaded, ticks = GetTickCount();
	if(!cache_num_rows()) {
		printf("\t\t LOAD_INFO: Brak grup w bazie danych. Pomijam ³adowanie."); 
		return 0;
	}
	for(new i; i <= cache_num_rows(); i++) {

		cache_get_value(i, "uid", temp, 64);
		gInfo[i][UID] = strval(temp);

		cache_get_value(i, "groupname", temp, 64);
		format(gInfo[i][groupName], 64, temp);

		cache_get_value(i, "groupcolor", temp, 64);
		format(gInfo[i][groupColor], 64, temp);

		cache_get_value(i, "spawnx", temp, 64);
		gInfo[i][spawnPos][0] = floatstr(temp);

		cache_get_value(i, "spawny", temp, 64);
		gInfo[i][spawnPos][1] = floatstr(temp);

		cache_get_value(i, "spawnz", temp, 64);
		gInfo[i][spawnPos][2] = floatstr(temp);

		cache_get_value(i, "spawnint", temp, 64);
		gInfo[i][spawnInt] = strval(temp);

		cache_get_value(i, "spawnvw", temp, 64);
		gInfo[i][spawnVw] = strval(temp);

		cache_get_value(i, "grouptype", temp, 64);
		gInfo[i][groupType] = strval(temp);

		Iter_Add(Group, i);
		loaded++;
	}
	printf("\tLOAD_INFO: Za³adowano %d grup w czasie %dms", loaded, GetTickCount()-ticks);
	cache_unset_active();
	return 1;
}

forward MYSQL_CreateGroup(groupid, playerid);
public MYSQL_CreateGroup(groupid, playerid) {
	gInfo[groupid][UID] = cache_insert_id();
	new string[128];
	format(string, sizeof string, "Utworzy³eœ grupê o nazwie [%s], typie [%d] i UID [%d]", gInfo[groupid][groupName], gInfo[groupid][groupType], gInfo[groupid][UID]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	cache_unset_active();
	return 1;
}

forward MYSQL_ShowGroupMembers(playerid, factionid);
public MYSQL_ShowGroupMembers(playerid, factionid) {
	new tempuid, temprank, tempname[24], string[500] = "Nazwa\tStatus\tRanga\n{ffffff}Lista cz³onków grupy:\t\t", bool:online = false;
	for(new i; i < cache_num_rows(); i++) {
		online = false;
		cache_get_value_int(i, "uid", tempuid);
		cache_get_value(i, "name", tempname);
		cache_get_value_int(i, "factionrank", temprank);
		foreach(new j : Player) {
			if(tempuid == pInfo[j][UID])  {
				online = true;
				format(string, sizeof string, "%s\n{FFF9CC}%s\t{31a010}ONLINE [ID:%d]\t{ffffff}%s[%d]", string, tempname, j, GetRankName(factionid, temprank), temprank);
			}
		}
		if(online == false) format(string, sizeof string, "%s\n{FFF9CC}%s\t{ff0000}OFFLINE\t{ffffff}%s[%d]", string, tempname, GetRankName(factionid, temprank), temprank);

	}
	ShowPlayerDialog(playerid, DIALOG_GROUP_MEMBERS, DIALOG_STYLE_TABLIST_HEADERS, DNAZWA " - lista cz³onków organizacji", string, "OK", "");
	cache_unset_active();
}


GetPlayerGroupType(playerid) {
	foreach(new x : Group) {
		if(gInfo[x][UID] == pInfo[playerid][Faction]) {
			return gInfo[x][groupType];
		}
	}
}
GetPlayerGroupTypeName(playerid) {
	new string[32];
	foreach(new x : Group) {
		if(gInfo[x][UID] == pInfo[playerid][Faction]) {
			switch(gInfo[x][groupType]) {
				case GROUP_TYPE_POLICE: strins(string, "Jednostka mundurowa", strlen(string));
				case GROUP_TYPE_EMS: strins(string, "Jednostka ratownicza", strlen(string));
				case GROUP_TYPE_FAMILY: strins(string, "Rodzina", strlen(string));
				case GROUP_TYPE_CRIMINAL: strins(string, "Grupa przestêpcza", strlen(string));
				case GROUP_TYPE_BUSINESS: strins(string, "Biznes", strlen(string));
				case GROUP_TYPE_TAXI: strins(string, "Firma taksówkarska", strlen(string));
				case GROUP_TYPE_WORKSHOP: strins(string, "Warsztat samochodowy", strlen(string));
				default: strins(string, "Nieznana", strlen(string));
			}
			return string;
		}
	}
}
GetPlayerGroupName(playerid) {
	new str[32];
	foreach(new x : Group) {
		if(gInfo[x][UID] == pInfo[playerid][Faction]) {
			format(str, sizeof str, gInfo[x][groupName]);
			return str;
		}
	}
}
GetGroupType(groupid) return gInfo[groupid][groupType];
GetPlayerGroup(playerid) return pInfo[playerid][Faction];
GetGroupName(groupid) {
	new string[32];
	format(string, sizeof string, gInfo[groupid][groupName]);
	return string;
}
GetGroupTypeName(groupid) {
	new string[32];
	switch(gInfo[groupid][groupType]) {
		case GROUP_TYPE_POLICE: strins(string, "Jednostka mundurowa", strlen(string));
		case GROUP_TYPE_EMS: strins(string, "Jednostka ratownicza", strlen(string));
		case GROUP_TYPE_FAMILY: strins(string, "Rodzina", strlen(string));
		case GROUP_TYPE_CRIMINAL: strins(string, "Grupa przestêpcza", strlen(string));
		case GROUP_TYPE_BUSINESS: strins(string, "Biznes", strlen(string));
		case GROUP_TYPE_TAXI: strins(string, "Firma taksówkarska", strlen(string));
		case GROUP_TYPE_WORKSHOP: strins(string, "Warsztat samochodowy", strlen(string));
		default: strins(string, "Nieznana", strlen(string));
	}
	return string;
}




// ------------------------------------------------------------------------------------------
//	--------------------------- ADMINISTRATORSKIE ----------------------------
// ------------------------------------------------------------------------------------------





/*CMD:makeleader(playerid, args[]) {
	if(!IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	new groupuid, targetid, exists, id;
	if(sscanf(args, "rd", targetid, groupuid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /makeleader [ID gracza] [UID grupy]");
	foreach(new i : Group) {
		if(gInfo[i][UID] == groupuid) {
				id = i;
				exists++;
			}
	}
	if(!exists) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Grupa o takim UID nie istnieje.");
	if(pInfo[targetid][FactionLeader]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz jest ju¿ liderem jakiejœ grupy.");
	new string[128];
	pInfo[targetid][Faction] = groupuid;
	pInfo[targetid][FactionLeader] = 1;
	pInfo[targetid][FactionRank] = 9;
	format(string, sizeof string, "»» Otrzyma³eœ status lidera grupy %s [UID: %d] od %s.", GetGroupName(id), groupuid, pName(playerid));
	SendClientMessage(targetid, COLOR_WHITE, string);
	format(string, sizeof string, "»» Nada³eœ graczowi %s kontrolê nad grup¹ %s [UID: %d].", pName(targetid), GetGroupName(id), groupuid);
	SendClientMessage(playerid, COLOR_WHITE, string);
	//dodac logi
	return 1;
}

CMD:takeleader(playerid, args[]) {
	if(!IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	new groupuid, targetid, exists, id;
	if(sscanf(args, "r", targetid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /takeleader [ID gracza]");
	groupuid = GetPlayerGroup(targetid);
	if(!groupuid) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie nale¿y do ¿adnej grupy.");
	foreach(new i : Group) {
		if(gInfo[i][UID] == groupuid) {
			id = i;
			exists++;
		}
	}
	if(!exists) SendClientMessage(playerid, COLOR_GREY, "B£¥D: Grupa o takim UID nie istnieje.");
	if(!pInfo[targetid][FactionLeader]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest liderem ¿adnej grupy grupy.");
	new string[128];
	pInfo[targetid][Faction] = 0;
	pInfo[targetid][FactionLeader] = 0;
	pInfo[targetid][FactionRank] = 0;
	format(string, sizeof string, "»» %s zabra³ Ci status lidera grupy %s [UID: %d].", pName(playerid), GetGroupName(id), groupuid);
	SendClientMessage(targetid, COLOR_WHITE, string);
	format(string, sizeof string, "»» Zabra³eœ graczowi %s kontrolê nad grup¹ %s [UID: %d].", pName(targetid), GetGroupName(id), groupuid);
	SendClientMessage(playerid, COLOR_WHITE, string);
	//dodac logi
	return 1;
}*/

CMD:creategroup(playerid, args[]) {
	if(!IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	new type, temp[32];
	if(sscanf(args, "s[32]d", temp, type)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /creategroup [nazwa] [typ grupy] | Typy grupy znajdziesz na forum.");
	if(type < 1 || type > 10) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /creategroup [nazwa] [typ grupy] | Typy grupy znajdziesz na forum.");
	if(strlen(temp) >= 32) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /creategroup [nazwa] [typ grupy] | Nazwa jest za d³uga. (limit: 32 chars)");

	new Float:pos[3], string[212], int, vw, iter;

	int = GetPlayerInterior(playerid);
	vw = GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	for(new x; x < MAX_GROUPS; x++)
	{
		if(gInfo[x][groupType] == GROUP_TYPE_NONE)
		{

			format(gInfo[x][groupName], 64, temp);
			gInfo[x][spawnPos][0] = pos[0];
			gInfo[x][spawnPos][1] = pos[1];
			gInfo[x][spawnPos][2] = pos[2];
			gInfo[x][spawnInt] = int;
			gInfo[x][spawnVw] = vw;
			gInfo[x][groupType] = type;

			Iter_Add(Group, x);
			iter = x; 
			break;
		}
	}
	mysql_format(Database, string, sizeof string, "INSERT INTO `groups` (`groupname`, `spawnx`, `spawny`, `spawnz`, `spawnint`, `spawnvw`, `grouptype`) VALUES ('%e', '%f', '%f', '%f', '%d', '%d', '%d')", temp, pos[0], pos[1], pos[2], int, vw, type);
	mysql_tquery(Database, string, "MYSQL_CreateGroup", "dd", iter, playerid);
	format(string, sizeof string, "%s stworzy³ grupê %s [UID: %d] o typie: %s [%d]", pName(playerid), GetGroupName(iter), GetGroupName(iter), GetGroupTypeName(iter), GetGroupType(iter));
	Log(LOG_DIR_GROUPS, string);
	return 1;
}

CMD:deletegroup(playerid, args[]) {
	if(!IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	new id;
	if(sscanf(args, "d", id)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /deletegroup [UID grupy]");
	new string[128], exists; 
	foreach(new i : Group) {
		if(gInfo[i][UID] == id) {

			gInfo[i][UID] = 0;
			gInfo[i][spawnPos][0] = 0.0;
			gInfo[i][spawnPos][1] = 0.0;
			gInfo[i][spawnPos][2] = 0.0;
			gInfo[i][spawnInt] = 0;
			gInfo[i][spawnVw] = 0;
			gInfo[i][groupType] = GROUP_TYPE_NONE;

			Iter_Remove(Group, i);
			exists++;
			break;
		}
	}
	if(!exists) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: Taka grupa nie istnieje!");
	foreach(new j : Player) {
		if(pInfo[j][Faction] == id) {
			pInfo[j][Faction] = 0;
			pInfo[j][FactionLeader] = 0;
			pInfo[j][FactionRank] = 0;
			SendClientMessage(j, COLOR_GREY, "Grupa do której nale¿ysz zosta³a usuniêta, wiêc zosta³eœ z niej wyproszony.");
		}
	}
	mysql_format(Database, string, sizeof string, "UPDATE `accounts` SET `faction` = '0' WHERE `faction` = '%d'", id);
	mysql_tquery(Database, string);
	mysql_format(Database, string, sizeof string, "DELETE FROM `groups` WHERE `uid` = '%d'", id);
	mysql_tquery(Database, string);
	format(string, sizeof string, "Pomyœlnie usun¹³eœ grupê %s[UID: %d]", GetGroupName(id), id);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "%s usun¹³ grupê %s[UID: %d]", pName(playerid), GetGroupName(id), id);
	Log(LOG_DIR_GROUPS, string);
	return 1;
}

CMD:zarzadzajgrupa(playerid, args[]) return cmd_managegroup(playerid, args);
CMD:managegroup(playerid, args[]) {
	if(!IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	new groupuid, temp[16], varchar[32];
	if(sscanf(args, "ds[16]S()[32]", groupuid, temp)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /managegroup [id grupy] [ nazwa | typ | spawn | kolor | przyjmij | wyrzuc | lider ]");
	if(!strcmp(temp, "nazwa", true, 5)) {
		new name[32], string[128];
		if(isnull(varchar)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /g(rupa) nazwa [nowa nazwa grupy]");
		if(strlen(name) > 31) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Nazwa jest za d³uga! (Limit: 32 chars)");
		format(string, sizeof(string), "»» Zmieni³eœ nazwê grupy na %s.", name);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "%s zmieni³ nazwê grupy %s [UID: %d] na %s", pName(playerid), GetGroupName(groupuid), GetPlayerGroup(groupuid), name);
		Log(LOG_DIR_GROUPS, string);
		format(gInfo[groupuid][groupName], 32, name);
		mysql_format(Database, string, sizeof string, "UPDATE `groups` SET `groupname` = '%e' WHERE `uid` = '%d'", name, groupuid);
		mysql_tquery(Database, string);
	}
	if(!strcmp(temp, "typ", true, 3)) {
		new type, string[128];
		if(sscanf(varchar, "d", type)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /g(rupa) typ [typ grupy] | Wszystkie typy grup s¹ na forum.");
		format(string, sizeof(string), "»» Zmieni³eœ typ  grupy na %s [ID: %d].", GetGroupTypeName(groupuid), GetGroupType(groupuid));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "%s zmieni³ typ grupy %s [ID: %d] na %s [ID: %d]", pName(playerid), GetGroupName(groupuid), GetPlayerGroup(groupuid), GetGroupTypeName(groupuid), GetGroupType(groupuid));
		gInfo[groupuid][groupType] = type;
		Log(LOG_DIR_GROUPS, string);
		mysql_format(Database, string, sizeof string, "UPDATE `groups` SET `grouptype` = '%d' WHERE `uid` = '%d'", type, groupuid);
		mysql_tquery(Database, string);
	}
	if(!strcmp(temp, "spawn", true)) {
		new string[128], Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		foreach(new x : Group) { 
			if(gInfo[x][UID] == groupuid) {
				gInfo[x][spawnPos][0] = pos[0];
				gInfo[x][spawnPos][1] = pos[1];
				gInfo[x][spawnPos][2] = pos[2];
				gInfo[x][spawnInt] = GetPlayerInterior(playerid);
				gInfo[x][spawnVw] = GetPlayerVirtualWorld(playerid);
				break;
			}
		}
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "»» Zmieni³eœ spawn grupy. Od teraz jej cz³onkowie bêd¹ siê pojawiali w tym miejscu.");
		mysql_format(Database, string, sizeof string, "UPDATE `groups` SET `spawnx` = '%f', `spawny` = '%f', `spawnz` = '%f', `spawnint` = '%d', `spawnvw` = '%d' WHERE `uid` = '%d'", pos[0], pos[1], pos[2], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), groupuid);
		mysql_tquery(Database, string);
		printf(string);
		format(string, sizeof string, "%s zmieni³ spawn grupy %s [UID: %d]", pName(playerid), GetGroupName(groupuid), groupuid);
		Log(LOG_DIR_GROUPS, string);
	}
	return 1;

}

CMD:pokazgrupy(playerid) return cmd_showgroups(playerid);
CMD:showgroups(playerid) {
	if(!IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	new string[450];
	foreach(new x : Group) format(string, sizeof string, "%s %s {fff9cc}[UID: %d]{ffffff} | Typ grupy: {fff9cc}%s\n", string, GetGroupName(x), gInfo[x][UID], GetGroupTypeName(x));
	ShowPlayerDialog(playerid, 69696, DIALOG_STYLE_LIST, DNAZWA " - lista grup", string, "Zamknij", "");
	return 1;
}





// ------------------------------------------------------------------------------------------
//			--------------------------- DLA GRACZY ----------------------------
// ------------------------------------------------------------------------------------------

CMD:g(playerid, args[]) return cmd_grupa(playerid, args);
CMD:grupa(playerid, args[]) {
	if(!pInfo[playerid][Faction]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Aby u¿yæ tej komendy musisz nale¿eæ do jakiejkolwiek grupy.");
	new temp[12], varchar[32];
	if(sscanf(args, "s[12]S()[32]", temp)) {
		if(pInfo[playerid][FactionLeader]) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /g(rupa) [ info | czlonkowie | sluzba | zapros | wypros | nazwa | zmienspawn ]");
		else return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /g(rupa) [ info | czlonkowie | sluzba ]");
	}
	new groupuid = GetPlayerGroup(playerid);
	if(!strcmp(temp, "info", true)) {
		new string[450];
		format(string, sizeof string, "Grupa:\t{fff9cc}%s [UID: %d]\t\n\
			Typ grupy:\t{fff9cc}%s\t\n",\
		 	GetPlayerGroupName(playerid), groupuid, GetPlayerGroupTypeName(playerid));
		ShowPlayerDialog(playerid, 2434, DIALOG_STYLE_TABLIST, DNAZWA " - grupa", string, "OK", "Anuluj");
	}
	if(!strcmp(temp, "czlonkowie", true)) {
		new string[78];
		mysql_format(Database, string, sizeof(string),"SELECT `name`, `uid`, `factionrank` FROM `accounts` WHERE `faction` = '%d'", groupuid);
		mysql_tquery(Database, string, "MYSQL_ShowGroupMembers", "ii", playerid, groupuid);
	}
	if(!strcmp(temp, "duty", true) || !strcmp(args, "sluzba", true) ) {
		if(!GetPlayerGroupType(playerid) != (GROUP_TYPE_EMS || GROUP_TYPE_POLICE)) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Twoja grupa nie ma uprawnieñ do u¿ycia tej komendy.");
		if(GetPVarInt(playerid, "on-group-duty")) {
			SetPVarInt(playerid, "on-group-duty", 0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "»» Schodzisz ze s³u¿by.");
			TextDrawHideForPlayer(playerid, TDEditor_TD[0]); // ON DUTY textdraw
		}
		else {
			SetPVarInt(playerid, "on-group-duty", 1);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "»» Wchodzisz na s³u¿bê.");
			TextDrawShowForPlayer(playerid, TDEditor_TD[0]); // ON DUTY textdraw
		}
	}
	if(!strcmp(temp, "nazwa", true, 5)) {
		if(!pInfo[playerid][FactionLeader]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Aby u¿yæ tej komendy musisz byæ liderem grupy!");
		new name[32], string[128];
		if(isnull(varchar)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /g(rupa) nazwa [nowa nazwa grupy]");
//		if(sscanf(varchar, "s[32]", name)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /g(rupa) nazwa [nowa nazwa grupy]");
		if(strlen(name) > 31) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Nazwa jest za d³uga! (Limit: 32 chars)");
		format(string, sizeof(string), "»» Zmieni³eœ nazwê grupy na %s.", name);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "%s zmieni³ nazwê grupy %s [UID: %d] na %s", pName(playerid), GetPlayerGroupName(playerid), GetPlayerGroup(playerid), name);
		Log(LOG_DIR_GROUPS, string);
		format(gInfo[GetPlayerGroup(playerid)][groupName], 32, name);
		mysql_format(Database, string, sizeof string, "UPDATE `groups` SET `groupname` = '%e' WHERE `uid` = '%d'", name, GetPlayerGroup(playerid));
		mysql_tquery(Database, string);
			//dodac logi
	}
	if(!strcmp(temp, "zmienspawn", true)) {
		if(!pInfo[playerid][FactionLeader]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Aby u¿yæ tej komendy musisz byæ liderem grupy!");
		new string[128], Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		foreach(new x : Group) {
			if(gInfo[x][UID] == GetPlayerGroup(playerid)) {
				gInfo[x][spawnPos][0] = pos[0];
				gInfo[x][spawnPos][1] = pos[1];
				gInfo[x][spawnPos][2] = pos[2];
				gInfo[x][spawnInt] = GetPlayerInterior(playerid);
				gInfo[x][spawnVw] = GetPlayerVirtualWorld(playerid);
			}
		}
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "»» Zmieni³eœ spawn grupy. Od teraz jej cz³onkowie bêd¹ siê pojawiali w tym miejscu.");
		mysql_format(Database, string, sizeof string, "UPDATE `groups` SET `spawnx` = '%f', `spawny` = '%f', `spawnz` = '%f', `spawnint` = '%d', `spawnvw` = '%d' WHERE `uid` = '%d'", pos[0], pos[1], pos[2], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), GetPlayerGroup(playerid));
		mysql_tquery(Database, string);
		printf(string);
		format(string, sizeof string, "%s zmieni³ spawn grupy %s [UID: %d]", pName(playerid), GetPlayerGroupName(playerid), GetPlayerGroup(playerid));
		Log(LOG_DIR_GROUPS, string);
	}
	if(!strcmp(temp, "zapros", true, 6)) {
		if(!pInfo[playerid][FactionLeader]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Aby u¿yæ tej komendy musisz byæ liderem grupy!");
		new targetid, string[128];
		if(sscanf(varchar, "r", targetid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /g(rupa) zapros [ID gracza]");
		if(pInfo[targetid][Faction]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz jest ju¿ w jakiejœ innej grupie!");
		pInfo[targetid][Faction] = 0;
		pInfo[targetid][FactionRank] = 0;
		pInfo[targetid][FactionLeader] = 0;
		format(string, sizeof(string), "»» Zosta³eœ przyjêty do grupy {f9cc00}%s {ffffff}przez {f9cc00}%s{ffffff}.", GetPlayerGroupName(playerid), pName(playerid));
		SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "»» Przyj¹³eœ {f9cc00}%s {ffffff}do swojej grupy.", pName(targetid));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "%s zaprosi³ gracza %s do grupy %s [UID: %d]", pName(playerid), pName(targetid),GetPlayerGroupName(playerid), GetPlayerGroup(playerid));
		Log(LOG_DIR_GROUPS, string);
	}
	if(!strcmp(temp, "wypros", true, 6)) {
		if(!pInfo[playerid][FactionLeader]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Aby u¿yæ tej komendy musisz byæ liderem grupy!");
		new targetid, string[128];
		if(sscanf(varchar, "r", targetid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /g(rupa) wypros [ID gracza]");
		if(pInfo[targetid][Faction] != groupuid) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest w twojej frakcji!");
		if(!pInfo[targetid][FactionLeader]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Nie mo¿esz wyrzuciæ lidera grupy!");
		pInfo[targetid][Faction] = 0;
		pInfo[targetid][FactionRank] = 0;
		format(string, sizeof(string), "»» Zosta³eœ wyrzucony z grupy przez {f9cc00}%s{ffffff}.",  pName(playerid));
		SendClientMessage(targetid, COLOR_WHITE, string);
		format(string, sizeof(string), "»» Wyrzuci³eœ {f9cc00}%s{ffffff}ze swojej grupy", pName(targetid));
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof string, "%s wyrzuci³³ gracza %s z grupy %s [UID: %d]", pName(playerid), pName(targetid),GetPlayerGroupName(playerid), GetPlayerGroup(playerid));
		Log(LOG_DIR_GROUPS, string);
	}
	return 1;
}
CMD:br(playerid) return cmd_brama(playerid);
CMD:brama(playerid) {
    new Float:pos[3];
     //bramy red county fire department
    if(GetPlayerGroupType(playerid) == (GROUP_TYPE_POLICE || GROUP_TYPE_EMS)) 
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 699.440734, -664.215454, 17.9))  {
            GetObjectPos(fdgate1, pos[0], pos[1], pos[2]);
            if(floatround(pos[2]) == floatround(17.923753)) MoveObject(fdgate1, 699.440734, -664.215454, 20.4, 1.0, 0.0, 0.0, 0.0);
            else MoveObject(fdgate1, 699.440734, -664.215454, 17.923753, 1.0, 0.0, 0.0, 0.0);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 704.621582, -664.215454, 17.9))  
        {
            GetObjectPos(fdgate2, pos[0], pos[1], pos[2]);
            if(floatround(pos[2]) == floatround(17.133747)) MoveObject(fdgate2, 704.621582, -664.215454, 20.4, 1.0, 0.0, 0.0, 0.0);
            else MoveObject(fdgate2, 704.621582, -664.215454, 17.133747, 1.0, 0.0, 0.0, 0.0);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 709.731445, -664.215454, 17.9))  
        {
            GetObjectPos(fdgate2, pos[0], pos[1], pos[2]);
            if(floatround(pos[2]) == floatround(17.343747)) MoveObject(fdgate3, 709.731445, -664.215454, 20.4, 1.0, 0.0, 0.0, 0.0);
            else MoveObject(fdgate3, 709.731445, -664.215454, 17.343747, 1.0, 0.0, 0.0, 0.0);
        }
    }
    ////bramy red county fire department end
    return 1;
}

CMD:rr(playerid, params[])
{
    if(pInfo[playerid][Faction] != 0)
    {
        if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /r [tekst] lub /r kanal [id kana³u]");
        new text[128];
        if(!strfind(params, "kanal", true)) {
            new channel;
            if(sscanf(params, "s[128]i", text, channel)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /r [tekst] lub /r kanal [id kana³u]");
            if(channel > 1000 || channel < 1) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /r kanal [id kana³u od 1 do 1000]");
            radioChannel[playerid] = channel;
            format(text, sizeof(text), "Pomyœlnie zmieni³eœ kana³ w radiu na %d.", channel);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, text);
            return 1;
        }
        
        format(C_STRING, sizeof(C_STRING), "** %s %s: %s **", GetRankName(pInfo[playerid][Faction], pInfo[playerid][FactionRank]), pName(playerid), params);
        
        format(text, sizeof(text), "%s (radio): %s", pName(playerid), params);
        
        new Float:pos[3];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        
        foreach(new x : Player)
        {
        	if(IsPlayerInRangeOfPoint(x, 7.5, pos[0], pos[1], pos[2]))
            {
                SendClientMessage(x, -1, text);
            }
            if(radioChannel[x] == radioChannel[playerid])
            {
                SendClientMessage(x, -1, C_STRING);
            }
        }
    }
    else
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff} » informacja", "Nie nale¿ysz do frakcji!", "Zamknij", "");
    return 1;
}