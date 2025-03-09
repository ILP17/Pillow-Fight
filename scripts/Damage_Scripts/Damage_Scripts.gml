function ScrGetRawDamage(_attacker, _scalar, _victim, _attack_stat_key, _base_power) {
	var _attack_stat = _attacker.GetStat(_attack_stat_key);
	var _damage = floor(_base_power + _attack_stat * abs(_scalar) * random_range(0.9, 1.1));
	
	return _damage;
}

function ScrGetDamage(_attacker, _scalar, _victim, _attack_stat_key, _defense_stat_key, _base_power = 0) {
	var _defense_stat = _victim.GetStat(_defense_stat_key);
	var _damage = ScrGetRawDamage(_attacker, _scalar, _victim, _attack_stat_key, _base_power);
	
	_damage = max(_damage - _defense_stat, 1) * -sign(_scalar);
	
	return _damage;
}

function ScrGetDamageNoDefense(_attacker, _scalar, _victim, _attack_stat_key, _base_power = 0) {
	var _damage = ScrGetRawDamage(_attacker, _scalar, _victim, _attack_stat_key, _base_power);
	
	_damage = max(_damage, 1) * -sign(_scalar);
	
	return _damage;
}