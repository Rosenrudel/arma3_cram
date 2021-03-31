/**
	Forces a given turret to shoot with a given amount of shots at a given target with calculated lead.

	@param _turret - Turret to shoot with
	@param _target - Target to shoot at
	@param _shots  - Amount of shots
	@param _timeBetweenShots - Time between two shots
 */

params['_turret', '_target', '_shots', '_timeBetweenShots'];

#include "..\CfgDefines.hpp"

_handle = [
	{
	private _turret = (_this select 0) select 0;
	private _target = (_this select 0) select 1;

	_lead = [_turret, _target, 1200] call RR_fnc_calcLead;
	_turret lookAt _lead;
	},
	0,
	[_turret, _target]
] call CBA_fnc_addPerFrameHandler;

// Wait for the turret to be on target
sleep 2;

while {alive _target} do
{
	for [{private _i = 0}, {_i < _shots && alive _target}, {_i = _i +1}] do
	{
		[_turret, currentWeapon _turret] call BIS_fnc_fire;
		sleep _timeBetweenShots;
	};

	sleep 2;
};

[_handle] call CBA_fnc_removePerFrameHandler;
