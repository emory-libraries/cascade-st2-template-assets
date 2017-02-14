<?php

class SearchResults {

  // set variable defaults. these values come from Cascade.
  public $site;
  public $api_root;
  public $numgm;
  public $num;
  public $requiredfields;
  public $use_cache;
  public $cache_time;

  // these come from search criteria, pagination, etc. values on url
  public $q = ''; // search term
  public $new_query = ''; // search term if there has been a misspelling that google wants to correct
  public $start = ''; // starting position (zero based)
  public $sort = ''; // sort method (we use default GSA method)
  public $btnG = ''; // we don't use this
  public $filter = 0; // do not allow google to filter things it thinks are redundant - get everything. this is because the first result shows all of them anyway; it only works on subsequent pages
  public $getfields = ''; // metafields that we need
  public $format = 'xml'; // format for api return

  // we create these based on the search criteria
  public $results = '';

  public $is_paged = false; // is the query paginated?
  public $results_paged = true; // do the results need pagination?
  public $is_search = false;

  public $is_debug = false; // are we in debug mode?

  function __construct($site, $api_root, $numgm, $num, $requiredfields, $use_cache = false, $cache_time = 3600) {
    $this->site = $site; // option values from cascade
    $this->api_root = $api_root;
    $this->numgm = $numgm;
    $this->num = $num;
    $this->requiredfields = $requiredfields;
    $this->use_cache = $use_cache;
    $this->cache_time = $cache_time;
    $this->autocomplete = false; // preparation for this, but for now it is a bad user expectation

    // minimum criteria for our needs
    if ($this->requiredfields != '') {
        $this->getfields = '*'; // gsa is able to see all metafields
    }

    // use json for results if server supports it
    if (!isset($_GET['format']) && $this->doesSupport('json') || isset($_GET['format']) && $_GET['format'] == 'json') {
        $this->format = 'json';
    } else {
        $this->format = 'xml';
    }

    if ($this->cache_time == '') {
        $this->cache_time = 3600;
    }

    // secure the query
    $this->is_search = $this->queryExists();

    // what kind of result query is this
    $this->is_paged = $this->isPagedQuery();

    // if debug is here, use it
    if (isset($_GET['debug'])) {
        $this->debug = true;
    }

    // start rendering things on the page
    $this->searchForm(); // search form

    if ($this->is_search === true) {
      $this->getSearchResults(); // get search results via the api
      if ($this->numgm != '') { // display results with key matches
        // TODO: look at the xml for key matches. display it nicely somehow.
        $this->displaySearchResults($this->results, true);
      } else {
        $this->displaySearchResults($this->results, false);
      }
      // if this is a results page, do some pagination
      if ($this->results_paged == true) {
        $this->pagination(); // pagination links and info
      }
    }        

  }

