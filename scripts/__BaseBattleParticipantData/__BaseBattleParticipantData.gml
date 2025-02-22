/**
 * Interface representing a character
**/
function BaseBattleParticipantData() constructor {
	/**
	 * @param {string} _stat_key
	 * @return {real}
	**/
	GetStat = function(_stat_key) {
		ScrThrowNotImplemented(instanceof(self), nameof(GetStat));
	}
	
	/**
     * Gets the number of available actions
	 * @return {real}
	**/
	GetActionCount = function() {
		ScrThrowNotImplemented(instanceof(self), nameof(GetActionCount));
	}
	
	/**
     * Gets an action
	 * @param {real} _index
	 * @return {Struct.Action}
	**/
	GetAction = function(_index) {
		ScrThrowNotImplemented(instanceof(self), nameof(GetAction));
	}
	
	/**
     * Gets the number of available action strategies
     * @return {real}
	**/
	GetStrategyCount = function() {
		ScrThrowNotImplemented(instanceof(self), nameof(GetStrategyCount));
	}
	
	/**
     * Gets a strategy
	 * @param {real} _index
	 * @return {Struct.ActionStrategy}
	**/
	GetStrategy = function(_index) {
		ScrThrowNotImplemented(instanceof(self), nameof(GetStrategy));
	}
}