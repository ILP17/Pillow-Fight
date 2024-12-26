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
        action = undefined;
    }
    
    /**
     * @return {Struct.Action,undefined}
    **/
    static GetAction = function() {
        return __.action;
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
     * @param {Struct.Action}
    **/
    static SetAction = function(_action) {
        __.action = _action;
    }
	
	/**
     * Returns the team targeted by the action
     * Throw is there is no action (action is undefined)
     * @return {Array<Id.Instance>}
	**/
	static ResolveTargets = function() {
        var _action = GetAction();
        
        if(is_undefined(_action)) {
            throw($"Action is undefined while trying to resolve target team");
        }
		
		return ScrGetTargetTeamBaseOnAction(_action, __.turnInstance, __.allyTeam, __.enemyTeam);
	}
}