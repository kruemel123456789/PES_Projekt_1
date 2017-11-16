pragma solidity ^0.4.18;




contract mortal {
   /* Define variable owner of the type address */
   address owner;

   /* This function is executed at initialization and sets the owner of the contract */
   function mortal() { owner = msg.sender; }

   /* Function to recover the funds on the contract */
   function kill() { if (msg.sender == owner) selfdestruct(owner); }
}



contract game is mortal
{

 // Zum Debuggen
  uint256 constant debug = 1;

  //Spieler limit
  uint256 public playerLim = 2;
  // Spieleranzahl
  uint256 public playerCount = 0;
  // Einsatz + Pfand
  uint256 public minBid = 100;
  // Speicherung der Spieleradressen
  address[3] public storagePlayer;
  //Speichern des Tips
  uint256[3] public storageTip;
  //Speicherung des gewonnen Spielers
  uint256 public storageWinningPlayer;
  //gewinn Speichern
  uint256 public storageWinnings =0;
  //pfandbetrag
  uint256 public deposit = 90;

  string playerMin = "Noch zu wenig Spieler";
  string valueMin = "Zu wenig Einsatz geleistet!";
  string bothMin = "Zu wenig Einsatz geleistet und noch zu wenig Spieler";
  string beginTheGame = "Das Spiel kann losgehen";

  mapping (address => uint256) public balanceOf;

   // Erfolgreich teilnahme am Spiel
   // @param player
   event join_success(address player);

   // Es sind drei Spieler vorhanden, spiel kann beginnen
   //@param
   event game_begin(string s);

   // Es sind nicht genpgent Spieler vorhanden
   event playToMin(string t);

   //Spieler hat das Spiel gewonnen
   event winTheGame(string w, uint256 s, string asd);

   // Spieler melden sich an
   //@param value  - Einsatz + Pfand
   function join_game(uint256 tipNumber) payable{
       uint256 value = 100;
       if (debug == 0){
           value = msg.value;
       }

       //prüfen ob der Spieler schon dabei ist
        for (uint256 i=0; i<=playerLim;i++){
            if (storagePlayer[i] == msg.sender){
                revert();
            }
        }

       if ( playerLim < playerCount && value < minBid) {
           playToMin(bothMin);
           if(debug == 0){ revert(); }
       }
       else if(value < minBid ){
           playToMin(valueMin);
           if(debug == 0){ revert(); }

       }
       else if(playerLim < playerCount){
           playToMin(playerMin);
           if(debug == 0){ revert(); }
       }

       storagePlayer[playerCount] = msg.sender; //
       storageTip[playerCount] = tipNumber;
       jackpot(value);
       join_success(msg.sender);

       if (playerLim == playerCount){
           game_begin(beginTheGame);
           playGame();
       }
       playerCount = playerCount + 1;
   }

   //Gesamt Einsatz des Spiels (Jackpot)
   function jackpot(uint256 mount){
       storageWinnings += mount-deposit;
   }

   function playGame(){
       dreiGewinnt();
       returnWinnings();
       returnDeposit();
   }

   // Spiel 3-Gewinnt
   function dreiGewinnt(){
       uint256 sum = 0;
     for (uint256 i=0; i<=playerLim;i++){
         sum += storageTip[i];
     }
      storageWinningPlayer = sum%3;
   }

   // krypthografisches commitmentValue
   function commitment(uint number){

   }


   function returnWinnings() {
       balanceOf[storagePlayer[storageWinningPlayer]] += storageWinnings;
       storageWinnings = 0;
       winTheGame("Spieler " , storageWinningPlayer , " hat gewonnen");
   }

   function returnDeposit(){
        for (uint256 i=0; i<=playerLim;i++){
            balanceOf[storagePlayer[i]] += deposit;
        }
   }
}
