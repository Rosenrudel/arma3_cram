/**
	Destroys the given target and spawns an explosition.

	@param target - Target (Object) to destroy
 */

params['_target'];

#include "..\..\CfgDefines.hpp"

// Deletes all attached objects
{
	deleteVehicle _x;
} forEach attachedObjects _target;


// Triggers the target
triggerAmmo _target;

// Add extra explosion for drama
"helicopterexplosmall" createVehicle (getPos _target);

#ifdef DEBUG
	systemChat "CRAM HAS DESTROYED A VALID TARGET";
#endif