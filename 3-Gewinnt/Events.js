
var browser_ballot_sol_gameContract =
web3.eth.contract([{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"hash","type":"bytes32"}],"name":"join_game","outputs":[{"name":"s","type":"string"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[{"name":"tipNumber","type":"uint256"},{"name":"passphrase","type":"string"}],"name":"unlockTips","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"number","type":"uint256"},{"name":"passphrase","type":"string"},{"name":"sender","type":"address"}],"name":"greateHash","outputs":[{"name":"hash","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"checkTime","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"player","type":"address"}],"name":"join_success","type":"event"},{"anonymous":false,"inputs":[],"name":"pleaseUnlock","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"player","type":"address"}],"name":"Unlock_success","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"win","type":"uint256"}],"name":"winTheGame","type":"event"},{"anonymous":false,"inputs":[],"name":"breakGame","type":"event"},{"anonymous":false,"inputs":[],"name":"resetSuccess","type":"event"}]);


//Addresse von dem Contract eintragen
var game = browser_ballot_sol_gameContract.at('0x8a397a9103b139f8b75af8344eaf078a02e99a2b');

var event_join_success = game.join_success();
event_join_success.watch(function(error, result)
{
  if(!error)
  {
      console.log('Erfolgreiche Anmeldung'  + '(Spieler Adresse: ' + result.args.player + ')' );
  }
  else
  {
      console.log('Fehler');
  }

});

var event_pleaseUnlock = game.pleaseUnlock()
event_pleaseUnlock.watch(function(error, result)
{
  if(!error)
  {
      console.log('Unlock bitte jetzt!');
  }
  else
  {
      console.log('Fehler');
  }

});

var event_Unlock_success = game.Unlock_success()
event_Unlock_success.watch(function(error, result)
{
  if(!error)
  {
      console.log('Unlock war erfolgreich.'   + '(Spieler Adresse: ' + result.args.player + ')' );
  }
  else{
      console.log('Unlock war nicht erfolgreich');
  }

});

var event_winTheGame = game.winTheGame()
event_winTheGame.watch(function(error, result)
{
  if(!error)
  {
      console.log('Spieler ' + result.args.win +' hat gewonnen.');
  }
  else{
      console.log('Fehler !');
  }

});


var event_breakGame = game.breakGame()
event_breakGame.watch(function(error, result)
{
  if(!error){
      console.log('Spiel nach 3 Minuten unterbrochen!');
  }
  else{
      console.log('Fehler !');
  }

});


var event_resetSuccess = game.resetSuccess()
event_resetSuccess.watch(function(error, result)
{
        if(!error)
        {
            console.log('Zurücksetzten war erfolgreich!');
        }
        else{
            console.log('Fehler !');
        }

    });
