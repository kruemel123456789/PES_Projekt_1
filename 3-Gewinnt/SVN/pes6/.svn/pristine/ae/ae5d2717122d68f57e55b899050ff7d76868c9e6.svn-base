pragma solidity ^0.4.18;

/*
Um die Events nutzen zu können, sollte "Events.js" in einer eigenen Console geladen werden
*/


//Cotract um alle Ether aus dem Contract an den Owner zu schicken und den Contract zu löschen
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

//Contract für das eigentlich Spiel, erbt von mortal
contract game is mortal
{
	//region Variablen und Konstanten Deklaration
	
	// Zum Debuggen (An -> 1 / Aus -> 0)
	uint256 constant debug = 0;

	//Spielerlimit (0 -> 1 Spieler , 1 -> 2 Spieler , 2 -> 3 Spieler)
	uint256 private playerLim = 2;

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

	// Einsatz + Pfand (Wei to Ether)
	uint256 constant minBid = 1 * 1000000000000000000;

	//Pfandbetrag (Wei to Ether)
	uint256 constant deposit = 0.5 * 1000000000000000000;

	//Zeitpunkt, zu dem genung Mitspieler vorhanden sind
	uint256 startTime;
	
	//endregion

	//region Events
	
	/*
	Event bei erfolgreicher Teilnahme am Spiel
	@param player - Es wird die Adresse von Spieler ausgegeben
	*/
	event join_success(address player);

	/*
	Event zum Entschlüsseln
	*/
	event pleaseUnlock();

	/*
	Event bei erfolgreichem Entschlüsseln des Tips
	@param player - Es wird die Adresse von Spieler ausgegeben
	*/
	event Unlock_success(address player);

	/*
	Event welcher Spieler das Spiel gewonnen hat
	@param s - Spieler Nummer
	*/
	event winTheGame(uint256 win);
	
	/*
	Event bei erfolgreichem Abbruch
	*/
	event breakGame();
	
	/*
	Event bei erfolgreichem Reset
	*/
	event resetSuccess();
	
	//endregion

	//region lokale Funktionen

	/*Erzeugung des Hashwerts
	
	Zum Beginn des Spiels muss der Tip mit einem Codewort(nicht geheim) und der eigenen Adresse gehasht werde.
	Zum Hashen wird KECCAK256 verwendet.
	Der Returnwert der Funktion entspricht dem Hash.
	Der Hash muss bei Teilnahmewunsch durch die Funktion join_game() übergeben werden.
	
	Beispielhafter Aufruf:
	spiel.greateHash(123,"Codestring",'0x123adresse456')

	@param number -  Eingabe des Tips (Integer)
	@param passphrase - Eingabe von einem Codewort (String) als zusätzliche Sicherheit beim Ver- und Entschlüsseln
	@param sender - Adresse (adresse) des Spielers, der teilnehmen möchte
	@returns hash - Ergebnis-Hash (byte) des Algorithmus
	*/
	function greateHash(uint256 number, string passphrase,address sender) public constant returns (bytes32 hash)
	{
		return (keccak256(number, passphrase, sender));
	}
	
	//endregion
	
	//region globale Funktionen

    /*Beitritt zum Spiel
	
    Der Spieler tritt durch Aufruf der Funktion dem Spiel bei.
	Es muss der zuvor berechnete Hash übergeben werden.
	
	Die Funktion überprüft, ob der Spieler bereits beigetreten ist.
	Die Funktion überprüft, ob der Spieler genug Einsatz bezahlt hat.
	Die Funktion überprüft, ob nach Plätze frei sind.
	War dies erfolgreich werden Adresse und Hash des Spielers gespeichert.
	Außerdem wird der Einsatz zum Jackpot addiert und ein Event ausgelöst,
	da der Beitritt erfolgreich war.
	Ist die gewünschte Spielerzahl erreicht, so wird durch ein Event zum Entschlüsseln
	aufgefordert und die Zeit gespeichert
	Im letzen Schritt der Funktion wird die Spielerzahl erhöht
	
	Beispielhafter Aufruf:
	spiel.join_game.sendTransaction("0x123hashwer456",{from:'0x123adresse456', value: web3.toWei(1.0,"ether"), gas:1000000})

    @param hash  - Hashwert aus der Funktion greateHash()
    @returns s - Es wird der Text zu debug-Zwecken zurückgegeben
	*/
	function join_game(bytes32 hash ) payable public  returns (string s)
	{		
		//Einsatz speichern
		uint256 value = msg.value;

		//prüfen, ob der Spieler schon beigetreten ist
		for (uint256 i=0; i <= playerLim;i++)
		{
			if (storagePlayer[i] == msg.sender)
			{
				if(debug == 0){ revert(); }
				if(debug == 1){ return ("Spieler schon vorhanden!" );}
			}
		}
		
		//prüfen, ob noch Plätze im Spiel frei sind und ob genung Einsatz geleistet wurde
		if ( playerLim < playerCount && value < minBid)	//Zu viele Spieler und zu wenig Einsatz
		{
			if(debug == 1){  return ("Zu viele Spieler und zu wenig Einsatz");}
			if(debug == 0){ revert(); }
		}
		else if(value < minBid )						//Zu wenig Einsatz gezahlt
		{
			if(debug == 1){ return("Zu wenig Einsatz gezahlt");}
			if(debug == 0){ revert(); }

		}
		else if(playerLim < playerCount)				//Zu viele Spieler
		{
			if(debug == 1){ return("Zu viele Spieler");}
			if(debug == 0){ revert();}
		}
		
		//Adresse des Spielers speichern
		storagePlayer[playerCount] = msg.sender;
		
		//Hashwert des Spielers speichern
		storageTipEncode[playerCount] = hash;
		
		//Einsatz zum Jackpot addieren
		jackpot(value);
		
		//Event auslösen, da der Beitritt erfolgreich war
		join_success(msg.sender);

		//prüfen, ob schon genug Spieler vorhanden sind
		if (playerLim == playerCount)
		{
			//Event auslösen, um zum Entschlüsseln aufzufordern
			pleaseUnlock();

			//Zeitpunkt speichern, zudem der letzte Spieler begetreten ist
			startTime = now;
		}
		
		//Spielerzähler um eins erhöhen
		playerCount = playerCount + 1;
	}
	

	/*Entschlüsselung des Tips

	Funktion zur Entschlüsselung der Tips.
	Nur möglich falls genug Spieler, Spieler begetreten, Spieler noch nicht entschtlüsselt und Eingabe korrekt.
	Dann werden Tipp und Nummer des Spielers gespeichert und das Pfand zurück gezahlt.
	Haben alle Spieler entschtlüsselt, wird der Gewinner ermittelt und ausbezahlt.
	Anschließend wird das Spiel zurückgesetzt.
	
	Beispielhafter Aufruf:
	spiel.unlockTips.sendTransaction(123,"Codestring",{from:'0x123adresse456', gas:1000000})
	
	@param tipNumber -  Eingabe des Tips (Integer)
	@param passphrase - Eingabe von einem Codewort (String) als zusätzliche Sicherheit beim Ver- und Entschlüsseln
	*/
	function unlockTips(uint256 tipNumber, string passphrase) payable public
	{
		//nur möglich falls gewünschte Spieleranzahl erreicht
		if (playerLim > (playerCount-1))
		{
			if(debug == 0){ revert();}
		}
		
		//Spielernummer für "Spieler nicht vorhanden"
		uint256 playerNum = 999;
		
		//Array der Adressen durchsuchen und bei übereinstimmung mit der akutellen Adresse die Stelle ausgeben
		for (uint256 i=0; i <= playerLim; i++)
		{
			if(storagePlayer[i] == msg.sender)
			{
				playerNum = i;
			}
		}
		
		/*
		Es dürfen nur Spieler entschlüsseln, die Teilnehmer sind.
		Deshalb muss überprüft werden ob die Adresse des Spielers gespeichert ist.
		Ist die Adresse unbekannt wird die Funktion abgebrochen
		*/
		if (playerNum == 999)
		{
			if(debug == 0){ revert(); }
		}

		//Sicherstellen, dass jeder Spieler nur einmal entschlüsseln kann
		if(unlockDone[0] != playerNum ||unlockDone[1] != playerNum ||unlockDone[2] != playerNum)
		{
			//Hashwert für den Vergleich berechnen
			bytes32 newUnlock = keccak256(tipNumber, passphrase, msg.sender);
			
			//falls geschickter Hash und berechneter Hash identisch sind, wird der Tip zwischengespeichert
			if (newUnlock == storageTipEncode[playerNum])
			{
				uint256 number = tipNumber;
			}
			else	//sonst wird die Transaction rückgängig gemacht
			{
				if(debug == 0){ revert(); }
			}
			
			//Speichern des Tipps im Array
			storageTip[playerNum] = number;
			
			//Speichern der Spielerzahl, die entschtlüsselt hat
			unlockDone[unlockCount] = playerNum;
			
			//Erhöhen des Unlock-Zählers
			unlockCount +=1;
			
			//Bei Erfolg gibts das Pfand zurück und ein Event wird ausgelöst
			returnDeposit(playerNum);
			Unlock_success(msg.sender);
		}
		
		else	//sonst wird die Transaction rückgängig gemacht
		{
			revert();
		}

		/*
		Wenn alle Spieler entschtlüsselt haben wird der Gewinner berechnet.
		An diesen wird dann der Gewinn ausbezahlt und anschließend das Spiel zurück gesetzt
		*/
		if(unlockCount == playerLim+1)
		{
			dreiGewinnt();
			returnWinnings();
			resetGame();
		}
	}
	
	
	/*Reset des Spiels
	
	Kann nur vom Besitzer des Contracts aufgerufen werden.
	Kann nur aufgerufen werden solange nicht alle Spieler entschtlüsselt haben.
	Kann erst drei Minuten nachdem der letzte Spieler beigetreten ist aufgerufen werden.
	Jackpot und verbliebenes Pfand werden gleich unter allen Spielern aufgeteilt, die schon entschtlüsselt haben.
	Dann wird das Spiel zurück gesetzt.
	
	Beispielhafter Aufruf:
	spiel.checkTime.sendTransaction({from:'0x123adresse456', gas:1000000})
	*/	
	function checkTime()public
	{
		if (msg.sender == owner)
		{
			if(unlockCount < (playerLim + 1))
			{
				if((startTime + 5 minutes) <= now)
				{
					uint256 sum;
					sum = (storageWinnings + deposit * ( (playerLim + 1) - unlockCount) )/ unlockCount;
					for(uint256 a=0 ; a < unlockCount ; a++)
					{
						storagePlayer[unlockDone[a]].transfer(sum);
					}
					resetGame();
				}
				else
				{
					revert();
				}
			}
			else
			{
				revert();
			}
			breakGame();
		}
	}
   
	//endregion
   
	//region private Funktionen

	/*Erstellung des Jackpots
	
	Gesamter Einsatz aller Spieler (Jackpot) wird zusammengerechnet.
	Das Pfand wird separat verwaltet und kommt nicht in den Jackpot.
	Der Jackpot wird in "storageWinnings" gespeichert.

	@param amount - Es wird der Einsatz (inklusive Pfand) übergeben
	*/
	function jackpot(uint256 amount) private
	{
		storageWinnings = storageWinnings + (amount - deposit);
	}

	
	/*Berechnung des Gewinners
	
	Alle abgegeben Tips werden aufsummiert.
	Daraus wird durch eine Modulo-Operation in Höhe der Spielerzahl der Gewinner ermittelt.
	Die Nummer des Gewinners wird in "storageWinningPlayer" gespeichert.
	*/
	function dreiGewinnt() private
	{
		// Variable für die Summe aller abgegebenen Tips
		uint256 sum = 0;
		
		//Summierung aller abgegebenen Tips
		for (uint256 i=0 ; i <= playerLim ; i++)
		{
			sum += storageTip[i];
		}
		storageWinningPlayer = sum % (playerLim+1);
	}


	/*Bekanntgabe des Gewinners
	
	Die Adresse des Gewinners wird ausgelesen.
	An diese wird dann der Jackpot überwiesen.
	Zusätzlich wird ein Event zur Bekanntgabe des Gewinners ausgelöst.
	*/
	function returnWinnings() private
	{
		storagePlayer[storageWinningPlayer].transfer(storageWinnings);
		winTheGame(storageWinningPlayer);
	}

	
	/*Pfandrückzahlung
	
	Das Pfand wird einem passenden Spieler zurück gezahlt.

	@param playerNum -  Nummer des passenden Spielers
	*/
	function returnDeposit(uint256 playerNum) private
	{
		storagePlayer[playerNum].transfer(deposit);
	}

	
	/*Reset des Spiels
	
	Beim Beenden des Spiels sollen alle Werte zurückgesetzt, sodass erneut gespielt werden kann.
	*/
	function resetGame() private
	{
		// Spieleranzahl
		playerCount = 0;
		
		//Unlockanzahl
		unlockCount = 0;
		
		//Zurücksetzten der Speicher-Arrays
		delete storagePlayer;
		delete storageTip;
		delete storageTipEncode;

		//Zurücksetzten des Jackpots
		storageWinnings =0;
		
		//Event zum Spielende
		resetSuccess();
	}

	//endregion
}
