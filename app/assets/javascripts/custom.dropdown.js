$.fn.customDropDown = function() {
    return this.each(function() {
        if($(this).find('option:selected')) {
            var first_option = $(this).find('option:selected').text();
        }
        else {
            first_option = $(this).find('option:first-child').text();
        }
        var existing_design = $(this).parents('.custom-select-wrap');
        if(existing_design.length <= 0) {
            $(this).wrap("<div class='custom-select-wrap'> </div>");
            $(this).after("<span class='selectInner'>" + first_option + "</span>");
        }
        $(this).change(function() {
            var i = $(this).index('select');
            var sel = $('select:eq(' + i + ') option:selected').text();
            $('.selectInner:eq(' + i + ')').text(sel);
        });
    });
};
$(function() {
    $('select').customDropDown();
});