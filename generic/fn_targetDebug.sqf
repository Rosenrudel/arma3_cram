/**
	Displays a debug hit window for a target.

	@param _turret - Turret wich tracks the targetKnowledge
	@param _target - Target to track.
*/

params["_turret", "_target"];


[
	{
		private _turret = (_this select 0) select 0;
		private _target = (_this select 0) select 1;

		systemChat str _this;

		if(isNull _target) then
		{
			[_this select 1] call CBA_fnc_removePerFrameHandler;
			systemChat "HALLO"
		}else
		{
			private _distance = _turret distance _target;
			private _distance2D = _turret distance2D _target;

			hintSilent format ["Target: %1 \nDistance: %2 \nDistance2D: %3", 
									_target,  _distance, _distance2D];
			
			};
	},
	0.5,
	[_turret, _target]
] call CBA_fnc_addPerFrameHandler;