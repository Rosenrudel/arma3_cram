/**
	Calculates the postion, where the turret has to shoot to actualy hit the moving target.

	This function is using linear approximation of the targets movement and the velocity of the used bullet.

	@param _turret - The shooting turret
	@param _target - The target to calc the lead for
 */

params['_turret', '_target', ['_bulletVelocity', 1400]];


private _travelTime = (_turret distance _target)/_bulletVelocity;

private _leadVector = (velocity _target) vectorMultiply _travelTime;

(getPos _target) vectorAdd _leadVector;