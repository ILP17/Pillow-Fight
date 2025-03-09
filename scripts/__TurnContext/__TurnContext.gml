/**
 * This is the context of the current turn where ally and enemy teams are distinguished
 * @param {Id.Instance} _turn_instance
 * @param {Array<Id.Instance>} _ally_team
 * @param {Array<Id.Instance>} _enemy_team
**/
function TurnContext(_turn_instance, _ally_team, _enemy_team) constructor {
	__ = { };
    
    with(__) {
        turnInstance = _turn_instance ?? ScrThrowArgumentUndefined(nameof(_turn_instance));
        allyTeam = _ally_team ?? ScrThrowArgumentUndefined(nameof(_ally_team));
        enemyTeam = _enemy_team ?? ScrThrowArgumentUndefined(nameof(_enemy_team));
        turnAction = new TurnAction();
    }
    
    /**
     * @return {Struct.TurnAction}
    **/
    static GetTurnAction = function() {
        return __.turnAction;
    }
    
    /**
     * @return {Id.Instance}
    **/
    static GetTurnInstance = function() {
           return __.turnInstance;
    }
    
    /**
     * @return {Array<Id.Instance>}
    **/
    static GetAllyTeam = function() {
        return __.allyTeam;
    }
    
    /**
     * @return {Array<Id.Instance>}
    **/
    static GetEnemyTeam = function() {
        return __.enemyTeam;
    }
    
    /**
     * @param {Struct.TurnAction}
    **/
    static SetTurnAction = function(_action) {
        __.turnAction = _action;
    }
	
	/**
     * Returns the team targeted by the action
     * Throw is there is no selected action (action is undefined)
     * @return {Array<Id.Instance>}
	**/
	static ResolveTargets = function() {
        if(!__.turnAction.IsValid()) {
            throw($"Could not resolve potential targets since there is no selected action.");
        }
		
		return ScrGetTargetTeamBasedOnAction(__.turnAction.action, self);
	}
}