/**
	Calculates the postion, where the turret has to shoot to actualy hit the moving target.

	This function is using linear approximation of the targets movement and the velocity of
	the used bullet based on a fixed position along its trajectory in combination with fixed
	values for targeting to ensure hits on munition close to or near in front of the turret.


	@param _turret - The shooting turret
	@param _target - The target to calc the lead for
 */

params['_turret', '_target'];

private _bulletVelocity = 1400;
private _bulletVelocityClose = 1500;
private _closeTargetBool = (_turret distance _target) < 600;
private _travelTime = [];
private _leadVector = [];
private _gottaGoFast = [];

if (_closeTargetBool) then {
	setVariable [_gottaGoFast, 1];
};

switch _gottaGoFast do {
	case "0": {_travelTime = (_turret distance _target)/_bulletVelocity};
	case "1": {_travelTime = (_turret distance _target)/_bulletVelocityClose};
};

(getPos _target) vectorAdd [(velocity _target) vectorMultiply _travelTime];