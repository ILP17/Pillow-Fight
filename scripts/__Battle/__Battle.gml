function Battle() constructor {
    participants = [];
    turn_order = [];
    turn_index = 0;
    
    static GetCurrentTurnInstance = function() {
        return turn_order[turn_index];
    }
    
    static NextTurn = function() {
        turn_index = (turn_index + 1) % array_length(turn_order);
    }
}