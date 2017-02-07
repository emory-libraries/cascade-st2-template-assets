<?php

class DatabaseResults {

    // set variable defaults. these values come from Cascade data definition.
    public $site;
    public $api_root;
    public $show_selections_body;
    public $use_autosuggest;
    public $show_featured;
    public $featured_title;
    public $show_new;
    public $new_title;
    public $use_summary;
    public $show_status;
    public $use_database_pages;
    public $get_all_results;
    public $num;
    public $use_cache;
    public $cache_time;

    // these come from the filters on the url
    public $subject = ''; // these are the sidebar filters
    public $resource_type = '';
    public $letter = '';
    public $status = '';
    public $items = array(); // we fill this in with the selected criteria

    // these come from search criteria, pagination, etc. values on url
    public $q = ''; // search term
    public $new_query = ''; // search term if there has been a misspelling that google wants to correct
    public $start = ''; // starting position (zero based)
    public $local_start = ''; // starting position if we are paginating locally (zero based)
    public $sort = ''; // sort method (we use default GSA method)
    
    public $numgm = 0; // how many related results to return
    public $btnG = ''; // we don't use this
    public $filter = 0; // do not allow google to filter things it thinks are redundant - get everything
    public $getfields = ''; // metafields that we need
    public $requiredfields = ''; // meta items to require
    public $partialfields = ''; // meta items to partially require
    public $format = 'xml'; // format for api return

    // we create these based on the search criteria
    public $featured_results = ''; // is it featured, new, or all?
    public $new_results = '';
    public $results = '';

    public $is_paged = false; // are the results paginated, seach results, or filtered?
    public $results_paged = true; // do the results need pagination?
    public $is_search_page = false;
    public $is_filter_page = false;

    public $debug = false; // are we in debug mode?
    public $beta = false; // are we in beta mode?
    public $link_checker = false; // are we checking for broken links?

    function __construct($site, $api_root, $show_selections_body, $use_autosuggest, $show_featured, $featured_title, $show_new, $new_title, $use_summary, $show_status, $show_fulltext, $show_coverage, $show_subjects, $use_database_pages = false, $get_all_results = true, $num = 25, $use_cache = false, $cache_time = 3600) {
        $this->site = $site; // option values from cascade
        $this->api_root = $api_root;
        $this->show_selections_body = $show_selections_body;
        $this->use_autosuggest = $use_autosuggest;
        $this->show_featured = $show_featured;
        $this->featured_title = $featured_title;
        $this->show_new = $show_new;
        $this->new_title = $new_title;
        $this->use_summary = $use_summary;
        $this->show_status = $show_status;
        $this->show_fulltext = $show_fulltext;
        $this->show_coverage = $show_coverage;
        $this->show_subjects = $show_subjects;
        $this->use_database_pages = $use_database_pages;
        $this->get_all_results = $get_all_results;
        $this->num = $num;
        $this->use_cache = $use_cache;
        $this->cache_time = $cache_time;
        $this->autocomplete = true;

        // minimum criteria for our needs
        $this->getfields = '*'; // gsa is able to see all metafields
        $this->requiredfields = 'content_type:'.urlencode(urlencode('database')); // we require at least this field for databases
        $this->partialfields .= 'include_in:'.str_replace('library-databases-','',$this->site); // make sure we load databases that we should. remove dashes because gsa doesn't like them
        $this->requiredfields .= '.-exclude_from:'.urlencode(urlencode($this->site)); // make sure we don't load databases that we should exclude

    // use json for results if server supports it
    if (!isset($_GET['format']) && $this->doesSupport('json') || isset($_GET['format']) && $_GET['format'] == 'json') {
            $this->format = 'json';
        } else {
            $this->format = 'xml';
        }

        if ($this->cache_time == '') {
            $this->cache_time = 3600;
        }

        // what kind of query is this       
        $this->is_search_page = $this->isSearchQuery();

        if ($this->is_search_page == true) { // if this is a search, we don't need to get all the results and then sort them
            $this->get_all_results = false;
        }

        $this->is_paged = $this->isPagedQuery();
        $this->is_filter_page = $this->isFilterQuery();

        if ($this->is_paged == false && $this->is_filter_page == false && $this->is_search_page == false) {
            foreach ($_GET as $key => $value) {
                if ($this->doesSupport('filter')) {
                    $value = filter_var(urlencode($value), FILTER_SANITIZE_STRING); // make the values secure
                } else {
                    $value = urlencode($value);
                }
                switch($key) { // and make them available to the entire class
                    case 'num':
                        $this->num = $value;
                        break;
                    case 'numgm':
                        $this->numgm = $value;
                        break;
                    case 'format':
                        $this->format = $value;
                        break;
                }
            }
        }

        // if debug is here, use it
        if (isset($_GET['debug'])) {
            $this->debug = true;
        }

        // if beta is here, use it
        if (isset($_GET['beta'])) {
            $this->beta = true;
            $this->show_coverage = true;
        }

        // if link_checker is here, use it
        if (isset($_GET['link_checker'])) {
            $this->link_checker = true;
        }

        // start rendering things on the page
        $this->searchForm(); // search form

        echo '<div class="databases">';
        if ($this->show_featured == true && $this->is_search_page == false && $this->is_paged == false && $this->status !== 'Featured') { // get and display featured results. status=featured means we only display featured, so we don't need this query
            $this->getSearchResults(true, false);
            $this->displaySearchResults($this->featured_results, $this->featured_title, true, false, false);
        }

        if ($this->show_new == true && $this->is_search_page == false && $this->is_paged == false && $this->status != 'New') { // get and display new results. status=new means we only display new, so we don't need this query
            $this->getSearchResults(false, true);
            $this->displaySearchResults($this->new_results, $this->new_title, false, true, false);
        }

        $this->getSearchResults(); // get and display default results. if we are using new, trial, or featured *only* it will end up using this query.
        $this->displaySearchResults($this->results);

        echo '</div>';

        if (isset($this->results['M']) && $this->results['M'] <= $this->num) {
            $this->results_paged = false;
        }

        // if this is a results page, do some pagination
        if (isset($this->results['M']) && $this->results_paged == true) {
        $this->pagination(); // pagination links and info
    }

    }

