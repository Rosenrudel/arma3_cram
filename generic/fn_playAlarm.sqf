/**
	Plays the cram warning alarm on the defined speaker for each cram unit that is placed
	or when multiple crams are with in a defined range to eachother lowers the volume on
	the cram unit defined speakers.

	@param cram - The initialized cram unit.
 */

params['_cram'];

private _cram = _this select 0;
private _localDistanceCrams = 200;
private _localCramPool = [];
private _localCramPool = _localCramPool append [_cram];
private _localCramDetectionObject = poolObject;


