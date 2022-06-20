/**
 * Checks if the supplied target is null and tries to find it again, based on the last known position.
 *
 * Arguments:
 * 0: Cram which handles the target
 * 1: Target to check
 *
 * Returns:
 * The target object if not null or if found again else objNull
 */

params['_cram', '_target'];

if(!(isNull _target)) exitWith {
	_cram setVariable ['RR_CRAM_CURRENT', _target];
	_cram setVariable ['RR_CRAM_LASTPOS', getPos _target];
	_cram setVariable ['RR_CRAM_LASTTYPE', typeOf _target];
	_target;
};

private _lastPos = _cram getVariable 'RR_CRAM_LASTPOS';

if(isNil "_lastPos") exitWith {objNull};

private _targets = _lastPos nearObjects [(_cram getVariable "RR_CRAM_LASTTYPE"), 50]; // TODO: Adaptive radius?

if(count _targets == 0) exitWith {objNull};

_target = _targets select 0;
_cram setVariable ['RR_CRAM_LASTPOS', getPos _target];

_target;