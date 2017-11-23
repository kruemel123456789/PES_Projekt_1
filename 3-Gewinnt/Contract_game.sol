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

  //Spielerlimit (0 -> 1 Spieler , 1 -> 2 Spieler , 2 -> 3 Spieler)
  uint256 private playerLim = 1;

  // Spieleranzahl
  uint256 private playerCount = 0;

  //Unlockanzahl
  uint256 private unlockCount = 0;

  // Speicherung der Spieleradressen
  address[3] private storagePlayer;

  //Speichern des Tips
  uint256[3] private storageTip ;

  //Sperichern des Hashwert von Tip
  bytes32[3] private storageTipEncode;

  //Speichern der ausgelogten Spieler
  uint256[3] private unlockDone;

  //Speicherung des gewonnen Spielers
  uint256  storageWinningPlayer ;

  // Gewinn teile
   uint256 storageDividier;

  //Gesamt Gewinn Speichern
  uint256 private storageWinnings = 0;

  // Einsatz + Pfand
  uint256 constant minBid = 1 * 1000000000000000000;

  //Pfandbetrag
  uint256 constant deposit = 0.5 * 1000000000000000000;


    uint256 startTime;

    /*
    Event bei rrfolgreiche Teilnahme am Spiel

    @param player - Es wird die Adresse von Spieler ausgegeben
   */
   event join_success(address player);

    /*
    Event bei der Ausgabe zum Debuggen

    @param  u - Es wird die Debuginformation ausgegeben
    */
   //event debugInfo(string t);

   /*
   Event zum Entschlüsseln

   @param u - Es wird die Ausgabe ausgegeben
   */
   event pleaseUnlock();

   /*
   Event zum erfolgreiches Entschlüsseln

   @param player -
   */
   event Unlock_success(address player);

   /*
   Event welcher Spieler das Spiel gewonnen hat

   @param s - Spieler Nummer
   */
   event winTheGame(uint256 win);


   /*
   Zum beginn wird der Tip und ein Passwort angelegt. Diese zwei Parameter werden mit
   der Hash Funktion KECCAK256 Verschlüsselt und für das Spiel verwendet.

   @param number -  Eingabe der Tip Zahl
   @param passphrase - Eingabe von einem Passwort als Text zum Ver-Entschlüsseln
   @returns hash - Es wird der Verschlüsselte Hex Wert zurückgegeben
   @return -
   */
   function greateHash(uint256 number, string passphrase,address sender) public constant returns (bytes32 hash){
      return (keccak256(number, passphrase, sender));
   }

    /*
    Es meldet sich der Spieler  mit seinem Verschlüsselten Tip und Passwort an.

    @param hash  - Verschlüsselter Tip und Passwort von der Funktion greateHash()
    @returns s - Es wird der Text zurückgegeben
   */
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
          pleaseUnlock();

          //Timout nach 1 Minute
          startTime = now;
       }

        playerCount = playerCount + 1;

   }

   function checkTime()public {
       if (msg.sender == owner){
            if(unlockCount < (playerLim)){
                if((startTime + 3 minutes) <= now){
                    uint256 sum;
                    sum = (storageWinnings + deposit * (playerLim - unlockCount) )/ playerCount;
                    for(uint256 a=0; a <= unlockCount;a++){
                        storagePlayer[unlockDone[a]].transfer(sum);
                    }
                    resetGame();
                }
                else{
                    revert();
                }
            }
            else{
                revert();
            }
       }
   }

   /*
   Es wird mit dem verwendeten Tip und Passwort wieder Entschlüsselt.

   @param tipNumber -
   @param passphrase -
   */

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
      bytes32 newUnlock= keccak256(tipNumber, passphrase, msg.sender);
        if (newUnlock == storageTipEncode[playerNum]){
           uint256 number = tipNumber;
        }
        else{
              if(debug == 0){ revert(); }
        }

       storageTip[playerNum] = number;
       unlockCount +=1;
       unlockDone[unlockCount] = playerNum;
       //Bei Erfolg gibts Pfand zurück
       returnDeposit(playerNum);
       Unlock_success(msg.sender);
      }
      else{
          revert();
      }

    //wenn alle drei entschtlüsselt haben, gewinn auszahlen
      if(unlockCount == playerLim+1){
        dreiGewinnt();
        returnWinnings();
        resetGame();
      }
   }

   /*
   Gesamt Einsatz des Spiels (Jackpot)
   Es wird von dem Gewinn der Pfand abgezogen.

   @param mount - Es wird der Einsatz übergeben
   */
   function jackpot(uint256 mount) private {
     storageWinnings += mount - deposit;
   }

   /*
   "Spieldurchführung"
   Es wird aus der Summe aller Tips durch Modulo der gewinner  Spieler ermittelt.
   */
   function dreiGewinnt() private {
     // Variable für die Summe aller Tip abgaben.
     uint256 sum = 0;
     for (uint256 i=0; i <= playerLim; i++){
         sum += storageTip[i];
     }
     storageWinningPlayer = sum % (playerLim+1);
   }


   /*
   Es wird dem Gewinner der Jackpot überwiesen.
   */
   function returnWinnings() private{
     storagePlayer[storageWinningPlayer].transfer(storageWinnings);
     winTheGame(storageWinningPlayer );
   }

   /*
   Es wird dem Spieler sein Pfand zurück gezahlt.

   @param playerNum -  Der jeweilige Spieler wird übergeben.
   */
   function returnDeposit(uint256 playerNum) private {
     storagePlayer[playerNum].transfer(deposit);
   }

   /*
   Beim beenden des Spiel werden alle Werte zurückgesetzt.
   */
   function resetGame() private {
      // Spieleranzahl
      playerCount = 0;
      //Unlockanzahl
      unlockCount = 0;
      //Zurücksetzten der Speicher
      delete storagePlayer;
      delete storageTip;
      delete storageTipEncode;

      //Zurücksetzten von der Gewinn Variablen
      storageWinnings =0;
   }
}
