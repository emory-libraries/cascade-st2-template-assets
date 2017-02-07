<?php

class Form extends CI_Controller {

    function index()
    {
        $this->load->helper('url');
        $path = $_SERVER['HTTP_REFERER'];

        $email = '';
        $requestor_email='';
        $multipart='';
        $message ='<html><body>';
        $innerTable='';
        $alt_msg = '';
        $formName = $_POST['submit'];

        $user_message ='';

        foreach ($_POST as $key => $value) {
            if($key!='submit' Xor $key!='re-name' Xor $key!='re-email' Xor strpos($key, 'undefined')!==false){
                if($key == 'maximum-number-of-students' and $value=='0'){
                    $value="Unlimited";
                }
                else if($key=='requested-date' and $value=='dd-mm-yyyy'){
                    $value="Not Specified.";
                }
                
                $k = ucwords(str_replace('-', ' ', $key));

                if(strpos($key, 'subject-area')!==false){
                  $multipart .= $value .", "; 
                  $multipart_k = "Interested Subject Areas";
                }
                else if($key=='user-message'){
                    $user_message = $value;
                }
                else{
                    if(strpos($key, 'email')!==false){
                        $requestor_email = $value;
                    }
                    $innerTable .='<tr>';
                    $innerTable .= '<td style="padding:1em;margin:0;background-color:#eff0f2;border-top-left-radius:5px;border-bottom-left-radius:5px;">'. $k . '</td>
                    <td style="padding:1em;margin:0;background-color:#eff0f2;border-top-right-radius:5px;border-bottom-right-radius:5px;">' .$value .'</td>'; 
                    $innerTable .= '<tr/>';
                }
                $alt_msg = $k .': ' .$value .' |';

            }
        }
        $message.="<p><small>This is an automatically generated email message. Please do not reply to this email.</small></p><br/>";
        
        $message.="<p>".$user_message."</p>";

        $message.='<table style="width: 100%;max-width: 480px;border:2px solid #ECECEC;background-color: #FFFFFF;border-radius: 3px;padding: 5px 5px 2px;font-family: sans-serif;color: #2C3E50;">';
        
        $message.='<tr><th colspan="2" style="text-align:left;font-size:24px;padding-bottom:12px;">'. $formName .'</th></tr>';
        
        $message.=$innerTable;

        $message.= '<td style="padding:1em;margin:0;background-color:#eff0f2;border-top-left-radius:5px;border-bottom-left-radius:5px;">'. $multipart_k . '</td>
                    <td style="padding:1em;margin:0;background-color:#eff0f2;border-top-right-radius:5px;border-bottom-right-radius:5px;">' .substr($multipart, 0, -2) .'</td>'; 

        $message.='</table>';

        $message .= "</body></html>";
        

        $data['heading'] = 'New Request from '. $formName;
        $data['path'] =$path;
        $data['requestor_email'] = $requestor_email;
        $data['send_to_email'] = $_POST['re-email'];
        $data['send_to_name'] = $_POST['re-name'];
        $data['message'] =$message;
        $data['alt_msg'] =$alt_msg;


        $this->load->helper(array('form', 'url'));

        $this->load->library('email');

        $this->load->view('formsuccess', $data);

    }
}
?>