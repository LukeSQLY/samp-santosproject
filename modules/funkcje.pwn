/*
#include <a_samp>
#include <YSI\y_ini>
#include <zcmd>
#include "modules/kolory.pwn"
#include "modules/define.pwn" 
*/

new Float:LosujSpawn[2][3] = { 
{660.1384,-620.5809,16.3410},
{668.7280,-464.5838,16.3419} //serek tutaj dodaj wiecej spawnuw ok kórwa
};

new Float:Motels[][] = {
	{672.0633,-632.0295,16.3359}
};

new LosujWiadomosc[][] =
{
	"Administracja przypomina, je¿eli dzieje siê coœ niepokoj¹cego zg³oœ to /report",
	"Serdecznie zapraszamy na nasz¹ stronê www.santosproject.pl"
};

// ------------------------------------------------------------------------------------------
//			------------------------------ £ADOWANIE ------------------------------
// ------------------------------------------------------------------------------------------


stock LoadDoors() {
	new ticks = GetTickCount();
	mysql_tquery(Database, "SELECT * FROM doors", "MYSQL_LoadDoors");
	printf("\tLOAD_INFO: Za³adowano drzwi na serwer! Czas: %dms", GetTickCount() - ticks);
	return 1;
}

stock LoadPickup()
{
	new ticks = GetTickCount();
	CreatePickup(1318, 0, 670.9697,-519.3539,16.3359, 0); //DMV
	CreatePickup(1318, 0, 701.7330,-519.1711,16.3298, 0); //Sklep z rowerami
	CreatePickup(1275, 0, 691.5554,-546.7997,16.3359, 0); //sklep z ciuchami [LUKE]
	CreatePickup(1318, 0, 712.0638,-498.9213,16.3359, 0); //sklep z przedmiotami
	CreatePickup(1272, 0, 614.4157,-518.4808,16.3533, 0); //salon aut 1272
	printf("\tLOAD_INFO: Za³adowano pickupy na serwer! Czas: %dms", GetTickCount() - ticks);
	return 1;
}

forward StopDrawPenalty(); 
public StopDrawPenalty() 
{ 
    pntly = false; //bool false [penalty]
    TextDrawHideForAll(Kary); 
    KillTimer(OffPenalty); 
    return 1; 
} 



ShowPenalty(text[]) { 
    if(pntly) { 
    TextDrawHideForAll(Kary); 
    KillTimer(OffPenalty); } 
    pntly = true; 
    TextDrawSetString(Kary,text); 
    TextDrawShowForAll(Kary); 
    OffPenalty = SetTimer("StopDrawPenalty",20000,false);
    return 1; } 

