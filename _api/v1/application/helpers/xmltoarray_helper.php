<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

function xml2array ( $xmlObject, $out = array () )
{
	foreach ( (array) $xmlObject as $index => $node )
	    $out[$index] = ( is_object ( $node ) ||  is_array ( $node ) ) ? xml2array ( $node ) : $node;

	return $out;
}