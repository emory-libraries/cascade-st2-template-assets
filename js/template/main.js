/* emorystandard object
 * Plugin
 * Some global support variables, basic functionality on the emorystandard namespace. derived from bostonglobe
 ______________________________________________________________________________ */

 if ( !window.console ) {
  window.console = new function() {
    this.log = function(str) {};
    this.dir = function(str) {};
  };
};

(function(win, undefined){
  //define some globals
  var doc         = win.document,
  docElem     = doc.documentElement,
  head        = doc.head || doc.getElementsByTagName( "head" )[0] || docElem,
  Modernizr   = win.Modernizr;

  //define "emorystandard" global namespace
  emorystandard = {};
  
  // mixins - utility object extender
  emorystandard.extend = function( obj, props ){
    for (var i in props ) {
      obj[i] = props[i];
    }
    return emorystandard;
  };
  
  //support hash
  emorystandard.extend( emorystandard, {
    browser : {},
    dev     : {},
    support : {}
  });
  
  //dev mobile assets flag: use for previewing mobile-optimized assets
  emorystandard.dev.mobileOverride = location.search.indexOf("mobile-assets") >= 0;
  
  //callback for dependencies.
  // You can use isDefined to run code as soon as the document.body is defined, for example, for body-dependent scripts
  // or, for a script loaded asynchronously that depends on other scripts, such as jQuery.
  // First argument is the property that must be defined, second is the callback function
  emorystandard.onDefine = function( prop, callback ){
    var callbackStack   = [];   
    if( callback ){
      callbackStack.push( callback );
    }       
    function checkRun(){
      if( eval( prop ) ){
        while( callbackStack[0] && typeof( callbackStack[0] ) === "function" ){
          callbackStack.shift().call( win );
        }
      }
      else {
        setTimeout(checkRun, 15); 
      }
    };
    checkRun();
  };
  // shortcut of isDefine body-specific 
  emorystandard.bodyready = function( callback ){
    emorystandard.onDefine( "document.body", callback );
  };
  /* Asset loading functions:
    - emorystandard.load is a simple script or stylesheet loader
    - scripts can be loaded via the emorystandard.load.script() function
    - Styles can be loaded via the emorystandard.load.style() function, 
      which accepts an href and an optional media attribute
      */
  //loading functions available on emorystandard.load
  emorystandard.load = {};

  //define emorystandard.load.style
  emorystandard.load.style = function( href, media ){
    if( !href ){ return; }
    var lk          = doc.createElement( "link" ),
    links       = head.getElementsByTagName("link"),
    lastlink    = links[links.length-1];
    lk.type     = "text/css";
    lk.href     = href;
    lk.rel      = "stylesheet";
    if( media ){
      lk.media = media;
    }           
      //if respond.js is present, be sure to update its media queries cache once this stylesheet loads
      //IE should have no problems with the load event on links, unlike other browsers
      if( "respond" in window ){
        lk.onload = respond.update;
      }           
      //might need to wait until DOMReady in IE...
      if( lastlink.nextSibling ){
        head.insertBefore(lk, lastlink.nextSibling );
      } else {
        head.appendChild( lk );
      }
    };
    
  //define emorystandard.load.script
  emorystandard.load.script = function( src ){
    if( !src ){ return; }
    var script      = doc.createElement( "script" ),
    fc          = head.firstChild;
    script.src  = src;
      //might need to wait until DOMReady in IE...
      if( fc ){
        head.insertBefore(script, fc );
      } else {
        head.appendChild( script );
      }
    };
    
  //quick element class existence function
  emorystandard.hasClass = function( el, classname ){
    return el.className.indexOf( classname ) >= 0;
  };
  
  //cookie functions - set,get,forget
  emorystandard.cookie = {
    set: function(name,value,days) {
      if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
      }
      else var expires = "";
      document.cookie = name+"="+value+expires+"; path=/";
    },
    get: function(name) {
      var nameEQ = name + "=";
      var ca = document.cookie.split(';');
      for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
      }
      return null;
    },
    forget: function(name) {
      createCookie(name, "", -1);
    }
  };
  
  emorystandard.clearPageCache = function() {
    if ((/iphone|ipad.*os 5/i).test(navigator.appVersion)) {
      window.onload=function () {
        localStorage.setItem('href',location.href);
      };
      window.onpopstate=function () {
        var a=localStorage.getItem('href'),
        b=location.href;
        if (b!==a&&b.indexOf((a+"#"))===-1) {
          document.body.style.display='none';
          location.reload();
        }
      };
    }
  };
  //extend emorystandard.support with some modernizr definitions
  emorystandard.extend( emorystandard.support, {
    localStorage        : Modernizr.localstorage,
    applicationcache    : Modernizr.applicationcache,
    touch               : Modernizr.touch,
    displayTable        : Modernizr[ "display-table" ]
  });
})(this);

