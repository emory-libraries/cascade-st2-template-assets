function urlencode(str) {
    str = (str + '').toString();
  //return encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28').replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+');
  return encodeURIComponent(encodeURIComponent(str));
}

function removeParameter(url, parameter) {
  var fragment = url.split('#');
  var urlparts= fragment[0].split('?');

  if (urlparts.length>=2) {
    var urlBase=urlparts.shift(); //get first part, and remove from array
    var queryString=urlparts.join("?"); //join it back up

    var prefix = encodeURIComponent(parameter)+'=';
    var pars = queryString.split(/[&;]/g);
    for (var i= pars.length; i-->0;) {               //reverse iteration as may be destructive
      if (pars[i].lastIndexOf(prefix, 0)!==-1) {   //idiom for string.startsWith
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
    var query = url.indexOf('?');
    var anchor = url.indexOf('#');
    if (query == url.length - 1) {
        // Strip any ? on the end of the URL
        url = url.substring(0, query);
        query = -1;
    }
    return (anchor > 0 ? url.substring(0, anchor) : url)
         + (query > 0 ? "&" + key + "=" + value : "?" + key + "=" + value)
         + (anchor > 0 ? url.substring(anchor) : "");
}

function loadPageVar(key, url) {
    if (typeof url === 'undefined') {
        return unescape(window.location.search.replace(new RegExp("^(?:.*[&\\?]" + escape(key).replace(/[\.\+\*]/g, "\\$&") + "(?:\\=([^&]*))?)?.*$", "i"), "$1"));
    } else {
        var getLocation = function(href) {
            var l = document.createElement("a");
            l.href = href;
            return l;
        };
        var parsed_url = getLocation(url);
        return unescape(parsed_url.search.replace(new RegExp("^(?:.*[&\\?]" + escape(key).replace(/[\.\+\*]/g, "\\$&") + "(?:\\=([^&]*))?)?.*$", "i"), "$1"));
    }
}

function searchClear() {
    $('#main-content input[type="search"]').after('<span class="fa fa-remove">x</span>');
    if ($('#main-content input[type="search"]').val().length > 1) {
        field = $('#main-content input[type="search"]');
        var io = $(field).val().length ? 1 : 0 ;
        $(field).next('.fa-remove').stop().fadeTo(200,io);
    }
}

// on load
$(function() {
    // prepare the form
    searchClear();

    // handle search field typing
    $(document).on('propertychange keyup input paste', '#main-content input[type="search"]', function() {
        var io = $(this).val().length ? 1 : 0 ;
        $(this).next('.fa-remove').stop().fadeTo(200,io);
    });

    // handle search field clear
    $(document).on('click', '.fa-remove', function(event) {
        $(this).delay(200).fadeTo(200,0).prev('input').val('');
        $(this).parents('form').submit();
    });

});
