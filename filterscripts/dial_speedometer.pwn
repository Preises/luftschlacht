//Made by lokii.

#include <a_samp>
#include <foreach> //credits to y_less

new speedo_timer;
new PlayerText:Speedo_Needle[MAX_PLAYERS];
new Text:Speedo_Dial[13];

Float:GetVehicleSpeed(vehicleid)
{
	new Float:vx, Float:vy, Float:vz, Float:vel;
	vel = GetVehicleVelocity(vehicleid, vx, vy, vz);
	vel = (floatsqroot(((vx*vx)+(vy*vy)))* 219.9060);
	return vel;
}

public OnFilterScriptInit()
{
    Speedo_Dial[0] = TextDrawCreate(551.999816, 333.370544, "ld_pool:ball");
	TextDrawTextSize(Speedo_Dial[0], 90.000000, 90.000000);
	TextDrawAlignment(Speedo_Dial[0], 1);
	TextDrawColor(Speedo_Dial[0], -2139062017);
	TextDrawSetShadow(Speedo_Dial[0], 0);
	TextDrawBackgroundColor(Speedo_Dial[0], 255);
	TextDrawFont(Speedo_Dial[0], 4);
	TextDrawSetProportional(Speedo_Dial[0], 0);
	Speedo_Dial[1] = TextDrawCreate(564.000061, 393.674041, "0");
	TextDrawLetterSize(Speedo_Dial[1], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[1], 1);
	TextDrawColor(Speedo_Dial[1], -1);
	TextDrawSetShadow(Speedo_Dial[1], 0);
	TextDrawBackgroundColor(Speedo_Dial[1], 255);
	TextDrawFont(Speedo_Dial[1], 1);
	TextDrawSetProportional(Speedo_Dial[1], 1);
	Speedo_Dial[2] = TextDrawCreate(617.199401, 393.674041, "220");
	TextDrawLetterSize(Speedo_Dial[2], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[2], 1);
	TextDrawColor(Speedo_Dial[2], -1);
	TextDrawSetShadow(Speedo_Dial[2], 0);
	TextDrawBackgroundColor(Speedo_Dial[2], 255);
	TextDrawFont(Speedo_Dial[2], 1);
	TextDrawSetProportional(Speedo_Dial[2], 1);
	Speedo_Dial[3] = TextDrawCreate(559.000061, 381.174041, "20");
	TextDrawLetterSize(Speedo_Dial[3], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[3], 1);
	TextDrawColor(Speedo_Dial[3], -1);
	TextDrawSetShadow(Speedo_Dial[3], 0);
	TextDrawBackgroundColor(Speedo_Dial[3], 255);
	TextDrawFont(Speedo_Dial[3], 1);
	TextDrawSetProportional(Speedo_Dial[3], 1);
	Speedo_Dial[4] = TextDrawCreate(620.500061, 381.174041, "200");
	TextDrawLetterSize(Speedo_Dial[4], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[4], 1);
	TextDrawColor(Speedo_Dial[4], -1);
	TextDrawSetShadow(Speedo_Dial[4], 0);
	TextDrawBackgroundColor(Speedo_Dial[4], 255);
	TextDrawFont(Speedo_Dial[4], 1);
	TextDrawSetProportional(Speedo_Dial[4], 1);
	Speedo_Dial[5] = TextDrawCreate(557.500061, 367.674041, "40");
	TextDrawLetterSize(Speedo_Dial[5], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[5], 1);
	TextDrawColor(Speedo_Dial[5], -1);
	TextDrawSetShadow(Speedo_Dial[5], 0);
	TextDrawBackgroundColor(Speedo_Dial[5], 255);
	TextDrawFont(Speedo_Dial[5], 1);
	TextDrawSetProportional(Speedo_Dial[5], 1);
	Speedo_Dial[6] = TextDrawCreate(621.500061, 367.674041, "180");
	TextDrawLetterSize(Speedo_Dial[6], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[6], 1);
	TextDrawColor(Speedo_Dial[6], -1);
	TextDrawSetShadow(Speedo_Dial[6], 0);
	TextDrawBackgroundColor(Speedo_Dial[6], 255);
	TextDrawFont(Speedo_Dial[6], 1);
	TextDrawSetProportional(Speedo_Dial[6], 1);
	Speedo_Dial[7] = TextDrawCreate(561.000061, 354.174041, "60");
	TextDrawLetterSize(Speedo_Dial[7], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[7], 1);
	TextDrawColor(Speedo_Dial[7], -1);
	TextDrawSetShadow(Speedo_Dial[7], 0);
	TextDrawBackgroundColor(Speedo_Dial[7], 255);
	TextDrawFont(Speedo_Dial[7], 1);
	TextDrawSetProportional(Speedo_Dial[7], 1);
	Speedo_Dial[8] = TextDrawCreate(620.500061, 354.174041, "160");
	TextDrawLetterSize(Speedo_Dial[8], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[8], 1);
	TextDrawColor(Speedo_Dial[8], -1);
	TextDrawSetShadow(Speedo_Dial[8], 0);
	TextDrawBackgroundColor(Speedo_Dial[8], 255);
	TextDrawFont(Speedo_Dial[8], 1);
	TextDrawSetProportional(Speedo_Dial[8], 1);
	Speedo_Dial[9] = TextDrawCreate(567.500061, 343.174041, "80");
	TextDrawLetterSize(Speedo_Dial[9], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[9], 1);
	TextDrawColor(Speedo_Dial[9], -1);
	TextDrawSetShadow(Speedo_Dial[9], 0);
	TextDrawBackgroundColor(Speedo_Dial[9], 255);
	TextDrawFont(Speedo_Dial[9], 1);
	TextDrawSetProportional(Speedo_Dial[9], 1);
	Speedo_Dial[10] = TextDrawCreate(578.835815, 337.374176, "100");
	TextDrawLetterSize(Speedo_Dial[10], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[10], 1);
	TextDrawColor(Speedo_Dial[10], -1);
	TextDrawSetShadow(Speedo_Dial[10], 0);
	TextDrawBackgroundColor(Speedo_Dial[10], 255);
	TextDrawFont(Speedo_Dial[10], 1);
	TextDrawSetProportional(Speedo_Dial[10], 1);
	Speedo_Dial[11] = TextDrawCreate(609.699768, 342.174102, "140");
	TextDrawLetterSize(Speedo_Dial[11], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[11], 1);
	TextDrawColor(Speedo_Dial[11], -1);
	TextDrawSetShadow(Speedo_Dial[11], 0);
	TextDrawBackgroundColor(Speedo_Dial[11], 255);
	TextDrawFont(Speedo_Dial[11], 1);
	TextDrawSetProportional(Speedo_Dial[11], 1);
	Speedo_Dial[12] = TextDrawCreate(594.403503, 336.473754, "120");
	TextDrawLetterSize(Speedo_Dial[12], 0.209333, 1.222517);
	TextDrawAlignment(Speedo_Dial[12], 1);
	TextDrawColor(Speedo_Dial[12], -1);
	TextDrawSetShadow(Speedo_Dial[12], 0);
	TextDrawBackgroundColor(Speedo_Dial[12], 255);
	TextDrawFont(Speedo_Dial[12], 1);
	TextDrawSetProportional(Speedo_Dial[12], 1);
	speedo_timer = SetTimer("Speedo", 100, true);
	foreach(new i : Player)
	{
	    Speedo_Needle[i] = CreatePlayerTextDraw(i, 549.000122, 346.644317, "");
		PlayerTextDrawTextSize(i, Speedo_Needle[i], 90.000000, 90.000000);
		PlayerTextDrawAlignment(i, Speedo_Needle[i], 1);
		PlayerTextDrawColor(i, Speedo_Needle[i], -1);
		PlayerTextDrawBoxColor(i, Speedo_Needle[i], 0x00000000);
		PlayerTextDrawBackgroundColor(i, Speedo_Needle[i], 0x00000000);
		PlayerTextDrawSetShadow(i, Speedo_Needle[i], 0);
		PlayerTextDrawFont(i, Speedo_Needle[i], 5);
		PlayerTextDrawSetProportional(i, Speedo_Needle[i], 0);
		PlayerTextDrawSetPreviewModel(i, Speedo_Needle[i], 19348);
		PlayerTextDrawSetPreviewRot(i, Speedo_Needle[i], 0.000000, 135.000000, 0.000000, 2.000000);
	}
	return 1;
}

