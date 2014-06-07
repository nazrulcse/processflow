$(document).ready(function() {

    $( "#dashboard .task-item" ).draggable({
        connectToSortable: ".task-content",
        refreshPositions: true,
        revert: true,
        greedy: true
    });

    $( "#dashboard .task-content" ).droppable({
        accept: ".task-item",
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

    $( "#dashboard .task-item").sortable({
        axis: "y",
        connectWith: "#dashboard .task-content"
    });

});