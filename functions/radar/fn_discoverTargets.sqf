/**
	Discovers Targets (Missles, Rockets and Artillery Shells)

	@param _position - Position from which the range is calculated
	@param _range	 - Range from which targets are aquiered
	@param _minHeightIntercept - (opt.) Minimal height for a shell
 */
params["_position", "_range", ["_minHeightIntercept", 30]];

#include "..\..\CfgDefines.hpp"

private _shellRegistry = [];

// Discover Rockets
_shellRegistry append (_cram nearObjects["Rocketbase",_range]);
_shellRegistry append (_cram nearObjects["SubmunitionBase",_range]);

// Discover Artillery Shells
_shellRegistry append (_cram nearObjects["ShellBase",_range]);

// Discover Missiles
_shellRegistry append (_cram nearObjects["MissileBase",_range]);


#ifdef DEBUG
if(count _shellRegistry > 0) then {
	systemChat "A SHELL WAS REGISTERED BY CRAM";
	systemChat format ["SHELL: %1", _shellRegistry select 0]
};
#endif

// Targets have to be falling and _minHeightIntercept m over the ground
_targetRegistry = _shellRegistry select {(velocity _x select 2 < 0) && (getPosATL _x select 2 > _minHeightIntercept)}; // INSPIRED BY YAX'S ITC MOD

#ifdef DEBUG
if(count _targetRegistry > 0) then {
	systemChat "AN INTERCEPTABLE TARGET WAS REGISTERED";
};
#endif

_targetRegistry;