stock LoadTextDraw()
{
	new ticks = GetTickCount();
	//napis w ld rób = URBANTRUCK.pl
	textdraw_0 = TextDrawCreate(6.000000, 426.000000, NAZWA);
	TextDrawFont(textdraw_0, 3);
	TextDrawLetterSize(textdraw_0, 0.425000, 1.799998);
	TextDrawTextSize(textdraw_0, 400.000000, 17.000000);
	TextDrawSetOutline(textdraw_0, 1);
	TextDrawSetShadow(textdraw_0, 0);
	TextDrawAlignment(textdraw_0, 1);
	TextDrawColor(textdraw_0, 1687547391);
	TextDrawBackgroundColor(textdraw_0, 255);
	TextDrawBoxColor(textdraw_0, 50);
	TextDrawUseBox(textdraw_0, 0);
	TextDrawSetProportional(textdraw_0, 1);
	TextDrawSetSelectable(textdraw_0, 0);

	TDEditor_TD[0] = TextDrawCreate(578.000000, 426.859191, "On_duty");
	TextDrawLetterSize(TDEditor_TD[0], 0.400000, 1.600000);
	TextDrawAlignment(TDEditor_TD[0], 1);
	TextDrawColor(TDEditor_TD[0], -1);
	TextDrawSetShadow(TDEditor_TD[0], 0);
	TextDrawSetOutline(TDEditor_TD[0], 1);
	TextDrawBackgroundColor(TDEditor_TD[0], 255);
	TextDrawFont(TDEditor_TD[0], 3);
	TextDrawSetProportional(TDEditor_TD[0], 1);
	
	Kary = TextDrawCreate(20.000000, 288.000000,"_"); 
    TextDrawTextSize(Kary, 344.000000,0.000000); 
    TextDrawAlignment(Kary,0); 
    TextDrawBackgroundColor(Kary, 0x000000ff); 
    TextDrawFont(Kary,1); 
    TextDrawLetterSize(Kary,0.299999,1.000000); 
    TextDrawLetterSize(Kary, 0.340000, 1.000000); 
    TextDrawColor(Kary, 0xffffffff); 
    TextDrawSetOutline(Kary,1); 
    TextDrawSetProportional(Kary,1); 
    TextDrawSetShadow(Kary,1);
	
	printf("\tLOAD_INFO: Za³adowano textdrawy na serwer! Czas: %dms", GetTickCount() - ticks);
	return 1;
}
stock LoadPlayerTextdraw(playerid) 
{
	//INFORMACJE
	//BOX
	textdraw_3[playerid] = CreatePlayerTextDraw(playerid, 56.000000, 166.000000, "_");
	PlayerTextDrawFont(playerid, textdraw_3[playerid], 1);
	PlayerTextDrawLetterSize(playerid, textdraw_3[playerid], 0.600000, 5.649983);
	PlayerTextDrawTextSize(playerid, textdraw_3[playerid], 298.500000, 96.500000);
	PlayerTextDrawSetOutline(playerid, textdraw_3[playerid], 1);
	PlayerTextDrawSetShadow(playerid, textdraw_3[playerid], 0);
	PlayerTextDrawAlignment(playerid, textdraw_3[playerid], 2);
	PlayerTextDrawColor(playerid, textdraw_3[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, textdraw_3[playerid], 4);
	PlayerTextDrawBoxColor(playerid, textdraw_3[playerid], 27);
	PlayerTextDrawUseBox(playerid, textdraw_3[playerid], 1);
	PlayerTextDrawSetProportional(playerid, textdraw_3[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, textdraw_3[playerid], 0);
	//koniec box
	textdraw_1[playerid] = CreatePlayerTextDraw(playerid, 59.000000, 170.000000, "~w~~r~INFORMACJA:");
	PlayerTextDrawFont(playerid, textdraw_1[playerid], 3);
	PlayerTextDrawLetterSize(playerid, textdraw_1[playerid], 0.416666, 1.549980);
	PlayerTextDrawTextSize(playerid, textdraw_1[playerid], 302.000000, 107.000000);
	PlayerTextDrawSetOutline(playerid, textdraw_1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, textdraw_1[playerid], 2);
	PlayerTextDrawAlignment(playerid, textdraw_1[playerid], 2);
	PlayerTextDrawColor(playerid, textdraw_1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, textdraw_1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, textdraw_1[playerid], 135);
	PlayerTextDrawUseBox(playerid, textdraw_1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, textdraw_1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, textdraw_1[playerid], 0);

	textdraw_2[playerid] = CreatePlayerTextDraw(playerid, 55.000000, 187.000000, "  ~w~~w~Aby odpalic pojazd kliknij klawisz ~g~Y");
	PlayerTextDrawFont(playerid, textdraw_2[playerid], 1);
	PlayerTextDrawLetterSize(playerid, textdraw_2[playerid], 0.204165, 1.049980);
	PlayerTextDrawTextSize(playerid, textdraw_2[playerid], 305.500000, 107.000000);
	PlayerTextDrawSetOutline(playerid, textdraw_2[playerid], 1);
	PlayerTextDrawSetShadow(playerid, textdraw_2[playerid], 0);
	PlayerTextDrawAlignment(playerid, textdraw_2[playerid], 2);
	PlayerTextDrawColor(playerid, textdraw_2[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, textdraw_2[playerid], 255);
	PlayerTextDrawBoxColor(playerid, textdraw_2[playerid], 135);
	PlayerTextDrawUseBox(playerid, textdraw_2[playerid], 0);
	PlayerTextDrawSetProportional(playerid, textdraw_2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, textdraw_2[playerid], 0);
}

stock Load3DText()
{
	new ticks = GetTickCount();
	Create3DTextLabel("San Andreas County Sheriff's Department",1123692742,627.121887,-571.705017,17.914501,30.0,0,1);
	Create3DTextLabel("Urz¹d Miasta ",-6750038,671.261047,-519.545776,16.335937,30.0,0,1);
	Create3DTextLabel("((/urzad))",-86,-2033.433715,-117.378898,1035.171875,30.0,0,1);
	Create3DTextLabel("** Na tablicy informacje o godzinie kursów oraz wyrabiania dokumentów **",-86,-2022.057983,-116.816917,1035.171875,30.0,0,1);
	Create3DTextLabel("((/wyjdz albo ALT+SPACJA))",-86,-2029.741699,-119.624496,1035.171875,30.0,0,1);
	Create3DTextLabel("Sklep z ubraniami ",-6750038,691.5554,-546.7997,16.3359,30.0,0,1);
	Create3DTextLabel("24/7",COLOR_GREY,712.62, -498.89, 16.33,30.0,1);
	Create3DTextLabel("Stacja benzynowa",0x3A47DEFF,660.95, -573.38, 16.33,30.0,1);
	Create3DTextLabel("Zaplecze SASD",0xAFAFAFAA,611.05, -583.69, 18.12,30.0,1);
	Create3DTextLabel("Motel 24h",0xFFFF00AA,672.06, -632.04, 16.33,30.0,1);
	Create3DTextLabel("Klatka schodowa",0xFF66FFFF,704.06, -642.10, 16.33,30.0,1);
	Create3DTextLabel("PodejdŸ tutaj jeœli chcesz wyrobiæ dokumenty.\n{F9CC00}/urzad", COLOR_WHITE, 698.9971,-508.1740,0.5819, 7.5, 0, 0);
	printf("\tLOAD_INFO: Za³adowano 3D-Texty na serwer! Czas: %dms", GetTickCount() - ticks);
	return 1;
}

stock Text3DLOAD()
{
    new ticks = GetTickCount();
    printf("\tLOAD_INFO: Za³adowano system 3DTextów na serwer! Czas: %dms", GetTickCount() - ticks);
	
	mysql_tquery(Database, "SELECT * FROM `3dtext`", "MYSQL_Load3dtext");
}

stock LoadActor()
{
	new ticks = GetTickCount();
	CreateActor(125, 204.2789,-157.8296,1000.5234, 179.0); //Sklepikarz w skklepie z ubraniami
	printf("\tLOAD_INFO: Za³adowano aktorów na serwer! Czas: %dms", GetTickCount() - ticks);
	return 1;
}

stock LoadMapICON()
{
	new ticks = GetTickCount();
	for(new mt; mt < sizeof(Motels); mt++) {
		SetPlayerMapIcon(playerid, 1, Float:Motels[mt], Float:Motels[mt], Float:Motels[mt], 35, 0, MAPICON_LOCAL)
	}
	printf("\tLOAD_INFO: Za³adowano ikony na serwer! Czas: %dms", GetTickCount() - ticks);
	return 1;
}
forward LoadPickupTimer(playerid);
public LoadPickupTimer(playerid)
{
	GameTextForPlayer(playerid, "~g~ZALADOWANO PICKUPY!", 3000, 4);
	LoadPickup();
	return 1;
}


forward LoadActorTimer(playerid);
public LoadActorTimer(playerid)
{
	GameTextForPlayer(playerid, "~g~ZALADOWANO AKTOROW!", 3000, 4);
	LoadActor();
	return 1;
}

forward Load3DTimer(playerid);
public Load3DTimer(playerid)
{
	GameTextForPlayer(playerid, "~g~ZALADOWANO 3DTEXTY!", 3000, 4);
	Load3DText();
	return 1;
}

// ------------------------------------------------------------------------------------------
//			------------------------------ FUNKCJE ------------------------------
// ------------------------------------------------------------------------------------------

GetRankName(factionid, rankid) {
	new temp[64];
	switch(rankid) 
	{
		case 0:{ 
			format(temp, 64, fRank[factionid][rank0]);
			return temp;
		}
		case 1: {
			format(temp, 64, fRank[factionid][rank1]);
			return temp;
		}
		case 2: {
			format(temp, 64, fRank[factionid][rank2]);
			return temp;
		}
		case 3: {
			format(temp, 64, fRank[factionid][rank3]);
			return temp;
		}
		case 4: {
			format(temp, 64, fRank[factionid][rank4]);
			return temp;
		}
		case 5: {
			format(temp, 64, fRank[factionid][rank5]);
			return temp;
		}
		case 6: {
			format(temp, 64, fRank[factionid][rank6]);
			return temp;
		}
		case 7: {
			format(temp, 64, fRank[factionid][rank7]);
			return temp;
		}
		case 8: {
			format(temp, 64, fRank[factionid][rank8]);
			return temp;
		}
		case 9: {
			format(temp, 64, fRank[factionid][rank9]);
			return temp;
		}
	}
	temp = fRank[factionid][rank0];
	return temp;
}

EscapeString(string[]) {
	for(new i; i <= strlen(string); i++) {
		if(string[i] == '%') string[i] = ' ';
	}
	return string;
}

stock Log(const logfile[], logstring[]) {
	new File:hFile, Hour, Minute, Second, Year, Month, Day, string[128];
	getdate(Year, Month, Day);
	gettime(Hour, Minute, Second);
	hFile = fopen(logfile, io_append);
	format(string, sizeof(string), "[%02d/%02d/%d %02d:%02d:%02d] %s\n", Day, Month, Year, Hour, Minute, Second, logstring);
	fwrite(hFile, string);
	fclose(hFile);
}

forward UpdatePlayerData(playerid); //timer wolany 5 sekund
public UpdatePlayerData(playerid) {
	UpdatePlayer3DName(playerid);
}

forward UpdatePlayer3DName(playerid);
public UpdatePlayer3DName(playerid) {
	new statuses[128], mainstring[144+MAX_PLAYER_NAME], statusesCount, Float:armour;
	GetPlayerArmour(playerid, Float:armour);
	if(IsPlayerAdminLevel(playerid, 1000)) {
		if(statusesCount) strins(statuses, ", ", strlen(statuses));
		strins(statuses, "{ff0000}g³ówny administrator{ffffff}", strlen(statuses));
		statusesCount++;
	}
	else if(IsPlayerAdminLevel(playerid, 6)) {
		if(statusesCount) strins(statuses, ", ", strlen(statuses));
		strins(statuses, "{993333}gamemaster{ffffff}", strlen(statuses));
		statusesCount++;
	}
	else if(IsPlayerAdminLevel(playerid, 1)) {
		if(statusesCount) strins(statuses, ", ", strlen(statuses));
		strins(statuses, "{007eff}supporter{ffffff}", strlen(statuses));
		statusesCount++;
	}
	if(pInfo[playerid][Hours] < 5) {
		if(statusesCount) strins(statuses, ", ", strlen(statuses));
		strins(statuses, "nowy gracz", strlen(statuses));
		statusesCount++;
	}
	if(GetPVarInt(playerid, "onduty")) {
		if(statusesCount) strins(statuses, ", ", strlen(statuses));
		strins(statuses, "na s³u¿bie", strlen(statuses));
		statusesCount++;
	}
	if(Float:armour) {
		if(statusesCount) strins(statuses, ", ", strlen(statuses));
		strins(statuses, "kamizelka", strlen(statuses));
		statusesCount++;
	}
	if(GetPVarInt(playerid, "brutalw")) {
		if(statusesCount) strins(statuses, ", ", strlen(statuses));
		strins(statuses, "nieprzytomny", strlen(statuses));
		statusesCount++;
	}
	if(statusesCount) format(mainstring, sizeof(mainstring), "%s {f9cc00}[ID: %d]\n{ffffff}(%s)", pName(playerid), playerid, statuses);
	else format(mainstring, sizeof(mainstring), "%s {f9cc00}[ID: %d]", pName(playerid), playerid);
	Update3DTextLabelText(pInfo[playerid][Player3DText], COLOR_WHITE, mainstring);
}

forward TimeUpdater();
public TimeUpdater()
{
    gettime(hours, minutes);
    SetWorldTime(hours);
    foreach(new x : Player) {
        if(IsPlayerConnected(x) && GetPlayerState(x) != PLAYER_STATE_NONE) {
            SetPlayerTime(x, hours, minutes);
        }
    }
}

stock AddScriptMoney(playerid, amount) {
	pInfo[playerid][Money]+= amount;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pInfo[playerid][Money]);
}

stock SetScriptMoney(playerid, amount) {
	pInfo[playerid][Money] = amount;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pInfo[playerid][Money]);
}

stock GetPlayerFaction(playerid) return pInfo[playerid][Faction];
stock IsPlayerFactionLeader(playerid) {
	if(pInfo[playerid][Faction] > 0 && pInfo[playerid][FactionLeader] == 1) return true;
	else return false;
}

stock pName(playerid) {
	new str[24];
	GetPlayerName(playerid, str, 24);
	return str;
}

stock NoAccessMessage(id) {
	return SendClientMessage(id, COLOR_FADE2, "»» Brak uprawnieñ do u¿ycia tej komendy!");
}


stock PlaySoundForAll(soundid) {
	for(new i = 0; i <= MAX_PLAYERS; i++) PlayerPlaySound(i, soundid, 0.0, 0.0, 0.0);
}

stock GiveJob(playerid, jobid) {
 return pInfo[playerid][Job] = jobid;
}

stock randomEx(min, max)
{      
    new rand = random(max-min)+min;    
    return rand;
}

forward mysql_skin(playerid);
public mysql_skin(playerid) {

	SetPlayerSkin(playerid, pInfo[playerid][Skin]); //wywo³ywanie skina
}

forward bw_yes(playerid);
public bw_yes(playerid) {

	SetPVarInt(playerid, "brutalw", 1);
	SetPlayerHealth(playerid, 25);
	TogglePlayerControllable(playerid, 0);
	SetPlayerSkin(playerid, pInfo[playerid][Skin]);
	TextDrawHideForPlayer(playerid, TDEditor_TD[0]); //zabieranie statusu duty
	SetPVarInt(playerid, "onduty", 0); //zabieranie statusu duty
	ShowPlayerDialog(playerid, BW_DIALOG, DIALOG_STYLE_MSGBOX, DNAZWA" » Utrata przytomnoœci", "Twoja postaæ jest nieprzytomna na 2 minuty \n Status s³u¿by zosta³ zdjêty automatycznie", "Zamknij", "");
	SetTimerEx("bw_no", BW_TIME, 0, "i", playerid);
	return 1;

}

forward bw_no(playerid);
public bw_no(playerid)
{
	SetPVarInt(playerid, "brutalw", 0);
	TogglePlayerControllable(playerid, 1);
	GameTextForPlayer(playerid, "ODZYSKALES PRZYTOMNOSC", 15000, 1);
}

//aodo------------------------------------------------

forward aodostart(playerid);
public aodostart(playerid)
{
	SetPVarInt(playerid, "hasaodo", 1);
	GameTextForPlayer(playerid, "ZAKLADANIE AODO", 5000, 5);
	SetTimerEx("aodoyes", 5000, false, "i", playerid);
}

forward aodoyes(playerid);
public aodoyes(playerid)
{
	SetPlayerArmour(playerid, 100);
	SetPlayerSkin(playerid, 278);
	ShowPlayerDialog(playerid, 654, DIALOG_STYLE_MSGBOX, DNAZWA" » AODO","Za³o¿y³eœ kombinezon oraz aparat tlenowy! Kieruj siê na miejsce zdarzebua gdzie nastêpnie u¿yj komendy /tlen", "Ok", "");
	return 1;
}

//aodo--------------------------------------------end

forward AddPlayerTime(playerid);
public AddPlayerTime(playerid) {
	pInfo[playerid][Minutes]++;
	if(pInfo[playerid][Minutes] >= 60) {
		pInfo[playerid][Minutes] = 0;
		pInfo[playerid][Hours]++;
		AddScriptMoney(playerid, MONEY_PER_HOUR);
		pInfo[playerid][Score]+= GAMESCORE_PER_HOUR;
		GameTextForPlayer(playerid, "~w~Otrzymujesz ~g~$500~w~ za spedzenie godziny w grze!", 10000, 6);
	}
}

forward LosowySpawn(playerid);
public LosowySpawn(playerid) {
new rand = random(sizeof LosujSpawn);
SetSpawnInfo(playerid, 0, pInfo[playerid][Skin],LosujSpawn[rand][0],LosujSpawn[rand][1],LosujSpawn[rand][2],90.0,0,0,0,0,0,0);
SpawnPlayer(playerid);
return 1;
}


forward LoginCamera(playerid);
public LoginCamera(playerid) {
	InterpolateCameraPos(playerid, 425.0, -526.0, 43.0+20.0, 654.0, -526.0, 16.0+20.0, 45*1000, CAMERA_MOVE);
	InterpolateCameraLookAt(playerid, 654.0, -555.0, 16.0, 798.0,- 551.0, 16.0, 30*1000, CAMERA_MOVE);
}

forward RollMY();
public RollMY()
{

	SendClientMessageToAll(COLOR_GREEN, LosujWiadomosc[random(sizeof(LosujWiadomosc))]);
	return 1;
}

forward StopCall(playerid);
public StopCall(playerid)
{
	SendClientMessage(playerid, COLOR_GREY, "Po³¹czenie zakoñczone");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	return 1;
}

forward DrawSpawn(playerid);
public DrawSpawn(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	SetCameraBehindPlayer(playerid);
	LosowySpawn(playerid);
	return 1;
}

forward CheckSpawn(playerid);
public CheckSpawn(playerid)
{
	 ShowPlayerDialog(playerid, 23, DIALOG_STYLE_MSGBOX, DNAZWA " » Wybór spawnu" , "{ffffff}Wybierz, gdzie chcesz siê zrespiæ", "Baza", "Dom");
}


forward unfreeze(playerid);
public unfreeze(playerid) {
	TogglePlayerControllable(playerid, 1);
	return 1;
}

forward Cuffed(playerid, policeid);
public Cuffed(playerid, policeid)
{
	if(IsPlayerInAnyVehicle(policeid) && IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == GetPlayerVehicleID(policeid))
		return 1;
	
	if(IsPlayerInAnyVehicle(policeid) && !IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			return PutPlayerInVehicle(playerid, GetPlayerVehicleID(policeid), 2);
	}
		
	new Float:pos[3];
	GetPlayerPos(policeid, pos[0], pos[1], pos[2]);
	
	SetPlayerPosFindZ(playerid, pos[0] + 2.0, pos[1] + 2.0, pos[2]);
	return 1;
}

forward KickEx(playerid);
public KickEx(playerid)
{
Kick(playerid);
}


forward AdminFly(playerid);
public AdminFly(playerid)
{
	if(!IsPlayerConnected(playerid))
		return flying[playerid] = false;

	if(flying[playerid])
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			new
				keys,
				ud,
				lr,
				Float:x[2],
				Float:y[2],
				Float:z;

			GetPlayerKeys(playerid, keys, ud, lr);
			GetPlayerVelocity(playerid, x[0], y[0], z);
			if(ud == KEY_UP)
			{
				GetPlayerCameraPos(playerid, x[0], y[0], z);
				GetPlayerCameraFrontVector(playerid, x[1], y[1], z);
				ApplyAnimation(playerid, "SWIM", "Swim_Tread", 4.1, 0, 1, 1, 0, 0);
				SetPlayerToFacePos(playerid, x[0] + x[1], y[0] + y[1]);
				SetPlayerVelocity(playerid, x[1], y[1], z);
			}
			else
			SetPlayerVelocity(playerid, 0.0, 0.0, 0.01);
		}
		SetTimerEx("AdminFly", 100, 0, "d", playerid);
	}
	return 0;
}
forward Float:SetPlayerToFacePos(playerid, Float:X, Float:Y);
public Float:SetPlayerToFacePos(playerid, Float:X, Float:Y)
{
	new
		Float:pX1,
		Float:pY1,
		Float:pZ1,
		Float:ang;

	if(!IsPlayerConnected(playerid)) return 0.0;

	GetPlayerPos(playerid, pX1, pY1, pZ1);

	if( Y > pY1 ) ang = (-acos((X - pX1) / floatsqroot((X - pX1)*(X - pX1) + (Y - pY1)*(Y - pY1))) - 90.0);
	else if( Y < pY1 && X < pX1 ) ang = (acos((X - pX1) / floatsqroot((X - pX1)*(X - pX1) + (Y - pY1)*(Y - pY1))) - 450.0);
	else if( Y < pY1 ) ang = (acos((X - pX1) / floatsqroot((X - pX1)*(X - pX1) + (Y - pY1)*(Y - pY1))) - 90.0);

	if(X > pX1) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

	ang += 180.0;

	SetPlayerFacingAngle(playerid, ang);

	return ang;
}
//-------------

