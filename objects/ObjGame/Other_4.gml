if(room == RmStart) {
	room_goto(RmTest);
}
if(room == RmTest && auto_run) {
	StartBattle();
}