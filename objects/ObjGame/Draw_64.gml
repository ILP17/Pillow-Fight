draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(FonUI);

var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();
var _battle_state = ObjBattleStateController.GetBattleState();
var _margin_x = 8;
var _margin_y = 8;

var _debug_text = $"Battle State: {BattleStatesToString(_battle_state)}";
_debug_text += $"\nCuurent Turn: {ObjBattleStateController.GetCurrentTurnInstance().GetCharacterData().name}";

draw_text(_margin_x, _margin_y, _debug_text);

draw_set_halign(fa_center);

if(_battle_state == BattleStates.NA) {
	draw_set_color(c_yellow);
	draw_text_transformed(_gui_width/2, _gui_height*0.8, "Press Space to begin!", 4, 4, 0);
}

if(_battle_state == BattleStates.PostBattle) {
    draw_set_color(c_orange);
    draw_text_transformed(_gui_width/2, _gui_height*0.9, "Press R to restart.", 2, 2, 0);
}