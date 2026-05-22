#macro PRIVATE __=self[$"__"]??{}
#macro MAX_LEVEL 50
#macro HP_STAT "hp"
#macro AT_STAT "at"
#macro DF_STAT "df"
#macro MAG_STAT "mag"
#macro SP_STAT "sp"
#macro UI_ACTION "UIActionList"
#macro OPTION_USE_TEAM_ENERGY "use_team_energy"

function ShowMessageAndEnd(_object_and_method, _message) {
    show_message($"[{_object_and_method}] {_message}");
    game_end();
}