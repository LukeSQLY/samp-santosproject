// frakcje.pwn

// ------------------------------------------------------------------------------------------
//			------------------------------ FUNKCJE ------------------------------
// ------------------------------------------------------------------------------------------

LoadFactions() {
	new string[64], ticks = GetTickCount();
	for(new i = 1; i <= MAX_FACTIONS-1; i++) {
		mysql_format(Database, string, sizeof(string), "SELECT * FROM `factions` WHERE `uid` = '%d' LIMIT 1", i);
		mysql_tquery(Database, string, "MYSQL_LoadFactions", "i", i);
		if(i == 5) break;
	}
	printf("\tLOAD_INFO: Za³adowano system frakcji na serwer! Czas: %dms", GetTickCount() - ticks);
	return 1;
}

IsPlayerInFaction(playerid, factionid) {
	if(pInfo[playerid][Faction] >= factionid) 	return true;
	else return false;
}

// ------------------------------------------------------------------------------------------
//	------------------------------ MYSQL ------------------------------
// ------------------------------------------------------------------------------------------

forward MYSQL_LoadFactions(i);
public MYSQL_LoadFactions(i) {
	fInfo[i][Cache] = cache_save();
	cache_set_active(fInfo[i][Cache]);
	new temp[64];
	if(cache_num_rows() > 0) {
		cache_get_value_int(0, "uid", fInfo[i][UID]);
		cache_get_value(0, "name", fInfo[i][Name], 64);  
		cache_get_value_float(0, "spawnX", fInfo[i][spawnX]);
		cache_get_value_float(0, "spawnY", fInfo[i][spawnY]);
		cache_get_value_float(0, "spawnZ", fInfo[i][spawnZ]);
		cache_get_value(0, "motd", fInfo[i][Motd], 64);
		cache_get_value(0, "rank0", temp);
		format(fRank[i][rank0], 64, temp);

		cache_get_value(0, "rank1", temp, 64);
		format(fRank[i][rank1], 64, temp);

		cache_get_value(0, "rank2", temp, 64);
		format(fRank[i][rank2], 64, temp);

		cache_get_value(0, "rank3", temp, 64);
		format(fRank[i][rank3], 64, temp);

		cache_get_value(0, "rank4", temp, 64);
		format(fRank[i][rank4], 64, temp);

		cache_get_value(0, "rank5", temp, 64);
		format(fRank[i][rank5], 64, temp);

		cache_get_value(0, "rank6", temp, 64);
		format(fRank[i][rank6], 64, temp);

		cache_get_value(0, "rank7", temp, 64);
		format(fRank[i][rank7], 64, temp);

		cache_get_value(0, "rank8", temp, 64);
		format(fRank[i][rank8], 64, temp);

		cache_get_value(0, "rank9", temp, 64);
		format(fRank[i][rank9], 64, temp);
	}
	format(fInfo[0][Name], 64, "Brak");
	format(fRank[0][rank1], 64, "-");
	format(fRank[0][rank2], 64, "-");
	format(fRank[0][rank3], 64, "-");
	format(fRank[0][rank4], 64, "-");
	format(fRank[0][rank5], 64, "-");
	format(fRank[0][rank6], 64, "-");
	format(fRank[0][rank7], 64, "-");
	format(fRank[0][rank8], 64, "-");
	format(fRank[0][rank9], 64, "-");
	cache_unset_active();
}
forward MYSQL_DialogFactionMembers(playerid, factionid);
public MYSQL_DialogFactionMembers(playerid, factionid) {
	new tempuid, temprank, tempname[24], string[500] = "Nazwa\tStatus\tRanga\n{ffffff}Lista cz³onków organizacji:\t\t", bool:online = false;
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
	ShowPlayerDialog(playerid, DIALOG_FACTION_MEMBERLIST, DIALOG_STYLE_TABLIST_HEADERS, DNAZWA " - lista cz³onków organizacji", string, "OK", "");
	cache_unset_active();
}

// ------------------------------------------------------------------------------------------
//			------------------------------ KOMENDY ------------------------------
// ------------------------------------------------------------------------------------------

