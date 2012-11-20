// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.

//= require jquery_ujs
//= require_tree ./vendor
//= require document_viewer/dv
//= require_tree ./public

function highlightComment() {
    $('.comment-top.highlight').removeClass('highlight');
    $(location.hash).children('.comment-top:first').addClass('highlight');
}


$().ready(function() {
    $("*[data-autocomplete-path]").each(function() {
        var path = $(this).data("autocomplete-path");
        $(this).autocomplete({
            minLength: 0,
            source: function(request, response) {
                $.ajax(path, {
                    type: "POST",
                    cache: false,
                    dataType: "script",
                    data: { 'term': request.term }
                });
            }});
    });

    highlightComment();
    $(window).bind('hashchange', highlightComment);

    $('.jqtransform').jqTransform();
});
