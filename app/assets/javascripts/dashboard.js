$(document).ready(function() {

    $( "#dashboard .tasks-item" ).draggable({
        connectToSortable: ".tasks-content",
        refreshPositions: true,
        revert: true,
        greedy: true
    });

    $( "#dashboard .tasks-content" ).droppable({
        accept: ".tasks-item",
        activeClass: "ui-state-hover",
        hoverClass: "ui-state-active",
        tolerance: "intersect",
        greedy: true,
        drop: function(event, ui) {
            $(this).append(ui.helper);
        },
        accept: function (elem) {
            return !$(this).has(elem).length;
        }
    });

    $( "#dashboard .tasks-item").sortable({
        axis: "y",
        connectWith: "#dashboard .tasks-content"
    });

});