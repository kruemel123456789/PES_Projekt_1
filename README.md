# PES_Projekt_1
Projektaufgabe 1

Pfand ist in Einsatz enthalten
Zahl zwischen 1 und 100



1. Teilnahme P_0, P_1, P_2 anmelden
    event zurück, wenn Teilnehmer akzeptiert(prüfen ob schon 3 Teilnehmer)
    event  an Alle zurück, wenn 3 Teilnehmer eingetragen
    
2. Teilnehmer leisten Einsatz(+Pfand) und Tipp
    event zurück, nach Prüfung ob genug Geld vorhanden und genug gesendet
    Tipps verschlüsseln    
 
3. Contract will Gewinner prüfen
    event an Alle zurück, wenn 3 Tipps, dann entschlüsseln
    Teilnehmer bekommen für entschlüsseln ihr Pfand zurück
    Gewinner ermitteln
    event ab Alle zurück, GEWINNER ist BLA
    
4. Gewinn abholen
    contract.getWinnings.sendTransaction(Passwort,{from:})
