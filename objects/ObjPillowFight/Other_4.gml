if(room == RmStart) {
	room_goto(RmTest);
    layer_set_visible(UI_ACTION, false);
}
if(room == RmTest && auto_run) {
	StartBattle();
}