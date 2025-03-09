/** 
 * @param _config
**/
function ExampleMonsterCharacter(_config = {}) : BaseBattleParticipantData() constructor {
	__ = {};
	with(__) {
		actions = _config[$ "actions"] ?? [BasicHitAction];
		strategies = _config[$ "strategies"] ?? [BasicActionStrategy];
		stats = _config[$ "stats"] ?? new Stats();
	}
	
	/** 
     * @param {string} _stat_key 
     * @return {real}
	**/
	GetStat = function(_stat_key) {
		return __.stats[$ _stat_key];
	}
	
	/** 
     * @return {real}
	**/
	GetActionCount = function() {
		return array_length(__.actions);
	}
	
	/** 
     * @param {real} _index 
     * @return {Struct.Action}
	**/
	GetAction = function(_index) {
		//Feather ignore once GM1045
		return new __.actions[_index]();
	}
	
	/** 
     * @return {real}
	**/
	GetStrategyCount = function() {
		return array_length(__.strategies);
	}
	
	/** 
     * @param {real} _index 
     * @return {Array<Struct.ActionStrategy>}
	**/
	GetStrategy = function(_index) {
		//Feather ignore once GM1045
		return new __.strategies[_index]();
	}
	
	name = _config[$ "name"] ?? "";
	sprite = _config[$ "sprite"] ?? SprPlayer;
	isBoss = _config[$ "isBoss"] ?? false;
}