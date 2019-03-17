#include <a_samp>
#include <zcmd>
#include <sscanf2>

/* KOLORY */
#include "modules/define.pwn"
#include "modules/kolory.pwn"
#include "modules/funkcje.pwn"

/*CMD:permisje(playerid, params[]) return cmd_uprawnienia(playerid, params);
CMD:upr(playerid, params[]) return cmd_uprawnienia(playerid, params);
CMD:uprawnienia(playerid, params[])
{
	new string[500], title[64], playerName[MAX_PLAYER_NAME], bool:any = false; 
	GetPlayerName(playerid, playerName, sizeof(playerName));
	format(title, sizeof(title), "{00e200}%s {ffffff}[UID: %d]", playerName, playerid);
	if (IsPlayerAdmin(playerid)) {
		format(string, sizeof(string), "{ffffff}» RCON - {00e200}TAK\n");
		any = true;
	}
	if (GetPlayerFlag(playerid, FFLAG_PANEL)) {
		format(string, sizeof(string), "%s{ffffff}» PANEL SERWERA - {00e200}TAK\n", string);
		any = true;
	}
	if (GetPlayerFlag(playerid, FFLAG_ADMIN)) {
		format(string, sizeof(string), "%s{ffffff}» Administrator - {00e200}TAK\n", string);
		any = true;
	}
	if (GetPlayerFlag(playerid, FFLAG_MOD)) {
		format(string, sizeof(string), "%s{ffffff}» Moderator - {00e200}TAK\n", string);
		any = true;
	}
	if (GetPlayerFlag(playerid, FFLAG_PENALTY)) {
		format(string, sizeof(string), "%s{ffffff}» Nadawanie kar - {00e200}TAK\n", string);
		any = true;
	}
	if (GetPlayerFlag(playerid, FFLAG_UNPENALTY)) {
		format(string, sizeof(string), "%s{ffffff}» Zdejmowanie kar - {00e200}TAK\n", string);
		any = true;
	}
	if (GetPlayerFlag(playerid, FFLAG_MANAGEFACTIONS)) {
		format(string, sizeof(string), "%s{ffffff}» Zarz¹dzanie frakcjami- {00e200}TAK\n", string);
		any = true;
	}
	if(any == false) format(string, sizeof(string), "{ff0000}\tBRAK JAKICHKOLWIEK UPRAWNIEÑ");
	ShowPlayerDialog(playerid, 6912, DIALOG_STYLE_LIST, title, string, "Zamknij", "");
	return 1;
} */



 /* KOMENDY DLA GRACZA */

