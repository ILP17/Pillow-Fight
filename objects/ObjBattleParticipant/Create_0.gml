var _self = self;
__ = {};
with(__) {
	sprite = SprPillowCombatMissing;
	spriteDead = SprPillowCombatMissing;
	healthColor = c_aqua;
	characterData = undefined;
	health = 0;
	healthDisplay = 0;
	buffs = [];
	actionEvaluator = undefined;
	effects = {};
	OnDeath = method(_self, function() {
		ClearBuffs();
		RemoveAllEffects();
		ObjBattleStateController.OnBattleParticipantDeath(id);
		sprite_index = __.spriteDead;
		image_blend = c_gray;
	});
}

/**
 * @param {Struct.BaseBattleParticipantData} _character_data
**/
Initialize = function(_character_data) {
	__.characterData = _character_data;
	
	__.health = __.characterData.GetStat(HP_STAT);
	__.healthDisplay = __.health;
	
	var _name = sprite_get_name(__.characterData.sprite);
	__.sprite = __.characterData.sprite;
	__.spriteDead = asset_get_index(_name + "Dead");
	sprite_index = __.sprite;
	
	__.actionEvaluator = new CPUActionEvaluator(__.characterData);
	
	return id;
}

/**
 * Gets a stat's value
 * @param {String} _stat_key
 * @return {real}
**/
GetStat = function(_stat_key) {
	var _value = __.characterData.GetStat(_stat_key);
	
	for(var i = 0; i < array_length(__.buffs); i++) {
		_value *= __.buffs[i].stats[$ _stat_key];
	}
	
	return floor(_value);
}

/**
 * BattleStateManager will call this  before proceeding to the Turn state.
 * Returning undefined effectively makes the BattleStateManager wait
 * @param {Struct.TurnContext} _turn_context
 * @return {Struct.TurnAction} this should denote that an action has been selected
**/
GetAction = function(_turn_context) {
    var _action = __.actionEvaluator.TryDetermineAction(_turn_context); 
    var _targets = __.actionEvaluator.TrySelectTargets(_turn_context, _action);
    show_debug_message($"action={instanceof(_action)}, _targets={_targets}");
    return new TurnAction(_action, [id], _targets);
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
	return __.health / __.characterData.GetStat(HP_STAT);
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
	@param {Struct.Buff} _buff_constructor
	@return {bool}
*/
HasBuff = function(_buff_constructor) {
	var _method = method({_buff_constructor}, function(_buff, _index) {
		return instanceof(_buff) == script_get_name(_buff_constructor);
	});
	
	return array_any(__.buffs, _method);
}

/**
	Returns true if battle participant has any of the provided buffs
	@param {Array<Struct.Buff>} _buffs
	@return {bool}
*/
HasAnyBuff = function(_buffs) {
	for(var i = 0; i < array_length(_buffs); i++) {
		if(HasBuff(_buffs[i])) {
			return true;
		}
	}
	
	return false;
}

/**
	@param {Struct.Buff}
*/
ApplyBuff = function(_buff) {
	array_push(__.buffs, _buff);
}

/**
	Clears buffs
*/
ClearBuffs = function() {
	__.buffs = [];
}

/**
 * BattleStateManager will call this at the end of the current turn for this battle participant
**/
OnPostTurn = function() {
    //Decays all buffs' turn timers by 1
	static Filter = function(_buff, _index) {
		return _buff.turnCount > 0;
	}
	
	__.buffs = array_filter(__.buffs, Filter);
	
	for(var i = 0; i < array_length(__.buffs); i++) {
		__.buffs[i].DecrementTurnCount();
	}
}

Damage = function(_damage) {
	var _is_crit = irandom(99) + 1 <= 25,
		_style = 1;
	
	if(_is_crit) {
		_damage = floor(_damage * 1.5);
		_style = 2;
	}
	
	if(_damage > 0) {
		_style = 3;
	}
	
	__.health = clamp(__.health + _damage, 0, __.characterData.GetStat(HP_STAT));
	
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

/**
	@param {Id.Instance} _effect_object
*/
AddEffect = function(_effect_object) {
	__.effects[$ $"{_effect_object.object_index}"] = _effect_object;
}

/**
	@param {Asset.GMObject} _effect_object
*/
RemoveEffect = function(_effect_object) {
	instance_destroy(__.effects[$ $"{_effect_object}"]);
	variable_struct_remove(__.effects, $"{_effect_object}");
}

RemoveAllEffects = function() {
	static RemoveEffect = function(_name, _effect) {
		instance_destroy(_effect);
	}
	
	struct_foreach(__.effects, RemoveEffect)
	__.effects = {};
}