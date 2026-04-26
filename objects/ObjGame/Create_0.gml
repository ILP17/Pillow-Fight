auto_run = true;

randomize();
show_debug_message($"START seed={random_get_seed()}");

StartBattle = function() {
    var _character_data,
        _battle_participant = noone,
        _base_y = room_height / 2,
        _player_x = room_width / 3,
        _monster_x = room_width * (2 / 3),
        _y = _base_y - array_length(global.playerParty) * 34 / 2,
        _alphaTeam = [],
        _betaTeam = [];
   
    for(var i = 0; i < array_length(global.playerParty); i++) {
        _character_data = global.playerParty[i];
        _battle_participant = instance_create_layer(
            _player_x + irandom_range(-18, 18),
            _y + i * 34,
            layer,
            ObjBattleParticipant).Initialize(_character_data, true);
        array_push(_alphaTeam, _battle_participant);
    }
    
    _y = _base_y - array_length(global.enemyParty) * 34 / 2;
    for(var i = 0; i < array_length(global.enemyParty); i++) {
        _character_data = global.enemyParty[i];
        
        var _real_monster_x = _monster_x + irandom_range(-18, 18);
        
        if(_character_data.isBoss) {
            _real_monster_x += 80;
        }
        
        _battle_participant = instance_create_layer(
            _real_monster_x,
            _y + i * 34,
            layer,
            ObjBattleParticipant).Initialize(_character_data, false);
        _battle_participant.image_xscale = -1;
        array_push(_betaTeam, _battle_participant);
    }
    
    ObjBattleStateController.Initialize(_alphaTeam, _betaTeam);
    ObjBattleStateController.TryBeginBattle();
}
