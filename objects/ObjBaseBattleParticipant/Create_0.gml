/**
 * Gets a stat's value
 * @param {String} _stat_key
 * @return {real}
**/
GetStat = function(_stat_key) {
	ScrThrowNotImplemented(object_get_name(object_index), nameof(GetStat));
}

/**
 * BattleStateManager will call this  before proceeding to the Turn state.
 * Returning undefined effectively makes the BattleStateManager wait
 * @param {Struct.TurnContext} _turn_context
 * @return {Struct.TurnAction,undefined} this should denote that an action has been selected
**/
GetAction = function(_turn_context) {
    ScrThrowNotImplemented(object_get_name(object_index), nameof(GetAction));
}

/**
 * If the BattleStateManager determines that the original targets are no longer valid,
 * it will call this to get new targets.
 * @param {Struct.TurnContext} _turn_context
 * @return {Array<Id.Instance>}
**/
UpdateTargets = function(_turn_context) {
    ScrThrowNotImplemented(object_get_name(object_index), nameof(UpdateTargets));
}

/**
 * Returns true if this participant is considered alive.
 * If one side has no alive members, the BattleStateManager will end the battle
 * @return {bool}
**/
IsAlive = function() {
	ScrThrowNotImplemented(object_get_name(object_index), nameof(IsAlive));
}

/**
 * Returns true if this participant is able to act.
 * If it is this participants turn, and it can't act its turn is skipped.
 * @return {bool}
**/
CanAct = function() {
	ScrThrowNotImplemented(object_get_name(object_index), nameof(CanAct));
}

/**
 * BattleStateManager will call this at the end of the current turn for this battle participant
**/
OnPostTurn = function() { }