//vehicle.inc


// ------------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------------- //
// ------------------------- Callbacki i funkcje do samochodów ------------------------- //
// ------------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------------- //

#define MAX_PETROL_STATION 15

new Iterator:PetrolStations<MAX_PETROL_STATION>;

enum Petrol
{
	pUID,
	Float:pPos[3],
	pFuelState,
	pFuelStateMax,
	pVW,
	pInt,
	pNameStation[24],
	Text3D:pText,
	pColor[8]
};
new PetrolCache[MAX_PETROL_STATION][Petrol];

#define MAX_VEHICLE_FUEL 100
#define MONEY_LITER_FUEL 5

#define DIALOG_SALON_SELECT_CLASS 994
#define DIALOG_DELETE_PETROL 993

#define VEHICLE_OBJECT_POLICELIGHT 0

#define MAX_PLAYER_VEHICLES 10

// Klasy pojazdóww 

new VehiclesOfClassStandard[][] = // MODEL | COST | MAX SPEED | NAZWA | CLASS 
{
	{400, 90000, 160, "Landstalker", 0}, {401, 65000, 160, "Bravura", 0}, {404, 30000, 140, "Perenniel", 0}
};

enum SalonVehicle
{
	sIndex,
	sClass,
	sVID,
	Text3D:sLabel
};
new SalonVeh[MAX_PLAYERS][SalonVehicle];

new bool:IsPlayerLookingVehicle[MAX_PLAYERS];

#define CLASS_VEHICLE_STANDARD 0
#define CLASS_VEHICLE_VAN 1
#define CLASS_VEHICLE_LUXURY 2 
#define CLASS_VEHICLE_WHEELERS 3
#define CLASS_VEHICLE_FLY 4 
#define CLASS_VEHICLE_SHIPS 5 
#define CLASS_VEHICLE_SPORTS 6

forward OnLoadVehicles();

/* --- SOCKETY NIE ODBLOKOWYWAC NA RAZIE!!!! ---
LogVehicle(playerid, vehicleid, actionid)
{
	HTTP(playerid, HTTP_POST, "", "", "");
}
*/

LoadVehicles()
{
	mysql_tquery(Database, "SELECT * FROM `vehicles`", "OnLoadVehicles");
	
	Time = GetTickCount();
}

LoadPetrolStations()
{
	mysql_tquery(Database, "SELECT * FROM `petrol_stations`", "OnLoadPetrolStations");
	
	Time = GetTickCount();
}

public OnLoadVehicles()
{
	if(!cache_num_rows())
		return printf("\tLOAD_INFO: Za³adowano pojazdy na serwer! Czas: %dms", GetTickCount() - Time);
	
	new temp[40];
	
	for(new x = 0; x < cache_num_rows(); x++)
	{
		cache_get_value(x, 0, temp);
		VehicleCache[x][vUID] = strval(temp);
		
		cache_get_value(x, 1, temp);
		VehicleCache[x][vType] = strval(temp);
		
		cache_get_value(x, 2, temp);
		VehicleCache[x][vOwner] = strval(temp);
		
		cache_get_value(x, 3, temp);
		VehicleCache[x][vColor][0] = strval(temp);
		
		cache_get_value(x, 4, temp);
		VehicleCache[x][vColor][1] = strval(temp);
		
		cache_get_value(x, 5, temp);
		VehicleCache[x][vModel] = strval(temp);
		
		cache_get_value(x, 6, temp);
		VehicleCache[x][vSpawnPos][0] = floatstr(temp);
		
		cache_get_value(x, 7, temp);
		VehicleCache[x][vSpawnPos][1] = floatstr(temp);
		
		cache_get_value(x, 8, temp);
		VehicleCache[x][vSpawnPos][2] = floatstr(temp);
		
		cache_get_value(x, 9, temp);
		VehicleCache[x][vRotation] = floatstr(temp);
		
		cache_get_value(x, 10, temp);
		VehicleCache[x][vLocked] = strval(temp);
		
		cache_get_value(x, 11, temp);
		VehicleCache[x][vFuel] = strval(temp);
		
		cache_get_value(x, 12, temp);
		VehicleCache[x][vHP] = floatstr(temp);
		
		cache_get_value(x, 13, temp);
		VehicleCache[x][vCourse] = floatstr(temp);
		
		cache_get_value(x, 14, temp);
		VehicleCache[x][vTuning][0] = strval(temp);
		
		cache_get_value(x, 15, temp);
		VehicleCache[x][vTuning][1] = strval(temp);
		
		cache_get_value(x, 16, temp);
		VehicleCache[x][vTuning][2] = strval(temp);
		
		cache_get_value(x, 17, temp);
		VehicleCache[x][vTuning][3] = strval(temp);
		
		cache_get_value(x, 18, temp);
		format(VehicleCache[x][vName], 41, temp);
		
		cache_get_value(x, 19, temp);
		VehicleCache[x][vRankNumber] = strval(temp);
		
		cache_get_value(x, 20, temp);
		VehicleCache[x][vVisual][0] = strval(temp);
		
		cache_get_value(x, 21, temp);
		VehicleCache[x][vVisual][1] = strval(temp);
		
		cache_get_value(x, 22, temp);
		VehicleCache[x][vVisual][2] = strval(temp);
		
		cache_get_value(x, 23, temp);
		VehicleCache[x][vVisual][3] = strval(temp);
		
		cache_get_value(x, 24, temp);
		VehicleCache[x][vCB] = strval(temp);
		
		// potem dokoncze xD
		
		Iter_Add(Vehicles, x);
		
		if(VehicleCache[x][vType] == OWNER_FACTION)
			SpawnVehicle(VehicleCache[x][vUID]);
	}
	
	printf("\tLOAD_INFO: Za³adowano pojazdy na serwer! Czas: %dms", GetTickCount() - Time);
	return true;
}