CMD:dajlidera(playerid, params[]) return cmd_makeleader(playerid, params);
CMD:makeleader(playerid, params[]) {
	new factionid, targetid, string[128];
	if(!IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	if(sscanf(params, "ui", targetid, factionid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /dajlidera [id/nick] [id frakcji]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie po³¹czony!");
	if(factionid <= 1 && factionid >= MAX_FACTIONS) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: ID frakcji musi siê mieœciæ miêdzy 1 i 10!");
	if(pInfo[targetid][FactionLeader] == 1) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz ju¿ jest liderem jakiejœ frakcji!");
	pInfo[targetid][Faction] = factionid;
	pInfo[targetid][FactionLeader] = 1;
	pInfo[targetid][FactionRank] = 10;
	format(string, sizeof(string), "%s[ID: %d] mianowa³ Ciê liderem frakcji %s [UID: %d]", pName(playerid), playerid, fInfo[factionid][Name],factionid);
	SendClientMessage(targetid, COLOR_GREEN, string);
	format(string, sizeof(string), "Nada³eœ graczowi %s[ID: %d] lidera frakcji UID %d.", pName(targetid), targetid, factionid);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s[UID: %d] nada³ graczowi %s[UID: %d] lidera frakcji o UID: %d", pName(playerid), pInfo[playerid][UID], pName(targetid), pInfo[targetid][UID], factionid);
	Log(LOG_DIR_FACTION, string);
	return 1;
}

CMD:zabierzlidera(playerid, params[]) return cmd_takeleader(playerid, params);
CMD:takeleader(playerid, params[]) {
	new targetid, string[128], factionid;
	if(!IsPlayerAdminLevel(playerid, 1000)) return NoAccessMessage(playerid);
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /zabierzlidera [id/nick]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie po³¹czony!");
	if(pInfo[targetid][FactionLeader] == 0) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest liderem w ¿adnej organizacji!");
	factionid = pInfo[targetid][Faction];
	pInfo[targetid][Faction] = 0;
	pInfo[targetid][FactionLeader] = 0;
	pInfo[targetid][FactionRank] = 0;
	format(string, sizeof(string), "%s[ID: %d] zabra³ Ci kontrolê nad frakcj¹ %s [UID: %d].", pName(playerid), playerid, fInfo[factionid][Name], factionid);
	SendClientMessage(targetid, COLOR_GREEN, string);
	format(string, sizeof(string), "Zabra³eœ graczowi %s[ID: %d] lidera frakcji o UID: %d.", pName(targetid), targetid, factionid);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s[UID: %d] zabra³ graczowi %s[UID: %d] lidera frakcji o UID: %d", pName(playerid), pInfo[playerid][UID], pName(targetid), pInfo[targetid][UID], factionid);
	Log(LOG_DIR_FACTION, string);
	return 1;
}

CMD:f(playerid, params[]) {
	new dialog[256], title[128];
	if(!pInfo[playerid][FactionLeader]) return NoAccessMessage(playerid);
	if(!pInfo[playerid][Faction]) return NoAccessMessage(playerid);
	format(title, sizeof(title), DNAZWA " -  %s [UID: %d]", fInfo[pInfo[playerid][Faction]][Name], pInfo[playerid][Faction]);
	format(dialog, sizeof(dialog), " »» Zmieñ nazwê frakcji\n »» Ustaw spawn\n »» Lista cz³onków\n »» Zmieñ MOTD");
	ShowPlayerDialog(playerid, DIALOG_FACTION_PANEL, DIALOG_STYLE_LIST, title, dialog, "OK", "WyjdŸ");
	return 1;
}
CMD:invite(playerid, params[]) return cmd_przyjmij(playerid, params);
CMD:przyjmij(playerid, params[]) {
	new targetid, string[128], factionid;
	factionid = pInfo[playerid][Faction];
	if(!pInfo[playerid][FactionLeader]) return NoAccessMessage(playerid);
	if(!pInfo[playerid][Faction]) return NoAccessMessage(playerid);
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /przyjmij [id/nick]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie po³¹czony!");
	if(pInfo[targetid][Faction] > 0) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz jest ju¿ w jakiejœ frakcji!");
	pInfo[targetid][Faction] = factionid;
	format(string, sizeof(string), "»» Zosta³eœ przyjêty do {f9cc00}%s {ffffff}przez {f9cc00}%s{ffffff}.", fInfo[factionid][Name], pName(playerid));
	SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "»» Przyj¹³eœ {f9cc00}%s {ffffff}do swojej frakcji.", pName(targetid));
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s przyj¹³ %s do organizacji %s[UID: %d]", pName(playerid), pName(targetid), fInfo[factionid][Name], factionid);
	Log(LOG_DIR_FACTION, string);
	return 1;
}
CMD:dismiss(playerid, params[]) return cmd_zwolnij(playerid, params);
CMD:zwolnij(playerid, params[]) {
	new targetid, string[128], factionid;
	factionid = pInfo[playerid][Faction];
	if(!pInfo[playerid][FactionLeader]) return NoAccessMessage(playerid);
	if(!pInfo[playerid][Faction]) return NoAccessMessage(playerid);
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /zwolnij [id/nick]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie po³¹czony!");
	if(pInfo[targetid][Faction] > 0) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest w ¿adnej frakcji!");
	if(pInfo[targetid][Faction] != factionid) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest w twojej frakcji!");
	pInfo[targetid][Faction] = 0;
	pInfo[targetid][FactionRank] = 0;
	format(string, sizeof(string), "»» Zosta³eœ zwolniony z {f9cc00}%s {ffffff}przez {f9cc00}%s{ffffff}.", fInfo[factionid][Name], pName(playerid));
	SendClientMessage(targetid, COLOR_WHITE, string);
	format(string, sizeof(string), "»» Zwolni³eœ {f9cc00}%s {ffffff}ze swojej frakcji", pName(targetid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "%s zwolni³ %s z organizacji %s[UID: %d]", pName(playerid), pName(targetid), fInfo[factionid][Name], factionid);
	Log(LOG_DIR_FACTION, string);
	return 1;
}
CMD:awans(playerid, args[]) return cmd_awansuj(playerid, args);
CMD:awansuj(playerid, args[]) {
	new targetid, string[128], factionid;
	factionid = pInfo[playerid][Faction];
	if(!pInfo[playerid][FactionLeader]) return NoAccessMessage(playerid);
	if(!pInfo[playerid][Faction]) return NoAccessMessage(playerid);
	if(sscanf(args, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /awansuj [id/nick]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie po³¹czony!");
	if(!pInfo[targetid][Faction]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest w ¿adnej frakcji!");
	if(pInfo[targetid][Faction] != factionid) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest w twojej frakcji!"); 
	if(pInfo[targetid][FactionRank] > 8) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Nie mo¿esz awansowaæ wy¿ej tego gracza!"); 
	pInfo[targetid][FactionRank]++;
	format(string, sizeof string, "»» Dosta³eœ awans od %s. Twoja ranga to teraz: %s.", pName(playerid), GetRankName(factionid, pInfo[targetid][FactionRank]));
	SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "»» Awansowa³eœ %s na rangê %s [%d].", pName(targetid), GetRankName(factionid, pInfo[targetid][FactionRank]), pInfo[targetid][FactionRank]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "%s awansowa³ %s na rangê %s [%d].", pName(playerid), pName(targetid), GetRankName(factionid, pInfo[targetid][FactionRank]), pInfo[targetid][FactionRank]);
	Log(LOG_DIR_FACTION, string);
	return 1;
}
CMD:degraduj(playerid, args[]) {
	new targetid, string[128], factionid;
	factionid = pInfo[playerid][Faction];
	if(!pInfo[playerid][FactionLeader]) return NoAccessMessage(playerid);
	if(!pInfo[playerid][Faction]) return NoAccessMessage(playerid);
	if(sscanf(args, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /degraduj [id/nick]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie po³¹czony!");
	if(!pInfo[targetid][Faction]) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest w ¿adnej frakcji!");
	if(pInfo[targetid][Faction] != factionid) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten gracz nie jest w twojej frakcji!");
	if(pInfo[targetid][FactionRank] < 1) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Nie mo¿esz zdegradowaæ tego gracza ni¿ej!");  
	pInfo[targetid][FactionRank]--;
	format(string, sizeof string, "»» Zosta³eœ zdegradowany przez %s. Twoja ranga to teraz: %s.", pName(playerid), GetRankName(factionid, pInfo[targetid][FactionRank]));
	SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "»» Zdegradowa³eœ %s na rangê %s [%d].", pName(targetid), GetRankName(factionid, pInfo[targetid][FactionRank]), pInfo[targetid][FactionRank]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "%s zdegradowa³ %s na rangê %s [%d].", pName(playerid), pName(targetid), GetRankName(factionid, pInfo[targetid][FactionRank]), pInfo[targetid][FactionRank]);
	Log(LOG_DIR_FACTION, string);
	return 1;
}
CMD:zmienrange(playerid, args[]) {
	new string[128], factionid, rankname[64], targetid;
	factionid = pInfo[playerid][Faction];
	if(!pInfo[playerid][FactionLeader]) return NoAccessMessage(playerid);
	if(!pInfo[playerid][Faction]) return NoAccessMessage(playerid);
	if(sscanf(args, "ds[64]", targetid, rankname)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /zmienrange [id rangi] [nazwa rangi]");
	if(targetid < 0 || targetid > 9) return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Mo¿esz edytowaæ tylko rangi mieszcz¹ce siê w zakresie 0-9.");
	switch(targetid) {
		case 0:{ 
			format(fRank[factionid][rank0], 64, rankname);
		}
		case 1: {
			format(fRank[factionid][rank1], 64, rankname);
		}
		case 2: {
			format(fRank[factionid][rank2], 64, rankname);
		}
		case 3: {
			format(fRank[factionid][rank3], 64, rankname);
		}
		case 4: {
			format(fRank[factionid][rank4], 64, rankname);
		}
		case 5: {
			format(fRank[factionid][rank5], 64, rankname);
		}
		case 6: {
			format(fRank[factionid][rank6], 64, rankname);
		}
		case 7: {
			format(fRank[factionid][rank7], 64, rankname);
		}
		case 8: {
			format(fRank[factionid][rank8], 64, rankname);
		}
		case 9: {
			format(fRank[factionid][rank9], 64, rankname);
		}
	}
	mysql_format(Database, string, sizeof string, "UPDATE `factions` SET `rank%d` = '%e' WHERE `uid` = '%d'", targetid, rankname, factionid);
	mysql_tquery(Database, string);
	format(string, sizeof string, "»» Zmieni³eœ nazwê rangi [%d] na %s.", targetid, rankname);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "%s zmieni³ nazwê rangi [%d] na %s.", pName(playerid), targetid, rankname);
	Log(LOG_DIR_FACTION, string);
	return 1;
}

CMD:duty(playerid, params[]) return cmd_sluzba(playerid, params);
CMD:sluzba(playerid, params[]) {
	if(!pInfo[playerid][Faction]) return NoAccessMessage(playerid);
	new string[128];
	if(GetPVarInt(playerid, "onduty") == 1) {
		format(string, sizeof(string),"»» Schodzisz ze s³u¿by we frakcji {f9cc00}%s{ffffff}.", fInfo[pInfo[playerid][Faction]][Name]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		TextDrawHideForPlayer(playerid, TDEditor_TD[0]); //onduty
		SetPVarInt(playerid, "onduty", 0);
	}
	else {
		format(string, sizeof(string),"»» Wchodzisz na s³u¿bê we frakcji {f9cc00}%s{ffffff}.", fInfo[pInfo[playerid][Faction]][Name]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		TextDrawShowForPlayer(playerid, TDEditor_TD[0]); //onduty
		SetPVarInt(playerid, "onduty", 1);
	}
	return 1;
}

// ------------------------------------------------------------------------------------------
//-	------------------------------ KOMENDY POSZCZEGÓLNYCH FRAKCJI -----------------------------
// ------------------------------------------------------------------------------------------


/*CMD:news(playerid, params[])
{
	new string[64], content;
	if (sscanf(params, "s[64]", content)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /news [treœæ]");
	if(pInfo[playerid][Faction] == 3)
	{
		format(string, sizeof string, "NEWS %s: %s", pName(playerid), content);
		SendClientMessageToAll(COLOR_NEWS, string);
	}
	return 1;
}*/

COMMAND:r(playerid, params[])
{
	if(pInfo[playerid][Faction] != 0)
	{
		if(isnull(params))
			return SendClientMessage(playerid, COLOR_GREY, "U¿yj: /r [tekst]");
		
		format(C_STRING, sizeof(C_STRING), "** %s %s: %s **", GetRankName(pInfo[playerid][Faction], pInfo[playerid][FactionRank]), pName(playerid), params);
		
		new text[128];
		
		format(text, sizeof(text), "%s (radio): %s", pName(playerid), params);
		
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		
		foreach(new x : Player)
		{
			if(pInfo[x][Faction] == pInfo[playerid][Faction])
			{
				SendClientMessage(x, -1, C_STRING);
			}
			if(IsPlayerInRangeOfPoint(x, 7.5, pos[0], pos[1], pos[2]))
			{
				SendClientMessage(x, -1, text);
			}
		}
	}
	else
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie nale¿ysz do frakcji!", "Zamknij", "");
	return 1;
}

COMMAND:d(playerid, params[])
{
	if(pInfo[playerid][Faction] == 1 || pInfo[playerid][Faction] == 2)
	{
		if(isnull(params))
			return SendClientMessage(playerid, COLOR_GREY, "U¿yj: /d [tekst]");
		
		if(pInfo[playerid][Faction] == 1)
			format(C_STRING, sizeof(C_STRING), "** [LSCSD] %s %s: %s **", GetRankName(pInfo[playerid][Faction], pInfo[playerid][FactionRank]), pName(playerid), params);
		if(pInfo[playerid][Faction] == 2)
			format(C_STRING, sizeof(C_STRING), "** [RCFD] %s %s: %s **", GetRankName(pInfo[playerid][Faction], pInfo[playerid][FactionRank]), pName(playerid), params);	
		
		new text[128];
		
		format(text, sizeof(text), "%s (radio): %s", pName(playerid), params);
		
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		
		foreach(new x : Player)
		{
			if(pInfo[x][Faction] == 1 || pInfo[x][Faction] == 2)
			{
				SendClientMessage(x, KOLOR_AC, C_STRING);
			}
			if(IsPlayerInRangeOfPoint(x, 7.5, pos[0], pos[1], pos[2]))
			{
				SendClientMessage(x, -1, text);
			}
		}
	}
	else 
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ z LSCSD/RCFD!", "Zamknij", "");
	return 1;
}

//EMS----------------------


CMD:aodo(playerid, params[])
{
	if(GetPVarInt(playerid, "hasaodo")) {
		SendClientMessage(playerid, COLOR_GREY, "Posiadasz juz AODO, nie mo¿esz go ponownie za³o¿yæ!");
		return 1;
	}

	if(IsPlayerInRangeOfPoint(playerid, 5.0, 711.6627,-679.4713,16.3697 )) {
		ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.0999, 0, 0, 0, 0, 0, 0);
		SetTimerEx("aodostart", 1000, false, "i", playerid);
	}

	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 711.6627,-679.4713,16.3697 )) {
		SendClientMessage(playerid, COLOR_GREY, "Nie znajdujesz siê w szatni RCFD!");
		return 1;
	}
	return 1;
}

CMD:apteczka(playerid, params[])
{
	new targetid;
	if(pInfo[playerid][Faction] != 2)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ z RCFD!", "Zamknij", "");
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GREY, "U¿yj: /apteczka [ID/Nick gracza]");
	if(!IsPlayerConnected(targetid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Gracz nie jest po³¹czony!", "Zamknij", "");
	if(IsPlayerInAnyVehicle(targetid) || IsPlayerInAnyVehicle(playerid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Ty/gracz nie mo¿e byæ w pojeŸdzie!", "Zamknij", "");
	if(targetid == playerid)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz uleczyæ siebie samego!", "Zamknij", "");
	
	new Float:pos[3];
	GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
	
	if(IsPlayerInRangeOfPoint(playerid, 7.5, pos[0], pos[1], pos[2]))
	{
		new Float:health;
		GetPlayerHealth(targetid, health);
		
		if(health >= 90.00)
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Gracz jest pe³ni zdrowia!", "Zamknij", "");
		
		SetPlayerHealth(targetid, 90.00);
		
		format(C_STRING, sizeof(C_STRING), "%s (ID: %d) opatrzy³ Ciê opatrunkami", pName(playerid), playerid);
		ShowPlayerDialog(targetid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		format(C_STRING, sizeof(C_STRING), "{dca2f4}** %s opatruje opatrunkami %s.", pName(playerid), pName(targetid));
		ActionMe(playerid, C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Opatrzy³eœ opatrunkami %s (ID: %d)", pName(targetid), targetid);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
	}
	else
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Gracz jest za daleko!", "Zamknij", "");
	return 1;
}

/*CMD:tlen(playerid, params[])
{
	if(GetPVarInt(playerid, "hasaodo"))
	SendClientMessage(playerid, COLOR_YELLOW, "Uruchomi³eœ butlê tlenowa, czas ucieka!");
	SetTimerEx("aodoon", 3000, true, "i", playerid);
	return 1;
}*/

//LSCSD--------------------------

CMD:kogut(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Musisz byæ w pojeŸdzie aby u¿yæ koguta!", "Zamknij", "");
	//new x = GetVehicleSpecialID(GetVehicleUID(GetPlayerVehicleID(playerid)));
	
	
	return 1;
}

CMD:zakuj(playerid, params[])
{
	new targetid, list;
	if(pInfo[playerid][Faction] != 1)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ z LSCSD!", "Zamknij", "");
	if(IsPlayerInAnyVehicle(playerid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz skuæ gracza bêd¹c w pojeŸdzie!", "Zamknij", "");
	
	foreach(new x : Player)
	{
		if(pInfo[x][Cuffs] == playerid)
			list++;
	}
	
	if(list != 0)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Ju¿ kogoœ zaku³eœ!", "Zamknij", "");
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GREY, "U¿yj: /zakuj [ID/Nick gracza]");
	if(!IsPlayerConnected(targetid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Gracz nie jest po³¹czony!", "Zamknij", "");
	if(targetid == playerid)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz siebie samego skuæ!", "Zamknij", "");
	if(IsPlayerInAnyVehicle(targetid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz skuæ gracza w pojeŸdzie!", "Zamknij", "");
	new Float:pos[3];
	GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
	
	if(IsPlayerInRangeOfPoint(playerid, 7.5, pos[0], pos[1], pos[2]))
	{
		if(pInfo[targetid][Cuffs] != INVALID_PLAYER_ID)
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Gracz jest ju¿ zakuty!", "Zamknij", "");
		
		TogglePlayerControllable(targetid, false);
		SetPlayerSpecialAction(targetid, SPECIAL_ACTION_CUFFED);
		CuffsTimer[targetid] = SetTimerEx("Cuffed", 2000, true, "ii", targetid, playerid);
		pInfo[targetid][Cuffs] = playerid;
		
		format(C_STRING, sizeof(C_STRING), "{dca2f4}** %s zakuwa w kajdanki %s.", pName(playerid), pName(targetid));
		ActionMe(playerid, C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zaku³eœ %s (ID: %d) w kajdanki", pName(targetid), targetid);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
	}
	else
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Gracz jest za daleko!", "Zamknij", "");
	return 1;
}

CMD:odkuj(playerid, params[])
{
	if(pInfo[playerid][Faction] != 1)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ z LSCSD!", "Zamknij", "");
	new targetid;
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GREY, "U¿yj: /odkuj [ID/Nick gracza]");
	if(!IsPlayerConnected(targetid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Gracz nie jest po³¹czony!", "Zamknij", "");
	if(targetid == playerid)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz siebie samego odkuæ!", "Zamknij", "");
	if(pInfo[targetid][Cuffs] == INVALID_PLAYER_ID)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Gracz nie jest skuty!", "Zamknij", "");
	
	new Float:pos[3];
	GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
	
	if(IsPlayerInRangeOfPoint(playerid, 7.5, pos[0], pos[1], pos[2]))
	{
		TogglePlayerControllable(targetid, true);
		pInfo[targetid][Cuffs] = INVALID_PLAYER_ID;
		KillTimer(CuffsTimer[targetid]);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		
		format(C_STRING, sizeof(C_STRING), "{dca2f4}** %s odkuwa kajdanki %s.", pName(playerid), pName(targetid));
		ActionMe(playerid, C_STRING);
	}
	else
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Gracz jest za daleko!", "Zamknij", "");
	return 1;
}

COMMAND:mandat(playerid, params[])
{
	if(pInfo[playerid][Faction] != 1)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff} » informacja", "Nie jesteœ z LSCSD!", "Zamknij", "");
	new targetid, cash;
	if(sscanf(params, "ud", targetid, cash))
		return SendClientMessage(playerid, COLOR_GREY, "Uzyj: /mandat [ID/Nick gracza] [Kwota]");
	if(!IsPlayerConnected(targetid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff} » informacja", "Gracz nie jest po³¹czony!", "Zamknij", "");
	if(cash >= 0)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff} » informacja", "Nie mo¿esz wydaæ takiego mandatu!", "Zamknij", "");
	if(targetid == playerid)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff} » informacja", "Nie mo¿esz na siebie samego wystawiæ mandat!", "Zamknij", "");
	
	new Float:pos[3];
	GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
	
	if(IsPlayerInRangeOfPoint(playerid, 7.5, pos[0], pos[1], pos[2]))
	{
		format(C_STRING, sizeof(C_STRING), "{dca2f4}** %s wypisuje mandat %s.", pName(playerid), pName(targetid));
		ActionMe(playerid, C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie wypisa³eœ mandat %s (ID: %d) na $%d", pName(targetid), targetid, cash);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		format(C_STRING, sizeof(C_STRING), "Otrzyma³eœ mandat od %s %s (ID: %d) na $%d", GetRankName(pInfo[playerid][Faction], pInfo[playerid][FactionRank]), pName(playerid), playerid, cash);
		ShowPlayerDialog(targetid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff} » informacja", C_STRING, "Zamknij", "");
	}
	else
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff} » informacja", "Gracz jest za daleko!", "Zamknij", "");
	return 1;
}