    // is this a paginated page?
    public function isPagedQuery() {
        if (isset($_GET['start']) && $_GET['start'] != '' || isset($_GET['sort']) && $_GET['sort'] != '') {
            foreach ($_GET as $key => $value) {
                if ($this->doesSupport('filter')) {
                    $value = filter_var(urlencode($value), FILTER_SANITIZE_STRING); // make the values secure
                } else {
                    $value = urlencode($value);
                }
                if ($this->get_all_results == true) {
                    switch($key) { // and make them available to the entire class
                        case 'q':
                            $this->q = $value;
                            break;
                        case 'db_q':
                            $this->q = $value;
                            break;
                        case 'start':
                            $this->local_start = $value;
                            break;
                        case 'sort':
                            $this->sort = $value;
                            break;
                        case 'num':
                            $this->num = $value;
                            break;
                        case 'numgm':
                            $this->numgm = $value;
                            break;
                        case 'format':
                            $this->format = $value;
                            break;
                    }
                } else {
                    switch($key) { // and make them available to the entire class
                        case 'q':
                            $this->q = $value;
                            break;
                        case 'db_q':
                            $this->q = $value;
                            break;
                        case 'start':
                            $this->start = $value;
                            break;
                        case 'sort':
                            $this->sort = $value;
                            break;
                        case 'num':
                            $this->num = $value;
                            break;
                        case 'numgm':
                            $this->numgm = $value;
                            break;
                        case 'format':
                            $this->format = $value;
                            break;
                    }
                }
            }
            return true;
        } else {
            return false;
        }
    }

    // is this a filter result page?
    public function isFilterQuery() {
        if (isset($_GET['subject']) && $_GET['subject'] !== '' || isset($_GET['resource_type']) && $_GET['resource_type'] !== '' || isset($_GET['letter']) && $_GET['letter'] !== '' || isset($_GET['status']) && $_GET['status'] !== '' ) {

            foreach ($_GET as $key => $value) {
                if ($this->doesSupport('filter')) {
                    $value = filter_var(urlencode($value), FILTER_SANITIZE_STRING); // secure variables
                } else {
                    $value = urlencode($value);
                }
                switch($key) { // make them available to the entire class
                    case 'q':
                        $this->q = $value;
                        break;
                    case 'db_q':
                        $this->q = $value;
                        break;
                    case 'subject':
                        if ( strpos ( urldecode($value), '.') !== false) {
                            $values = explode('.', $value);
                            $this->subject = $values;
                        } else {
                            $this->subject = ucfirst($value);
                        }                       
                        break;
                    case 'resource_type':
                        if ( strpos ( urldecode($value), '.') !== false) {
                            $values = explode('.', $value);
                            $this->resource_type = $values;
                        } else {
                            $this->resource_type = ucfirst($value);
                        } 
                        break;
                    case 'letter':
                        if ( strpos ( urldecode($value), '.') !== false) {
                            $values = explode('.', $value);
                            $this->letter = $values;
                        } else {
                            $this->letter = ucfirst($value);
                        } 
                        break;
                    case 'status':
                        if ( strpos ( urldecode($value), '.') !== false) {
                            $values = explode('.', $value);
                            $this->status = $values;
                        } else {
                            $this->status = ucfirst($value);
                        }
                        break;
                    case 'num':
                        $this->num = $value;
                        break;
                    case 'numgm':
                        $this->numgm = $value;
                        break;
                    case 'format':
                        $this->format = $value;
                        break;
                }
            }
            return true;
        } else {
            return false;
        }
    }

    // is this a search result page?
    public function isSearchQuery() {
        if (isset($_GET['q']) && $_GET['q'] != '' || isset($_GET['db_q']) && $_GET['db_q'] != '' ) {
            foreach ($_GET as $key => $value) {
                if ($this->doesSupport('filter')) {
                    $value = filter_var(urlencode($value), FILTER_SANITIZE_STRING); // secure variables
                } else {
                    $value = urlencode($value);
                }
                switch($key) { // available to the entire class
                    case 'q':
                        $this->q = $value;
                        break;
                    case 'db_q':
                        $this->q = $value;
                        break;
                    case 'num':
                        $this->num = $value;
                        break;
                    case 'numgm':
                        $this->numgm = $value;
                        break;
                    case 'format':
                        $this->format = $value;
                        break;
                }
            }
            return true;
        } else {
            return false;
        }
    }

