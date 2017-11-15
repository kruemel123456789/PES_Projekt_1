 pragma solidity ^0.4.18;


 contract join_game {

   //Spieler limit
   uint public playerlim = 2;
   // Spieleranzahl
   uint public playercount = 0;
   // Einsatz + Pfand
   uint public minbid = 100;
   // Speicherung der Spieleradressen
   address[] public storage_player;

   /**
    * Erfolgreich teilnahme am Spiel
    *
    * @param player
    */
   event join_success(address player);

   /**
    * Es sind drei Spieler vorhanden
    *
    * @param
    */
   event game_begin();

   /**
    * @param valueEinsatz + Pfand
    */
   function join_game(uint value) {

      require(value > minbid && playerlim > playercount )
      storage_player[playercount] = msg.sender; //
      playercount = playercount + 1;
      join_success(msg.sender);

      if(playerlim == playercount){
        game_begin();
     }
 }
