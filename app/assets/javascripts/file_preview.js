function create_preview(path, type, content) {
    $("div#file-preview").remove();
    window_width = $(window).width();
    window_height = $(window).height();
    new_width = window_width - 100;
    new_height = window_height - 50;
    host_url = window.location.host
    iframe = "<iframe src='http://docs.google.com/gview?url=" + host_url + path + "&embedded=true' width='"+new_width+"' height='"+new_height+"'> </iframe>";
    preview = "<div id='file-preview'>" + iframe + "</div>";
    $('html').append(preview);
    $("body").addClass("modal-open");
}

$(document).on('click', '#file-preview', function() {
    $(this).remove();
    $("body").removeClass("modal-open");
});