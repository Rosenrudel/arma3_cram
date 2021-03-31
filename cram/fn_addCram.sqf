params["_cram","_radarrange"];

#include "..\CfgDefines.hpp"

private _rate =	4615;
private _rangeCramAttention = 4000;
private _rangeCramEngage = 1500;
private _timeBetweenShots = 1 / (_rate / 60);
private _maxHeightIntercept = 30;
private _targetRegistry = [];
private _targetsNotTracked = [];
private _target = "";
private _playAlert = false;
private _salvos = 1;
private _shots = 0;
private _shotsMin = 100;
private _shotsMid = 200;
private _shotsMax = 300;
private _turretAngleMaxRight = {_cram getRelDir _target < 0 + 55};
private _turretAngleMaxLeft = {_cram getRelDir _target > 360 - 55};
private _withinTurretAngle = {call _turretAngleMaxLeft || call _turretAngleMaxRight};

_cram setAutonomous true;

#ifdef DEBUG
	systemChat format ["A CRAM HAS BEEN INITIALIZED AT %1", (mapGridPosition _cram)];
#endif


while{alive _cram}do{
	
	_salvos = 1; // RESET SALVOS
	_targetsNotTracked = [getPosATL _cram, _radarrange] call RR_fnc_discoverTargets; // Get Targets

	_cram doWatch objNull; //RESET ORIENTATION FRONT IF NO VALID TARGET

	if(count _targetsNotTracked > 0) then {
		_target = selectrandom _targetsNotTracked;

		#ifdef DEBUG
		systemChat format ["Target: %1, \nTracker: %2", _target, (_target getVariable ["isTracked",false]) ];
		#endif

		
		_shots = floor random [_shotsMin, _shotsMid, _shotsMax];

		#ifdef AUDIO_WARNING
			playSound3D ["arma3_cram\sound\cramwarning.ogg", _cram, false, getPosASL _cram, 10, 1, 0];
		#endif

		#ifdef DEBUG
			if (call _withinTurretAngle) then
			{
				[_cram, _target] spawn RR_fnc_targetDebug;
			};
		#endif

		waitUntil{
			if (!((alive _target) && (call _withinTurretAngle))) exitWith {contine};

			(_target distance _cram < _rangeCramAttention) && (_target distance _cram > 50);
		};

		_cram doWatch _target;

		waitUntil{
			if (!((alive _target) && (call _withinTurretAngle))) exitWith {contine};

			(_target distance _cram < _rangeCramEngage) && (_target distance _cram > 50) && (_cram weaponDirection (currentWeapon _cram)) select 2 > 0.1;
		};

		// Create Hitbox with 2x2x2
		_dummy = createVehicle ["ProtectionZone_Invisible_F", [0, 0, 0]];
		_dummy attachTo [_target, [0, 0, 0]];
		_dummy setObjectScale 0.05;
		
		// Create visible 
		#ifdef DEBUG
			_test = createVehicle ["Sign_Sphere200cm_F", [0, 0, 0]];
			_test attachTo [_target, [0, 0, 0]];
		#endif

		_dummy addEventHandler ["HitPart", {
			_dummy = (_this select 0) select 0;
			[attachedTo _dummy] call RR_fnc_destroyTarget;
		}];

		[_cram, _target, 250, _timeBetweenShots] call RR_fnc_shootTarget;
		
	} else {sleep 2}; // SLEEP NO VALID TARGET
};