forward OnLoadPetrolStations();
public OnLoadPetrolStations()
{
	if(!cache_num_rows())
		return printf("\tLOAD_INFO: Za³adowano stacje na serwer! Czas: %dms", GetTickCount() - Time);
	
	new temp[40];
	
	for(new x = 0; x < cache_num_rows(); x++)
	{
		cache_get_value(x, 0, temp);
		PetrolCache[x][pUID] = strval(temp);
		
		cache_get_value(x, 1, temp);
		PetrolCache[x][pPos][0] = floatstr(temp);
		
		cache_get_value(x, 2, temp);
		PetrolCache[x][pPos][1] = floatstr(temp);
		
		cache_get_value(x, 3, temp);
		PetrolCache[x][pPos][2] = floatstr(temp);
		
		cache_get_value(x, 4, temp);
		PetrolCache[x][pFuelState] = strval(temp);
		
		cache_get_value(x, 5, temp);
		PetrolCache[x][pFuelStateMax] = strval(temp);
		
		cache_get_value(x, 6, temp);
		PetrolCache[x][pVW] = strval(temp);
		
		cache_get_value(x, 7, temp);
		PetrolCache[x][pInt] = strval(temp);
		
		cache_get_value(x, 8, temp);
		format(PetrolCache[x][pNameStation], 24, temp);
		
		cache_get_value(x, 9, temp);
		format(PetrolCache[x][pColor], 24, temp);
		
		Iter_Add(PetrolStations, x);
		
		format(C_STRING, sizeof(C_STRING), "{%s}Stacja paliw %s \n{FFFFFF}Stan stacji: %d/%d litrów paliwa \nU¿yj /tankuj aby zatankowaæ pojazd!", PetrolCache[x][pColor], PetrolCache[x][pNameStation], PetrolCache[x][pFuelState], PetrolCache[x][pFuelStateMax]);
		PetrolCache[x][pText] = CreateDynamic3DTextLabel(C_STRING, -1, PetrolCache[x][pPos][0], PetrolCache[x][pPos][1], PetrolCache[x][pPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PetrolCache[x][pVW], PetrolCache[x][pInt]);
	}
	
	printf("\tLOAD_INFO: Zaladowano stacje na serwer! Czas: %dms", GetTickCount() - Time);
	return true;
}

ShowPlayerVehicles(playerid)
{
	C_STRING = "";
	
	new list;
	
	foreach(new x : Vehicles)
	{
		if(VehicleCache[x][vType] == OWNER_PLAYER)
		{
			if(VehicleCache[x][vOwner] == pInfo[playerid][UID])
			{
				format(C_STRING, sizeof(C_STRING), "%s\n%d\t\t%s", C_STRING, VehicleCache[x][vUID], VehicleCache[x][vName]);
				list++;
			}
		}
	}
	
	if(list != 0)
	{
		ShowPlayerDialog(playerid, DIALOG_SHOW_PLAYER_VEHICLES, DIALOG_STYLE_LIST, DNAZWA " {ffffff}- Twoje pojazdy", C_STRING, "(Un)spawn", "Zamknij");
	}
	else 
	{
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie posiadasz pojazdów! Udaj siê do salonu aby zakupiæ pojazd!", "Zamknij", "");
	}
}

GetVehicleSpecialID(uid)
{
	new vehid = 0;
	
	foreach(new y : Vehicles)
	{
		if(VehicleCache[y][vUID] == uid)
		{
			vehid = y;
			break;
		}
	}
	
	return vehid;
}

UnspawnVehicle(uid)
{
	new vehid = GetVehicleSpecialID(uid);
	
	VehicleCache[vehid][vSpawned] = VEHICLE_NO_SPAWNED;
	
	DestroyVehicle(VehicleCache[vehid][vID]);
	
	VehicleCache[vehid][vID] = INVALID_VEHICLE_ID;
}

SpawnVehicle(uid)
{
	new vehid = GetVehicleSpecialID(uid);
	
	VehicleCache[vehid][vSpawned] = VEHICLE_SPAWNED;
	
	VehicleCache[vehid][vID] = CreateVehicle(VehicleCache[vehid][vModel], VehicleCache[vehid][vSpawnPos][0], VehicleCache[vehid][vSpawnPos][1], VehicleCache[vehid][vSpawnPos][2], VehicleCache[vehid][vRotation], VehicleCache[vehid][vColor][0], VehicleCache[vehid][vColor][1], -1);
	
	VehicleCache[vehid][vLocked] = 1;
	
	SetVehicleParamsEx(VehicleCache[vehid][vID], 0, 0, 0, 0, 0, 0, 0);
	
	for(new x = 0; x < 5; x++)
	{
		if(VehicleCache[vehid][vTuning][x] != 0)
			AddVehicleComponent(VehicleCache[vehid][vID], VehicleCache[vehid][vTuning][x]);
	}
	
	UpdateVehicleDamageStatus(VehicleCache[vehid][vID], VehicleCache[vehid][vVisual][0], VehicleCache[vehid][vVisual][1], VehicleCache[vehid][vVisual][2], VehicleCache[vehid][vVisual][3]);
}

SaveVehicle(uid, type)
{
	new vehid = GetVehicleSpecialID(uid);
	new DB_Query[400], STRINGG[782];
	
	
	if(type == SAVE_VEHICLE_ALL)
	{
		new Float:health;
		GetVehicleHealth(VehicleCache[vehid][vID], health);
		
		if(health != VehicleCache[vehid][vHP]) {
			format(C_STRING, sizeof(C_STRING), "Pojazd %s (UID: %d | OWNER: %d) wedlug zmiennej ma %.2f hp, a wedlug serwera %.2f! Sprawdzic go!", VehicleCache[vehid][vName], VehicleCache[vehid][vUID], VehicleCache[vehid][vOwner], VehicleCache[vehid][vHP], health);
			Log("/logs/vehicles.log", C_STRING); }
		
		GetVehicleDamageStatus(VehicleCache[vehid][vID], VehicleCache[vehid][vVisual][0], VehicleCache[vehid][vVisual][1], VehicleCache[vehid][vVisual][2], VehicleCache[vehid][vVisual][3]);
		
		mysql_format(Database, DB_Query, sizeof(DB_Query), "UPDATE `vehicles` SET `type` = '%d', `owner` = '%d', `color_first` = '%d', `color_second` = '%d', `model` = '%d', `spawnpos_x` = '%.f', `spawnpos_y` = '%.f', `spawnpos_z` = '%.f', `rotation` = '%f', `locked` = '%d', `fuel` = '%d', `hp` = '%f', `course` = '%f', `tuningmod_first` = '%d', `tuningmod_second` = '%d',",
		VehicleCache[vehid][vType], VehicleCache[vehid][vOwner], VehicleCache[vehid][vColor][0], VehicleCache[vehid][vColor][1], VehicleCache[vehid][vModel], VehicleCache[vehid][vSpawnPos][0], VehicleCache[vehid][vSpawnPos][1], VehicleCache[vehid][vSpawnPos][2], VehicleCache[vehid][vRotation], VehicleCache[vehid][vLocked], VehicleCache[vehid][vFuel], VehicleCache[vehid][vHP],
		VehicleCache[vehid][vCourse], VehicleCache[vehid][vTuning][0], VehicleCache[vehid][vTuning][1]);
		
		format(STRINGG, sizeof(STRINGG), "%s `tuningmod_third` = '%d', `tuningmod_fourth` = '%d', `name`= '%s', `rank` = '%d', `visual_panels` = '%d', `visual_doors` = '%d', `visual_lights` = '%d', `visual_tires` = '%d', `cb` = '%d' WHERE `uid` = '%d'", DB_Query,
		VehicleCache[vehid][vTuning][2], VehicleCache[vehid][vTuning][3], VehicleCache[vehid][vName], VehicleCache[vehid][vRankNumber], VehicleCache[vehid][vVisual][0], VehicleCache[vehid][vVisual][1], VehicleCache[vehid][vVisual][2], VehicleCache[vehid][vVisual][3], VehicleCache[vehid][vCB]);
		
		
		mysql_tquery(Database, STRINGG);
	}
	else if(type == SAVE_VEHICLE_SPAWNPOS)
	{
		GetVehiclePos(VehicleCache[vehid][vID], VehicleCache[vehid][vSpawnPos][0], VehicleCache[vehid][vSpawnPos][1], VehicleCache[vehid][vSpawnPos][2]);
		GetVehicleZAngle(VehicleCache[vehid][vID], VehicleCache[vehid][vRotation]);
		
		mysql_format(Database, DB_Query, sizeof(DB_Query), "UPDATE `vehicles` SET `spawnpos_x` = '%f', `spawnpos_y` = '%f', `spawnpos_z` = '%f', `rotation` = '%f' WHERE `uid` = '%d'", VehicleCache[vehid][vSpawnPos][0], VehicleCache[vehid][vSpawnPos][1], VehicleCache[vehid][vSpawnPos][2], VehicleCache[vehid][vRotation], uid);
		mysql_tquery(Database, DB_Query);
	}
	else if(type == SAVE_VEHICLE_HEALTH)
	{
		new Float:health;
		
		GetVehicleHealth(VehicleCache[vehid][vID], health);
		
		if(health != VehicleCache[vehid][vHP])
		{
			printf("[ANTYCHEAT][ANTI-HP] Pojazd gracza o UID: %d o nazwie %s (UID: %d) ma inne hp niz zmienna!", VehicleCache[vehid][vOwner], VehicleCache[vehid][vName], VehicleCache[vehid][vUID]);
		}
		
		VehicleCache[vehid][vHP] = health;
	
		mysql_format(Database, DB_Query, sizeof(DB_Query), "UPDATE `vehicles` SET `hp` = '%f' WHERE `uid` = '%d'", health, uid);
		mysql_tquery(Database, DB_Query);
	}
}

UpdateVehicleParamsEx(vehid, params)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	
	GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective);
	
	if(params == 0)
	{
		if(engine == 0) {
			SetVehicleParamsEx(vehid, 1, lights, alarm, doors, bonnet, boot, objective); } // odpalamy silniczek
		
		if(engine == 1) {
			SetVehicleParamsEx(vehid, 0, lights, alarm, doors, bonnet, boot, objective); } // gasimy silniczek
	}
	else if(params == 1)
	{
		if(lights == 0) {
			SetVehicleParamsEx(vehid, engine, 1, alarm, doors, bonnet, boot, objective); } // odpalamy swiatelka
			
		if(lights == 1) {
			SetVehicleParamsEx(vehid, engine, 0, alarm, doors, bonnet, boot, objective); } // gasimy  swiatelka
	}
	else if(params == 2)
	{
		if(boot == 0) {
			SetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, 1, objective); } // otweiramy baga¿niczek
		
		if(boot == 1) {
			SetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, 0, objective); } // zamykamy baga¿niczek
	}
	else if(params == 3)
	{
		if(bonnet == 0) {
			SetVehicleParamsEx(vehid, engine, lights, alarm, doors, 1, boot, objective); } // otweiramy maseczke
		
		if(bonnet == 1) {
			SetVehicleParamsEx(vehid, engine, lights, alarm, doors, 0, boot, objective); } // zamykamy maseczke
	}
	else if(params == 4)
	{
		if(alarm == 0) {
			SetVehicleParamsEx(vehid, engine, lights, 1, doors, bonnet, boot, objective); } // wlaczamy alarm
		
		if(alarm == 1) {
			SetVehicleParamsEx(vehid, engine, lights, 0, doors, bonnet, boot, objective); } // wylaczamy alarm
	}
}

ShowPlayerVehiclesCanToTrace(playerid)
{
	C_STRING = "";
	
	new list;
	
	foreach(new x : Vehicles)
	{
		if(VehicleCache[x][vType] == OWNER_PLAYER)
		{
			if(VehicleCache[x][vOwner] == pInfo[playerid][UID] && VehicleCache[x][vSpawned] != 0)
			{
				format(C_STRING, sizeof(C_STRING), "%s\n%d\t\t%s", C_STRING, VehicleCache[x][vUID], VehicleCache[x][vName]);
				list++;
			}
		}
	}
	
	if(list != 0)
	{
		ShowPlayerDialog(playerid, DIALOG_SHOW_PLAYER_VEHICLES_TRA, DIALOG_STYLE_LIST, DNAZWA " {ffffff}- Namierzanie pojazdow", C_STRING, "Namierz", "Zamknij");
	}
	else 
	{
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie posiadasz ¿adnego pojazdu, którego mo¿esz namierzyæ!", "Zamknij", "");
	}
}

