/**
	@param _config
*/
function PlayerCharacter(_config = {}) : Character() constructor {
	__ = {};
	with(__) {
		actions = _config[$ "actions"] ?? [];
		strategies = _config[$ "strategies"] ?? [];
		level = _config[$ "level"] ?? 1;
		class = ThrowIfUndefined(_config[$ "class"], "class");
	}
	
	/**
		@param {string} _stat_key
		@return {real}
	*/
	GetStat = function(_stat_key) {
		return __.class.GetStat(_stat_key, __.level);
	}
	
	/**
		@return {real}
	*/
	GetActionCount = function() {
		return array_length(__.actions) + array_length(__.class.GetActions());
	}
	
	/**
		@param {real} _index
		@return {Array<Function>}
	*/
	GetAction = function(_index) {
		var _array = array_union(__.actions, __.class.GetActions());
		//Feather ignore once GM1045
		return new _array[_index]();
	}
	
	/**
		@return {real}
	*/
	GetStrategyCount = function() {
		return array_length(__.strategies) + array_length(__.class.GetStrategies());
	}
	
	/**
		@param {real} _index
		@return {Array<Struct.ActionStrategy>}
	*/
	GetStrategy = function(_index) {
		var _array = array_union(__.strategies, __.class.GetStrategies());
		//Feather ignore once GM1045
		return new _array[_index]();
	}
	
	name = _config[$ "name"] ?? "";
	sprite = _config[$ "sprite"] ?? SprPlayer;
	isBoss = _config[$ "isBoss"] ?? false;
}