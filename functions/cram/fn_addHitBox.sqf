params['_target'];

#include "..\..\CfgDefines.hpp"

// Create Hitbox with 2x2x2 
_dummy = createVehicle ["ProtectionZone_Invisible_F", [0, 0, 0]];
_dummy attachTo [_target, [0, 0, 0]];
_dummy setObjectScale 0.05;

// Create visible 
#ifdef DEBUG
	_test = createVehicle ["Sign_Sphere200cm_F", [0, 0, 0]];
	_test attachTo [_target, [0, 0, 0]];
#endif

_dummy addEventHandler ["HitPart", {
	_dummy = (_this select 0) select 0;
	[attachedTo _dummy] call RR_fnc_destroyTarget;
}];