/*! A fix for the iOS orientationchange zoom bug. Script by @scottjehl, rebound by @wilto.MIT / GPLv2 License.*/
(function(a){function m(){d.setAttribute("content",g),h=!0}function n(){d.setAttribute("content",f),h=!1}function o(b){l=b.accelerationIncludingGravity,i=Math.abs(l.x),j=Math.abs(l.y),k=Math.abs(l.z),(!a.orientation||a.orientation===180)&&(i>7||(k>6&&j<8||k<8&&j>6)&&i>5)?h&&n():h||m()}var b=navigator.userAgent;if(!(/iPhone|iPad|iPod/.test(navigator.platform)&&/OS [1-5]_[0-9_]* like Mac OS X/i.test(b)&&b.indexOf("AppleWebKit")>-1))return;var c=a.document;if(!c.querySelector)return;var d=c.querySelector("meta[name=viewport]"),e=d&&d.getAttribute("content"),f=e+",maximum-scale=1",g=e+",maximum-scale=10",h=!0,i,j,k,l;if(!d)return;a.addEventListener("orientationchange",m,!1),a.addEventListener("devicemotion",o,!1)})(this); 

/* emoryUtilityMenu
 * Plugin
 * derived from emory.edu version with small changes
 ______________________________________________________________________________ */
 (function($){
  $.fn.extend({
    emoryUtilityMenu: function(options) {
      return this.each(function() {
        // Assign current element to variable, in this case is UL element
        $("#emory-wide li:not('.search')").hover(
          function () { 
            $(this).addClass('active');
            $(this).find("li.top > a").addClass('active');
            $(this).find("div.nav-box").show();
          },
          function () { 
            $(this).removeClass('active');
            $(this).find("li.top > a").removeClass('active');
            $(this).find("div.nav-box").hide();
          }
          );
      });
    }
  });
})(jQuery);

