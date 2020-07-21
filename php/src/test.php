<?php
  //require_once('./src/client.php');

  //$client = new Client;
  //$output = $client->get('/users/heidi.bruss/loans');
  //echo gettype($output);
  
  require_once('./src/patron.php');

  $p = new Patron('heidi.bruss');
  print_r($p->Transactions());
  print_r($p->CancelHold('1372360500006381'));
 // print_r($p->payPatronFines('10','blahblah'));
?>
