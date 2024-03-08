//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "../IUserStorageInterface.sol";

contract CheeseProducerStorage is IUserStorageInterface {

    // Address of Organization che gestisce gli utenti
    address private  CheeseProducerOrg;


    constructor(){
        CheeseProducerOrg = msg.sender;
    }


    // Struttura per rappresentare gli attributi di un consumatore
    struct CheeseProducer {
        uint256 id;
        string fullName;
        string password; // Si presume che sia già crittografata dal Front-End
        string email;
        uint256 balance;
    }

    // Mapping che collega l'indirizzo del portafoglio (wallet address) ai dati del consumatore
    mapping(address => CheeseProducer) private  cheeseProducers;

    address[ ] private addressList;

    /**
     * addUser() effettuiamo la registrazione dell'utente CheeseProducer 
     */
    function addUser(string memory _fullName, string memory _password,string memory _email, address walletCheeseProducer) external {
                
        // Genera l'ID manualmente utilizzando keccak256
        bytes32 idHash = ripemd160(abi.encodePacked(_fullName, _password, _email, walletCheeseProducer)); // Produce un hash di 20 byte
        uint256 lastIdCheeseProducer = uint256(idHash);

        require(cheeseProducers[walletCheeseProducer].id == 0, "CheeseProducer already registered");
        require(bytes(_fullName).length > 0, "Full name cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        require(address(walletCheeseProducer)!=address(0),"Address cannot be empty");
        
        // Crea un nuovo consumatore con l'ID univoco
        CheeseProducer memory newCheeseProducer = CheeseProducer({
            id: lastIdCheeseProducer,
            fullName: _fullName,
            password: _password,
            email: _email,
            balance: 100
        });
        // Inserisco l'address 
        addressList.push(walletCheeseProducer);

        // Inserisce il nuovo cheeseProducer all'interno della Lista dei CheeseProducer 
        cheeseProducers[walletCheeseProducer] = newCheeseProducer;
    }

    /**
     * LoginUser() effettua il login dell'utente 
     * La comparazione Hash tra (email e password) di input e quelli salvati
     * return true se la comparazione è vera, La comparazione è falsa se l'hashing non risulta valido
     */
    function loginUser(address walletCheeseProducer, string memory _email, string memory _password) external view returns(bool){

        // Recupero il CheeseProducer 
        CheeseProducer storage cheeseProducer = cheeseProducers[walletCheeseProducer];
        
        // Verifico che l'email e la password hashate sono uguali tra di loro 
        return ripemd160(abi.encodePacked(cheeseProducer.email, cheeseProducer.password)) == ripemd160(abi.encodePacked(_email, _password));
    }

    // Funzione per eliminare il CheeseProducer dato il suo indirizzo del wallet 
    function deleteUser(address walletCheeseProducer) external returns(bool){

        delete cheeseProducers[walletCheeseProducer];

        if(cheeseProducers[walletCheeseProducer].id == 0 && deleteCheeseProducerFromList(walletCheeseProducer)){
            return true;
        }else {
            return false;
        }
    }

    function deleteCheeseProducerFromList(address walletCheeseProducer)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(addressList[i] == walletCheeseProducer){
                delete  addressList[i];
                return true;
            }
        }
        return false;
    }

    // Check if exist the User 
    function isUserPresent(address walletCheeseProducer) external view returns(bool){

        return cheeseProducers[walletCheeseProducer].id!=0;
    }

//---------------------------------------------------- CheeseProducer Get and Set Function --------------------------------------------------//

    /**
        - Funzione getId() attraverso l'address del CheeseProducer riusciamo a recuperare il suo ID
    */
    function getId(address walletCheeseProducer) external view  returns(uint256){
        CheeseProducer memory cheeseProducer = cheeseProducers[walletCheeseProducer];
        return cheeseProducer.id;
    }

    /**
        - Funzione getFullName() attraverso l'address del CheeseProducer riusciamo a recuperare il suo FullName
    */
    function getFullName(address walletCheeseProducer, uint256 _id) external view  returns(string memory){
        require(cheeseProducers[walletCheeseProducer].id ==_id,"ID not Valid!");
        
        CheeseProducer memory cheeseProducer = cheeseProducers[walletCheeseProducer];
        return cheeseProducer.fullName;
    }

    /**
        - Funzione getEmail() attraverso l'address del CheeseProducer riusciamo a recuperare la sua Email 
    */
    function getEmail(address walletCheeseProducer, uint256 _id) external view  returns(string memory){
        require(cheeseProducers[walletCheeseProducer].id==_id,"ID not Valid!");
        CheeseProducer memory cheeseProducer = cheeseProducers[walletCheeseProducer];
        return cheeseProducer.email;
    }

    /**
        - Funzione getBalance() attraverso l'address del CheeseProducer riusciamo a recuperare il suo Balance
    */
    function getBalance(address walletCheeseProducer, uint256 _id) external view  returns(uint256){
        require(cheeseProducers[walletCheeseProducer].id == _id,"ID not Valid!");

        CheeseProducer memory cheeseProducer = cheeseProducers[walletCheeseProducer];
        return cheeseProducer.balance;
    }

    /**
     * getUser(walletCheeseProducer) : 
     * CheeseProducer visualizza le sue informazioni principali
     * - email, password , fullName , balance 
     */
    function getUser(address walletCheeseProducer) external view returns (uint256, string memory, string memory, string memory, uint256) {

        CheeseProducer memory cheeseProducer = cheeseProducers[walletCheeseProducer];

        // Restituisce i dati del consumatore
        return (cheeseProducer.id,
         cheeseProducer.fullName,
          cheeseProducer.password,
           cheeseProducer.email,
            cheeseProducer.balance
            );
    }

    /**
    *Ritorna la Lista degli address
    */
    function getListAddressCheeseProducer() external view returns (address [] memory){  
        return addressList;
    }

    // - Funzione updateBalance() attraverso l'address e l'id, riusciamo a settare il nuovo balance
    function updateBalance(address walletCheeseProducer, uint256 balance) external{
        // Update Balance 
        cheeseProducers[walletCheeseProducer].balance = balance;
    }



}   