/**
  *   jQuery Library Search Plugin
  *   written by Jonathan Stegall <jonathan.stegall@emory.edu>
  *   default usage:
    $('#form-search').librarySearch();
    */
    (function ($) {
      "use strict";
      var methods = {
        init : function ( options ) {
          var settings = {
            'size': 'small',
            'search_form': $(this),
            'search_field': $('#q', this),
            'placeholder_text': $('input', this).attr('placeholder'),
            'search_scope': $('.search-scope', this),
            'search_scope_label': $('.search-scope label', this),
            'options_container': $("footer ul.options"),
            'options_info': $('footer ul.options', this),
            'option_description': $('footer .options > li', this),
            'current': $('.search-scope label.checked', this),
            'next': $('.search-scope label.checked', this).next(),
            'prev': $('.search-scope label.checked', this).prev(),
            'current_info': $('ul.options > .active', this),
            'next_info': $('ul.options > .active', this).prev(),
            'prev_info': $('ul.options > .active', this).prev(),
            'error_placeholder': 'Please enter a search term',
            'TABKEY': 9,
            'ENTERKEY':13,
            'DOWNKEY':40,
            'UPKEY':38
          };
          if (options) {
            $.extend( true, settings, options );
          }
          return this.each(function() {
            searchScope(settings);
            searchScopeLabels(settings);
            if (settings.size == 'large') {
              searchExplanations(settings);
            }
          });

      // handle the show and hide of the search scope options
      function searchScope(settings) {
        // hide the explanation text by default
        if (settings.size == 'large') {
          // add arrow next to label.
          $('footer h4 a', settings.search_form).append('<span class="icon-angle-right"></span>');
        }

        // if user clicks the search field, show the options
        $(settings.search_field).on('focus, click',function() {
          $(settings.search_scope).show();
          $(document).on('focusin.'+settings.search_scope+' click.'+settings.search_scope, function(e) {
            if ($(e.target).closest('.search-scope, ' + $(settings.search_field).length)) return;
            $(document).off('.search-scope');
            $(settings.search_scope).hide();
          });
        });

        // if the user arrows or tabs through the options, trigger the normal change event with extra parameter for keypress=true
        // (keydown is more accurate for capturing keystrokes)
        $(settings.search_field).keydown(function(e) {
          var key = e.keyCode || e.which;
          if (key == settings.DOWNKEY) {
            e.preventDefault();
            $(settings.next).trigger('change', true);
          } else if (key == settings.UPKEY) {
            e.preventDefault();
            $(settings.prev).trigger('change', true);
          } else if (key == settings.ENTERKEY && $(settings.search_field).val().length == 0) {
            e.preventDefault();
            emptySearch();
          } else if (key == settings.ENTERKEY && $(settings.search_field).val().length != 0) { // submit with enter if there is value
            e.preventDefault();
            $(settings.search_form).submit();
          }
        });

          // do not submit the placeholder value
          $(settings.search_form).on('submit',function(e) {
            if ($(settings.search_field).val().length == 0) {
              e.preventDefault();
              emptySearch();
            }
          });
        }

        function searchScopeLabels(settings) {
        // if one of the options is clicked, hide the explanation, change the placeholder, and switch the explanation. if explanation is already opened by user, show the appropriate one
        $(settings.search_scope_label).on('change',function(event, keypress) {
          keypress = typeof keypress !== 'undefined' ? keypress : false;          
          // uncheck and check radio button labels
          $(settings.search_field).focus();
          $(settings.search_scope_label).removeClass('checked');
          $(this).addClass('checked');
          settings.current = $(this);
          settings.next = $(this).next();
          settings.prev = $(this).prev();
          // get the id of the radio button and check it
          var $item = $(this).children('input'), itemid = $item.attr('id').substr(12);
          $item.attr('checked','checked');

          // get the placeholder for the specific radio button
          $(settings.search_field).attr('placeholder', $(this).children('input').data('search-placeholder'));
          settings.placeholder_text = $(this).children('input').data('search-placeholder');

          // hide the radio buttons
          if (keypress !== true) {
             // $(settings.search_scope).hide();
           }

          // also handle the descriptions
          if (settings.size == 'large') {
            // identify active explanation, and hide everything else
            settings.current_info = $('ul.options > .active');
            $(settings.options_container).hide();

            // switch the "what does this do" indicator
            $('footer h4 .search-indicator', settings.search_form).html('<em>' + $(settings.search_field).attr('placeholder') + '</em> do?');

            // deactivate the activated one, and activate the selected one
            $(settings.current_info).removeClass('active');
            $('li.'+itemid, settings.options_info).addClass('active');
            settings.current_info = $('ul.options > .active');

            // if the description is open, show the current stuff
            if ($('footer', settings.search_form).hasClass('open')) {
              $(settings.current_info).show();
            }
            
          }

        }); // end on change

$(document).on("click",function(e){
  if ($(e.target).closest($(settings.search_field)).length == 0) {
            // .closest can help you determine if the element 
            // or one of its ancestors is #menuscontainer
            $(settings.search_scope).hide();
            if($('footer', settings.search_form).hasClass('open')){
              $(settings.options_container).show();
            }
          }
        });
}

function searchExplanations(settings) {
        // vertical arrow above the explanation
        $(settings.options_info).prepend('<span class="search-arrow"></span>');

        // by default, hide all the options container
        $(settings.options_container).hide();

        // if the "what does this search" is clicked, toggle it
        $('footer h4 a', settings.search_form).click(function() {
          // toggle the arrow with the explanation stuff

          /*$('.search-arrow').slideToggle(); 
          $(settings.current_info).slideToggle();*/
          
          var window_width = $(window).width();
          if(window_width<=767){
            $("#form-library-search .options").slideToggle();
          }
          else{
            $("#form-library-search .options").fadeToggle();
          }
          

          $('footer', settings.search_form).toggleClass('open');
          if ($('footer', settings.search_form).hasClass('open')) {
            $('.icon-angle-right').addClass('icon-rotate-90');
          } else {
            $('.icon-angle-right').removeClass('icon-rotate-90');
          }        
          return false;
        }); // end on click
      }

      // if user tries to submit empty form, call this and set error message
      function emptySearch() {
        $(settings.search_field).attr('placeholder','Please enter a search term.').css({'box-shadow': 'rgba(255, 131, 131, 0) -4px -5px 15px'});

        $(settings.search_field).stop(true,true).animate({'opacity':'0.8'},500).css({'box-shadow': 'rgba(255, 131, 131, 0.7) -4px -5px 15px'});
        $(settings.search_field).animate({'opacity':'1'},250);

        function clearErrorMsg(){
          $(settings.search_field).attr('placeholder',settings.placeholder_text).css({'box-shadow': 'rgba(255, 131, 131, 0) -4px -5px 15px'});
        }

        window.setTimeout(clearErrorMsg,3000);
      }

    }    
  };
  
  $.fn.librarySearch = function( method ) {
    // Method calling logic
    if ( methods[method] ) {
      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.librarySearch' );
    }
  };
  
})(jQuery);

