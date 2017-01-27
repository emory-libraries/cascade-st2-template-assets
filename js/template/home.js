//Options for configuring the sliders: http://bxslider.com/options

function utilitySlider() {
    var mywidth = $('.utilities li').width();
    $('.utilities').bxSlider({
        slideWidth: mywidth,
        //startSlide: 1,
        minSlides: 1,
        maxSlides: 8,
        slideMargin: 0,
        infiniteLoop: true,
        pager: false,
        nextText: '>',
        prevText: '<'
    });
    if ($('.today-hours').length > 0) {
        hoursComponent('slider');
    }
}

function bookSlider() {
    var mywidth = $('.books-slider li').width();
    $('.books-slider').bxSlider({
        slideWidth: mywidth,
        randomStart: true,
        captions: false,
        auto:true,
        autoHover: true,
        autoDelay: 3000,
        minSlides: 1,
        slideMargin: 0,
        infiniteLoop: true,
        pager: false,
        pause: 5000,
        speed: 500,
        nextText: '>',
        prevText: '<'
    });
}

function typeaheadSetup() {
  var field, url, end;
  field = $('#library_q.ajax_typeahead');
  if (field.length > 0) {
    url = $('#hero-search-databases').data('url');
    end = url.indexOf('?') == -1 ? '?' : '&';
    url = url + end;
    field.typeahead({
      name: 'databases',
      limit: 100,

      prefetch: {
        url: url,
        filter: function(data) {
          var dataset = [];
          if (data.RES !== undefined) {
            dataset = getTypeaheadDatabase(data,url);
          }
          return dataset;
        }
      },

      remote: {
        url: url + 'q=%QUERY',
        filter: function(data) {
          var dataset = [];
          if (data.RES !== undefined) {
            dataset = getTypeaheadDatabase(data,url);
          }
          return dataset;
        }
      },


      template: [
        '<p class="ta-h1">{{value}}</p>',
      ].join(''),
      engine: Hogan

    });

    field.on('typeahead:selected', function(obj, datum) {
      window.location = datum.redirect_url;
    });

    if ($('.big-search.database-search.database-page').length === 0){
        $('.twitter-typeahead').css('width', '103%');
    }else if ($('.big-search.database-search.database-page').length > 0){
        $('.twitter-typeahead').addClass('span10');
    }
    $('.tt-hint').addClass('input span12');
    $('.tt-query').css('width', '100%');
    if (Modernizr.mq('screen and (max-width:767px)')) {
      $('.tt-hint').css('width', '100%');
    }
  }
}


function getTypeaheadDatabase(data,url) {
  var dataset = [];

  if (data.RES.M == 1) {
    $.each(data.RES.R.MT, function(j, value) {
      if (value['@attributes'].N == 'full_title') {
        data.RES.R.T = value['@attributes'].V;
      }
    });

    $.each(data.RES.R.MT, function(j, value) {
      if (value['@attributes'].N == 'full_description') {
        data.RES.R.S = value['@attributes'].V;
      }
    });

    $.each(data.RES.R.MT, function(j, value) {
      if (value['@attributes'].N == 'external_link') {
        data.RES.R.U = value['@attributes'].V;
      }
    });

    data.RES.R.combined = data.RES.R.T;
    dataset.push({
      'name': data.RES.R.T,
      'description': data.RES.R.S,
      'language': 'en',
      'value' : data.RES.R.combined,
      'redirect_url' : data.RES.R.U,
      "tokens" : data.RES.R.T
    });

  } else if (data.RES.M > 1) {
    for(i = 0; i < data.RES.R.length; i++) {

      $.each(data.RES.R[i].MT, function(j, value) {
        if (value['@attributes'].N == 'full_title') {
          data.RES.R[i].T = value['@attributes'].V;
        }
      });

      $.each(data.RES.R[i].MT, function(j, value) {
        if (value['@attributes'].N == 'full_description') {
          data.RES.R[i].S = value['@attributes'].V;
        }
      });

      $.each(data.RES.R[i].MT, function(j, value) {
        if (value['@attributes'].N == 'external_link') {
          data.RES.R[i].U = value['@attributes'].V;
        }
      });

      data.RES.R[i].combined = data.RES.R[i].T;

      dataset.push({
        'name': data.RES.R[i].T,
        'description': data.RES.R[i].S,
        'language': 'en',
        'value' : data.RES.R[i].combined,
        'redirect_url' : data.RES.R[i].U,
        "tokens" : data.RES.R[i].T
      });

    }
  }
  return dataset;
}

// on load
$(function() {
  typeaheadSetup();
});

$(document).ready(function(){
    if ($('#form-library-search').length > 0) {
        $('#form-library-search').librarySearch({ // search plugin for big search form
            'search_field': $('#library_q'),
            'size': 'large'
        });
    }
    if ($('.utilities').length > 0){
        utilitySlider();
    }
    
    if ($('.books-slider').length > 0){
        bookSlider();
    }
});