GetVehicleUID(vehicleid)
{
	new uid;
	
	foreach(new x : Vehicles)
	{
		if(VehicleCache[x][vID] == vehicleid)
		{
			uid = VehicleCache[x][vUID];
			break;
		}
	}
	
	return uid;
}

LoadVehicle(uid)
{
	new DB_Query[256];
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT * FROM `vehicles` WHERE `uid` = '%d' LIMIT 1", uid);
	new Cache:result = mysql_query(Database, DB_Query, true);
	
	new x = Iter_Free(Vehicles);
	
	cache_get_value_int(0, "uid", VehicleCache[x][vUID]);
	cache_get_value_int(0, "type", VehicleCache[x][vType]);
	cache_get_value_int(0, "owner", VehicleCache[x][vOwner]);
	cache_get_value_int(0, "color_first", VehicleCache[x][vColor][0]);
	cache_get_value_int(0, "color_second", VehicleCache[x][vColor][1]);
	cache_get_value_int(0, "model", VehicleCache[x][vModel]);
	cache_get_value_float(0, "spawnpos_x", VehicleCache[x][vSpawnPos][0]);
	cache_get_value_float(0, "spawnpos_y", VehicleCache[x][vSpawnPos][1]);
	cache_get_value_float(0, "spawnpos_z", VehicleCache[x][vSpawnPos][2]);
	cache_get_value_float(0, "rotation", VehicleCache[x][vRotation]);
	cache_get_value_int(0, "locked", VehicleCache[x][vLocked]);
	cache_get_value_int(0, "fuel", VehicleCache[x][vFuel]);
	cache_get_value_float(0, "hp", VehicleCache[x][vHP]);
	cache_get_value_float(0, "course", VehicleCache[x][vCourse]);
	cache_get_value_int(0, "tuningmod_first", VehicleCache[x][vTuning][0]);
	cache_get_value_int(0, "tuningmod_second", VehicleCache[x][vTuning][1]);
	cache_get_value_int(0, "tuningmod_third", VehicleCache[x][vTuning][2]);
	cache_get_value_int(0, "tuningmod_fourth", VehicleCache[x][vTuning][3]);
	cache_get_value(0, "name", VehicleCache[x][vName], 41);
	cache_get_value_int(0, "rank", VehicleCache[x][vRankNumber]);
	cache_get_value_int(0, "visual_panels", VehicleCache[x][vVisual][0]);
	cache_get_value_int(0, "visual_doors", VehicleCache[x][vVisual][1]);
	cache_get_value_int(0, "visual_lights", VehicleCache[x][vVisual][2]);
	cache_get_value_int(0, "visual_tires", VehicleCache[x][vVisual][3]);
	cache_get_value_int(0, "cb", VehicleCache[x][vCB]);
	
	Iter_Add(Vehicles, x);
	
	if(VehicleCache[x][vType] == OWNER_FACTION)
		SpawnVehicle(VehicleCache[x][vUID]);
	
	printf("Pomyslnie wczytano pojazd o UID %d...", uid);
	
	cache_delete(result);
}

DeleteVehicle(uid)
{
	// usuniecie danych
	new x = GetVehicleSpecialID(uid), DB_Query[64];
	
	UnspawnVehicle(uid);
	
	format(C_STRING, sizeof(C_STRING), "Pojazd %s (UID: %d | OWNER: %d | TYPE: %d) zostal poprawnie usuniety!", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vOwner], VehicleCache[x][vType]);
	
	VehicleCache[x][vUID] = 0;
	VehicleCache[x][vType] = 0;
	VehicleCache[x][vOwner] = 0;
	VehicleCache[x][vColor][0] = 0;
	VehicleCache[x][vColor][1] = 0;
	VehicleCache[x][vModel] = 0;
	
	VehicleCache[x][vSpawnPos][0] = 0.0;
	VehicleCache[x][vSpawnPos][1] = 0.0;
	VehicleCache[x][vSpawnPos][2] = 0.0;
	VehicleCache[x][vRotation] = 0.0;
	
	VehicleCache[x][vLocked] = 0;
	VehicleCache[x][vFuel] = 0;
	
	VehicleCache[x][vHP] = 0.0;
	VehicleCache[x][vCourse] = 0.0;
	
	for(new y = 0; y < 5; y++)
		VehicleCache[x][vTuning][y] = 0;
	
	VehicleCache[x][vName] = -1;
	VehicleCache[x][vRankNumber] = 0;
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "DELETE FROM `vehicles` WHERE `uid` = '%d' LIMIT 1", uid);
	mysql_tquery(Database, DB_Query);
	
	Iter_Remove(Vehicles, x);
	
	Log("/logs/vehicles.log", C_STRING);
}

CreateVehicleEx(type, owner, color_first, color_second, model, name[], Float:spawnpos_x, Float:spawnpos_y, Float:spawnpos_z, Float:rotation)
{
	new DB_Query[560], uid;
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "INSERT INTO `vehicles` (`type`, `owner`, `color_first`, `color_second`, `model`, `name`, `spawnpos_x`, `spawnpos_y`, `spawnpos_z`, `rotation`) VALUES ('%d', '%d', '%d', '%d', '%d', '%s', '%f', '%f', '%f', '%f')", type, owner, color_first, color_second, model, name, spawnpos_x, spawnpos_y, spawnpos_z, rotation);
	mysql_tquery(Database, DB_Query);
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT `uid` FROM `vehicles` WHERE `type` = '%d' AND `owner` = '%d' AND `name` = '%s' AND `model` = '%d' AND `course` = '0' AND `color_first` = '%d' AND `color_second` = '%d' LIMIT 1", type, owner, name, model, color_first, color_second);
	printf(DB_Query);
	new Cache:result = mysql_query(Database, DB_Query, true);
	
	cache_get_value_int(0, "uid", uid);
	
	LoadVehicle(uid);
	
	cache_delete(result);
}

UpdatePetrolStation(petrolid)
{
	new DB_Query[256];
	format(C_STRING, sizeof(C_STRING), "{%s}Stacja paliw %s \n{FFFFFF}Stan stacji: %d/%d litrów paliwa \nU¿yj /tankuj aby zatankowaæ pojazd!", PetrolCache[petrolid][pColor], PetrolCache[petrolid][pNameStation], PetrolCache[petrolid][pFuelState], PetrolCache[petrolid][pFuelStateMax]);
	UpdateDynamic3DTextLabelText(PetrolCache[petrolid][pText], -1, C_STRING);
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "UPDATE `petrol_stations` SET `fuelstate` = '%d' WHERE `uid` = '%d'", PetrolCache[petrolid][pFuelState], PetrolCache[petrolid][pUID]);
	mysql_tquery(Database, DB_Query);
}

CreatePetrolStation(Float:x, Float:y, Float:z, name[], maxfuelstate, color[])
{
	new DB_Query[256];
	mysql_format(Database, DB_Query, sizeof(DB_Query), "INSERT INTO `petrol_stations` (`posx`, `posy`, `posz`, `fuelstate`, `fuelstatemax`, `vw`, `interior`, `name`, `color`) VALUES ('%f', '%f', '%f', '%d', '%d', '0', '0', '%s', '%s')", x, y, z, maxfuelstate, maxfuelstate, name, color);
	new Cache:result = mysql_query(Database, DB_Query, true);
	new uid = cache_insert_id();
	cache_delete(result);
	
	new petrolid = Iter_Free(PetrolStations);
	
	PetrolCache[petrolid][pUID] = uid;
	PetrolCache[petrolid][pPos][0] = x;
	PetrolCache[petrolid][pPos][1] = y;
	PetrolCache[petrolid][pPos][2] = z;
	PetrolCache[petrolid][pFuelState] = maxfuelstate;
	PetrolCache[petrolid][pFuelStateMax] = maxfuelstate;
	PetrolCache[petrolid][pVW] = 0;
	PetrolCache[petrolid][pInt] = 0;
	format(PetrolCache[petrolid][pNameStation], 24, name);
	format(PetrolCache[petrolid][pColor], 8, color);
	
	format(C_STRING, sizeof(C_STRING), "{%s}Stacja paliw %s \n{FFFFFF}Stan stacji: %d/%d litrów paliwa \nU¿yj /tankuj aby zatankowaæ pojazd!", PetrolCache[petrolid][pColor], PetrolCache[petrolid][pNameStation], PetrolCache[petrolid][pFuelState], PetrolCache[petrolid][pFuelStateMax]);
	PetrolCache[petrolid][pText] = CreateDynamic3DTextLabel(C_STRING, -1, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
}

LookVehiclesOfSalon(playerid, class)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	SetPlayerCameraPos(playerid, -1657.6683, 1210.3528, 21.1563);
	SetPlayerCameraLookAt(playerid, -1649.0459, 1206.8979, 21.1987);
	
	IsPlayerLookingVehicle[playerid] = true;
	
	SetPlayerVirtualWorld(playerid, playerid+200);
	SetPlayerPos(playerid, -1664.8743, 1206.9246, 21.1563);
	TogglePlayerControllable(playerid, false);
	
	if(class == CLASS_VEHICLE_STANDARD)
	{
		SalonVeh[playerid][sVID] = CreateVehicle(VehiclesOfClassStandard[0][0], -1649.0459, 1206.8979, 21.1987, 40.4627, 3, 0, -1, 0);
		SetVehicleVirtualWorld(SalonVeh[playerid][sVID], playerid+200);
		
		SalonVeh[playerid][sIndex] = 0;
		SalonVeh[playerid][sClass] = 0;
		
		format(C_STRING, sizeof(C_STRING), "{33CCCC}%s\n{FFFFFF}\nCena: $%d\nKlasa standardowa\nMaks. prêdkoœæ: %d\nU¿yj /kup aby zakupiæ pojazd", VehiclesOfClassStandard[0][3], VehiclesOfClassStandard[0][1], VehiclesOfClassStandard[0][2]);
		SalonVeh[playerid][sLabel] = CreateDynamic3DTextLabel(C_STRING, -1, 0.0, 0.0, 0.0, 3200.00, INVALID_PLAYER_ID, SalonVeh[playerid][sVID], 0, playerid+200);
	}
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Witaj w salonie aut! U¿yj strzalki w prawo aby siê poruszaæ miêdzy pojazdami!", "Zamknij", "");
	return 1;
}

