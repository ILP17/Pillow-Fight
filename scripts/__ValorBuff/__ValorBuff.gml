/**
	Kill
	
	@param {real} _turn_count
*/
function ValorBuff(_turn_count) : Buff(_turn_count, 1) constructor {
	stats = new StatsMultiplierModifier({ at: 1.5, mag: 1.25 });
}