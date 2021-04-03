class RR_CRAM
{
	tag = "RR";
	class CRAM
	{
		file = "arma3_cram\functions\cram"
		class addCram {};

		class handleTarget {};

		class calcLead {};
		class shootTarget {};

		class destroyTarget {};

		class targetDebug {};
	};

	class Radar
	{
		file = "arma3_cram\functions\radar";
		class addRadar {};
		class discoverTargets {};
	}

	class Speaker
	{
		file = "arma3_cram\functions\speaker";
		class addSpeaker;
		class playAlarm;
	}
};