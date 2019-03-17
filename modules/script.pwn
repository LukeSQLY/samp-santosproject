#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#define culoare 0xFFFFFFAA
new objects;
new objectmodel[2000];
new selectedobject, selectedobject_model;
forward WriteLog(string[]);
public OnFilterScriptInit()
{
    printf("|------OBJECTS EDITOR--------|");
    printf("|                            |");
    printf("|                            |");
    printf("|                            |");
    printf("|                            |");
    printf("|----------------------------|");
    return 1;
}
COMMAND:mc(playerid, params[])
{
    new oid,myobject;
    if (!sscanf(params, "i",oid ))
    {
		new string[128];
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        myobject = CreateDynamicObject(oid, x+2, y+2, z+2, 0.0, 0.0, 90.0);
        format(string, sizeof(string), "CREATED:%d||CreateDynamicObject(%d,%f,%f,%f,0.0,0.0,90.0)",myobject,oid,x,y,z);
        SendClientMessage(playerid,culoare,string);
        objectmodel[myobject]=oid;
        objects++;
		selectedobject = myobject;
		selectedobject_model = oid;
        return 1;
    }
    else
    {
        SendClientMessage(playerid,culoare,"USE : /mc [objectid]");
        SendClientMessage(playerid,culoare,"WARNING : Using an wrong id may crash your server");
        return 1;
	}
}
COMMAND:md(playerid, params[])
{
	new oid;
	if(!sscanf(params, "i", oid))
	{
		DestroyDynamicObject(oid);
		for(new x = 0; x < 2000; x++)
		{
			if(objectmodel[x] == oid)
			{
				objectmodel[x] = 0;
				objects--;
				break;
			}
		}
		selectedobject = 0;
		selectedobject_model = 0;
		return 1;
	}
	else
	{
		SendClientMessage(playerid, culoare, "Use: /md [objectid]");
		return 1;
	}
}
COMMAND:msel(playerid, params[])
{
	SelectObject(playerid);
    return 1;
}
COMMAND:mcopy(playerid, params[])
{
	new string[128], myobject;
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    myobject = CreateDynamicObject(selectedobject_model, x+2, y+2, z+2, 0.0, 0.0, 90.0);
    format(string, sizeof(string), "COPY: %d||CreateDynamicObject(%d,%f,%f,%f,0.0,0.0,90.0)",myobject,selectedobject_model,x,y,z);
    SendClientMessage(playerid,culoare,string);
    objectmodel[myobject]=selectedobject_model;
	objects++;
	selectedobject = myobject;
	return 1;
}
COMMAND:mo(playerid, params[])
{
    new oid;
    if(!sscanf(params, "i", oid))
    {
        new Float:xo, Float:yo, Float:zo;
        GetDynamicObjectPos(oid, xo, yo, zo);
        SetPlayerPos(playerid,xo+1,yo+1,zo+1);
        return 1;
    }
	else
	{
		SendClientMessage(playerid,culoare,"Use :/go[objectid]"); 
		return 1;
	}
}
COMMAND:rx(playerid, params[])
{
	new Float:rot;
	if(sscanf(params, "f", rot))
		return SendClientMessage(playerid, culoare, "Use: /rx [rot]");
	
	new Float:rx, Float:ry, Float:rz;
	GetDynamicObjectRot(selectedobject, rx, ry, rz);
	SetDynamicObjectRot(selectedobject, rx + rot, ry, rz);
	SendClientMessage(playerid, culoare, "Success change rotate X.");
	return 1;
}
COMMAND:ry(playerid, params[])
{
	new Float:rot;
	if(sscanf(params, "f", rot))
		return SendClientMessage(playerid, culoare, "Use: /ry [rot]");
	
	new Float:rx, Float:ry, Float:rz;
	GetDynamicObjectRot(selectedobject, rx, ry, rz);
	SetDynamicObjectRot(selectedobject, rx, ry + rot, rz);
	SendClientMessage(playerid, culoare, "Success change rotate Y.");
	return 1;
}
COMMAND:rz(playerid, params[])
{
	new Float:rot;
	if(sscanf(params, "f", rot))
		return SendClientMessage(playerid, culoare, "Use: /rz [rot]");
	
	new Float:rx, Float:ry, Float:rz;
	GetDynamicObjectRot(selectedobject, rx, ry, rz);
	SetDynamicObjectRot(selectedobject, rx, ry, rz + rot);
	SendClientMessage(playerid, culoare, "Success change rotate Z.");
	return 1;
}
COMMAND:ohelp(playerid,params[])
{
    SendClientMessage(playerid,culoare,"/mc || /msel || /go || /mmat || /rx || /ry || /rz || /mcopy || /md || /objects || /savemap");
    SendClientMessage(playerid,culoare,"/oprew");
	return 1;
}
COMMAND:savemap(playerid, params[])
{
    for(new i = 0; i <=500; i++)
    {
        new stringg[128];
        new Float:RotX,Float:RotY,Float:RotZ;
        GetDynamicObjectRot(i, RotX, RotY, RotZ);
        new Float:xo, Float:yo, Float:zo;
        GetDynamicObjectPos(i, xo, yo, zo);
        if(xo!=0 && yo!=0 && zo!=0)
        {
            format(stringg, sizeof(stringg), "CreateDynamicObject(%d,%f,%f,%f,%f,%f,%f);",objectmodel[i],xo,yo,zo,RotX,RotY,RotZ,90);
            WriteLog(stringg);
        }
       
    }
    new stringg[128];
    format(stringg, sizeof(stringg), "________________//\\_______________");
    WriteLog(stringg);
    SendClientMessage(playerid,culoare,"All Objects have been saved to mapa.txt");
    return 1;
}
COMMAND:objects(playerid, params[])
{
    SendClientMessage(playerid,culoare,"___________L I S T______________");
    for(new i = 1; i <=500; i++)
    {
        new stringg[128];
        new Float:RotX,Float:RotY,Float:RotZ;
        GetDynamicObjectRot(i, RotX, RotY, RotZ);
        new Float:xo, Float:yo, Float:zo;
        GetDynamicObjectPos(i, xo, yo, zo);
        if(xo!=0 && yo!=0 && zo!=0)
		{
			format(stringg, sizeof(stringg), "ID:%dCreateDynamicObject(%d,%f,%f,%f,%f,%f,%f);",i,objectmodel[i],xo,yo,zo,RotX,RotY,RotZ);
			SendClientMessage(playerid,culoare,stringg);
		}
    }
    SendClientMessage(playerid,culoare,"________________________________");
    return 1;
}
COMMAND:mmat(playerid, params[])
{
	new index, model, name[128], texturname[128];
	if(!sscanf(params, "dds[128]s[128]", index, model, name, texturname))
	{
		SetDynamicObjectMaterial(selectedobject, index, model, name, texturname);
	}
	else
	{
		SendClientMessage(playerid, culoare, "Use: /mmat [index] [modelid] [txdname] [texturname]");
	}
	return 1;
}
public WriteLog(string[])
{
    new entry[192];
	format(entry, sizeof(entry), "%s\n",string);
	new File:hFile;
    hFile = fopen("mapa.txt", io_append);
	fwrite(hFile, entry);
    fclose(hFile);
    return 1;
}
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(response == EDIT_RESPONSE_FINAL)
    {
        GetDynamicObjectPos(objectid,x,y,z);
        GetDynamicObjectRot(objectid,rx,ry,rz);
        SendClientMessage(playerid,culoare,"Object Saved");
        return 1;
    }
    return 1;
}
public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	selectedobject = objectid;
	selectedobject_model = modelid;
	EditDynamicObject(playerid, objectid);
	return 1;
}