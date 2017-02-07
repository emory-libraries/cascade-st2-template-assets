<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * GSA_data
 *
 * Data model for Google Search Appliance
 *
 * @package    	CodeIgniter
 * @subpackage	GSA API
 * @category	Model
 * @author		Jonathan Stegall
*/

class Gsa_data extends CI_Model {

    public function __construct()
    {
        parent::__construct();
        $this->load->helper('xmltoarray'); // converts xml into a php array
        $this->load->library('feedcache'); // caches the xml if it can

    }

    public function get_results($q, $btnG, $num, $numgm, $site, $sort, $start, $filter, $getfields, $requiredfields, $partialfields, $use_cache, $cache_time)
    {
		/*
			A default URL from the Emory Search site is like this:
			http://search.emory.edu/search?q=ebsco&btnG=Emory+Search&entqr=0&output=xml&ud=1&oe=UTF-8&ie=UTF-8&numgm=5&sort=date%3AD%3AL%3Ad1&site=main_library';
		*/

        // make url friendly string out of the parameters
        $query = '&q='.$q; // the search term
        if ($btnG != '')
        {
            $query .= '&btnG='.$btnG; // the button text, if applicable
        }
        if ($num != '')
        {
            $query .= '&num='.$num; // how many results
        }
        if ($numgm != '')
        {
            $query .= '&numgm='.$numgm; // how many recommended results
        }
        if ($filter != '' && $filter != 1)
        {
            $query .= '&filter='.$filter; // configure how the results are filtered
        }
        if ($site != '')
        {
            $query .= '&site='.$site; // gsa collection
        }
        if ($sort != '')
        {
            $query .= '&sort='.$sort; // sort
        }
        if ($start != '')
        {
            $query .= '&start='.$start; // start at result number ___ (zero-based)
        }
        if ($getfields != '')
        {
            $query .= '&getfields='.$getfields; // tell gsa whether to look for metafields
        }
        if ($requiredfields != '')
        {
            $query .= '&requiredfields='.$requiredfields; // which metafields to return
        }

        if ($partialfields != '')
        {
            $query .= '&partialfields='.$partialfields; // which metafields to return
        }

        $cached_data = FALSE;

    	$url = 'http://search.emory.edu/search?entqr=0&output=xml&ud=1&oe=UTF-8&ie=UTF-8&client=default_frontend'.$query; // full gsa url
        
        // load the xml. if it is not a search query, if we have option enabled, and if we have permissions, cache it.
        if ($use_cache == true)
        {
            $cacheparams = array('local' => 'gsa_'.$query.'.xml', 'remote' => $url, 'valid_for' => $cache_time, 'dir' => APPPATH.'cache/');
            if ($q == '' || $requiredfields == '' && is_writable($cacheparams['dir'])) // cache if there is no search string or no required fields
            {
                $feed_cache = new FeedCache($cacheparams);
                $xml = simplexml_load_string($feed_cache->get_data());
                $cached_data = TRUE;
            }
            else
            {
                // otherwise, just load the xml
                $xml = $this->load_file($url);
            } 
        }
        else
        {
            // otherwise, just load the xml
            $xml = $this->load_file($url);
        }

        $results['url'] = $url;
        $results['cached_data'] = $cached_data;
        
        // make an array from the xml
        $resultset = xml2array($xml);
        if (isset($resultset['RES']) || isset($resultset['Spelling']))
        {
            // get the xml structured the way we need it
            if (ENVIRONMENT == 'development')
            {
                $results['TM'] = $resultset['TM'];
                $results['url'] = $url;
            }
            $results['@attributes'] = $resultset['@attributes']; // attributes for the search appliance
            $results['parameters'] = $resultset['PARAM']; // parameters we sent in the request

            if ($numgm > 0) {
                $results['GM'] = array();
                foreach ($resultset['GM'] as $gm) {
                    $results['GM'][] = $gm;
                }
            }

            if (isset($resultset['RES']))
            {
                $results['M'] = $resultset['RES']['M']; // The estimated total number of results for the search.
                if (isset($resultsset['RES']['FI']))
                {
                    $results['FI'] = $resultset['RES']['FI']; // Indicates that document filtering was performed during this search
                }
                if (isset($resultsset['RES']['NB']))
                {
                    $results['NB'] = $resultset['RES']['NB']; // Navigation info for resultset - only present if there are previous or next results
                }
                if (isset($resultset['RES'])) {
                    $results['RES'] = $resultset['RES']; // the actual resultset. each result in the set is 'R'
                }
            } else if (isset($resultset['Spelling'])) {
                $results['Spelling'] = $resultset['Spelling'];
            }

            // if there is not a search query term, sort the results before we send them
            if ($q == '' && $results['M'] > 1) {
                //$this->aasort($results['RES']['R'], 'T');
                usort($results['RES']['R'], array($this, 'cmp'));
            }

            // send the xml back to the controller
            return $results;
        } else if (is_array($resultset)) {
            if (isset($resultset['error_code']) && $resultset['error_code'] == 56) {
                $results['error_code'] = 500;
                $results['error'] = 'Internal server error';
            }
            return $results;
        } else {
            $results['error'] = 'No results';
            return $results;
        }
    }

    // sort the array we pass to it
    private function cmp($a, $b)
    {
        return strcmp(strtolower($a['T']), strtolower($b['T']));
    }


    private function load_file($url)
    {
        //$ch = curl_init($url);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        // return response in string that php can use
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HEADER, 0);

        curl_exec($ch);

        // Check if any error occured
        if(!curl_errno($ch))
        {
         if(curl_getinfo($ch, CURLINFO_HTTP_CODE) === 200) {
            $xml = simplexml_load_string(curl_exec($ch));
        }
        } else {
            $xml['error_code'] = curl_errno($ch);
        }

        // close cURL resource, and free up system resources
        curl_close($ch);

        return $xml;
    }
     
}