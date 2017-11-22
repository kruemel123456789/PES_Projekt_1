pragma solidity ^0.4.18;




contract mortal {
   /* Define variable owner of the type address */
   address owner;

   /* This function is executed at initialization and sets the owner of the contract */
   function mortal() public { owner = msg.sender; }

   /* Function to recover the funds on the contract */
   function kill() public {
       if (msg.sender == owner) selfdestruct(owner);
       else revert();
   }
}

contract game is mortal
{
 // Zum Debuggen (An -> 1 / Aus -> 0)
  uint256 constant debug = 0;

  //Spieler limit
  uint256 private playerLim = 1;
  // Spieleranzahl
  uint256 private playerCount = 0;
  //Unlockanzahl
  uint256 private unlockCount = 0;
  // Speicherung der Spieleradressen
  address[3] private storagePlayer;
  //Speichern des Tips
  uint256[3] private storageTip ;
  bytes32[3] private storageTipEncode;
  uint256[3] private unlockDone;
  //Speicherung des gewonnen Spielers
  uint256  storageWinningPlayer ;
  //gewinn Speichern
  uint256 private storageWinnings = 0;
  // Einsatz + Pfand
  uint256 constant minBid = 1 * 1000000000000000000;
  //pfandbetrag
  uint256 constant deposit = 0.5 * 1000000000000000000;

   // Erfolgreich teilnahme am Spiel
   // @param player
   event join_success(address player);

   // Ausgabe zum Debuggen
   //event debugInfo(string t);

   //Aufruf zum entschlüsseln
   event pleaseUnlock(string u);

   //Erfolgreiches Unlocken
   event Unlock_success(address player);

   //Spieler hat das Spiel gewonnen
   event winTheGame(string w, uint256 s, string asd);


   function greateHash(uint256 number, string passphrase) public constant returns (bytes32 hash){
       return (keccak256(number, passphrase, msg.sender));
   }

   // Spieler melden sich an
   //@param value  - Einsatz + Pfand
   function join_game(bytes32 hash ) payable public  returns (string s) {
       uint256 value = 100;
       if (debug == 0){
           value = msg.value;
       }

       //prüfen ob der Spieler schon dabei ist
        for (uint256 i=0; i <= playerLim;i++){
            if (storagePlayer[i] == msg.sender){
                 if(debug == 0){ revert(); }
                 if(debug == 1){ return ("Spieler schon vorhanden!" );}
            }
        }

       if ( playerLim < playerCount && value < minBid) {
          if(debug == 1){  return ("Zu wenig Spieler und zu wenig Einsatz");}
          if(debug == 0){ revert(); }
       }
       else if(value < minBid ){
           if(debug == 1){ return("Zu wenig Einsatz gezahlt");}
           if(debug == 0){ revert(); }

       }
       else if(playerLim < playerCount){
           if(debug == 1){ return("Zu viele Spieler");}
           if(debug == 0){ revert();}
       }

       storagePlayer[playerCount] = msg.sender; //
       storageTipEncode[playerCount] = hash;
       jackpot(value);
       join_success(msg.sender);

       if (playerLim == playerCount){
          pleaseUnlock("Bitte unlockTips() aufrufen");
       }
        playerCount = playerCount + 1;

   }

   function unlockTips(uint256 tipNumber, string passphrase) payable public {
       //nur möglich falls 3 Spieler
       if (playerLim > playerCount){
           if(debug == 0){ revert();}

       }
       //Jeder Spieler muss entschlüsseln
       uint256 playerNum = 99;
       for (uint256 i=0; i <= playerLim; i++){
           if(storagePlayer[i] == msg.sender){
                playerNum = i;
           }
       }
       if (playerNum == 99)
       {
            if(debug == 0){ revert(); }
       }


       if(unlockDone[0] != playerNum ||unlockDone[1] != playerNum ||unlockDone[2] != playerNum){
           storageTip[playerNum] = decoding(tipNumber, passphrase, storageTipEncode[playerNum]);
           unlockCount +=1;
           unlockDone[unlockCount] = playerNum;
           //Bei Erfolg gibts Pfand zurück
           returnDeposit(playerNum);
           Unlock_success(msg.sender);
        }


       //wenn alle drei entschtlüsselt haben, gewinn auszahlen
       if(unlockCount == playerLim+1){
            dreiGewinnt();
            returnWinnings();
            resetGame();
       }
   }

   //Gesamt Einsatz des Spiels (Jackpot)
   function jackpot(uint256 mount) private {
       storageWinnings += mount-deposit;
   }

   // Spiel 3-Gewinnt
   function dreiGewinnt() private {
       uint256 sum = 0;
     for (uint256 i=0; i <= playerLim; i++){
         sum += storageTip[i];
     }
      storageWinningPlayer = sum % (playerLim+1);
   }

   // krypthografisches commitmentValue
   function encoding(uint256 number, string passphrase) private returns (bytes32 hash){
    return  keccak256(number, passphrase, msg.sender);
   }

   function decoding(uint256 number, string passphrase, bytes32 oldHash) private returns (uint256 tip){
       bytes32 newUnlock= keccak256(number, passphrase, msg.sender);
       if (newUnlock == oldHash){
            return number;
       }
       else
       {
            if(debug == 0){ revert(); }
       }
   }


   function returnWinnings() private{
       storagePlayer[storageWinningPlayer].transfer(storageWinnings);
       winTheGame("Spieler " , storageWinningPlayer , " hat gewonnen");
   }

   function returnDeposit(uint256 playerNum) private {
            storagePlayer[playerNum].transfer(deposit);
   }

   function resetGame() private {

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
