class ArtiHandler
{
	debug = "systemChat str (_this select 6);";
	hitBox = "[_this select 6] call RR_fnc_addHitBox;";
};

class Extended_FiredBIS_Eventhandlers {
    class StaticMortar : ArtiHandler {};
	class StaticCannon : ArtiHandler {};
	class B_MBT_01_arty_base_F : ArtiHandler {};
	class B_Ship_Gun_01_F : ArtiHandler {};
};