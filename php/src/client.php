<?
  class Client {
    public $host = "http://web:3000";
    public function __construct(){
    } 
    public function get($url){
      $timeout = ini_get('default_socket_timeout');
      ini_set('default_socket_timeout', 360);
      $data = file_get_contents("{$this->host}{$url}"); 
      ini_set('default_socket_timeout', $timeout);
      return $data;
    }
  }
?>