    // search form
    public function searchForm() {
        $hidden_fields = array('subject' => $this->subject, 'resource_type' => $this->resource_type, 'letter' => $this->letter, 'status' => $this->status);
        if ($this->format == 'json' && $this->autocomplete === true) {
            $url = htmlspecialchars($this->getQueryURL(false));
            if (isset($this->debug) && $this->debug === true) {
                echo '<div class="alert alert-info"><h4>Debug</h4><small>Form submit url is <a href="'.$url.'">'.$url.'</a></small></div>';
            }
            $typeahead_class = '';
            if ($this->use_autosuggest == true) {
                $typeahead_class = ' ajax-typeahead';
            }
            $formparams = 'class="input span10'.$typeahead_class.'" autocomplete="off" data-url="'.$url.'&amp;format=json"';
        } else {
          $formparams = 'class="input span10"';
        }
        echo '<div class="big-search database-search">
                        <form action="?" id="database-search" class="clearfix" method="get" name="databaseSearchForm">';
                            foreach ($hidden_fields as $key => $value) { // preserve the current url querystrings in hidden form fields
                                if ($value != '' && !is_array($value)) {
                                    //$value = $this->titleCase(urldecode(urldecode($value)));
                                    echo '<input type="hidden" id="db_'.$key.'" name="'.$key.'" value="'.$value.'" />';
                                } else if ($value != '') {
                                    $newvalues = array();
                                    foreach ($value as $newvalue) {
                                        //$newvalues[] = $this->titleCase(urldecode(urldecode($newvalue)));
                                        $newvalues[] = $newvalue;
                                    }
                                    $value = implode('.', $newvalues);
                                    echo '<input type="hidden" id="db_'.$key.'" name="'.$key.'" value="'.$value.'" />';
                                }
                            }
                            echo '<div class="input-append span12">                                    
                                <input '.$formparams.' id="db_q" name="db_q" placeholder="'.$this->placeholderValue().'"'.$this->formValue().' type="search"/>                                    
                        <button class="btn btn-search" type="submit"> <strong class="label">Search</strong>
                            <span class="icon-search"></span>
                        </button>
                    </div>
                </form>';

                // by subject
                if ($this->subject != '') {
                    if (!is_array($this->subject)) {
                        $title = 'All '.$this->titleCase(urldecode(urldecode($this->subject))).' Databases';
                        if ($this->show_selections_body !== true && $this->resource_type !== '' || $this->show_selections_body !== true && $this->letter !== '' || $this->show_selections_body !== true && $this->status !== '') {
                            $title = 'Database Results for Your Selections';
                        } else if (is_array($this->items) && $this->show_selections_body == true) {
                            $this->items[] = '<li class="subject"><a href="'.$url.'" title="Remove this filter" class="remove"><span>'.$this->titleCase(urldecode(urldecode($this->subject))).'</span> <span class="icon-remove-sign"></span></a></li>';
                        }
                    } else {
                        foreach ($this->subject as $value) {
                            $replace = array('.'.$value, $value.'.', $value);
                            $url = str_replace($replace, '', $url);
                            if ($this->show_selections_body !== true) {
                                $title = 'Database Results for Your Selections';
                            } else if (is_array($this->items) && $this->show_selections_body == true) {
                                $this->items[] = '<li class="subject"><a href="'.$url.'" title="Remove this filter" class="remove"><span>'.$this->titleCase(urldecode(urldecode($value))).'</span> <span class="icon-remove-sign"></span></a></li>';
                            }
                        }               
                    }
                }

                // by resource type
                if ($this->resource_type != '') {
                    if (!is_array($this->resource_type)) {
                        $title = 'All '.$this->titleCase(urldecode(urldecode($this->resource_type))).' Databases';
                        if ($this->show_selections_body !== true && $this->subject !== '' || $this->show_selections_body !== true && $this->letter !== '' || $this->show_selections_body !== true && $this->status !== '') {
                            $title = 'Database Results for Your Selections';
                        } else if (isset($this->items) && $this->show_selections_body == true) {
                            $this->items[] = '<li class="resource_type"><a href="'.$url.'" title="Remove this filter" class="remove"><span>'.$this->titleCase(urldecode(urldecode($this->resource_type))).'</span> <span class="icon-remove-sign"></span></a></li>';
                        }
                    } else {
                        foreach ($this->resource_type as $value) {
                            $replace = array('.'.$value, $value.'.', $value);
                            $url = str_replace($replace, '', $url);
                            if ($this->show_selections_body !== true) {
                                $title = 'Database Results for Your Selections';
                            } else if (is_array($this->items) && $this->show_selections_body == true) {
                                $this->items[] = '<li class="resource_type"><a href="'.$url.'" title="Remove this filter" class="remove"><span>'.$this->titleCase(urldecode(urldecode($value))).'</span> <span class="icon-remove-sign"></span></a></li>';
                            }
                        }                       
                    }
                } 

                // by letter
                if ($this->letter != '') {
                    if (!is_array($this->letter)) {
                        $title = 'All '.$this->titleCase(urldecode(urldecode($this->letter))).' Databases';
                        if ($this->show_selections_body !== true && $this->subject !== '' || $this->show_selections_body !== true && $this->resource_type !== '' || $this->show_selections_body !== true && $this->status !== '') {
                            $title = 'Database Results for Your Selections';
                        } else if (is_array($this->items) && $this->show_selections_body == true) {
                            $this->items[] = '<li class="letter"><a href="'.$url.'" title="Remove this filter" class="remove"><span>'.$this->titleCase(urldecode(urldecode($this->letter))).'</span> <span class="icon-remove-sign"></span></a></li>';
                        }
                    } else {
                        foreach ($this->letter as $value) {
                            $replace = array('.'.$value, $value.'.', $value);
                            $url = str_replace($replace, '', $url);
                            if ($this->show_selections_body !== true) {
                                $title = 'Database Results for Your Selections';
                            } else if (is_array($this->items) && $this->show_selections_body == true) {
                                $this->items[] = '<li class="letter"><a href="'.$url.'" title="Remove this filter" class="remove"><span>'.$this->titleCase(urldecode(urldecode($value))).'</span> <span class="icon-remove-sign"></span></a></li>';
                            }
                        }                       
                    }
                } 

                // by status
                if ($this->status != '') {
                    if (!is_array($this->status)) {
                        $title = 'All '.$this->titleCase(urldecode(urldecode($this->status))).' Databases';
                        if ($this->show_selections_body !== true || $this->show_selections_body !== true && $this->subject !== '' || $this->show_selections_body !== true && $this->resource_type !== '' || $this->show_selections_body !== true && $this->letter !== '') {
                            $title = 'Database Results for Your Selections';
                        } else if (is_array($this->items) && $this->show_selections_body == true) {
                            $this->items[] = '<li class="status"><a href="'.$url.'" title="Remove this filter" class="remove"><span>'.$this->titleCase(urldecode(urldecode($this->status))).'</span> <span class="icon-remove-sign"></span></a></li>';
                        }
                    } else {
                        foreach ($this->status as $value) {
                            $replace = array('.'.$value, $value.'.', $value);
                            $url = str_replace($replace, '', $url);
                            if ($this->show_selections_body !== true) {
                                $title = 'Database Results for Your Selections';
                            } else if (is_array($this->items) && $this->show_selections_body == true) {
                                $this->items[] = '<li class="status"><a href="'.$url.'" title="Remove this filter" class="remove"><span>'.$this->titleCase(urldecode(urldecode($value))).'</span> <span class="icon-remove-sign"></span></a></li>';
                            }
                        }                   
                    }
                }
                if (!empty($this->items) && $this->show_selections_body == true) {
                    $this->items = implode('', $this->items);
                    $selections = '<ul class="filter-list inline well well-small clearfix"><li><strong>Your selections:</strong></li>'.$this->items.'</ul>';
                }
                if (isset($selections)) { echo $selections; };
                
            echo '</div>';
            
    }

