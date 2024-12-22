function Action() constructor {
	__attackers = [];
	__targets = [];
	__hasEnded = false;
	
	Initialize = function(_attackers, _targets) {
		__attackers = _attackers;
		__targets = _targets;
	}
	
	/**
		@return {Struct.ActionMetadata}
	*/
	static GetMetadata = function() {
		return ScrActionGetMetadataFromInstance(self);
	}
	
	/**
		@return {Struct.TargetStrategy}
	*/
	static CreateTargetStrategy = function() {
		var _action_metadata = ScrActionGetMetadataFromInstance(self);
		//Feather ignore once GM1045
		return new _action_metadata.targetStrategy();
	}
	
	static HasEnded = function() {
		return __hasEnded;
	}
	
	static GetTargets = function() {
		return __targets;
	}
	
	static __GetDamageInternal = function(_attacker, _scalar, _victim, _attack_stat_key, _base_power) {
		var _attack_stat = _attacker.GetStat(_attack_stat_key);
		var _damage = floor(_base_power + _attack_stat * abs(_scalar) * random_range(0.9, 1.1));
		
		return _damage;
	}
	
	static GetDamage = function(_attacker, _scalar, _victim, _attack_stat_key, _defense_stat_key, _base_power = 0) {
		var _defense_stat = _victim.GetStat(_defense_stat_key);
		var _damage = __GetDamageInternal(_attacker, _scalar, _victim, _attack_stat_key, _base_power);
		
		_damage = max(_damage - _defense_stat, 1) * -sign(_scalar);
		
		return _damage;
	}
	
	static GetDamageNoDefense = function(_attacker, _scalar, _victim, _attack_stat_key, _base_power = 0) {
		var _damage = __GetDamageInternal(_attacker, _scalar, _victim, _attack_stat_key, _base_power);
		
		_damage = max(_damage, 1) * -sign(_scalar);
		
		return _damage;
	}
}