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
	printf("\tLOAD_INFO: Za�adowano system prac dorywczych na serwer! Czas: %dms", GetTickCount() - ticks);
}

CMD:prace(playerid, params[])
{
	ShowPlayerDialog(playerid, INFO_JOB_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, DNAZWA " - Prace dorywcze",\
	"{f9cc00}Praca:\t P�aca:\tOpis:\n\
	Koszenie trawnik�w\t$100\t-\n\
	Mechanik\t-\t-",\
	"Zamknij", "");
	return 1;
} 



