/**
	Angel stop dying
	
	@param {real} _turn_count
*/
function ProtectionBuff(_turn_count) : Buff(_turn_count, 2) constructor {
	stats = new StatsMultiplierModifier({ df: 1.5 });
}