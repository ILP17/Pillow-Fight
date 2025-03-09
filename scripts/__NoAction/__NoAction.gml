/**
 * This is used to signify a case where there is no selected action.
**/
function NoAction() : Action() constructor { }

/**
 * Returns true if the supplied action is valid
 * @param {Struct.Action} _action
**/
function ScrActionIsValid(_action) {
    return !is_undefined(_action) && instanceof(_action) != nameof(NoAction);
}