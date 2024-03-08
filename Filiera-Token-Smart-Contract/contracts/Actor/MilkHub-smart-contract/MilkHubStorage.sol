//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "../IUserStorageInterface.sol";

contract MilkHubStorage is IUserStorageInterface {

    // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;


    constructor(){
        MilkHubOrg = msg.sender;
    }


    // Struttura per rappresentare gli attributi di un consumatore
    struct MilkHub {
        uint256 id;
        string fullName;
        string password; // Si presume che sia già crittografata dal Front-End
        string email;
        uint256 balance;
    }

    // Mapping che collega l'indirizzo del portafoglio (wallet address) ai dati del consumatore
    mapping(address => MilkHub) private  milkhubs;

    address[ ] private addressList;

    /**
     * addUser() effettuiamo la registrazione dell'utente MilkHub 
     */
    function addUser(string memory _fullName, string memory _password,string memory _email, address walletMilkHub) external {
                
        // Genera l'ID manualmente utilizzando keccak256
        bytes32 idHash = ripemd160(abi.encodePacked(_fullName, _password, _email, walletMilkHub)); // Produce un hash di 20 byte
        uint256 lastIdMilkHub = uint256(idHash);

        require(milkhubs[walletMilkHub].id == 0, "MilkHub already registered");
        require(bytes(_fullName).length > 0, "Full name cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        
        // Crea un nuovo consumatore con l'ID univoco
        MilkHub memory newMilkHub = MilkHub({
            id: lastIdMilkHub,
            fullName: _fullName,
            password: _password,
            email: _email,
            balance: 100
        });
        // Inserisco l'address 
        addressList.push(walletMilkHub);

        // Inserisce il nuovo consumer all'interno della Lista dei Consumer 
        milkhubs[walletMilkHub] = newMilkHub;
    }

    /**
     * LoginUser() effettua il login dell'utente 
     * La comparazione Hash tra (email e password) di input e quelli salvati
     * return true se la comparazione è vera, La comparazione è falsa se l'hashing non risulta valido
     */
    function loginUser(address walletMilkHub, string memory _email, string memory _password) external view returns(bool){

        // Recupero il MilkHub 
        MilkHub storage milkhub = milkhubs[walletMilkHub];
        
        // Verifico che l'email e la password hashate sono uguali tra di loro 
        return ripemd160(abi.encodePacked(milkhub.email, milkhub.password)) == ripemd160(abi.encodePacked(_email, _password));
    }

    // Funzione per eliminare il Consumer dato il suo indirizzo del wallet 
    function deleteUser(address walletMilkHub) external returns(bool){

        delete milkhubs[walletMilkHub];

        if(milkhubs[walletMilkHub].id == 0 && deleteMilkHubFromList(walletMilkHub)){
            return true;
        }else {
            return false;
        }
    }

    function deleteMilkHubFromList(address walletMilkHub)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(addressList[i] == walletMilkHub){
                delete  addressList[i];
                return true;
            }
        }
        return false;
    }

    // Check if exist the User 
    function isUserPresent(address walletMilkHub) external view returns(bool){

        return milkhubs[walletMilkHub].id!=0;
    }

//---------------------------------------------------- MilkHub Get and Set Function --------------------------------------------------//

    /**
        - Funzione getId() attraverso l'address del MilkHub riusciamo a recuperare il suo ID
    */
    function getId(address walletMilkHub) external view  returns(uint256){
        MilkHub memory milkhub = milkhubs[walletMilkHub];
        return milkhub.id;
    }

    /**
        - Funzione getFullName() attraverso l'address del MilkHub riusciamo a recuperare il suo FullName
    */
    function getFullName(address walletMilkHub, uint256 _id) external view  returns(string memory){
        require(milkhubs[walletMilkHub].id ==_id,"ID not Valid!");
        
        MilkHub memory milkhub = milkhubs[walletMilkHub];
        return milkhub.fullName;
    }

    /**
        - Funzione getEmail() attraverso l'address del MilkHub riusciamo a recuperare la sua Email 
    */
    function getEmail(address walletMilkHub, uint256 _id) external view  returns(string memory){
        require(milkhubs[walletMilkHub].id==_id,"ID not Valid!");
        MilkHub memory milkhub = milkhubs[walletMilkHub];
        return milkhub.email;
    }

    /**
        - Funzione getBalance() attraverso l'address del MilkHub riusciamo a recuperare il suo Balance
    */
    function getBalance(address walletMilkHub, uint256 _id) external view  returns(uint256){
        require(milkhubs[walletMilkHub].id == _id,"ID not Valid!");

        MilkHub memory milkhub = milkhubs[walletMilkHub];
        return milkhub.balance;
    }

    /**
     * getUser(walletMilkHub) : 
     * MilkHub visualizza le sue informazioni principali
     * - email, password , fullName , balance 
     */
    function getUser(address walletMilkHub) external view returns (uint256, string memory, string memory, string memory, uint256) {

        MilkHub memory milkhub = milkhubs[walletMilkHub];

        // Restituisce i dati del consumatore
        return (
            milkhub.id,
         milkhub.fullName,
          milkhub.password,
           milkhub.email,
            milkhub.balance
            );
    }

    /**
    *Ritorna la Lista degli address
    */
    function getListAddressMilkHub() external view returns (address [] memory){  
        return addressList;
    }

    // - Funzione updateBalance() attraverso l'address e l'id, riusciamo a settare il nuovo balance
    function updateBalance(address walletMilkHub, uint256 balance) external{
        // Update Balance 
        milkhubs[walletMilkHub].balance = balance;
    }



}   

