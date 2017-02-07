$(function() {
    if ($('.movie-list li').length > 1) {
        $('.movie-list').dataFilter({
        'showSearch': true,
            'startsWith': 'all',
            'showNumbers': true,
            'formClass': 'span12',
            'searchPlaceholder': 'Search for a movie by title'
        });
    }
    if ($('.ebook-list li').length > 1) {
        $('.ebook-list').dataFilter({
        'showSearch': true,
            'startsWith': 'all',
            'showNumbers': true,
            'formClass': 'span12',
            'searchPlaceholder': 'Search for an e-book by title'
        });
    }
    if ($('.az-list li').length > 1) {
        $('.az-list').dataFilter({
            'formClass': 'span12'
        });
    }
    if ($('form#database-filter').length > 0) {
        $('form#database-filter .accordion-heading > a').after('<span class="fa fa-angle-right"></span>');
        $('.collapse').on('show', function(){
            $(this).parent().find('.fa-angle-right').addClass('fa-rotate-90');
        }).on('hide', function(){
            $(this).parent().find('.fa-angle-right').removeClass('fa-rotate-90');
        });
    }
});

/* video gallery
___________________*/
$(document).ready(function($) {
    $('.main-video').fitVids();
    $('.video-playlist').css('height', $('.main-video').css('height'));
    //thumbnails
    $('.video-playlist li a').each(function() {
        //var youtubeid = $(this).attr('data-video-id');
        var url = $(this).attr('href');
        var title = $(this).children('h3').text();
        if (url.match('http://(www.)?youtube|youtu\.be')) {
        youtubeid = url.split(/v\/|v=|youtu\.be\//)[1].split(/[?&]/)[0];
        }
        var thumb = 'http://img.youtube.com/vi/' + youtubeid + '/default.jpg';
        $(this).parent().addClass('thumbnail');
        $(this).addClass('clearfix');
        $(this).children('h3').before('<img src="'+thumb+'" alt="Thumbnail for '+title+'" class="pull-left" />');
    });


    var ytcplayer = {};
    $('.video-playlist li a').click(function() {
        var quality = $(this).attr('data-quality');
        if (quality === undefined) {
            quality = 'default'
        }
        var iframeid = $(this).attr('data-player-id');
        //var youtubeid = $(this).attr('data-video-id');
        var url = $(this).attr('href');
        if (url.match('http://(www.)?youtube|youtu\.be')) {
        youtubeid = url.split(/v\/|v=|youtu\.be\//)[1].split(/[?&]/)[0];
        }
        var thumb = 'http://img.youtube.com/vi/' + youtubeid + '/default.jpg';
        
        ytcplayVideo (iframeid, youtubeid, quality);
        return false;
    });

    function ytcplayVideo (iframeid, youtubeid, quality) {
        if (iframeid in ytcplayer) { 
            ytcplayer[iframeid].loadVideoById(youtubeid); 
        } else {
            ytcplayer[iframeid] = new YT.Player(iframeid, {
                events: { 
                    'onReady': function(){
                        ytcplayer[iframeid].loadVideoById(youtubeid);
                        ytcplayer[iframeid].setPlaybackQuality(quality);
                    }
                }
            });
        }
    }

});
/*end video gallery*/


//Toggle rotation of accordion heading arrows
$('#accordion').on('show', function (e) {
    $(e.target).prev('h2.accordion-heading').children('a').children('span').addClass('fa-rotate-90');
});
$('#accordion').on('hide', function () {
    $(this).find('.fa-rotate-90').removeClass('fa-rotate-90');
});
