for(var i = 0; i < array_length(__.battle_participants); i++) {
    var _battle_participant = __.battle_participants[i];
    var _difference = (_battle_participant.GetHealth() - __.health_display[$ $"{_battle_participant}"]);
    var _sign_difference = sign(_difference);
	var _abs_difference = abs(_difference);

    __.health_display[$ $"{_battle_participant}"] += max(_abs_difference div 5, 1) * _sign_difference;
}