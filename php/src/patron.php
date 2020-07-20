<?php
  require_once('./src/client.php');
  class Patron {
    public $uniqname = NULL;
    public $client = NULL;

    public function __construct($uniqname, $client = NULL ){
      $this->uniqname = $uniqname;
      $this->client = (is_null($client)) ? new MyClient : $client;
    } 

    public function Login(){
      $url = "/users/{$this->uniqname}";
      $output = json_decode($this->client->get($url), TRUE);
      return $output;
    }

    public function Transactions(){
      $url = "/users/{$this->uniqname}/loans";
      $output = json_decode($this->client->get($url), TRUE);
      return $output;
    }
  }
?>
