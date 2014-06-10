// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require angular
//= require_tree .
$(function () {
    initPage();
    return false;
});
$(window).bind('page:change', function () {
    initPage();
    return false;
});
function initPage() {
    $('.dropdown-toggle').dropdown();
    $(document).tooltip({
        track: true
    });
}

function popupMessage(message, klass) {
    $('#message-modal .modal-body').html(message).addClass(klass);
    $('#message-modal').modal('show');
    $(".modal-backdrop").hide();
    setTimeout(function () {
        $('#message-modal').modal('hide');
    }, 4000);
}

function initProjectList() {
    offset = $(window).height() - $("#project-item-wrapper").height();
    if(offset > 0) {
        $("#project-item-wrapper").css('margin-top', offset/2);
    }
}