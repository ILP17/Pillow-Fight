/**
	You wobblin big fella
	
	@param {real} _turn_count
*/
function StaggerBuff(_turn_count) : Buff(_turn_count, 3) constructor {
	stats = new StatsMultiplierModifier({ sp: 0.5 });
}