/* Navigation
 * Functions for global navigation
 ______________________________________________________________________________ */
 function toggleButtons() {
  $('.toggle-nav').click(function() {
    toggleItems('.toggle-nav','#main-nav');
    return false;
  });
  $('.toggle-search').click(function() {
    toggleItems('.toggle-search','#emory-wide');
    return false;
  });
}
function toggleItems(button, item) {
  //$(item).toggle();
  $(item).toggleClass('visible-phone');
  $(button).toggleClass('active');
  return false;
}
function justifyNav(largescreen) {
  if (largescreen == true) {
    var totalWidth = $('#main-nav').width();
    var getWidths = 0;
    $('#main-nav li a').each(function() {
      getWidths += $(this).width();
    });
    remainder = totalWidth - getWidths;
    padding = remainder / $('#main-nav li a').length;
    newpadding = padding / 2 - 1;
    $('#main-nav li').each(function () {
      $(this).children('a').css('padding-left',newpadding+'px');
      $(this).children('a').css('padding-right',newpadding+'px');
    });
    // fix rounding at the end
    $('#main-nav li a:last').hover(function(){                           
      $('#main-nav').addClass('hover_background');
    },
    function(){
      $('#main-nav').removeClass('hover_background');
      // check if the last item is toggled to on state. note hover state function above will remove the class
      if ($('#main-nav li a:last').hasClass('active')) {
        $('#main-nav').addClass('hover_background');
      }
    });
    // check if the last item is toggled to on state. note hover state function above will remove the class
    if ($('#main-nav li a:last').hasClass('active')) {
      $('#main-nav').addClass('hover_background');
    } 
  } else {
    $('#main-nav li').each(function () {
      $(this).children('a').css('padding-left','');
      $(this).children('a').css('padding-right','');
    });
  }
}

/* Global layout
 * Layout conventions across site
 ______________________________________________________________________________ */

