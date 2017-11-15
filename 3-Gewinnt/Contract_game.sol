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

  //Spieler limit
  uint256 public playerLim = 2;
  // Spieleranzahl
  uint256 public playerCount = 0;
  // Einsatz + Pfand
  uint256 public minBid = 100;
  // Speicherung der Spieleradressen
  address[3] public storagePlayer;

   // Erfolgreich teilnahme am Spiel
   // @param player
   event join_success(address player);

   // Es sind drei Spieler vorhande
   //@param
   event game_begin();

   //@param valueEinsatz + Pfand
   function join_game(uint256 value){
     require(value > minBid && playerLim > playerCount);
     storagePlayer[playerCount] = msg.sender; //
     playerCount = playerCount + 1;
     join_success(msg.sender);

       if(playerLim == playerCount){
        game_begin();
       }
   }
}
