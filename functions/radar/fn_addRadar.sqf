/**
	Adds a radar object to the given object.
	
	@param _radar - Radar object
	@param _cram  - Cram object
 */
params['_radar', ['_cram', objNull]];

#include "..\..\CfgDefines.hpp"

private _crams = [];

// Get max radar range from vehicle config
private _radarrange = getNumber (configfile >> "CfgVehicles" >> typeOf _radar >> "Components" >> "SensorsManagerComponent" >> "Components" >> "ActiveRadarSensorComponent" >> "typeRecognitionDistance");

#ifdef DEBUG
	systemChat format ["A RADAR HAS BEEN INITIALIZED AT %1 WITH RANGE %2", (mapGridPosition _cram), _radarrange];
#endif


if (isNull _cram) then
{
	_cram = synchronizedObjects _radar;
}else
{
	_crams = [_cram]
};

_handle = [
	{
		_radar = (_this select 0) select 0;
		_crams  = (_this select 0) select 1;
		_radarrange = (_this select 0) select 2;

		// Get possible targets
		_targetsNotTracked = [getPosATL _radar, _radarrange] call RR_fnc_discoverTargets;
		// Get free crams
		_freeCrams = _crams select {!(_x getVariable ["RR_CRAM_BUSY", true])};

		// Distribute Targets between the crams
		{
			_currentCram = _x;

			if (count _targetsNotTracked > 0) then
			{
				_target = ([_targetsNotTracked, [getPos _currentCram], {_input0 distance _x}] call BIS_fnc_sortBy) select 0;
				[_x, _target] spawn RR_fnc_handleTarget;

				#ifdef DEBUG
					systemChat format ["Target: %1, Tracker: %2", _target, _currentCram];
				#endif
			};
			
		} forEach _freeCrams ;

		// Remove event handler if the radar is dead
		if (!alive _radar) then { [_this select 1] call CBA_fnc_removePerFrameHandler; }
	},
	1,
	[_radar, _crams, _radarrange]
] call CBA_fnc_addPerFrameHandler;