    // get results from the api. can return featured resultset, new resultset, trial resultset, and the default resultset for whatever criteria
    public function getSearchResults($featured_only = false, $new_only = false, $trial_only = false, $new_query = '') {

        if ($this->status == 'Featured') {
            $featured_only = true;
        } // we need this because status=feature isn't specific enough. we use featured_in ....

        // get the url for the api call - tell it everything we know up to this point
        if ($new_query == '') {
            $url = $this->getQueryURL(true, $new_query, $featured_only, $new_only, $trial_only);
        } else {
            $url = $this->getQueryURL(false, $new_query, $featured_only, $new_only, $trial_only);
        }

        // set format for api result
        $url .= '&format='.$this->format;

        // we can check all the links, maybe
        if (isset($this->link_checker) && $this->link_checker === true) {
            $this->results = $this->load_file($url, $this->format);
            if (isset($this->results['RES']['R'])) {
                $this->results = $this->results;
            }
            $this->linkChecker($this->results['RES']['R']);
        }

        // make the api call and store the results
        if ($this->get_all_results == true) {
            if (!isset($this->local_start) || $this->local_start == 0) {
                $start = 0;
            } else {
                $start = $this->local_start;
            }
            if ($featured_only == true && $new_only == false) {
                $this->featured_results = $this->load_file($url, $this->format);
                if (isset($this->featured_results['RES']['R'])) {
                    $this->featured_results['RES']['R'] = array_slice($this->featured_results['RES']['R'], $start, $this->num);
                    $this->featured_results = array_slice($this->featured_results, $start, $this->num);
                }
            } else if ($new_only == true && $featured_only == false) {
                $this->new_results = $this->load_file($url, $this->format);
                if (isset($this->new_results['RES']['R'])) {
                    $this->new_results['RES']['R'] = array_slice($this->new_results['RES']['R'], $start, $this->num);
                    $this->new_results = array_slice($this->new_results, $start, $this->num);
                }
            } else {
                $this->results = $this->load_file($url, $this->format);
                if (isset($this->results['RES']['R'])) {
                    $this->results['RES']['R'] = array_slice($this->results['RES']['R'], $start, $this->num);
                    $this->results = $this->results;
                }
            }
        } else {
            if ($featured_only == true && $new_only == false) {
                $this->featured_results = $this->load_file($url, $this->format);    
            } else if ($new_only == true && $featured_only == false) {
                $this->new_results = $this->load_file($url, $this->format); 
            } else {
                $this->results = $this->load_file($url, $this->format); 
            }
        }

        // print the api url if this is a debug query
        if (isset($this->debug) && $this->debug === true) {
            echo '<div class="alert alert-info"><h4>Debug</h4><small>API query url is <a href="'.$url.'">'.$url.'</a></small></div>';
        }

        return $this->results;
        
    }

    // take the results and display them according to the configuration
    public function displaySearchResults($results, $results_title = '', $featured = false, $new = false, $trial = false, $misspelled = false) {
        // set values for range display
        if ($this->get_all_results == true) {
            if (isset($results['M'])) {
                if ($this->local_start <= $results['M']) {
                    $begin = $this->local_start + 1;
                } else {
                    $begin = $results['M'];
                }
                if ($this->num >= $results['M'] || $this->local_start + $this->num >= $results['M']) {
                    $end = $results['M'];
                } else {
                    $end = $this->local_start + $this->num;
                }
            }
        } else {
            if (isset($results['M'])) {
                if ($this->start <= $results['M']) {
                    $begin = $this->start + 1;
                } else {
                    $begin = $results['M'];
                }
                if ($this->num >= $results['M'] || $this->start + $this->num >= $results['M']) {
                    $end = $results['M'];
                } else {
                    $end = $this->start + $this->num;
                }
            }
        }

        $url = $_SERVER['REQUEST_URI']; // the current server url to preserve what is being viewed

        // if there are results, display the count info
        if ($this->is_search_page == true) {
            $term = urldecode(urldecode($this->q));
            if (isset($results['M'])) {
                if ($results_title == '') {
                    $title = 'Results '.number_format($begin).' - '.number_format($end).' of '.number_format($results['M']).' for <strong>'.$term.'</strong>';
                } else if ($misspelled == true) {
                    $title = $results_title;
                    /*$url = $this->parseQueryString($url,'db_q');
                    $has_params = parse_url($url, PHP_URL_QUERY);

                    if ($has_params != true) {
                        $query_delimitor = '?';
                    } else {
                        $query_delimitor = '&amp;';
                    }
                    $url = $url.$query_delimitor.'db_q='.$this->q;
                    $instead = 'Search instead for <a href="'.$url.'"><strong><em>'.$this->q.'</em></strong></a>';
                    removed this bc not sure how to force it */
                } else {
                    $title = $results_title;
                }
            } else if (isset($results['Spelling'])) {
                $fresh_query = strip_tags($results['Spelling']['Suggestion']);
                // need to treat the suggested query like a regular query or GSA doesn't like it.
                if ($this->doesSupport('filter')) {
                    $this->new_query = filter_var(urlencode($fresh_query), FILTER_SANITIZE_STRING); // secure variables
                } else {
                    $this->new_query = urlencode($fresh_query);
                }
                $title = 'Showing results for <strong><em>'.$fresh_query.'</em></strong>';

                $results = $this->getSearchResults(false, false, false, $this->new_query);
                $this->displaySearchResults($results, $title, false, false, false, true);
                return;
            } else {
                $title = 'No results for <strong>'.$term.'</strong>';
            }
        } else {
            // is this a featured, new, or trial resultset or a default
            if ($featured == true) {
                $title = $this->featured_title;
            } else if ($new == true) {
                $title = $this->new_title;
            } else if ($trial == true) {
                $title = 'Trial Only Databases';
            } else {
                // we are filtering by status
                if (isset($results['M'])) {
                    $subtitle = 'Results '.number_format($begin).' - '.number_format($end).' of '.number_format($results['M']);
                }

                if ($this->subject === '' && $this->resource_type === '' && $this->letter === '' && $this->status === '') {
                    $title = 'All Databases';
                }

                if (!empty($this->items) && $this->show_selections_body == true) {
                    $title = 'Database Results for Your Selections';
                }

                if (!isset($results['M'])) {
                    $title = 'No results';
                }
            }
        }
        // only display "no results" if this is the default listing or default filter listing. not for "new" or "trial"
        if (isset($results['M']) || isset($results['M']) && $this->is_search_page != false || isset($results['M']) && $this->is_paged != false) { // we have results, or this is a search page with results, or this is a paginated page
            $start = $this->start + 1;
            $status = 'default-databases ';
            if ($featured == 1) {
                $status = 'featured-databases ';
            }
            if ($new == 1) {
                $status = 'new-databases ';
            }
            if ($trial == 1) {
                $status = 'trial-databases ';
            }
            // for beta
            if ($this->beta === true) {
                $this->use_summary = true;
            }
            // wrap the results and send them to be displayed
            echo '<section class="'.$status.'database-results clearfix">
                <h2>'.$title.'</h2>';
                if (isset($this->debug) && $this->debug === true) {
                    $cached = 'no';
                    if ($this->use_cache == 1) {
                        if ($results['cached_data'] == 1) {
                            $cached = 'yes';
                        }
                    }
                    if (isset($results['M'])) {
                        $count = $results['M'];
                    } else {
                        $count = 0;
                    }
                    echo '<ul>
                        <li>Are we getting all the results? '.$this->get_all_results.'</li>
                        <li>How many results are there? '.$count.'</li>
                        <li>What number do we want to start at? '.$begin.'</li>
                        <li>How many results should be on this page? '.$this->num.'</li>
                        <li>What is the end number? '.$end.'</li>
                        <li>Are the results being cached? '.$cached.'</li>
                    </ul>';
                }
                if (isset($subtitle)) { echo '<h4 class="result-range">'.$subtitle.'</h4>'; };
                if (isset($instead)) { echo '<h4 class="instead">'.$instead.'</h4>'; };
                if ($this->use_summary === true) { $list_class = ' summaries'; } else { $list_class = ''; }
                echo '<ol class="listings'.$list_class.'" start="'.$start.'">';
                    if ($results['RES']['M'] == 1) { // if there is only one result
                        $this->databaseEntry($results['RES']['R'], $status, 0);
                    } else {
                        if ($this->format == 'json') {
                            foreach ($results['RES']['R'] as $key => $database) {
                                $this->databaseEntry($database, $status, $key);
                            }
                        } else {
                            foreach ($results['RES']['R']['item'] as $database) {
                                $this->databaseEntry($database, $status, $key);
                            }
                        }
                    }
                echo '</ol>
        </section>';
        } else if (isset($results['Spelling'])) { // google has returned a spelling suggestion to us
            $status = 'no-results ';
            echo '<section class="'.$status.'database-results clearfix">
                <h2>'.$title.'</h2>';
                echo '<p>There are no results for this selection.</p>';
            echo '</section>';
        } else if (isset($results['error']) && isset($results['error_code']) && $featured != true && $new != true && $trial != true) {
            $status = 'no-results ';
            echo '<section class="'.$status.'database-results clearfix">';
                echo '<h2>Databases at Emory is under repair.</h2><p>You can find databases via the Catalog Tab in <a href="http://discovere.emory.edu/">DiscoverE</a>.</p>';
            echo '</section>';
        } else if (isset($results['error']) && $featured != true && $new != true && $trial != true || !isset($results['M']) && $featured != true && $new != true && $trial != true) {
            // if there is an error and this is not featured, new, or trial set display the error message
            $status = 'no-results ';
            echo '<section class="'.$status.'database-results clearfix">
                <h2>'.$title.'</h2>';
                echo '<p>There are no results for this selection.</p>';
            echo '</section>';
        }
    }

