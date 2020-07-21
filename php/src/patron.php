<?php
  require_once('./src/client.php');
  class Patron {
    public $uniqname = NULL;
    public $client = NULL;

    public function __construct($uniqname, $client = NULL ){
      $this->uniqname = $uniqname;
      $this->client = (is_null($client)) ? new Client : $client;
    } 

    //public function getCheckoutHistory(){
    //}

    public function getPatronFines(){
      $url = "/users/{$this->uniqname}/fines";
      return $this->get($url);
    }

    public function payPatronFines($amount, $reference){
      $url = "/users/{$this->uniqname}/fines?amount={$amount}&reference={$reference}";
      return $this->put($url);
    }

    //public function setSMS($sms_number){
    //}

    //public function getSMS(){
    //}
  
    public function Login(){
      $url = "/users/{$this->uniqname}";
      return $this->get($url);
    }

    public function Transactions(){
      $url = "/users/{$this->uniqname}/loans";
      return $this->get($url);
    }

    public function Holds(){
      $url = "/users/{$this->uniqname}/requests";
      return $this->get($url);
    }

    public function Fines(){
      $url = "/users/{$this->uniqname}/fines";
      return $this->get($url);
    }

    public function Renew($barcode){
      $url = "/users/{$this->uniqname}/loans/{$barcode}/renew";
      return $this->post($url);
    }

    public function CancelHold($request_id){
      $url = "/users/{$this->uniqname}/requests/{$request_id}";
      return $this->del($url);
    }
    
    private function get($url){
      return json_decode($this->client->get($url), TRUE);
    }
    private function put($url){
      return json_decode($this->client->put($url), TRUE);
    }
    private function del($url){
      return json_decode($this->client->del($url), TRUE);
    }
    private function post($url){
      return json_decode($this->client->post($url), TRUE);
    }
  }
?>