// Equal Height Columns:
// generates balanced height elements across a given row
// on any elements with class of .equal-height
// only applied to wider views: larger tablets and up
function setEqualHeights(largescreen, container, selector, ajax) {
  var container, selector, ajax;
  if (container === undefined) {
    container = '.equal-height-row';
  }
  if (selector === undefined) {
    selector = '.equal-height'; // if we remove the dot here, works on news feed. with it, works everywhere else.
  }
  if (ajax === undefined) {
    ajax = false;
  }
  if (largescreen == true) {
     $(container).each(function() { // each equal-height-row
      var highestBox = 0;
      var highestContent = 0;
      var thisHeight = 0;
      $(this).children(selector).each(function(){ // each equal-height under the specific equal-height-row
        // get the height of the container div
                var thisHeight = $(this).height(); // height of equal-height
                
        if (thisHeight > highestContent) { // is the height value taller than 0
          highestContent = thisHeight;
        }
                // adjust for padding when necessary
                if (thisHeight > highestBox) {
                  highestBox = thisHeight;
                }
              });
      $(this).children(selector).height(highestBox);
      $(this).children(selector).children(selector).height(highestContent);
    });
   } else {
      $(container).each(function() { // each equal-height-row
        $(this).children(selector).height('');
        $(this).children(selector).children(selector).height('');
      });
    }
  }
// search on a single page without submitting a form
// customform and filterclass are optional parameters
// use filterclass to assign a different width to the form (default is span12)
function searchOnPage(filtered, selector, placeholder, customform, filterclass, wrapped) {
  var searchwrapper = 'pagesearch-wrap';
  emorystandard.clearPageCache();
  $('.no-results').addClass('hidden');
  $(selector).parent().parent().show();
  if (wrapped !== undefined) {
    $(wrapped).wrap('<div class="'+searchwrapper+'">');
  }
  // check for a cookie. use it as the value if there is one.
   /* if (emorystandard.cookie.get('pagesearch') != null) {
    var lastsearch = '', count = 0; //cookie caused trouble
    // Loop through the item list
    $(selector).each(function(){
      // If the list item does not contain the text phrase fade it out
      if ($(this).text().search(new RegExp(lastsearch, "i")) < 0) {
        $(this).fadeOut();
        // Show the list item if the phrase matches and increase the count by 1
      } else {
        $(this).show();
        count++;
      }
    });
    if (count === 0) {
      // create a child of the filtered element with a class of no-results hidden to use this
            $('.no-results').removeClass('hidden');
            $(selector).parent().parent().hide();
    }
  } else {
    var lastsearch = '';
  }*/
  var lastsearch = '';
  
  // generate the html for the form, and place it before the filtered selector
  if (customform === undefined && filterclass === undefined && wrapped === undefined) {
    $(filtered).before('<div class="filter"><form action="" name="page-search" method="post"><div class="input"><label><input autocomplete="off" class="span12" id="filter-on-page" name="filter-on-page" placeholder="'+placeholder+'" value="'+lastsearch+'" type="search"/></label></div></form></div>');    
  } else if (customform === undefined && wrapped === undefined) {
    $(filtered).before('<div class="filter"><form action="" name="page-search" method="post"><div class="input"><label><input autocomplete="off" class="'+filterclass+'" id="filter-on-page" name="filter-on-page" placeholder="'+placeholder+'" value="'+lastsearch+'" type="search"/></label></div></form></div>');    
  } else if (customform === undefined) {
    $('.'+searchwrapper).before('<div class="filter"><form action="" name="page-search" method="post"><div class="input"><label><input autocomplete="off" class="'+filterclass+'" id="filter-on-page" name="filter-on-page" placeholder="'+placeholder+'" value="'+lastsearch+'" type="search"/></label></div></form></div>');    
  } else {
      // we will use custom code for this, if it is provided in the function call
      $(filtered).before(customform);
    }
    $('#filter-on-page').keyup(function() {
      $('.no-results').addClass('hidden');
      $(selector).parent().parent().show();
    // Retrieve the input field text and reset the count to zero
    var filter = $(this).val(), count = 0;
    // set a cookie so we know what has been searched
    emorystandard.cookie.set('pagesearch', filter);
    // Loop through the item list
    $(selector).each(function(){
      // If the list item does not contain the text phrase fade it out
      if ($(this).text().search(new RegExp(filter, "i")) < 0) {
        $(this).fadeOut();
              // Show the list item if the phrase matches and increase the count by 1
            } else {
              $(this).show();
              count++;
            }
          });
    if (count === 0) {
          // create a child of the filtered element with a class of no-results hidden to use this
          $('.no-results').removeClass('hidden');
          $(selector).parent().parent().hide();
        }
      });
    $(filtered).find('a').click(function() {
      window.onunload = function(){}; // reload the page if accessed by back button, if an item is clicked
    });
  }
