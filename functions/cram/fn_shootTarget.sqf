/**
	Forces a given turret to shoot with a given amount of shots at a given target with calculated lead.

	@param _turret - Turret to shoot with
	@param _target - Target to shoot at
	@param _dummy  - Hitbox
	@param _shots  - Amount of shots
	@param _timeBetweenShots - Time between two shots
 */

params['_turret', '_target', '_dummy','_shots', '_timeBetweenShots'];

#include "..\..\CfgDefines.hpp"

private _groundUpAngle = 0.17;
private _interceptSpeedPreset = 1200;

_handle = [
	{
	private _turret = (_this select 0) select 0;
	private _target = (_this select 0) select 1;
	private _dummy = (_this select 0) select 2;

	_lead = [_turret, _target, _interceptSpeedPreset] call RR_fnc_calcLead;
	_turret lookAt _lead;

	// Delete the hitbox if the target is to low
	if (getPosATL _target select 2 < 10) then { deleteVehicle _dummy; }
	},
	0,
	[_turret, _target, _dummy]
] call CBA_fnc_addPerFrameHandler;

// Wait for the turret to be on target
sleep 1;
waitUntil{
	sleep 0.2; 
	_toTarget = (getPos _target) vectorDiff (getPos _turret);
	_aim = _turret weaponDirection currentWeapon _turret;
	acos(_toTarget vectorCos _aim) < 10;
};

// Repeat until target is not longer alive or not longer in allowed angle zone
while {alive _target && (_turret weaponDirection (currentWeapon _turret)) select 2 > _groundUpAngle} do
{
	for [{private _i = 0}, {_i < _shots && alive _target}, {_i = _i +1}] do
	{	
		// Force position synchronization for the hitbox
		_dummy setPos getPos _target;
		
		[_turret, currentWeapon _turret] call BIS_fnc_fire;
		sleep _timeBetweenShots;
	};

	sleep 2;
};

[_handle] call CBA_fnc_removePerFrameHandler;
