<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Forms extends CI_Controller {

    public function __construct()
    {
        parent::__construct();
        // Your own constructor code
        $this->load->library(array('Form', 'user_agent'));
        // save honeypot name attribute value in a session here
    }

    public function index()
    {
    }

    public function create($form) // $form is an array that could come from any data source: config file, database results, etc.
    {

        // if form has a name and has any fields
        if (isset($form['name']) && isset($form['fields']))
        {
            $form_name = $form['name'];
            $form_array = $form['fields'];
        }

        // determine whether form is in debug mode
        if (isset($form_array['debug']))
        {
            $debug = $form_array['debug'];
        }
        else
        {
            $debug = FALSE;
        }

        // determine whether form should use JavaScript for confirmation message
        if (isset($form_array['js_submit']))
        {
            $js_submit = $form_array['js_submit'];
        }
        else
        {
            $js_submit = FALSE;
        }

        if ($js_submit == TRUE && $debug == FALSE)
        {
            $form_array['attributes']['class'] .= ' js_submit';
        }

        // determine whether form should contain a honeypot captcha
        if (isset($form_array['honeypot'])) {
            $honeypot = $form_array['honeypot'];
        }
        else
        {
            $honeypot = FALSE;
        }


        if ($honeypot == TRUE)
        {
            // name attribute needs to be the session value
            $form_array['step1']['special_body'] = array(
                'type'  => 'text',
                'label' => "Are you a robot? (humans don't enter anything)",
                'error_text' => '',
                'rules' => '',
                'attributes' => ''
            );
        }

        // validate the form (with codeigniter's validation library) and perform any actions associated with it
        if (Form::validate($form_array, $form_name))
        {
            $post = $this->input->post(); // posted data
            $honeypot_value = '';
            if ($honeypot !== FALSE)
            {
                $honeypot_value = $post['special_body'];
            }
            $pre_message = $post['email_message'];
            $data['pre_message'] = $post['email_message'];
            // move necessary fields out of the main area
            unset($post['email_message']);
            unset($post['special_body']);

            // if it is an undefined key, take it out
            foreach($post as $key=>$value)
            {
              if (strpos('x'.$key,'undefined'))
              {
                unset($post["$key"]);
              }
            }

            // process the form
            // check if honeypot value matches the session variable that we stored. if it does, invalid.
            if ($debug !== TRUE && $honeypot_value === '')
            { // all conditions passed

                // if it passed all requirements, perform actions
                $data = $this->email($form, $form_name, $form['recipient'], $post);
                
                Form::flush();

                if ($data['result'] == 1)
                {
                    $data['page_message'] = 'Your message was sent';
                    echo $this->load->view('form-email/success', $data, true);
                }
                else
                {
                    $data['page_message'] = 'Your message was not sent';
                    echo $this->load->view('form-email/error', $data, true);
                }

            }
            else if ($debug == TRUE && $honeypot_value === '')
            { // debug is true but other conditions passed

                $data['form_name'] = $form_name;
                $data['email'] = $post;

                $data['page_message'] = 'The message below would have been sent, but the form is in debug mode.';
                $data['message'] = $data['email'];

                echo $this->load->view('form-email/success', $data, true);
                Form::flush();
            }
            else
            {
                // get html markup and display it
                $form = Form::get($form_array, $form_name);
                echo $form;
            }

        }
        // form is invalid, or hasn't been submitted
        else
        {
            // if there are default values, get them as an array here

            // get html markup and display it
            $form = Form::get($form_array, $form_name);
            echo $form;
        }
    }

    // do email stuff
    public function email($form, $form_name, $recipient, $post, $debug = FALSE)
    {
        $this->load->helper(array('url', 'form'));
        $this->load->library('email');
        $config['mailtype'] = 'html';

        $alt_msg = '';
        $user_message = '';

        $posted['form_name'] = $form_name;
        $posted['email'] = $post;
        $subject_line = '';


        $message = $this->load->view('form-email/template', $posted, true);

        $data['message'] = $message;
        
        $this->email->initialize($config);

        if (isset($post['name'])) {
            $name = $post['name'];
        } else if (isset($post['email'])) {
            $name = $post['email'];
        }

        $recipient = preg_split('/[, ;]/', $recipient);

        if (is_array($recipient))
        {
            $this->email->from($recipient[0], $form['recipient_name']);
        }
        else
        {
            $this->email->from($recipient, $form['recipient_name']);
        }
        
        $this->email->to($recipient);
        if (isset($post['email'])) {
            $this->email->cc($post['email']);
        }
        if (isset($name)) {
            $this->email->reply_to($post['email'], $name);
        }

        // use subject from data source if it is present. else, use heading value
        if(isset($post['name__subject'])){
            $this->email->subject($post['name__subject']);
        }
        else if (isset($form['subject'])) {
            $this->email->subject($form['subject']);
        }
        else{
            $subject_line = 'A New Request from ' . $form_name;
            $this->email->subject($subject_line);
        }

        $this->email->message($message);    
        $this->email->set_alt_message($alt_msg);
        
        if ($debug == true )
        {
            $data['result'] = 1;
            echo '<div class="alert"><strong>Debug mode:</strong> no email was sent.</div>';
        }
        else
        {
            $data['result'] = $this->email->send();
        }

        return $data;

    }

}