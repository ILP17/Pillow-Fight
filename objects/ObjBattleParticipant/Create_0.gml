var _self = self;
__ = {};
with(__) {
	sprite = SprPillowCombatMissing;
	spriteDead = SprPillowCombatMissing;
	healthColor = c_aqua;
	character_data = undefined;
    is_player = false;
	health = 0;
    energy = 0;
	status_manager = new StatusManager();
	actionEvaluator = undefined;
	effects = new InstanceDictionary();
	particles = new InstanceDictionary();
	animations = new AnimationDictionary();
	OnDeath = method(_self, function() {
		__.status_manager.ClearStatus();
		RemoveAll();
		ObjBattleStateController.OnBattleParticipantDeath(id);
		sprite_index = __.spriteDead;
		image_blend = c_gray;
	});
}

/**
 * @param {Struct.BaseBattleParticipantData} _character_data
 * @param {bool} _is_player
**/
Initialize = function(_character_data, _is_player) {
	__.character_data = _character_data;
	__.health = GetStat(HP_STAT);
	__.is_player = _is_player;
	
	var _name = sprite_get_name(__.character_data.sprite);
	__.sprite = __.character_data.sprite;
	__.spriteDead = asset_get_index(_name + "Dead");
	sprite_index = __.sprite;
	
	__.actionEvaluator = _is_player ? new PlayerActionEvaluator(__.character_data) : new CPUActionEvaluator(__.character_data);
    
    Reset();
	
	return id;
}

Reset = function() {
    var _status_count = __.status_manager.GetStatusCount();
	var _extra_energy = 0;
	for(var i = 0; i < _status_count; i++) {
		_extra_energy += __.status_manager.GetStatus(i).energy;
	}
    
    __.max_energy = 3 + _extra_energy;
    __.energy = __.max_energy;
}

AddEnergy = function(_amount) {
    if(ObjOptionsProvider.GetOption(OPTION_USE_TEAM_ENERGY, false)) {
        ObjTeamEnergyManager.AddEnergy(_amount);
        return;
    }
    
    __.energy = clamp(__.energy + _amount, 0, __.max_energy);
}

IsPlayer = function() { return __.is_player; }

GetName = function() { return __.character_data.name; }

GetHealth = function() { return __.health; }

GetStatusManager = function() { return __.status_manager; }

GetEnergy = function(_amount) { return __.energy; }

GetCharacterData = function() { return __.character_data; }

GetEffects = function() { return __.effects; }

GetParticles = function() { return __.particles; }

GetAnimations = function() { return __.animations; }

/**
 * Gets a stat's value
 * @param {String} _stat_key
 * @return {real}
**/
GetStat = function(_stat_key) {
	var _value = __.character_data.GetStat(_stat_key);
    var _status_count = __.status_manager.GetStatusCount();
	
	for(var i = 0; i < _status_count; i++) {
		_value *= __.status_manager.GetStatus(i).stats[$ _stat_key];
	}
	
	return floor(_value);
}

/**
 * BattleStateManager will call this before proceeding to the Turn state.
 * Returning undefined effectively makes the BattleStateManager wait
 * @param {Struct.TurnContext} _turn_context
 * @return {Struct.TurnAction} this should denote that an action has been selected
**/
GetAction = function(_turn_context) {
    var _action = __.actionEvaluator.TryDetermineAction(_turn_context); 
    var _targets = __.actionEvaluator.TrySelectTargets(_turn_context, _action);
    //show_debug_message($"action={instanceof(_action)}, _targets={_targets}");
    var _turn_action = new TurnAction(_action, [id], _targets);
    
    if(_turn_action.IsValid()) {
        __.actionEvaluator.Reset();
    }
    
    return _turn_action;
}

/**
 * @param {Struct.TurnContext} _turn_context
 * @param {Struct.Action} _action
**/
InitializeAction = function(_turn_context, _action) {
    _action.Initialize(_turn_context);
    
    if(IsPlayer()) {
        AddEnergy(-_action.GetMetadata().GetData("cost", 0));
    }
}

/**
 * If the BattleStateManager determines that the original targets are no longer valid,
 * it will call this to get new targets.
 * @param {Struct.TurnContext} _turn_context
 * @return {Array<Id.Instance>}
**/
UpdateTargets = function(_turn_context) {
	return __.actionEvaluator.UpdateTargets(_turn_context);
}

GetHealthRatio = function() {
	return __.health / GetStat(HP_STAT);
}

/**
 * Returns true if this participant is considered alive.
 * If one side has no alive members, the BattleStateManager will end the battle
 * @return {bool}
**/
IsAlive = function() {
	return __.health > 0;
}

IsTargetable = function() {
	return IsAlive();
}

/**
 * Returns true if this participant is able to act.
 * If it is this participants turn, and it can't act its turn is skipped.
 * @return {bool}
**/
CanAct = function() {
	return IsAlive();
}

/**
 * BattleStateManager will call this at the end of the current turn for this battle participant
**/
OnPostTurn = function() {
    var _hp_ratio = GetHealthRatio();
    var _prev_hp = GetStat(HP_STAT);
    
    __.status_manager.DecayStatuses();
    
    var _current_hp = GetStat(HP_STAT);
    
    if(_prev_hp != _current_hp) {
        __.health = floor(_current_hp * _hp_ratio);
        ObjBattleHUD.SetHealthDisplay(id);
    }
}

/**
 * @param {Struct.Status} _status
**/
ApplyStatus = function(_status) {
    var _hp_ratio = GetHealthRatio();
    var _prev_hp = GetStat(HP_STAT);
    
    __.status_manager.AddStatus(_status);
    
    var _current_hp = GetStat(HP_STAT);
    
    if(_prev_hp != _current_hp) {
        Damage(floor(_current_hp * _hp_ratio) - __.health, false);
        ObjBattleHUD.SetHealthDisplay(id);
    }
}

Damage = function(_damage, _allow_crit = true) {
	var _is_crit = irandom(99) + 1 <= 25,
		_style = 1;
	
	if(_allow_crit && _is_crit) {
		_damage = floor(_damage * 1.5);
		_style = 2;
	}
	
	if(_damage > 0) {
		_style = 3;
	}
	
	__.health = clamp(__.health + _damage, 0, GetStat(HP_STAT));
	
	instance_create_depth(
		x + irandom_range(-12, 12),
		y + irandom_range(-34, -8),
		depth,
		ObjDamage).Initialize(abs(_damage), _style);
	
	if(!IsAlive()) {
		__.OnDeath();
	} else {
		sprite_index = __.sprite;
		image_blend = c_white;
	}
}

RemoveAll = function() {
	__.effects.Clear();
	__.animations.Clear();
	__.particles.Clear();
}