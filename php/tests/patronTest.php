<?php
require __DIR__ . "/../src/patron.php";
require __DIR__ . "/../tests/doubles/clientDouble.php";
use PHPUnit\Framework\TestCase;

class patronTest extends TestCase
{
     /**
     * @covers            \Patron::Login
     */
    public function testReturnsCorrectOutput(): void
    {
        $dbl = new ClientDouble([
          'get' => [ 
            '/users/heidibruss' => file_get_contents("tests/fixtures/heidi_user.json") 
           ]
         ]);
        $output = [
          "uniqname" => "heidibruss",
          "first_name" => "Heidi",
          "last_name" => "Bruss",
          "email" => "heidi@alma.net",
          "college" => null,
          "bor_status" => null,
          "booking_permission" => null,
          "campus" => null,
          "barcode" => null,
          "address_1" => "1350 E. Touhy Ave.",
          "address_2" => "#200E",
          "zip" => "",
          "phone" => "847-227-2200",
          "expires" => ""
        ];
        $p = new Patron('heidibruss', $dbl);
        $this->assertEquals(
            $output,
            $p->Login()
        );
    }
     /**
     * @covers            \Patron::Transactions
     */
    public function testReturnsCorrectTransactionsOutput(): void
    {
        $dbl = new ClientDouble([
          'get' => [ 
            '/users/heidibruss/loans' => file_get_contents("tests/fixtures/heidi_transactions.json") 
           ]
         ]);
        $output = [
          [
            "duedate" => "20200920 0359",
            "isbn" => "0199795134",
            "status" => "",
            "author" => "Fountain, Charles.",
            "title" => "The betrayal : the 1919 World Series and the birth of modern baseball / Charles Fountain.",
            "barcode" => "A1272204",
            "call_number" => "GV875.C58 F68 2015",
            "description" => null,
            "id" => "9930337800521",
            "bib_library" => "",
            "location" => "Main Library",
            "format" => [
              "Book"
            ],
            "num" => 0
          ],
          [
            "duedate" => "20191005 0000",
            "isbn" => "1423603877 (pbk.)",
            "status" => "",
            "author" => "Taylor, Nancy H.",
            "title" => "Go green : how to build an earth-friendly community / Nancy H. Taylor.",
            "barcode" => "15009452",
            "call_number" => "GE195 .T39 2008",
            "description" => null,
            "id" => "991301860000541",
            "bib_library" => "",
            "location" => "Science Library",
            "format" => [
              "Book"
            ],
            "num" => 1
          ]
        ];
        $p = new Patron('heidibruss', $dbl);
        $this->assertEquals(
            $output,
            $p->Transactions()
        );
    }
     /**
     * @covers            \Patron::Login
     */
    public function testReturnsCorrectOutput(): void
    {
        $dbl = new ClientDouble([
          'get' => [ 
            '/users/heidibruss' => file_get_contents("tests/fixtures/heidi_user.json") 
           ]
         ]);
        $output = [
          "uniqname" => "heidibruss",
          "first_name" => "Heidi",
          "last_name" => "Bruss",
          "email" => "heidi@alma.net",
          "college" => null,
          "bor_status" => null,
          "booking_permission" => null,
          "campus" => null,
          "barcode" => null,
          "address_1" => "1350 E. Touhy Ave.",
          "address_2" => "#200E",
          "zip" => "",
          "phone" => "847-227-2200",
          "expires" => ""
        ];
        $p = new Patron('heidibruss', $dbl);
        $this->assertEquals(
            $output,
            $p->Login()
        );
    }
    
}
?>
