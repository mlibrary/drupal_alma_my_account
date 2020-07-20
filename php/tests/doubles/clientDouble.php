<?
  class ClientDouble {
    // example requests['get']['/users/jbister'] = Json stirng
    public $requests = NULL;
    public function __construct($requests){
      $this->requests = $requests;
    } 
    
    public function get($url){
      return $this->requests['get'][$url];
    } 
  }

?>