//-------------------------------------------------

stock SendLocalMessage(playerid, string[], Float:range) {
	if(strlen(string) > 127) {
		SendClientMessage(playerid, COLOR_RED, "B£¥D: Wiadomoœæ jest za d³uga!");
		return 0;
	}
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, Float:x, Float:y, Float:z);
	foreach(new targetid : Player) {
		if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) {
			if(IsPlayerInRangeOfPoint(targetid, Float:range, Float:x, Float:y, Float:z)) {
				new Float:distancefrompoint = GetPlayerDistanceFromPoint(targetid, Float:x, Float:y, Float:z);
				format(string, 128, "%s mówi: %s", pName(playerid), string);
				if(Float:distancefrompoint >= Float:range) {
					printf("dist: range text: %s", string);
					SendClientMessage(targetid, COLOR_GRAD1, string);
				} //if distance
				else if(Float:distancefrompoint >= Float:range / 2) {
					printf("dist: range/2t ext: %s", string);
					SendClientMessage(targetid, COLOR_GRAD3, string);
				} //if distance
				else if(Float:distancefrompoint >= Float:range / 4) {
					printf("dist: range/4 text: %s", string);
					SendClientMessage(targetid, COLOR_GRAD5, string);
				} //if distance
				else {
					printf("dist: else or bug text: %s", string);
					SendClientMessage(targetid, COLOR_GRAD5, string);
				}
			} //if inrange
		}//if virtualworld
	} //foreach
	return 1;
}
stock SendLocalMeMessage(playerid, string[]) {
	if(strlen(string) > 127) {
		SendClientMessage(playerid, COLOR_RED, "B£¥D: Wiadomoœæ jest za d³uga!");
		return 0;
	}
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, Float:x, Float:y, Float:z);
	foreach(Player, targetid) {
		if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) {
			if(IsPlayerInRangeOfPoint(targetid, 25.0, Float:x, Float:y, Float:z)) {
				format(string, 128, "* %s %s", pName(playerid), string);
				SendClientMessage(targetid, COLOR_ME, string);
			} //if inrange
		} //if virtualworld
	} //foreach
	return 1;
}
stock SendLocalDoMessage(playerid, string[]) {
	if(strlen(string) > 127) {
		SendClientMessage(playerid, COLOR_RED, "B£¥D: Wiadomoœæ jest za d³uga!");
		return 0;
	}
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, Float:x, Float:y, Float:z);
	foreach(Player, targetid) {
		if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) {
			if(IsPlayerInRangeOfPoint(targetid, 30.0, Float:x, Float:y, Float:z)) {
				format(string, 128, "* %s((%s))", string, pName(playerid));
				SendClientMessage(targetid, COLOR_DO, string);
			} //if range
		}// if vw
	} //foreach
	return 1;
}

