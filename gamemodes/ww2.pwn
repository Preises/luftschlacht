// Luftschlacht made by Tec9 2019-2020

#include <a_samp>
#include <ocmd>
#include<a_mysql>
#include <streamer>
#include<progressbar>
#include<crashdetect>
#include <JunkBuster>
#include <mapandreas>
#include <mysql_info>
#include <flyCameraByGammix>
#include<morserScript>

main()
{
	print("\n----------------------------------");
	print(" Luftschlacht - Made by Tec9");
	print("----------------------------------\n");
}

// Dialog Defines

enum
{
    DIALOG_REGISTER,
    DIALOG_LOGIN,
    DIALOG_BAN,
    DIALOG_TUTORIAL,
    DIALOG_STATS,
    DIALOG_CONFIG_ARTILLERY
    
}


//

// Global Variabels

new Text:TDEditor_TD[3];
new startcounter;
new gangzone;
new updater;
new miniumScore_pilot = 0;
new Float:debug_speed = 40.0; // How fast are the bomb objects moving?

new debug_howfar = 75; // how far from the Players Forward Position are the bombs being dropped in a bomber.

new Float:debug_rotationfloat = -2400.0;  // how far does the bomb rotate while being dropped?

new MySQL:handle; // MySQL SA:MP GameMode connection!
//

// natives

native gpci (playerid, serial [], len);

// Spawns
new Float:LSSpawns[][] =
{
    {256.0207,-1845.6223,3.3293,87.5131}, // LS1
    {256.2760,-1829.8337,3.7616,90.8971}, //
    {251.9052,-1817.3425,4.1313,97.8532}, //
    {251.1783,-1800.5221,4.4088,92.5891}, //
    {249.0969,-1783.3824,4.2265,101.9892}, // LS5
    {274.9626,-1789.2765,4.3802,86.9490},
    {277.4340,-1803.8250,4.4269,96.7251},
    {277.8704,-1825.3513,3.9446,110.4493}, // LS 8
    {295.7298,-1759.2570,8.3755,142.0336}//
};
new Float:SFSpawns[][] =
{
    {-357.2592,-1408.0635,25.7266,265.7386}, // SF1
    {-414.0228,-1399.1511,23.1478,283.0115}, //
    {-426.9585,-1380.0610,23.1085,277.5594}, //
    {-427.0782,-1357.6388,23.7796,294.4796}, //
    {-426.0165,-1338.1522,26.6104,296.9236}, // SF5
    {-418.8205,-1309.0702,30.0239,294.8555},
    {-335.2206,-1394.6351,14.1079,262.3312},
    {-335.7329,-1407.1595,15.9292,264.2113}, // SF 8
    {-339.5097,-1419.8730,17.6816,268.7234}//
};
/*

new Float:LSEnemySpawn[][] = // Für SF
{
    {152.5197,-1773.9719,4.3996,267.8873}, //
    {152.5520,-1784.4281,4.1189,269.7672}, //
    {152.9404,-1791.6887,3.9360,269.7672}, //
    {153.6378,-1801.4977,3.7307,272.9006}, //
    {154.5089,-1812.6305,3.7416,271.9606}, //
    {155.5059,-1820.3279,3.7491,271.9606},
    {155.9918,-1830.4211,3.7590,271.0206},
    {154.0269,-1841.0427,3.7734,269.4539}, //
    {155.0444,-1853.2649,3.7734,274.4673},//
    {154.8698,-1863.7157,3.7734,268.2006}
};


new Float:SFEnemySpawn[][] = // Für LS
{
    {-216.8717,-1474.3345,7.6936,69.4167}, //
    {-227.4613,-1480.6742,6.2603,64.7166}, //
    {-233.5973,-1487.9229,6.7178,64.7166}, //
    {-239.6256,-1495.6351,7.2369,58.1366}, //
    {-246.8573,-1503.4360,6.8647,58.1366}, //
    {-253.1413,-1510.0753,6.3823,58.1366},
    {-260.2648,-1517.3141,5.8113,52.1832},
    {-268.7184,-1524.3331,5.1300,48.1098}, //
    {-276.5608,-1529.2139,5.3357,38.7097},//
    {-284.3905,-1533.3843,6.8339,38.7097}
};*/

// Player Variables

new PlayerText:TDEditor_PTD[MAX_PLAYERS];
new PlayerText:TeamCapturePoints[MAX_PLAYERS];
new LastDriver[MAX_VEHICLES];
new LastCar[MAX_PLAYERS];
new PlayerText:PlayerBox[MAX_PLAYERS];

new PlayerText:BombsTextDraw[MAX_PLAYERS];

new DroppingBombs[MAX_PLAYERS];

//

//General defines
#define SCM SendClientMessage

//

// Gameplay Defines
#define MAX_CITIES 3

#define MAX_CAPTURE_POINTS 8

#define MAX_CAPTURE_TIME 25

#define MIN_PLAYERS_TOPLAY 1

#define MAX_ZONES 158


// COLORS
#define COOLRED 0xFF0000FF
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTRED 0xFB0000AA
#define COLOR_PURPLE 0xC2A2DAAA
#define RED_NEW 0xF60000F6
#define BLUE_NEW 0x0000CAF6
#define GREEN 0x21DD00FF
#define ORANGE 0xF97804FF
#define ROT 0xE60000FF
#define GRUEN 0x05FF00FF
#define GELB 0xFFFF00FF
#define BLAU 0x000FFFFF
#define RED 0xE60000FF
#define CHECKPOINT_NONE 0
#define CHECKPOINT_HOME 12
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_ORANGE 0xFF9933FF
#define COLOR_NTRL 0xC30C15F0
#define COLOR_BROWN 0x330000FF
#define COLOR_BLACK 0x000000FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define EVENTCOLOR 0xAA3333AA
#define COLOR_LIGHTRED2 0xFF6347AA
#define COLOR_LIGHTRED3 0xFB0000AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTGREEN 0x9ACD32AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_YELLOW2 0xF5DEB3AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_WHITEE 0xFFFFFFAA
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_ALLDEPT 0xFF8282AA
#define COLOR_NEWS 0xFFA500AA
#define COLOR_OOC 0xE0FFFFAA
#define COLOR_AONDONNN 0xF5DEB3AA
#define TEAM_CYAN 1
#define TEAM_BLUE 2
#define TEAM_GREEN 3
#define TEAM_ORANGE 4
#define TEAM_COR 5
#define TEAM_BAR 6
#define TEAM_TAT 7
#define TEAM_CUN 8
#define TEAM_STR 9
#define TEAM_HIT 10
#define TEAM_ADMIN 17
#define OBJECTIVE_COLOR 0x64000064
#define TEAM_GREEN_COLOR 0xFFFFFFAA
#define TEAM_JOB_COLOR 0xFFB6C1AA
#define TEAM_HIT_COLOR 0xFFFFFF00
#define TEAM_BLUE_COLOR 0x8D8DFF00
#define COLOR_ADD 0x63FF60AA
#define TEAM_Grove_COLOR 0x00D900C8
#define TEAM_Vagos_COLOR 0xFFC801C8
#define TEAM_Ballas_COLOR 0xD900D3C8
#define TEAM_Aztecas_COLOR 0x01FCFFC8
#define TEAM_CYAN_COLOR 0xFF8282AA
#define TEAM_ORANGE_COLOR 0xFF830000
#define TEAM_COR_COLOR 0x39393900
#define TEAM_BAR_COLOR 0x00D90000
#define TEAM_TAT_COLOR 0xBDCB9200
#define TEAM_CUN_COLOR 0xD900D300
#define TEAM_STR_COLOR 0x01FCFF00
#define TEAM_ADMIN_COLOR 0x00808000
#define COLOR_INVIS 0xAFAFAF00
#define COLOR_SPEC 0xBFC0C200
//



// Enums
enum pDataEnum
{
	p_id,
	pLoggedIn,
	pName[MAX_PLAYER_NAME],
	pScore,
	pMoney,
	pKills,
	pDeaths,
	pInCP,
	PlayerBar:pProgress,
	pProgressTimer,
	SpswnProtected,
	mylabel,
	bool:pClassSelection,
	bool:pDead,
	Float:DeadPosX,
	Float:DeadPosY,
	Float:DeadPosZ,
	bool:AlreadySpawned,
	bool:CarReady,
	pTutStep,
	pTutorial,
	pAdmin,
	bool:pIPBanCheck,
	bool:pBoxShown,
	pJob,  // Job 0 = Soldier, Job 1 = Pilot, Job 2 = Tank Driver, Job 3 = Supply Deliverer
	Float:pTargetArtPos_X,
	Float:pTargetArtPos_Y,
	Float:pTargetArtPos_Z,
	bool:IsConfiguringArtillery
}
new PlayerInfo[MAX_PLAYERS][pDataEnum];

enum City_Enum
{
	Air_Superiority, // get air superiority of a City !  > Description: Each city has 50% air superiority, so 100% together. If you shoot a plane, your team gets + 1% Air Superiority. If you're being shot down by an enemy your team loses 1%
	LuftFlugzeuge,  // get numbers of planes of a City!
	Captured,       // how many checkpoints your team captured in this round
	Defended        // how many checkpoints were successfully defended after the enemy attemptet to capture it
}
new City[MAX_CITIES][City_Enum];


enum ServerMode{
	InvasionStep,
	bool:LandGefecht,
	bool:Prepared,
	bool:ModeStarted,
	bool:CanSpawn,
	EtappenWinner,
	bool:PreparePhase2,
	bool:FiveSecondStart,
	Minuten,
	Sekunden
	
}
new Server[ServerMode];


enum CapturePoints{
	owner,
	cpid,
	Effect,
	baseid,
	ActiveCapture,
	CaptureTime,
	ProgressTime,
	tattacker,
	tdefender,
	bool:kampfvorbei
}
new Capture[MAX_CAPTURE_POINTS][CapturePoints];
//


enum VehicleEnum{
	teamidd,
	vehType,
	neededJob,
	LocalID,
	bombs
}
new VehicleInfo[MAX_VEHICLES][VehicleEnum];

//vehtype = 0 normal, vehtype = 1 stukabomber




enum BombenSystemYo{

	bombid,
	localBomb
	
}

new BombSystem[100][BombenSystemYo];





enum GangZoneEnum
{
	ZoneID,
	ZoneArt,
	Float:minx,
	Float:miny,
	Float:maxx,
	Float:maxy,
	DominatedBy,
	ZoneName[24],
	ZoneActive,
	Text3D:CaptureLabel,
	FlagPickup,
	Zone_CP,
	resource,
	resourceAmount,
	LocalZone,
	bool:beingCaptured,
	beingCapturedTime, // max 100
	playerCapturerID
}

new GangZones[MAX_ZONES][GangZoneEnum];




enum ArtillerySystem{

	artid,
	artLocalID,
	artListID,
	Float:Art_PositonX,
	Float:Art_PositonY,
	Float:Art_PositonZ,
	Float:Art_RotationX,
	Float:Art_RotationY,
	Float:Art_RotationZ,
	Float:TargetPointX,
	Float:TargetPointY,
	Float:TargetPointZ,
	shootHowOften, // getimme
	ammuNition,
	bool: activeShooting,
	bool: isEnabled,
	dominatedByTeam
}

new Artillery[10][ArtillerySystem];




enum ProjetileSystem{

	p_id,
	p_objectID
	
}

new ProjectTile[325][ProjetileSystem];

