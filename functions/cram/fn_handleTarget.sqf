/**
	Handles tracking and shooting of a given target for one cram.

	@param _cram - Cram which should track and shoot the target
	@param _target - Target to track and destroy
 */

params['_cram', '_target'];

#include "..\..\CfgDefines.hpp"

// Sets cram busy
_cram setVariable ["RR_CRAM_BUSY", true];

private _timeBetweenShots = _cram getVariable["RR_CRAM_TIME_BETWEEN_SHOTS", 0.05];
private _rangeCramAttention = _cram getVariable["RR_CRAM_Attention", 2000];
Private _rangeEngageAttentionMin = 50;
private _rangeCramEngage = _cram getVariable["RR_CRAM_Engage", 1000];
private _shotRange = _cram getVariable ["RR_CRAM_SHOTS", [100, 200, 300]];
private _turretAngleMaxRight = {_cram getRelDir _target < 0 + 55};
private _turretAngleMaxLeft = {_cram getRelDir _target > 360 - 55};
private _withinTurretAngle = {call _turretAngleMaxLeft || call _turretAngleMaxRight};
private _unregisterTarget = {
	_tracked = missionNamespace getVariable ["RR_CRAM_TRACKED", []];
	missionNamespace setVariable ["RR_CRAM_TRACKED", _tracked - [_target]];
};
private _shots = floor random _shotRange;
private _dummyObjectScale = 0.05;

#ifdef AUDIO_WARNING
	{
		[_x] call RR_fnc_playAlarm;
		
	} forEach (_cram getVariable ["RR_CRAM_Speaker", []]);
#endif

#ifdef DEBUG
	if (call _withinTurretAngle) then
	{
		[_cram, _target] spawn RR_fnc_targetDebug;
	};
#endif

/* Wait until projectile is in reach */
private _error = false;
waitUntil{
	/* Get target */
	_target = [_cram, _target] call RR_fnc_getTarget;
	if(isNUll _target) exitWith {
		_error = true;
		true;
	};

	if (!(call _withinTurretAngle) && (_target distance _cram < _rangeEngageAttentionMin)) exitWith {
		_error = true;
		true;
	};

	(_target distance _cram < _rangeCramAttention);
};

if (_error) exitWith {
	call _unregisterTarget;
	_cram setVariable ["RR_CRAM_BUSY", false];
};

// Lets the turret look in the direction of the projectile
_cram doWatch _target;

/* Wait until target is engagment range */
waitUntil{
	/* Get target */
	_target = [_cram, _target] call RR_fnc_getTarget;
	if(isNUll _target) exitWith {
		_error = true;
		true;
	};

	if (!(call _withinTurretAngle) && (_target distance _cram < _rangeEngageAttentionMin)) exitWith {
		_error = true;
		true;
	};

	(_target distance _cram < _rangeCramEngage) && (_cram weaponDirection (currentWeapon _cram)) select 2 > 0.1; // ?
};

if (_error) exitWith {
	_cram doWatch objNull;
	call _unregisterTarget;
	_cram setVariable ["RR_CRAM_BUSY", false];
};

[_cram, _target, 250, _timeBetweenShots] call RR_fnc_shootTarget;

_cram doWatch objNull;
call _unregisterTarget;
_cram setVariable ["RR_CRAM_BUSY", false];