DestroyPetrolStation(petrolid)
{
	new DB_Query[128];
	
	format(C_STRING, sizeof(C_STRING), "Stacja paliw %s (UID: %d | FUEL: %d | MAX FUEL: %d) zostala poprawnie usunieta", PetrolCache[petrolid][pNameStation], PetrolCache[petrolid][pUID], PetrolCache[petrolid][pFuelState], PetrolCache[petrolid][pFuelStateMax]);
	Log(LOG_DIR_VEHICLE, C_STRING);
	
	DestroyDynamic3DTextLabel(PetrolCache[petrolid][pText]);
	
	PetrolCache[petrolid][pUID] = 0;
	
	for(new x = 0; x < 3; x++)
		PetrolCache[petrolid][pPos][x] = 0.0;
		
	PetrolCache[petrolid][pFuelState] = 0;
	PetrolCache[petrolid][pFuelStateMax] = 0;
	PetrolCache[petrolid][pVW] = 0;
	PetrolCache[petrolid][pInt] = 0;
	
	PetrolCache[petrolid][pNameStation] = -1;
	PetrolCache[petrolid][pColor] = -1;
	
	Iter_Remove(PetrolStations, petrolid);
	
	mysql_format(Database, DB_Query, sizeof(DB_Query), "DELETE FROM `petrol_stations` WHERE `uid` = '%d' LIMIT 1", PetrolCache[petrolid][pUID]);
	mysql_tquery(Database, DB_Query);
}

GetPlayerVehicles(playerid)
{
	new list;
	foreach(new x : Vehicles)
	{
		if(VehicleCache[x][vType] == OWNER_PLAYER && VehicleCache[x][vOwner] == pInfo[playerid][UID])
			list++;
	}
	
	return list;
}

// ------------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------------- //
// ----------------------------- Komendy do samochodów --------------------------------- //
// ------------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------------- //

CMD:avehicle(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000))
		return NoAccessMessage(playerid);
	new model, type, owner, color[2], name[41];
	if(sscanf(params, "iiiiis[41]", model, type, owner, color[0], color[1], name))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /avehicle [MODEL] [TYPE(1-PLAYER/2-FACTION)] [OWNER(UID/FID)] [COLOR] [COLOR] [NAME OF VEHICLE]");
	if(model < 400 || model > 611)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Z³y model pojazdu!");
	if(type < 1 || type > 2)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Z³y type pojazdu!");
		
	new Float:pos[4];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerFacingAngle(playerid, pos[3]);
		
	CreateVehicleEx(type, owner, color[0], color[1], model, name, pos[0], pos[1], pos[2], pos[3]);
	
	format(C_STRING, sizeof(C_STRING), "Pomyœlnie stworzy³eœ pojazd %s (TYPE: %d | OWNER: %d | MODEL: %d)", name, type, owner, model);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
	return 1;
}

CMD:getvehuid(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000)) 
		return NoAccessMessage(playerid);
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /getvehuid [VID]");
	new vid = strval(params);
	if(GetVehicleModel(vid) == 0)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
	
	new x = GetVehicleSpecialID(GetVehicleUID(vid));
	
	format(C_STRING, sizeof(C_STRING), "UID pojazdu %s (VID: %d) to %d UID!", VehicleCache[x][vName], VehicleCache[x][vID], VehicleCache[x][vUID]);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
	return 1;
}

