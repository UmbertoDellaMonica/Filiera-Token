* - Per provare le varie funzionalità del MilkHubService abbiamo una suddivisione dei Metodi dove : 

- * invoke : si riferisce a tutti quei metodi che permettono di modificare un valore all'interno dello smart contract - Codice RESPONSE 202 o 200
- * query : si riferisce a tutti quei metodi che permettono di visualizzare o controllare un determinato dato all'interno dello smart contract - Codice 200 e restituisce sempre un oggetto 


- MilkHubService.registerUser ( params ): 
- email
- fullName
- password 
- wallet ( Auto Generato in maniera automatica da Ganache )

* Funzione inovke/registerUser e possiamo effettuare la nostra registrazione 

- FullName : Umberto DM
- email : umberto@gmail.com
- passowrd : ciao1002!
- wallet : 0x5aE254103EDe2E48F71876d4ED74358070C3296B



- MilkHubService.login ( params ) :
- email 
- password 
- wallet 
* Funzione query/login e possiamo effettuare il login : Restituisce True o False se i parametri non dovessero combaciare  