    // render each database entry
    public function databaseEntry($database, $status, $key) {
        // get the metadata fields from gsa. this is formatted differently for xml and json
        $link = $database['U'];
        $subjects_alone = '';
        $subjects = '';
        $fulltext = '';
        $coverage_alone = '';
        $coverage = '';
        $friendly_status = '';
        $alert = '';
        $alert_type = '';
        $render_description = '';
        $full_description = '';
        $expand = '';
        if ($this->format == 'json') {
            foreach ($database['MT'] as $metaset) {
                foreach ($metaset as $attributes) {
                    if ($this->use_database_pages != true && $attributes['N'] == 'external_link') {
                        $link = $attributes['V'];
                    }
                    if ($attributes['N'] == 'full_title') {
                        $full_title = $attributes['V'];
                    }
                    if ($attributes['N'] == 'alert') {
                        $alert = $attributes['V'];
                    }
                    if ($attributes['N'] == 'alert_type') {
                        $alert_type = 'alert-'.strtolower($attributes['V']);
                    }

                    if ($this->show_coverage == true && $attributes['N'] == 'coverage' && $this->use_summary !== true) {
                        $coverage_alone = '<p class="muted meta">Coverage: '.$attributes['V'].'</p>';
                    } else if ($this->show_coverage == true && $attributes['N'] == 'coverage') {
                        $coverage = '<li><strong>Coverage:</strong> '.$attributes['V'].'</li>';
                    }

                    if ($this->show_fulltext == true && $attributes['N'] == 'fulltext') {
                        $fulltext = '<li><strong>Full Text:</strong> '.$attributes['V'].'</li>';
                    }

                    if ($this->show_status === true && $attributes['N'] == 'status' && $this->use_summary == true) {
                        if ($attributes['V'] == 'trial') {
                            $badge_class = 'badge-warning';
                        } else if ($attributes['V'] == 'new') {
                            $badge_class = 'badge-info';
                        }
                        $friendly_status = '<li><span class="badge '.$badge_class.'">'.ucfirst($attributes['V']).'</span></li>';
                    }

                    if ($attributes['N'] == 'full_description') {
                        $full_description = $attributes['V'];
                    }
                    if ($this->site === 'library-databases-health') {
                        if (isset($attributes['N']) && $attributes['N'] == 'whsc_full_description') {
                            if ($attributes['N'] == 'whsc_full_description' && $attributes['V'] !== '') {
                                $full_description = $attributes['V'];
                            }
                        }
                    }
                    if ($this->site === 'library-databases-business') {
                        if (isset($attributes['N']) && $attributes['N'] == 'gbl_full_description') {
                            if ($attributes['N'] == 'gbl_full_description' && $attributes['V'] !== '') {
                                $full_description = $attributes['V'];
                            }
                        }
                    }
                    if ($this->show_subjects == true && $attributes['N'] == 'subject' && $this->use_summary !== true) {
                        $subjectlist = explode(', ', $attributes['V']);
                        $subjects_alone .= '<p class="muted subjects"><strong>Subjects:</strong> '.$attributes['V'].'</p>';
                    } else if ($this->show_subjects == true && $attributes['N'] == 'subject') {
                        $subjectlist = explode(', ', $attributes['V']);
                        $subjects .= '<p class="muted subjects"><strong>Subjects:</strong> '.$attributes['V'].'</p>';
                    }
                }
            }
        } else {
            foreach ($database['MT']['item'] as $metaset) {
                foreach ($metaset as $attributes) {
                    if ($this->use_database_pages != true && $attributes['N'] == 'external_link') {
                        $link = $attributes['V'];
                    }
                    if ($attributes['N'] == 'full_title') {
                        $full_title = $attributes['V'];
                    }
                    if ($attributes['N'] == 'full_description') {
                        $full_description = $attributes['V'];
                    }
                }
            }
        }

        // bold stuff in the title based on whether this is search result page or not
        if ($this->is_search_page !== true) {
            $title = $full_title;
        } else {
            // bold keywords
            $title = $this->highlightkeyword($full_title, $this->q);
        }

        $render_title = $title;

        // set description based on search result page or not
        if ($this->use_summary === true && isset($full_description)) {
            $render_description = $this->excerpt($full_description, 160);
            $full_description = str_replace($render_description, '', $full_description);
        } else if ($this->is_search_page !== true && isset($full_description)) {
            $render_description = $full_description;
        } else if ($this->is_search_page === true && isset($full_description)) {
            $render_description = $this->excerpt($full_description, 160);
        } else {
            $render_description = $database['S'];
        }

        if ($this->is_search_page === true) {
            $render_description = $this->highlightkeyword($render_description, $this->q);
            $full_description = $this->highlightkeyword($full_description, $this->q);
        }

        if ($this->use_summary === true) {
            if (!isset($alert_type) || $alert_type == '') {
                $alert_type = 'alert-info';
            }
            $status = str_replace('-databases ', '', $status);
            if ($alert != '' || $full_description != '' || $friendly_status != '' || $coverage != '' || $subjects != '') {
                if (substr($full_description, 0, 3) != '<p>') {
                    $full_description = '<p>'.trim($full_description, chr(0xC2).chr(0xA0));
                }
                $expand .= '<div id="'.$status.'_'.$key.'" class="collapse database-details">';
                    if ($full_description !== $render_description) {
                        $expand .= '<div class="full_description">'.$full_description.'</div>';
                    }
                    if ($alert != '') {
                        $expand .= '<div class="alert '.$alert_type.'">'.$alert.'</div>';
                    }
                    if ($fulltext != '' || $coverage != '') {
                        $expand .= '<div class="meta well well-small"><ul class="inline">'.$fulltext.$coverage.$friendly_status.'</ul></div>';
                    }
                    if ($subjects != '') {
                        $expand .= $subjects;
                    }
                $expand .= '</div>';
                $expand .= '<a class="expand muted" data-target="#'.$status.'_'.$key.'" data-toggle="collapse" href="#">Expand <span class="icon-angle-down"></span></a>';
            }
        }

        if ($link !== 'none') {
            $render_title = '<a href="'.$link.'" rel="nofollow">'.$title.'</a>';
        // render title, link, and description
            if ($render_description == strip_tags($render_description)) {
                // no html tags
                $render_description = '<p>'.$render_description.'</p>';
            } else if ($this->use_summary === true) {
                $render_description = '<p>'.str_replace(array('<p>','</p>'), '', $render_description).'</p>';
            }
        } else {
            if ($render_description == strip_tags($render_description)) {
                // no html tags
                $render_description = '<p>'.$render_description.'</p>';
            } else if ($this->use_summary === true) {
                $render_description = '<p>'.str_replace(array('<p>','</p>'), '', $render_description).'</p>';
            }
        }
        echo '<li>
                <h3>'.$render_title.'</h3>'.
                    $coverage_alone.
                    $render_description.
                    $subjects_alone.
                    $expand.
             '</li>';
    }

