// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RetailerStorage.sol";
import "../../Service/Filieratoken.sol";


contract RetailerService {

//-------------------------------------------------------------------- Contract Address Service --------------------------------------------------------------------//


    // Address of Consumer Storage 
    RetailerStorage private retailerStorage;
    
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  RetailerOrg;



// --------------------------------------------------------------------- Event of Service ----------------------------------------------------------------//

    // Evento emesso al momento della cancellazione di un consumatore
    event RetailerDeleted(address indexed walletRetailer, string message);
    // Evento emesso al momento della registrazione di un consumatore
    event RetailerRegistered(address indexed walletRetailer, string fullName, string message);



//---------------------------------------------------------------------- Constructor ----------------------------------------------------------------------------//    
    constructor(address _retailerStorage, address _filieraToken) {
        retailerStorage = RetailerStorage(_retailerStorage);
        filieraToken = Filieratoken(_filieraToken);
        RetailerOrg = msg.sender;
    }

// ------------------------------------------------------------ Modifier Of Service ---------------------------------------------------------------------------------//


    modifier onlyOrg(address sender){
        require(sender == RetailerOrg,"User Not Authorized!");
        _;
    }

    // Verifica chi effettua la transazione : 
    // Verfica che l'address non sia l'organizzazione 
    // Verfica che l'address non sia lo smart contract del RetailerStorage e FilieraToken 
    modifier checkAddress(address walletRetailer){

        require(walletRetailer != address(0),"Address is zero");
        require(walletRetailer != address(retailerStorage), "Address is RetailerStorage Smart Contract!");
        require(walletRetailer != address(filieraToken), "Address is FilieraToken Smart Contract!" );
        require(walletRetailer != RetailerOrg ,"Organization address");

        _;
    }


//--------------------------------------------------------------- Business Logic -------------------------------------------------------------------------------------------//

    /**
     * registerRetailer() registra gli utenti della piattaforma che sono Retailer 
     * - Inserisce i dati all'interno della Blockchain
     * - Trasferisce 100 token dal contratto di FilieraToken 
     * - Emette un evento appena l'utente è stato registrato 
     *  */ 
    function registerRetailer(string memory fullName, string memory password, string memory email, address walletRetailer) external checkAddress(walletRetailer) {

        // Verifica che l'utente è gia' presente 
        require(!(this.isUserPresent(walletRetailer)), "Utente gia' registrato !");

        // Chiama la funzione di Storage 
        retailerStorage.addUser(fullName, password, email, walletRetailer);

        // Autogenera dei token nel balance del Retailer 
        require(filieraToken.registerUserWithToken(address(walletRetailer), 100),"Transfer Token not Valid!");

        // Emette l'evento della registrazione dell'utente
        emit RetailerRegistered(walletRetailer, fullName, "Utente Retailer e' stato registrato!");
    }

    /**
     * login() effettua la Login con email e password 
     * - Inserisce l'email e la password 
     * - return True se l'utente esiste ed ha accesso con le giuste credenziali 
     * - return False altrimenti 
     */
    function login(address walletRetailer, string memory email, string memory password) external view checkAddress(walletRetailer)  returns(bool) {

        // Verifichiamo che l'utente è presente 
        require(this.isUserPresent(walletRetailer),"Utente non e' presente!");
        
        return retailerStorage.loginUser(walletRetailer, email, password);
    }


    /**
     * deleteRetailer() elimina un Retailer all'interno del sistema 
     * - Solo l'owner può effettuare l'eliminazione 
     * - msg.sender dovrebbe essere solo quello dell'owner 
     */
    function deleteRetailer(address walletRetailer, uint256 id) external checkAddress(walletRetailer)  {
        
        // Verifico che l'utente è presente 
        require(this.isUserPresent(walletRetailer), "Utente non e' presente!");
        // Restituisce l'id del Retailer tramite il suo address wallet
        require(retailerStorage.getId(walletRetailer) == id , "Utente non Autorizzato!");
        // Effettuo la cancellazione dell'utente 
        require(retailerStorage.deleteUser(walletRetailer), "Errore durante la cancellazione");
        // Burn all token ( elimina i token che sono in circolazione, di un utente che non effettua transazioni ) 
        filieraToken.burnToken(walletRetailer, filieraToken.balanceOf(walletRetailer));
        // Emit Event on FireFly 
        emit RetailerDeleted(walletRetailer,"Utente e' stato eliminato!");
    }

// --------------------------------------------------------------------------- RetailerInventoryService ----------------------------------------------------//

    function isUserPresent(address walletRetailer) external view returns(bool){
        
        return retailerStorage.isUserPresent(walletRetailer);
    }



//----------------------------------------------------------------------------- Get Function ----------------------------------------------------------------------//

    /**
        -  Funzione getRetailerId() attraverso l'address del Retailer siamo riusciti ad ottenere il suo ID
    */
    function getRetailerId(address walletRetailer) external view checkAddress(walletRetailer)  returns (uint256){
        
        return retailerStorage.getId(walletRetailer);
    }

    
    /**
        - Funzione getFullName() attraverso l'address del Retailer riusciamo a recuperare il suo FullName
    */
    function getRetailerFullName(address walletRetailer,uint256 id) external view checkAddress(walletRetailer) returns(string memory){

        return retailerStorage.getFullName(walletRetailer,id);
    }

    /**
        - Funzione getEmail() attraverso l'address del Retailer riusciamo a recuperare la sua Email 
    */
    function getRetailerEmail(address walletRetailer, uint256 id) external view checkAddress(walletRetailer) returns(string memory){
        
        return retailerStorage.getEmail(walletRetailer,id);
    }


    /**
        - Funzione getBalance() attraverso l'address del Retailer riusciamo a recuperare il suo Balance
    */
    function getRetailerBalance(address walletRetailer, uint256 id) external view checkAddress(walletRetailer)  returns(uint256){

        return retailerStorage.getBalance(walletRetailer,id);
    }

    /**
     * getRetailerData() otteniamo i dati del Retailer
     * - tramite l'address del Retailer riusciamo a visualizzare anche i suoi dati
     * - Dati sensibili e visibili solo dal Retailer stesso 
     */
    function getRetailerData(address walletRetailer, uint256 id) external checkAddress(walletRetailer) view returns (uint256, string memory, string memory, string memory, uint256) {
        // Verifico che l'utente è presente 
        require(this.isUserPresent(walletRetailer), "Utente non e' presente!");
        // Restituisce l'id del Retailer tramite il suo address wallet
        require(retailerStorage.getId(walletRetailer) == id , "Utente non Autorizzato!");
        // Call function of Storage         
        return retailerStorage.getUser(walletRetailer);
    }

    function getListAddressRetailer() external view returns ( address [ ] memory){
        return retailerStorage.getListAddressRetailer();
    }

//------------------------------------------------------------ Set Function -------------------------------------------------------------------//

    // - Funzione updateBalance() attraverso l'address e l'id, riusciamo a settare il nuovo balance
    function updateRetailerBalance(address walletRetailer, uint256 balance) external checkAddress(walletRetailer) {
        // Verifico che il Balance sia >0 
        require(balance>0,"Balance Not Valid");
        // Verifico che l'utente esista 
        require(this.isUserPresent(walletRetailer),"User Not Found!");
        // Update Balance 
        retailerStorage.updateBalance(walletRetailer, balance);
    }


// ------------------------------------------------------------ Change Address Contract of Service -----------------------------------------------------//


    function changeRetailerStorage(address _retailerStorageNew)private {
        retailerStorage = RetailerStorage(_retailerStorageNew);
    }


    function changeFilieraToken(address _filieraToken)private {
        filieraToken = Filieratoken(_filieraToken);
    }


}
