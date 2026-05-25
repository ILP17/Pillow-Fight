GetHealthColor = function(_ratio) {
    var _health_color = c_aqua;
    
    if(_ratio < 0.5) { _health_color = c_yellow; }
    
    if(_ratio < 0.25) { _health_color = c_red; }
    
    return _health_color;
}

/**
 * @param {Id.Instance} _battle_participant
 * @param {Struct.StatusManager} _status_manager
**/
DrawBattleParticipantHUD = function(_battle_participant, _status_manager) {
    var _view_ratio = display_get_gui_width() / camera_get_view_width(view_camera[0]);
    var _display_health = __.health_display[$ $"{_battle_participant}"];
    var _display_health_ratio = _display_health / _battle_participant.GetStat(STAT_HP);
    var _is_player = _battle_participant.IsPlayer();
    var _ox = _battle_participant.xstart;
    var _oy = _battle_participant.ystart;
    var _width = _battle_participant.sprite_width;
    var _height = _battle_participant.sprite_height;
    var _x_scale = _battle_participant.image_xscale;
    var _energy = _battle_participant.GetEnergy();
    
    draw_set_halign(_is_player ? fa_right : fa_left);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_font(FonUISmall);
    draw_text(
    	(_ox + (abs(_width) - 2) * -_x_scale) * _view_ratio,
    	(_oy - _height * 0.75) * _view_ratio,
    	_battle_participant.GetName()
    );
    
    var _middle_x = (_ox - (abs(_width) + 12) * _x_scale);
    var _x1 = (_middle_x - 14) * _view_ratio;
    var _x2 = (_middle_x + 14) * _view_ratio;
    var _y1 = (_oy - _height * 0.75 + 2) * _view_ratio;
    var _y2 = _y1 + 8 * _view_ratio;
    
    draw_sprite_ext(SprPixel, 0, _x1, _y1, _x2 - _x1, _y2 - _y1, 0, c_black, 1);
    
    _x1 += 2 * _view_ratio;
    _x2 -= 2 * _view_ratio;
    
    if(_display_health > 0) {
    	var _health_color = GetHealthColor(_battle_participant.GetHealthRatio());
        draw_sprite_ext(
            SprPixel, 0, _x1, _y1 + 2 * _view_ratio, 
            floor(abs(_x2 - _x1) * _display_health_ratio), 
            _y2 - _y1 - 4 * _view_ratio, 0, _health_color, 1);
    }
    
    if(ObjOptionsProvider.GetOption(OPTION_USE_TEAM_ENERGY, false)) {
        var _buff_count = _status_manager.GetStatusCount();
        
        for(var i = 0; i < _buff_count; i++) {
        	draw_sprite(
        		SprBuffIcons,
        		_status_manager.GetStatus(i).icon_index,
        		(_is_player ? _x1 : _x2) + (-18 * (i + 1)) * _x_scale,
        		_y1);
        }
        return;
    }
    
    if(_battle_participant.IsPlayer()) {
        draw_sprite(
        	SprEnergy,0,
        	(_is_player ? _x1 : _x2) + -18 * _x_scale,
        	_y1);
        
        draw_set_color(_energy > 0 ? c_white : c_red);
        draw_set_font(FonUISmall);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text((_is_player ? _x1 : _x2) + -12 * _x_scale, _y1 + 8, _energy);
    }
    
    var _buff_count = _status_manager.GetStatusCount();
    
    for(var i = 0; i < _buff_count; i++) {
    	draw_sprite(
    		SprBuffIcons,
    		_status_manager.GetStatus(i).icon_index,
    		(_is_player ? _x1 : _x2) + (-18 - 18 * (i + 1)) * _x_scale,
    		_y1);
    }
}

DrawTurnOrder = function() {
    var _turn_order = ObjBattleStateController.GetTurnOrder();
    var _view_ratio = display_get_gui_width() / camera_get_view_width(view_camera[0]);
    
    for(var i = 0, n = array_length(_turn_order); i < n; i++) {
        var _battle_participant = _turn_order[i];
        var _is_player = _battle_participant.IsPlayer();
        var _sprite = _battle_participant.__.sprite;
        var _width = sprite_get_width(_sprite);
        var _alpha = 0.65;
        
        if(ObjBattleStateController.GetCurrentTurnInstance() == _battle_participant) {
            _alpha = 1;
        }
        var _x = 244 + 62 * i;
        var _y = 8;
        
        draw_sprite_ext(SprPanel, 0, _x, _y, 52/16, 52/16, 0, -1, 1);
        draw_sprite_part_ext(_sprite, 0, _width - 18, 0, 20, 20, _x + 40 + 4, _y + 5, -2, 2, -1, _alpha);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_set_font(FonUISmall);
        draw_text(_x + 26, 64 + ((i%2) == 1 ? -2 : 12), _battle_participant.GetName() );
    }
}

PRIVATE

__.health_display = {};
__.battle_participants = [];

SetUp = function(_battle_participants) {
    __.battle_participants = _battle_participants;
    
    for(var i = 0; i < array_length(_battle_participants); i++) {
        __.health_display[$ $"{_battle_participants[i]}"] = _battle_participants[i].GetHealth();
    }
}

SetHealthDisplay = function(_battle_participant) {
    __.health_display[$ $"{_battle_participant}"] = _battle_participant.GetHealth();
}