//define.pwn

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define WERSJA "v1.1"
#define NAZWA "santosProject"
#define DNAZWA "{f9cc00}santosProject{ffffff}"

#if defined MAX_PLAYERS
	#undef MAX_PLAYERS
#endif
#define MAX_PLAYERS 100

#define LOG_DIR_CHAT 			"/logs/chat.log"
#define LOG_DIR_FACTION	 	"/logs/faction.log"
#define LOG_DIR_ADMIN 			"/logs/faction.log"
#define LOG_DIR_VEHICLE 		"/logs/vehicles.log"
#define LOG_DIR_LOGIN			"/logs/login.log"

	
// ------------------------------------------------------------------------------------------
//			------------------------------ FRAKCJE ------------------------------
// ------------------------------------------------------------------------------------------

#define MAX_FACTIONS  11 		//NIE ZMIENIAÆ, JEDEN SLOT DODATKOWY BO SIÊ BUGUJE

#define FACTION_NONE 		0
#define FACTION_POLICE 	1
#define FACTION_MEDIC 		2
#define FACTION_CLEAR		3
#define FACTION_CRIME		4
#define FACTION_RADIO 		5


// ------------------------------------------------------------------------------------------
//			------------------------------ PRACE ------------------------------
// ------------------------------------------------------------------------------------------

#define JOB_NONE 0
#define JOB_MGRASS 1

// ------------------------------------------------------------------------------------------
//			------------------------------ MYSQL ------------------------------
// ------------------------------------------------------------------------------------------

new MySQL: Database, Corrupt_Check[MAX_PLAYERS], Logged[MAX_PLAYERS], loginAttempts[MAX_PLAYERS] = 3;

#define STARTING_MONEY 					250
#define STARTING_GAMESCORE 		0
#define STARTING_SKIN						8
#define MONEY_PER_HOUR				100
#define GAMESCORE_PER_HOUR		10

new Iterator:Text3DLabel<MAX_3DTEXT_GLOBAL>;


// ------------------------------------------------------------------------------------------
//			------------------------------ RADIO ------------------------------
// ------------------------------------------------------------------------------------------

#define BW_TIME 		15000
#define RADIO_DIALOG 443
#define R_OFF ""
#define R_RMF "http://www.rmfon.pl/n/rmffm.pls"
#define R_RMXX "http://www.rmfon.pl/n/rmfmaxxx.pls"
#define R_PARTY "http://www.radioparty.pl/play/glowny_64.m3u"
#define R_OPENFM "http://gr-relay-1.gaduradio.pl/2"

//inne
#define CGLOBAL "{42b9f4}[G]{ffffff}"
//lwiadom
#define LTIME 90000

//prace
#define JOB_NONE 		0
#define JOB_MECHANIC 	1
#define JOB_ROADHELP 	2
	
//dialogi
#define DIALOG_LOGIN 				1
#define DIALOG_REGISTER 				2
#define DIALOG_STATS 				3

#define DIALOG_FACTION_PANEL 			500
#define DIALOG_FACTION_CHANGENAME 		501
#define DIALOG_FACTION_CHANGESPAWN 		502
#define DIALOG_FACTION_MEMBERLIST 		503
#define DIALOG_FACTION_CHANGEMOTD 		504
#define BW_DIALOG						874
#define INFO_JOB_DIALOG 				594

#define DIALOG_JOB_GRASS 				395

#define DIALOG_DESC 					821
#define DIALOG_ANIMACJE 				932

// ------------------------------------------------------------------------------------------
//	------------------------------ POJAZDY ------------------------------
// ------------------------------------------------------------------------------------------

#define MAX_VEHICLES_EX 2137 // maksymalna ilosc pojazdow w bazie danych (dalem na razie byle jaka liczbe)

new Iterator:Vehicles<MAX_VEHICLES_EX>;

#define OWNER_PUBLIC 3
#define OWNER_FACTION 2
#define OWNER_PLAYER 1

#define SAVE_VEHICLE_ALL 1
#define SAVE_VEHICLE_SPAWNPOS 2

new C_STRING[256], Time, bool:CP_TRACE_VEHICLE[MAX_PLAYERS];

#define DIALOG_SHOW_PLAYER_VEHICLES 997 // id dialogu odpowiadajemu /v lista
#define DIALOG_SHOW_MENU_VEHICLE 998 // id dialogu odpowiadajemu panelowi pojazdu
#define DIALOG_SHOW_PLAYER_VEHICLES_TRA 999 // id dialogu odpowiadajcemu /v namierz
#define DIALOG_EDIT_VEHICLE 996
#define DIALOG_VEHICLE_SET_DESCRIPTION 995 // /v opis

#define VEHICLE_SPAWNED 1
#define VEHICLE_NO_SPAWNED 0
#define SAVE_VEHICLE_HEALTH 3

