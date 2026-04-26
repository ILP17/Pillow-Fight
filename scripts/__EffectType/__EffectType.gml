enum EffectType {
	Damage,
	Heal,
	Revive,
	Buff
}

function EffectTypeFromString(_enum) {
    _enum = string_lower(_enum);
    _enum = string_replace(_enum, "effecttype.", "");
    
    switch(_enum) {
        case "damage": return EffectType.Damage;
        case "heal": return EffectType.Heal;
        case "revive": return EffectType.Revive;
        case "buff": return EffectType.Buff;
    }
}