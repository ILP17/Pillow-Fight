var _self = self;
__ = {};
with(__) {
	sprite = SprPlayer;
	spriteDead = SprPlayerDead;
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
	@param {struct.Character} _character_data
*/
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

GetStat = function(_stat_key) {
	var _value = __.characterData.GetStat(_stat_key);
	
	for(var i = 0; i < array_length(__.buffs); i++) {
		_value *= __.buffs[i].stats[$ _stat_key];
	}
	
	return floor(_value);
}

/**
	@param {struct.TurnContext} _turn_context
	@return {struct.TurnActionContext|undefined}
*/
GetAction = function(_turn_context) {
	var _action_instance = __.actionEvaluator.DetermineAction(_turn_context);
	var _targets = __.actionEvaluator.DetermineTargets(_action_instance, _turn_context);
	
	if(is_undefined(_action_instance) || is_undefined(_targets)) {
		return undefined;
	}
	
	if(array_length(_targets) == 0) {
		throw ($"ERROR: Target strategy for {instanceof(_action_instance)} produced no targets!");
	}
	
	_action_instance.Initialize([id], _targets);
	
	return new TurnActionContext(_action_instance, _targets);
}

/**
	@param {struct.Action} _action
	@param {struct.TurnContext} _turn_context
	@return {Array<Id.Instance>}
*/
UpdateTargets = function(_action, _turn_context) {
	return __.actionEvaluator.UpdateTargets(_action, _turn_context);
}

GetHealthRatio = function() {
	return __.health / __.characterData.GetStat(HP_STAT);
}

IsAlive = function() {
	return __.health > 0;
}

IsTargetable = function() {
	return IsAlive();
}

CanAct = function() {
	return IsAlive();
}

/**
	@param {struct.Buff} _buff_constructor
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
	@param {Array<struct.Buff>} _buffs
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
	@param {struct.Buff}
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
	Decays all buffs' turn timers by 1
*/
DecayBuffs = function() {
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