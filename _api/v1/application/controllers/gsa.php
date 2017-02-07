<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * GSA
 *
 * API classes for Google Search Appliance
 *
 * @package     CodeIgniter
 * @subpackage  GSA API
 * @category    Controller
 * @author      Jonathan Stegall
*/

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
require APPPATH.'/libraries/REST_Controller.php';

class Gsa extends REST_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->load->model('gsa_data');
    }
    
    public function results_get()
    {
        if (ENVIRONMENT == 'development')
        {
            $this->benchmark->mark('code_start'); // if this is development, we can figure out how long it takes
        }

        // get parameters from the url - these are things gsa needs or that the api needs
        $q = $this->get('q');
        $start = $this->get('start');
        $sort = $this->get('sort');
        $num = $this->get('num');
        $numgm = $this->get('numgm');
        $btnG = $this->get('btnG');
        $filter = $this->get('filter');
        $getfields = $this->get('getfields');
        $requiredfields = $this->get('requiredfields');
        $partialfields = $this->get('partialfields');
        $site = $this->get('site');
        $use_cache = $this->get('use_cache');
        $cache_time = $this->get('cache_time');
        $format = $this->get('format');

        // set parameter defaults if necessary
        if (isset($sort))
        {
            $sort = $this->get('sort'); // sorting gsa
        }
        else
        {
            $sort = ''; // use gsa default
        }
        
        if (isset($num))
        {
            $num = $this->get('num'); // number of results
        }
        else
        {
            $num = 10; // default of 10
        }

        if (isset($numgm))
        {
            $numgm = $this->get('numgm'); // number of featured results
        }
        else
        {
            $numgm = 3; // default of 3 (matches emory config)
        }

        if (isset($btnG))
        {
            $btnG = $this->get('btnG'); // search button text if we use google's
        }
        else
        {
            $btnG = 'Search'; // default of Search
        }

        if (isset($filter))
        {
            $filter = $this->get('filter'); // activate or deactivate automatic results filtering
        }
        else
        {
            $filter = 1; // default uses google's filtering
        }

        if (isset($getfields))
        {
            $getfields = $this->get('getfields'); // whether or not to return metatags
        }
        else
        {
            $getfields = ''; // by default, do not return them
        }

        if (isset($requiredfields))
        {
            $requiredfields = $this->get('requiredfields'); // which tags to return
        }
        else
        {
            $requiredfields = ''; // by default, none
        }

        if (isset($partialfields))
        {
            $partialfields = $this->get('partialfields'); // which tags to return
        }
        else
        {
            $partialfields = ''; // by default, none
        }

        if (isset($site))
        {
            $site = $this->get('site'); // gsa collection
        }
        else
        {
            $site = 'default_collection'; // the default emory collection. specify if you need a different value.
        }

        if (isset($use_cache))
        {
            $use_cache = $this->get('use_cache'); // whether to cache
        }
        else
        {
            $use_cache = false; // by default, do not cache
        }

        if (isset($cache_time))
        {
            $cache_time = $this->get('cache_time'); // how long to cache results
        }
        else
        {
            $cache_time = 3600; // default cache time
        }

        if (isset($format) && $format != '')
        {
            $format = $this->get('format'); // what format to use for the results
        }
        else
        {
            $format = $this->config->item('rest_default_format');
        }
        
        // send paramters to the model and get results
        $results = $this->gsa_data->get_results($q, $btnG, $num, $numgm, $site, $sort, $start, $filter, $getfields, $requiredfields, $partialfields, $use_cache, $cache_time);
        if (ENVIRONMENT == 'development') {
            $this->benchmark->mark('code_end');
            $results['elapsed_time'] = $this->benchmark->elapsed_time('code_start', 'code_end');
        }
        
        $results['format'] = $format;

        // send the results to the API
        if (!isset($results['error']))
        {
            $this->response($results, 200); // 200 being the HTTP response code
        }
        else if (isset($results['error_code']))
        {
            $this->response($results, $results['error_code']); // error code being the HTTP response code
        }
        else
        {
            $this->response(array('error' => 'No results were found.'), 404);
        }

    }

}