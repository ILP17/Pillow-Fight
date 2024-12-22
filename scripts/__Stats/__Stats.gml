/**
	Struct containing stats data
*/
function Stats(_config = {}) constructor {
	hp = _config[$ "hp"] ?? 10;
	at = _config[$ "at"] ?? 0;
	df = _config[$ "df"] ?? 0;
	sp = _config[$ "sp"] ?? 0;
	mag = _config[$ "mag"] ?? 0;
	
	/**
		@param {string} _stat_key
		@return {real}
	*/
	GetStat = function(_stat_key) {
		return self[$ _stat_key];
	}
}

/**
	Struct containing stats data as a multiplier
*/
function StatsMultiplierModifier(_config = {}) constructor {
	hp = _config[$ "hp"] ?? 1;
	at = _config[$ "at"] ?? 1;
	df = _config[$ "df"] ?? 1;
	sp = _config[$ "sp"] ?? 1;
	mag = _config[$ "mag"] ?? 1;
}