    // display pagination
    public function pagination() {
      $total = $this->results['M'];
      if ($total >= 1000) {
        $total = 1000;
      }
      $pages = ceil($total / $this->num);
      if ($this->get_all_results == true) {
        $current_page = ceil($this->local_start / $this->num);
      } else {
        $current_page = ceil($this->start / $this->num);
      }
      $url = $_SERVER['REQUEST_URI']; // the current url to preserve what is being viewed

      if ($this->new_query !== '') {
        $url = str_replace('q='.$this->q, 'q='.$this->new_query, $url);
      }

      $url = $this->parseQueryString($url,'start');

      $has_params = parse_url($url, PHP_URL_QUERY);

      if ($has_params != true) {
        $query_delimitor = '?';
      } else {
        $query_delimitor = '&amp;';
      }

      if (!isset($this->results['error'])) {
          echo '<div class="pagination"><ul>';

              if ($current_page != 1 && $current_page != 0) {
                  // current page - 1 for previous
                  $query_string = $url.$query_delimitor.'start='.($current_page - 1) * $this->num;
                  echo '<li><a href="'.$query_string.'">Previous</a></li>';
              } else if ($current_page != 0) {
                  // current page - 1 for previous
                  $query_string = $url.$query_delimitor.'start=';
                  echo '<li><a href="'.$query_string.'">Previous</a></li>';
              }

              for ($i = 1; $i <= $pages; $i++) {
                  if ($i != 1) {
                      $query_string = $url.$query_delimitor.'start='.($i - 1) * $this->num;
                  } else {
                      $query_string = $url.$query_delimitor.'start=';
                  }

                  $show_link = true; // we are only going to show the right number of links                  

                  if ($pages > 10) { // we have more than 10 total pages
                      if ( ($i < $current_page && ($current_page - $i) > 4) || ($i > $current_page && ($i - $current_page) > 5) && $i - 9 > 1) {
                          $show_link = false;
                      }
                  } else { // there are 10 pages or less, total. show all of them in that case.
                      if ($i < 10) {
                          $show_link = true;
                      }
                  }

                  if ($show_link && $current_page < ($total / $this->num)) {
                      if ($i - 1 == $current_page) { // currently selected page
                          echo '<li class="active"><a href="'.$query_string.'">'.$i.'</a></li>';
                      } else { // all the other pages
                          echo '<li><a href="'.$query_string.'">'.$i.'</a></li>';
                      }
                  }
              }

              if ($this->get_all_results == true) {
                if ($current_page != $total && ($this->local_start + $this->num) < $total) {
                  // current page + 1 for next
                  $query_string = $url.$query_delimitor.'start='.($current_page + 1) * $this->num;
                  echo '<li><a href="'.$query_string.'">Next</a></li>';
                }
              } else {
                if ($current_page != $total && ($this->start + $this->num) < $total) {
                  // current page + 1 for next
                  $query_string = $url.$query_delimitor.'start='.($current_page + 1) * $this->num;
                  echo '<li><a href="'.$query_string.'">Next</a></li>';
                }
              }

          echo '</ul></div>';
      }
    }

