<?php
  class Client {
    public $host = "http://web:3000";
    public function __construct(){
    } 
    public function get($url){
      $requests = [
	     // '/users/UNIQNAME' => '{"errorsExist":true,"errorList":{"error":[{"errorCode":"401861","errorMessage":"User with identifier blah was not found.","trackingId":"E01-2907122924-BMB9Y-AWAE128734075"}]},"result":null}',
	      '/users/UNIQNAME/loans' => '[{"duedate":"20200920 0359","isbn":"0199795134","status":"","author":"Fountain, Charles.","title":"The betrayal : the 1919 World Series and the birth of modern baseball / Charles Fountain.","barcode":"A1272204","call_number":"GV875.C58 F68 2015","description":null,"id":"9930337800521","bib_library":"","location":"Main Library","format":["Book"],"num":0},{"duedate":"20200920 0359","isbn":"1423603877 (pbk.)","status":"","author":"Taylor, Nancy H.","title":"Go green : how to build an earth-friendly community / Nancy H. Taylor.","barcode":"15009452","call_number":"GE195 .T39 2008","description":null,"id":"991301860000541","bib_library":"","location":"Science Library","format":["Book"],"num":1}]',
	      '/users/UNIQNAME/requests' => '{"B":[{"title":"Orange roofs, golden arches : the architecture of American chain restaurants / Philip Langdon.","author":"Langdon, Philip.","isbn":"","type":"B-03","status":"NOT_STARTED","id":"991244320000541","hold_rec_key":"1372379300006381","barcode":null,"pickup_loc":"Main Library","location":"","call_number":"","description":"","expires":"","created":"07/22/2020","booking_start":"07/24/2020 04:00 PM","booking_end":"08/03/2020 03:59 AM"}],"H":[{"title":"The social life of language / Gillian Sankoff.","author":"Sankoff, Gillian.","isbn":"","type":"H-03","status":"IN_PROCESS","id":"991040390000541","hold_rec_key":"1372348190006381","barcode":null,"pickup_loc":"Music Library","location":"Main Library","call_number":"","description":"","expires":"07/22/2020","created":"07/16/2020","booking_start":"","booking_end":""}]}',
	      '/users/UNIQNAME/fines' => '{"count":1,"amount":1.83,"charges":[{"author":"Langdon, Philip.","barcode":"69218","date":"20171013","fine":1.83,"fine_description":"Overdue fine","href":"https://api-na.hosted.exlibrisgroup.com/almaws/v1/users/heidi.bruss/fees/1299725720000521","id":"991244320000541","library":"Main Library","payment_cataloger":"","status":"Active","sub_library":"Main Library","title":"Orange roofs, golden arches : the architecture of American chain restaurants / Philip Langdon.","type":"OVERDUEFINE","value":"(1.83)"}],"payments":[{"transaction":"46010000521"},{"transaction":"blahblah"}]}',
	      '/users/UNIQNAME' => '{"uniqname":"heidi.bruss","first_name":"Heidi","last_name":"Bruss","email":"heidi@alma.net","college":null,"bor_status":null,"booking_permission":null,"campus":null,"barcode":null,"address_1":"1350 E. Touhy Ave.","address_2":"#200E","zip":"","phone":"847-227-2200","expires":"20220722"}'
      ];
      	
      return $requests[$this->strip_uniqname($url)];
    }
    public function put($url){
      return $this->send('PUT', $url);
    }

    public function post($url){
      $requests = [
        '/users/UNIQNAME/loans/15009452/renew' => '{"body":"Renewed: item renewed","status":200}',
	'/users/UNIQNAME/loans/A1272204/renew' => '{"body":"Not Renewed: Cannot renew loan:  1346144360000521 - Item renew period exceeded.","status":400}'
      ];
      return $requests[$url];
    }

    public function del($url){
      $requests =  [
        '/users/UNIQNAME/requests/1372348190006381' => true
      ];
      return $requests[$url];
    }
  
    private function strip_uniqname($url){
      return preg_replace('/\/users\/\w+/','/users/UNIQNAME',$url);
    }
    private function send($method, $url){
       $options = [
         'http' => [
           'method' => $method 
         ]
       ];
       $context = stream_context_create($options);
       print_r($context->http);
       $timeout = ini_get('default_socket_timeout');
       ini_set('default_socket_timeout', 360);
       $data =  file_get_contents("{$this->host}{$url}", false, $context);
       ini_set('default_socket_timeout', $timeout);
       return $data;
    }

  }
?>
