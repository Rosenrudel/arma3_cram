/**
	Destroys the given target and spawns an explosition.

	@param target - Target (Object) to destroy
 */

params['_target'];

#include "..\..\CfgDefines.hpp"

// Deletes the target
[typeOf _target, getPos _target] remoteExecCall ['RR_fnc_deleteTarget', 0];
//[typeOf _target, getPos _target] call RR_fnc_deleteTarget;

// Add extra explosion for drama
"helicopterexplosmall" createVehicle (getPos _target);

#ifdef DEBUG
	systemChat "CRAM HAS DESTROYED A VALID TARGET";
#endif