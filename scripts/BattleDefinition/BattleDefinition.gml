#macro STAT_HP "hp"
#macro STAT_AT "at"
#macro STAT_DF "df"
#macro STAT_MAG "mag"
#macro STAT_SP "sp"
#macro UI_ACTION "UIActionList"
#macro OPTION_USE_TEAM_ENERGY "use_team_energy"

function ShowMessageAndEnd(_object_and_method, _message) {
    show_message($"[{_object_and_method}] {_message}");
    game_end();
}