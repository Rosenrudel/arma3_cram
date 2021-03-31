class RR_CRAM
{
	tag = "RR";
	class CRAM
	{
		file = "arma3_cram\cram"
		class initCram {};
		class addCram {};
	};

	class Generic
	{
		file = "arma3_cram\generic";
		class discoverTargets {};

		class calcLead {};
		class shootTarget {};

		class destroyTarget {};

		class targetDebug {};
	}
};