/*!
* FitVids 1.0
*
* Copyright 2011, Chris Coyier - http://css-tricks.com + Dave Rupert - http://daverupert.com
* Credit to Thierry Koblentz - http://www.alistapart.com/articles/creating-intrinsic-ratios-for-video/
* Released under the WTFPL license - http://sam.zoy.org/wtfpl/
*
* Date: Thu Sept 01 18:00:00 2011 -0500
*/
(function(a){a.fn.fitVids=function(b){var c={customSelector:null};var e=document.createElement("div"),d=document.getElementsByTagName("base")[0]||document.getElementsByTagName("script")[0];e.className="fit-vids-style";e.innerHTML="&shy;<style>               .fluid-width-video-wrapper {                 width: 100%;                              position: relative;                       padding: 0;                            }                                                                                   .fluid-width-video-wrapper iframe,        .fluid-width-video-wrapper object,        .fluid-width-video-wrapper embed {           position: absolute;                       top: 0;                                   left: 0;                                  width: 100%;                              height: 100%;                          }                                       </style>";d.parentNode.insertBefore(e,d);if(b){a.extend(c,b)}return this.each(function(){var f=["iframe[src*='player.vimeo.com']","iframe[src*='www.youtube.com']","iframe[src*='www.youtube-nocookie.com']","iframe[src*='www.kickstarter.com']","object","embed"];if(c.customSelector){f.push(c.customSelector)}var g=a(this).find(f.join(","));g.each(function(){var l=a(this);if(this.tagName.toLowerCase()==="embed"&&l.parent("object").length||l.parent(".fluid-width-video-wrapper").length){return}var h=(this.tagName.toLowerCase()==="object"||(l.attr("height")&&!isNaN(parseInt(l.attr("height"),10))))?parseInt(l.attr("height"),10):l.height(),i=!isNaN(parseInt(l.attr("width"),10))?parseInt(l.attr("width"),10):l.width(),j=h/i;if(!l.attr("id")){var k="fitvid"+Math.floor(Math.random()*999999);l.attr("id",k)}l.wrap('<div class="fluid-width-video-wrapper"></div>').parent(".fluid-width-video-wrapper").css("padding-top",(j*100)+"%");l.removeAttr("height").removeAttr("width")})})}})(jQuery);

/* Fallbacks
 * Fallbacks for older browsers
 ______________________________________________________________________________ */
 function placeholderFallback() {
  Modernizr.load({
    'test': Modernizr.placeholder,
    'nope': ["//cdnjs.cloudflare.com/ajax/libs/jquery-placeholder/2.0.7/jquery.placeholder.min.js"],
    'complete': function() {
      $('input').placeholder();
    }
  });
}

/* General
______________________________________________________________________________ */

function checkScreenSize() {
  var largescreen = true;
  if (Modernizr.mq('screen and (min-width:768px)')) {
    largescreen = true;
  } else if (Modernizr.mq('screen and (max-width:767px)')) {
    largescreen = false;
  }

  if ($('.lt-ie8').length) {
    if (screen.width > 768) {
      largescreen = true;
    } else {
      largescreen = false;
    }
  }

  return largescreen;
}

// assign functions to run on window orientation change. do this carefully.
function updateOrientation() {
  var largescreen = checkScreenSize();
  setEqualHeights(largescreen);
};

