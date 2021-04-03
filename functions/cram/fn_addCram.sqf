/**
	Initialises a cram object

	@param _cram - Cram object
	@param _rate - Firerate of the cram
	@param _alone - If the cram object should operate indepentently
	@param _speaker - A list of all speaker objects for the cram
 */

params["_cram", ["_rate", 4615], ["_alone", true], ["_speaker", []]];

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
};

if (_alone) then
{
	_cram setVariable ["RR_CRAM_Speaker", [_cram]];
	[_cram] call RR_fnc_addSpeaker;

}else
{
	_cram setVariable ["RR_CRAM_Speaker", _speaker];
	{
		[_x] call RR_fnc_addSpeaker;
	} forEach _speaker;
};