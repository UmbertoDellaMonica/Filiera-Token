//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "../IUserStorageInterface.sol";

contract RetailerStorage is IUserStorageInterface {

    // Address of Organization che gestisce gli utenti
    address private  RetailerOrg;


    constructor(){
        RetailerOrg = msg.sender;
    }


    // Struttura per rappresentare gli attributi di un consumatore
    struct Retailer {
        uint256 id;
        string fullName;
        string password; // Si presume che sia già crittografata dal Front-End
        string email;
        uint256 balance;
    }

    // Mapping che collega l'indirizzo del portafoglio (wallet address) ai dati del consumatore
    mapping(address => Retailer) private  retailers;

    address[ ] private addressList;

    /**
     * addUser() effettuiamo la registrazione dell'utente Retailer 
     */
    function addUser(string memory fullName, string memory password,string memory email, address walletRetailer) external {
                
        // Genera l'ID manualmente utilizzando keccak256
        bytes32 idHash = ripemd160(abi.encodePacked(fullName, password, email, walletRetailer)); // Produce un hash di 20 byte
        uint256 lastIdRetailer = uint256(idHash);

        require(retailers[walletRetailer].id == 0, "Retailer already registered");
        require(bytes(fullName).length > 0, "Full name cannot be empty");
        require(bytes(password).length > 0, "Password cannot be empty");
        require(bytes(email).length > 0, "Email cannot be empty");
        
        // Crea un nuovo consumatore con l'ID univoco
        Retailer memory newRetailer = Retailer({
            id: lastIdRetailer,
            fullName: fullName,
            password: password,
            email: email,
            balance: 100
        });
        // Inserisco l'address 
        addressList.push(walletRetailer);

        // Inserisce il nuovo consumer all'interno della Lista dei Consumer 
        retailers[walletRetailer] = newRetailer;
    }

    /**
     * LoginUser() effettua il login dell'utente 
     * La comparazione Hash tra (email e password) di input e quelli salvati
     * return true se la comparazione è vera, La comparazione è falsa se l'hashing non risulta valido
     */
    function loginUser(address walletRetailer, string memory email, string memory password) external view returns(bool){

        // Recupero il Retailer 
        Retailer storage retailer = retailers[walletRetailer];
        
        // Verifico che l'email e la password hashate sono uguali tra di loro 
        return ripemd160(abi.encodePacked(retailer.email, retailer.password)) == ripemd160(abi.encodePacked(email, password));
    }

    // Funzione per eliminare il Consumer dato il suo indirizzo del wallet 
    function deleteUser(address walletRetailer) external returns(bool){

        delete retailers[walletRetailer];

        if(retailers[walletRetailer].id == 0 && deleteRetailerFromList(walletRetailer)){
            return true;
        }else {
            return false;
        }
    }

    function deleteRetailerFromList(address walletRetailer)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(addressList[i] == walletRetailer){
                delete  addressList[i];
                return true;
            }
        }
        return false;
    }

    // Check if exist the User 
    function isUserPresent(address walletRetailer) external view returns(bool){

        return retailers[walletRetailer].id!=0;
    }

//---------------------------------------------------- Retailer Get and Set Function --------------------------------------------------//

    /**
        - Funzione getId() attraverso l'address del Retailer riusciamo a recuperare il suo ID
    */
    function getId(address walletRetailer) external view  returns(uint256){
        Retailer memory retailer = retailers[walletRetailer];
        return retailer.id;
    }

    /**
        - Funzione getFullName() attraverso l'address del Retailer riusciamo a recuperare il suo FullName
    */
    function getFullName(address walletRetailer, uint256 id) external view  returns(string memory){
        require(retailers[walletRetailer].id ==id,"ID not Valid!");
        
        Retailer memory retailer = retailers[walletRetailer];
        return retailer.fullName;
    }

    /**
        - Funzione getEmail() attraverso l'address del Retailer riusciamo a recuperare la sua Email 
    */
    function getEmail(address walletRetailer, uint256 id) external view  returns(string memory){
        require(retailers[walletRetailer].id==id,"ID not Valid!");
        Retailer memory retailer = retailers[walletRetailer];
        return retailer.email;
    }

    /**
        - Funzione getBalance() attraverso l'address del Retailer riusciamo a recuperare il suo Balance
    */
    function getBalance(address walletRetailer, uint256 id) external view  returns(uint256){
        require(retailers[walletRetailer].id == id,"ID not Valid!");

        Retailer memory retailer = retailers[walletRetailer];
        return retailer.balance;
    }

    /**
     * getUser(walletRetailer) : 
     * Retailer visualizza le sue informazioni principali
     * - email, password , fullName , balance 
     */
    function getUser(address walletRetailer) external view returns (uint256, string memory, string memory, string memory, uint256) {

        Retailer memory retailer = retailers[walletRetailer];

        // Restituisce i dati del consumatore
        return (
            retailer.id,
         retailer.fullName,
          retailer.password,
           retailer.email,
            retailer.balance
            );
    }

    /**
    *Ritorna la Lista degli address
    */
    function getListAddressRetailer() external view returns (address [] memory){  
        return addressList;
    }

    // - Funzione updateBalance() attraverso l'address e l'id, riusciamo a settare il nuovo balance
    function updateBalance(address walletRetailer, uint256 balance) external{
        // Update Balance 
        retailers[walletRetailer].balance = balance;
    }

}   