    // construct a url for the API that we can re-use
    // important: depending on how it is being used, additional parameters may be added to this url in other functions
    private function getQueryURL($usequery = true, $newquery = '', $featured_only = false, $new_only = false, $trial_only = false) {
        $requiredfields = $this->requiredfields; // reset this value so it doesn't repeat itself
        $partialfields = $this->partialfields; // reset this value so it doesn't repeat itself
        $url = $this->api_root . 'gsa/results/?site='.$this->site; // add api url
        if ($usequery === true) { // is there a search value?
            $url = $url .= '&q='.urlencode($this->q); // encode once bc it came from the url
        } else if ($newquery != '') {
            $url = $url .= '&q='.urlencode($newquery); // encode once bc it came from the url
        }
        // add gsa fields to the api url
        if ($this->start !== '') {
            $url .= '&start='.$this->start;
        }
        if ($this->sort !== '') {
            $url .= '&sort='.$this->sort;
        }
        if ($this->get_all_results == true) {
            $url .= '&num=1000';
        } else if ($this->num !== '' && $this->get_all_results != true) {
            $url .= '&num='.$this->num;
        }
        if ($this->numgm !== '') {
            $url .= '&numgm='.$this->numgm;
        }
        if ($this->filter !== '') {
            $url .= '&filter=0';
        }
        if ($this->getfields !== '') {
            $url .= '&getfields='.$this->getfields;
        }

        // create requiredfields for gsa from the filter parameters

        // subject
        if ($this->subject != '' && !is_array($this->subject)) {
            if ($requiredfields != '') {
                $requiredfields .= '.';
            }
            //$requiredfields .= 'subject:'.urlencode(strtr($this->subject, array('%28' => '', '%29' => ''))); // encode once bc it came from the url
            $requiredfields .= 'subject:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $this->subject)))))); // match the regex from javascript and xslt
        } else if ($this->subject != '') {
            $newsubjects = array();
            foreach ($this->subject as $value) {
                //$newsubjects[] = 'subject:'.urlencode(strtr($value, array('%28' => '', '%29' => ''))); // encode once bc it came from the url
                $newsubjects[] = 'subject:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $value)))))); // match the regex from javascript and xslt
            }
            $subjects = implode('|', $newsubjects);
            if ($requiredfields != '') {
                $requiredfields .= '.';
            }
            $requiredfields .= '('.$subjects.')';
        }

        // resource type
        if ($this->resource_type != '' && !is_array($this->resource_type)) {
            if ($requiredfields != '') {
                $requiredfields .= '.';
            }
            //$requiredfields .= 'resource_type:'.urlencode($this->resource_type); // encode once bc it came from the url
            $requiredfields .= 'resource_type:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $this->resource_type)))))); // match the regex from javascript and xslt
        } else if ($this->resource_type != '') {
            $newtypes = array();
            foreach ($this->resource_type as $value) {
                //$newtypes[] = 'resource_type:'.urlencode($value); // encode once bc it came from the url
                $newtypes[] = 'resource_type:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $value)))))); // match the regex from javascript and xslt
            }
            $resource_types = implode('|', $newtypes);
            if ($requiredfields != '') {
                $requiredfields .= '.';
            }
            $requiredfields .= '('.$resource_types.')';
        }

        // letter
        if ($this->letter != '' && !is_array($this->letter)) {
            if ($requiredfields != '') {
                $requiredfields .= '.';
            }
            if ($this->letter == '0-9') {
                $requiredfields .= '(letter:1|letter:2|letter:3|letter:4|letter:5|letter:6|letter:7|letter:8|letter:9|letter:0)';
            } else {
           // $requiredfields .= 'letter:'.urlencode($this->letter); // encode once bc it came from the url
            $requiredfields .= 'letter:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $this->letter)))))); // match the regex from javascript and xslt
            }
        } else if ($this->letter != '') {
            $newletters = array();
            foreach ($this->letter as $value) {
                //$newletters[] = 'letter:'.urlencode($value); // encode once bc it came from the url
                $newletters[] = 'letter:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $value)))))); // match the regex from javascript and xslt
            }
            $letters = implode('|', $newletters);
            if ($requiredfields != '') {
                $requiredfields .= '.';
            }
            $requiredfields .= '('.$letters.')';
        }

        // status
        if ($this->status != '' && !is_array($this->status) && $this->status != 'Featured') { // don't do this if we are only getting featured databases and nothing else
            if ($requiredfields != '') {
                $requiredfields .= '.';
            }
            //$requiredfields .= 'status:'.urlencode($this->status); // encode once bc it came from the url
            $requiredfields .= 'status:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $this->status)))))); // match the regex from javascript and xslt
        } else if ($this->status != '' && $this->status != 'Featured') {
            $newstatuses = array();
            foreach ($this->status as $value) {
                //$newstatuses[] = 'status:'.urlencode($value); // encode once bc it came from the url
                $newstatuses[] = 'status:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $value)))))); // match the regex from javascript and xslt
            }
            $statuses = implode('|', $newstatuses);
            if ($requiredfields != '') {
                $requiredfields .= '.';
            }
            $requiredfields .= '('.$statuses.')';
        }

        // combine it all
        $url .= '&requiredfields='.$requiredfields;

        // extra fields if we only want featured, new, or trial results in this set. also start adding to partialfields here.
        $extra_requiredfields = '';
        $partialfields = $this->partialfields;

        if ($featured_only == true) {
            if ($this->subject != '') {
                // subject
                if (!is_array($this->subject)) {
                    $extra_requiredfields .= '.featured_subject:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $this->subject)))))); // match the regex from javascript and xslt
                } else {
                    $newsubjects = array();
                    foreach ($this->subject as $value) {
                        $newsubjects[] = 'featured_subject:'.urlencode(urlencode(preg_replace("/[^a-zA-Z\%\-\d\s:]/", '', urldecode(urldecode(str_replace('%2526%2523x2e', '', $value)))))); // match the regex from javascript and xslt
                    }
                    $subjects = implode('|', $newsubjects);
                    $extra_requiredfields .= '.('.$subjects.')';
                }
            } else {
                $partialfields .= '.feature_in:'.str_replace('library-databases-','',$this->site); // make sure we feature databases that we should. remove dashes because gsa doesn't like them
            }
        } else if ($new_only == true) {
            $extra_requiredfields .= '.status:'.urlencode(urlencode('new')); // encode twice bc it didn't come from the url
        } else if ($trial_only == true) {
            $extra_requiredfields .= '.status:'.urlencode(urlencode('trial')); // encode twice bc it didn't come from the url
        }

        $url .= $extra_requiredfields;

        // add partial fields
        if ($partialfields != '') {
            $url .= '&partialfields='.$partialfields;
        }

        // cache it all if it's supposed to
        if ($this->use_cache === true) {
            $url .= '&use_cache='.$this->use_cache.'&cache_time='.$this->cache_time;
        }

        return $url;
    }

    // load the api result file and parse it into a php array
    private function load_file($url, $format) {
      $ch = curl_init($url);
      // return http response in string
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
      if ($format != 'json') {
        $xml = simplexml_load_string(curl_exec($ch));
        $array = $this->xml2array($xml);
        } else {
            $json = curl_exec($ch);
            $array = json_decode($json, true);
        }
        return $array;
  }

  // if the data is xml, make it an array
    private function xml2array($xmlObject, $out = array()) {
        foreach ((array)$xmlObject as $index => $node) {
            if ( is_object($node) || is_array($node) ) {
                $out[$index] = $this->xml2array($node);
            } else {
                $out[$index] = $node;
            }
        }
        return $out;
    }

    // check the php installation for support of a functionality
    private function doesSupport($function) {
        return phpversion($function);
    }

