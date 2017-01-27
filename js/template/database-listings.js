function urlencode(str) {
  str = (str + '').toString();
  //return encodeURIComponent(encodeURIComponent(str));
  return encodeURIComponent(encodeURIComponent(str)).replace(/\-/g, "%252D").replace(/\_/g, "%255F").replace(/\./g, "%252E").replace(/\!/g, '%2521').replace(/\~/g, '%257E').replace(/\*/g, '%252A').replace(/\'/g, '%2527').replace(/\(/g, '%2528').replace(/\)/g, '%2529');
}

function removeParameter(url, parameter) {
  var fragment, urlparts, urlBase, queryString, prefix, pars;
  fragment = url.split('#');
  urlparts= fragment[0].split('?');

  if (urlparts.length>=2) {
    urlBase=urlparts.shift(); //get first part, and remove from array
    queryString=urlparts.join("?"); //join it back up

    prefix = encodeURIComponent(parameter)+'=';
    pars = queryString.split(/[&;]/g);
    for (var i= pars.length; i-->0;) { // reverse iteration as may be destructive
      if (pars[i].lastIndexOf(prefix, 0)!==-1) {// idiom for string.startsWith
        pars.splice(i, 1);
      }
    }
    url = urlBase+'?'+pars.join('&');
    if (fragment[1]) {
      url += "#" + fragment[1];
    }
  }
  return url;
}

function addParameter(url, key, value) {
  var query, anchor;
  query = url.indexOf('?');
  anchor = url.indexOf('#');
  if (query == url.length - 1) {
    // Strip any ? on the end of the URL
    url = url.substring(0, query);
    query = -1;
  }
  return (anchor > 0 ? url.substring(0, anchor) : url) + (query > 0 ? "&" + key + "=" + value : "?" + key + "=" + value) + (anchor > 0 ? url.substring(anchor) : "");
}

function loadPageVar(key, url) {
  var getLocation, l, parsed_url;
  if (typeof url === 'undefined') {
    return unescape(window.location.search.replace(new RegExp("^(?:.*[&\\?]" + escape(key).replace(/[\.\+\*]/g, "\\$&") + "(?:\\=([^&]*))?)?.*$", "i"), "$1"));
  } else {
    getLocation = function(href) {
      l = document.createElement('a');
      l.href = href;
      return l;
    };
    parsed_url = getLocation(url);
    return unescape(parsed_url.search.replace(new RegExp("^(?:.*[&\\?]" + escape(key).replace(/[\.\+\*]/g, "\\$&") + "(?:\\=([^&]*))?)?.*$", "i"), "$1"));
  }
}

function searchClear() {
  var field, io;
  $('#main-content input[type="search"]').after('<span class="icon-clear">x</span>');
  if ($('#main-content input[type="search"]').val().length > 1) {
    field = $('#main-content input[type="search"]');
    io = $(field).val().length ? 1 : 0 ;
    $(field).next('.icon-clear').stop().fadeTo(200,io);
  }
}

function setCheckboxes(url) {
  var subject, resource_type, letter, status;
  subject = loadPageVar('subject', url);
  resource_type = loadPageVar('resource_type', url);
  letter = loadPageVar('letter', url);
  status = loadPageVar('status', url);

  // uncheck all the boxes first, so that back button works
  $('input:checkbox[name="subject[]"]').prop('checked', false);
  $('input:checkbox[name="resource[]"]').prop('checked', false);
  $('input:checkbox[name="letter[]"]').prop('checked', false);
  $('input:checkbox[name="status[]"]').prop('checked', false);

  // check the appropriate boxes based on the url
  if (subject !== '') {
    if (subject.indexOf('.') !== -1) {
      subjects = subject.split('.');
      for (var i = 0; i < subjects.length; i++) {
        subject = encodeURIComponent(subjects[i]).toLowerCase();
        $('input:checkbox[value="'+subject+'"][name="subject[]"]').prop('checked', true);
      }
    } else {
      subject = encodeURIComponent(subject).toLowerCase();
      $('input:checkbox[value="'+subject+'"][name="subject[]"]').prop('checked', true);
    }
  }
  if (resource_type !== '') {
    if (resource_type.indexOf('.') !== -1) {
      resource_types = resource_type.split('.');
      for (var i = 0; i < resource_types.length; i++) {
        resource_type = encodeURIComponent(resource_types[i]).toLowerCase();
        $('input:checkbox[value="'+resource_type+'"][name="resource_type[]"]').prop('checked', true);
      }
    } else {
      resource_type = encodeURIComponent(resource_type).toLowerCase();
      $('input:checkbox[value="'+resource_type+'"][name="resource_type[]"]').prop('checked', true);
    }
  }
  if (letter !== '') {
    if (letter.indexOf('.') !== -1) {
      letters = letter.split('.');
      for (var i = 0; i < letters.length; i++) {
        letter = encodeURIComponent(letters[i]).toLowerCase();
        $('input:checkbox[value="'+letter+'"][name="letter[]"]').prop('checked', true);
      }
    } else {
      letter = encodeURIComponent(letter).toLowerCase();
      $('input:checkbox[value="'+letter+'"][name="letter[]"]').prop('checked', true);
    }
  }
  if (status !== '') {
    if (status.indexOf('.') !== -1) {
      statuses = status.split('.');
      for (var i = 0; i < statuses.length; i++) {
        letter = encodeURIComponent(statuses[i]).toLowerCase();
        $('input:checkbox[value="'+status+'"][name="status[]"]').prop('checked', true);
      }
    } else {
      status = encodeURIComponent(status).toLowerCase();
      $('input:checkbox[value="'+status+'"][name="status[]"]').prop('checked', true);
    }
  }
}

function readCheckboxes(url, event) {
  var subject, resource_type, letter, status;
  var items = {};

  // set up the url with the appropriate checkboxes
  if ($('input:checkbox[name="subject[]"]:checked').length > 0) {
    subject = $('input:checkbox[name="subject[]"]:checked').map(function() {
      return this.id;
    }).get().join('.');
    url = addParameter(url, 'subject', subject);
    items.subject = subject;
  } else {
    subject = '';
  }

  if ($('input:checkbox[name="resource_type[]"]:checked').length > 0) {
    resource_type = $('input:checkbox[name="resource_type[]"]:checked').map(function() {
    return this.id;
  }).get().join('.');
    url = addParameter(url, 'resource_type', resource_type);
    items.resource_type = resource_type;
  } else {
    resource_type = '';
  }

  if ($('input:checkbox[name="letter[]"]:checked').length > 0) {
    letter = $('input:checkbox[name="letter[]"]:checked').map(function() {
    return this.id;
  }).get().join('.');
    url = addParameter(url, 'letter', letter);
    items.letter = letter;
  } else {
    letter = '';
  }

  if ($('input:checkbox[name="status[]"]:checked').length > 0) {
    status = $('input:checkbox[name="status[]"]:checked').map(function() {
    return this.id;
  }).get().join('.');
    url = addParameter(url, 'status', status);
    items.status = status;
  } else {
    status = '';
  }

  if (window.location.search.indexOf('debug=true') > -1) {
    url = addParameter(url, 'debug', true);
  }
  if (window.location.search.indexOf('beta=true') > -1) {
    url = addParameter(url, 'beta', true);
  }

  return { items: items, url: url };
}

function getResults(sections, url, container) {
  // for each result div present on the page, do an ajax call
  $.each(sections, function(index, value) {
    if (value.section === 'results') {
      return $.ajax({
        beforeSend:function() {
          $('.loading').show(); // show loading gif
        },
        complete:function() {
          $('.loading').hide(); // hide loading gif
        },
        cache: true,
        url: url,
        success: function(data) {
          // need to filter the data by the url that is being used

          var State, subjectlist, resourcelist, letterlist, statuslist;
          State = History.getState();

          filters = $(data).find('.filter-list');

          if (filters.length > 0) {
            if (State.data.subject !== undefined) {
              subjectlist = $(data).find('ul.subject.filter-list');
              filter = $('ul.subject.filter-list');
              if (filter.length > 0) {
                filter.html($(subjectlist).prop('innerHTML'));
              } else {
                $('#subject').parent('fieldset').after('<ul class="subject filter-list unstyled well well-small clearfix">'+$(subjectlist).prop('innerHTML')+'</ul>');
              }
            } else {
              // remove the filter box if there is no filter to apply
              filter = $('#subject').parent('fieldset').next('ul.subject.filter-list');
              if (filter.length > 0) {
                filter.remove();
              }
            }

            if (State.data.resource_type !== undefined) {
              resourcelist = $(data).find('ul.resource_type.filter-list');
              filter = $('ul.resource_type.filter-list');
              if (filter.length > 0) {
                filter.html($(resourcelist).prop('innerHTML'));
              } else {
                $('#resource_type').parent('fieldset').after('<ul class="resource_type filter-list unstyled well well-small clearfix">'+$(resourcelist).prop('innerHTML')+'</ul>');
              }
            } else {
              filter = $('#resource_type').parent('fieldset').next('ul.resource_type.filter-list');
              if (filter.length > 0) {
                filter.remove();
              }
            }

            if (State.data.letter !== undefined) {
              letterlist = $(data).find('ul.letter.filter-list');
              filter = $('ul.letter.filter-list');
              if (filter.length > 0) {
                filter.html($(letterlist).prop('innerHTML'));
              } else {
                $('#letter').parent('fieldset').after('<ul class="letter filter-list unstyled well well-small clearfix">'+$(letterlist).prop('innerHTML')+'</ul>');
              }
            } else {
              // remove the filter box if there is no filter to apply
              filter = $('#letter').parent('fieldset').next('ul.letter.filter-list');
              if (filter.length > 0) {
                filter.remove();
              }
            }

            if (State.data.status !== undefined) {
              statuslist = $(data).find('ul.status.filter-list');
              filter = $('ul.status.filter-list');
              if (filter.length > 0) {
                filter.html($(statuslist).prop('innerHTML'));
              } else {
                $('#status').parent('fieldset').after('<ul class="status filter-list unstyled well well-small clearfix">'+$(statuslist).prop('innerHTML')+'</ul>');
              }
            } else {
              // remove the filter box if there is no filter to apply
              filter = $('#status').parent('fieldset').next('ul.status.filter-list');
              if (filter.length > 0) {
                filter.remove();
              }
            }
          }

          form = $(data).find('.database-search');

          parsed_results = $(data).find('.databases');
          pagination = $(data).find('.pagination');

          // display search form
          $('.database-search').html($(form).prop('innerHTML'));

          // reset search clear
          searchClear();

          typeaheadSetup(false);

          // display main search form
          container.html($(parsed_results).prop('innerHTML'));

          // expand link behavior
          expandDetails();

          // display pagination
          if (pagination.length > 0) {
            $('.pagination').html($(pagination).prop('innerHTML'));
          } else {
            $('.pagination').html('');
          }

        },
        error: function(error) {
          return false;
        },
        dataType: 'html'
      });
    }
  });
}

function prepareForm() {
  // prepare the form
  var form, container, url, title, h1, parent, id, sections, History, State, passDelay;
  form = $('.databases .database-search');
  searchClear();
  container = $('.databases');
  $(container).before('<div class="loading"><img src="https://template.emory.edu/assets/wdg/css/img/loader.gif" /> Loading Database Results</div>');
  title = document.title;
  sections = [];
  url = '';
  History = window.History;
  State = History.getState();
    
  // make checkboxes for each filter link
  $.each($('form#database-filter .accordion-body > li a, form#database-filter .standard > li a'), function() {
    parent = $(this).parent().parent().attr('id');
    id = urlencode($(this).text()).toLowerCase();
    if (id === '0%252d9') {
      id = '0-9';
    }
    $(this).wrap('<label class="checkbox">');
    $(this).before('<input type="checkbox" name="'+parent+'[]" id="'+id+'" value="'+id+'" />');
    $(this).contents().unwrap(); // remove the link so there is just label and input
  });

  $('form#database-filter .accordion-heading > a').after('<span class="icon-angle-right"></span>');
  $('.collapse').on('show', function(){
    $(this).parent().find('.icon-angle-right').removeClass('icon-angle-right').addClass('icon-angle-down');
  }).on('hide', function(){
    $(this).parent().find('.icon-angle-down').removeClass('icon-angle-down').addClass('icon-angle-right');
  });

  $('form#database-filter .accordion-body.in').parent().find('.accordion-heading span').removeClass('icon-angle-right').addClass('icon-angle-down');

  // set the initial checkboxes based on url, in case this request is a page refresh
  setCheckboxes();

  // make sure accordion link doesn't do anything if someone clicks it
  $('.accordion-toggle').click(function(event) {
    event.preventDefault();
  });

  // check the current html markup for elements that contain results
  if ($('.database-search').length > 0) {
    sections.push({'selector': '.database-search', 'section' : 'form'});
  }
  if ($('.featured-databases').length > 0) {
    sections.push({'selector': '.featured-databases', 'section' : 'results', 'status' : 'featured', 'title' : $('.featured-databases').data('title')});
  }
  if ($('.new-databases').length > 0) {
    sections.push({'selector': '.new-databases', 'section' : 'results', 'status' : 'new', 'title' : $('.new-databases').data('title')});
  }
  if ($('.trial-databases').length > 0) {
    sections.push({'selector': '.trial-databases', 'section' : 'results', 'status' : 'trial', 'title' : $('.trial-databases').data('title')});
  }
  if ($('.default-databases').length > 0) {
    sections.push({'selector': '.default-databases', 'section' : 'results', 'status' : 'default', 'title' : $('.default-databases').data('title')});
  }
  if ($('.no-results').length > 0) {
    sections.push({'selector': '.no-results', 'section' : 'results', 'status' : 'empty', 'title' : $('.no-results').data('title')});
  } 
  if ($('.pagination').length > 0) {
    sections.push({'selector': '.pagination', 'section' : 'pagination'});
  }

  sections = sections.sort();
  url = '';

  // handle form checkbox change
  $('#database-filter').on('change', function(event) {
    var target, subject, resource_type, letter, status, checkboxvalues, items;
    url = '';
    target = $(event.target);
    url = $('#database-filter').data('url');
    url = removeParameter(url, 'start');
    clearTimeout(passDelay);

    // search box
    if ($('#db_q').val()) {
      url = addParameter(url, 'q', $('#db_q').val());
    } else {
      url = addParameter(url, 'q', $('#q').val());
    }

    checkboxvalues = readCheckboxes(url, event);
    items = checkboxvalues.items;
    url = checkboxvalues.url;

    // if we just unchecked a box, remove the filter list indicator items
    if (target.is(':not(:checked)')) {
      // to remove
      var remove, parent, filters;
      remove = target.parent().text();
      parent = target.parents('ul').attr('id');
      filters = $('#' + parent).parent('fieldset').next('.filter-list');
      $(filters).find('li').each(function() {
        if ($(this).text().slice(0,-1) == remove) {
          $(this).remove();
          if (filters.children().length < 2) {
            filters.remove();
          }
        }
      });
    }

    // with a delay of 500ms, push all this stuff to the history object
    passDelay = setTimeout(function() {
      History.pushState( items, title, url);
      }, 500);
    });

    // handle filter remove click
    $(document).on('click', '.filter-list a.remove', function(event) {
      event.preventDefault();

      var ul, li, text, type;

      li = $(this).parent().parent('li');
      // if it is on the sidebar
      if (li.length > 0) {
        text = urlencode($(this).parent().text().slice(0, -1)).toLowerCase();
        ul = li.parent();
        type = ul.prev('fieldset').find('ul').attr('id');
      } else {
        // if it is in the body
        text = urlencode($(this).text().slice(0, -1)).toLowerCase();
        li = $(this).parent('li');
        ul = li.parent();
        type = li.attr('class');
      }

      if (text === '0%252d9') {
        text = '0-9';
      }

      $('#'+type).find('input:checkbox[value="'+text+'"]').click(); // fire the checkbox event

      // remove the shown filter
      li.remove();
      if (ul.children().length < 2) {
        ul.remove();
      }

    });


    // handle search form submission
    $(document).on('submit', 'form', function(event) {
      var params, target, value, checkboxvalues, items;

      if (event.target.id === 'database-search' || $('#search-databases').prop('checked') === true) {
        checkboxvalues = readCheckboxes(url, event);
        items = checkboxvalues.items;
        url = '';
        if ($('input#db_q').length > 0) {
          url = '';
          params = $(this).serializeArray();
          jQuery.each(params, function(i, param) {
            if (param.name === 'db_q' || param.name === 'q') {
              value = urlencode(param.value);
            } else {
              value = param.value;
            }
            if (i == 0) {
              url += '?';
            } else {
              url += '&';
            }
          url += param.name + '=' + value;
          });
          History.pushState( items, title, url);
          return false;
        }
      }

    });

    // handle search field typing
    $(document).on('propertychange keyup input paste', '#main-content input[type="search"]', function() {
      var io = $(this).val().length ? 1 : 0 ;
      $(this).next('.icon-clear').stop().fadeTo(200,io);
    });

    // handle search field clear
    $(document).on('click', '.icon-clear', function(event) {
      $(this).delay(200).fadeTo(200,0).prev('input').val('');
      $(this).parents('form').submit();
    });

    // handle pagination link click
    $(document).on('click', '.pagination a', function(event) {
      event.preventDefault();
      $('body,html').animate({
          scrollTop: 0
      }, 600);
      url = $(this).attr('href');
      History.pushState( null, title, url);
    });

    // when statechange happens on the history object, make the ajax call
    History.Adapter.bind(window,'statechange',function() {
        State = History.getState();
        setCheckboxes(State.url);
        getResults(sections, State.url, container);
    });
}

// so we can use the back button with html5 history stuff
history.navigationMode = 'compatible';

function expandDetails() {
/*  $('.database-results .listings a.expand').click(function(event) {
    event.preventDefault();
  });

  $('.database-details').on('show', function () {
    $(this).parent().addClass('expanded');
    $('a.expand', $(this).parent()).html('Collapse <span class="icon-angle-up"></span>');
  });

  $('.database-details').on('hide', function () {
    $(this).parent().removeClass('expanded');
    $('a.expand', $(this).parent()).html('Expand <span class="icon-angle-down"></span>');
  });*/
  $('.databases .listings a.expand').click(function(event){
    $(this).prev('.database-details').toggleClass('collapse');
    $(this).parent().toggleClass('expanded');

    var expand = 'Expand <span class="icon-angle-down"></span>';
    var collapse = 'Collapse <span class="icon-angle-up"></span>';

    switch( $(this).html() ) {
      case expand :
        $(this).html(collapse);
        break;
      case collapse: 
        $(this).html(expand);
        break;
    }

    event.preventDefault();
  });

}

function typeaheadSetup(prefetch) {
  var field, url, end;
  field = $('.database-search .ajax-typeahead');
  if (field.length > 0) {
    url = field.data('url');
    end = url.indexOf('?') == -1 ? '?' : '&';
    url = url + end;

    if (prefetch === true) {
    field.typeahead({
      //name: 'databases',
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

    } else {
      field.typeahead({
      //name: 'databases',
      limit: 100,

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
    }

    field.on('typeahead:selected', function(obj, datum) {
      window.location = datum.redirect_url;
    });

    $('.twitter-typeahead').addClass('span10');
    $('.tt-hint').addClass('input span12');
    $('.tt-query').css('width', '100%');
    if (Modernizr.mq('screen and (max-width:767px)')) {
      $('.database-search.big-search .btn').addClass('typeahead');
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
  prepareForm();
  expandDetails();
  typeaheadSetup(true);
});