// options for things included in bootstrap
function bootstrapOptions() {
  $('.alert-close').prepend('<button type="button" class="close" data-dismiss="alert">&times;</button>');
  $('.alert-close').alert();
}

// configure use of the bootstrap typeahead component with search appliance results
function typeaheadConfig() {
  if ($('.ajax-typeahead')) {
    var url = $('.ajax-typeahead').data('url');
    window.query_cache = {};
    $('.ajax-typeahead').typeahead({
      source: function (q, process) {
        if (query_cache[q]) {
          process(query_cache[q]);
          return;
        }
        if ( typeof searching != 'undefined') {
          clearTimeout(searching);
          process([]);
        }
        searching = setTimeout(function() {
          return $.get(url, { q: q }, function (data) {
            // make a json string that bootstrap can use
            var num = data.RES.M;
            var allResults = { 'results': [] };
            if (num != 1) {
              $.each(data.RES.R,function(i,item){
                var currentResult = {};
                currentResult = item.T; // we could also add the url in here and make it clickable
                allResults.results.push(currentResult);
                data = allResults;
              });
            } else {
              var currentResult = {};
              currentResult = data.RES.R.T;
              allResults.results.push(currentResult);
              data = allResults;
            }
            return process(data.results);
          });
        }, 600); // 300 ms
      }
    });
}
}




/*
/*var url = $('.ajax-typeahead').data('url');
source: function (q, process) {
      if (query_cache[q]) {
        process(query_cache[q]);
        return;
      }
      if ( typeof searching != 'undefined') {
        clearTimeout(searching);
        process([]);
      }
      searching = setTimeout(function() {
        return $.get(url, { q: q }, function (data) {
          // make a json string that bootstrap can use
          var num = data.RES.M;
          if (num != 1) {
            console.log(num);
            var allResults = { 'results': [] };
            $.each(data.RES.R,function(i,item){
              var currentResult = {};
              currentResult = item.T; // we could also add the url in here and make it clickable
              allResults.results.push(currentResult);
              data = allResults;
              return process(data.results);
            });
          } else {
            var allResults = { 'results': [] };
            var currentResult = {};
            currentResult = data.RES.R.T;
            allResults.results.push(currentResult);
            data = allResults;
            return process(data.results);
          }

        });
      }, 600); // 300 ms
    }
    */

    function hoursComponent(placement){
      if (placement == 'footer') {
        var $hours_container = $('.hours-component .footer-hours'), url = $hours_container.data('url');
        $.get(url, function(data) {
          var $xml = $(data),
          $hours = $xml.find('table > tbody tr'),
          $footer = $xml.find('table > tfoot tr');
          var $render_list = '';
          $hours.each(function(i){
            var $this = $(this),
            day = $this.find('th'),
            number_of_days = 3,
            hours = $this.find('td'),  
            $render_day = '';

            if(data && i<number_of_days) {
              if(i==1){
                $render_day = '<ul><li>' + 'Tomorrow' + '</li> <li>' + hours.text() + '</li></ul>';
            //$ul.append('<li>' + 'Tomorrow' + '</li> <li>' + hours.text() + '</li>').appendTo($results);
          } else if (i==0) {
            $render_day = '<ul class="today"><li>' + day.text() + '</li> <li>' + hours.text() + '</li></ul>';
          }
          else{
            $render_day = '<ul><li>' + day.text() + '</li> <li>' + hours.text() + '</li></ul>';
            //$ul.append('<li>' + day.text() + '</li> <li>' + hours.text() + '</li>').appendTo($results);
          }
        }
        $render_list += $render_day;
      });

          $hours_container.html($render_list);
        });
} else if (placement == 'slider') {
  var $hours_container = $('.utility li .today-hours'), 
  url = $hours_container.data('url');
    //console.log(url);
    $.get(url, function(data) {
      var $xml = $(data),
      $hours = $xml.find('table > tbody tr'),
      $footer = $xml.find('table > tfoot tr'),
      $results = $('<span></span>');

      $hours.each(function(){
        var $this       =    $(this),
        day  =   $this.find('th'),
        hours  =   $this.find('td');

        if(data && day.text() == 'Today') {
          $hours_container.html('Today: '+hours.text());
          return false;
        }
      });
    });
  }
}