    // html5 placeholder value for the search form
    private function placeholderValue() {
        // is this a filter page?
        if ($this->is_filter_page != false) {
            // we are filtering by subject
            if ($this->subject != '' && !is_array($this->subject)) {
                return 'Search for '.$this->indefiniteArticle($this->subject).' '.$this->titleCase(urldecode(urldecode($this->subject))).' Database';
            } else if ($this->subject != '') {
                $subjects = array();
                foreach ($this->subject as $subject) {
                    $subjects[] = $this->titleCase(urldecode(urldecode($subject)));
                }
                $subjects = implode(', ', $subjects);
                return 'Search within these criteria in Databases: '.$subjects;
            }
            // by resource type
            if ($this->resource_type != '' && !is_array($this->resource_type)) {
                return 'Search for '.$this->indefiniteArticle($this->resource_type).' '.$this->titleCase(urldecode(urldecode($this->resource_type))).' Database';
            } else if ($this->resource_type != '') {
                $resource_types = array();
                foreach ($this->subject as $resource_type) {
                    $resource_types[] = $this->titleCase(urldecode(urldecode($resource_type)));
                }
                $resource_types = implode(', ', $resource_types);
                return 'Search within these criteria in Databases:'.$resource_types;
            }
            // by letter
            if ($this->letter != '' && !is_array($this->letter)) {
                return 'Search for '.$this->indefiniteArticle($this->letter).' '.$this->titleCase(urldecode(urldecode($this->letter))).' Database';
            } else if ($this->letter != '') {
                $letters = array();
                foreach ($this->letter as $letter) {
                    $letters[] = $this->titleCase(urldecode(urldecode($letter)));
                }
                $letters = implode(', ', $letters);
                return 'Search within these criteria in Databases: '.$letters;
            }
            // by status
            if ($this->status != '' && !is_array($this->status)) {
                return 'Search for '.$this->indefiniteArticle($this->status).' '.$this->titleCase(urldecode(urldecode($this->status))).' Database';
            } else if ($this->status != '') {
                $statuses = array();
                foreach ($this->status as $status) {
                    $statuses[] = $this->titleCase(urldecode(urldecode($status)));
                }
                $statuses = implode(', ', $statuses);
                return 'Search within these criteria in Databases: '.$statuses;
            }
        } else {
            // is this the main page with no other criteria?
            return 'Search for a Database';
        }
    }

    // if we have a search value, keep it in the form field
    private function formValue() {
        //if ($this->is_search_page == true) {
            if (isset($_GET['db_q'])) {
                return ' value="'.urldecode(urldecode($_GET['db_q'])).'"';
            } else if (isset($_GET['q'])) {
                return ' value="'.urldecode(urldecode($_GET['q'])).'"';
            } else {
                return ' value=""';
            }
        //}
    }

    // make a/an appropriate as much as we can
    private function indefiniteArticle($subject) {
        $subject = strtolower($subject);
        switch ($subject) {
            case 'university':
                return 'a';
                break;
            case 'lgbt':
                return 'an';
                break;
            case 'f':
                return 'an';
                break;
            case 'h':
                return 'an';
                break;
            case 'l';
                return 'an';
                break;
            case 'm';
                return 'an';
                break;
            case 'n';
                return 'an';
                break;
            case 'o';
                return 'an';
                break;
            case 'r';
                return 'an';
                break;
            case 's';
                return 'an';
                break;
            case 'u';
                return 'a';
                break;
            case 'x';
                return 'an';
                break;
            default:
                if (in_array(strtolower(substr($subject, 0, 1)),array('a','e','i','o','u'))) {
                    return 'an';
                }
                else {
                    return 'a';
                }
            break;
        }
        
    }

    private function highlightkeyword($str, $search) {
        $search = urldecode(urldecode($search));
        $occurrences = substr_count(strtolower(urlencode($str)), urlencode($search));
        $newstring = $str;
        $match = array();
 
        for ($i=0;$i<$occurrences;$i++) {
            $match[$i] = stripos($str, $search, $i);
            $match[$i] = substr($str, $match[$i], strlen($search));
            $newstring = str_replace($match[$i], '[#]'.$match[$i].'[@]', strip_tags($newstring));
        }
 
        $newstring = str_replace('[#]', '<strong>', $newstring);
        $newstring = str_replace('[@]', '</strong>', $newstring);
        return $newstring;
 
    }

    function excerpt($string, $limit, $break = '. ', $pad = '.') {
        // return with no change if string is shorter than $limit
        if (preg_match('%(<ul[^>]*>.*?</ul>)%i', $string)) {
            $break = '<ul>';
            $pad = '';
        }
        if (strlen($string) >= $limit) {
            // is $break present between $limit and the end of the string?
            if (false !== ($breakpoint = strpos($string, $break, $limit))) {
                if($breakpoint < strlen($string) - 1) {
                    $string = strip_tags(substr($string, 0, $breakpoint) . $pad, $allowed_tags = '<b><i><sup><sub><em><strong><u><br><a>');
                }
            }
        }
        return $string;
    }
    

    private function titleCase($string)  {
        $len=strlen($string); 
        $i=0; 
        $last= ""; 
        $new= ""; 
        $string=strtoupper($string); 
        while  ($i<$len): 
                $char=substr($string,$i,1); 
                if  (ereg( "[A-Z]",$last)): 
                        $new.=strtolower($char); 
                else: 
                        $new.=strtoupper($char); 
                endif; 
                $last=$char; 
                $i++; 
        endwhile; 
        return($new); 
    }


    private function parseQueryString($url, $key) {
        $parts = parse_url($url);
        $qs = isset($parts['query']) ? $parts['query'] : '';
        $base = $qs ? substr($url, 0, strpos($url, '?')) : $url; // all of URL except QS
        parse_str($qs, $qsParts);
        unset($qsParts[$key]);
        $newQs = rtrim(http_build_query($qsParts), '=');
        if ($newQs)
        return $base.'?'.$newQs;
        else
        return $base;
    }

    private function linkChecker($results) {
        echo '<ol>';
        foreach ($results as $result) {
            foreach ($result['MT'] as $metaset) {
                foreach ($metaset as $attributes) {
                    if ($attributes['N'] == 'external_link') {
                        $url = $attributes['V'];
                        $ch = curl_init();
                        curl_setopt($ch, CURLOPT_URL, $url);
                        curl_setopt($ch, CURLOPT_HEADER, 1);
                        curl_setopt($ch , CURLOPT_RETURNTRANSFER, 1);
                        $data = curl_exec($ch);
                        $headers = curl_getinfo($ch);
                        curl_close($ch);
                        echo '<li>'.$headers['http_code'].'</li>';
                    }
                }
            }
        }
        echo '</ol>';
    }

}

?>