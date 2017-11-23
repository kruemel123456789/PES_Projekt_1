var spiel = browser_ballot_sol_gameContract.at(contract.address);

var event_join_success = spiel.join_success();
event_join_success.watch(function(error, result){
        if(!error){
            console.log('Erfolgreiche Anmeldung'  + '( Spieler Adresse: ' + result.args.player + ' )' );
        }
        else{
            console.log(error);
        }

    });

var event_pleaseUnlock = spiel.pleaseUnlock()
event_pleaseUnlock.watch(function(error, result){
        if(!error){
            console.log('Unlock bitte jetzt!');
        }
        else{
            console.log(error);
        }

    });

var event_Unlock_success = spiel.Unlock_success()
event_Unlock_success.watch(function(error, result){
        if(!error){
            console.log('Unlock war erfolgreich.'   + '( Spieler Adresse: ' + result.args.player + ' )' );
        }
        else{
            console.log('Unlock war nicht erfolgreich');
        }

    });

var event_winTheGame = spiel.winTheGame()
event_winTheGame.watch(function(error, result){
        if(!error){
            console.log('Spieler ' + result.args.win +' hat gewonnen.');
        }
        else{
            console.log('Fehler !');
        }

    });
