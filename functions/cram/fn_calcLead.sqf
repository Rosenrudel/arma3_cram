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
private _closeTargetValue = 600;
private _travelTime = 0;
private _leadVector = [];

if ((_turret distance _target) < _closeTargetValue) then
{
    _travelTime = (_turret distance _target)/_bulletVelocityClose;
} else
{
    _travelTime = (_turret distance _target)/_bulletVelocity;
};

/*
 \vec{x} + \dot{\vec{x}}} \cdot t
  With x the position of the target and approx. t the time to reach the target
*/
//(getPos _target) vectorAdd ((velocity _target) vectorMultiply _travelTime);
(getPos _target) vectorAdd ([0, 0, -9.81] vectorMultiply (_travelTime^2 * 0.5)) vectorAdd ((velocity _target) vectorMultiply _travelTime);