CMD:getvehid(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000))
		return NoAccessMessage(playerid);
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /getvehid [UID]");
	new x = GetVehicleSpecialID(strval(params));
	
	if(VehicleCache[x][vID] == INVALID_VEHICLE_ID) { 
		format(C_STRING, sizeof(C_STRING), "Pojazd %s (UID: %d) nie posiada aktualnie VID.", VehicleCache[x][vName], VehicleCache[x][vUID]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", ""); }
	else if(VehicleCache[x][vID] != INVALID_VEHICLE_ID) {
		format(C_STRING, sizeof(C_STRING), "Pojazd %s (UID: %d) aktualnie posiada %d VID.", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vID]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", ""); }
	return 1;
}

CMD:cbradio(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Musisz byæ w pojeŸdzie aby korzystaæ z CB-Radia!");
	new vehid = GetVehicleUID(GetPlayerVehicleID(playerid));
	new x = GetVehicleSpecialID(vehid);
	
	if(!VehicleCache[x][vCB])
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten pojazd nie posiada zamontowego CB-Radia! Udaj siê do sklepu aby je zakupiæ!");
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /cbradio [Tekst]");
	
	format(C_STRING, sizeof(C_STRING), "%s mówi przez cb-radio: %s", pName(playerid), params);
	
	foreach(new z : Player)
	{
		if(IsPlayerInAnyVehicle(z))
		{
			new vid = GetPlayerVehicleID(z);
			
			new y = GetVehicleSpecialID(GetVehicleUID(vid));
			
			if(GetPlayerVehicleID(z) == VehicleCache[y][vID])
			{
				if(VehicleCache[y][vCB])
				{
					SendClientMessage(z, COLOR_YELLOW, C_STRING);
					continue;
				}
			}
		}
	}
	return 1;
}

CMD:fixveh(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000))
		return NoAccessMessage(playerid);
	new type[7], vehid;
	if(sscanf(params, "s[7]i", type,  vehid))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /fixveh [visual | hp | all] [VID]");
	if(GetVehicleModel(vehid) == 0)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
	
	if(!strcmp(type, "visual", true))
	{
		new x = GetVehicleSpecialID(GetVehicleUID(vehid));
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie naprawiono wygl¹d wizualny pojazdu %s (UID: %d)", VehicleCache[x][vName], VehicleCache[x][vUID]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		VehicleCache[x][vVisual][0] = 0;
		VehicleCache[x][vVisual][1] = 0;
		VehicleCache[x][vVisual][2] = 0;
		VehicleCache[x][vVisual][3] = 0;
		
		UpdateVehicleDamageStatus(VehicleCache[x][vID], 0, 0, 0, 0);
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `visual_panels` = '%d', `visual_doors` = '%d', `visual_lights` = '%d', `visual_tires` = '%d' WHERE `uid` = '%d'", 0, 0, 0, 0, VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "hp", true))
	{
		new x = GetVehicleSpecialID(GetVehicleUID(vehid));
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie nadano pe³n¹ iloœæ ¿ycia pojazdowi %s (UID: %d)", VehicleCache[x][vName], VehicleCache[x][vUID]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		VehicleCache[x][vHP] = 1000.0;
		
		SetVehicleHealth(VehicleCache[x][vID], 1000.0);
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `hp` = '%.2f' WHERE `uid` = '%d'", VehicleCache[x][vHP], VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "all", true))
	{
		new x = GetVehicleSpecialID(GetVehicleUID(vehid));
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie naprawiono wygl¹d wizualny oraz nadano maksymaln¹ iloœæ ¿ycia pojazdowi %s (UID: %d)", VehicleCache[x][vName], VehicleCache[x][vUID]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		VehicleCache[x][vVisual][0] = 0;
		VehicleCache[x][vVisual][1] = 0;
		VehicleCache[x][vVisual][2] = 0;
		VehicleCache[x][vVisual][3] = 0;
		VehicleCache[x][vHP] = 1000.0;
		
		UpdateVehicleDamageStatus(VehicleCache[x][vID], 0, 0, 0, 0);
		SetVehicleHealth(VehicleCache[x][vID], 1000.0);
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `visual_panels` = '%d', `visual_doors` = '%d', `visual_lights` = '%d', `visual_tires` = '%d', `hp` = '%.2f' WHERE `uid` = '%d'", 0, 0, 0, 0, VehicleCache[x][vHP], VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	return 1;
}

CMD:evehicle(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000))
		return NoAccessMessage(playerid);
	new type[32], varchar[32];
	if(sscanf(params, "s[32]S()[32]", type, varchar))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle [type | owner | model | color | hp | zaparkuj | fuel | name | course | tuning | mod | opis]");
	
	new vid, number;
	
	if(!strcmp(type, "type", true))
	{
		if(sscanf(varchar, "ii", vid, number))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle type [VID] [TYPE(1-PLAYER/2-FACTION/3-PUBLIC)]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		if(number > 3 || number < 1)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Z³y type pojazdu!");
		
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zmieni³eœ typ pojazdu %s (UID: %d) z %d na %d!", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vType], number);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff- informacja", C_STRING, "Zamknij", "");
		
		format(C_STRING, sizeof(C_STRING), "Typ pojazdu %s (UID: %d) zosta³ zmieniony z %d na %d!\n", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vType], number);
		Log("/logs/vehicles.log", C_STRING);
		
		VehicleCache[x][vType] = number;
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `type` = '%d' WHERE `uid` = '%d'", number, VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "owner", true))
	{
		if(sscanf(varchar, "ii", vid, number))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle owner [VID] [UID/FID]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "Wlasciciel pojazdu %s (UID: %d) zostal zmieniony z %d na %d!", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vOwner], number);
		Log("/logs/vehicles.log", C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zmieniono w³aœciciela pojazdu %s (UID: %d) z %d na %d!", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vOwner], number);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		VehicleCache[x][vOwner] = number;
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `owner` = '%d' WHERE `uid` = '%d'", number, VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "model", true))
	{
		if(sscanf(varchar, "ii", vid, number))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle model [VID] [MODEL]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		if(number > 611 || number < 400)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Z³y model pojazdu!");
			
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "Model pojazdu %s (UID: %d) zostal zmieniony z %d na %d", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vModel], number);
		Log("/logs/vehicles.log", C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zmieniono model pojazdu %s (UID: %d) z %d na %d.", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vModel], number);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		VehicleCache[x][vModel] = number;
		
		UnspawnVehicle(VehicleCache[x][vUID]);
		SpawnVehicle(VehicleCache[x][vUID]);
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `model` = '%d' WHERE `uid` = '%d'", number, VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "color", true))
	{
		new number_2;
		if(sscanf(varchar, "iii", vid, number, number_2))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle color [VID] [Color] [Color]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "Kolor pojazdu %s (UID: %d) zostal zmieniony z %d %d na %d %d", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vColor][0], VehicleCache[x][vColor][1], number, number_2);
		Log("/logs/vehicles.log", C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zmieniono kolor pojazdu %s (UID: %d) z %d %d na %d %d.", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vColor][0], VehicleCache[x][vColor][1], number, number_2);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA  " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		VehicleCache[x][vColor][0] = number;
		VehicleCache[x][vColor][1] = number_2;
		
		ChangeVehicleColor(VehicleCache[x][vID], VehicleCache[x][vColor][0], VehicleCache[x][vColor][1]);
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `color_first` = '%d', `color_second` = '%d' WHERE `uid` = '%d'", number, number_2, VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "hp", true))
	{
		new Float:health;
		if(sscanf(varchar, "if", vid, health))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle hp [VID] [HP]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
			
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "HP pojazdu %s (UID: %d) zostalo zmienione z %.2f na %.2f!", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vHP], health);
		Log("/logs/vehicles.log", C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zmieniono HP pojazdu %s (UID: %d) z %.2f na %.2f!", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vHP], health);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		VehicleCache[x][vHP] = health;
		
		SetVehicleHealth(VehicleCache[x][vID], health);
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `hp` = '%.2f' WHERE `uid` = '%d'", health, VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "zaparkuj", true))
	{
		if(sscanf(varchar, "i", vid))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle zaparkuj [VID]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "Pozycja spawnu pojazdu %s (UID: %d) zostala zmieniona", VehicleCache[x][vName], VehicleCache[x][vUID]);
		Log("/logs/vehicles.log", C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zmieniono aktualn¹ pozycje spawnu pojazdu %s (UID: %d)", VehicleCache[x][vName], VehicleCache[x][vUID]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		GetVehiclePos(VehicleCache[x][vID], VehicleCache[x][vSpawnPos][0], VehicleCache[x][vSpawnPos][1], VehicleCache[x][vSpawnPos][2]);
		GetPlayerFacingAngle(VehicleCache[x][vID], VehicleCache[x][vRotation]);
		
		SaveVehicle(VehicleCache[x][vUID], SAVE_VEHICLE_SPAWNPOS);
		return 1;
	}
	if(!strcmp(type, "fuel", true))
	{
		if(sscanf(varchar, "ii", vid, number))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle fuel [VID] [PALIWO]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "Paliwo w pojezdzie %s (UID: %d) zostalo zmienione z %d na %d", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vFuel], number);
		Log("/logs/vehicles.log", C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zmieniono iloœæ paliwa w pojeŸdzie %s (UID: %d) z %d na %d.", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vFuel], number);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		VehicleCache[x][vFuel] = number;
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `fuel` = '%d' WHERE `uid` = '%d'", number, VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "name", true))
	{
		new name[41];
		if(sscanf(varchar, "is[41]", vid, name))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle name [VID] [NAME]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "Nazwa pojazdu %s (UID: %d) zostala zmieniona na %s", VehicleCache[x][vName], VehicleCache[x][vUID], name);
		Log("/logs/vehicles.log", C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zmieniono nazwe pojazdu %s (UID: %d) na %s.", VehicleCache[x][vName], VehicleCache[x][vUID], name);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		format(VehicleCache[x][vName], 41, name);
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `name` = '%s' WHERE `uid` = '%d'", name, VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "course", true))
	{
		new Float:course;
		if(sscanf(varchar, "if", vid, course))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle [VID] [COURSE]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "Przebieg w pojezdzie %s (UID: %d) zostal zmieniony z %.2f na %.2f", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vCourse], course);
		Log("/logs/vehicles.log", C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie zmieniono przebieg pojazdu %s (UID: %d) z %.2f na %.2f.", VehicleCache[x][vName], VehicleCache[x][vUID], VehicleCache[x][vCourse], course);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		VehicleCache[x][vCourse] = course;
		
		mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `course` = '%.2f' WHERE `uid` = '%d'", course, VehicleCache[x][vUID]);
		mysql_tquery(Database, C_STRING);
		return 1;
	}
	if(!strcmp(type, "tuning", true))
	{
		new number_2;
		if(sscanf(varchar, "iii", vid, number, number_2))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle tuning [VID] [Slot(1-5)] [ID Component]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		format(C_STRING, sizeof(C_STRING), "W pojezdzie %s (UID: %d) zostal dodany tuning na slot %d, id component %d", VehicleCache[x][vName], VehicleCache[x][vUID], number, number_2);
		Log("/logs/vehicles.log", C_STRING);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie dodano tuning (ID Component: %d) na slot %d w pojeŸdzie %s (UID: %d)", number_2, number, VehicleCache[x][vName], VehicleCache[x][vUID]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		AddVehicleComponent(VehicleCache[x][vID], number_2);
		
		VehicleCache[x][vTuning][number-1] = number_2;
		
		if(number == 1)
			mysql_format(Database, C_STRING, sizeof(C_STRING), "UPDATE `vehicles` SET `tuningmod_first` = '%d' WHERE `uid` = '%d'");
		return 1;
	}
	if(!strcmp(type, "mod", true))
	{
		new stringa[10];
		if(sscanf(varchar, "is[10]", vid, stringa))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle mod [VID] [CB/Immo]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
			
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		if(!strcmp(stringa, "cb", true))
		{
			VehicleCache[x][vCB] = 1;
			return 1;
		}
	}
	if(!strcmp(type, "opis", true))
	{
		new string[128];
		if(sscanf(varchar, "is[128]", vid, string))
			return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /evehicle opis [VID] [OPIS]");
		if(GetVehicleModel(vid) == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		
		new x = GetVehicleSpecialID(GetVehicleUID(vid));
		
		if(IsValidDynamic3DTextLabel(VehicleCache[x][vDescription]))
			UpdateDynamic3DTextLabelText(VehicleCache[x][vDescription], -1, string);
		else if(!IsValidDynamic3DTextLabel(VehicleCache[x][vDescription]))
			VehicleCache[x][vDescription] = CreateDynamic3DTextLabel(string, -1, 0.0, 0.0, 0.0, 5.0, INVALID_PLAYER_ID, vid);
		
		format(C_STRING, sizeof(C_STRING), "Pomyœlnie ustawi³eœ opis pojazdu %s (UID: %d) na %s.", VehicleCache[x][vName], VehicleCache[x][vUID], string);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		
		return 1;
	}
	return 1;
}

CMD:gotoveh(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000))
		return NoAccessMessage(playerid);
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /gotoveh [VID]");
	new vid = strval(params);
	if(GetVehicleModel(vid) == 0)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
	
	new x = GetVehicleSpecialID(GetVehicleUID(vid));
	
	format(C_STRING, sizeof(C_STRING), "Pomyœlnie przeteleportowano do pojazdu %s (UID: %d)", VehicleCache[x][vName], VehicleCache[x][vUID]);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
	
	new Float:pos[3];
	
	GetVehiclePos(VehicleCache[x][vID], pos[0], pos[1], pos[2]);
	
	SetPlayerPos(playerid, pos[0] + 2.0, pos[1] + 2.0, pos[2]);
	return 1;
}

