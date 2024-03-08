//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "../IUserStorageInterface.sol";

contract ConsumerStorage is IUserStorageInterface {

    // Address of Organization che gestisce gli utenti
    address private  ConsumerOrg;


    constructor(){
        ConsumerOrg = msg.sender;
    }


    // Struttura per rappresentare gli attributi di un consumatore
    struct Consumer {
        uint256 id;
        string fullName;
        string password; // Si presume che sia già crittografata dal Front-End
        string email;
        uint256 balance;
    }

    // Mapping che collega l'indirizzo del portafoglio (wallet address) ai dati del consumatore
    mapping(address => Consumer) private  consumers;

    address[ ] private addressList;

    /**
     * addUser() effettuiamo la registrazione dell'utente Consumer 
     */
    function addUser(string memory _fullName, string memory _password,string memory _email, address walletConsumer) external {
                
        // Genera l'ID manualmente utilizzando keccak256
        bytes32 idHash = ripemd160(abi.encodePacked(_fullName, _password, _email, walletConsumer)); // Produce un hash di 20 byte
        uint256 lastIdConsumer = uint256(idHash);

        require(consumers[walletConsumer].id == 0, "Consumer already registered");
        require(bytes(_fullName).length > 0, "Full name cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        require(address(walletConsumer)!=address(0),"Address cannot be empty");
        
        // Crea un nuovo consumatore con l'ID univoco
        Consumer memory newConsumer = Consumer({
            id: lastIdConsumer,
            fullName: _fullName,
            password: _password,
            email: _email,
            balance: 100        });
        // Inserisco l'address 
        addressList.push(walletConsumer);

        // Inserisce il nuovo consumer all'interno della Lista dei Consumer 
        consumers[walletConsumer] = newConsumer;
    }

    /**
     * LoginUser() effettua il login dell'utente 
     * La comparazione Hash tra (email e password) di input e quelli salvati
     * return true se la comparazione è vera, La comparazione è falsa se l'hashing non risulta valido
     */
    function loginUser(address walletConsumer, string memory _email, string memory _password) external view returns(bool){

        // Recupero il Consumer 
        Consumer storage consumer = consumers[walletConsumer];
        
        // Verifico che l'email e la password hashate sono uguali tra di loro 
        return ripemd160(abi.encodePacked(consumer.email, consumer.password)) == ripemd160(abi.encodePacked(_email, _password));
    }

    // Funzione per eliminare il Consumer dato il suo indirizzo del wallet 
    function deleteUser(address walletConsumer) external returns(bool){

        delete consumers[walletConsumer];

        if(consumers[walletConsumer].id == 0 && deleteConsumerFromList(walletConsumer)){
            return true;
        }else {
            return false;
        }
    }

    function deleteConsumerFromList(address walletConsumer)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(addressList[i] == walletConsumer){
                delete  addressList[i];
                return true;
            }
        }
        return false;
    }

    // Check if exist the User 
    function isUserPresent(address walletConsumer) external view returns(bool){

        return consumers[walletConsumer].id!=0;
    }

//---------------------------------------------------- Consumer Get and Set Function --------------------------------------------------//

    /**
        - Funzione getId() attraverso l'address del Consumer riusciamo a recuperare il suo ID
    */
    function getId(address walletConsumer) external view  returns(uint256){
        Consumer memory consumer = consumers[walletConsumer];
        return consumer.id;
    }

    /**
        - Funzione getFullName() attraverso l'address del Consumer riusciamo a recuperare il suo FullName
    */
    function getFullName(address walletConsumer, uint256 _id) external view  returns(string memory){
        require(consumers[walletConsumer].id ==_id,"ID not Valid!");
        
        Consumer memory consumer = consumers[walletConsumer];
        return consumer.fullName;
    }

    /**
        - Funzione getEmail() attraverso l'address del Consumer riusciamo a recuperare la sua Email 
    */
    function getEmail(address walletConsumer, uint256 _id) external view  returns(string memory){
        require(consumers[walletConsumer].id==_id,"ID not Valid!");
        Consumer memory consumer = consumers[walletConsumer];
        return consumer.email;
    }

    /**
        - Funzione getBalance() attraverso l'address del Consumer riusciamo a recuperare il suo Balance
    */
    function getBalance(address walletConsumer, uint256 _id) external view  returns(uint256){
        require(consumers[walletConsumer].id == _id,"ID not Valid!");

        Consumer memory consumer = consumers[walletConsumer];
        return consumer.balance;
    }

    /**
     * getUser(walletConsumer) : 
     * Consumer visualizza le sue informazioni principali
     * - email, password , fullName , balance 
     */
    function getUser(address walletConsumer) external view returns (uint256, string memory, string memory, string memory, uint256) {

        Consumer memory consumer = consumers[walletConsumer];

        // Restituisce i dati del consumatore
        return (consumer.id,
         consumer.fullName,
          consumer.password,
           consumer.email,
            consumer.balance
            );
    }

    /**
    *Ritorna la Lista degli address
    */
    function getListAddressConsumer() external view returns (address [] memory){  
        return addressList;
    }

    // - Funzione updateBalance() attraverso l'address e l'id, riusciamo a settare il nuovo balance
    function updateBalance(address walletConsumer, uint256 balance) external{
        // Update Balance 
        consumers[walletConsumer].balance = balance;
    }



}   



