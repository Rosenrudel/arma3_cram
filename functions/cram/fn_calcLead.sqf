/**
	Calculates the postion, where the turret has to shoot to actualy hit the moving target.

	This function is using linear approximation of the targets movement and the velocity of
	the used bullet based on a fixed position along its trajectory in combination with fixed
	values for targeting to ensure hits on munition close to or near in front of the turret.


	@param _turret - The shooting turret
	@param _target - The target to calc the lead for
 */

params['_turret', '_target', ['_bulletVelocity', 1400]];

private _farTargetValue = (_turret distance _target) > 3000;
private _nearTargetValue = (_turret distance _target) > 1000;
private _closeTargetValue = (_turret distance _target) < 1000;
private _travelTime = (_turret distance _target)/_bulletVelocity;
private _leadVector = (velocity _target) vectorMultiply _travelTime;

(getPos _target) vectorAdd _leadVector;