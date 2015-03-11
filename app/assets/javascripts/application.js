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
//= require_tree .
//= require turbolinks
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

    $(document).ajaxStart(function() {
        loader('show');
    });

    $(document).ajaxComplete(function() {
        loader('hide');
    });

    $(document).ajaxError(function() {
        loader('hide');
    });

    $("body").click(function(e) {
        if(e.target.className !== "notification-menu") {
            $(".notification-list").hide();
        }
    });
}

var category = {
      '1' : '.backlog .task-content'
    , '2' : '.project-sprint .task-content'
    , '3' : '.project-doing .task-content'
    , '4' : '.project-finish .task-content'
    , '5' : '.project-done .task-content'
};

var new_notification_count = 0;

function update_task(response) {
    element = $('.task-details-'+response.task_id);
    task = $('#task-'+response.task_id);
    switch(response.field) {
        case 'priority':
            task.find('.task-priority-icon').attr('src', "/assets/task_"+response.value.toLowerCase()+".png");
            element.find('.task-priority img').attr('src', "/assets/task_"+response.value.toLowerCase()+".png");
            break;
        case 'end_date':
            element.find('.edit-end-date').val(response.value);
            task.find('.task-end-date').html(formatted_date(response.value));
            task.removeClass('finish_today finish_tomorrow time_past upcoming').addClass(response.remaining_status);
            break;
        case 'effort':
            element.find('.progress-effort').text(response.value);
            task.find('.total-effort').html(response.value);
            break;
        case 'spend':
            element.find('.progress-spend').text(response.value);
            break;
        case 'task_type':
            task.removeClass('bug').removeClass('feature').addClass(response.value);
            break;
        case 'title':
            task.find('.task-name').text(response.value);
            break;
        case 'status_id':
            container = $(''+category[response.value]);
            copy_task_item = task.clone();
            task.remove();
            container.append(copy_task_item);
            break;
    }
    add_notification(response);
}

function remove_task(response) {
    task_id = response.task_id;
    $('#x-large-modal').modal('hide');
    $('#task-'+task_id).remove();
    add_notification(response);
}

function formatted_date(date) {
    d = new Date(date);
    var dd = d.getDate() + 1;
    var mm = d.getMonth()+1; //January is 0!
    var yyyy = d.getFullYear();
    return dd + "/" + mm + "/" + yyyy;
}

function add_notification(response) {
    new_notification_count += 1;
    template = $('#notification-item-template').html();
    var rendered = Mustache.render(template, response);
    if($('ul.notification li').length > 0) {
        $('ul.notification li').first().before(rendered);
    }
    else {
        $('ul.notification').append(rendered)
    }
    $('a.notification-menu').html("<span class='new-notification-count'>"+new_notification_count+"</span>");
}

function new_task(response) {
    template = $('#new-task-item').html();
    if(!response.assign_member) {
        response.assign_member = "Unassign";
    }
    var rendered = Mustache.render(template, response);
    $('.task-category.backlog .task-content').append(rendered);
}

function chk_create(response)  {
    template = $('#tmp_new_checklist_item').html();
    var rendered = Mustache.render(template, response);
    console.log(rendered);
    $('.checklist-' + response.checklist_id).find('li').last().before(rendered);
}

function popupMessage(message, klass) {
    $('#message-modal .modal-body').html(message).addClass(klass);
    $('#message-modal').modal('show');
    setTimeout(function () {
        $('#message-modal').modal('hide');
    }, 4000);
}

function show_attachment(image_file) {
    var style = "";
    var filename = "";
    if(image_file != '') {
        filename = image_file.substring(image_file.lastIndexOf('/')+1);
    }
    $(".attachment-details-wrap").remove();
    $('body').append("<div class='attachment-overlay'> </div>" +
        "<div class='attachment-details-wrap'>" +
        "<div class='attachment-title'> Title: "+filename+"</div>" +
        "<span class='close-attachment'> X Close </span>"+
        "<img class='attachment-details' src='"+image_file+"'/>" +
        "</div>");
    windowsize = {width: $(window).width(), height: $(window).height()};
    image = $(".attachment-details");
    if(image.width() > windowsize.width || image.width() > windowsize.width) {
        style += "width:"+ (windowsize.width - 100) +"px;height"+(windowsize.height - 100)+"top:25px;left:25px;";
    }
    else {
        style += "top:"+ (windowsize.height - image.height() - 10) / 2 +"px;left:"+(windowsize.width - image.width() - 10) / 2+"px;";
    }
    $(".attachment-details-wrap").attr('style', style);
}

function loader(type) {
    if(type == 'show') {
        $('body').append("<div class='ajax-loader'> <img src='/assets/ajax-loader.GIF'> </div>");
    }
    else {
       $('.ajax-loader').remove();
    }
}

function initProjectList() {
//    offset = $(window).height() - $('#project-item-wrapper').height();
//    if (offset > 0) {
//        $('#project-item-wrapper').css('margin-top', offset / 2);
//    }
}