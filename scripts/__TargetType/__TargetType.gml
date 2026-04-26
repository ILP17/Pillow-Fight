enum TargetType {
	Enemy,
	Team,
	Self
}

function TargetTypeFromString(_enum) {
    _enum = string_lower(_enum);
    _enum = string_replace(_enum, "targettype.", "");
    
    switch(_enum) {
        case "enemy": return TargetType.Enemy;
        case "team": return TargetType.Team;
        case "self": return TargetType.Self;
    }
}