CMD:dvehicle(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000))
		return NoAccessMessage(playerid);
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /dvehicle [UID]");
	new uid = strval(params);
	new vehid = GetVehicleSpecialID(uid);
	if(VehicleCache[vehid][vUID] == 0)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		
	DeleteVehicle(uid);
	
	format(C_STRING, sizeof(C_STRING), "Pomyœlnie usun¹³eœ pojazd %s (UID: %d | OWNER: %d)", VehicleCache[vehid][vName], VehicleCache[vehid][vUID], VehicleCache[vehid][vOwner]);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
	
	format(C_STRING, sizeof(C_STRING), "%s (UID: %d) usunal pojazd %s (UID: %d)", pName(playerid), pInfo[playerid][UID], VehicleCache[vehid][vName], VehicleCache[vehid][vUID]);
	Log("logs/admincmd.log", C_STRING);
	return 1;
}

CMD:tpveh(playerid, params[])
{
	new vehid, idplayer;
	if(sscanf(params, "iu", vehid, idplayer))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /tpveh [VID] [PLAYERID (id do którego pojazd ma zostaæ przywo³any)]");
	
	if(idplayer == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "B£AD: Gracz nie jest po³¹czony!");
	if(vehid == INVALID_VEHICLE_ID)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
	
	new vehicid = GetVehicleSpecialID(GetVehicleUID(vehid));	
	
	if(VehicleCache[vehicid][vSpawned] != VEHICLE_SPAWNED)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
	
	new Float:pos_player[3];
	GetPlayerPos(idplayer, pos_player[0], pos_player[1], pos_player[2]);
	
	SetVehiclePos(VehicleCache[vehicid][vID], pos_player[0] + 2.0, pos_player[1] + 2.0, pos_player[2]);
	
	SetVehicleVirtualWorld(VehicleCache[vehicid][vID], GetPlayerVirtualWorld(idplayer));
	LinkVehicleToInterior(VehicleCache[vehicid][vID], GetPlayerInterior(idplayer));
	
	format(C_STRING, sizeof(C_STRING), "Pomyœlnie przeteleportowa³eœ pojazd %s (UID: %d) do %s (ID: %d)!", VehicleCache[vehicid][vName], VehicleCache[vehicid][vUID], pName(idplayer), idplayer);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
	return 1;
}

CMD:svehicle(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1))
		return NoAccessMessage(playerid);
	new text[10], number;
	if(sscanf(params, "s[10]i", text, number))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /svehicle [spawn | unspawn] [UID]");
	
	new vehid = GetVehicleSpecialID(number);
	
	if(!strcmp(text, "spawn", true))
	{	
		if(VehicleCache[vehid][vUID] == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		if(VehicleCache[vehid][vSpawned] == VEHICLE_SPAWNED)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten pojazd jest ju¿ zespawnowany!");
		
		SpawnVehicle(number);
		
		format(C_STRING, sizeof(C_STRING), "Poprawnie zespawnowa³eœ pojazd %s (UID: %d | OWNER: %d | TYPE: %d)", VehicleCache[vehid][vName], VehicleCache[vehid][vUID], VehicleCache[vehid][vOwner], VehicleCache[vehid][vType]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		format(C_STRING, sizeof(C_STRING), "Pojazd %s (UID: %d) zostal zespawnowany przez administratora %s (UID: %d)", VehicleCache[vehid][vName], VehicleCache[vehid][vUID], pName(playerid), pInfo[playerid][UID]);
		Log(LOG_DIR_VEHICLE, C_STRING);
		return 1;
	}
	if(!strcmp(text, "unspawn", true))
	{
		if(VehicleCache[vehid][vUID] == 0)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
		if(VehicleCache[vehid][vSpawned] == VEHICLE_NO_SPAWNED)
			return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Ten pojazd nie jest zespawnowany!");
		
		UnspawnVehicle(number);
		
		format(C_STRING, sizeof(C_STRING), "Poprawnie odspawnowa³eœ pojazd %s (UID: %d | OWNER: %d | TYPE: %d)", VehicleCache[vehid][vName], VehicleCache[vehid][vUID], VehicleCache[vehid][vOwner], VehicleCache[vehid][vType]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		return 1;
	}
	return 1;
}

CMD:putinveh(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1))
		return NoAccessMessage(playerid);
	new player, vehicle, seatid;
	if(sscanf(params, "uii", player, vehicle, seatid))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /putinveh [ID GRACZA] [VID] [SEATID]");
	if(vehicle == INVALID_VEHICLE_ID)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Taki pojazd nie istnieje!");
	if(seatid < 0 || seatid > 10)
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Z³y SEATID!");
	if(!IsPlayerConnected(player))
		return SendClientMessage(playerid, COLOR_GREY, "B£¥D: Gracz o takim ID nie jest po³¹czony!");
	
	new vehuid = GetVehicleSpecialID(GetVehicleUID(vehicle)), list;
	
	foreach(new x : Player)
	{
		if(IsPlayerInAnyVehicle(x))
		{
			if(GetPlayerVehicleID(x) == vehicle)
			{
				if(GetPlayerVehicleSeat(x) == seatid)
				{
					list++;
					SendClientMessage(playerid, COLOR_GREY, "B£¥D: Jakiœ gracz ju¿ jest na tym miejscu w pojeŸdzie!");
					break;
				}
			}
		}
	}
	
	if(!list){
	PutPlayerInVehicle(player, vehicle, seatid);
	
	format(C_STRING, sizeof(C_STRING), "Pomyœlnie umieœci³eœ %s (ID: %d | UID: %d) w pojeŸdzie %s (VID: %d | UID: %d) na miejscu o nr. %d!", pName(player), player, pInfo[player][UID], VehicleCache[vehuid][vName], vehicle, VehicleCache[vehuid][vUID], seatid);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
	
	format(C_STRING, sizeof(C_STRING), "%s (UID: %d) umiescil %s (UID: %d) w pojezdzie %s (UID: %d) na miejscu o nr. %d", pName(playerid), pInfo[playerid][UID], pName(player), pInfo[player][UID], VehicleCache[vehuid][vName], VehicleCache[vehuid][vUID], seatid);
	Log("/logs/admincmd.log", C_STRING);
	}
	return 1;
}

CMD:getvehinfo(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000))
		return NoAccessMessage(playerid);
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, "U¯YCIE: /getvehinfo [UID]");
	new uid = strval(params);
	
	new vehuid = GetVehicleSpecialID(uid);
	
	new local_string[452];
	
	format(C_STRING, sizeof(C_STRING), "Nazwa\tWartoœæ");
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nUID:\t%d", VehicleCache[vehuid][vUID]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nType:\t%d", VehicleCache[vehuid][vType]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nOwner:\t%d", VehicleCache[vehuid][vOwner]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nColor:\t%d %d", VehicleCache[vehuid][vColor][0], VehicleCache[vehuid][vColor][1]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nModel:\t%d", VehicleCache[vehuid][vModel]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nSpawnPos:\t%.3f, %.3f, %.3f", VehicleCache[vehuid][vSpawnPos][0], VehicleCache[vehuid][vSpawnPos][1], VehicleCache[vehuid][vSpawnPos][2]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nRotation:\t%.2f", VehicleCache[vehuid][vRotation]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nLocked:\t%d", VehicleCache[vehuid][vLocked]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nFuel:\t%d", VehicleCache[vehuid][vFuel]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nHealth:\t%.2f", VehicleCache[vehuid][vHP]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nCourse:\t%.2f", VehicleCache[vehuid][vCourse]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nTuning:\t%d %d %d %d", VehicleCache[vehuid][vTuning][0], VehicleCache[vehuid][vTuning][1], VehicleCache[vehuid][vTuning][2], VehicleCache[vehuid][vTuning][3]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nName:\t%s", VehicleCache[vehuid][vName]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nFaction Rank:\t%d", VehicleCache[vehuid][vRankNumber]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nVisual:\t%d %d %d %d", VehicleCache[vehuid][vVisual][0], VehicleCache[vehuid][vVisual][1], VehicleCache[vehuid][vVisual][2], VehicleCache[vehuid][vVisual][3]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nSpawned:\t%d", VehicleCache[vehuid][vSpawned]);
	strcat(local_string, C_STRING);
	
	format(C_STRING, sizeof(C_STRING), "\nVehicleID:\t%d", VehicleCache[vehuid][vID]);
	strcat(local_string, C_STRING);
	
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, DNAZWA " {ffffff}- informacja o pojeŸdzie", local_string, "Zamknij", "");
	return 1;
}

