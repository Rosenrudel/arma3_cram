/**
	Destroys the given target and spawns an explosition.

	@param target - Target (Object) to destroy
 */

params['_target'];

#include "..\CfgDefines.hpp"

private _targetBoom = getText (configFile >> "CfgAmmo" >> typeOf _target >> "explosionEffects");

"helicopterexplosmall" createVehicle (getPos _target);
_targetBoom createVehicle (getPos _target);


// Deletes all attached objects
{
	deleteVehicle _x;
} forEach attachedObjects _target;


// Deletes the actual target
deleteVehicle _target;

#ifdef DEBUG
	systemChat "CRAM HAS DESTROYED A VALID TARGET";
#endif