  // filter the query variables
  function queryExists() {
    if (isset($_GET['q']) || isset($_GET['search_q'])) {            
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
          case 'search_q':
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

  // is this a paginated page?
  public function isPagedQuery() {
    if (isset($_GET['start']) || isset($_GET['sort'])) {  
      foreach ($_GET as $key => $value) {
          if ($this->doesSupport('filter')) {
            $value = filter_var(urlencode($value), FILTER_SANITIZE_STRING); // secure variables
          } else {
            $value = urlencode($value);
          }
          switch($key) { // available to the entire class
            case 'start':
              $this->start = $value;
              break;
            case 'sort':
              $this->sort = $value;
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
      if ($this->format == 'json' && $this->autocomplete === true) {
        $url = $this->getQueryURL(false);
        if (isset($this->debug) && $this->debug === true) {
          echo '<div class="alert alert-info"><h4>Debug</h4><small>Form submit url is <a href="'.$url.'">'.$url.'</a></small></div>';
        }
        $formparams = 'class="input span10 ajax-typeahead" autocomplete="off" data-url="'.$url.'&amp;format=json"';
      } else {
        $formparams = 'class="input span10"';
      }
      echo '<div class="big-search site-search">
              <form action="?" id="site-search" class="clearfix" method="get" name="searchForm">';
                echo '<div class="input-append span12">
                  <input '.$formparams.' id="search_q" name="search_q" placeholder="'.$this->placeholderValue().'"'.$this->formValue().' type="search"/>                                    
                  <button class="btn btn-search" type="submit"> <strong class="label">Search</strong>
                      <span class="fa fa-search"></span>
                  </button>
                </div>
              </form>
            </div>';
  }

  // get results from the api
  public function getSearchResults($new_query = '') {

    if ($new_query == '') {
      $url = $this->getQueryURL(true);
    } else {
      $url = $this->getQueryURL(false, $new_query);
    }

    // set format for api result
    $url .= '&format='.$this->format;

    // make the api call and store the results
    $this->results = $this->load_file($url, $this->format);

    if (isset($this->debug) && $this->debug === true) {
      echo '<div class="alert alert-info"><h4>Debug</h4><small>API query url is <a href="'.$url.'">'.$url.'</a></small></div>';
    }

    return $this->results;

  }

    // take the results and display them according to the configuration
    public function displaySearchResults($results, $numgm = false, $results_title = '', $misspelled = false) {
        // set values for range display
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
        // if there are results, display the count info
        $term = urldecode(urldecode($this->q));
        if (isset($results['M'])) {
            if ($results_title == '') {
                $title = 'Results '.number_format($begin).' - '.number_format($end).' of '.number_format($results['M']).' for <strong>'.$term.'</strong>';
            } else if ($misspelled == true) {
                $title = $results_title;
                //$instead = 'Search instead for <a href="#"><strong><em>'.$this->q.'</em></strong></a>';
            } else {
                $title = $results_title;
            }
        } else if (isset($results['Spelling'])) {
            $this->new_query = strip_tags($results['Spelling']['Suggestion']);
            $title = 'Showing results for '.$results['Spelling']['Suggestion'];
            $results = $this->getSearchResults($this->new_query);
            $this->displaySearchResults($results, $this->numgm, $title, true);
            return;
        } else if ($term != '') {
            $title = 'No results for <strong>'.$term.'</strong>';
        } else {
          $title = '';
        }

        // only display "no results" if this is the default listing or default filter listing
        if (isset($results['RES']) && !isset($results['error']) || isset($results['RES']) && !isset($results['error']) && $this->is_paged != false) { // we have no error, or we have no error and no pagination
            $start = $this->start + 1;
            // wrap the results and send them to be displayed
            echo '<section class="search-results clearfix">
                    <h2>'.$title.'</h2>';
                    if (isset($subtitle)) { echo '<h4 class="result-range">'.$subtitle.'</h4>'; };
                    if (isset($instead)) { echo '<h4 class="instead">'.$instead.'</h4>'; };

                    if ($this->numgm != '' && $this->numgm > 0 && isset($results['GM'])) {
                        echo '<div class="key-matches well well-small"><h4>Key Matches</h4>';
                        echo '<ul>';
                        if ($this->format == 'json') {
                            foreach ($results['GM'] as $gm) {
                                echo '<li><a href="'.$gm['GL'].'">'.$gm['GD'].'</a></li>';
                            }
                        } else {
                            foreach ($results['GM']['item'] as $gm) {
                                echo '<li><a href="'.$gm['GL'].'">'.$gm['GD'].'</a></li>';
                            }
                        }
                        echo '</ul></div>';
                    }

                    echo '<ol class="listings" start="'.$start.'">';
                        if ($results['RES']['M'] == 1) {
                            $this->searchResult($results['RES']['R']);
                        } else {
                            if ($this->format == 'json') {
                                foreach ($results['RES']['R'] as $result) {
                                        $this->searchResult($result);
                                }
                            } else {
                                foreach ($results['RES']['R']['item'] as $result) {
                                        $this->searchResult($result);
                                }
                            }
                        }
                    echo '</ol>
                </section>';

        } else if (isset($results['error']) && isset($results['error_code'])) {
            echo '<section class="search-results clearfix">';
                echo '<h2>Site search is under repair</h2><p>You can still use Library Catalog, eJournals, Research &amp; Course Guides, Finding Aids, and EUCLID by choosing one of the links at the right of this page.</p>';
                if (isset($selections)) { echo $selections; };
            echo '</section>';
        } else if (isset($results['error']) || !isset($results['RES'])) {
            // if there is an error display the error message
            echo '<section class="search-results clearfix">
                    <h2>'.$title.'</h2>';
                    if ($term != '') {
                      echo '<p>There are no results for this search.</p>';
                    }
                echo '</section>';
        }
    }

    // render each search result entry
    public function searchResult($result) {
        $link = $result['U'];
        if ($this->format == 'json') {
          $mime = isset($result['@attributes']['MIME']) ? $result['@attributes']['MIME'] : '';
        } else {
          $mime = isset($result['attributes']['MIME']) ? $result['attributes']['MIME'] : '';
        }
        $title = $result['T'];
        $description = $result['S'];
        if (empty($description)) {
            $description = '';
        }

        if ($mime !== '') {
          $extension = $this->getExtension($mime);
          if ($extension != '') {
            $extension = '<sup class="muted">['.$this->getExtension($mime).']</sup> ';
          }
        } else {
          $extension = '';
        }

        // render title, link, and description
        echo '<li>
                <article>
                    <h3>'.$extension.'<a href="'.$link.'">'.$title.'</a></h3>
                    <small class="caption text-success">'.preg_replace('#^https?://#', '', $link).'</small>
                    <p>'.$description.'</p>
                </article>
             </li>';
    }

    // display pagination
    public function pagination() {
        if (isset($this->results['M'])) {
          $total = $this->results['M'];
          if ($total >= 1000) {
              $total = 1000;
          }
          $pages = ceil($total / $this->num);
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

        if (!isset($this->results['error']) && isset($this->results['M'])) {
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
                    //$viewable_number = $i + 1;
                    if ($i != 1) {
                        $query_string = $url.$query_delimitor.'start='.($i - 1) * $this->num;
                    } else {
                        $query_string = $url.$query_delimitor.'start=';
                    }

                    $show_link = true;

                    if ($pages > 10) {
                        if ( ($i < $current_page && ($current_page - $i) > 4) || ($i > $current_page && ($i - $current_page) > 5) && $i - 9 > 1) {
                          $show_link = false;
                        }
                    } else { // less than 10 pages total
                        if ($i < 10) {
                            $show_link = true;
                        }
                    }

                    if ($show_link && $current_page < (1000 / $this->num)) {
                        if ($i - 1 == $current_page) { // currently selected page
                            echo '<li class="active"><a href="'.$query_string.'">'.$i.'</a></li>';
                        } else { 
                            echo '<li><a href="'.$query_string.'">'.$i.'</a></li>';
                        }
                    }
                }

                if ($current_page != $total && ($this->start + $this->num) < $total) {
                  // current page + 1 for next
                  $query_string = $url.$query_delimitor.'start='.($current_page + 1) * $this->num;
                  echo '<li><a href="'.$query_string.'">Next</a></li>';
              }

            echo '</ul></div>';
        }
    }

    // construct a url for the API that we can re-use
    // important: depending on how it is being used, additional parameters may be added to this url in other functions
    private function getQueryURL($usequery = true, $newquery = '') {

      $url = $this->api_root . 'gsa/results/?site='.$this->site; // add api url
      if ($usequery === true) { // is there a search value?
        $url = $url .= '&q='.urlencode(urlencode($this->q));
      }
      if ($newquery != '') {
        $url = $url .= '&q='.urlencode(urlencode($newquery));
      }
      // add gsa fields to the api url
      if ($this->start !== '') {
        $url .= '&start='.$this->start;
      }
      if ($this->sort !== '') {
        $url .= '&sort='.$this->sort;
      }
      if ($this->num !== '') {
        $url .= '&num='.$this->num;
      }
      if ($this->numgm !== '') {
        $url .= '&numgm='.$this->numgm;
      }
      if ($this->filter !== '') {
        $url .= '&filter=0';
      }
      if ($this->btnG !== '') {
        $url .= '&btnG='.$this->btnG;
      }
      if ($this->getfields !== '') {
        $url .= '&getfields='.$this->getfields;
      }
      // create requiredfields for gsa from the filter parameters
      if ($this->requiredfields != '') {
        $fields = explode('.', $this->requiredfields);
        foreach ($fields as $field) {
          $pairs[] = explode(':', $field);
        }
        $newpairs = array();
        foreach ($pairs as $pair) {
          $pair['key'] = $pair[0];
          $pair['value'] = urlencode(urlencode($pair[1]));

          $newpair = $pair['key'].':'.$pair['value'];
          $newpairs[] = $newpair;
        }
        $this->requiredfields = implode('.', $newpairs);
      }
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

  private function getExtension($mime_type) {
    $extensions = array (
      'image/jpeg' => 'jpg',
      'image/png' => 'png',
      'image/gif' => 'gif',
      'text/xml' => 'xml',
      'application/pdf' => 'pdf',
      'application/excel' => 'xls',
      'application/vnd.ms-excel' => 'xls',
      'application/msexcel' => 'xls',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'xlsx',
      'application/powerpoint' => 'ppt',
      'application/vnd-ms-powerpoint' => 'ppt',
      'application/msword' => 'doc',
      'application/vnd.openformats-officedocument.wordprocessingml.document' => 'docx',
      'video/mpeg' => 'mpg',
      'video/mpg' => 'mpg'
    );

    if (array_key_exists($mime_type, $extensions) == 1) { // return an extension if we know what it is
      return $extensions[$mime_type];
    } else {
      return '';
    }

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
        // flexible for more criteria
        return 'Search this Site';
    }

    // if we have a search value, keep it in the form field
    private function formValue() {
        if (isset($_GET['q'])) {
            return ' value="'.$_GET['q'].'"';
        } else if (isset($_GET['search_q'])) {
            return ' value="'.$_GET['search_q'].'"';
        }
    }

    private function multiexplode ($delimiters,$string) {
        $ready = str_replace($delimiters, $delimiters[0], $string);
        $launch = explode($delimiters[0], $ready);
        return  $launch;
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

}

?>
