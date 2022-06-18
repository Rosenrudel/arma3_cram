/**
	Destroys the given target and spawns an explosition.

	@param target - Target (Object) to destroy
 */

params['_target'];

#include "..\..\CfgDefines.hpp"

// Triggers the target
//triggerAmmo _target;

deleteVehicle _target;

// Add extra explosion for drama
"helicopterexplosmall" createVehicle (getPos _target);

#ifdef DEBUG
	systemChat "CRAM HAS DESTROYED A VALID TARGET";
#endif