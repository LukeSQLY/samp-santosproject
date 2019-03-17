//vehicle.inc

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
	printf("Rozpoczynam wczytywanie pojazdow z bazy danych!");
	
	Time = GetTickCount();
}

public OnLoadVehicles()
{
	if(!cache_num_rows())
		return printf("[MYSQL][LOAD VEHICLES] Brak pojazdow w bazie danych...");
	
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
		format(VehicleCache[x][vName], 40, temp);
		
		// potem dokoncze xD
		
		Iter_Add(Vehicles, x);
		
		if(VehicleCache[x][vType] == OWNER_FACTION)
			SpawnVehicle(VehicleCache[x][vUID]);
	}
	
	printf("[MYSQL][LOAD VEHICLES] Wczytano lacznie %d pojazdow w czasie %d ms...", cache_num_rows(), Time - GetTickCount());
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
		ShowPlayerDialog(playerid, DIALOG_SHOW_PLAYER_VEHICLES, DIALOG_STYLE_LIST, "Twoje pojazdy", C_STRING, "(Un)spawn", "Zamknij");
	}
	else 
	{
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacja", "Nie posiadasz pojazdów! Udaj się do salonu aby zakupić pojazd!", "Zamknij", "");
	}
}

GetVehicleSpecialID(uid)
{
	new vehid = 0;
	
	foreach(new y : Vehicles)
	{
		if(VehicleCache[y][vUID] == uid)
		{
			vehid = uid;
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
}

SpawnVehicle(uid)
{
	new vehid = GetVehicleSpecialID(uid);
	
	VehicleCache[vehid][vSpawned] = VEHICLE_SPAWNED;
	
	VehicleCache[vehid][vID] = CreateVehicle(VehicleCache[vehid][vModel], VehicleCache[vehid][vSpawnPos][0], VehicleCache[vehid][vSpawnPos][1], VehicleCache[vehid][vSpawnPos][2], VehicleCache[vehid][vRotation], VehicleCache[vehid][vColor][0], VehicleCache[vehid][vColor][1], -1);
	
	SetVehicleParamsEx(VehicleCache[vehid][vID], 0, 0, 0, 1, 0, 0, 0);
}


// =----------- dialogi ------------


// ------------- cmd -------------

CMD:v(playerid, params[])
{
	if(isnull(params))
		return SendClientMessage(playerid, -1, "» Użyj: /v [lista | namierz | info | zamknij]");
	
	if(!strcmp(params, "lista", false))
	{
		ShowPlayerVehicles(playerid);
		return 1;
	}
	return 1;
}