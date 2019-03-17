//doors.pwn
forward MYSQL_LoadDoors(); 
public MYSQL_LoadDoors() {
	if(!cache_num_rows()) {
		print("\t\tLOAD_INFO: Nie znaleziono w bazie danych ¿adnych drzwi. Pomijam ich ³adowanie.");
	}
	new temp[64];
	for(new i = 0; i < cache_num_rows(); i++) {
		if(i == MAX_DOORS) {
			print("\t\tLOAD_INFO: Iloœæ wyników w bazie danych przekracza maksymaln¹ iloœæ drzwi obs³ugiwan¹ przez skrypt. Wy³¹czam serwer.");
			SendRconCommand("exit");
		}

		cache_get_value(i, "uid", temp);
		dInfo[i][UID] = strval(temp);

		cache_get_value(i, "Name", dInfo[i][Name]);
		format(dInfo[i][Name], 64, temp);

		cache_get_value(i, "entposx", temp);
		dInfo[i][entPos][0] = floatstr(temp);

		cache_get_value(i, "entposy", temp);
		dInfo[i][entPos][1] = floatstr(temp);

		cache_get_value(i, "entposz", temp);
		dInfo[i][entPos][2] = floatstr(temp);

		cache_get_value(i, "entvw", temp);
		dInfo[i][entVw] = strval(temp);

		cache_get_value(i, "entintid", temp);
		dInfo[i][entIntID] = strval(temp);

		cache_get_value(i, "intposx", temp);
		dInfo[i][intPos][0] = floatstr(temp);

		cache_get_value(i, "intposy", temp);
		dInfo[i][intPos][1] = floatstr(temp);

		cache_get_value(i, "intposz", temp);
		dInfo[i][intPos][2] = floatstr(temp);

		cache_get_value(i, "intvw", temp);
		dInfo[i][intVw] = strval(temp);

		cache_get_value(i, "intintid", temp);
		dInfo[i][intIntID] = strval(temp);

		cache_get_value(i, "factionproperty", temp);
		dInfo[i][factionProperty] = strval(temp);

		Iter_Add(Doors, i);

		if(dInfo[i][factionProperty])  temp = "1272";
		else  temp = "1273";
		i = CreatePickup(strval(temp), 1, dInfo[i][entPos][0], dInfo[i][entPos][1], dInfo[i][entPos][2], dInfo[i][entVw]);
	}
	cache_unset_active();
	return 1;
}