CMD:stats(playerid, params[])
{
	new string[500];
	format(string, sizeof(string), "{ffffff}U¿ytkownik: \t{f9cc00}%s {ffffff}[UID: %d]\t\t\n{ffffff}IP:\t{f9cc00}%s\t\n\t\t\n{f9cc00}Czas spêdzony na serwerze:\t%d godzin, %d minut\t\n{f9cc00}Gamescore:\t%dGS\t\n{f9cc00}Pieni¹dze:\t$%d\t\n{f9cc00}Frakcja:\t%s [UID: %d]\t\n",\
		pName(playerid), pInfo[playerid][UID], pInfo[playerid][IP] ,pInfo[playerid][Hours], pInfo[playerid][Minutes],pInfo[playerid][Score],pInfo[playerid][Money], GetPlayerGroupName(playerid), GetPlayerGroup(playerid));
	format(string, sizeof(string), "%s{f9cc00}Ranga:\t%s\t\n{f9cc00}Skin:\t%d\t\n", string, GetRankName(GetPlayerGroup(playerid), pInfo[playerid][FactionRank]), pInfo[playerid][Skin]);
	if(IsPlayerAdminEx(playerid)) format(string, sizeof(string), "%s{f9cc00}Poziom admin. :\t%d\t\n", string, pInfo[playerid][AdminLevel]);
	ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_TABLIST, DNAZWA" » Statystyki", string, "Zamknij", "");
	return 1;
}  
CMD:checkstats(playerid, args[]) return cmd_sprawdzstats(playerid, args);
CMD:sprawdzstats(playerid, args[]) {
	new string[500], targetid; 
	if(!IsPlayerAdminLevel(playerid, 6)) return NoAccessMessage(playerid);
	if(sscanf(args, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /sprawdzstats [id/nick]");
	format(string, sizeof(string), "{ffffff}U¿ytkownik \t{f9cc00}%s {ffffff}[UID: %d]\t\t\n{ffffff}IP:\t{f9cc00}%s\t\n\t\t\n{f9cc00}Czas spêdzony na serwerze:\t%d godzin, %d minut\t\n{f9cc00}Gamescore:\t%dGS\t\n{f9cc00}Pieni¹dze:\t$%d\t\n{f9cc00}Frakcja:\t%s [UID: %d]\t\n",\
		pName(targetid), pInfo[targetid][UID], pInfo[targetid][IP] ,pInfo[targetid][Hours], pInfo[targetid][Minutes],pInfo[targetid][Score],pInfo[targetid][Money], fInfo[pInfo[targetid][Faction]][Name], pInfo[targetid][Faction]);
	format(string, sizeof(string), "%s{f9cc00}Ranga:\t%s\t\n{f9cc00}Skin:\t%d\t\n", string, GetRankName(pInfo[targetid][Faction], pInfo[targetid][FactionRank]), pInfo[targetid][Skin]);
	ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_TABLIST, DNAZWA" » Statystyki", string, "Zamknij", "");
	return 1;
}

/*CMD:xopis(playerid, params[])
{
    new String[64], Opis_Text[64], Opis_Text2[256],
   // Float:X, Float:Y, Float:Z, Text3D:Opis;
    GetPlayerPos(playerid, X, Y, Z);
    if(sscanf(params, "s[64]", String)) return SendClientMessage(playerid, -1, "U¿ycie: /opis [TREŒÆ]");
    format(Opis_Text, sizeof(Opis_Text), "%s", String);
    format(Opis_Text2, sizeof(Opis_Text2), "Ustawiono opis: %s", Opis_Text);
    SendClientMessage(playerid, -1, Opis_Text2);
    Opis = Create3DTextLabel(Opis_Text, 0xC2A2DAAA, 30.0, 40.0,-0.5, 8.0, 0, 1);
    Attach3DTextLabelToPlayer(Opis, playerid, 0.0, 0.0, -0.7);
    return 1;
}
*/
CMD:opis(playerid, params[])
{
	if(GetPVarInt(playerid, "KP-TEST"))
	{
		ShowPlayerDialog(playerid, DIALOG_DESC, DIALOG_STYLE_INPUT, DNAZWA" » Ustaw opis", "Wpisz poni¿ej opis do ustawienia\n\nPosiadasz konto premium dziêki czemu mo¿esz sformatowaæ swój opis\nAby zmieniæ odcieñ opisu u¿yj koloru w formacie {hex} wstawiaj¹c go przed treœæ opisu", "Ustaw", "");
	}
	else
    ShowPlayerDialog(playerid, DIALOG_DESC, DIALOG_STYLE_INPUT, DNAZWA" » Ustaw opis", "Wpisz poni¿ej opis do ustawienia", "Ustaw", "");
    return 1;
}

CMD:test(playerid, params[])
{
	SetPVarInt(playerid, "KP-TEST", 1);
	SetPlayerInterior(playerid, 12);
	SetPlayerPos(playerid, 	2324.33, -1144.79, 1050.71);
	return 1;
}

CMD:qs(playerid)
{
	SendClientMessage(playerid, COLOR_GREY, "Zapisano twoj¹ pozycjê.");
	SetTimerEx("KickEx", 500, 0, "i", playerid);
	return 1; 
}

CMD:time(playerid, params[])
{
	SetWorldTime(strval(params));
	return 1;
}

 
CMD:pomoc(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_TABLIST_HEADERS, DNAZWA " » Spis komend",\
	"{f9cc00}Komenda\t Skrót\tDzia³anie\n\
	{f9cc00}/stats\t-\tPokazuje dialog ze statystykami\n\
	{f9cc00}/dolacz\t-\tPozwala do³¹czyæ do jakiejœ pracy\n\
	{f9cc00}/opis\t-\tUstawiasz w³asny opis\n\
	{f9cc00}/dolacz\t-\tPozwala do³¹czyæ do jakiejœ pracy",\
	"Zamknij", "");
	return 1;
} 

