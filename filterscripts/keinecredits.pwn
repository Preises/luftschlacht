#include <a_samp>

new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new PlayerText:Textdraw3[MAX_PLAYERS];
new PlayerText:Textdraw4[MAX_PLAYERS];
new PlayerText:Textdraw5[MAX_PLAYERS];


new VehicleNames[][] =
{
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Perenniel",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Mr Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Article Trailer",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squallo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Article Trailer 2",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Topfun Van (Berkley's RC)",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"SAN News Maverick",
	"Rancher",
	"FBI Racher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring Racer",
	"Sandking",
	"Blista Compact",
	"Police Maverick",
	"Boxville",
	"Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer",
	"Hotring Racer",
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropduster",
	"Stuntplane",
	"Tanker",
	"Roadtrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Towtruck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine Hervester",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight (Train)",
	"Brownstreak (Train)",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck LA",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility Van",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster \"A\"",
	"Monster \"B\"",
	"Uranus",
	"Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight Flat Tailer (Train)",
	"Streak Trailer (Train)",
	"Kart",
	"Mower",
	"Dune",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"Newsvan",
	"Tug",
	"Petrol Trailer",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Freight Box Trailer (Train)",
	"Article Trailer 3",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police Car (LSPD)",
	"Police Car (SFPD)",
	"Police Car (LVPD)",
	"Police Ranger",
	"Picador",
	"S.W.A.T.",
	"Alpha",
	"Phoenix",
	"Glendale Shit",
	"Sadler Shit",
	"Baggage Trailer \"A\"",
	"Baggage Trailer \"B\"",
	"Tug Stairs Trailer",
	"Boxville",
	"Farm Trailer",
	"Utility Trailer"
};
new hSpeedActiv[MAX_PLAYERS];
new hspeedinfotimer[MAX_PLAYERS];

public OnFilterScriptInit()
{
    print("- hSpeed (by Hattoldy) succesfully loaded."); // credits
	Textdraw0 = TextDrawCreate(602.500000, 332.522216, "usebox");
	TextDrawLetterSize(Textdraw0, 0.122000, 8.795476);
	TextDrawTextSize(Textdraw0, 485.500000, 4.355555);
	TextDrawAlignment(Textdraw0, 1);
	TextDrawColor(Textdraw0, 0);
	TextDrawUseBox(Textdraw0, true);
	TextDrawBoxColor(Textdraw0, 102);
	TextDrawSetShadow(Textdraw0, 0);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawFont(Textdraw0, 0);

	Textdraw1 = TextDrawCreate(505.000000, 318.577758, "hud:radar_truck");
	TextDrawLetterSize(Textdraw1, 0.769999, 1.711111);
	TextDrawTextSize(Textdraw1, 23.000000, 21.155574);
	TextDrawAlignment(Textdraw1, 1);
	TextDrawColor(Textdraw1, -1);
	TextDrawUseBox(Textdraw1, true);
	TextDrawBoxColor(Textdraw1, 102);
	TextDrawSetShadow(Textdraw1, 0);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawFont(Textdraw1, 4);

	Textdraw2 = TextDrawCreate(529.000000, 316.711090, "Speed");
	TextDrawLetterSize(Textdraw2, 0.692499, 2.160000);
	TextDrawAlignment(Textdraw2, 1);
	TextDrawColor(Textdraw2, -1);
	TextDrawSetShadow(Textdraw2, 0);
	TextDrawSetOutline(Textdraw2, 1);
	TextDrawBackgroundColor(Textdraw2, 51);
	TextDrawFont(Textdraw2, 0);
	TextDrawSetProportional(Textdraw2, 1);
	return 1;
}


public OnPlayerConnect(playerid)
{
	Textdraw3[playerid] = CreatePlayerTextDraw(playerid, 548.500000, 392.622161, "~R~SUPER GT");
	PlayerTextDrawLetterSize(playerid, Textdraw3[playerid], 0.321500, 1.475554);
	PlayerTextDrawAlignment(playerid, Textdraw3[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw3[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw3[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, Textdraw3[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw3[playerid], 3);
	PlayerTextDrawSetProportional(playerid, Textdraw3[playerid], 1);

	Textdraw4[playerid] = CreatePlayerTextDraw(playerid, 545.000000, 348.822143, "SPEED ~R~123 KM/H");
	PlayerTextDrawLetterSize(playerid, Textdraw4[playerid], 0.364500, 1.425777);
	PlayerTextDrawAlignment(playerid, Textdraw4[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw4[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw4[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, Textdraw4[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw4[playerid], 3);
	PlayerTextDrawSetProportional(playerid, Textdraw4[playerid], 1);

	Textdraw5[playerid] = CreatePlayerTextDraw(playerid, 546.500000, 372.222229, "Health ~R~100.0");
	PlayerTextDrawLetterSize(playerid, Textdraw5[playerid], 0.367000, 1.488000);
	PlayerTextDrawAlignment(playerid, Textdraw5[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw5[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw5[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw5[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, Textdraw5[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw5[playerid], 3);
	PlayerTextDrawSetProportional(playerid, Textdraw5[playerid], 1);
	hSpeedActiv[playerid] = 1;
	return 1;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
	if(hSpeedActiv[playerid] == 1)
	{
		if(newstate == PLAYER_STATE_DRIVER)
		{
			TextDrawShowForPlayer(playerid,Textdraw0);
			TextDrawShowForPlayer(playerid,Textdraw1);
			TextDrawShowForPlayer(playerid,Textdraw2);
			PlayerTextDrawShow(playerid, Textdraw3[playerid]);
			PlayerTextDrawShow(playerid, Textdraw4[playerid]);
			PlayerTextDrawShow(playerid, Textdraw5[playerid]);
	        hspeedinfotimer[playerid] = SetTimerEx("hSpeedINFO",1000,1,"d",playerid);
		}
		if(oldstate == PLAYER_STATE_DRIVER)
		{
			TextDrawHideForPlayer(playerid,Textdraw0);
			TextDrawHideForPlayer(playerid,Textdraw1);
			TextDrawHideForPlayer(playerid,Textdraw2);
			PlayerTextDrawHide(playerid, Textdraw3[playerid]);
			PlayerTextDrawHide(playerid, Textdraw4[playerid]);
			PlayerTextDrawHide(playerid, Textdraw5[playerid]);
			KillTimer(hspeedinfotimer[playerid]);
		}
	}
	return 1;
}


forward hSpeedINFO(PlayerId);
public hSpeedINFO(PlayerId)
{
	new String[150];
	format(String,150,"~R~%s",VehicleNames[GetVehicleModel(GetPlayerVehicleID(PlayerId))-400]);
    PlayerTextDrawSetString(PlayerId, Textdraw3[PlayerId], String);
	new Float:X;
	new Float:Y;
	new Float:Z;
	GetVehicleVelocity(GetPlayerVehicleID(PlayerId),X,Y,Z);
	format(String,150,"SPEED ~R~%d KM/H",floatround(floatsqroot(X * X + Y * Y + Z * Z) * 200.0000));
    PlayerTextDrawSetString(PlayerId, Textdraw4[PlayerId], String);
	new Float:Health;
	GetVehicleHealth(GetPlayerVehicleID(PlayerId),Health);
	format(String,150,"Health ~R~%d.0",floatround(Health / 10));
    PlayerTextDrawSetString(PlayerId, Textdraw5[PlayerId], String);
	return 1;
}
