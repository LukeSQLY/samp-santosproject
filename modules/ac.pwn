#include <a_samp>
#include <zcmd>
#include <sscanf2>

//=DEFINICJE=//

#include "modules/define.pwn"
#include "modules/kolory.pwn"
#include "modules/funkcje.pwn"

new pojazd_ac[MAX_PLAYERS];


CMD:salo(playerid, params[])
{
	new string[128];
	format(string, sizeof(string), "[AC] %s u¿y³ komendy [/salo] która wy³acza aimbota! SprawdŸ to /acs [%d]", pName(playerid), playerid);
    AdminWarning(COLOR_SPECIALGOLD, string);
    return 1;
}

forward ac_car(playerid);
public ac_car(playerid)
{
	SetTimerEx("s0beit_AC", 1500, false, "i", playerid);
	DestroyVehicle(pojazd_ac[playerid]);

}

/*forward s0beit_check(playerid);
public s0beit_check(playerid) {

	print("[AC] Uruchomiono sprawdzanie"); 
	SetTimerEx("s0beit_AC", 1500, true, "i", playerid);
}*/

forward s0beit_AC(playerid);
public s0beit_AC(playerid) {
	if(CheckSlotGun(playerid)) {	
		new string[128];
		format(string, sizeof(string), "[AC] %s [ID %d] zosta³ wyrzucony z serwera, wykryto czity: s00beit - bronie  ", pName(playerid), playerid);
		AdminWarning(KOLOR_AC, string);

		ShowPlayerDialog(playerid, DIALOG_AC, DIALOG_STYLE_MSGBOX, DNAZWA" » AC ", "Zostajesz wyrzucony z serwera z podejrzeniem o oszustwo", "Ok" "");
		
		SetTimerEx("KickEx", 1500, 0, "i", playerid);
	}
}

stock CheckSlotGun(playerid)
{
	new weapon, ammo;
	GetPlayerWeaponData(playerid, 1, weapon, ammo);
	if(weapon == 2) return 1;
	return 0;
}

forward ac_spawn(playerid);
public ac_spawn(playerid)
{
	new Float:X, Float:Y, Float:Z, Float:Ang;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Ang);
	SendClientMessage(playerid, COLOR_RED, "[INFO] Automatyczne sprawdzanie konta.");
	pojazd_ac[playerid] = CreateVehicle(457, X, Y, Z, Ang, 0, 1, -1);
	PutPlayerInVehicle(playerid, pojazd_ac[playerid], 0);
	SetTimerEx("ac_car", 1000, false, "i", playerid);
}