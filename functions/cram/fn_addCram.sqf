params["_cram", ["_rate", 4615], ["_alone", true]];

#include "..\..\CfgDefines.hpp"

private _rangeCramAttention = 7000;
private _rangeCramEngage = 2000;

_cram setAutonomous true;

_cram setVariable ["RR_CRAM_Attention", 4000];
_cram setVariable ["RR_CRAM_Engage", 2000];
_cram setVariable ["RR_CRAM_TIME_BETWEEN_SHOTS", 1 / (_rate / 60)];
_cram setVariable ["RR_CRAM_SHOTS", [100, 200, 300]];

_cram setVariable ["RR_CRAM_BUSY", false];

#ifdef DEBUG
	systemChat format ["A CRAM HAS BEEN INITIALIZED AT %1", (mapGridPosition _cram)];
#endif

if (_alone) then
{
	[_cram, _cram] call RR_fnc_addRadar;
}