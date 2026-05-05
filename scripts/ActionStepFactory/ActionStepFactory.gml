/**
 * @param {Struct} _config
 * @return {Struct.ActionStep}
**/
function ActionStepFactory(_config) {
    switch(_config[$ "type"]) {
        case "move": return new ActionStepMove(_config); break;
        case "timer": return new ActionStepTimer(_config); break;
        case "foreach": return new ActionStepForeach(_config); break;
        case "effect": return new ActionStepEffect(_config); break;
        case "effect_update": return new ActionStepEffectUpdate(_config); break;
        case "effect_remove": return new ActionStepEffectRemove(_config); break;
        case "effect_animation_wait": return new ActionStepEffectAnimationWait(_config); break;
        case "damage": return new ActionStepDamage(_config); break;
        case "animation": return new ActionStepAnimation(_config); break;
        case "animation_stop": return new ActionStepAnimationStop(_config); break;
        case "particle": return new ActionStepParticle(_config); break;
        case "particle_clear": return new ActionStepParticleClear(_config); break;
        case "status": return new ActionStepStatus(_config); break;
        case "prepare": return new ActionStepPrepare(_config); break;
        case "if": return new ActionStepIf(_config); break;
    }
    
    show_message($"[ActionStepFactory] unknown action step: {_config}");
    game_end();
}