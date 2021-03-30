params["_cram","_radarrange"];

#include "..\CfgDefines.hpp"

private _rate =	4615;
private _rangeCramAttention = 3000;
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

		_targetBoom = getText (configFile >> "CfgAmmo" >> typeOf _target >> "explosionEffects");
		_shots = floor random [_shotsMin, _shotsMid, _shotsMax];

		#ifdef AUDIO_WARNING
			playSound3D ["arma3_cram\sound\cramwarning.ogg", _cram, false, getPosASL _cram, 10, 1, 0];
		#endif

		// Maybe rather like this?: _cram getDir _target < 0 + 55 || _cram getDir _target > 360 - 55;
		//while {(alive _target) && (_dirTarget < (_fromTarget + 55)) && (_dirTarget > (_fromTarget - 55))} do {
		while {(alive _target) && (call _withinTurretAngle)} do {
			_distance = _target distance _cram;
			_distance2D = _target distance2D _cram;

			#ifdef DEBUG
				hintSilent format ["Target: %1 \nSalvos: %2 \nDistance: %3 \nDistance2D: %4", _target, _salvos, _distance, _distance2D];
			#endif

			if ((_target distance _cram < _rangeCramAttention) && (_target distance _cram > 50)) then {
				_cram doWatch _target;

				if ((_target distance _cram < _rangeCramEngage) && (_target distance _cram > 50) && (_cram weaponDirection (currentWeapon _cram)) select 2 > 0.1) then {
					// _cram aimedAtTarget [_target, (currentWeapon _cram)] > 0.9 ???

					_dummy = createVehicle ["CBA_B_InvisibleTargetAir", [0, 0, 0]];
					_dummy attachTo [_target, [0, 0, 0]];

					_test = createVehicle ["Sign_Sphere200cm_F", [0, 0, 0]];
					_test attachTo [_target, [0, 0, 0]];

					while {_shots > 0} do {
						_cram doWatch _dummy;
						_handle = _cram fireAtTarget [_dummy, currentWeapon _cram];

						waitUntil {_cram doWatch _dummy; _handle}; 

						_shots=_shots-1;
						sleep _timeBetweenShots;
					};
				
					_salvos = _salvos -1;
					if (_salvos == 0) then {
						"helicopterexplosmall" createVehicle (getPos _target);
						_targetBoom createVehicle (getPos _target);
						deleteVehicle _target;
						deleteVehicle _dummy;

						#ifdef DEBUG
						systemChat "CRAM HAS DESTROYED A VALID TARGET";
						#endif
					};

				};

			};
		};
		
	} else {sleep 2}; // SLEEP NO VALID TARGET

};