CMD:dolacz(playerid)
{
	/* PRACA MECHANIKA || SLOT PRACY: 1 || */
	if(pInfo[playerid][Job] == 1) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "» Informacja", "{ffffff}Posiadasz obecnie pracê mechanika! Aby siê zwolniæ wpisz /zwolnij", "Ok", "Zamknij");
	if(pInfo[playerid][Job] == 2) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "» Informacja", "{ffffff}Posiasdasz obecnie pracê w firmie sprz¹taj¹cej! Aby siê zwolniæ wpisz /zwolnij", "Ok", "Zamknij");
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 655.2314,-503.1116,16.3359))
	{
		GiveJob(playerid, 1);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{0fce55}» Praca mechanika", "{ffffff}Do³¹czy³eœ do pracy mechanika!\nOd teraz jeŸdzisz do zg³oszeñ, naprawiasz i tankujesz pojazdy!\n{ffffff}SprawdŸ dostêpne komendy pod {0fce55}/pomoc", "Ok", "Zamknij");
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 854.6208,-605.2053,18.4219))
	{
		GiveJob(playerid, 2);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{0fce55}» Praca Sprz¹tacza", "{ffffff}Do³¹czy³eœ do firmy sprz¹taj¹cej\nMasz wa¿n¹ misjê, dbaj o czystoœæ w mieœcie\n{ffffff}SprawdŸ dostêpne komendy pod {0fce55}/pomoc", "Ok", "Zamknij");
		return 1;
	}
	else ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "» Informacja", "{ffffff}Nie znajdujesz siê przy budynku pracodawcy", "Ok", "Zamknij");
	return 1;
}


CMD:drzwi(playerid, args[]) {
	/*if(!IsPlayerInAnyVehicle(playerid)) {
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 629.0994,-571.8003,16.8967)) {//komisariat
			SetPlayerInterior(playerid, 10);
			SetPlayerPos(playerid, 246.40,  110.84, 1003.22);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("unfreeze", 2000, false, "i", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, 288.4723, 170.0647, 1007.1794)) {//komisariat wyjscie
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 288.4723, 170.0647, 1007.1794);

			TogglePlayerControllable(playerid, 0);
			SetTimerEx("unfreeze", 2000, false, "i", playerid);
		}
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 670.9697,-519.3539,16.3359)) { //dmv
			//SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,694.6577,-499.7328,0.5897); 
			SetPlayerFacingAngle(playerid, 178.2420);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("unfreeze", 2000, false, "i", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 694.6577,-499.7328,0.5897) || IsPlayerInRangeOfPoint(playerid, 3.0, 692.5205,-504.3206,0.5897)) {//dmv wyjscie
			//SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 670.9697,-519.3539,16.3359);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("unfreeze", 2000, false, "i", playerid);
		}
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 691.5554,-546.7997,16.3359)) { //sklepzubraniami
			SetPlayerInterior(playerid, 14);
			SetPlayerPos(playerid, 204.332992,-166.694992,1000.523437); 
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("unfreeze", 2000, false, "i", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, 204.332992,-166.694992,1000.523437)) { //sklepzubraniami wyjscie
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 691.5554,-546.7997,16.3359);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("unfreeze", 2000, false, "i", playerid);
		}
	}
	else SendClientMessage(playerid, -1, "Nie mo¿esz wejœæ do interioru bêd¹c w pojeŸdzie!");*/
	return 1;
}

CMD:zwolnijsie(playerid)
{
	if(pInfo[playerid][Job] == 1) // Praca mechanika || SLOT [1]
	{
		GiveJob(playerid, 0);
		SendClientMessage(playerid, COLOR_GREY, "Zwolni³eœ siê z pracy mechanika!");
		return 1;
	}
	if(pInfo[playerid][Job] == 2) // Praca sprz¹tacza || SLOT [2]
	{
		GiveJob(playerid, 0);
		SendClientMessage(playerid, COLOR_GREY, "Zwolni³eœ siê z pracy sprz¹tacza ulic!");
		return 1;
	}
	else SendClientMessage(playerid, COLOR_GREY, "Nie posiadasz pracy, z której mo¿esz siê zwolniæ!");
	return 1;
}

