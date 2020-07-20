<?php
  //require_once('./src/client.php');

  //$client = new Client;
  //$output = $client->get('/users/heidi.bruss/loans');
  //echo gettype($output);
  
  require_once('./src/patron.php');

  $p = new Patron('heidi.bruss');
  print_r($p->Transactions());
?>
