/**
	This is the context of the current turn where ally and enemy teams are distinguished
	@param {Id.Instance} _turn_instance
	@param {Array<Id.Instance>} _alpha_team
	@param {Array<Id.Instance>} _beta_team
*/
function TurnContext(_turn_instance, _alpha_team, _beta_team) constructor {
	turnInstance = _turn_instance;
	myTeam = [];
	enemyTeam = [];
	
	if(array_contains(_alpha_team, turnInstance)) {
		myTeam = _alpha_team;
		enemyTeam = _beta_team;
	} else if(array_contains(_beta_team, turnInstance)) {
		myTeam = _beta_team;
		enemyTeam = _alpha_team;
	}
	
	/**
     * Returns the team targeted by the action
     * @param {Struct.ActionMetadata} _action_metadata
	*/
	static ResolveTargets = function(_action_metadata) {
		var _targets = [];
		
		switch(_action_metadata.targetType) {
			case TargetType.Enemy:
				_targets = enemyTeam;
				break;
			case TargetType.Team:
				_targets = myTeam;
				break;
			case TargetType.Self:
				_targets = [turnInstance];
				break;
		}
		
		return _targets;
	}
}