forward AdminWarning(color,const string[]);
public AdminWarning(color,const string[])
{
	foreach(new i : Player)
	{
		if(IsPlayerAdminLevel(i, 1))
		{
			SendClientMessage(i, color, string);
		}
	}
	return 1;
}

stock ActionMe(playerid, text[])
{
	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	
	foreach(new targetid : Player)
	{
		if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid))
		{
			if(IsPlayerInRangeOfPoint(targetid, 25.0, pos[0], pos[1], pos[2]))
			{
				SendClientMessage(targetid, -1, text);
			}
		}
	}
	return 1;
}

forward MYSQL_Load3dtext();
public MYSQL_Load3dtext()
{
	if(!cache_num_rows())
		return printf("Nie odnaleziono 3dtext w bazie");
	
	new temp[128];
	
	for(new x = 0; x < cache_num_rows(); x++)
	{
		cache_get_value(x, 0, temp);
		LabelCache[x][tUID] = strval(temp);
		
		cache_get_value(x, 1, temp);
		format(LabelCache[x][tText], 64, temp);
		
		cache_get_value(x, 2, temp);
		format(LabelCache[x][tColor], 64, temp);
		
		cache_get_value(x, 3, temp);
		LabelCache[x][tPos][0] = floatstr(temp);
		
		cache_get_value(x, 4, temp);
		LabelCache[x][tPos][1] = floatstr(temp);
		
		cache_get_value(x, 5, temp);
		LabelCache[x][tPos][2] = floatstr(temp);
		
		Iter_Add(Text3DLabel, x);
		
		format(temp, sizeof(temp), "{%s}%s", LabelCache[x][tColor], LabelCache[x][tText]);
		
		LabelCache[x][tID] = CreateDynamic3DTextLabel(temp, -1, LabelCache[x][tPos][0], LabelCache[x][tPos][1], LabelCache[x][tPos][2], 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
	}
	printf("Pomyslnie wczytano %d 3dtextow na serwer", cache_num_rows());
	return 1;
}


//TEXDRAWY1!!!

/*
//POKAZ/UKRYJ
TextDrawShowForPlayer(playerid, textdraw_0); //Pokazuje TextDraw graczowi.
TextDrawShowForAll(textdraw_0); //Pokazuje TextDraw wszystkim.

TextDrawHideForPlayer(playerid, textdraw_0); //Ukrywa TextDraw graczowi.
TextDrawHideForAll(textdraw_0); //Ukrywa TextDraw wszystkim.

PlayerTextDrawShow(playerid, textdraw_0[playerid]); //Pokazuje PlayerTextDraw graczowi.
PlayerTextDrawHide(playerid, textdraw_0[playerid]); //Ukrywa PlayerTextDraw graczowi.*/

