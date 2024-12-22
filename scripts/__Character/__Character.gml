/**
	Interface representing a character
*/
function Character() constructor {
	/**
		@param {string} _stat_key
		@return {real}
	*/
	GetStat = function(_stat_key) {
		ScrEnforceImplementation(instanceof(self), nameof(GetStat));
	}
	
	/**
		@return {real}
	*/
	GetActionCount = function() {
		ScrEnforceImplementation(instanceof(self), nameof(GetActionCount));
	}
	
	/**
		@param {real} _index
		@return {struct.Action}
	*/
	GetAction = function(_index) {
		ScrEnforceImplementation(instanceof(self), nameof(GetAction));
	}
	
	/**
		@return {real}
	*/
	GetStrategyCount = function() {
		ScrEnforceImplementation(instanceof(self), nameof(GetStrategyCount));
	}
	
	/**
		@param {real} _index
		@return {struct.ActionStrategy}
	*/
	GetStrategy = function(_index) {
		ScrEnforceImplementation(instanceof(self), nameof(GetStrategy));
	}
}