CMD:urzad(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, -2033.4344,-117.4557,1035.1719)) {
		ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, DNAZWA " » DMV", "Wyrób prawo jazdy\nWyrób dowód\nZarejestruj pojazd\nZap³aæ mandaty", "Ok", "Zamknij");
		return 1;
	}
	
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, 698.9297,-507.6399,0.5819)) {
	 ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA" » DMV", "Nie znajdujesz siê w budynku urzêdu miasta.", "Ok", "Zamknij");
	 return 1;
	} 
	return 1;
}

/*
CMD:call(playerid, params[]) //dobieranie 
{
	new phonenumb;
	if( sscanf(params, "ds[128]", phonenumb))
	{
		SendClientMessage(playerid, COLOR_GREY, "U¯YJ: /call[dzwon/polaczenie]");
		return 1;
	}
	else if(phonenumb == 911)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		SendClientMessage(playerid, COLOR_WHITE, "£¹czê z numerem {ff0000}911..");
		SendClientMessage(playerid, COLOR_YELLOW, "Po³¹czenie Alarmowe: Witamy, z kim chcesz siê po³¹czyæ to chuj ci w dupe cwelu..");
		SetTimerEx("StopCall",2000,0,"d",playerid);
	}
	return 1;
}*/

//========== | SKLEP | GS | ============//

CMD:sklep(playerid, params[])
{
	new string[500], title[100], playerName[MAX_PLAYER_NAME]; 
 
	GetPlayerName(playerid, playerName, sizeof(playerName));
	format(title, sizeof(title), "{ffffff}Obecnie posiadasz: {f9cc00}%d{ffffff} gamescore", GetPlayerScore(playerid));   
	format(string, sizeof(string), "» SLOT 1\n» SLOT 2\n» SLOT 3");
   // format(string,sizeof(string),"Nazwa konta: %s\nIloœæ pieniêdzy: -", playerName);
	ShowPlayerDialog(playerid, 6969, DIALOG_STYLE_LIST, title, string, "Zamknij", "");
	return 1;
}

//========== | SKLEP | GS | ============//

CMD:przebierz(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 204.2789,-157.8296,1000.5234))
	{
		SendClientMessage(playerid, COLOR_WHITE, "John Binco mówi: Witaj, je¿eli chcesz zmieniæ swój ubiór udaj siê do poczekalni!");
		SendClientMessage(playerid, COLOR_GRAD1, "John Binco (OOC): Wpisz tutaj /ubranie");
		return 1;
	}
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 204.2789,-157.8296,1000.5234))
	{
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Binco", "Nie znajdujesz siê w budynku sklepu z ubraniami", "Ok", "Zamknij");
		return 1;
	}
	return 1;
}	

CMD:ubranie(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 204.2789,-157.8296,1000.5234))
	{
		SendClientMessage(playerid, KOLOR_AC, "Funkcja w budowie ;-D");
		return 1;
	}
	return 1;
}

CMD:motel(playerid, params[])
{
	new command[32], varchar[32];
	if (sscanf(params, "s[32]S()[32]", command, varchar)) {
		SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /motel (wejdz, zamelduj)");
		return 1;
	}

	if (!strcmp(command, "wejdz", true)) {	
		for(new mt; mt < sizeof(Motels); mt++) 
		if(IsPlayerInRangeOfPoint(playerid, 3.0, Motels[mt][0],Motels[mt][1],Motels[mt][2]))
		{
			SendClientMessage(playerid, COLOR_RED, "Jesteœ w strefie moteli");
			return 1;
		}
	}

	if (!strcmp(command, "zamelduj", true)) {	
		for(new mt; mt < sizeof(Motels); mt++) 
		if(IsPlayerInRangeOfPoint(playerid, 3.0, Motels[mt][0],Motels[mt][1],Motels[mt][2]))
		{
			SendClientMessage(playerid, COLOR_RED, "Zameldowa³eœ siê w tym motelu!");
			GivePlayerMoney(playerid, -50 + playerid);
			return 1;
		}
	}
	return 1;
}

CMD:radio(playerid, params[])
{
	ShowPlayerDialog(playerid, RADIO_DIALOG, DIALOG_STYLE_LIST, DNAZWA" » Panel Radiowy", "{ff0000}Wy³¹cz radio\n\n\n{ffffff}RMF FM\nRMF MAXX\nRadio Party\nOpenFM\n", "Wybierz", "");
	return 1;
}