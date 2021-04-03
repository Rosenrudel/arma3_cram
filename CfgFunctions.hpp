class RR_CRAM
{
	tag = "RR";
	class CRAM
	{
		file = "arma3_cram\functions\cram"
		class initCram {};
		class addCram {};

		class calcLead {};
		class shootTarget {};

		class destroyTarget {};

		class targetDebug {};
	};

	class Generic
	{
		file = "arma3_cram\functions\radar";
		class discoverTargets {};
	}

	class Speaker
	{
		file = "arma3_cram\functions\speaker";
		class addSpeaker;
		class playAlarm;
	}
};