#include <a_samp>
#include <zcmd>
#include <sscanf2>

/* KOLORY */
#include "modules/define.pwn"
#include "modules/kolory.pwn"
#include "modules/funkcje.pwn"

/* DEFINICJE */

stock LoadJob()
{
	new ticks = GetTickCount();
	printf("\tLOAD_INFO: Za³adowano system prac dorywczych na serwer! Czas: %dms", GetTickCount() - ticks);
}

CMD:prace(playerid, params[])
{
	ShowPlayerDialog(playerid, INFO_JOB_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, DNAZWA " - Prace dorywcze",\
	"{f9cc00}Praca:\t P³aca:\tOpis:\n\
	Koszenie trawników\t$100\t-\n\
	Mechanik\t-\t-",\
	"Zamknij", "");
	return 1;
} 



