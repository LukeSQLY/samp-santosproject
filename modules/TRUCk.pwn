/*
Ten plik zostal wygenerowany przez skrypt Nickk's TextDraw editor
Autorem skryptu NTD jest Nickk888
*/

#include <a_samp>

new Text:textdraw_0;
new Text:textdraw_1;

public OnFilterScriptInit()
{
	textdraw_0 = TextDrawCreate(6.000000, 426.000000, "Urbantruck.pl :");
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

	textdraw_1 = TextDrawCreate(161.000000, 427.000000, "00.00.0000");
	TextDrawFont(textdraw_1, 3);
	TextDrawLetterSize(textdraw_1, 0.341663, 1.549998);
	TextDrawTextSize(textdraw_1, 400.000000, 17.000000);
	TextDrawSetOutline(textdraw_1, 1);
	TextDrawSetShadow(textdraw_1, 0);
	TextDrawAlignment(textdraw_1, 2);
	TextDrawColor(textdraw_1, -1);
	TextDrawBackgroundColor(textdraw_1, 255);
	TextDrawBoxColor(textdraw_1, 50);
	TextDrawUseBox(textdraw_1, 0);
	TextDrawSetProportional(textdraw_1, 1);
	TextDrawSetSelectable(textdraw_1, 0);

	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!strcmp(cmdtext, "/tdtest", true))
	{
		TextDrawShowForPlayer(playerid, textdraw_0);
		TextDrawShowForPlayer(playerid, textdraw_1);
		return 1;
	}
	return 0;
}
