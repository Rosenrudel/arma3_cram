if(isServer)then{

// CONFIGURATION
	FSG_DEBUG = true; //Show debug info
	FSG_CURATORS = []; //Add game masters here or "allCurators". This will cause any Turret placed to turn from CIWS into a C-RAM. >UNDESIRABLE<!
	FSG_RADARRANGE = 5000; //Distance to scan for projectiles per CRAM
	FSG_SYSTEM = "B_AAA_System_01_F"; //The type of weapon system you want to apply CRAM function to
	FSG_IDENTIFIER = "isCram"; // Place in object init: this setVariable["isCram", true];

// ONLY CHANGE BELOW IF YOU KNOW WHAT YOU ARE DOING!

	{
		if(_x isKindOf FSG_SYSTEM && _x getVariable[FSG_IDENTIFIER,false]) then {
//		if(_x isKindOf FSG_SYSTEM) then {
//			if((side _x) == West)then{
			[_x,FSG_RADARRANGE] spawn RR_fnc_addCram;
//			waitUntil {player == player};
			systemChat "CRAM INIT FIRED";
//			};
		};
	} forEach vehicles;

	{
		_x addEventHandler["CuratorObjectPlaced",{
			_obj = _this select 1;
			if(_obj isKindOf FSG_SYSTEM && _obj getVariable[FSG_IDENTIFIER,false]) then {
				[_obj, FSG_RADARRANGE] spawn RR_fnc_addCram;
			};
		}];
	}forEach FSG_CURATORS;

};