<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed'); 
/**
* Cache remote feeds to improve speed and reliability
* Author: Erik Runyon
* Updated: 2012-06-08
*/

/* 
* Modified for CodeIgniter and old, locked-down version of PHP
* Author: Jonathan Stegall
* Updated: 2013-07-23
*/

class Feedcache {
  public  $params;
  private $is_expired;
  private $is_local;
  private $data = false;

  public function __construct( $params = array('local' => '', 'remote' => '', 'valid_for' => 3600, 'dir' => APPPATH) ) {
    $this->local = $params['dir'].$params['local'];
    $this->remote = $params['remote'];
    $this->valid_for = $params['valid_for'];
    $this->is_local = $this->check_local();
    $this->is_expired = $this->check_expired();
    $this->cleanup = $this->clean_cache();
    $this->data = $this->populate_data();
  }

  public function get_data() {
    return $this->data;
  }

  /**
* 1. If local file is valid, use it
* 2. If it's not, try to cache it
* 3. If that fails, use the local even if its expired so we at least have something
*/
  private function populate_data() {
    if( $this->is_local && !$this->is_expired ) {
      return file_get_contents($this->local);
    } else if( $this->cache_feed() || $this->is_local ) {
      return file_get_contents($this->local);
    }
  }

  /**
* If remote file exists, get the data and write it to the local cache folder
*/
  private function cache_feed() {
    if($this->remote_file_exists($this->remote)) {
      $compressed_content = '';
      $remote_content = $this->load_file($this->remote);
      $cached = $remote_content->asXML($this->local);      
      if ($cached === false) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  /**
  * Check the local copy to see if it is a file, and if it is at least 500 bytes
  */
  private function check_local() {
    if (is_file($this->local) && filesize($this->local) > 500) {
      return true;
    } else {
      return false;
    }
  }

  /**
  * Check the local copy to see if it is expired.
  */
  private function check_expired() {
    if($this->is_local === true) {
      $valid_until = filemtime($this->local) + $this->valid_for;
      return $valid_until < time();
    }
    return true;
  }

  /**
  * If the local copy has expired, delete it
  */
  private function clean_cache() {
    if ($this->is_local === true && $this->is_expired === true) {
      unlink($this->local);
    }
  }

  /**
  * Check to see if remote feed exists and responding in a timely manner
  */
  private function remote_file_exists($url) {
    $ret = false;
    $ch = curl_init($url);

    curl_setopt($ch, CURLOPT_NOBODY, true); // check the connection; return no content
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 1); // timeout after 1 second
    curl_setopt($ch, CURLOPT_TIMEOUT, 2); // The maximum number of seconds to allow cURL functions to execute.
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows; U; Windows NT 6.0; da; rv:1.9.0.11) Gecko/2009060215 Firefox/3.0.11');

    // do request
    $result = curl_exec($ch);

    // if request is successful
    if ($result === true) {
      $statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if ($statusCode === 200) {
        $ret = true;
      }
    }
    curl_close($ch);
    return $ret;
  }

  /**
  * Load the remote file as a SimpleXML object and return it
  */
  private function load_file($url)
  {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    // return response in object
    $xml = simplexml_load_string(curl_exec($ch));
    return $xml;
  }

}
?>