CMD:v(playerid, params[])
{
	if(isnull(params))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientMessage(playerid, COLOR_GREY, "» U¿yj: /v [lista | namierz | info | zamknij | zaparkuj | opis | dodatki]");
			
		ShowPlayerDialog(playerid, DIALOG_SHOW_MENU_VEHICLE, DIALOG_STYLE_LIST, DNAZWA " {ffffff}- Panel pojazdu", "(1) Odpal/zgaœ silnik\n(2) Zapal/zgaœ œwiat³a\n(3) Otwórz/zamknij baga¿nik\n(4) Otwórz/zamknij maskê\n(5) W³¹cz/wy³¹cz alarm", "Wybierz", "Zamknij");
		return 1;
	}
	
	if(!strcmp(params, "lista", false))
	{
		ShowPlayerVehicles(playerid);
		return 1;
	}
	if(!strcmp(params, "namierz", false))
	{
		ShowPlayerVehiclesCanToTrace(playerid);
		return 1;
	}
	if(!strcmp(params, "info", false)) // w trakcie
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Musisz znajdowaæ siê w pojeŸdzie!", "Zamknij", "");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Musisz byæ kierowc¹!", "Zamknij", "");
		
		new y = GetVehicleUID(GetPlayerVehicleID(playerid));
		new x = GetVehicleSpecialID(y);
		
		new local_string[300];
		
		SendClientMessage(playerid, COLOR_RED, "Jeszcze to robie ok ;-)");
		
		new owner[40];
		
		if(VehicleCache[x][vType] == OWNER_PLAYER)
			format(owner, 40, "Gracz (UID: %d)", VehicleCache[x][vOwner]);
		else if(VehicleCache[x][vType] == OWNER_FACTION)
			format(owner, 40, "Frakcja (FID: %d)", VehicleCache[x][vOwner]);
		else if(VehicleCache[x][vType] == OWNER_PUBLIC)
			format(owner, 40, "Pojazd publiczny");
		
		format(C_STRING, sizeof(C_STRING), DNAZWA " {ffffff}- informacje o pojeŸdzie: %s (UID: %d)", VehicleCache[x][vName], VehicleCache[x][vUID]);
		format(local_string, sizeof(local_string), "Nazwa\tWartoœæ\nUID:\t%d\nModel:\t%d\nKolor pojazdu:\t%d %d\nW³aœciciel:\t%s\n¯ycie pojazdu:\t%.2f\nPrzebieg:\t%.2f\nPaliwo:\t%d", VehicleCache[x][vUID], VehicleCache[x][vModel], VehicleCache[x][vColor][0], VehicleCache[x][vColor][1], owner, VehicleCache[x][vHP], VehicleCache[x][vCourse], VehicleCache[x][vFuel]);
		
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, C_STRING, local_string, "Zamknij", ""); 
		return 1;
	}
	if(!strcmp(params, "zamknij", false))
	{
		new Float:pos_player[3], Float:pos_vehicles[MAX_VEHICLES][3];
		
		GetPlayerPos(playerid, pos_player[0], pos_player[1], pos_player[2]);
		
		foreach(new x : Vehicles)
		{
			if(VehicleCache[x][vSpawned] != 0)
			{
				GetVehiclePos(VehicleCache[x][vID], pos_vehicles[x][0], pos_vehicles[x][1], pos_vehicles[x][2]);
				
				if(IsPlayerInRangeOfPoint(playerid, 5.0, pos_vehicles[x][0], pos_vehicles[x][1], pos_vehicles[x][2]))
				{
					if(VehicleCache[x][vOwner] == pInfo[playerid][UID])
					{
						new engine, lights, alarm, doors, bonnet, boot, objective;
						GetVehicleParamsEx(VehicleCache[x][vID], engine, lights, alarm, doors, bonnet, boot, objective);
						
						if(VehicleCache[x][vLocked] == 0) // Otwarty
						{
							VehicleCache[x][vLocked] = 1;
							
							SetVehicleParamsEx(VehicleCache[x][vID], engine, lights, alarm, 1, bonnet, boot, objective);
							
							GameTextForPlayer(playerid, "Pojazd ~r~zamkniety!", 5000, 5);
							ApplyAnimation(playerid, "INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
							
							format(C_STRING, sizeof(C_STRING), "%s (UID: %d) zamknal pojazd %s (UID: %d)", pName(playerid), pInfo[playerid][UID], VehicleCache[x][vName], VehicleCache[x][vUID]);
							Log(LOG_DIR_VEHICLE, C_STRING);
						}
						else // zamkniety
						{
							VehicleCache[x][vLocked] = 0;
							
							SetVehicleParamsEx(VehicleCache[x][vID], engine, lights, alarm, 0, bonnet, boot, objective);
							
							GameTextForPlayer(playerid, "Pojazd ~g~otwarty!", 5000, 5);
							ApplyAnimation(playerid, "INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
							
							format(C_STRING, sizeof(C_STRING), "%s (UID: %d) otworzyl pojazd %s (UID: %d)", pName(playerid), pInfo[playerid][UID], VehicleCache[x][vName], VehicleCache[x][vUID]);
							Log(LOG_DIR_VEHICLE, C_STRING);
						}
					}
				}
			}
		}
		return 1;
	}
	if(!strcmp(params, "zaparkuj", false))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Musisz znajdowaæ siê w pojeŸdzie!", "Zamknij", "");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- Informacja", "Musisz byæ kierowc¹!", "Zamknij", "");
		
		new uid = GetVehicleUID(GetPlayerVehicleID(playerid));
		
		new vehid = GetVehicleSpecialID(uid);
		
		if(VehicleCache[vehid][vType] == OWNER_FACTION || VehicleCache[vehid][vType] == OWNER_PUBLIC)
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz przeparkowaæ pojazdu podpisanego pod grupe!", "Zamknij", "");
		
		if(pInfo[playerid][UID] != VehicleCache[vehid][vOwner])
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ w³aœcicielem tego pojazdu!", "Zamknij", "");
			
		SaveVehicle(uid, SAVE_VEHICLE_SPAWNPOS);
		
		format(C_STRING, sizeof(C_STRING), "Twój pojazd %s (UID: %d) zosta³ pomyœlnie przeparkowany!", VehicleCache[vehid][vName], VehicleCache[vehid][vUID]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		
		format(C_STRING, sizeof(C_STRING), "%s (UID: %d) przeparkowa³ pojazd %s (UID: %d). Nowy spawn: %.3f %.3f %.3f", pName(playerid), pInfo[playerid][UID], VehicleCache[vehid][vName], VehicleCache[vehid][vUID], VehicleCache[vehid][vSpawnPos][0], VehicleCache[vehid][vSpawnPos][1], VehicleCache[vehid][vSpawnPos][2]);
		Log(LOG_DIR_VEHICLE, C_STRING);
		return 1;
	}
	if(!strcmp(params, "opis", true))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Musisz znajdowaæ siê w pojeŸdzie!", "Zamknij", "");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- Informacja", "Musisz byæ kierowc¹!", "Zamknij", "");
		
		new x = GetVehicleSpecialID(GetVehicleUID(GetPlayerVehicleID(playerid)));
		if(VehicleCache[x][vOwner] != pInfo[playerid][UID] && !IsPlayerAdminLevel(playerid, 1000))
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ w³aœcicielem tego pojazdu!", "Zamknij", "");
		
		
		format(C_STRING, sizeof(C_STRING), "Wpisz poni¿ej opis, który chcesz ustawiæ dla pojazdu %s (UID: %d)", VehicleCache[x][vName], VehicleCache[x][vUID]);
		ShowPlayerDialog(playerid, DIALOG_VEHICLE_SET_DESCRIPTION, DIALOG_STYLE_INPUT, DNAZWA " {ffffff}- informacja", C_STRING, "Ustaw", "Zamknij");
		return 1;
	}
	if(!strcmp(params, "dodatki", true))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Musisz znajdowaæ siê w pojeŸdzie!", "Zamknij", "");
		new x = GetVehicleSpecialID(GetVehicleUID(GetPlayerVehicleID(playerid)));
		if(VehicleCache[x][vOwner] != pInfo[playerid][UID] && !IsPlayerAdminLevel(playerid, 1000))
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ w³aœcicielem tego pojazdu!", "Zamknij", "");
		
		new list;
		
		for(new y = 0; x < 4; x++) {
			if(VehicleCache[x][vTuning][y] == 0) {
				list++; }
		}
		
		if(list == 4 && VehicleCache[x][vCB] == 0)
			return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Ten pojazd nie posiada dodatków!", "Zamknij", "");
		
		
		return 1;
	}
	return 1;
}

