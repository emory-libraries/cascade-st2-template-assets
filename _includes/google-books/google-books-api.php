<?php

$all_isbn_book_data = array();

//GET FROM EXISTING LIBRARY OF JSON FILES FROM all_stored_isbns.txt
$all_stored_isbns = file('cache/all_stored_isbns.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

// RECEIVE ISBNS 
//$isbns_received = array('1451666179', '0060930314','1419708635', '3832797599');
$isbns_received = explode(',',urldecode($_GET['isbns']));
//var_dump($_GET['isbns']);

//open the object
// echo "{";

//LOOP THROUGH EVERY RECIEVED ISBN TO SEE IF THEY EXIST IN all_stored_isbns.txt
foreach ($isbns_received as $key => $this_isbn) {
    
    //FILENAME FOR JSON FILE - USED IN BOTH CONDITIONS  

    $this_filename = $this_isbn .'.json';

    // CHECK TO SEE IF IT'S IN ARRAY
    if (in_array($this_isbn, $all_stored_isbns)) {
        $this_isbn_json = file_get_contents('cache/'.$this_filename);
        //echo '"'.$this_isbn.'":'.$this_isbn_json;
        array_push($all_isbn_book_data,'"'.$this_isbn.'":'.$this_isbn_json); 
    }

    // IF IT DOESNT ALREADY EXIST - CONNECT TO API  AND GET JSON
    else {
        $apikey = "AIzaSyDnmY2TOrSYqhZru2y3VYM8-iq1Ti-d-jw";
        $endpoint = 'https://www.googleapis.com/books/v1/volumes?q=isbn:' . $this_isbn . '&key=' . $apikey;
        $session = curl_init($endpoint);
        curl_setopt($session, CURLOPT_RETURNTRANSFER, true);
        $this_isbn_json = curl_exec($session);
        $this_isbn_json = '{"id":"'.$this_isbn.'","result":'.$this_isbn_json.'}';
        //$this_isbn_json = (string)$this_isbn_json;
        curl_close($session);
        //$search_results = json_decode($this_isbn_json);
        //if ($search_results === NULL) die('Error parsing json');
        //echo '"'.$this_isbn.'":'.$this_isbn_json;

        // WRITE BOOK ISBN TO all_stored_isbns.txt
        file_put_contents('cache/all_stored_isbns.txt', "\n" . $this_isbn, FILE_APPEND);
        
        // WRITE BOOK JSON TO LOCAL FOLDER
        file_put_contents('cache/'.$this_filename, $this_isbn_json);
        //RETRIEVE DATA FROM FILE
        $this_isbn_json = file_get_contents('cache/'.$this_filename);

        array_push($all_isbn_book_data,'"'.$this_isbn.'":'.$this_isbn_json); 
    }

    /*if($key !== sizeof($isbns_received)-1){
        echo ",";
    }*/

}

$all_isbn_book_data = implode(",",$all_isbn_book_data);
$all_isbn_data_to_send = "{".$all_isbn_book_data."}";

//close the object
//echo "}";

/*
$request_headers = apache_request_headers();
$origin = $request_headers['Origin'];

$domains = array();
$domains = ["https://cascade.emory.edu", "http://test.business.library.emory.edu", "http://business.library.emory.edu", "http://test.health.library.emory.edu","http://health.library.emory.edu", "http://web.library.emory.edu", "http://marbl.library.emory.edu", "http://oxford.library.emory.edu"];
if (in_array($origin, $domains)){
    header("Access-Control-Allow-Origin: ".$origin);
}
*/

header('Content-type: application/json');
echo($all_isbn_data_to_send);

?>