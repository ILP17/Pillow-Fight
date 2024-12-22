/**
	Dont use this directly >:(
	
	@param {real} _turn_count
	@param {real} _icon_index
*/
function Buff(_turn_count, _icon_index = 0) constructor {
	iconIndex = _icon_index;
	turnCount = _turn_count;
	stats = new StatsMultiplierModifier({});
	
	static DecrementTurnCount = function() {
		turnCount --;
	}
}