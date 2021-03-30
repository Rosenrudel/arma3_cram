params["_cram","_radarrange"];
_null = [_cram,_radarrange]spawn{
	// private["_cram","_radarrange","_rate","_rangeCramAttention","_rangeCramEngage","_timeBetweenShots","_maxHeightIntercept","_shellRegistry","_targetRegistry","_target","_playAlert","_handleCBATargetDebug","_salvos","_shots","_targetsNotTracked"];
	// THIS ABOVE HERE NEEDS TO GO!! IT IS BAD FOR PERFORMANCE AS PER BIS WIKI
	private _cram = _this select 0;
	private _radarrange = _this select 1;
	private _rate =	4615;
	private _rangeCramAttention = 3000;
	private _rangeCramEngage = 1500;
	private _timeBetweenShots = 1 / (_rate / 60);
	private _maxHeightIntercept = 30;
	private _shellRegistry = [];
	private _isDecending = {velocity _this select 2 < 0}; //INSPIRED BY YAX'S ITC MOD
	private _canIntercept = {getPosATL _this select 2 > _maxHeightIntercept}; //INSPIRED BY YAX'S ITC MOD
	private _targetRegistry = [];
	private _targetsNotTracked = [];
	private _target = "";
	private _playAlert = false;
	private _salvos = 1;
	private _shots = 0;
	private _shotsMin = 100;
	private _shotsMid = 200;
	private _shotsMax = 300;
	private _turretAngleMaxRight = {_cram getRelDir _target < 0 + 55};
	private _turretAngleMaxLeft = {_cram getRelDir _target > 360 - 55};
	private _withinTurretAngle = {call _turretAngleMaxLeft || call _turretAngleMaxRight};
	systemChat format ["A CRAM HAS BEEN INITIALIZED AT %1", (mapGridPosition _cram)];
	while{alive _cram}do{
		
		_salvos = 1; // RESET SALVOS
		_shellRegistry = []; // RESET SHELLREGISTRY EMPTY

		_shellRegistry append (_cram nearObjects["Rocketbase",_radarrange]); // BETTER: ARRAY CHECK FOR IF CONDITION WITH LOOPING THROUGH BY VARIABLE
		_shellRegistry append (_cram nearObjects["ShellBase",_radarrange]);
//		_shellRegistry append (_cram nearObjects["MissileBase",_radarrange]); // conflicting with line 27 for incoming shells or rockets

		if(count _shellRegistry > 0) then {
			systemChat "A SHELL WAS REGISTERED BY CRAM";
			systemChat format ["SHELL: %1", _shellRegistry select 0]
		};

		_targetRegistry = _shellRegistry select {_x call _canIntercept && _x call _isDecending}; // INSPIRED BY YAX'S ITC MOD
		
		if(count _targetRegistry > 0) then {
			systemChat "AN INTERCEPTABLE TARGET WAS REGISTERED";
		};

		_targetsNotTracked = _targetRegistry select {!(_x getVariable ["isTracked",false])};
		
		if(count _targetsNotTracked > 0) then {
			systemChat "CRAM HAS IDENTIFIED VALID UNTRACKED TARGET";
		};

		_cram doWatch objNull; //RESET ORIENTATION FRONT IF NO VALID TARGET

		if(count _targetsNotTracked > 0) then {
			_target = selectrandom _targetsNotTracked;
			_target setVariable ["isTracked",true];
			systemChat format ["Target: %1, \nTracker: %2", _target, (_target getVariable ["isTracked",false]) ];
			_targetBoom = getText (configFile >> "CfgAmmo" >> typeOf _target >> "explosionEffects");
			_shots = floor random [_shotsMin, _shotsMid, _shotsMax];

			if (_playAlert == true) then {
				playSound3D ["arma3_cram\sound\cramwarning.ogg", _cram, false, getPosASL _cram, 10, 1, 0];
			};
			// Maybe rather like this?: _cram getDir _target < 0 + 55 || _cram getDir _target > 360 - 55;
			//while {(alive _target) && (_dirTarget < (_fromTarget + 55)) && (_dirTarget > (_fromTarget - 55))} do {
			while {(alive _target) && (call _withinTurretAngle)} do {
				_distance = _target distance _cram;
				_distance2D = _cram distance2D _target;

				hintSilent format ["Target: %1 \nSalvos: %2 \nDistance: %3 \nDistance2D: %4", _target, _salvos, _distance, _distance2D];
				if ((_target distance _cram < _rangeCramAttention) && (_target distance _cram > 50)) then {
					_cram doWatch _target;
					if ((_target distance _cram < _rangeCramEngage) && (_target distance _cram > 50) && (_cram weaponDirection (currentWeapon _cram)) select 2 > 0.20) then {
						// _cram aimedAtTarget [_target, (currentWeapon _cram)] > 0.9 ???
						while {_shots > 0} do {
							_cram doWatch _target;
							_cram fire [currentWeapon _cram, ""];
							_shots=_shots-1;
							sleep _timeBetweenShots;
						};
						_salvos = _salvos -1;
						if (_salvos == 0) then {
							_shellRegistry deleteAt (_shellRegistry find _target);
							_targetRegistry deleteAt (_targetRegistry find _target);
							_targetsNotTracked deleteAt (_targetsNotTracked find _target);
							"helicopterexplosmall" createVehicle (getPos _target);
							_targetBoom createVehicle (getPos _target);
							deleteVehicle _target;
							systemChat "CRAM HAS DESTROYED A VALID TARGET";
						};

					};

				};
			};
			
		} else {sleep 2}; // SLEEP NO VALID TARGET

	};

};