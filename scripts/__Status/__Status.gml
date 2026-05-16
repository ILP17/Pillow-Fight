/**
 * @param {String} _id
 * @param {real} _turn_count
 * @param {real} _icon_index
**/
function Status(_id, _turn_count, _icon_index = 0) constructor {
	id = _id;
	icon_index = _icon_index;
	turn_count = _turn_count;
	stats = new StatsMultiplierModifier({});
	
	static DecrementTurnCount = function() {
		turn_count --;
	}
}