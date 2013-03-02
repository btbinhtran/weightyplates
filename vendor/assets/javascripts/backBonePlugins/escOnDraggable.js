/*
$( window ).keypress( function( e ){
    if( e.keyCode == 27 ) {
        var mouseMoveEvent = document.createEvent("MouseEvents");
        var offScreen = -50000;

        mouseMoveEvent.initMouseEvent(
            "mousemove", //event type : click, mousedown, mouseup, mouseover, etc.
            true, //canBubble
            false, //cancelable
            window, //event's AbstractView : should be window
            1, // detail : Event's mouse click count
            offScreen, // screenX
            offScreen, // screenY
            offScreen, // clientX
            offScreen, // clientY
            false, // ctrlKey
            false, // altKey
            false, // shiftKey
            false, // metaKey
            0, // button : 0 = click, 1 = middle button, 2 = right button
            null // relatedTarget : Only used with some event types (e.g. mouseover and mouseout).
            // In other cases, pass null.
        );

        // Move the mouse pointer off screen so it won't be hovering a droppable
        document.dispatchEvent(mouseMoveEvent);

        // This is jQuery speak for:
        // for all ui-draggable elements who have an active draggable plugin, that
        var dragged = $('.ui-draggable:data(draggable)')
            // either are ui-draggable-dragging, or, that have a helper that is ui-draggable-dragging
            .filter(function(){return $('.ui-draggable-dragging').is($(this).add(($(this).data('draggable') || {}).helper))});

        // We need to restore this later
        var origRevertDuration = dragged.draggable('option', 'revertDuration');
        var origRevertValue = dragged.draggable('option', 'revert');

        console.log("dragged info")
        console.log(dragged)

        dragged
            // their drag is being reverted
            .draggable('option', 'revert', true)
            // no revert animation
            .draggable('option', 'revertDuration', 0)
            // and the drag is forcefully ended
            .trigger('mouseup')
            // restore revert animation settings
            .draggable('option', 'revertDuration', origRevertDuration)
            // restore revert value
            .draggable('option', 'revert', origRevertValue);
    }
})
*/