CMD:kompresor(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz tego u¿yæ nie bêd¹c w pojeŸdzie!", "Zamknij", "");
	new list;
	for(new x = 0; x < sizeof(Compressor); x++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, Compressor[x][0], Compressor[x][1], Compressor[x][2]))
		{	
			list++;
			new vehid = GetVehicleSpecialID(GetVehicleUID(GetPlayerVehicleID(playerid)));
			
			new engine, lights, alarm, doors, bonnet, boot, objective;
	
			GetVehicleParamsEx(VehicleCache[vehid][vID], engine, lights, alarm, doors, bonnet, boot, objective);
			if(engine == 1)
				return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz napompowaæ opon z zapalonym silnikiem!", "Zamknij", "");
			
			if(VehicleCache[vehid][vType] == OWNER_PLAYER)
			{
				if(VehicleCache[vehid][vOwner] != pInfo[playerid][UID])
					return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ w³aœcicielem pojazdu!", "Zamknij", "");
			}
			
			GetVehicleDamageStatus(VehicleCache[vehid][vID], VehicleCache[vehid][vVisual][0], VehicleCache[vehid][vVisual][1], VehicleCache[vehid][vVisual][2], VehicleCache[vehid][vVisual][3]);
			
			if(VehicleCache[vehid][vVisual][3] == 0)
				return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Ten pojazd nie ma przebitych opon!", "Zamknij", "");
			
			
			new tires;
				
			if(VehicleCache[vehid][vVisual][3] == 1 || VehicleCache[vehid][vVisual][3] == 2 || VehicleCache[vehid][vVisual][3] == 4 || VehicleCache[vehid][vVisual][3] == 8)
				tires = 1;
			if(VehicleCache[vehid][vVisual][3] == 3 || VehicleCache[vehid][vVisual][3] == 5 || VehicleCache[vehid][vVisual][3] == 6 || VehicleCache[vehid][vVisual][3] == 9 || VehicleCache[vehid][vVisual][3] == 10 || VehicleCache[vehid][vVisual][3] == 12)
				tires = 2;
			if(VehicleCache[vehid][vVisual][3] == 7 || VehicleCache[vehid][vVisual][3] == 11 || VehicleCache[vehid][vVisual][3] == 13 || VehicleCache[vehid][vVisual][3] == 14)
				tires = 3;
			if(VehicleCache[vehid][vVisual][3] == 15)
				tires = 4;
			
			new pay = tires * COMPRESSOR_MONEY;
			
			if(pInfo[playerid][Money] < pay)
				return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie posiadasz wystarczaj¹co pieniêdzy!", "Zamknij", "");
			
			AddScriptMoney(playerid, -pay);
			format(C_STRING, sizeof(C_STRING), "Pomyœlnie napompowa³eœ %d opony w %s (UID: %d) za $%d", tires, VehicleCache[vehid][vName], VehicleCache[vehid][vUID], pay);
			UpdateVehicleDamageStatus(VehicleCache[x][vID], VehicleCache[vehid][vVisual][0], VehicleCache[vehid][vVisual][1], VehicleCache[vehid][vVisual][2], 0);
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
		}
	}
	if(list == 0)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ przy kompresorze!", "Zamknij", "");
	return 1;
}

CMD:apetrol(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000))
		return NoAccessMessage(playerid);
	new name[24], maxfuelstate, color[8];
	if(sscanf(params, "s[24]ds[8]", name, maxfuelstate, color))
		return SendClientMessage(playerid, -1, "» U¿yj: /apetrol [Nazwa] [Maksymalna iloœæ paliwa] [Color (HTML)]");
	if(maxfuelstate <= 0)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Maksymalna iloœæ paliwa nie mo¿e byæ ni¿sza od 0!", "Zamknij", "");
	
	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	
	CreatePetrolStation(pos[0], pos[1], pos[2], name, maxfuelstate, color);
	
	format(C_STRING, sizeof(C_STRING), "Pomyœlnie stworzy³eœ stacje paliw {%s}%s {FFFFFF}z maksymaln¹ iloœci¹ paliwa %d", color, name, maxfuelstate);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
	
	format(C_STRING, sizeof(C_STRING), "%s (UID: %d) stworzyl stacje %s z maksymalna iloscia paliwa %d", pName(playerid), pInfo[playerid][UID], name, maxfuelstate);
	Log("/logs/admincmd.log", C_STRING);
	return 1;
}

CMD:dpetrol(playerid, params[])
{
	if(!IsPlayerAdminLevel(playerid, 1000))
		return NoAccessMessage(playerid);
	
	foreach(new x : PetrolStations)
	{
		if(IsPlayerInRangeOfPoint(playerid, 50.0, PetrolCache[x][pPos][0], PetrolCache[x][pPos][1], PetrolCache[x][pPos][2]))
		{
			format(C_STRING, sizeof(C_STRING), "Czy na pewno chcesz usun¹æ stacjê paliw {%s}%s {FFFFFF}(UID: %d)?", PetrolCache[x][pColor], PetrolCache[x][pNameStation], PetrolCache[x][pUID]);
			ShowPlayerDialog(playerid, DIALOG_DELETE_PETROL, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Usuñ", "Anuluj");
			
			SetPVarInt(playerid, "INDEX_PETROL", x);
			SetPVarInt(playerid, "UID_PETROL", PetrolCache[x][pUID]);
			break;
		}
	}
	return 1;
}

CMD:tankuj(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz tego u¿yæ bêd¹c w pojeŸdzie!", "Zamknij", "");
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, "» U¿yj: /tankuj [iloœæ litrów paliwa]");
	if(strval(params) <= 0)
		return SendClientMessage(playerid, COLOR_GREY, "» U¿yj: /tankuj [iloœæ litrów paliwa]");
	
	new fuel = strval(params);
	new list, petrolid;
	
	foreach(new x : PetrolStations)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, PetrolCache[x][pPos][0], PetrolCache[x][pPos][1], PetrolCache[x][pPos][2]))
		{
			if(PetrolCache[x][pFuelState] < fuel)
				return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Ta stacja nie ma tylu litrów na stanie!", "Zamknij", "");
			
			petrolid = x;
			list++;
		}
	}
	
	if(list == 0)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ na stacji paliw!", "Zamknij", "");
	
	new Float:xyz[MAX_VEHICLES_EX][3];
	
	foreach(new v : Vehicles)
	{
		if(VehicleCache[v][vSpawned] == VEHICLE_SPAWNED)
		{
			GetVehiclePos(VehicleCache[v][vID], xyz[v][0], xyz[v][1], xyz[v][2]);
			if(IsPlayerInRangeOfPoint(playerid, 5.0, xyz[v][0], xyz[v][1], xyz[v][2]))
			{
				new engine, lights, alarm, doors, bonnet, boot, objective;
	
				GetVehicleParamsEx(VehicleCache[v][vID], engine, lights, alarm, doors, bonnet, boot, objective);
				if(engine == 1)
					return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie mo¿esz zatankowaæ pojazdu z zapalonym silnikiem!", "Zamknij", "");
				if(VehicleCache[v][vType] == OWNER_PLAYER && VehicleCache[v][vOwner] != pInfo[playerid][UID])
					return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ w³aœcicielem pojazdu!", "Zamknij", "");
				if(VehicleCache[v][vFuel] == MAX_VEHICLE_FUEL)
					return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Bak pojazdu jest pe³ny!", "Zamknij", "");
				if(VehicleCache[v][vFuel] + fuel > MAX_VEHICLE_FUEL) {
					format(C_STRING, sizeof(C_STRING), "Nie mo¿esz nalaæ tyle paliwa do baku, poniewa¿ przekroczy on swoj¹ maks. pojemnoœæ!\nMo¿liwa maksymalna iloœæ paliwa do zape³nienia: %d", VehicleCache[v][vFuel] - MAX_VEHICLE_FUEL);
					return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", ""); }
				
				new pay = fuel * MONEY_LITER_FUEL;
				if(pInfo[playerid][Money] < pay)
					return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie posiadasz wystarczaj¹co pieniêdzy!", "Zamknij", "");
				
				AddScriptMoney(playerid, -pay);
				VehicleCache[v][vFuel] += fuel;
				PetrolCache[petrolid][pFuelState] -= fuel;
				UpdatePetrolStation(petrolid);
				
				format(C_STRING, sizeof(C_STRING), "Pomyœlnie zatankowa³eœ pojazd %s (UID: %d) o %d litrów!\nAktualnie w baku jest %d litrów paliwa.", VehicleCache[v][vName], VehicleCache[v][vUID], fuel, VehicleCache[v][vFuel]);
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", C_STRING, "Zamknij", "");
				
				format(C_STRING, sizeof(C_STRING), "%s (UID: %d) zatankowal pojazd %s (UID: %d) o %d litrow", pName(playerid), pInfo[playerid][UID], VehicleCache[v][vName], VehicleCache[v][vUID], fuel);
				Log(LOG_DIR_VEHICLE, C_STRING);
			}
		}
	}
	return 1;
}

CMD:salon(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 563.7422, -1368.5813, 52.5134))
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie jesteœ przy salonie aut!", "Zamknij", "");
	
	ShowPlayerDialog(playerid, DIALOG_SALON_SELECT_CLASS, DIALOG_STYLE_TABLIST_HEADERS, DNAZWA " {ffffff}- wybierz klasê pojazdu", "Klasa\tIloœæ pojazdów\nStandardowa\t?\nDostawcza\t?\nLuksusowa\t?\nJednoœlady\t?\nLataj¹ca\t?\nStatki wodne\t?\nSportowa\t?", "Zamknij", "");
	return 1;
}

COMMAND:zakup(playerid, params[])
{
	if(IsPlayerLookingVehicle[playerid] == false)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Nie przegl¹dasz pojazdów w salonie!", "Zamknij", "");
	if(GetPlayerVehicles(playerid) >= MAX_PLAYER_VEHICLES)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA " {ffffff}- informacja", "Posiadasz maksymaln¹ iloœæ pojazdów!", "Zamknij", "");
	
	return 1;
}