public OnGameModeInit()
{
//	SetGameModeText("Deathmatch");
	updater = SetTimer("UpdateGameMode",1000,1);
	SetTimer("CheckAirWinners",2500,1);
	
	SetTimer("UpdateObjects",120,1);
	
	
	SetTimer("LoopThrewAllPlayers",1000,1);
	
	MapAndreas_Init(2);
	for(new i = 0; i<sizeof(BombSystem); i++)
	{
	    BombSystem[i][bombid] = -1;
	}
	
	for(new id=0; id<MAX_ZONES; id++)
	{
	    GangZones[id][FlagPickup]=-1;
	    GangZones[id][CaptureLabel]=Text3D:-1;
	    GangZones[id][ZoneID] = -1;
	}
	for(new i = 0; i<sizeof(Artillery);i++)
	{
	    Artillery[i][artid]=-1;
	    
	    Artillery[i][ammuNition]=10000;   // standard default and local default should be configurable by an admin
	   /* Artillery[i][TargetPointX] = -357.2592;
	    Artillery[i][TargetPointY] = -1408.0635;
	    Artillery[i][TargetPointZ] = 25.7266;*/
	}

	
	for(new i = 0; i<sizeof(ProjectTile);i++)
	{
	    ProjectTile[i][p_id]=-1;
	}
// Soldier Class 
	AddPlayerClass(12,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(287,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(291,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(193,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(299,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(206,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(217,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(218,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
    AddPlayerClass(296,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);





	// Tank Driver

	AddPlayerClass(250,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(234,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(226,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);

	// Supply Driver

	AddPlayerClass(261,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(235,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(206,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(202,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);


	// Pilots 


	AddPlayerClass(255,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(253,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	
	
	
	
	MySQL_SetupConnection();
	LoadMaps();
	PrepareGameMode();
	LoadGangZones();
 	LoadArtillerys();

	

	
	// Team SF CPS
/*	Capture[0][cpid] = CreateDynamicCP(-365.0519,-1420.4594,25.7266, 8.0,-1, -1, -1, 100.0,-1, 0); // San Fierro Checkpoints (Team 2)
    Capture[1][cpid] = CreateDynamicCP(-298.4463,-1423.2028,13.7179, 8.0,-1, -1, -1, 100.0,-1, 0);
    Capture[2][cpid] = CreateDynamicCP(-389.4870,-1446.4491,34.0547, 8.0,-1, -1, -1, 100.0,-1, 0);
    Capture[3][cpid] = CreateDynamicCP(-91.8136,-1171.1531,2.3813, 8.0,-1, -1, -1, 100.0,-1, 0);
    
    Capture[1][Effect] = CreateObject(18728,-365.0519,-1420.4594,25.7266,0,0,0,300);
    Capture[2][Effect] = CreateObject(18728,-298.4463,-1423.2028,13.7179,0,0,0);
    Capture[3][Effect] = CreateObject(18728,-389.4870,-1446.4491,34.0547,0,0,0);
    Capture[4][Effect] = CreateObject(18728,-91.8136,-1171.1531,2.3813,0,0,0);

    
    
    
    Capture[4][cpid] = CreateDynamicCP(211.4802,-1759.1700,4.4693, 8.0,-1, -1, -1, 100.0,-1, 0);  // Los Santos Checkpoints (Team 1)
    Capture[5][cpid] = CreateDynamicCP(260.5986,-1761.8623,13.8516, 8.0,-1, -1, -1, 100.0,-1, 0);
    Capture[6][cpid] = CreateDynamicCP(257.8129,-1818.9976,4.0854, 8.0,-1, -1, -1, 100.0,-1, 0);
    Capture[7][cpid] = CreateDynamicCP(535.1077,-1812.5867,6.5713, 8.0,-1, -1, -1, 100.0,-1, 0);
    
    Capture[4][Effect] = CreateObject(18728,211.4802,-1759.1700,4.4693,0,0,0);
    Capture[5][Effect] = CreateObject(18728,260.5986,-1761.8623,13.8516,0,0,0);
    Capture[6][Effect] = CreateObject(18728,257.8129,-1818.9976,4.0854,0,0,0);
    Capture[7][Effect] = CreateObject(18728,535.1077,-1812.5867,6.5713,0,0,0);*/
    
    
    
	
	
	
	//
	
	// flugzeug TextDraw
	

	TDEditor_TD[0] = TextDrawCreate(283.666687, -3.874080, "");
	TextDrawTextSize(TDEditor_TD[0], 66.000000, 40.000000);
	TextDrawAlignment(TDEditor_TD[0], 1);
	TextDrawColor(TDEditor_TD[0], -1);
	TextDrawSetShadow(TDEditor_TD[0], 0);
	TextDrawBackgroundColor(TDEditor_TD[0], 1); // vorher 255
	TextDrawFont(TDEditor_TD[0], 5);
	TextDrawSetProportional(TDEditor_TD[0], 0);
	TextDrawSetPreviewModel(TDEditor_TD[0], 476);
	TextDrawSetPreviewRot(TDEditor_TD[0], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(TDEditor_TD[0], 1, 1);
	
	
	// die restlichen flugzeuge anzahl als %02d angeben
	
	TDEditor_TD[2] = TextDrawCreate(593.667236, 417.733123, "5:00");  // Zeit
	TextDrawLetterSize(TDEditor_TD[2], 0.363333, 1.575111);
	TextDrawAlignment(TDEditor_TD[2], 1);
	TextDrawColor(TDEditor_TD[2], -1);
	TextDrawSetShadow(TDEditor_TD[2], 0);
	TextDrawBackgroundColor(TDEditor_TD[2], 255);
	TextDrawFont(TDEditor_TD[2], 1);
	TextDrawSetProportional(TDEditor_TD[2], 1);
	TextDrawSetSelectable(TDEditor_TD[2], true);




//	gangzone = GangZoneCreate(-493.5156,-722.0081, 1026.8051,-2109.3525);



    /*for(new i = MAX_VEHICLES, k; k < i; k++)
	{
		LastDriver[k] = INVALID_PLAYER_ID;
	}*/


	
	
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
		LastDriver[i] = INVALID_PLAYER_ID;
		
		VehicleInfo[i][bombs] = 100;
	}
	


	
	
	
	//
	return 1;
}

public OnGameModeExit()
{
    mysql_close(handle);
    
    for(new i=0; i<MAX_OBJECTS;i++)
    {
        DestroyDynamicObject(i);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, -65.4287,-1359.8640,12.4613);
	SetPlayerFacingAngle(playerid,69.6762);
	
	SetPlayerCameraPos(playerid,-68.5222,-1357.7305,12.5180);
	SetPlayerCameraLookAt(playerid, -65.4287,-1359.8640,12.4613);
	
	
	PlayerInfo[playerid][pClassSelection]=true;
	return 1;
}



public OnPlayerConnect(playerid)
{
    ResetPlayerVariables(playerid);
    
    CheckUserBan(playerid);
    
    RemoveBuildingsForPlayer(playerid);
    PlayerInfo[playerid][pProgress] = CreatePlayerProgressBar(playerid, 291.333435, 208.251922, 80.5,  10.2, COLOR_LIGHTRED, 100.0);
    if(!PlayerInfo[playerid][pLoggedIn])
	{
		new query[128];
		mysql_format(handle, query, sizeof(query), "SELECT p_id FROM accountsy WHERE name = '%e'", PlayerInfo[playerid][pName]);
		mysql_pquery(handle, query, "OnUserCheck", "d", playerid);
	}
	else Kick(playerid);
	
	TDEditor_PTD[playerid] = CreatePlayerTextDraw(playerid, 307.666717, 19.096334, "100");
	PlayerTextDrawLetterSize(playerid, TDEditor_PTD[playerid], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, TDEditor_PTD[playerid], 1);
	PlayerTextDrawColor(playerid, TDEditor_PTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, TDEditor_PTD[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, TDEditor_PTD[playerid], 255);
	PlayerTextDrawFont(playerid, TDEditor_PTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TDEditor_PTD[playerid], 1);
	
	PlayerInfo[playerid][mylabel] = CreatePlayerObject(playerid,19353,-188.2051,-1469.9440,55.7322,0,0,90.0,300);
	
	TeamCapturePoints[playerid]= CreatePlayerTextDraw(playerid, 545.333435, 416.903442, "0/1_Captured");
	PlayerTextDrawLetterSize(playerid, TeamCapturePoints[playerid], 0.335333, 1.730961);
  //  PlayerTextDrawLetterSize(playerid, TeamCapturePoints[playerid], 0.299332, 1.587552);
	PlayerTextDrawTextSize(playerid, TeamCapturePoints[playerid], -143.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, TeamCapturePoints[playerid], 1);
	PlayerTextDrawColor(playerid, TeamCapturePoints[playerid], -1);
	PlayerTextDrawSetShadow(playerid, TeamCapturePoints[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, TeamCapturePoints[playerid], 255);
	PlayerTextDrawFont(playerid, TeamCapturePoints[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TeamCapturePoints[playerid], 1);
	
	
	
	
	
	// PlayerBox
    PlayerBox[playerid] = CreatePlayerTextDraw(playerid,17.000007, 126.118553, "Text__");
	PlayerTextDrawLetterSize(playerid,PlayerBox[playerid], 0.517666, 2.006517);
	PlayerTextDrawTextSize(playerid,PlayerBox[playerid], 212.000000, 0.000000);
	//PlayerTextDrawTextSize(playerid,PlayerBox[playerid], 510.000000, 0.000000);
	PlayerTextDrawAlignment(playerid,PlayerBox[playerid], 1);
	PlayerTextDrawColor(playerid,PlayerBox[playerid], COLOR_GREY);
	PlayerTextDrawSetShadow(playerid,PlayerBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid,PlayerBox[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid,PlayerBox[playerid], 255);
	PlayerTextDrawFont(playerid,PlayerBox[playerid], 1);
	PlayerTextDrawSetProportional(playerid,PlayerBox[playerid], 1);
	PlayerTextDrawSetShadow(playerid,PlayerBox[playerid], 0);
	PlayerTextDrawBoxColor(playerid,PlayerBox[playerid], 0x00000089);
	PlayerTextDrawUseBox(playerid,PlayerBox[playerid], 1);
	  //
	  
	  
	  
	  // Bomben in Flugzeug
    BombsTextDraw[playerid] = CreatePlayerTextDraw(playerid, 536.666625, 168.014831, "Bombs:_10");
	PlayerTextDrawLetterSize(playerid, BombsTextDraw[playerid], 0.351333, 1.496296);
	PlayerTextDrawAlignment(playerid, BombsTextDraw[playerid], 1);
	PlayerTextDrawColor(playerid, BombsTextDraw[playerid], -1);
	PlayerTextDrawSetShadow(playerid, BombsTextDraw[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BombsTextDraw[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, BombsTextDraw[playerid], 255);
	PlayerTextDrawFont(playerid, BombsTextDraw[playerid], 2);
	PlayerTextDrawSetProportional(playerid, BombsTextDraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, BombsTextDraw[playerid], 0);
	  
	  
	  
	  //
	  
	  
    for(new id=0; id<MAX_ZONES; id++)
	{
 		if(GangZones[id][LocalZone] != -1)
 		{
			GangZoneShowForPlayer(playerid,GangZones[id][LocalZone],GetTeamColor(GangZones[id][DominatedBy]));
		}
	}
	return 1;
}

stock GetTeamColor(teamid)
{
	new color;
	switch (teamid)
	{
	    case 1: // LS
	    {
	        color = 0xAA3333AA;
		}
		case 2: //SF
		{
		    color = 0x33CCFFAA;
		}
	}
	return color;
}

public OnPlayerDisconnect(playerid, reason)
{
    SaveUserStats(playerid);
 //   PlayerInfo[playeri][
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(Server[ModeStarted]==false)
    {
        SetPlayerPos(playerid,-704.9656,1952.4576,5.1078);
	    SetPlayerFacingAngle(playerid,223.1054);
	    SCM(playerid,COLOR_GREEN,"Welcome to LUFTSCHLACHT! The Game is being prepared...");
	    return 1;
	}
 	if(PlayerInfo[playerid][pTutorial]==1)
 	{
 	    new sstring[512];
 	    switch(PlayerInfo[playerid][pTutStep])
 	    {
	 	    case 1:
	 	    {
	 	    	SetPlayerCameraPos(playerid,55.5603,-1816.0057,92.6071);
	 	    	SetPlayerCameraLookAt(playerid,48.3580,-1540.6732,20.2873);


				strcat(sstring,"{FFFFFF}Hey and Welcome to LUFTSCHLACHT!\n");
				strcat(sstring,"{FFFFFF}We'd like to Show you our Server in this following Tutorial\n");
				strcat(sstring,"{DF0101}Note: {FFFFFF}Please read the following sentences carefully in order to fully understand our game concept\n\n");
                strcat(sstring,"Reading Time: {01DF3A} 3 Minutes");
                
                PlayerInfo[playerid][pTutStep] = 2;
	 	    	ShowPlayerDialog(playerid,DIALOG_TUTORIAL,DIALOG_STYLE_MSGBOX,"{FFFFFF}Tutorial 1/4",sstring,"{58D3F7}Start","Leave");
	 	   	}
		}
		return 1;
	}
	 
	if(PlayerInfo[playerid][pClassSelection] == false)
	{

	/*    if(Server[ModeStarted]==true)
		{
		    PlayerInfo[playerid][AlreadySpawned]=true;
		}*/
	    if(GetPlayerTeam(playerid) == 255 && Server[ModeStarted]==true)
	    {
	        if(GetTeamPlayers(1) > GetTeamPlayers(2))
	        {
	            SetPlayerTeam(playerid,2);
			}
			if(GetTeamPlayers(2) > GetTeamPlayers(1))
	        {
	            SetPlayerTeam(playerid,1);
			}
			if(GetTeamPlayers(2) == GetTeamPlayers(1))
	        {
	            new rand = randomEx(1,3);
	            SetPlayerTeam(playerid,rand);
			}
			new string[64],team = GetPlayerTeam(playerid);
			format(string,sizeof(string),"You joined the Team %s",GetTeamName(team));
			SendClientMessage(playerid,COLOR_GOLD,string);
			if(Server[LandGefecht]==true)
			{
				SetTimerEx("SpawnKillEnd", 8000, 0,"i",playerid);
			}
			SetPlayerWorldBounds(playerid, 1027.9858, -488.1284, -728.1127, -2107.9824);
			
			new Random;
			switch(GetPlayerTeam(playerid))
   			{
   			    
      			case 1:
         		{
           			Random = random(sizeof(LSSpawns));
		        	SetPlayerPos(playerid, LSSpawns[Random][0], LSSpawns[Random][1], LSSpawns[Random][2]);
		        	SetPlayerFacingAngle(playerid, LSSpawns[Random][3]);
		        	SetPlayerColor(playerid,COLOR_YELLOW);
				}
				case 2:
    			{
    				Random = random(sizeof(SFSpawns));
       				SetPlayerPos(playerid, SFSpawns[Random][0], SFSpawns[Random][1], SFSpawns[Random][2]);
		        	SetPlayerFacingAngle(playerid, SFSpawns[Random][3]);
		        	SetPlayerColor(playerid,COLOR_BLUE);
				}
			}

		}
		if(PlayerInfo[playerid][pDead]==true)
		{
            PlayerInfo[playerid][pDead] = false;
		}
		switch(PlayerInfo[playerid][pJob])
		{
		    case 0:  // foot Soldier
		    {
		        SetSpawnReady(playerid);
		        ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid,4,1);
				GivePlayerWeapon(playerid,24,999);
				GivePlayerWeapon(playerid,25,999);
				GivePlayerWeapon(playerid,31,999);
				GivePlayerWeapon(playerid,34,10);
			}
			
			case 1: //Pilot
			{
			    SetSpawnReady(playerid);
			    ResetPlayerWeapons(playerid);
			    GivePlayerWeapon(playerid,24,999);
			    SCM(playerid,COLOR_RED,"[SEARCHING PLANE] We're looking for a free Plane for you...");
				SetTimerEx("FindPlaneInterval",4000,0,"i",playerid);
			}
	
	        case 2: // Tank Driver
	        {
	            SetSpawnReady(playerid);
	            ResetPlayerWeapons(playerid);
			    GivePlayerWeapon(playerid,24,999);
			    SCM(playerid,COLOR_RED,"[SEARCHING TANK] We're looking for a free Tank for you...");
				SetTimerEx("FindTankInterval",4000,0,"i",playerid);
			}
			case 3:
			{
			    SetSpawnReady(playerid);
			    ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid,9,1);
				GivePlayerWeapon(playerid,22,999);
				GivePlayerWeapon(playerid,25,999);
				SCM(playerid,COLOR_GREEN,"[SUPPLY DELIVERER] Get in a Truck!");
			}
		}
		
	}
	return 1;
}

stock SetSpawnReady(playerid)
{
    SetCameraBehindPlayer(playerid);
	SetPlayerVirtualWorld(playerid,0);
	SetPlayerInterior(playerid,0);
	PlayerTextDrawHide(playerid,TDEditor_PTD[playerid]);
	TextDrawHideForPlayer(playerid,TDEditor_TD[0]); // testweise raus (unschuldig)
	TextDrawShowForPlayer(playerid,TDEditor_TD[1]);
	TogglePlayerControllable(playerid,true);
			
	return 1;
}
/*
forward NotifyPlayers();
public NotifyPlayers()
{
	for(new i = GetPlayerPoolSize(); i != -1; --i)
	{
		new team = GetPlayerTeam(playerid);
		new winners= Server[EtappenWinner];
		if(team == winners)
		{
			switch(winners
			{
			    case 1: SetPlayerCheckpoint(i,319.7451,-1814.7493,28.7061,12.0);  // LS Gewinnt
			    case 2: SetPlayerCheckpoint(i,-277.4837,-1446.3989,23.4118,12.0); // SF Gewinnt
			}
			
		}
		SCM(i,COLOR_RED,"Invade the Enemys Terroroty ");
        PlayerInfo[i][Notified]=true;
	}
}*/

stock GetMostPlanes()
{
	if(City[1][LuftFlugzeuge] > City[2][LuftFlugzeuge]) return 1;
	else if(City[1][LuftFlugzeuge] < City[2][LuftFlugzeuge]) return 2;
	else return 999;
}
stock RemoveBuildingsForPlayer(playerid)
{
	RemoveBuildingForPlayer(playerid,791,-54.83594,-1201.0547,0.21875,63.015308);
	printf("Alright");
	return 1;
}


stock GetAirSuperiority()
{
	if(City[1][Air_Superiority] > City[2][Air_Superiority]) return 1;
	else if(City[1][Air_Superiority] < City[2][Air_Superiority]) return 2;
	else return 999;
}

forward CheckAirWinners();
public CheckAirWinners()
{
	new karm,string[128],gewinner;
    if(Server[LandGefecht]==false && karm != 1)
    {
    	if(City[1][LuftFlugzeuge]==0 || City[2][LuftFlugzeuge]==0)
	    {
	        karm++;
     		gewinner = GetMostPlanes();
	        if(gewinner == 999)return 1; //SendClientMessageToAll(-1,"First 999");
	        else
	        {
	            Server[PreparePhase2]=true;
		        format(string,sizeof(string),"[SERVER]: Team %s lost the Battle due lack of Air Supplies",GetTeamName(GetEnemy(gewinner)));
		        SendClientMessageToAll(COLOR_LIGHTGREEN,string);
		        GameTextForAll("The Invasion Begins",5000,3);
		     	BurnAllPlanes();
				        //	SetTimer("NotifyPlayers",5000,0);

		   		Server[LandGefecht]=true;
		     	CreateCaptureFlag();
		       	SetTimer("SpawnEveryOneAndStartTimer",5000,0);
		       	Server[EtappenWinner]=gewinner;
				return 1;
			}
	    }
	    if(City[1][Air_Superiority]>=80 || City[2][Air_Superiority]>=80 )
	    {
	        karm++;
	        gewinner = GetAirSuperiority();
	        if(gewinner == 999)return SendClientMessageToAll(-1,"Second 999");
	        else
	        Server[PreparePhase2]=true;
	        format(string,sizeof(string),"[SERVER]: Team %s won the Battle with 80% Air Superiority",GetTeamName(gewinner));
	        SendClientMessageToAll(COLOR_LIGHTGREEN,string);
	        GameTextForAll("The Invasion Begins",5000,3);
	     	BurnAllPlanes();
			        //	SetTimer("NotifyPlayers",5000,0);
	   		Server[LandGefecht]=true;
	     	CreateCaptureFlag();
	       	SetTimer("SpawnEveryOneAndStartTimer",5000,0);
	       	Server[EtappenWinner]=gewinner;
			return 1;
	    }
 	}
 /*	if(karm > 0)
 	{
 		GameTextForAll("The Invasion Begins",5000,3);
     	BurnAllPlanes();
		        //	SetTimer("NotifyPlayers",5000,0);
      	
       	//Server[PreparePhase2]=true;
   		Server[LandGefecht]=true;
     	CreateCaptureFlag();
       	SetTimer("SpawnEveryOne",10000,0);
       	Server[EtappenWinner]=gewinner;
       	SendClientMessageToAll(-1,"Es wurde bestätigt");
       	return 1;
	}*/
	return 1;
}



forward SetInvalidDriver(vehicle);
public SetInvalidDriver(vehicle)
{
    LastDriver[vehicle] = INVALID_PLAYER_ID;
}


forward FindPlaneInterval(playerid);
public FindPlaneInterval(playerid)
{
    PutPlayerInPlane(playerid);
    TogglePlayerControllable(playerid,true);
}

forward FindTankInterval(playerid);
public FindTankInterval(playerid)
{
    PutPlayerInTank(playerid);
    TogglePlayerControllable(playerid,true);
}
forward SAMPRespawnVehicle(vehicle);
public SAMPRespawnVehicle(vehicle)
{
    SetVehicleToRespawn(vehicle);
   /* if(playerid !=INVALID_PLAYER_ID)
    {
        new Random;
        switch(GetPlayerTeam(playerid))
        {
	        case 1:
	        {
		        Random = random(sizeof(LSSpawns));
		       	SetPlayerPos(playerid, LSSpawns[Random][0], LSSpawns[Random][1], LSSpawns[Random][2]);
		       	SetPlayerFacingAngle(playerid, LSSpawns[Random][3]);
		       	SetPlayerColor(playerid,COLOR_YELLOW);
			}
			case 2:
	  		{
	    		Random = random(sizeof(SFSpawns));
	     		SetPlayerPos(playerid, SFSpawns[Random][0], SFSpawns[Random][1], SFSpawns[Random][2]);
	      		SetPlayerFacingAngle(playerid, SFSpawns[Random][3]);
	       		SetPlayerColor(playerid,COLOR_BLUE);
			}
		}	SetPlayerVirtualWorld(playerid,0);
	}*/
}
forward PutPlayerInPlane(playerid);
public PutPlayerInPlane(playerid)
{
	if(Server[LandGefecht]==true) return 1;
	if(IsPlayerInAnyVehicle(playerid)) return 1;
    new veh = GetFreePlane(playerid);
    if(veh == INVALID_VEHICLE_ID)
	{
		SCM(playerid,COLOR_LIGHTRED,"[SEARCHING PLANE] There was no free Plane found. Retrying in 5 Seconds..."); // COOLRED genutzt mal xD LOL SOL LANGE WTF
		SetTimerEx("Repeat",5000,0,"i",playerid);
		return 1;
	}
	PutPlayerInVehicle(playerid,veh,0);
	PlayerInfo[playerid][CarReady]=true;
	return 1;
}
forward PutPlayerInTank(playerid);
public PutPlayerInTank(playerid)
{
	if(Server[LandGefecht]==true) return 1;
	if(IsPlayerInAnyVehicle(playerid)) return 1;
    new veh = GetFreeTank(playerid);
    if(veh == INVALID_VEHICLE_ID)
	{
		SCM(playerid,COLOR_LIGHTRED,"[SEARCHING TANK] There was no free Tank found. Retrying in 5 Seconds..."); // COOLRED genutzt mal xD LOL SOL LANGE WTF
		SetTimerEx("Repeat",5000,0,"i",playerid);
		return 1;
	}
	PutPlayerInVehicle(playerid,veh,0);
	PlayerInfo[playerid][CarReady]=true;
	return 1;
}




forward Repeat(playerid);
public Repeat(playerid)
{
    PutPlayerInPlane(playerid);
}
stock CreateCaptureFlag()
{
    TDEditor_TD[1] = TextDrawCreate(524.333251, 415.918670, "");
	TextDrawTextSize(TDEditor_TD[1], 23.000000, 22.000000);
	TextDrawAlignment(TDEditor_TD[1], 1);
	TextDrawColor(TDEditor_TD[1], -1);
	TextDrawSetShadow(TDEditor_TD[1], 0);
	TextDrawBackgroundColor(TDEditor_TD[1], 1); // auch vorher 255
	TextDrawFont(TDEditor_TD[1], 5);
	TextDrawSetProportional(TDEditor_TD[1], 0);
	TextDrawSetPreviewModel(TDEditor_TD[1], 19306);
	TextDrawSetPreviewRot(TDEditor_TD[1], 0.000000, 0.000000, 0.000000, 1.000000);
	return 1;
}
stock BurnAllPlanes()
{
    for(new i = 0; i < MAX_VEHICLES; i++) // grl0e scheiss egal beide gleich groß LOL!
    {
        if(i!=INVALID_VEHICLE_ID)
        {
        	if(GetVehicleModel(i) == 476)
         	{
         	    SetVehicleHealth(i,0.0);
			}
		}
	}
}
stock DestroyAllPlanes()
{
    for(new i = 0; i < MAX_VEHICLES; i++) // grl0e scheiss egal beide gleich groß LOL!
    {
        if(i!=INVALID_VEHICLE_ID)
        {
        	if(GetVehicleModel(i) == 476)
         	{
         	    DestroyVehicle(i);
			}
		}
	}
}/*
stock GetFreePlane(playerid)
{
    new team = GetPlayerTeam(playerid);
    new
    color1,
    color2;
    for(new i = 0; i < MAX_VEHICLES; i++) // grl0e scheiss egal beide gleich groß LOL!
    {
        if(i!=INVALID_VEHICLE_ID)
        {
        	if(!IsVehicleOccupied(i) && GetVehicleModel(i) == 476)
         	{
          		if(team == 1)
				{
				    GetVehicleColor(i, color1, color2);
					if(color1 == 6 && color2 == 6)
					{
					    return i;
					}
				}
			 	if(team == 2)
				{
				    GetVehicleColor(i, color1, color2);
					if(color1 == 7 && color2 == 7)
					{
					    return i;
					}
				}
            }
        }
    }
    return INVALID_VEHICLE_ID;
}*/


stock GetFreePlane(playerid)
{
	new team = GetPlayerTeam(playerid);
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
		if(i!=INVALID_VEHICLE_ID)
		{
		    if(i == VehicleInfo[i][LocalID] && !IsVehicleOccupied(i) && VehicleInfo[i][neededJob] == GetPlayerJob(playerid))
		    {
		        new Float:health;
			    GetVehicleHealth(VehicleInfo[i][LocalID], health);
		        if(VehicleInfo[i][teamidd] == team && health >= 1000)
		        {
					new Float: vPosX, Float:vPosY,Float:vPosZ;
					GetVehiclePos(VehicleInfo[i][LocalID],vPosX,vPosY,vPosZ);
					if(IsPointInRangeOfPoint(vPosX,vPosY,vPosZ,286.9475,-1804.6365,5.0574,30.0) || IsPointInRangeOfPoint(vPosX,vPosY,vPosZ,-327.0711,-1424.0215,14.8314,30.0))
					{
		            	return VehicleInfo[i][LocalID];
					}
				}
			}
		}
	}
	return INVALID_VEHICLE_ID;
}


stock GetFreeTank(playerid)
{
	new team = GetPlayerTeam(playerid);
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
		if(i!=INVALID_VEHICLE_ID)
		{
		    if(i == VehicleInfo[i][LocalID] && !IsVehicleOccupied(i) && VehicleInfo[i][neededJob] == GetPlayerJob(playerid))
		    {
		        new Float:health;
			    GetVehicleHealth(VehicleInfo[i][LocalID], health);
		        if(VehicleInfo[i][teamidd] == team && health >= 1000)
		        {
					new Float: vPosX, Float:vPosY,Float:vPosZ;
					GetVehiclePos(VehicleInfo[i][LocalID],vPosX,vPosY,vPosZ);
					if(IsPointInRangeOfPoint(vPosX,vPosY,vPosZ,286.9475,-1804.6365,5.0574,30.0) || IsPointInRangeOfPoint(vPosX,vPosY,vPosZ,-327.0711,-1424.0215,14.8314,30.0))
					{
		            	return VehicleInfo[i][LocalID];
					}
				}
			}
		}
	}
	return INVALID_VEHICLE_ID;
}


stock GetPlayerJob(playerid)
{
	return PlayerInfo[playerid][pJob];
}
stock IsPointInRangeOfPoint(Float:x, Float:y, Float:z, Float:x2, Float:y2, Float:z2, Float:range)
{
    x2 -= x;
    y2 -= y;
    z2 -= z;
    return ((x2 * x2) + (y2 * y2) + (z2 * z2)) < (range * range);
}



stock GetTeamPlayers(teamid)
{
	new count;
    for(new i = GetPlayerPoolSize(); i != -1; --i)
    {
        if(GetPlayerTeam(i)==255)continue;
        
        if(GetPlayerTeam(i) == teamid)
        count++;
	}
	return count;
}
stock GetOnlinePlayers()
{
    new count;
    for(new i = GetPlayerPoolSize(); i != -1; --i)
    {
        if(IsPlayerConnected(i) && !IsPlayerNPC(i))
        count++;
	}
	return count;
}
stock PrepareGameMode()
{
    Capture[0][owner] = 2;
    Capture[1][owner] = 2;
    Capture[2][owner] = 2;
    Capture[3][owner] = 2;
    Capture[4][owner] = 1;
    Capture[5][owner] = 1;
    Capture[6][owner] = 1;
    Capture[7][owner] = 1;
    Capture[0][baseid] = 0;
    Capture[1][baseid] = 1;
    Capture[2][baseid] = 2;
    Capture[3][baseid] = 3;
    Capture[4][baseid] = 4;
    Capture[5][baseid] = 5;
    Capture[6][baseid] = 6;
    Capture[7][baseid] = 7;
    Server[LandGefecht]=false;
    Server[CanSpawn]=false;
    Server[FiveSecondStart]=false;
    City[1][LuftFlugzeuge]=55;  // temp vorher 55
    City[2][LuftFlugzeuge]=55;
    
    City[1][Air_Superiority]=50;
    City[2][Air_Superiority]=50;
    
    Server[Prepared]=true;
    
    Server[EtappenWinner]=255;
    
    City[1][Captured]=0;
    City[2][Captured]=0;
    
    City[1][Defended]=0;
    City[2][Defended]=0;
    
    Server[Minuten]=2;
    Server[Sekunden]=0;
    
    
    // Flugzeuge

//	LSflugzeuge[0] = AddStaticVehicle(476,1989.3309,-2249.7639,14.9342,90.0630,6,6);


   // VehicleInfo[1][LocalID] =

	VehicleInfo[1][LocalID] = AddStaticVehicle(476,286.8562,-1862.9209,3.5516,91.1361,6,6);  // Ls Flugzeuge

	VehicleInfo[2][LocalID] = AddStaticVehicle(476,286.9519,-1850.8475,3.9125,89.8315,6,6);

	VehicleInfo[3][LocalID] = AddStaticVehicle(476,287.1361,-1839.1473,4.2506,89.3586,6,6);

	VehicleInfo[4][LocalID] = AddStaticVehicle(476,287.3204,-1827.7021,4.5636,90.4841,6,6);

	VehicleInfo[5][LocalID] = AddStaticVehicle(476,287.3728,-1816.0518,4.8671,89.5865,6,6);

	VehicleInfo[6][LocalID] = AddStaticVehicle(476,286.9475,-1804.6365,5.0574,91.0835,6,6);

	VehicleInfo[7][LocalID] = AddStaticVehicle(476,286.5289,-1792.8777,5.0208,91.3815,6,6);

	VehicleInfo[8][LocalID] = AddStaticVehicle(476,306.5972,-1856.7286,3.8510,90.2504,6,6);

	VehicleInfo[9][LocalID] = AddStaticVehicle(476,306.6064,-1845.3405,4.1526,90.2081,6,6);

	VehicleInfo[10][LocalID] = AddStaticVehicle(476,306.6231,-1833.8168,4.4865,90.3218,6,6);

	VehicleInfo[11][LocalID] = AddStaticVehicle(476,302.5186,-1822.0491,4.7776,91.5145,6,6);

	VehicleInfo[12][LocalID] = AddStaticVehicle(476,302.4044,-1810.0698,5.0715,90.3324,6,6);
	
	VehicleInfo[1][teamidd]= 1;
	VehicleInfo[2][teamidd]= 1;
	VehicleInfo[3][teamidd]= 1;
	VehicleInfo[4][teamidd]= 1;
	VehicleInfo[5][teamidd]= 1;
	VehicleInfo[6][teamidd]= 1;
	VehicleInfo[7][teamidd]= 1;
	VehicleInfo[8][teamidd]= 1;
	VehicleInfo[9][teamidd]= 1;
	VehicleInfo[10][teamidd]= 1;
	VehicleInfo[11][teamidd]= 1;
	VehicleInfo[12][teamidd]= 1;
	



	VehicleInfo[13][LocalID] = AddStaticVehicleEx(476,-327.0711,-1424.0215,14.8314,271.4219,8,8,12);  // SF Flugzeuge

	VehicleInfo[14][LocalID] = AddStaticVehicle(476,-326.8553,-1410.8499,14.7713,266.5722,7,7);

	VehicleInfo[15][LocalID] = AddStaticVehicle(476,-326.2861,-1398.3126,13.9737,267.8988,7,7);

	VehicleInfo[16][LocalID] = AddStaticVehicle(476,-325.2201,-1386.6586,12.9594,266.8053,7,7);


	VehicleInfo[17][LocalID] = AddStaticVehicle(476,-407.5030,-1391.6349,24.1916,281.9602,7,7);

	VehicleInfo[18][LocalID] = AddStaticVehicle(476,-416.5064,-1375.1812,24.2779,282.8986,7,7);

	VehicleInfo[19][LocalID] = AddStaticVehicle(476,-416.2974,-1358.1239,24.6949,280.7294,7,7);

	VehicleInfo[20][LocalID] = AddStaticVehicle(476,-418.6104,-1342.5516,25.9786,280.9048,7,7);

	VehicleInfo[21][LocalID] = AddStaticVehicle(476,-417.3068,-1328.1924,27.5177,279.2845,7,7);

	VehicleInfo[22][LocalID] = AddStaticVehicle(476,-418.3099,-1314.1429,29.7785,272.0164,7,7);

//	SFflugzeuge[11] = AddStaticVehicle(476,-417.9878,-1297.4380,31.8950,263.3316,7,7);

    VehicleInfo[23][LocalID] = AddStaticVehicle(476,-417.3089,-1293.1337,32.5913,271.4613,7,7);

	VehicleInfo[24][LocalID] = AddStaticVehicle(476,-418.2881,-1280.0403,35.3042,275.0225,7,7);
    
    VehicleInfo[13][teamidd]= 2;
	VehicleInfo[14][teamidd]= 2;
	VehicleInfo[15][teamidd]= 2;
	VehicleInfo[16][teamidd]= 2;
	VehicleInfo[17][teamidd]= 2;
	VehicleInfo[18][teamidd]= 2;
	VehicleInfo[19][teamidd]= 2;
	VehicleInfo[20][teamidd]= 2;
	VehicleInfo[21][teamidd]= 2;
	VehicleInfo[22][teamidd]= 2;
	VehicleInfo[23][teamidd]= 2;
	VehicleInfo[24][teamidd]= 2;
	
	
	for(new v = 0; v<25; v++)
	{
	    if(GetVehicleModel(VehicleInfo[v][LocalID]) == 476)
	    {
			VehicleInfo[v][neededJob] = 1;// for Pilots
		}
	}
	
	
	
	// LS Barracks + Panzer
	
	
	VehicleInfo[25][LocalID] = AddStaticVehicle(433,463.5969,-1813.2545,5.9832,269.5406,77,77);
    VehicleInfo[26][LocalID] = AddStaticVehicle(433,414.2048,-1824.7388,5.5945,359.3375,77,77); // barrack2LS
    VehicleInfo[27][LocalID] = AddStaticVehicle(433,460.2543,-1831.6183,5.2234,4.9846,77,77); // barrack3LS
	
    VehicleInfo[25][teamidd]= 1;
	VehicleInfo[26][teamidd]= 1;
	VehicleInfo[27][teamidd]= 1;
	
	
	
	// SF Barracks + Panzer
    
    VehicleInfo[28][LocalID] = AddStaticVehicle(433,-86.2795,-1223.4944,3.0817,81.3939,77,77); // barrack1SF
    VehicleInfo[29][LocalID] = AddStaticVehicle(433,-89.0194,-1259.2354,2.2377,103.5382,77,77); // barrack2SF
    VehicleInfo[30][LocalID] = AddStaticVehicle(433,-109.6278,-1203.6272,3.3013,76.1915,77,77); // barrack3SF

    VehicleInfo[28][teamidd]= 2;
	VehicleInfo[29][teamidd]= 2;
	VehicleInfo[30][teamidd]= 2;
	
	
	
	
	for(new v = 25; v<31; v++)
	{
	    if(GetVehicleModel(VehicleInfo[v][LocalID]) == 433)
	    {
			VehicleInfo[v][neededJob] = 3;// for Supply Drivers ( Barrack )
		}
	}
    

    
}
stock GetTeamName(id)
{
	new name[3];
	switch(id)
	{
	    case 1: name = "LS";
	    case 2: name = "SF";
	}
	return name;
}/*
stock GetCarFunctionNew(carid)
{
    new
    color1,
    color2;
	GetVehicleColor(carid, color1, color2);
	if(color1 == 6 && color2 == 6)
	{
		return 1;
	}
	else if(color1 == 7 && color2 == 7)
	{
		return 2;
	}
	return 0;
}*/
stock GetCarFunctionNew(vehicle)
{
  //  new team = GetPlayerTeam(playerid);
    for(new i = 0; i < MAX_VEHICLES; i++)
	{
		if(i!=INVALID_VEHICLE_ID)
		{
		    if(vehicle == VehicleInfo[i][LocalID])
		    {
		        return VehicleInfo[i][teamidd];
			}
		}
	}
	return 0; // oder 255 musste abfrage ändern
}



stock GetVehicleType(vehicle)
{
  //  new team = GetPlayerTeam(playerid);
    for(new i = 0; i < MAX_VEHICLES; i++)
	{
		if(i!=INVALID_VEHICLE_ID)
		{
		    if(vehicle == VehicleInfo[i][LocalID])
		    {
		        return VehicleInfo[i][vehType];
			}
		}
	}
	return 0; // oder 255 musste abfrage ändern
}


stock GetVehicleVehicleInfo(vehicle)
{
    for(new i = 0; i < MAX_VEHICLES; i++)
	{
		if(i!=INVALID_VEHICLE_ID)
		{
		    if(vehicle == VehicleInfo[i][LocalID])
		    {
		        return i;
			}
		}
	}
	return -1; // kein VehicleInfo Fahrzeug!
}

stock randomEx(min, max)
{
    //Credits to ******
    new rand = random(max-min)+min;
    return rand;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    PlayerInfo[playerid][pDeaths]++;
    
    GetPlayerPos(playerid,PlayerInfo[playerid][DeadPosX],PlayerInfo[playerid][DeadPosY],PlayerInfo[playerid][DeadPosZ]);
    SendDeathMessage(killerid, playerid, reason);
    PlayerInfo[playerid][pInCP]=-1;
    PlayerInfo[playerid][pDead]=true;
    PlayerInfo[playerid][AlreadySpawned]=false;
	SCM(playerid,COLOR_LIGHTRED,"You died!");
	PlayerTextDrawHide(playerid,TDEditor_PTD[playerid]); // Eigene Team Flugzeuge (Luftschlacht)
	TextDrawHideForPlayer(playerid,TDEditor_TD[0]); // FlugZeug Symbol ( LuftSchlacht) // testweise raus (unschuldig)
	TextDrawHideForPlayer(playerid,TDEditor_TD[1]); // Flagge (LandGefecht)
	PlayerTextDrawHide(playerid,TeamCapturePoints[playerid]);
	
	
	if(killerid != INVALID_PLAYER_ID && killerid != playerid)
	{
	    PlayerInfo[killerid][pKills]++;
	    PlayerInfo[killerid][pScore]++;
	    GivePlayerMoneySave(killerid,1250);
	    GameTextForPlayer(killerid,"FIGHT-KILL",3000,3);
	}
//	TeamCapturePoints
	if(Server[PreparePhase2]==true)
	{
	    PlayerInfo[playerid][AlreadySpawned]=true;
	  //  SCM(playerid,-1,"Xeee");
	}
	return 1;
}
public OnVehicleSpawn(vehicleid)
{
    if(Server[LandGefecht]==true) // dort BAFRAGEEE
    {
        if(GetCarFunctionNew(vehicleid == 1 || vehicleid == 2))
        {
            DestroyVehicle(vehicleid);
		}
	}
	return 1;
}
/*
GetCarFunction(carid)
{
    for(new i = 0; i < sizeof(LSflugzeuge); i++)
    {
        if(carid == LSflugzeuge[i])
        {
            return 1;
        }
    }
    for(new j; j < sizeof(SFflugzeuge); j++)
    {
        if(carid == SFflugzeuge[j])
        {
            return 2;
        }
    }
    return 0;
}
*/
stock GetPlayerFromDeadCar(vehicleid)
{
    for(new i = GetPlayerPoolSize(); i != -1; --i)
    //for(new i;i<GetMaxPlayers();i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(IsPlayerInVehicle(i,vehicleid) && GetPlayerState(i) == PLAYER_STATE_DRIVER)
	        {
	            return i;
			}
		}
	}
	return INVALID_PLAYER_ID;
//	return 999;
}

stock GetVehicleDriver(vehicleid) {
	for(new i; i <= GetPlayerPoolSize(); i++) {
		if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) {
			if(GetPlayerVehicleID(i) == vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER)
				return i;
		}
	}
	return INVALID_PLAYER_ID;
}

stock IsTeamMate(playerid)
{
    if(GetPlayerTeam(playerid) == 1 || GetPlayerTeam(playerid) == 2) return 1;
    else return 0;
}
public OnVehicleDeath(vehicleid, killerid)
{
    new playerid = LastDriver[vehicleid];
	if(GetCarFunctionNew(vehicleid) !=0 && Server[LandGefecht]==false)
	{
		//new playerid = GetVehicleDriver(vehicleid);
		
//		new string[128];
		if(playerid == INVALID_PLAYER_ID) return 1;//SendClientMessageToAll(-1,"Nicht Erfolgt.");
		
//		SetPlayerHealth(playerid,0);
		new team = GetPlayerTeam(playerid);
		new teamenemy = GetEnemy(team);
//	    SCM(playerid,-1,"Du bist der täter");
		if(killerid == INVALID_PLAYER_ID)
		{
			if(IsTeamMate(playerid))
			{
		    	City[team][LuftFlugzeuge]--;
		    	City[team][Air_Superiority]--;
		    	City[teamenemy][Air_Superiority]++;
			}
		}
	    if(GetPlayerTeam(killerid)!=255 && killerid != INVALID_PLAYER_ID)
	    {
			new opfer=GetPlayerTeam(playerid),teamyo=GetEnemy(opfer);
			
			City[teamyo][Air_Superiority]++;
			
			City[opfer][Air_Superiority]--;
			
			City[opfer][LuftFlugzeuge]--;
			
			//GiveMoneySave (Killerod)
		}
		SetTimerEx("SAMPRespawnVehicle",2500,0,"i",vehicleid);

		
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return SendClientMessage(playerid,COLOR_RED,"Unknown Command! Use /Help");
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{

	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	SetTimerEx("SetInvalidDriver",1000,0,"i",vehicleid);
    
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate&PLAYER_STATE_DRIVER)
	{
	    new veh = GetPlayerVehicleID(playerid);
	    if(GetCarFunctionNew(veh) != GetPlayerTeam(playerid)&&GetCarFunctionNew(veh) !=0)
	    {
			RemovePlayerFromVehicle(playerid);
			SCM(playerid,COLOR_LIGHTRED,"You have no access to this Vehicle");
			return 1;
		}
		if(GetPlayerVehicleID(playerid) !=INVALID_VEHICLE_ID)
		{
		    LastDriver[GetPlayerVehicleID(playerid)] = playerid;
		    LastCar[playerid] = GetPlayerVehicleID(playerid);
		}
		if(GetVehicleModel(veh) == 476)
		{
		    ShowPlayerBox(playerid,"Use SPACE to drop one Bomb. Press ALT to drop a bunch of bombs.",5);
		}
	}
	if(newstate & PLAYER_STATE_ONFOOT)
	{
	    DeletePVar(playerid,"DroppingBombs");
		DeletePVar(playerid,"DroppingFrom");

		DeletePVar(playerid,"DropTime");
	}
	/*
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
		if(LastCar[playerid]!=INVALID_VEHICLE_ID)
		{
		    if(GetVehicleModel(LastCar[playerid]) != 476)return 1;
		    if(Server[LandGefecht]==false && PlayerInfo[playerid][CarReady]==true)
			{
				SetPlayerHealth(playerid,0.0);
				SCM(playerid,COLOR_LIGHTRED,"You were killed by enemys Fire. Don't leave your Airplane before the Invasion!");
				if(LastCar[playerid]!=INVALID_VEHICLE_ID)
				{
					SetVehicleToRespawn(LastCar[playerid]);
				}
			//	SpawnPlayer(playerid);
			}
		}
	}*/
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(Server[FiveSecondStart]==true)
	{
 		SCM(playerid,COLOR_LIGHTRED,"Please wait a Second, the Game Mode is starting...");
 		return 0;
	}
	if(PlayerInfo[playerid][pLoggedIn]==0)
	{
 		SCM(playerid,COLOR_LIGHTRED,"You are not logged in!");
 		return 0;
	}
	new jobid = GetPlayerClassJob(playerid,GetPlayerSkin(playerid));
	if(jobid == 3 && GetPlayerScore(playerid) < miniumScore_pilot)
	{
	 	SCM(playerid,COLOR_RED,"[Choosing Job] You need at least 100 XP to do this Job.");
	 	return 0;
	}
	PlayerInfo[playerid][pJob] = jobid;
	
	PlayerInfo[playerid][pClassSelection]=false;
//	SpawnPlayer(playerid);
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}
stock Float:GetDistanceBetweenPoints3D(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2){
    return VectorSize(x1-x2,y1-y2,z1-z2);
}
stock Float:GetDistanceBetweenPoints(Float:x1f,Float:y1f,Float:z1f,Float:x2f,Float:y2f,Float:z2f)
{
	return floatadd(floatadd(floatsqroot(floatpower(floatsub(x1f,x2f),2)),floatsqroot(floatpower(floatsub(y1f,y2f),2))),floatsqroot(floatpower(floatsub(z1f,z2f),2)));
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_HANDBRAKE)
	{
	    //SCM(playerid,-1,"Key SpRINT!");
	    if(IsPlayerInAnyVehicle(playerid) && !DroppingBombs[playerid])
	    {
	        //SCM(playerid,-1,"Key SpRINT! Vehicle."); KEY_WALK
	        new veh = GetPlayerVehicleID(playerid);
	        new model = GetVehicleModel(GetPlayerVehicleID(playerid));
	        if(model == 476 && GetVehicleType(veh) == 0)
	        {
	        	SCM(playerid,-1,"yes#1");
	        	DropBomb(playerid,0);
		 	}
		}
	}
	if(newkeys & KEY_SECONDARY_ATTACK)
	{
 		if(PlayerInfo[playerid][IsConfiguringArtillery])
		{
		    new arte_id = GetPVarInt(playerid,"ArtilleryID");
			printf("Arte ID KEY_SECONDAR_ATTACK : %d", arte_id);
		    if(arte_id == -1)
		    {
		        SetPlayerCamera(playerid, 0);
		        PlayerInfo[playerid][IsConfiguringArtillery] = false;
		        HideBox(playerid);
		        SetPlayerPos(playerid,Artillery[arte_id][Art_PositonX]-1,Artillery[arte_id][Art_PositonY],Artillery[arte_id][Art_PositonZ]);
			}
			else
			{
			    new Float:distance = GetDistanceBetweenPoints3D(Artillery[arte_id][Art_PositonX],Artillery[arte_id][Art_PositonY],Artillery[arte_id][Art_PositonZ],PlayerInfo[playerid][pTargetArtPos_X],PlayerInfo[playerid][pTargetArtPos_Y],PlayerInfo[playerid][pTargetArtPos_Z]);

			    if(distance < 60.0 || distance > 500.0) return SCM(playerid,COOLRED,"[Select Target] The Artillery can't reach this point (Range: 60m-500m)");
				Artillery[arte_id][TargetPointX] = PlayerInfo[playerid][pTargetArtPos_X];
	        	Artillery[arte_id][TargetPointY] = PlayerInfo[playerid][pTargetArtPos_Y];
	        	Artillery[arte_id][TargetPointZ] = PlayerInfo[playerid][pTargetArtPos_Z];
	        	HideBox(playerid);
	        	SetPlayerCamera(playerid, 0);
		        PlayerInfo[playerid][IsConfiguringArtillery] = false;
		        SetPlayerPos(playerid,Artillery[arte_id][Art_PositonX]-1,Artillery[arte_id][Art_PositonY],Artillery[arte_id][Art_PositonZ]);
			}
		}
	}
	new dropbombs = GetPVarInt(playerid,"DroppingBombs");
	if(newkeys & KEY_FIRE && dropbombs == 0)
	{
	    if(IsPlayerInAnyVehicle(playerid) && !DroppingBombs[playerid])
	    {
	        new veh = GetPlayerVehicleID(playerid);
	        new model = GetVehicleModel(GetPlayerVehicleID(playerid));
	        if(model == 476 && GetVehicleType(veh) == 0)
	        {
	        	DropBomb(playerid,1);
		 	}
		}
	}
	
	if(newkeys & KEY_FIRE && GetPlayerState(playerid == PLAYER_STATE_ONFOOT))
	{
	    for(new i = 0; i<sizeof(Artillery);i++)
		{
			if(Artillery[i][artid]!=-1)
	    	{
	    	    if(IsPlayerInRangeOfPoint(playerid,6.0,Artillery[i][Art_PositonX],Artillery[i][Art_PositonY],Artillery[i][Art_PositonZ]))
		        {
		            SetPVarInt(playerid,"ArtilleryID",i);
		            printf("Arte ID KEYFIRE : %d", i);
		            ShowPlayerDialog(playerid,DIALOG_CONFIG_ARTILLERY,DIALOG_STYLE_LIST,"Configure Artillery","Set Target Position\nStart/Stop","Execute","Exit");
		    	}
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{/*
	if(PlayerInfo[playerid][SpswnProtected]==1)
	{
	    SetPlayerHealth(playerid,80.0);
	}
 	*/
 	
 	
 	new dropbombs = GetPVarInt(playerid,"DroppingBombs");
	new i = GetPVarInt(playerid,"DroppingFrom");
	
	new Float:droptime = GetPVarFloat(playerid,"DropTime");
	
	if(dropbombs > 0)
	{
	   // printf("DEBUG: EINS: Spieler %s, dropbombs: %d, droptime: %f,gettime: %d, Fahrzeug: %i",GetName(playerid),dropbombs, droptime,gettime(), i);
		if(VehicleInfo[i][LocalID]!=INVALID_VEHICLE_ID)
		{
		  //  printf("DEBUG: ZWEI: Spieler %s, dropbombs: %d, droptime: %f, gettime: %d Fahrzeug: %i",GetName(playerid),dropbombs, droptime,gettime(), i);
	/*		if(gettime() > droptime)
			{*/
			  //  printf("DEBUG: DREI: Spieler %s, dropbombs: %d, droptime: %f, gettime: %d Fahrzeug: %i",GetName(playerid),dropbombs, droptime, gettime(),i);
   				DropBomb(playerid,0);
   				droptime = gettime()+1;
   				
   				SetPVarFloat(playerid,"DropTime",droptime);
	//		}
		}
		
		// bei aussteignne zurcüsketzen
	}
	
	
	if (g_FlyMode[playerid][flyType] == 1 && PlayerInfo[playerid][IsConfiguringArtillery])
	{
	    new
            Float:fPX, Float:fPY, Float:fPZ,
            Float:fVX, Float:fVY, Float:fVZ,
            Float:object_x, Float:object_y, Float:object_z;
            
        const
            Float:fScale = 35.0;

        GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
        GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
        
        object_x = fPX + floatmul(fVX, fScale);
        object_y = fPY + floatmul(fVY, fScale);
        object_z = fPZ + floatmul(fVZ, fScale);
        
        SetPlayerCheckpoint(playerid,object_x, object_y, object_z,8.0);
        
        PlayerInfo[playerid][pTargetArtPos_X] = object_x;
        PlayerInfo[playerid][pTargetArtPos_Y] = object_y;
        PlayerInfo[playerid][pTargetArtPos_Z] = object_z;
        
        ShowPlayerBox(playerid,"Press ENTER to select a positon.",-1);
	}
	return 1;
}
/*
forward OnPlayerDeathEx(playerid,killerid,reason);
public OnPlayerDeathEx(playerid,killerid,reason)
{
    PlayerInfo[playerid][pInCP]=-1;
    PlayerInfo[playerid][pDead]=true;
    PlayerInfo[playerid][AlreadySpawned]=false;
	SCM(playerid,COLOR_LIGHTRED,"You died!");
	PlayerTextDrawHide(playerid,TDEditor_PTD[playerid]); // Eigene Team Flugzeuge (Luftschlacht)
	TextDrawHideForPlayer(playerid,TDEditor_TD[0]); // FlugZeug Symbol ( LuftSchlacht) // testweise raus (unschuldig)
	TextDrawHideForPlayer(playerid,TDEditor_TD[1]); // Flagge (LandGefecht)
	PlayerTextDrawHide(playerid,TeamCapturePoints[playerid]); // TeamPunkte (LandGefecht)
	
	
 //	SetPlayerPos(playerid,PlayerInfo[playerid][DeadPosX],PlayerInfo[playerid][DeadPosY],PlayerInfo[playerid][DeadPosZ]);

	SetPlayerInterior(playerid,0);
 	SetPlayerVirtualWorld(playerid,0);


	SetCameraBehindPlayer(playerid);
 	ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,1,1,1,0);
 	TogglePlayerControllable(playerid,false);
	ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,1,1,1,0);
  //  SetTimerEx("SpawnTimer", 6000, 0,"i",playerid);
	
	
}*/

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
  /*  new Float:health;
    GetPlayerHealth(playerid,health);
    if(PlayerInfo[playerid][pDead]!=true)
	{
	    if (health < 2.0  && Server[ModeStarted]==true && PlayerInfo[playerid][pClassSelection]==false && PlayerInfo[playerid][pLoggedIn]==1)
	    {
	        GetPlayerPos(playerid,PlayerInfo[playerid][DeadPosX],PlayerInfo[playerid][DeadPosY],PlayerInfo[playerid][DeadPosZ]);
			SetTimerEx("OnPlayerDeathEx",100,0,"i",playerid,issuerid,weaponid);
	    }
	}*/
	
	if(GetPlayerTeam(playerid) == GetPlayerTeam(issuerid))
	{
    	return 0;
	}
	else return 1;
}
public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_CONFIG_ARTILLERY:
	    {
	        if(!response) return 0;
	        new arte_id = GetPVarInt(playerid,"ArtilleryID");
	        switch(listitem)
	        {
				case 0: // set target position
				{
				    SetPlayerCamera(playerid, 1);  // set in Flymode
				    PlayerInfo[playerid][IsConfiguringArtillery] = true;
				}
				case 1:
				{
				    if(!Artillery[arte_id][isEnabled]) return SCM(playerid,COOLRED,"[Artillery] This Artillery is destroyed or was deactivated.");
                    if(Artillery[arte_id][ammuNition] <=0) return SCM(playerid,COOLRED,"[Artillery] This Artillery ran out of ammu nition.");
				    if(Artillery[arte_id][activeShooting])
				    {
				        Artillery[arte_id][activeShooting] = false;
				        SCM(playerid,COLOR_GREY,"[Artillery] Artillery {FF0000}disabled");
					}
					else
					{
					    Artillery[arte_id][activeShooting] = true;
					    SCM(playerid,COLOR_GREY,"[Artillery] Artillery {04B404}enabled");
					}
				}
			}
		}
	}
    if(dialogid == DIALOG_TUTORIAL)
	{
	    if(!response) return Kick(playerid);
     	new sstring[512];
 	    switch(PlayerInfo[playerid][pTutStep])
 	    {
	 	    case 2: // Zeige Dialog 2
	 	    {
	 	        
	 	    	SetPlayerCameraPos(playerid,-337.9100,-1217.6211,78.0643);
	 	    	SetPlayerCameraLookAt(playerid,-200.0253,-1455.4664,15.7106);


				strcat(sstring,"{FFFFFF}Our server is based on a ""round system"".\n");
				strcat(sstring,"{FFFFFF}San Fierro (pictured here) is fighting against Los Santos.\n");
				strcat(sstring,"{FFFFFF}Both sides are completely the same strong, the only advantages are in the strategic positions on their own side, which everyone can exploit for his own benefit.\n");
	 	    	ShowPlayerDialog(playerid,DIALOG_TUTORIAL,DIALOG_STYLE_MSGBOX,"{FFFFFF}Tutorial 2/4",sstring,"{58D3F7}Next","Leave");
	 	    	PlayerInfo[playerid][pTutStep]=3;
			}
			case 3: // Zeige Dialog 3
	 	    {

	 	    	SetPlayerCameraPos(playerid,299.9666,-1894.1281,12.0792);
	 	    	SetPlayerCameraLookAt(playerid,228.8795,-1780.4327,4.2971);


				strcat(sstring,"{FFFFFF}The Gamemode consists of two phases: First: Gain the air superiority in San Andreas\n");
				strcat(sstring,"{FFFFFF}Second: Take Place in your plane and fight in a heated battle for the superiority of your own Team!\n");
				strcat(sstring,"{FFFFFF}The more Enemy aircraft you shoot, the more air superiority your team gets.\n");
				strcat(sstring,"{FFFFFF}Should your team run out of planes beforehand, you lose immediately.");
				
				
	 	    	ShowPlayerDialog(playerid,DIALOG_TUTORIAL,DIALOG_STYLE_MSGBOX,"{FFFFFF}Tutorial 3/4",sstring,"{58D3F7}Next","Leave");
	 	    	PlayerInfo[playerid][pTutStep]=4;
			}
			case 4: // Zeige Dialog 3
	 	    {

	 	    	SetPlayerCameraPos(playerid,299.9666,-1894.1281,12.0792);
	 	    	SetPlayerCameraLookAt(playerid,228.8795,-1780.4327,4.2971);


				strcat(sstring,"{FFFFFF}If a team manages to secure air superiority, the land invasion starts. \n");
				strcat(sstring,"{FFFFFF}The Team that conquers first all enemy checkpoints, wins.\n");

	 	    	ShowPlayerDialog(playerid,DIALOG_TUTORIAL,DIALOG_STYLE_MSGBOX,"{FFFFFF}Tutorial 4/4",sstring,"{58D3F7}Next","Leave");
	 	    	PlayerInfo[playerid][pTutStep]=5;
			}
			case 5: // Zeige Dialog 3
	 	    {

	 	    	SetPlayerCameraPos(playerid,299.9666,-1894.1281,12.0792);
	 	    	SetPlayerCameraLookAt(playerid,228.8795,-1780.4327,4.2971);


				strcat(sstring,"{FFFFFF}And thats it! \n");
				strcat(sstring,"{FFFFFF}Thanks for reading this Tutorial! We are spawning you in 3 Seconds...\n");

	 	    	ShowPlayerDialog(playerid,DIALOG_TUTORIAL,DIALOG_STYLE_MSGBOX,"{FFFFFF}Tutorial Emd",sstring,"{58D3F7}End","Leave");
	 	    	PlayerInfo[playerid][pTutStep]=0;
	 	    	PlayerInfo[playerid][pTutorial]=0;
	 	    	SetTimerEx("SpawnTimer", 3000, 0,"i",playerid);
			}
		}

	}
    if(dialogid == DIALOG_REGISTER)
	{
		if(!response) return Kick(playerid);
		if(strlen(inputtext) < 3) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration", "Please register:\n{FF0000}3 letters!", "Register", "Cancel");
		new query[256];
		mysql_format(handle, query, sizeof(query), "INSERT INTO accountsy (name, password) VALUES ('%e', MD5('%e'))", PlayerInfo[playerid][pName], inputtext);
		mysql_pquery(handle, query, "OnUserRegister", "d", playerid);
		return 1;
	}
	if(dialogid == DIALOG_LOGIN)
	{
		if(!response) return Kick(playerid);
		if(strlen(inputtext) < 3) return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Please login:\n{FF0000}Mindestens 3 Zeichen!", "Login", "Cancel");
		new query[256];
		mysql_format(handle, query, sizeof(query), "SELECT * FROM accountsy WHERE name = '%e' AND password = MD5('%e')", PlayerInfo[playerid][pName], inputtext);
		mysql_pquery(handle, query, "OnUserLogin", "d", playerid);
		return 1;
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

forward OnUserRegister(playerid);
public OnUserRegister(playerid)
{
	//Der Spieler wurde in die Datenbank eingetragen, es wird die id ausgelesen
	PlayerInfo[playerid][p_id] = cache_insert_id();
	PlayerInfo[playerid][pLoggedIn]  = 1;
	SendClientMessage(playerid, 0x00FF00FF, "[Account] Registration successful.");
	PlayerInfo[playerid][pTutorial]  = 1;
	PlayerInfo[playerid][pTutStep]=1;
	return 1;
}

forward OnUserLogin(playerid);
public OnUserLogin(playerid)
{
	//Query wurde ausgeführt und das Ergebnis im Cache gespeichert
	new rows;
	cache_get_row_count(rows);
	if(rows == 0)
	{
		//Der Spieler hat ein falsches Passwort eingegeben
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Please log in :\n{FF0000}Wrong Password!", "Try again", "Cancel");
	}
	else
	{
		//Es existiert ein Ergebnis, das heißt der Spieler hat das richtige Passwort eingegeben
		//Wir lesen nun die erste Zeile des Caches aus (ID 0)
 		cache_get_value_name_int(0, "p_id", PlayerInfo[playerid][p_id]);
		cache_get_value_name_int(0, "score", PlayerInfo[playerid][pScore]);
		cache_get_value_name_int(0, "money", PlayerInfo[playerid][pMoney]);
		cache_get_value_name_int(0, "kills", PlayerInfo[playerid][pKills]);
		cache_get_value_name_int(0, "deaths", PlayerInfo[playerid][pDeaths]);
		cache_get_value_name_int(0, "pTutorial", PlayerInfo[playerid][pTutorial]);
		cache_get_value_name_int(0, "pAdmin", PlayerInfo[playerid][pAdmin]);
		
		SetPlayerScore(playerid,PlayerInfo[playerid][pScore]);
		PlayerInfo[playerid][pLoggedIn]  = 1;
		SendClientMessage(playerid, 0x00FF00FF, "[Account] You logged in.");
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
	}
	return 1;
}
forward OnUserCheck(playerid);
public OnUserCheck(playerid)
{
	//Query wurde ausgeführt und das Ergebnis im Cache gespeichert
	new rows;
	cache_get_row_count(rows);
	if(rows == 0)
	{
		//Der Spieler konnte nicht gefunden werden, er muss sich registrieren
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration", "Pleae register:", "Register", "Cancel");
	}
	else
	{
		//Es existiert ein Ergebnis, das heißt der Spieler ist registriert und muss sich einloggen
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Please login:", "Login", "Cancel");
	}
	return 1;
}
stock SaveUserStats(playerid)
{
	//Wenn der Spieler nicht eingeloggt ist, dann speichere seine Statistiken nicht
	if(!PlayerInfo[playerid][pLoggedIn]) return 1;

	//Ansonsten speichere sie
	new query[256];
	mysql_format(handle, query, sizeof(query), "UPDATE accountsy SET score = '%d', money = '%d', kills = '%d', deaths = '%d',pTutorial = '%d', pAdmin='%d' WHERE name = '%s'",
		PlayerInfo[playerid][pScore], PlayerInfo[playerid][pMoney], PlayerInfo[playerid][pKills], PlayerInfo[playerid][pDeaths],PlayerInfo[playerid][pTutorial], PlayerInfo[playerid][pAdmin],PlayerInfo[playerid][pName]);

	//Das Query wird abgesendet
	mysql_pquery(handle, query);
	return 1;
}
stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,name,sizeof(name));
    return name;
}
stock ResetPlayerVariables(playerid)
{
    PlayerInfo[playerid][p_id]       = 0;
	PlayerInfo[playerid][pLoggedIn]  = 0;
	PlayerInfo[playerid][pAdmin]  = 0;
	PlayerInfo[playerid][pScore]     = 0;
	PlayerInfo[playerid][pMoney]     = 0;
	PlayerInfo[playerid][pKills]     = 0;
	PlayerInfo[playerid][pDeaths]    = 0;
	GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	PlayerInfo[playerid][pInCP]=-1;
	PlayerInfo[playerid][SpswnProtected]=0;
	PlayerInfo[playerid][mylabel]=-1;
	PlayerInfo[playerid][pClassSelection]=false;
	PlayerInfo[playerid][pDead]=false;
	PlayerInfo[playerid][AlreadySpawned]=false;
	PlayerInfo[playerid][CarReady]=false;
	PlayerInfo[playerid][pTutorial]=false;
	PlayerInfo[playerid][pTutStep]     = 0;
	PlayerInfo[playerid][pIPBanCheck]=false;
	
	PlayerInfo[playerid][pBoxShown] = false;
	PlayerInfo[playerid][IsConfiguringArtillery] = false;
	
	
	
	DroppingBombs[playerid] = 0;
	return 1;
}
stock MySQL_SetupConnection(ttl = 3)
{
	print("[MySQL] Connecting...");
	//mysql_log();

	handle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DBSE);

	//Prüfen und gegebenenfalls wiederholen
	if(mysql_errno(handle) != 0)
	{
		//Fehler im Verbindungsaufbau, prüfe ob ein weiterer Versuch gestartet werden soll
		if(ttl > 1)
		{
			//Versuche erneut eine Verbindung aufzubauen
			print("[MySQL] Connecting to MySQL Failed.");
			printf("[MySQL] Retrying... (TTL: %d).", ttl-1);
			return MySQL_SetupConnection(ttl-1);
		}
		else
		{
			//Abbrechen und Server schließen
			print("[MySQL] Couldn't establish a connection to database.");
			print("[MySQL] Shutting down server....");
			return SendRconCommand("exit");
		}
	}
	printf("[MySQL] Successfully connected! Handle: %d", _:handle);
	return 1;
}



stock IsPlayerAdminEx(playerid,admlvl)
{
	if(PlayerInfo[playerid][pAdmin]>=admlvl) return 1;
	return 0;
}



stock CheckUserBan(playerid)
{
    new query[256];
	mysql_format(handle, query, sizeof(query), "SELECT * FROM BanList WHERE name = '%e'", GetName(playerid));
	mysql_pquery(handle, query, "OnUserBanCheck", "d",playerid);
}

stock CheckUserBanIP(playerid)
{
    new query[256];
    new ipadresse[16];
    GetPlayerIp(playerid, ipadresse, sizeof(ipadresse));
	mysql_format(handle, query, sizeof(query), "SELECT * FROM BanList WHERE playerIP = '%e'", ipadresse);
	mysql_pquery(handle, query, "OnUserBanCheck", "d",playerid);
	PlayerInfo[playerid][pIPBanCheck]=true;
}

forward OnUserBanCheck(playerid);
public OnUserBanCheck(playerid)
{
    new rows,ipadresse[16],BannerAdmin[35],BannerReason[128],BannerDate[128],playerip[16],string[128],name[35],BanExpire,BanEver;
	cache_get_row_count(rows);
	if(rows > 0)
	{
    	cache_get_value_name(0, "name", name);
		cache_get_value_name(0, "playerIP", ipadresse);
		
		cache_get_value_name(0, "BannerAdmin", BannerAdmin);
		cache_get_value_name(0, "BannerReason", BannerReason);
		cache_get_value_name(0, "BanDate", BannerDate);
		cache_get_value_name_int(0, "BanExpire", BanExpire);
		cache_get_value_name_int(0, "BanEver", BanEver);
		
		format(string,sizeof(string),"Name: {FFFFFF}%s",name);
		SCM(playerid,COLOR_LIGHTRED,string);
		format(string,sizeof(string),"Banned by: {FFFFFF}%s",BannerAdmin);
		SCM(playerid,COLOR_LIGHTRED,string);
	    format(string,sizeof(string),"Ban Reason: {FFFFFF}%s",BannerReason);
		SCM(playerid,COLOR_LIGHTRED,string);
	    format(string,sizeof(string),"Ban Date: {FFFFFF}%s",BannerDate);
		SCM(playerid,COLOR_LIGHTRED,string);
		if(BanEver == 0) // verwirrend eig steht das für NICHT permanent gebannt der name klingt aber geil hshahahahahahah wollte es net wd ändern kb nvm.
		{
			if(BanExpire >=1)
			{
				if(gettime() < BanExpire)
				{
				    new timebanned = BanExpire-gettime();
					new tage = timebanned / 86400;
					timebanned -= tage * 86400;
					new stunden = timebanned / 3600;
					timebanned -= stunden * 3600;
					new minuten = timebanned / 60;
					timebanned -= minuten * 60;
					new sekunden = timebanned;
					new str[128];
					if(tage > 0) format(str,sizeof(str),"%i Days, %i Hours, %i Minutes and %d Seconds",tage,stunden,minuten,sekunden);
					else if(stunden > 0) format(str,sizeof(str),"%i Hours, %i Minutes and %i Seconds",stunden,minuten,sekunden);
					else if(minuten > 0) format(str,sizeof(str),"%i Minutes and %i Seconds!",minuten,sekunden);
					else format(str,sizeof(str),"%i Seconds!",sekunden);
					format(string,sizeof(string),"Ban Expire: {FFFFFF}%s",str);
					SCM(playerid,COLOR_LIGHTRED,string);
				}
				else
				{ // unbanned
				    SCM(playerid,COLOR_LIGHTRED,"You were unbanned.");
				    
				    new query[256];
					mysql_format(handle, query, sizeof(query), "DELETE FROM BanList WHERE name = '%e'", GetName(playerid));
					mysql_pquery(handle, query, "", "d",playerid);

				}
			}
		}
		else
		{
		    SCM(playerid,COLOR_LIGHTRED,"Ban Expire: {FFFFFF}Never");
		}
	//	else

		GetPlayerIp(playerid, playerip, sizeof(playerip));
		
		if(!strcmp(playerip, ipadresse, true))
		{
		    format(string,sizeof(string),"Your IP Adress: {FFFFFF}%s",ipadresse);
			SCM(playerid,COLOR_LIGHTRED,string);
		}
		SetTimerEx("KickTimer", 100, 0,"i",playerid);
	//	return 1;
	}
	else
	{
	    if(PlayerInfo[playerid][pIPBanCheck]==false)
	    {
	        CheckUserBanIP(playerid);
		}
	}

}

stock BanUser(playerid,admin[],reason[],zeitdauer,zeitbann)
{
//	if(PlayerInfo[playerid][pBanned]==1) return 1;
	new playerip[16],playerserial[128],string2[128];
 	gpci(playerid,playerserial,sizeof(playerserial));
 	GetPlayerIp(playerid, playerip, sizeof(playerip));
 	new Year, Month, Day;
 	getdate(Year, Month, Day);
 	format(string2, sizeof(string2), "%d/%02d/%02d", Year,Month,Day);
 //	days * 24*30;
 	new query[256];
	mysql_format(handle, query, sizeof(query), "INSERT INTO BanList (name, playerIP,playerSerial,BannerAdmin,BannerReason,BanDate,BanExpire,BanEver) VALUES ('%e','%e','%e','%e','%e','%e','%d','%d')", //%02d/%02d/%d
	GetName(playerid),playerip,playerserial,admin,reason,string2,zeitdauer,zeitbann);
	mysql_pquery(handle, query, "", "d", playerid);
	return 1;
}

//sscanf
stock sscanf(string[], format[], {Float,_}:...)
{
    #if defined isnull
        if (isnull(string))
    #else
        if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
    #endif
        {
            return format[0];
        }
    #pragma tabsize 4
    new
        formatPos = 0,
        stringPos = 0,
        paramPos = 2,
        paramCount = numargs(),
        delim = ' ';
    while (string[stringPos] && string[stringPos] <= ' ')
    {
        stringPos++;
    }
    while (paramPos < paramCount && string[stringPos])
    {
        switch (format[formatPos++])
        {
            case '\0':
            {
                return 0;
            }
            case 'i', 'd':
            {
                new
                    neg = 1,
                    num = 0,
                    ch = string[stringPos];
                if (ch == '-')
                {
                    neg = -1;
                    ch = string[++stringPos];
                }
                do
                {
                    stringPos++;
                    if ('0' <= ch <= '9')
                    {
                        num = (num * 10) + (ch - '0');
                    }
                    else
                    {
                        return -1;
                    }
                }
                while ((ch = string[stringPos]) > ' ' && ch != delim);
                setarg(paramPos, 0, num * neg);
            }
            case 'h', 'x':
            {
                new
                    num = 0,
                    ch = string[stringPos];
                do
                {
                    stringPos++;
                    switch (ch)
                    {
                        case 'x', 'X':
                        {
                            num = 0;
                            continue;
                        }
                        case '0' .. '9':
                        {
                            num = (num << 4) | (ch - '0');
                        }
                        case 'a' .. 'f':
                        {
                            num = (num << 4) | (ch - ('a' - 10));
                        }
                        case 'A' .. 'F':
                        {
                            num = (num << 4) | (ch - ('A' - 10));
                        }
                        default:
                        {
                            return -1;
                        }
                    }
                }
                while ((ch = string[stringPos]) > ' ' && ch != delim);
                setarg(paramPos, 0, num);
            }
            case 'c':
            {
                setarg(paramPos, 0, string[stringPos++]);
            }
            case 'f':
            {

                new changestr[16], changepos = 0, strpos = stringPos;
                while(changepos < 16 && string[strpos] && string[strpos] != delim)
                {
                    changestr[changepos++] = string[strpos++];
                    }
                changestr[changepos] = '\0';
                setarg(paramPos,0,_:floatstr(changestr));
            }
            case 'p':
            {
                delim = format[formatPos++];
                continue;
            }
            case '\'':
            {
                new
                    end = formatPos - 1,
                    ch;
                while ((ch = format[++end]) && ch != '\'') {}
                if (!ch)
                {
                    return -1;
                }
                format[end] = '\0';
                if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
                {
                    if (format[end + 1])
                    {
                        return -1;
                    }
                    return 0;
                }
                format[end] = '\'';
                stringPos = ch + (end - formatPos);
                formatPos = end + 1;
            }
            case 'u':
            {
                new
                    end = stringPos - 1,
                    id = 0,
                    bool:num = true,
                    ch;
                while ((ch = string[++end]) && ch != delim)
                {
                    if (num)
                    {
                        if ('0' <= ch <= '9')
                        {
                            id = (id * 10) + (ch - '0');
                        }
                        else
                        {
                            num = false;
                        }
                    }
                }
                if (num && IsPlayerConnected(id))
                {
                    setarg(paramPos, 0, id);
                }
                else
                {
                    #if !defined foreach
                        #define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
                        #define __SSCANF_FOREACH__
                    #endif
                    string[end] = '\0';
                    num = false;
                    new
                        name[MAX_PLAYER_NAME];
                    id = end - stringPos;
                    foreach (Player, playerid)
                    {
                        GetPlayerName(playerid, name, sizeof (name));
                        if (!strcmp(name, string[stringPos], true, id))
                        {
                            setarg(paramPos, 0, playerid);
                            num = true;
                            break;
                        }
                    }
                    if (!num)
                    {
                        setarg(paramPos, 0, INVALID_PLAYER_ID);
                    }
                    string[end] = ch;
                    #if defined __SSCANF_FOREACH__
                        #undef foreach
                        #undef __SSCANF_FOREACH__
                    #endif
                }
                stringPos = end;
            }
            case 's', 'z':
            {
                new
                    i = 0,
                    ch;
                if (format[formatPos])
                {
                    while ((ch = string[stringPos++]) && ch != delim)
                    {
                        setarg(paramPos, i++, ch);
                    }
                    if (!i)
                    {
                        return -1;
                    }
                }
                else
                {
                    while ((ch = string[stringPos++]))
                    {
                        setarg(paramPos, i++, ch);
                    }
                }
                stringPos--;
                setarg(paramPos, i, '\0');
            }
            default:
            {
                continue;
            }
        }
        while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
        {
            stringPos++;
        }
        while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
        {
            stringPos++;
        }
        paramPos++;
    }
    do
    {
        if ((delim = format[formatPos++]) > ' ')
        {
            if (delim == '\'')
            {
                while ((delim = format[formatPos++]) && delim != '\'') {}
            }
            else if (delim != 'z')
            {
                return delim;
            }
        }
    }
    while (delim > ' ');
    return 0;
}

stock IsVehicleOccupied(vehid)
{
    for(new i = GetPlayerPoolSize(); i != -1; --i) {
        if(IsPlayerConnected(i)) {
            if(IsPlayerInVehicle(i, vehid)) return 1;
        }
    }
    return 0;
}

stock GetTeamPlayersInZone(checkpoint,team)
{
	new count;
    for(new i = GetPlayerPoolSize(); i != -1; --i)
	{
	    if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pInCP]==Capture[checkpoint][baseid] && GetPlayerTeam(i) == team)
			{
			    count++;
			}
	    }
	}
    return count;
}

SendTeamMessage(team,msg[])
{
    for(new i = GetPlayerPoolSize(); i != -1; --i)
	{
	    if(IsPlayerConnected(i))
		{
			if(GetPlayerTeam(i) == team)
			{
			    SendClientMessage(i,COLOR_PURPLE,msg);
			}
	    }
	}
}
stock SpawnAll()
{
    for(new i = GetPlayerPoolSize(); i != -1; --i)
	{
	    if(IsPlayerConnected(i) && PlayerInfo[i][pClassSelection]==false && PlayerInfo[i][pLoggedIn]==1)
		{
			SpawnPlayer(i);
	    }
	}
}





public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	SCM(playerid,-1,"entered!");
	
	new string[100];
	for(new id=0; id<MAX_ZONES; id++)
	{
 		if(GangZones[id][Zone_CP] == checkpointid)
 		{
			format(string,sizeof(string),"[SERVER] Checkpoint ID %d, Name %s, Dominated by %s",GangZones[id][ZoneID],GangZones[id][ZoneName],GetTeamName(GangZones[id][DominatedBy]));
			SendClientMessageToAll(COLOR_YELLOW,string);

			if(GetPlayerTeam(playerid) != GangZones[id][DominatedBy] && !GangZones[id][beingCaptured])
			{
			    GangZones[id][beingCaptured] = true;
			    GangZones[id][beingCapturedTime] = 0;
			    GangZones[id][playerCapturerID] = playerid;
			    
			    printf("Capturer ID %d", GangZones[id][playerCapturerID]);
			    
			    if(PlayerInfo[playerid][pProgress] == INVALID_PLAYER_BAR_ID) return SCM(playerid,COOLRED,"[Server Error] INVALID Progressbar! Try again later!");
			 	SetPlayerProgressBarMaxValue(playerid,PlayerInfo[playerid][pProgress],5);
				SetPlayerProgressBarValue(playerid,PlayerInfo[playerid][pProgress],GangZones[id][beingCapturedTime]);
				UpdatePlayerProgressBar(playerid,PlayerInfo[playerid][pProgress]);
				ShowPlayerProgressBar(playerid,PlayerInfo[playerid][pProgress]);
				

			}
		}
	}
	
	/*
	for(new i=0; i<MAX_CAPTURE_POINTS;i++)
	{
	    if(Server[LandGefecht]==false) return 1;
		if(Server[PreparePhase2]==true) return 1;
	    if(Capture[i][cpid]==checkpointid)
	    {
			if(GetPlayerTeam(playerid)==255) return 1;
			if(Capture[i][kampfvorbei]==true)return SendClientMessage(playerid,COLOR_LIGHTRED,"This Fight is already over...");
			PlayerInfo[playerid][pInCP]=Capture[i][baseid];
			
			if(Capture[i][ActiveCapture]==0)
			{
			    if(GetPlayerTeam(playerid) == Capture[i][owner])
			    {
			        SendClientMessage(playerid,COLOR_LIGHTRED,"Checkpoint is already owned by your Team.");
			        return 1;
				}
				if(Capture[i][owner]!=GetEnemy(Server[EtappenWinner]))
				{
				    SendClientMessage(playerid,COLOR_LIGHTRED,"You're fighting in the wrong Zone.");
			        return 1;
				}
			    KillTimer(PlayerInfo[playerid][pProgressTimer]);
			    //DestroyPlayerProgressBar(playerid,PlayerInfo[playerid][pProgress]);
             //   PlayerInfo[playerid][pProgress] = CreatePlayerProgressBar(playerid, 291.333435, 208.251922, 80.5,  10.2, COLOR_LIGHTRED, 100.0);
			   // ShowPlayerProgressBar(playerid, PlayerInfo[playerid][pProgress]);


	//		    SetPlayerProgressBarValue(playerid,PlayerInfo[playerid][pProgress],Capture[i][ProgressTime]);

			   // SetPlayerProgressBarMaxValue(playerid,PlayerInfo[playerid][pProgress],MAX_CAPTURE_TIME);
			  //  PlayerInfo[playerid][pProgressTimer] = SetTimerEx("ProgressEnd", 1000, 1,"ii",playerid,i);
		     	Capture[i][ActiveCapture]=1;
		     	
		     	if(GetPlayerTeam(playerid) != Capture[i][owner])
		     	{
		     	    Capture[i][tattacker]=GetPlayerTeam(playerid);
		     	    Capture[i][tdefender]=Capture[i][owner];
				}
			}
		}
	}*/
	
	
	return 1;
}


forward SpawnTimer(playerid);
public SpawnTimer(playerid)
{
	PlayerInfo[playerid][pDead]=false;
	//SCM(playerid,-1,"Untoter!");
	SpawnPlayer(playerid);
}
forward SpawnKillEnd(playerid);
public SpawnKillEnd(playerid)
{
    PlayerInfo[playerid][SpswnProtected]=0;
    SendClientMessage(playerid,COLOR_LIGHTRED,"* Spawn Protection end!");
}
forward KickTimer(playerid);
public KickTimer(playerid)
{
	Kick(playerid);
}
forward SpawnEveryOneAndStartTimer();
public SpawnEveryOneAndStartTimer()
{
    DestroyAllPlanes();
  //  SpawnAll();
    SetTimer("SpawnEveryOness",7000,0);
}
forward SpawnEveryOne();
public SpawnEveryOne()
{
	SpawnAll();
//	Server[CanSpawn]=true;
	
}

forward SpawnEveryOness();
public SpawnEveryOness()
{
    Server[PreparePhase2]=false;
    for(new i = GetPlayerPoolSize(); i != -1; --i)
	{
	    if(IsPlayerConnected(i) && PlayerInfo[i][pClassSelection]==false && PlayerInfo[i][pLoggedIn]==1)
		{
			SpawnPlayer(i);
	    }
	}
//	SetTimer("SpawnEveryOne",10000,0);
}


forward SpawnEveryOneAndSet5SecSpawn();
public SpawnEveryOneAndSet5SecSpawn()
{
   // Server[ModeStarted]=true;
    Server[FiveSecondStart]=false;
    SpawnAll();
}

forward NewRound();
public NewRound()
{
	PrepareGameMode();
	updater = SetTimer("UpdateGameMode",1000,1);
	SpawnAll();
}

forward Restart();
public Restart()
{
	SendRconCommand("gmx");
}


forward LoopThrewAllPlayers();
public LoopThrewAllPlayers()
{
    for(new i = GetPlayerPoolSize(); i != -1; --i)
    {
	        if(IsPlayerConnected(i))
	        {
	            if(GetPlayerTeam(i) ==255)
	            {
	                if(PlayerInfo[i][pClassSelection])
	                {
	                    new jobid = GetPlayerClassJob(i,GetPlayerSkin(i)),string[50];
	                    format(string,sizeof(string),"~g~%s",GetJobName(jobid));
						GameTextForPlayer(i,string,2000,3);
					}
	            }
			}
	}
}



forward UpdateGameMode();
public UpdateGameMode()
{
    new string[128];
	if(Server[Prepared]==false)
	{
	    PrepareGameMode();
	}
	if(Server[ModeStarted]==false)
	{
	    if(GetOnlinePlayers() < MIN_PLAYERS_TOPLAY)
	    {
	        if(startcounter > 14)
	        {
	            format(string,sizeof(string),"[SERVER] We need %d more Players to start a new Round!",MIN_PLAYERS_TOPLAY-GetOnlinePlayers());
				SendClientMessageToAll(COLOR_YELLOW,string);
				startcounter=0;
			}
			else startcounter++;
		}
		else
		{
  			GameTextForAll("Round started", 5000, 3);
  			Server[FiveSecondStart]=true;
  			Server[ModeStarted]=true;
	    	SetTimer("SpawnEveryOneAndSet5SecSpawn",5000,0); // Was wenn jemand innerhalb dieser 5 Sekunde joint ?
		}
	}
	
	
	
	for(new i = 0; i<sizeof(Artillery);i++)
	{
	    FireArtillery(i);
	}
	
	for(new id=0; id<MAX_ZONES; id++)
	{
	    if(GangZones[id][ZoneID]!=-1)
	    {
	        if(!GangZones[id][beingCaptured])continue;
	        if(IsPlayerConnected(GangZones[id][playerCapturerID]) && GangZones[id][playerCapturerID]!=INVALID_PLAYER_ID)
	        {
        		GangZones[id][beingCapturedTime]++;
        		new playerid = GangZones[id][playerCapturerID];
       			SetPlayerProgressBarValue(playerid,PlayerInfo[playerid][pProgress],GangZones[id][beingCapturedTime]);
	      		UpdatePlayerProgressBar(playerid,PlayerInfo[playerid][pProgress]);
	      		ShowPlayerProgressBar(playerid,PlayerInfo[playerid][pProgress]);
          		if(GangZones[id][beingCapturedTime]>=5)
          		{
                    GangZones[id][DominatedBy] = GetEnemy(GangZones[id][DominatedBy]);
	      			HidePlayerProgressBar(playerid,PlayerInfo[playerid][pProgress]);
	      			//GangZoneShowForAll(GangZones[id][LocalZone],GetTeamColor(GangZones[id][DominatedBy]));
	      			
					GameTextForPlayer(playerid,"~w~Zone captured~n~~g~You get $5.000",3000,3);
					GivePlayerMoney(playerid,5000);
				    GangZones[id][beingCapturedTime]=0;
				    GangZones[id][playerCapturerID] = INVALID_PLAYER_ID;
				    GangZones[id][beingCaptured] = false;
				    
				    updateGangZone(id);
				}
			}
			else
			{
			    GangZoneShowForAll(id,GetTeamColor(GangZones[id][DominatedBy]));
			    GangZones[id][beingCapturedTime]=0;
			    GangZones[id][playerCapturerID] = INVALID_PLAYER_ID;
			    GangZones[id][beingCaptured] = false;
			}
			GangZoneShowForAll(GangZones[id][LocalZone],GetTeamColor(GangZones[id][DominatedBy]));
		}
	}
	/*
	if(Server[LandGefecht]==true && Server[Prepared]==true) // true
	{
	    if(Server[PreparePhase2]==false)
	    {
	        Server[Sekunden]--;
	      //  Server[Minuten]--;
	        //if(Server[Sekunden]<=0 && Server[Minuten]!=0){Server[Sekunden]=59;}
	        if(Server[Sekunden] == 0 && Server[Minuten] == 0)
	        {
	            new stepwinner = Server[EtappenWinner];
	            Server[PreparePhase2]=false;
	            if(City[stepwinner][Captured]>2)
	            {
	                format(string,sizeof(string),"[END] The Attackers %s captured $d/4 Checkpoints and Won the Round!",GetTeamName(stepwinner),City[stepwinner][Captured]);
	                SendClientMessageToAll(COLOR_GREEN,string);
	                SetTimer("Restart",9000,0);
	                // bis 3/4 keine Sorge man hat etwas wie punktezänlung und teamriviltItät am ende
	            }
	            else
	            {
	                if(City[stepwinner][Defended] == 0) {City[stepwinner][Defended]=4;}
	                format(string,sizeof(string),"Team %s defended their Territory by holding %d/4 Checkpoints!",GetTeamName(GetEnemy(stepwinner)),City[stepwinner][Defended]);
	                SendClientMessageToAll(COLOR_GREEN,string);
	                SendClientMessageToAll(COLOR_GREEN,"The Match is starting into a new Round!");
	                KillTimer(updater);
	                Server[Prepared]=false;
	                SetTimer("NewRound",9000,0);
	                // bis 3/4 keine Sorge man hat etwas wie punktezänlung und teamriviltItät am ende
	            }
	            // Ende
	            return 1;
	        }
	        if(Server[Sekunden]<=0)
	        {
	            Server[Minuten]--;
	            Server[Sekunden]=59;
	        }
	        format(string, sizeof(string), "%02d:%02d", Server[Minuten],Server[Sekunden]);
	        TextDrawSetString(TDEditor_TD[2], string);
	    }
		
		for(new cpidd=0; cpidd<MAX_CAPTURE_POINTS;cpidd++)
		{
		    if(Capture[cpidd][ActiveCapture]==1)
		    {
		        Capture[cpidd][ProgressTime]++;
				if(Capture[cpidd][ProgressTime] > MAX_CAPTURE_TIME)
				{
				    if(GetTeamPlayersInZone(cpidd,Capture[cpidd][tattacker]) > GetTeamPlayersInZone(cpidd,Capture[cpidd][tdefender]))
				    {
				        // Gebiet erobert
						format(string,sizeof(string),"[CAPTURE] Team %s captured a new Zone!",GetTeamName(Capture[cpidd][tattacker]));
						SendClientMessageToAll(COLOR_GREEN,string);
						Capture[cpidd][owner]=Capture[cpidd][tattacker];
						
						City[Capture[cpidd][tattacker]][Captured]++;
					}
			        if(GetTeamPlayersInZone(cpidd,Capture[cpidd][tattacker]) < GetTeamPlayersInZone(cpidd,Capture[cpidd][tdefender]))
				    {
				        // Gebiet verteidigt
						format(string,sizeof(string),"[CAPTURE] Team %s successfully defended their Zone!",GetTeamName(Capture[cpidd][tdefender]));
						SendClientMessageToAll(COLOR_GREEN,string);
						City[Capture[cpidd][tdefender]][Defended]++;
					}
					if(GetTeamPlayersInZone(cpidd,Capture[cpidd][tattacker]) == GetTeamPlayersInZone(cpidd,Capture[cpidd][tdefender]))  // if wert == 1 return 1; Kampf um 10 sek verlängern?
				    {
				        // Gebiet gleichstand
						format(string,sizeof(string),"[CAPTURE] Team %s successfully defended their Zone!",GetTeamName(Capture[cpidd][tdefender]));
						SendClientMessageToAll(COLOR_GREEN,string);
                        City[Capture[cpidd][tdefender]][Defended]++;
					}

					if(GetTeamPlayersInZone(cpidd,Capture[cpidd][tattacker]) ==0 && GetTeamPlayersInZone(cpidd,Capture[cpidd][tdefender] ==0))
				    {
				        // Gebiet nobody there
						format(string,sizeof(string),"[CAPTURE] Team %s stopped capturing a Zone!",GetTeamName(Capture[cpidd][tattacker]));
						SendClientMessageToAll(COLOR_GREEN,string);
					}
					for(new i = GetPlayerPoolSize(); i != -1; --i)
					{
					    if(IsPlayerConnected(i))
						{
						    if(PlayerInfo[i][pInCP]==cpidd)
						    {
						        KillTimer(PlayerInfo[i][pProgressTimer]);
						        HidePlayerProgressBar(i, PlayerInfo[i][pProgress]);
								//DestroyPlayerProgressBar(i,PlayerInfo[i][pProgress]);
							}
						}
					}
                    Capture[cpidd][tattacker]=0;
                    Capture[cpidd][tdefender]=0;
				 	Capture[cpidd][ActiveCapture]=0;
				 	Capture[cpidd][kampfvorbei]=true;
				 	Capture[cpidd][ProgressTime]=0;

				}
				else
				{
	    			for(new i = GetPlayerPoolSize(); i != -1; --i)
					{
	    				if(IsPlayerConnected(i))
						{
		    				if(PlayerInfo[i][pInCP]==Capture[cpidd][baseid])
					    	{
					    	    SetPlayerProgressBarMaxValue(i,PlayerInfo[i][pProgress],MAX_CAPTURE_TIME);
		        				SetPlayerProgressBarValue(i,PlayerInfo[i][pProgress],Capture[cpidd][ProgressTime]);
								UpdatePlayerProgressBar(i,PlayerInfo[i][pProgress]);
								ShowPlayerProgressBar(i,PlayerInfo[i][pProgress]);
							}
						}
					}
				}
			}
		}
		for(new i = GetPlayerPoolSize(); i != -1; --i)
		{
  			if(IsPlayerConnected(i))
			{
				new team = GetPlayerTeam(i);
				new enemy = GetEnemy(team);
				if(team != 255)
				{
				    if(team == Server[EtappenWinner])
				    {
                   // 	format(string, sizeof(string), "{01DF01}%d{FFFFFF}/{FFFF00}4{FFFFFF} Captured", City[team][Captured]);
                        format(string, sizeof(string), "%d/4", City[team][Captured]);
						PlayerTextDrawSetString(i,TeamCapturePoints[i], string);
						PlayerTextDrawColor(i, TeamCapturePoints[i], COLOR_GREEN);
					}
					else if(team != Server[EtappenWinner])
					{
					   // format(string, sizeof(string), "{FF0000}%d{FFFFFF}/{FFFF00}4{FF0000} lost", City[enemy][Captured]);
					    format(string, sizeof(string), "%d/4", City[enemy][Captured]);
						PlayerTextDrawSetString(i,TeamCapturePoints[i], string);
						PlayerTextDrawColor(i, TeamCapturePoints[i], COLOR_RED);
					}
					if(PlayerInfo[i][pDead]==false)
					{
						PlayerTextDrawShow(i,TeamCapturePoints[i]);
						TextDrawShowForPlayer(i,TDEditor_TD[2]);
					}
				}
			}
		}
	}
	else
	{
	    for(new i = GetPlayerPoolSize(); i != -1; --i)
	    {
	        if(IsPlayerConnected(i))
	        {
	            if(GetPlayerTeam(i) !=255)
	            {
	             //   TextDrawShowForPlayer(i,TDEditor_TD[0]);
	                new team = GetPlayerTeam(i);
	                new enemy = GetEnemy(team);
	                if(team == 1 || team == 2)
	                if(City[team][LuftFlugzeuge]==City[enemy][LuftFlugzeuge] || City[team][LuftFlugzeuge]>City[enemy][LuftFlugzeuge] && PlayerInfo[i][pDead]==false)
	                {
	                    format(string, sizeof(string), "%02d", City[enemy][LuftFlugzeuge]); // %02d
    					PlayerTextDrawSetString(i,TDEditor_PTD[i], string);
	                    PlayerTextDrawColor(i, TDEditor_PTD[i], COLOR_RED);
	                    if(PlayerInfo[i][pDead]==false)
						{
	                    	PlayerTextDrawShow(i,TDEditor_PTD[i]);
						}

					}
					if(City[enemy][LuftFlugzeuge] > City[team][LuftFlugzeuge])
					{
					    format(string, sizeof(string), "%02d", City[team][LuftFlugzeuge]);
    					PlayerTextDrawSetString(i,TDEditor_PTD[i], string);
					    PlayerTextDrawColor(i, TDEditor_PTD[i], COLOR_BLUE);
					    if(PlayerInfo[i][pDead]==false)
						{
					    	PlayerTextDrawShow(i,TDEditor_PTD[i]);
					    	
					    }
					}
					if(City[team][Air_Superiority] > City[enemy][Air_Superiority])
					{
					    GangZoneShowForPlayer(i,gangzone,COLOR_GREEN);
					    format(string, sizeof(string), "{6BE916} Air Superiority: %d%", City[team][Air_Superiority]);
					    if(PlayerInfo[i][mylabel]==-1)
						{
                            
						 //   SetPlayerObjectMaterialText(i, PlayerInfo[i][mylabel],string, 0, OBJECT_MATERIAL_SIZE_256x128,\"Arial", 28, 0, COLOR_GREEN, COLOR_GREEN, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
						}
					}
					else if(City[enemy][Air_Superiority] > City[team][Air_Superiority])
					{
					    format(string, sizeof(string), "{FF0000} Air Superiority: %d%", City[team][Air_Superiority]);
					    if(PlayerInfo[i][mylabel]==-1)
						{
					      
						}
					    GangZoneShowForPlayer(i,gangzone,COLOR_LIGHTRED);
					}
					else GangZoneShowForAll(gangzone,COLOR_GREY);
					if(IsPlayerInAnyVehicle(i) && PlayerInfo[i][pDead]==false && Server[PreparePhase2]==true)
					{
					    new veh = GetPlayerVehicleID(i);
					    if(GetCarFunctionNew(veh == 1 || veh == 2))
					    {
					        SCM(i,COLOR_LIGHTRED,"The Invasion begins! Get the Hell out of here!");
					        GivePlayerWeapon(i,46,1);
					     //   SetVehicleHealth(veh,0);
						}
					}
					
	            }
	        }
		}*/
	return 1;
}


stock GetEnemy(teamid)
{
	new enemy;
	if(teamid != 255 && teamid == 1 || teamid == 2)
	{
		switch(teamid)
		{
		    case 1: enemy = 2;
		    case 2: enemy = 1;
		}
	}
	return enemy;
}

/*
forward ProgressEnd(playerid,cpidd);
public ProgressEnd(playerid,cpidd)
{
    Capture[cpidd][ProgressTime]++;
	if(Capture[cpidd][ProgressTime] > MAX_CAPTURE_TIME)
	{
	    new string[128];
	    if(GetTeamPlayersInZone(cpidd,Capture[cpidd][tattacker]) > GetTeamPlayersInZone(cpidd,Capture[cpidd][tdefender]))
	    {
	        // Gebiet erobert
			format(string,sizeof(string),"[CAPTURE] Team %s captured a new Zone!",GetTeamName(Capture[cpidd][tattacker]));
			SendClientMessageToAll(0xFFFFFFAA,string);
		}
        if(GetTeamPlayersInZone(cpidd,Capture[cpidd][tattacker]) < GetTeamPlayersInZone(cpidd,Capture[cpidd][tdefender]))
	    {
	        // Gebiet verteidigt
			format(string,sizeof(string),"[CAPTURE] Team %s successfully defended their Zone!",GetTeamName(Capture[cpidd][tattacker]));
			SendClientMessageToAll(0xFFFFFFAA,string);
		}
		if(GetTeamPlayersInZone(cpidd,Capture[cpidd][tattacker]) == GetTeamPlayersInZone(cpidd,Capture[cpidd][tdefender]))  // if wert == 1 return 1; Kampf um 10 sek verlängern?
	    {
	        // Gebiet gleichstand
			format(string,sizeof(string),"[CAPTURE] Team %s successfully defended their Zone!",GetTeamName(Capture[cpidd][tattacker]));
			SendClientMessageToAll(0xFFFFFFAA,string);
		}
		
		if(GetTeamPlayersInZone(cpidd,Capture[cpidd][tattacker] ==0 && GetTeamPlayersInZone(cpidd,Capture[cpidd][tdefender] ==0)))
	    {
	        // Gebiet nobody there
			format(string,sizeof(string),"[CAPTURE] Team %s stopped capturing a Zone!",GetTeamName(Capture[cpidd][tattacker]));
			SendClientMessageToAll(0xFFFFFFAA,string);
		}
		for(new i = GetPlayerPoolSize(); i != -1; --i)
		{
		    if(IsPlayerConnected(i))
			{
			    if(PlayerInfo[i][pInCP]==cpidd)
			    {
			        KillTimer(PlayerInfo[i][pProgressTimer]);
					DestroyPlayerProgressBar(i,PlayerInfo[i][pProgress]);
				}
			}
		}
		
	 	Capture[cpidd][ActiveCapture]=0;
	 	Capture[cpidd][kampfvorbei]=true;
	 	
	  //  SendClientMessage(playerid,-1,"Die Zone wurde erobert.");
	    return 1;
	}
    Capture[cpidd][ProgressTime]=0;
    for(new i = GetPlayerPoolSize(); i != -1; --i)
		{
		    if(IsPlayerConnected(i))
			{
			    if(PlayerInfo[i][pInCP]==cpidd)
			    {
			        SetPlayerProgressBarValue(i,PlayerInfo[i][pProgress],Capture[cpidd][ProgressTime]);
					UpdatePlayerProgressBar(i,PlayerInfo[i][pProgress]);
				}
			}
		}
	
	return 1;
}
*/
forward LoadMaps();
public LoadMaps()
{
	// Waiting Room
	CreateDynamicObject(19378, -696.98480, 1933.82788, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19375, -691.79700, 1933.82959, -4.63640,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19378, -696.96490, 1924.19556, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, -686.46490, 1924.19556, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, -675.96490, 1924.19556, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -675.96490, 1933.82788, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -675.96490, 1943.46191, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19375, -681.13501, 1933.82959, -4.63640,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19377, -686.46490, 1928.92566, -4.20040,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(19375, -681.13501, 1943.46191, -4.63640,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19375, -696.98328, 1938.55981, -4.20040,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, -675.96490, 1953.09595, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19381, -686.46490, 1953.09595, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -696.96332, 1953.09595, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19375, -686.46490, 1948.36194, -4.20040,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(19375, -696.96332, 1948.36194, -4.20040,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, -697.39722, 1919.46643, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -687.76422, 1919.46643, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -678.13123, 1919.46643, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, -672.32562, 1919.46838, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18762, -692.21368, 1924.19556, 1.61130,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18762, -692.21368, 1953.09595, 1.61130,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19378, -696.96490, 1924.19556, 4.02260,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, -696.53522, 1919.46643, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19378, -696.98480, 1933.82788, 4.02260,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -696.96332, 1953.09595, 4.02260,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -696.96332, 1943.46191, 4.02260,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, -696.53522, 1957.82434, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19325, -691.70990, 1954.59338, 5.99750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -691.70990, 1922.69934, 5.99750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -691.70990, 1929.34253, 5.99750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -691.70990, 1947.95032, 5.99750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -691.70990, 1941.30725, 5.99750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -691.70990, 1935.98535, 5.99750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -691.77502, 1938.63660, 5.66020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -670.84943, 1924.19556, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -670.84943, 1933.82788, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -670.84943, 1943.46191, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -670.84943, 1953.09595, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -697.39722, 1957.82434, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -687.76422, 1957.82434, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -678.13123, 1957.82434, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, -672.32562, 1957.82324, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -691.77502, 1924.19556, 8.77500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -691.77502, 1933.82788, 8.77500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -691.77502, 1943.46191, 8.77500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -691.77502, 1953.09595, 8.77500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -702.21503, 1928.61145, 2.03280,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -702.21503, 1935.25342, 2.03280,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -702.21503, 1948.53833, 2.03280,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -702.21503, 1957.82434, 0.73680,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -702.21503, 1941.89624, 2.03280,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19376, -696.96490, 1924.19556, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -696.98480, 1933.82788, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -696.96332, 1943.46191, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -696.96332, 1953.09595, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19325, -702.21503, 1919.46643, 0.73680,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -702.20898, 1943.83887, -0.79380,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -702.20898, 1934.20496, -0.79380,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19408, -702.20898, 1950.26184, -0.79380,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -702.20398, 1926.09265, -0.79380,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19408, -702.20898, 1927.78186, -0.79380,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -708.77209, 1932.64526, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -702.20398, 1957.66870, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19378, -707.46490, 1924.19556, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -707.46490, 1933.82788, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -707.46490, 1943.46191, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -707.46490, 1953.09595, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -717.96490, 1943.46191, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -717.96490, 1933.82788, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -728.46490, 1943.46191, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -728.46490, 1933.82788, 0.52860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, -707.10919, 1919.46643, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -706.14191, 1918.36511, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -716.74353, 1928.92432, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -726.37848, 1928.92432, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -707.10919, 1957.82434, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -712.01367, 1953.09595, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -716.74353, 1948.36194, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -726.37848, 1948.36194, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19325, -705.53870, 1945.21460, 2.03280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19435, -702.20398, 1919.69666, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -708.77209, 1944.50549, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19408, -703.90240, 1945.21814, -0.79380,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19408, -707.11243, 1945.21814, -0.79380,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19408, -703.90240, 1931.93274, -0.79380,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19408, -707.11243, 1931.93274, -0.79380,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19325, -705.53870, 1931.93274, 2.03280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19376, -717.93408, 1948.52258, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -720.66492, 1933.82788, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, -725.85797, 1933.82788, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -725.85797, 1943.46191, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7096, -716.37738, 1937.99841, 2.26960,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19378, -707.46490, 1924.19556, 4.02260,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -707.46490, 1933.82788, 4.02260,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -707.46490, 1943.46191, 4.02260,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19378, -707.46490, 1953.09595, 4.02187,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19362, -715.37500, 1933.75183, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -715.37500, 1936.95581, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -715.36298, 1939.47778, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -713.68201, 1932.23474, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, -712.01367, 1933.75183, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -714.31097, 1943.60669, 2.36000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -712.72968, 1938.87585, 2.35200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -716.70721, 1943.61096, -0.44800,   -23.08000, 0.00000, 90.00000);
	CreateDynamicObject(19362, -716.25122, 1941.01099, -0.25600,   -23.08000, 0.00000, 90.00000);
	CreateDynamicObject(19362, -719.20221, 1941.01099, -1.51400,   -23.08000, 0.00000, 90.00000);
	CreateDynamicObject(19435, -712.36621, 1936.03467, 2.36000,   0.00000, 0.00000, 26.80000);
	CreateDynamicObject(19434, -716.10028, 1934.58936, 4.06600,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19361, -716.81421, 1936.28577, 4.06600,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19434, -716.10028, 1937.80139, 4.06600,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1463, -716.18439, 1936.15259, 0.69240,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18692, -716.18439, 1936.15259, -0.49260,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, -715.36298, 1940.16577, 5.85820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -715.37500, 1936.95581, 5.85820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -715.37500, 1933.75183, 5.85820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -713.68201, 1932.23474, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, -714.31097, 1943.60669, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -706.16919, 1919.46643, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -710.98602, 1924.19556, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -711.52960, 1930.49219, 5.85820,   0.00000, 0.00000, 20.00000);
	CreateDynamicObject(19362, -713.59601, 1932.06665, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -706.16919, 1957.82434, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19325, -706.22913, 1922.80737, 7.27750,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(19435, -712.71582, 1936.49390, 5.85820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -712.71582, 1940.35986, 5.99750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -712.00177, 1935.77893, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19325, -702.74579, 1940.67773, 5.99750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -702.74579, 1935.77893, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19435, -702.74579, 1936.57886, 5.85820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -704.00818, 1935.77893, 7.27750,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(19435, -702.74579, 1944.01392, 5.85820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -704.00818, 1944.77893, 7.27750,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(19435, -702.74579, 1944.77893, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19435, -712.00177, 1944.79285, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19435, -712.71582, 1944.01392, 5.85820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -710.67322, 1944.77893, 7.27750,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(19435, -701.32898, 1920.35559, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -710.67322, 1935.77893, 7.27750,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(2097, -706.73993, 1921.16675, 4.39400,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -701.32898, 1922.76355, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -701.32898, 1925.97546, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19443, -701.32898, 1928.38757, 5.50000,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, -701.32898, 1927.50037, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19443, -698.26801, 1928.38757, 6.26000,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19443, -704.38800, 1928.38757, 4.90000,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19435, -711.78979, 1957.82434, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -712.62659, 1952.91846, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -710.14142, 1927.50037, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19391, -707.73340, 1927.50037, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(948, -692.10834, 1928.01904, 4.10360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -695.03619, 1935.77893, 5.99750,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19325, -695.03619, 1944.77893, 5.99750,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2828, -705.25348, 1928.37805, 4.97710,   0.00000, 0.00000, 310.00000);
	CreateDynamicObject(11707, -705.34912, 1922.72815, 4.95600,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, -704.25470, 1926.91016, 4.11040,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19622, -710.73761, 1927.76038, 4.74810,   -20.82990, 0.00000, 140.00000);
	CreateDynamicObject(2854, -703.90112, 1928.55298, 4.99000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19435, -692.52039, 1927.50037, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19391, -694.90637, 1927.50037, 5.85820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2562, -712.13409, 1938.67639, 0.61410,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(948, -708.23669, 1944.51831, 0.61460,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(19466, -705.67102, 1938.64441, 0.15580,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(19466, -705.67102, 1938.64441, 0.30780,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19466, -705.67102, 1939.61035, 1.27780,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19466, -705.67102, 1937.67542, 1.27780,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(1720, -704.26233, 1939.46350, 0.61530,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1720, -705.68542, 1940.84668, 0.61530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1720, -707.16492, 1939.41870, 0.61530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1720, -707.16492, 1937.54675, 0.61530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1720, -704.26233, 1937.54675, 0.61530,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1720, -705.68542, 1936.31055, 0.61530,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2257, -712.63031, 1940.19263, 2.67030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(14535, -709.07721, 1923.77844, 2.63040,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -712.01367, 1924.19556, 2.36000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1569, -704.84692, 1919.52844, 0.61350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(948, -671.32202, 1938.28345, 0.61537,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2484, -705.76721, 1931.36707, 1.41730,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14455, -704.84930, 1957.76221, 2.20400,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(14455, -711.83746, 1954.95520, 2.20400,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2868, -702.58905, 1957.40466, 0.61357,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1727, -711.25720, 1956.44116, 0.61300,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(2617, -703.76801, 1949.85486, 1.23880,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2484, -705.55121, 1945.62708, 1.43180,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2568, -706.58533, 1950.78381, 0.61480,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2568, -707.77161, 1953.91089, 0.61480,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19362, -707.17719, 1952.32581, 0.66340,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19376, -707.46490, 1953.09595, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -707.46490, 1943.46191, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -707.46490, 1933.82788, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -707.46490, 1924.19556, 3.99860,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(948, -715.90350, 1940.36426, 0.61500,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(19787, -716.89099, 1936.13916, 3.00830,   10.00000, 0.00000, 270.00000);
	CreateDynamicObject(1840, -716.82599, 1934.96033, 2.77210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1841, -716.82599, 1937.33032, 2.77210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -713.10498, 1924.77844, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -708.36639, 1920.03296, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1821, -701.78302, 1927.75354, 4.06950,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19873, -704.20929, 1927.31055, 5.11960,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1738, -707.99237, 1923.72388, 4.67010,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2742, -701.58472, 1925.71960, 5.23230,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2523, -701.92603, 1924.98572, 4.10840,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2817, -704.97809, 1924.21680, 4.10934,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2868, -705.49689, 1938.57239, 1.27660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19806, -705.53040, 1938.63574, 3.16140,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -712.62659, 1946.49255, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -715.36298, 1943.37476, 5.85820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19376, -720.66492, 1943.46191, 4.02260,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -717.93408, 1927.17957, 4.02260,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1727, -692.95673, 1935.11353, 4.10840,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(2484, -695.32300, 1935.40393, 4.94000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2236, -691.64117, 1931.05420, 4.10930,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(948, -706.58698, 1928.13501, 4.10360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, -708.10321, 1948.36194, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19454, -696.53522, 1950.75415, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19391, -699.80731, 1953.89355, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19391, -702.32220, 1949.56067, 5.86000,   0.00000, 0.00000, 140.00000);
	CreateDynamicObject(19362, -696.67590, 1955.41553, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -696.67590, 1957.82397, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19391, -701.32709, 1952.37366, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -697.39929, 1953.89355, 5.86000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19362, -701.32709, 1955.41553, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19435, -701.32709, 1957.82397, 5.86000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2566, -694.78632, 1922.04919, 4.66880,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2847, -696.88959, 1922.33191, 4.10900,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14867, -700.74438, 1923.45837, 5.63620,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19878, -692.20935, 1927.03296, 4.16920,   0.00000, 0.00000, 22.00000);
	CreateDynamicObject(19786, -697.81958, 1927.49780, 5.80270,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1744, -698.27930, 1927.57678, 4.45920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2028, -697.78839, 1927.30334, 4.87080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19554, -696.97198, 1927.24146, 4.84700,   -20.00000, 270.00000, 0.00000);
	CreateDynamicObject(2233, -692.86261, 1921.82251, 4.10900,   0.00000, 0.00000, 250.00000);
	CreateDynamicObject(2233, -692.74384, 1924.76501, 4.10900,   0.00000, 0.00000, 280.00000);
	CreateDynamicObject(2830, -697.81696, 1919.87048, 4.72002,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14820, -693.15527, 1923.78101, 5.02620,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1826, -693.12921, 1923.16541, 4.11060,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2964, -709.28699, 1940.21790, 4.10774,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11686, -704.72217, 1940.15625, 4.10750,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2350, -705.95062, 1938.89404, 4.43920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2350, -705.95062, 1939.92798, 4.43920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2350, -705.95062, 1940.96204, 4.43920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2350, -705.95062, 1941.85498, 4.43920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19812, -712.07666, 1936.41479, 4.58060,   0.00000, 0.00000, 300.00000);
	CreateDynamicObject(1486, -704.70251, 1942.22192, 5.23410,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1486, -704.76428, 1941.97290, 5.34810,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1486, -704.86981, 1942.07129, 5.34810,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14446, -710.76068, 1953.10999, 4.58130,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2617, -693.17322, 1949.07385, 4.72440,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2207, -694.87018, 1940.82043, 4.10190,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1713, -697.21552, 1944.09753, 4.11080,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1665, -694.23688, 1938.98999, 4.89050,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11735, -693.60413, 1938.82043, 4.11091,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11735, -693.85339, 1939.14990, 4.16090,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1714, -693.30988, 1940.15601, 4.11080,   0.00000, 0.00000, 300.00000);
	CreateDynamicObject(19513, -694.05200, 1940.53564, 4.87690,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1730, -702.33630, 1940.08984, 4.10500,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2238, -702.11151, 1940.04187, 5.66230,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19079, -701.99463, 1941.03821, 5.49200,   0.00000, 270.00000, 180.00000);
	CreateDynamicObject(14869, -704.41522, 1957.23767, 4.88540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2309, -704.44989, 1956.14453, 4.10751,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19893, -694.62787, 1940.07813, 4.87860,   0.00000, 0.00000, 40.00000);
	CreateDynamicObject(19619, -691.86627, 1939.02344, 5.01100,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2284, -696.67529, 1950.16492, 5.81320,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2319, -697.30188, 1950.19275, 4.10990,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2242, -696.57849, 1950.32971, 4.73280,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19376, -696.96332, 1953.09595, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -707.46490, 1953.09595, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -707.46490, 1943.46191, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -707.46490, 1933.82788, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -696.98480, 1933.82788, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -696.96332, 1943.46191, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -707.46490, 1924.19556, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -696.96490, 1924.19556, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -717.96490, 1933.82788, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19376, -717.96490, 1943.46191, 7.67660,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(14455, -722.69470, 1929.12134, 2.17500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1569, -725.80487, 1935.54126, 0.61410,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1569, -725.81091, 1938.54126, 0.61410,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1703, -717.28448, 1933.27039, 0.61520,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1703, -720.83447, 1935.16443, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1727, -725.23602, 1945.82727, 0.61510,   0.00000, 0.00000, 30.00000);
	CreateDynamicObject(2240, -723.57880, 1947.63574, 1.13490,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2242, -723.79761, 1946.83789, 0.77640,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2248, -724.76068, 1947.88220, 1.14690,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2257, -721.23041, 1948.24402, 2.07140,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14455, -725.80627, 1944.28186, 2.12480,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(948, -725.40283, 1934.54663, 0.61464,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2617, -724.33209, 1930.24524, 1.26060,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2811, -725.03058, 1931.75696, 1.24890,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2126, -718.08667, 1935.49634, 0.61480,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1491, -708.51251, 1927.50513, 4.08980,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1491, -695.70453, 1927.50513, 4.08980,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1491, -701.83429, 1950.11963, 4.11040,   0.00000, 0.00000, 230.00000);
	CreateDynamicObject(1491, -700.58807, 1953.86621, 4.09610,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1491, -701.32208, 1951.62231, 4.08760,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2570, -705.36719, 1948.95081, 4.10790,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(948, -712.22382, 1957.33972, 4.10782,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(948, -692.14856, 1951.10767, 4.10956,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2517, -694.32599, 1956.25354, 4.11330,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2523, -693.84900, 1951.32678, 4.10950,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, -696.07257, 1954.99268, 4.10950,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2261, -697.71143, 1951.35779, 5.68570,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2371, -697.50378, 1955.23645, 4.11031,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2394, -697.78381, 1955.81653, 4.79030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2843, -700.66766, 1956.76025, 4.11060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2847, -700.13342, 1954.64746, 4.11060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2846, -701.15411, 1956.26147, 4.11060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2844, -700.54907, 1956.04675, 4.11060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2845, -699.83331, 1956.17932, 4.11061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19366, -689.96600, 1949.88428, 0.54100,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19366, -686.46490, 1949.88428, 0.54100,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19366, -682.97028, 1949.88428, 0.54100,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19366, -679.47827, 1949.88428, 0.54100,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19366, -679.47827, 1927.40735, 0.54100,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19366, -682.97028, 1927.40735, 0.54100,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19366, -686.46490, 1927.40735, 0.54100,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19366, -689.96600, 1927.40735, 0.54100,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(870, -684.71600, 1953.86902, 0.61159,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(870, -690.39838, 1924.24866, 0.61159,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3532, -689.26288, 1920.04895, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -684.93390, 1920.04895, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -680.71588, 1920.04895, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -676.27588, 1920.04895, 0.61520,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(3532, -672.83490, 1920.04895, 0.61520,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(3532, -671.91272, 1922.42944, 0.61520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3532, -671.91272, 1926.64746, 0.61520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(801, -681.99426, 1923.45276, 0.61185,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(801, -678.44647, 1924.43713, 0.61190,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(3512, -684.63416, 1953.96899, 0.61509,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(870, -689.83099, 1923.95020, 0.61159,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2895, -681.36487, 1924.26636, 0.61633,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2895, -690.00793, 1924.08167, 0.61633,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2895, -684.90283, 1953.03333, 0.61633,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2895, -687.40601, 1922.38708, 0.61633,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(6965, -675.29608, 1953.68213, -1.49610,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(869, -675.77808, 1954.05310, 0.61450,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(869, -675.07965, 1952.92590, 0.61447,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(869, -674.65253, 1954.71228, 0.61447,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3512, -679.91907, 1923.84705, 0.61509,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(870, -679.89996, 1923.65503, 0.61159,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3532, -689.18927, 1956.70801, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -685.41528, 1956.70801, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -682.19629, 1956.70801, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -678.86627, 1956.70801, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -677.31232, 1956.70801, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -674.42627, 1956.70801, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -672.09528, 1956.70801, 0.61520,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3532, -671.85883, 1954.25537, 0.61520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3532, -671.85883, 1950.25940, 0.61520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2895, -675.33746, 1925.62891, 0.61633,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2895, -680.74915, 1953.72876, 0.61633,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2895, -675.46442, 1951.62219, 0.61633,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, -699.44592, 1919.91846, 1.28010,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(640, -694.20990, 1919.91846, 1.28010,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3785, -702.02521, 1940.63245, 0.43230,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3785, -702.02521, 1943.31836, 0.43230,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3785, -702.02521, 1945.83435, 0.43230,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1255, -673.66998, 1944.36865, 1.17890,   0.00000, 0.00000, 200.00000);
	CreateDynamicObject(1255, -673.66998, 1941.46472, 1.17890,   0.00000, 0.00000, 200.00000);
	CreateDynamicObject(16151, -671.88428, 1934.24219, 0.94960,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2227, -670.67926, 1943.07983, 0.61230,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2233, -670.76508, 1941.65601, 0.61240,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2233, -670.76508, 1944.35999, 0.61240,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(948, -705.66083, 1920.01270, 0.61537,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1825, -696.86169, 1933.69495, 0.60230,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19375, -696.98328, 1943.45581, -2.56840,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19375, -686.45129, 1943.46191, -2.56840,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19375, -686.45129, 1933.82959, -2.56840,   0.00000, 90.00000, 0.00000);
	//
	
	
	// Fabriken erste SF dann LS sowie Außenposten LS (Translated): Factories in LS and SF + the very first outpost in SF (tower)
    CreateDynamicObject(1463,-81.2000000,-1573.3000000,1.9000000,0.0000000,0.0000000,0.0000000); //object(dyn_woodpile2) (1)
	CreateDynamicObject(1280,-78.8000000,-1573.4000000,2.0000000,0.0000000,0.0000000,0.0000000); //object(parkbench1) (1)
	CreateDynamicObject(1280,-84.2000000,-1573.6000000,2.0000000,0.0000000,0.0000000,184.2500000); //object(parkbench1) (2)
	CreateDynamicObject(1280,-81.5000000,-1576.8000000,2.4000000,0.0000000,0.0000000,275.2500000); //object(parkbench1) (3)
	CreateDynamicObject(1280,-81.4000000,-1570.3000000,2.0000000,0.0000000,0.0000000,89.5000000); //object(parkbench1) (4)
	CreateDynamicObject(10763,-81.6000000,-1588.1000000,5.4000000,0.0000000,0.0000000,0.0000000); //object(controltower_sfse) (1)
	CreateDynamicObject(10775,-28.4000000,-1207.1000000,24.9000000,0.0000000,0.0000000,167.2450000); //object(bigfactory_sfse) (1)
	CreateDynamicObject(10843,-55.2000000,-1240.6000000,10.3000000,0.0000000,0.0000000,0.0000000); //object(bigshed_sfse01) (1)
	CreateDynamicObject(1337,534.4892600,-1859.4668000,6.1227900,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (1)
	CreateDynamicObject(10843,431.3999900,-1847.5000000,10.7000000,0.0000000,0.0000000,0.0000000); //object(bigshed_sfse01) (2)
	
	
	//
	
	
	
	// Platform for Artilerry in the sea between the 2 teams
	CreateDynamicObject(9946,-35,-1777.5,0.5,0,0,156);
	
	//
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
    for(new i=0; i<MAX_CAPTURE_POINTS;i++)
	{
	    if(Capture[i][cpid]==checkpointid)
	    {
			if(GetPlayerTeam(playerid)==255) return 1;
			PlayerInfo[playerid][pInCP]=-1;
		}
	}
	if(PlayerInfo[playerid][pProgress] != INVALID_PLAYER_BAR_ID)
	{
		HidePlayerProgressBar(playerid,PlayerInfo[playerid][pProgress]);
	}
	return 1;
}


stock GivePlayerMoneySave(playerid,money)
{
	ResetPlayerMoney(playerid);
	PlayerInfo[playerid][pMoney] = PlayerInfo[playerid][pMoney] + money;
	GivePlayerMoney(playerid,PlayerInfo[playerid][pMoney]);
	return 0;
}

stock GetPlayerMoneySave(playerid)
{
	return PlayerInfo[playerid][pMoney];
}
stock Stats(playerid)
{
	new string[128],Float:kd;
	kd = PlayerInfo[playerid][pKills] / PlayerInfo[playerid][pDeaths];
    format(string,sizeof(string),"Kills: %d\nDeaths: %d\nMoney: $%d\nK/D: %f",PlayerInfo[playerid][pKills],PlayerInfo[playerid][pDeaths],GetPlayerMoneySave(playerid),kd);
    ShowPlayerDialog(playerid,DIALOG_STATS,DIALOG_STYLE_MSGBOX,"Your Stats",string,"Okay","");
	return 0;
}



stock getFreeBomb()
{
	for(new i = 0; i<(sizeof(BombSystem)); i++)
	{
	    if(BombSystem[i][bombid] == -1) return i;
	}
	return -1;
}
stock DropBomb(playerid,art)
{
    new i = GetVehicleVehicleInfo(GetPlayerVehicleID(playerid));
    if(VehicleInfo[i][bombs] <1) return 0;
    new id = getFreeBomb();
	if(id == -1) return SCM(playerid,COLOR_RED,"Couldn't drop a Bomb!");
    // art 0 = 1x bomb, art 1 = 3er Bomb
    if(art == 1)
    {
        if(VehicleInfo[i][bombs] <3) return 0;
		SetPVarInt(playerid,"DroppingBombs",3);
		SetPVarInt(playerid,"DroppingFrom",i);
	}
    else
    {
        new dropbombs = GetPVarInt(playerid,"DroppingBombs");
	
	    dropbombs--;
	    if(dropbombs <= 0) { dropbombs = 0;}
	    
	    SetPVarInt(playerid,"DroppingBombs",dropbombs);
	
		BombSystem[id][bombid] = id;
		new Float: PlayerX, Float: PlayerY, Float: PlayerZ;
		GetPlayerPos(playerid,PlayerX,PlayerY,PlayerZ);


		if(PlayerZ > 10)
		{
			new Float:Height;
		


	        PlayerZ = PlayerZ - 1.5;
			BombSystem[id][localBomb] = CreateDynamicObject(1636,PlayerX,PlayerY,PlayerZ,0,0,0);

			GetXYInFrontOfPlayer(playerid,PlayerX,PlayerY,debug_howfar);

	        new Float:rx, Float:ry, Float:rz;
	        GetDynamicObjectRot(BombSystem[id][localBomb],rx,ry,rz);
	        MapAndreas_FindZ_For2DCoord(PlayerX, PlayerY, Height);
	     


			new movetime = MoveDynamicObject(BombSystem[id][localBomb],PlayerX,PlayerY,Height,debug_speed);

            DroppingBombs[playerid] = 1;
            
            SetTimerEx("NotDroppingBombs",movetime,0,"i",playerid);
		
		}
	}
	
	return 1;
	
}


forward NotDroppingBombs(playerid);
public NotDroppingBombs(playerid)
{
    DroppingBombs[playerid] = 0;
}

stock IsABombObject(objid)
{
    for(new i = 0; i<(sizeof(BombSystem)); i++)
	{
	    if(BombSystem[i][localBomb] == objid) return 1;
	}
	return 0;
}
public OnDynamicObjectMoved(objectid)
{
	
	for(new i = 0; i<(sizeof(BombSystem)); i++)
	{
	    if(BombSystem[i][bombid] != -1 && BombSystem[i][localBomb] == objectid)
	    {
            new Float: ObjPosX, Float: ObjPosY, Float: ObjPosZ;

	  		GetDynamicObjectPos(objectid,ObjPosX,ObjPosY,ObjPosZ);

	  		CreateExplosion(ObjPosX,ObjPosY,ObjPosZ,0,30.0);
	  		
			DestroyDynamicObject(objectid);
			
			BombSystem[i][bombid] = -1;
			
			break;
		}
	}
}
forward UpdateObjects();
public UpdateObjects()
{

    for(new i = 0; i<(sizeof(BombSystem)); i++)
	{
	    if(BombSystem[i][bombid] != -1 && IsValidDynamicObject(BombSystem[i][localBomb]))
	    {
	      //  printf("Objekt %d (BOMBID: %d) geupdatet!",i,BombSystem[i][bombid]);
	        new Float:rx, Float:ry, Float:rz;
            GetDynamicObjectRot(BombSystem[i][localBomb],rx,ry,rz);
            
            SetDynamicObjectRot(BombSystem[i][localBomb],rx+debug_rotationfloat,ry+debug_rotationfloat,rz+debug_rotationfloat);
		}
	}
	
	
	
//	beingCapturedTime
}


stock updateAllGangZones()
{
	for(new id=0; id<MAX_ZONES; id++)
	{
	    if(GangZones[id][ZoneID] != -1)
	    {
	        updateGangZone(id);
	    }
	}
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    //unknown author
    new Float:a;

    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);

    if (GetPlayerVehicleID(playerid)) {
        GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }

    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}

stock ShowPlayerBox(playerid,textbox[],interval)
{
	if(!strlen(textbox)) {SCM(playerid,-1,"Errorcode: 11111"); return 0;}
	if(strlen(textbox) > 150) {SCM(playerid,-1,"Errorcode: 22222"); return 0;}
	if(interval <-1 || interval > 1000) {SCM(playerid,-1,"Errorcode: 333333"); return 0;}
	if(PlayerInfo[playerid][pBoxShown]==true) {HideBox(playerid);}
	PlayerInfo[playerid][pBoxShown]=true;
	if(interval !=-1) // nicht uendlich
	{
	    SetTimerEx("HideBox", interval*1000, false, "i", playerid);
	    PlayerPlaySound(playerid,1084,0.0,0.0,0.0);
	}
	PlayerTextDrawSetString(playerid,PlayerBox[playerid],textbox);
 	PlayerTextDrawShow(playerid, PlayerBox[playerid]);
 	
 	
	return 1;
}
stock GetPointInFront2D(Float:x,Float:y,Float:rz,Float:radius,&Float:tx,&Float:ty){
	tx = x - (radius * floatsin(rz,degrees));
	ty = y + (radius * floatcos(rz,degrees));
}

/*
	AddPlayerClass(12,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(287,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(291,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(193,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(299,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClss(206,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(217,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(218,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
    AddPlayerClass(296,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);





	// Tank Driver 11 - 13

	AddPlayerClass(250,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(234,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(226,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);

	// Supply Driver 234 206 14-18

	AddPlayerClass(261,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(235,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(206,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(202,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);


	// Pilots 255 253


	AddPlayerClass(255,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
	AddPlayerClass(253,-65.4287,-1359.8640,12.4613,69.6762,0,0,0,0,0,0);
*/

stock GetPlayerClassJob(playerid,skinid)
{
	new job;
	
	if(skinid==12 ||skinid==287 ||skinid==291 ||skinid==193 ||skinid==299 ||skinid==206 ||skinid==217 ||skinid== 218||skinid==296) { job = 0;} //soldier

	if(skinid==250 || skinid==234 ||skinid==226) { job = 2;} // tank driver
	
	if(skinid==261 ||skinid==235 ||skinid==206 ||skinid==202) { job = 3;} // supply driver
	
	if(skinid==255 ||skinid==253) { job = 1;} // pilot
	
	return job;
}

stock GetJobName(jobid)
{
	new name[16];
	switch(jobid)
	{
	    case 0:
	    {
	        name="Soldier";
		}
		case 1:
	    {
	        name="Pilot";
		}
		case 2:
	    {
	        name="Tank Driver";
		}
		case 3:
	    {
	        name="Supply Driver";
		}
	}
	return name;
}
/*
stock GetPlayerClassJob(playerid,skinid)
{
		new job;
		switch(classid)
		{
		    case 0 .. 10:
		    {
		        job = 0; // soldier
			}
			case 11 .. 13:
		    {
		        job = 2; // tank driver
			}
			case 14 .. 18:
		    {
		        job = 3; // supply deliverer
			}
			case 19 .. 20:
		    {
		        job = 1; // pilot
			}
		}
		return job;
}*/
	
	
forward HideBox(playerid);
public HideBox(playerid)
{
 	PlayerTextDrawHide(playerid, PlayerBox[playerid]);
 	PlayerInfo[playerid][pBoxShown]=false;
 	return 1;
}


forward LoadGangZones();
public LoadGangZones()
{
    new query[128];


    format(query,sizeof(query),"SELECT * FROM `GangZones`");

    mysql_pquery(handle, query, "LoadGangZones2");
    return 1;
}
forward LoadGangZones2();
public LoadGangZones2()
{
    new rows;
    cache_get_row_count(rows);
    new id;
	if(rows)
	{
	    for(new i; i<rows; i++)
    	{
    	    cache_get_value_name_int(i, "zoneid", id);

            cache_get_value_name_int(i, "zoneid", GangZones[id][ZoneID]);

            cache_get_value_name_int(i, "ZoneArt", GangZones[id][ZoneArt]);
            
            cache_get_value_name_int(i, "ZoneActive", GangZones[id][ZoneActive]);
            
            cache_get_value_name_int(i, "DominatedBy", GangZones[id][DominatedBy]);

            cache_get_value_name(i, "ZoneName", GangZones[id][ZoneName],128);

            cache_get_value_name_float(i, "minx", GangZones[id][minx]);
	     	cache_get_value_name_float(i, "miny", GangZones[id][miny]);
	     	cache_get_value_name_float(i, "maxx", GangZones[id][maxx]);
	     	cache_get_value_name_float(i, "maxy", GangZones[id][maxy]);
	     	
	     	
	        if(GangZones[id][ZoneActive]){updateGangZone(id);}
		}
		return 1;
	}
	return 1;
}


updateGangZone(id) //continue?
{
//    new string[128];
	if(GangZones[id][FlagPickup] != -1)
	{
		DestroyPickup(GangZones[id][FlagPickup]);
	}
	if(GangZones[id][CaptureLabel] != Text3D:-1)
	{
		DestroyDynamic3DTextLabel(GangZones[id][CaptureLabel]);
	}
/*	if(GangZones[id][Zone_CP] != -1)
	{
	    DestroyDynamicCP(GangZones[id][Zone_CP]);
	  //  GangZones[id][Zone_CP] = -1;
	}
	if(IsValidDynamicCP(GangZones[id][LocalZone]))
	{
	    GangZoneDestroy(GangZones[id][LocalZone]);
	}*/


    new Float:CenterX, Float:CenterY,Float:CenterZ;
    
    
    CenterX = (GangZones[id][minx] + GangZones[id][maxx]) / 2; // thx to itsmaho and Syno
    
    CenterY = (GangZones[id][miny] + GangZones[id][maxy]) / 2;
    
   	MapAndreas_FindZ_For2DCoord(CenterX, CenterY, CenterZ);
   	
 //  	printf("CenterX: %f, CenterY: %f, CenterZ: %f, LocalZone: %d, GangZone: %d",CenterX,CenterY,CenterZ,GangZones[id][LocalZone],GangZones[id][Zone_CP],GangZones[id][LocalZone]);
	GangZones[id][Zone_CP]=CreateDynamicCP(CenterX, CenterY, CenterZ, 2.0);

	new text[256];

	if(GangZones[id][DominatedBy]==0)
	{
		format(text,sizeof(text), "{B18904}Dominated by Nobody. Enter to invade\nSpecial resource: %s, amount: %d", GetResourceName(GangZones[id][resource]),GangZones[id][resourceAmount]);
		GangZones[id][CaptureLabel]=CreateDynamic3DTextLabel(text, -1, CenterX, CenterY, CenterZ, 10);
	}
	else
  	{
		format(text,sizeof(text), "{B18904}Dominated by Team %s. Enter to invade\nSpecial resource: %s, amount: %d", GetTeamName(GangZones[id][DominatedBy]),GetResourceName(GangZones[id][resource]),GangZones[id][resourceAmount]);
		GangZones[id][CaptureLabel]=CreateDynamic3DTextLabel(text, -1, CenterX, CenterY, CenterZ, 10);
 	}

	if(GangZones[id][ZoneID] != -1)
	{
 		GangZones[id][LocalZone]=GangZoneCreate(GangZones[id][minx], GangZones[id][miny], GangZones[id][maxx], GangZones[id][maxy]);
	}
	
	GangZoneShowForAll(GangZones[id][LocalZone],GetTeamColor(GangZones[id][DominatedBy]));
	return 1;
}

forward LoadArtillerys();
public LoadArtillerys()
{
    new query[128];


    format(query,sizeof(query),"SELECT * FROM `Artillery`");

    mysql_pquery(handle, query, "LoadArtillerys2");
    return 1;
}


forward LoadArtillerys2();
public LoadArtillerys2()
{
    new rows;
    cache_get_row_count(rows);
    new id;
	if(rows)
	{
	    for(new i; i<rows; i++)
    	{
    	    new ar_id = FindFreeId();
	
	        if(ar_id == -1) return printf("Couldn't load row %d (ARTILLERY), Reason: Limit reached.",i);
	        
	        Artillery[ar_id][artid] = id;
    	    cache_get_value_name_int(i, "ListID", Artillery[id][artListID]);

            cache_get_value_name_float(i, "Art_PositonX", Artillery[ar_id][Art_PositonX]);
	     	cache_get_value_name_float(i, "Art_PositonY", Artillery[ar_id][Art_PositonY]);
	     	cache_get_value_name_float(i, "Art_PositonZ", Artillery[ar_id][Art_PositonZ]);
	     	
	     	cache_get_value_name_float(i, "Art_RotationX", Artillery[ar_id][Art_RotationX]);
	     	cache_get_value_name_float(i, "Art_RotationY", Artillery[ar_id][Art_RotationY]);
	     	cache_get_value_name_float(i, "Art_RotationZ", Artillery[ar_id][Art_RotationZ]);
	     	
	     	
	     	Artillery[ar_id][activeShooting] = true;
	     	
	     	Artillery[ar_id][isEnabled] = true;
	     	
	     	
	     	Artillery[ar_id][dominatedByTeam] = 0; 
	     	
	     	Artillery[ar_id][artLocalID] = CreateDynamicObject(3267,Artillery[ar_id][Art_PositonX],Artillery[ar_id][Art_PositonY],Artillery[ar_id][Art_PositonZ]-0.5,Artillery[ar_id][Art_RotationX],Artillery[ar_id][Art_RotationY],Artillery[ar_id][Art_RotationZ]);
	     	

			new Float:GoalX,Float:GoalY,Float:GoalZ;
			
			GetPointInFront2D(Artillery[ar_id][Art_PositonX],Artillery[ar_id][Art_PositonY],Artillery[ar_id][Art_PositonZ],60.0,GoalX,GoalY);
			
			MapAndreas_FindZ_For2DCoord(GoalX, GoalY, GoalZ);
			
			
			Artillery[ar_id][TargetPointX] =GoalX;
		    Artillery[ar_id][TargetPointY] =GoalY;
		    Artillery[ar_id][TargetPointZ] =GoalZ;
		    
		    
		    SetObjectFaceCoords3D(Artillery[ar_id][artLocalID],Artillery[ar_id][TargetPointX], Artillery[ar_id][TargetPointY], Artillery[ar_id][TargetPointZ],-0.0,270.0, -355.0);  // das zweite bearbeiten
			
			
			
			

		}
		return 1;
	}
	printf("Artillerys loaded: %d", rows);
	return 1;
}




public OnMissileFinished(Float:x,Float:y,Float:z)
{
    CreateExplosion(x,y,z,2,20); //explosion
    return 1;
}



forward FireArtillery(artilleryid);
public FireArtillery(artilleryid)
{
	if(artilleryid != -1)
	{
    	new id = findFreeProjectile();
    	new arteid = artilleryid;
    	if(id == -1) {print("no more ids"); return 0;}


		if(!Artillery[arteid][isEnabled]) return 0;
		
		if(Artillery[arteid][artLocalID] == INVALID_OBJECT_ID)
		{
			printf("Artillery ID %d destroyed or Invalid. Action taken: diabled",arteid);
			Artillery[arteid][isEnabled] = false;
			return 0;
		}
		
		
		Artillery[arteid][ammuNition]--;
  		if(Artillery[arteid][ammuNition] <=0)
  		{
  		    SendTeamMessage(Artillery[arteid][dominatedByTeam],"[ARTILLERY] Artillery with ID %d was deactivated, reason: lack of ammunition");  // could be send to team 0 (nobody) doesn't matter.
		  	Artillery[arteid][activeShooting] = false;
		}
		
		if(!Artillery[arteid][activeShooting]) return 0;

		
        new Random = random(21);
        float(Random);
        
        new Float:FloatValue;
		FloatValue = float(Random);

		
    //    printf("%f",FloatValue);
		new Random2 = random(2);
		switch(Random2)
		{
		    case 0:
		    {
			    Artillery[arteid][TargetPointX] = Artillery[arteid][TargetPointX] + FloatValue;
			    Artillery[arteid][TargetPointY]+=FloatValue;
			//    printf("ID %d, Random 0: X: %f, Y: %f, Z: %f",artilleryid,Artillery[arteid][TargetPointX],Artillery[arteid][TargetPointY],Artillery[arteid][TargetPointZ]);
			    
			    MapAndreas_FindZ_For2DCoord(Artillery[arteid][TargetPointX], Artillery[arteid][TargetPointY], Artillery[arteid][TargetPointZ]);

//			    SetObjectFaceCoords3D(Artillery[id][artLocalID],Artillery[id][TargetPointX], Artillery[id][TargetPointY], Artillery[id][TargetPointZ],0.0,0.0);
			}
			case 1:
			{
   				Artillery[arteid][TargetPointX]-=FloatValue;
			    Artillery[arteid][TargetPointY]-=FloatValue;
			 //   printf("ID %d, Random 1: X: %f, Y: %f, Z: %f",artilleryid,Artillery[arteid][TargetPointX],Artillery[arteid][TargetPointY],Artillery[arteid][TargetPointZ]);
		     	MapAndreas_FindZ_For2DCoord(Artillery[arteid][TargetPointX], Artillery[arteid][TargetPointY], Artillery[arteid][TargetPointZ]);
		     	
		     	
		     	
		     	
		     //	SetObjectFaceCoords3D(Artillery[id][artLocalID],Artillery[id][TargetPointX], Artillery[id][TargetPointY], Artillery[id][TargetPointZ],0.0,0.0);
			    
 			}

		}
		
	 //	printf("ID %d, Final Shot 1: X: %f, Y: %f, Z: %f",artilleryid,Artillery[arteid][TargetPointX],Artillery[arteid][TargetPointY],Artillery[arteid][TargetPointZ]);
        SetObjectFaceCoords3D(Artillery[arteid][artLocalID],Artillery[arteid][TargetPointX], Artillery[arteid][TargetPointY], Artillery[arteid][TargetPointZ],-0.0,270.0, -355.0);
		ProjectTile[id][p_objectID] = StartMissile(Artillery[arteid][Art_PositonX],Artillery[arteid][Art_PositonY],Artillery[arteid][Art_PositonZ]+1, Artillery[arteid][TargetPointX],Artillery[arteid][TargetPointY],Artillery[arteid][TargetPointZ]);

	}
	return 1;
}


/*/
artid,
	artLocalID,
	Float:Art_PositonX,
	Float:Art_PositonY,
	Float:Art_PositonZ,
	Float:Art_RotationX,
	Float:Art_RotationY,
	Float:Art_RotationZ,
	Float:TargetPointX,
	Float:TargetPointY,
	Float:TargetPointZ,

*/

stock FindFreeId()
{
	for(new i = 0; i<sizeof(Artillery);i++)
	{
	    if(Artillery[i][artid]==-1)return i;
	}
	return -1;
}

stock findFreeProjectile()
{
	for(new i = 0; i<sizeof(ProjectTile);i++)
	{
	    if(ProjectTile[i][p_id]==-1)return i;
	}
	return -1;
}


//

stock GetResourceName(resourceid)
{
	new string[20];
	switch (resourceid)
	{
	    case 0:
	    {
	        string = "Nothing";
		}
	    case 1:
	    {
	        string = "Manpower";
		}
		case 2:
	    {
	        string = "Artillery";
		}
		case 3:
	    {
	        string = "Airplanes";
		}
		case 4:
	    {
	        string = "Tanks";
		}
	 	default:
		{
		    string = "Unknown";
		}
	}
	return string;
}


stock SetObjectFaceCoords3D(iObject, Float: fX, Float: fY, Float: fZ, Float: fRollOffset = 0.0, Float: fPitchOffset = 0.0, Float: fYawOffset = 0.0) {  // credits to RyDeR`
    new
        Float: fOX,
        Float: fOY,
        Float: fOZ,
        Float: fPitch
    ;
    GetDynamicObjectPos(iObject, fOX, fOY, fOZ);

    fPitch = floatsqroot(floatpower(fX - fOX, 2.0) + floatpower(fY - fOY, 2.0));
    fPitch = floatabs(atan2(fPitch, fZ - fOZ));

    fZ = atan2(fY - fOY, fX - fOX) - 90.0; // Yaw

    SetDynamicObjectRot(iObject, fRollOffset, fPitch + fPitchOffset, fZ + fYawOffset);
}

//OCMD COMMANDS

ocmd:stats(playerid,params[])
{
	if(PlayerInfo[playerid][pLoggedIn]==0) return SCM(playerid,COLOR_RED,"You are not logged in!");
	Stats(playerid);
	return 1;
}

ocmd:help(playerid,params[])
{
	if(PlayerInfo[playerid][pLoggedIn]==0) return SCM(playerid,COLOR_RED,"You are not logged in!");
	SCM(playerid,-1,"HELP-COMMANDS: /focus /myteam /stats /help");
	if(PlayerInfo[playerid][pAdmin]!=0)
	{
	    SCM(playerid,-1,"Admin: HELP-COMMANDS: /kick /ban /setadmin /gethere /veh /adminteleport(useless)");
	}
	return 1;
}


ocmd:myteam(playerid,params[])
{
    new string[100];
    format(string,sizeof(string),"{6BE916}You're in Team %d or %s",GetPlayerTeam(playerid),GetTeamName(GetPlayerTeam(playerid)));
    SendClientMessage(playerid,-1,string);

    new Float:px,Float:py,Float:pz;

	GetPlayerPos(playerid,px,py,pz);
  //  if(veh != INVALID_VEHICLE_ID && IsVehicleInWater(veh)) return SCM(playerid,COLOR_ORANGE,"Vehicle in Water.");
    SetPlayerObjectMaterialText(playerid, PlayerInfo[playerid][mylabel],string, 0, OBJECT_MATERIAL_SIZE_256x128,"Arial", 28, 0, 0xF60000F6, 0xF60000F6, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
    return 1;
}


ocmd:focus(playerid,params[])
{
	if(PlayerInfo[playerid][pClassSelection] == false && PlayerInfo[playerid][pLoggedIn]==1){
	SetCameraBehindPlayer(playerid);}
    return 1;
}


// DEBUG COMMANDS ( TEMPORARY ) explainations on the top!

ocmd:speed(playerid,params[])
{
	new speedy;
	if(sscanf(params,"d",speedy))return SendClientMessage(playerid,-1,"/speed (set speed)");

	debug_speed = speedy;
	return 1;
}

ocmd:howfar(playerid,params[])
{
	new speedy;
	if(sscanf(params,"d",speedy))return SendClientMessage(playerid,-1,"/howfar (how far xy)");

	debug_howfar = speedy;
	return 1;
}

ocmd:rotation(playerid,params[])
{
	new Float:speedy;
	if(sscanf(params,"f",speedy))return SendClientMessage(playerid,-1,"/rotation (which rotation?)");

	debug_rotationfloat = speedy;
	return 1;
}

ocmd:testoommand(playerid,params[])   // can be changed everytime ( DEBUG COMMAND TO TEST ARTILLERY TARGET )
{
    SetPlayerCamera(playerid, 1);
    return 1;
}
ocmd:testoommand2(playerid,params[])   // can be changed everytime ( DEBUG COMMAND TO TEST ARTILLERY TARGET )
{
    SetPlayerCamera(playerid, 0);
    return 1;
}


//




// Admin Commands
ocmd:gethere(playerid,params[])
{
	new pid;
	if(!IsPlayerAdminEx(playerid,1))return SCM(playerid,COLOR_RED,"You are not permitted.");
	if(sscanf(params,"u",pid))return SendClientMessage(playerid,-1,"/gethere[playerid]");
	new Float:px,Float:py,Float:pz;

	GetPlayerPos(playerid,px,py,pz);

	SetPlayerPos(pid,px+1,py,pz);
	return 1;
}

ocmd:setadmin(playerid,params[])
{
	if(!IsPlayerAdmin(playerid))return SCM(playerid,COLOR_RED,"You are no RCON-Admin!");
	new pid,admin,string[100];
	if(sscanf(params,"ud",pid,admin))return SendClientMessage(playerid,-1,"/setadmin [playerid][Admin]");
	PlayerInfo[pid][pAdmin]=admin;

	format(string,sizeof(string),"%s is now Admin-Level %d",GetName(pid),admin);
	SCM(playerid,COLOR_GREEN,string);
	format(string,sizeof(string),"You were setted to Admin-Level %d by Administrator %s",admin,GetName(playerid));
	SCM(pid,COLOR_GREEN,string);
	return 1;
}

ocmd:kick(playerid,params[])
{
    new pid,reason[128],string[128];
    if(!IsPlayerAdminEx(playerid,1))return SCM(playerid,COLOR_RED,"You are not permitted.");
    if(sscanf(params,"us",pid,reason))return SendClientMessage(playerid,-1,"/kick [playerid][Reason]");
    if(strlen(reason) > 50) return SCM(playerid,COLOR_LIGHTRED,"Max: 50 Letters!");

	if(PlayerInfo[pid][pAdmin]>=PlayerInfo[playerid][pAdmin]) return SCM(playerid,COLOR_LIGHTRED,"You can't kick Admins on your Level!");
	format(string,sizeof(string),"[SYSTEM]: Adminstrator %s kicked %s, Reason: %s",GetName(playerid),GetName(pid),reason);
	SendClientMessageToAll(COLOR_GREEN,string);
	Kick(pid);
	return 1;
}
ocmd:ban(playerid,params[])
{
    new pid,reason[128],string[128],days,zeitdauer,zeitbann;
    if(!IsPlayerAdminEx(playerid,2))return SCM(playerid,COLOR_RED,"You are not permitted.");
    if(sscanf(params,"usd",pid,reason,days))return SendClientMessage(playerid,-1,"/ban [playerid][Reason][Days] [UNLIMITED = 999]");
    if(strlen(reason) > 50) return SCM(playerid,COLOR_LIGHTRED,"Max: 50 Letters!");
	if(PlayerInfo[pid][pLoggedIn]==0)return SCM(playerid,COLOR_LIGHTRED,"Error: Player not Logged In, Ban wouldn't have any Effect.");
	if(PlayerInfo[pid][pAdmin]>=PlayerInfo[playerid][pAdmin]) return SCM(playerid,COLOR_LIGHTRED,"You can't Ban Admins on your Level!");
	format(string,sizeof(string),"[SYSTEM]: Adminstrator %s banned %s for %i Days, Reason: %s",GetName(playerid),GetName(pid),days,reason);
	zeitdauer = gettime()+(60*60*24*days);
	if(days == 999)
	{
		zeitbann = 1;
		format(string,sizeof(string),"[SYSTEM]: Adminstrator %s permanently %s banned %s, Reason: %s",GetName(playerid),GetName(pid),reason);
	}
	BanUser(pid,GetName(playerid),reason,zeitdauer,zeitbann);
	SendClientMessageToAll(COLOR_LIGHTRED,string);
	return 1;
}

ocmd:veh(playerid,params[])
{
    if(PlayerInfo[playerid][pClassSelection] == false && PlayerInfo[playerid][pLoggedIn]==1)
    {
		new vehid, color1,color2;
		if(!IsPlayerAdminEx(playerid,1))return SCM(playerid,COLOR_RED,"You are not permitted.");
		if(sscanf(params,"iii",vehid,color1,color2))return SendClientMessage(playerid,COLOR_LIGHTRED,"Use: /veh [vehicleID][Color1][Color2]");

		new Float: X, Float: Y, Float: Z,Float:A;

		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,A);
		new car = CreateVehicle(vehid,X,Y,Z,A,color1,color2,-1);
		PutPlayerInVehicle(playerid,car,0);
		return 1;
	}
	return 1;
}


ocmd:adminteleport(playerid,params[])
{
    if(PlayerInfo[playerid][pClassSelection] == false && PlayerInfo[playerid][pLoggedIn]==1){
    new Random;
    Random = random(sizeof(LSSpawns));
   	SetPlayerPos(playerid, LSSpawns[Random][0], LSSpawns[Random][1], LSSpawns[Random][2]);
   	SetPlayerFacingAngle(playerid, LSSpawns[Random][3]);}
    return 1;
}





ocmd:setobjectrott(playerid,params[])
{
	new count,Float:fRollOffset,Float:fPitchOffset,Float:fYawOffset;
	if(sscanf(params,"fff",fRollOffset,fPitchOffset,fYawOffset))return SendClientMessage(playerid,-1,"/setobjectrott [fRollOffset] [fPitchOffset] [fYawOffset]");
	for(new i = 0; i<sizeof(Artillery);i++)
	{
	    if(Artillery[i][artid]!=-1)
	    {
	        if(IsPlayerInRangeOfPoint(playerid,6.0,Artillery[i][Art_PositonX],Artillery[i][Art_PositonY],Artillery[i][Art_PositonZ]))
	        {
	            count++;
		        SetObjectFaceCoords3D(Artillery[i][artLocalID],Artillery[i][TargetPointX], Artillery[i][TargetPointY], Artillery[i][TargetPointZ],fRollOffset ,fPitchOffset ,fYawOffset);
			}
		}
	}
    if(count == 0) return SCM(playerid,COOLRED,"[Set Rotation] You're not near any Artillery!");
    return 1;
}



























/*
ocmd:getzoneid(playerid,params[])
{

}*/
//