forward Speedo();

public Speedo()
{
	new Float:speed, Float:result;
	foreach(new i : Player)
	{
	    if(GetPlayerState(i) != 2) continue;
		speed = GetVehicleSpeed(GetPlayerVehicleID(i));
		if(speed > 270.0)
		{
		    PlayerTextDrawHide(i, Speedo_Needle[i]);
		    PlayerTextDrawSetPreviewRot(i, Speedo_Needle[i], 0.000000, -135.0, 0.000000, 2.000000);
		    PlayerTextDrawShow(i, Speedo_Needle[i]);
		    continue;
		}
		if(speed < 135)
		{
		    result = floatabs((135.0-speed));
		    PlayerTextDrawHide(i, Speedo_Needle[i]);
		    PlayerTextDrawSetPreviewRot(i, Speedo_Needle[i], 0.000000, result, 0.000000, 2.000000);
		    PlayerTextDrawShow(i, Speedo_Needle[i]);
		    continue;
		}
  		result = 135.0-speed;
  		PlayerTextDrawHide(i, Speedo_Needle[i]);
  		PlayerTextDrawSetPreviewRot(i, Speedo_Needle[i], 0.000000, result, 0.000000, 2.000000);
  		PlayerTextDrawShow(i, Speedo_Needle[i]);
	}
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(speedo_timer);
	foreach(new x : Player)
	{
	    PlayerTextDrawDestroy(x, Speedo_Needle[x]);
	}
	for(new i = 0; i < 13; i ++)
	{
	    TextDrawDestroy(Speedo_Dial[i]);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
	    Speedo_Needle[playerid] = CreatePlayerTextDraw(playerid, 549.000122, 346.644317, "");
		PlayerTextDrawTextSize(playerid, Speedo_Needle[playerid], 90.000000, 90.000000);
		PlayerTextDrawAlignment(playerid, Speedo_Needle[playerid], 1);
		PlayerTextDrawColor(playerid, Speedo_Needle[playerid], -1);
		PlayerTextDrawBoxColor(playerid, Speedo_Needle[playerid], 0x00000000);
		PlayerTextDrawBackgroundColor(playerid, Speedo_Needle[playerid], 0x00000000);
		PlayerTextDrawSetShadow(playerid, Speedo_Needle[playerid], 0);
		PlayerTextDrawFont(playerid, Speedo_Needle[playerid], 5);
		PlayerTextDrawSetProportional(playerid, Speedo_Needle[playerid], 0);
		PlayerTextDrawSetPreviewModel(playerid, Speedo_Needle[playerid], 19348);
		PlayerTextDrawSetPreviewRot(playerid, Speedo_Needle[playerid], 0.000000, 135.000000, 0.000000, 2.000000);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(!IsPlayerNPC(playerid))
	{
	    PlayerTextDrawDestroy(playerid, Speedo_Needle[playerid]);
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == 2)
	{
	    for(new i = 0; i < 13; i++)
	    {
			TextDrawShowForPlayer(playerid, Speedo_Dial[i]);
	    }
        PlayerTextDrawSetPreviewRot(playerid, Speedo_Needle[playerid], 0.000000, 135.000000, 0.000000, 2.000000);
	    PlayerTextDrawShow(playerid, Speedo_Needle[playerid]);
	}
	if(newstate != 2 && oldstate == 2)
	{
	    for(new i = 0; i < 13; i++)
	    {
			TextDrawHideForPlayer(playerid, Speedo_Dial[i]);
	    }
	    PlayerTextDrawHide(playerid, Speedo_Needle[playerid]);
	}
	return 1;
}

//EOF.
