Show = function() {
    layer_set_visible(UI_ACTION, true);
}

Hide = function() {
    layer_set_visible(UI_ACTION, false);
}

IsShowing = function() {
    return layer_get_visible(UI_ACTION);
}

/**
 * @param {Struct.BaseBattleParticipantData} _character_data
**/
SetCharacter = function(_character_data) { 
    //Clean list node
    var _count = flexpanel_node_get_num_children(__.list_node);
    
    repeat (_count) {
    	flexpanel_delete_node(flexpanel_node_get_child(__.list_node, 0));
    }
    
    flexpanel_node_remove_all_children(__.list_node); 
    
    //Populate list node
    var _action_count = _character_data.GetActionCount();
    for(var i = 0; i < _action_count; i++) {
        var _action = _character_data.GetAction(i);
        var _action_metadata = _action.GetMetadata();
        var _node = flexpanel_create_node({
            width: "100%",
            height: 24,
            layerElements: [
                {
                    type: "Instance",
                    instanceObjectIndex: ObjButton,
                    instanceVariables: { text: _action_metadata.name, callback: method({ action: _action, selected: __on_action_selected }, function() { selected(action) }) }, 
                    flexStretchWidth: true,
                    flexStretchHeight: true,
                    instanceColour: -1
                }
            ]
        });
        
        flexpanel_node_insert_child(__.list_node, _node, i);
    }
    
    if(is_instanceof(_character_data, ExamplePlayerCharacter) || is_instanceof(_character_data, ExampleMonsterCharacter)) {
        var _text_id = layer_text_get_id(UI_ACTION, "UIActionTextPrompt");
        layer_text_text(_text_id, string(__.prompt, _character_data.name));
    }
    
    flexpanel_calculate_layout(__.list_node, undefined, undefined, flexpanel_direction.LTR, true);
}

PRIVATE
__.node_root = layer_get_flexpanel_node(UI_ACTION);
__.list_node = flexpanel_node_get_child(__.node_root, "List");
__.selected_index = 0;
__.prompt = "What will {0} do?";

on_action_selected = function(_action) { }

__on_action_selected = function(_action) {
    on_action_selected(_action);
    Hide();
}


