params['_type', '_position'];

// Get the target
private _target = nearestObject [_position, _type];

// Deletes all attached objects
{
	deleteVehicle _x;
} forEach attachedObjects _target;

// Deletes the actual target
//deleteVehicle _target;
triggerAmmo _target;