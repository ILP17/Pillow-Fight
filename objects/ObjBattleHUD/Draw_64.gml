for(var i = 0; i < array_length(__.battle_participants); i++) {
    var _battle_participants = __.battle_participants[i];
    DrawBattleParticipantHUD(_battle_participants, _battle_participants.GetStatusManager());
}

if(ObjOptionsProvider.GetOption(OPTION_USE_TEAM_ENERGY, false)) {
    var _gui_height = display_get_gui_height();
    var _energy = ObjTeamEnergyManager.GetEnergy();
    
    draw_sprite_ext(SprEnergy, 0, 48, _gui_height - 64 - 12, 4, 4, 0, c_white, 1);
    
    draw_set_color(_energy > 0 ? c_white : c_red);
    draw_set_font(FonUISmall);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed(48, _gui_height - 56 - 12, _energy, 3, 3, 0);
}

DrawTurnOrder();