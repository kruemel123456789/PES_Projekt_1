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

 // Zum Debuggen (An -> 1 / Aus -> 0)
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
  uint256[3] public storageTip ;
  bytes32[3] public storageTipEncode;
  //Speicherung des gewonnen Spielers
  uint256 public storageWinningPlayer;
  //gewinn Speichern
  uint256 public storageWinnings =0;
  //pfandbetrag
  uint256 public deposit = 90;

  mapping (address => uint256) public balanceOf;

   // Erfolgreich teilnahme am Spiel
   // @param player
   event join_success(address player);

   // Ausgabe zum Debuggen
   event debugInfo(string t);

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
        for (uint256 i=0; i <= playerLim;i++){
            if (storagePlayer[i] == msg.sender){
                 if(debug == 0){ revert(); }
                 if(debug == 1){ debugInfo("Spieler schon vorhanden!" );return;}
            }
        }

       if ( playerLim < playerCount && value < minBid) {
          if(debug == 1){  debugInfo("Zu wenig Spieler und zu wenig Einsatz"); return;}
          if(debug == 0){ revert(); }
       }
       else if(value < minBid ){
           if(debug == 1){ debugInfo("Zu wenig Einsatz gezahlt");return;}
           if(debug == 0){ revert(); }

       }
       else if(playerLim < playerCount){
           if(debug == 1){ debugInfo("Noch zu wenig Spieler");return;}
           if(debug == 0){ revert(); }
       }

       storagePlayer[playerCount] = msg.sender; //
       storageTip[playerCount] = tipNumber;
       encoding(tipNumber);
       jackpot(value);
       join_success(msg.sender);

       if (playerLim == playerCount){
           if(debug == 1){ debugInfo("Spiel kann los gehen!");  }
           playGame();
       }
       else{
            playerCount = playerCount + 1;
       }

   }

   //Gesamt Einsatz des Spiels (Jackpot)
   function jackpot(uint256 mount){
       storageWinnings += mount-deposit;
   }

   // Spiel 3-Gewinnt
   function dreiGewinnt(){
       uint256 sum = 0;
     for (uint256 i=0; i<= playerLim;++i){
         sum += storageTip[i];
     }
      storageWinningPlayer = sum % 3;
   }

   // krypthografisches commitmentValue
   function encoding(uint256 number){

    bytes32 hash = keccak256(number);
    storageTipEncode[playerCount] = hash;
   }

   function decoding(){

   }


   function returnWinnings() {
       balanceOf[storagePlayer[storageWinningPlayer]] += storageWinnings;
       storageWinnings = 0;
       if(debug == 1){    winTheGame("Spieler " , storageWinningPlayer , " hat gewonnen");}
   }

   function returnDeposit(){
        for (uint256 i=0; i<=playerLim;i++){
            balanceOf[storagePlayer[i]] += deposit;
        }
   }

      function playGame(){
       dreiGewinnt();
       returnWinnings();
       returnDeposit();
   }

}