new Float:MaxSpeedVehicle[] = 
{
	{160.0}, {160.0}, {200.0}, {120.0}, {150.0}, {165.0}, {110.0}, {170.0}, {110.0}, {180.0}, // od landstalkera do stretch (lacznie z nim)
	{160.0}, {240.0}, {160.0}, {160.0}, {140.0}, {230.0}, {155.0}, {150.0}, {160.0}, {180.0}, // od manany do taxi (lacznie z nim)
	{180.0}, {165.0}, {145.0}, {170.0}, {200.0}, {170.0}, {170.0}, {200.0}, {130.0}, {80.0},  // od washington do rhino (lacznie z nim)
	{180.0}, {200.0}, {120.0}, {160.0}, {160.0}, {160.0}, {160.0}, {160.0}, {75.0}, {150.0},  // od barracks do romero (lacznie z nim)
	{150.0}, {110.0}, {165.0}, {150.0}, {140.0}, {120.0}, {240.0}, {140.0}, {160.0}, {160.0}, // od packer do golfcraft (lacznie z nim)
	{165.0}, {160.0}, {160.0}, {160.0}, {170.0}, {160.0}, {160.0}, {200.0}, {150.0}, {165.0}, // od solair do regina (lacznie z nim)
};

new Float:Compressor[][] = 
{
	{542.1438, -1293.3125, 17.2422}, {664.5994, -583.5781, 16.3359}
};

#define COMPRESSOR_MONEY 5

// ------------------------------------------------------------------------------------------
//		------------------------------ DRZWI ------------------------------
// ------------------------------------------------------------------------------------------

#define MAX_DOORS 1000

new Iterator:Doors<MAX_DOORS>;

#define DIALOG_DOOR_INFO 6001


// ------------------------------------------------------------------------------------------
//	------------------------------ ENUM ------------------------------
// ------------------------------------------------------------------------------------------

enum playerInfo 
{
	UID,
	Password[65],
	Salt[11],
	IP[32],
	AdminLevel,
	Score,
	Money,
	Skin,
	Hours,
	Minutes,
	Job,
	Faction,
	FactionLeader,
	FactionRank,
	PrawoJazdy,
	Dowod,
	AntyDM,
	Float:SpecPos[4],
	Float:BWPos[4],
	Cache: PlayerCache,
	Text3D:Player3DText,
	Cuffs
};
new pInfo[MAX_PLAYERS][playerInfo];

enum factionInfo 
{
	Name[64],
	UID,
	Float:spawnX,
	Float:spawnY,
	Float:spawnZ,
	Motd[64],
	Cache:Cache
};
new fInfo[MAX_FACTIONS][factionInfo];
enum factionRank 
{
	rank0[64],
	rank1[64],
	rank2[64],
	rank3[64],
	rank4[64],
	rank5[64],
	rank6[64],
	rank7[64],
	rank8[64],
	rank9[64]
};
new fRank[100][factionRank];


enum Vehicle
{
	vUID,
	vType,
	vOwner,
	vColor[2],
	vModel,
	Float:vSpawnPos[3],
	Float:vRotation,
	vLocked,
	vFuel,
	Float:vHP,
	Float:vCourse,
	vTuning[5], // co
	vName[41],
	vRankNumber,
	vVisual[5],
	vCB,
	vSpawned,
	vID,
	Text3D:vDescription,
	vObjects[2]
};
new VehicleCache[MAX_VEHICLES_EX][Vehicle];

enum Text3DLabels
{
	tUID,
	tText[64],
	tColor[64],
	Float:tPos[3],
	Text3D:tID
};
new LabelCache[MAX_3DTEXT_GLOBAL][Text3DLabels];


enum doorInfo
{
	Name[64],
	UID,
	Float:entPos[3],
	entVw,
	entIntID,
	Float:intPos[3],
	intVw,
	intIntID,
	ownerUID,
	factionProperty,
	bool:closed
};
new dInfo[MAX_DOORS][doorInfo]; 
/*
enum Trailer {
	goodsType,
	goodsWeight,
	distanceDriven,
	jobPay
}
new trailerInfo[MAX_VEHICLES][Trailer];
*/


// ------------------------------------------------------------------------------------------
//	     ------------------------------ ZMIENNE ------------------------------
// ------------------------------------------------------------------------------------------

new playerTimer[MAX_PLAYERS];
new updateTimer[MAX_PLAYERS];
new Text:textdraw_0; //URBANTRUCK
new Text:TDEditor_TD[1]; //onduty
new PlayerText:textdraw_1[MAX_PLAYERS]; //INFORMACJE
new PlayerText:textdraw_2[MAX_PLAYERS];//aby odpalic kliknij y
new PlayerText:textdraw_3[MAX_PLAYERS]; //box pod informacje
new bool:flying[MAX_PLAYERS]; //flymode
new Cache:banCache[MAX_PLAYERS];
new bool:CJob1[MAX_PLAYERS]; //praca koszenia trawy, funkcja pod wy³aczanie czekpointu
new Text3D:Opis[MAX_PLAYERS];
new CuffsTimer[MAX_PLAYERS];
new radioChannel[MAX_PLAYERS];

new bool:pntly; 
new Text:Kary, OffPenalty;
new hours, minutes;
//-----------------------------------


//Zmienne globalne do obiektów

new fdgate1, fdgate2, fdgate3;
