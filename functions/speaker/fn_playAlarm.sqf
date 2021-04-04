/**
	Plays the pre init. sound at the speaker object.

	@param speaker - The speaker object
 */

params['_speaker'];

#include "..\..\CfgDefines.hpp"

if ((_speaker getVariable ["RR_CRAM_SPEAKER_BUSY", true])) exitWith {};



_speaker spawn {
		_this setVariable ["RR_CRAM_SPEAKER_BUSY", true];

		_sound = _this getVariable "RR_CRAM_SPEAKER_SOUND";
		_range = _this getVariable "RR_CRAM_SPEAKER_RANGE";
		[_this, [_sound, _range]] remoteExec ["say3D"];

		sleep (_this getVariable "RR_CRAM_SPEAKER_SOUND_LENGTH");

		_this setVariable ["RR_CRAM_SPEAKER_BUSY", false];
};