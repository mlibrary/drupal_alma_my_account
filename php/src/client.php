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
    public function put($url){
      return $this->send('PUT', $url);
    }

    public function post($url){
      return $this->send('POST', $url);
    }

    public function del($url){
      return $this->send('DELETE', $url);
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
