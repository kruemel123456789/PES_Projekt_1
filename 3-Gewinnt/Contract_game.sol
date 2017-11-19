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
  uint256 constant debug = 0;

  //Spieler limit
  uint256 public playerLim = 2;
  // Spieleranzahl
  uint256 public playerCount = 0;
  //Unlockanzahl
  uint256 public unlockCount = 0;
  // Einsatz + Pfand
  uint256 public minBid = 10 * 1000000000000000000;
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
  uint256 public deposit = 9 * 1000000000000000000;

  mapping (address => uint256) public balanceOf;

   // Erfolgreich teilnahme am Spiel
   // @param player
   event join_success(address player);

   // Ausgabe zum Debuggen
   event debugInfo(string t);
   
   //Aufruf zum entschlüsseln
   event pleaseUnlock(string u);

   //Spieler hat das Spiel gewonnen
   event winTheGame(string w, uint256 s, string asd);

   // Spieler melden sich an
   //@param value  - Einsatz + Pfand
   function join_game(uint256 tipNumber, string passphrase) payable{
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
           if(debug == 1){ debugInfo("Zu viele Spieler");return;}
           if(debug == 0){ revert();}
       }

       storagePlayer[playerCount] = msg.sender; //
       storageTipEncode[playerCount] = encoding(tipNumber,passphrase);
       jackpot(value);
       join_success(msg.sender);

       if (playerLim == playerCount){
           if(debug == 1){ debugInfo("Spiel kann los gehen!");  }
           pleaseUnlock("Bitte unlockTips() aufrufen");
           
       }
        playerCount = playerCount + 1;

   }
   
   function unlockTips(uint256 tipNumber, string passphrase) payable{
       //Jeder Spieler muss entschlüsseln
       uint256 playerNum = 99;
       for (uint256 i=0; i <= playerLim;i++){
           if(storagePlayer[i] == msg.sender){
                playerNum = i;
           }
       }
       if (playerNum == 99)
       {
            if(debug == 1){  debugInfo("Spieler ist kein Teilnehmer"); return;}
            if(debug == 0){ revert(); }
       }
       storageTip[playerNum] = decoding(tipNumber, passphrase, storageTipEncode[playerNum]);
       unlockCount +=1;
       //Bei Erfolg gibts Pfand zurück
       returnDeposit(playerNum);
       //wenn alle drei entschtlüsselt haben, gewinn auszahlen
       if(unlockCount == 3){
            dreiGewinnt();
            returnWinnings();
            resetGame();
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
   function encoding(uint256 number, string passphrase) private returns (bytes32){
    return  keccak256(number, passphrase, msg.sender);
   }

   function decoding(uint256 number, string passphrase, bytes32 oldHash) private returns (uint256 tip){
       bytes32 newUnlock= keccak256(number, passphrase, msg.sender);
       if (newUnlock == oldHash){
           if(debug == 1){  debugInfo("Unlock erfolgreich");}
            return number;
       }
       else
       {
            if(debug == 1){  debugInfo("Falsche Nummer oder passphrase"); return;}
            if(debug == 0){ revert(); }
       }
   }


   function returnWinnings()payable {
       storagePlayer[storageWinningPlayer].transfer(storageWinnings);
       winTheGame("Spieler " , storageWinningPlayer , " hat gewonnen");
   }

   function returnDeposit(uint256 playerNum)payable{
            storagePlayer[playerNum].transfer(deposit);
   }
   
   function resetGame(){
      // Spieleranzahl
      playerCount = 0;
      //Unlockanzahl
      unlockCount = 0;

      delete storagePlayer;
      delete storageTip;
      delete storageTipEncode;
         
      //gewinn Speichern
      storageWinnings =0;
   }

}
