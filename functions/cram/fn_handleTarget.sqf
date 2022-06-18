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

waitUntil{
	if (!((alive _target) && (call _withinTurretAngle))) exitWith {true};

	(_target distance _cram < _rangeCramAttention) && (_target distance _cram > _rangeEngageAttentionMin);
};

if (!((alive _target) && (call _withinTurretAngle))) exitWith {
	call _unregisterTarget;
	_cram setVariable ["RR_CRAM_BUSY", false];
};

_cram doWatch _target;

waitUntil{
	if (!((alive _target) && (call _withinTurretAngle))) exitWith {true};

	(_target distance _cram < _rangeCramEngage) && (_target distance _cram > _rangeEngageAttentionMin) && (_cram weaponDirection (currentWeapon _cram)) select 2 > 0.1;
};

if (!((alive _target) && (call _withinTurretAngle))) exitWith {
	_cram doWatch objNull;
	call _unregisterTarget;
	_cram setVariable ["RR_CRAM_BUSY", false];
};

[_cram, _target, 250, _timeBetweenShots] call RR_fnc_shootTarget;

_cram doWatch objNull;
call _unregisterTarget;
_cram setVariable ["RR_CRAM_BUSY", false];