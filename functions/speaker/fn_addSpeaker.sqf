/**
	Initialises a speaker.	

	@param speaker - Speaker object
	@param alarmSound - Alarm sound to play
	@param alarmRange - Alarm sound range
 */

params['_speaker', ['_alarmSound', "CramWarning"], ['_alarmRange', 100]];

_speaker setVariable ["RR_CRAM_SPEAKER_BUSY", false];
_speaker setVariable ["RR_CRAM_SPEAKER_SOUND", _alarmSound];
_speaker setVariable ["RR_CRAM_SPEAKER_RANGE", _alarmRange];

#ifdef DEBUG
	systemChat format ["A SPEAKER HAS BEEN INITIALIZED AT %1 WITH RANGE %2", (mapGridPosition _speaker), _alarmRange];
#endif