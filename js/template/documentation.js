/* searchOptions
 * Allows for search type picker across site
______________________________________________________________________________ */
function searchOptionsDocs() {
    var value = '';
    $('.search-scope').hide();
    $('#form-search input').focus(function() {
        $('.search-scope').show();
        $(document).bind('focusin.search-scope click.search-scope',function(e) {
            if ($(e.target).closest('.search-scope, #form-search input').length) return;
            $(document).unbind('.search-scope');
            $('.search-scope').hide();
        });
    });
    $('.search-scope label').change(function(){
        $('.search-scope label').removeClass('checked');
        $(this).addClass('checked');
        value = $(this).children('input[name="site"]').val();
        if (value == 'directory') {
            document.searchForm.action = 'http://directory.service.emory.edu';
            document.searchForm.method = 'post';
        } else {
            document.searchForm.action = 'http://search.emory.edu/search';
            document.searchForm.method = 'get';
        }
    });
    $('#form-search').submit(function() {
        document.searchForm.searchString.value = document.searchForm.q.value;
        document.searchForm.submit();
        return false;
    });
}

/* Document load and window resize
______________________________________________________________________________ */

// assign functions to run when the page loads. do this carefully.
$(document).ready(function() {
    searchOptionsDocs();
});