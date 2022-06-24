/**
	Adds a radar object to the given object.
	
	@param _radar - Radar object
	@param _cram  - Cram object
 */
params['_radar', ['_cram', objNull], ['_speaker', []]];

#include "..\..\CfgDefines.hpp"

private _crams = [];

// Get max radar range from vehicle config
private _radarrange = getNumber (configfile >> "CfgVehicles" >> typeOf _radar >> "Components" >> "SensorsManagerComponent" >> "Components" >> "ActiveRadarSensorComponent" >> "typeRecognitionDistance");

#ifdef DEBUG
	systemChat format ["A RADAR HAS BEEN INITIALIZED AT %1 WITH RANGE %2", (mapGridPosition _radar), _radarrange];
#endif


if (isNull _cram) then
{
	_crams = synchronizedObjects _radar;
}else
{
	_crams = [_cram]
};

_radar setVariable ["RR_CRAM_RADAR_Speaker", _speaker];
{
	[_x] call RR_fnc_addSpeaker;
} forEach _speaker;


_handle = [
	{
		_radar = (_this select 0) select 0;
		_crams  = (_this select 0) select 1;
		_radarrange = (_this select 0) select 2;
		
		_trackedTargets_old = missionNamespace getVariable ["RR_CRAM_TRACKED", []];
		_lastPositions_old = missionNameSpace getVariable ["RR_CRAM_LASTPOSITIONS", []];
		_lastTypes_old = missionNameSpace getVariable ["RR_CRAM_LASTTYPES", []];

		_trackedTargets = [];
		_lastPositions = [];
		_lastTypes = [];

		/* Update tracked targets which can get null and try to find them again */
		{
			_target = _x;
			if(isNull _target) then {
				_pos = _lastPositions_old select _forEachIndex;
				_type = _lastTypes_old select _forEachIndex;
				_targets = _pos nearObjects [_type, 100];

				if(count _targets != 0) then {
					_target = _targets select 0;
				}else{
					continue;
				}
			};

			_trackedTargets pushBack (_target);
			_lastPositions pushBack (getPos _target);
			_lastTypes pushBack (typeOf _target);
		}foreach _trackedTargets_old;


		missionNamespace setVariable ["RR_CRAM_TRACKED", _trackedTargets, true];
		missionNameSpace setVariable ["RR_CRAM_LASTPOSITIONS", _lastPositions, true];
		missionNameSpace setVariable ["RR_CRAM_LASTTYPES", _lastTypes, true];

		// Get possible targets
		_targetsNotTracked = ([getPosATL _radar, _radarrange] call RR_fnc_discoverTargets) select {!(_x in (missionNamespace getVariable ["RR_CRAM_TRACKED", []]))};

		diag_log format ["New: %1 | Old: %2", _targetsNotTracked, _trackedTargets];
		// Get free crams
		_freeCrams = _crams select {!(_x getVariable ["RR_CRAM_BUSY", true])};

		if ((count _targetsNotTracked) + (count _trackedTargets) > 0) then
		{
			{
				[_x] call RR_fnc_playAlarm;
				
			} forEach (_radar getVariable ["RR_CRAM_RADAR_Speaker", []]);
		};

		// Distribute Targets between the crams
		{
			_currentCram = _x;
			
			if (count _targetsNotTracked > 0) then
			{
				_target = (([_targetsNotTracked, [_currentCram], {_input0 distance _x}] call BIS_fnc_sortBy)) select 0;

				//_trackedTargets = missionNamespace getVariable ["RR_CRAM_TRACKED", []];
				_trackedTargets pushBack _target;
				_lastPositions pushBack (getPos _target);
				_lastTypes pushBack (typeOf _target);

				_targetsNotTracked deleteAt (_targetsNotTracked find _target);

				[_x, _target] spawn RR_fnc_handleTarget;

				#ifdef DEBUG
					diag_log format ["Target: %1, Tracker: %2", _target, _currentCram];
				#endif
			};
			
		} forEach _freeCrams ;

		missionNamespace setVariable ["RR_CRAM_TRACKED", _trackedTargets, true];
		missionNameSpace setVariable ["RR_CRAM_LASTPOSITIONS", _lastPositions, true];
		missionNameSpace setVariable ["RR_CRAM_LASTTYPES", _lastTypes, true];

		#ifdef DEBUG
			//diag_log str (missionNamespace getVariable ["RR_CRAM_TRACKED", []]);
		#endif

		// Remove event handler if the radar is dead
		if (!alive _radar) then { [_this select 1] call CBA_fnc_removePerFrameHandler; }
	},
	0,
	[_radar, _crams, _radarrange]
] call CBA_fnc_addPerFrameHandler;