/* Functions for old IE use only
______________________________________________________________________________ */

function sectionChildren() {
  $('.people.general li:nth-child(2n+1)').addClass('odd');
  $('.col2col3 .span9 .pages .span3:nth-child(3n+1)').addClass('three_n');
  $('.col2col3 .span9 .pages .span3:nth-child(4n+1)').addClass('four_n');
}

function applyTableStripes(){
  if($('.table-striped').length>0){
    $(".table-striped tbody > tr:nth-child(odd) > td, .table-striped tbody > tr:nth-child(odd) > th").css({'background-color': '#F2F5F7'});
  }
}

function lastChildStyles(){
  $("nav#main-nav ul li:last-child, .footer-hat .component:last-child, .items li.item:last-child a, .pages .subpages li:last-child a").css({
    'border-right':'none'
  });

}


/* Document load and window resize
______________________________________________________________________________ */

// assign functions to run when the page loads. do this carefully.
$(document).ready(function() {
  $('a[rel="external"], a[rel="external nofollow"]').click( function() {
    window.open( $(this).attr('href') );
    return false;
  });
  toggleButtons();
  $('#form-search').librarySearch(); // call the search plugin for the top right search form
  $('#emory-wide ul').emoryUtilityMenu();
  var largescreen = checkScreenSize();
  // if browser is less than ie8
  if ($('.lt-ie8').length) {
    justifyNav(largescreen);
  }
  $('#main-content .video').fitVids(); // any .video inside #main-content
  placeholderFallback();
  bootstrapOptions();
  //typeaheadConfig();
  hoursComponent('footer');

  var $slider_items = $('.utilities li');
  if($slider_items.length<=4){
    $('.bx-controls.bx-has-controls-direction').hide();
  }

  if ($('.lt-ie9').length) { // browser is less than ie9
    sectionChildren();
    applyTableStripes();
    lastChildStyles();
    thumbnailFix();
  }

});

// equalheights should run a little later, to account for wysiwyg images in webkit
$(window).load(function() {

  var largescreen = checkScreenSize();
  setEqualHeights(largescreen);
  if(typeof window.orientation !== 'undefined') {
    window.addEventListener('orientationchange', updateOrientation, false);
  }
});

// assign functions to run on window resize. do this carefully.
$(window).resize(function() {
  var largescreen = checkScreenSize();
  if ($('.lt-ie8').length) {
    justifyNav(largescreen);
  }
  setEqualHeights(largescreen);
});


//Accordion rewrite
$(document).ready(function () {

  function hideAll(keepExpanded){
    //console.log('hide');
    if(keepExpanded === false){
      $('.accordion-body.collapse.expanded').removeClass('expanded');
      $('h2.accordion-heading a span.expanded').removeClass('expanded');
    }

    $('.accordion-body.in.collapse').not('.expanded').removeClass('in');
    //reset up/down arrow .accordion-heading h2 a span
    $('h2.accordion-heading a span.icon-rotate-90').not('.expanded').removeClass('icon-rotate-90');
  }

  //Hide all accordions on load (default is to show all)
  var keepExpanded = true;
  hideAll(keepExpanded);

  //adding to native accordion functionality, but allowing users to show/hide all at once

  $('.accordion-heading a').click(function(){
    $(this).parent().next().toggleClass('in');
    $(this).find('.icon-angle-right').toggleClass('icon-rotate-90');
  });


  $('#expandAll').click(function(){
    //console.log('show');
    $('.accordion-body.collapse').addClass('in');
    //reset up/down arrow .accordion-heading h2 a span
    $('h2.accordion-heading a span').addClass('icon-rotate-90');
  });

  $('#hideAll').click(function(){
    //Remove default expanded class, too
    keepExpanded = false;
    hideAll(keepExpanded);
  });

});
