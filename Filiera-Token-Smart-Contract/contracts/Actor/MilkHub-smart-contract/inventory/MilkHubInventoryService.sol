// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MilkHubInventoryStorage.sol";
import "../MilkHubService.sol";

import "../../../Service/access-control-product/AccessControlProductMilkBatch.sol";


contract MilkHubInventoryService {


// ------------------------------------------------------------------ Contract Address Service -----------------------------------------------------------//

     // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;
    // Address of Inventory Storage 
    MilkHubInventoryStorage private milkhubInventoryStorage;
    // Address Service of MilkHub Service 
    MilkHubService private milkhubService;
    // Address Access Control 
    AccessControlProductMilkBatch private accessControlProduct;

//----------------------------------------------------------------- Costructor Function ---------------------------------------------------------------------------//

    constructor(address _milkhubInventoryStorage, address _milkhubService, address _accessControlProduct
    ){
        MilkHubOrg = msg.sender;
        milkhubInventoryStorage = MilkHubInventoryStorage(_milkhubInventoryStorage);
        milkhubService = MilkHubService(_milkhubService);
        accessControlProduct = AccessControlProductMilkBatch(_accessControlProduct);
    }



//----------------------------------------------------------------- Event of Service ----------------------------------------------------------------------------------//


    // Evento per notificare l'aggiunta e l'eliminazione dei dati
    event MilkBatchAdded(address indexed userAddress, uint256 id, string message, string expirationDate, uint256 quantity, uint256 price);
    // Evento per notificare l'eliminazione del MilkBatch 
    event MilkBatchDeleted(address indexed userAddress, uint256 indexed id, string message);
    // Evento per notificare la modifica del MilkBatch 
    event MilkBatchEdited(address indexed userAddress,string message, uint256 quantity);
    // Evento per notificare che un dato utente non ha il permesso 
    event UserDenied(string errorMessage);

//-------------------------------------------------------------------- Change Contract Address Service ----------------------------------------------------------------------//




    function changeMilkHubInventoryStorage(address _milkhubInventoryStorage)external {
        milkhubInventoryStorage = MilkHubInventoryStorage(_milkhubInventoryStorage);
    }


    function changeMilkHubService(address _milkhubService)external {
        milkhubService = MilkHubService(_milkhubService);
    }


//--------------------------------------------------------------------------- Modifier function of Service ----------------------------------------------------------------------------//


    // Verifica chi effettua la transazione : 
    // Verfica che l'address non sia l'organizzazione 
    // Verfica che l'address non sia lo smart contract del MilkHubStorage e FilieraToken 
    modifier checkAddress(address walletMilkHub){

        require(walletMilkHub != address(0),"Address is zero");
        require(walletMilkHub != address(milkhubInventoryStorage), "Address is MilkHubStorage Smart Contract!");
        require(walletMilkHub != address(milkhubService), "Address is FilieraToken Smart Contract!" );
        require(walletMilkHub != MilkHubOrg ,"Organization address not Valid to do Operation");

        _;
    }




//------------------------------------------------------------------------------- Business Function of Service --------------------------------------------------------------------------//


    /* Questa funzione permette di aggiungere : 
       Un prodotto MilkBatch all'inventario da poter mettere in vendita
       
       - Check da effettuare : 
       - Verifica che l'address dell'utente sia registrato 
       - Verifica che l'address dell'utente non sia l'organizzazione che ha deployato il contratto 
       
       - Evento : 
       - milkBatchAdded()
     */
    function addMilkBatch(string memory expirationDate, uint256 quantity, uint256 price, address walletMilkHub) external checkAddress(walletMilkHub) {
        // Check if User exists
        require(milkhubService.isUserPresent(walletMilkHub), "User is not present in data");

        //Call function of Storage 
        (uint256 _id, string memory _expirationDate, uint256 _quantity, uint256 _price) = milkhubInventoryStorage.addMilkBatch(walletMilkHub, expirationDate, quantity, price);
        // Emissione dell'evento 
        emit MilkBatchAdded(walletMilkHub, _id, "Pezzo di formaggio inserito !", _expirationDate, _quantity, _price);
    }

    /**
     * Ottenere le informazioni del milkbatch attraverso : 
     * - ID milkBatch
       - msg.sender -> mi permette di visualizzare solo se sono il proprietario di questo prodotto 
     * */  
    function getMilkBatch(uint256 id, address walletMilkHub) external view checkAddress(walletMilkHub) returns (uint256, string memory, uint256, uint256)  {
        
        // Retrieve msg.sender 
        require(this.isMilkBatchPresent(walletMilkHub, id),"MilkBatch not Present!");

        return milkhubInventoryStorage.getMilkBatch(walletMilkHub,id);
    }

    // - Ritorna la lista degli id di tutti i MilkBatch 
    // - Solo l'utente può vedere questa Lista ( il suo inventario ) 
    function getUserMilkBatchIds(address walletMilkHub) external view checkAddress(walletMilkHub) returns (uint256[] memory){
        // Verifico che l'utente sia presente 
        require(milkhubService.isUserPresent(walletMilkHub),"Utente non Presente!");

        return milkhubInventoryStorage.getUserMilkBatchIds(walletMilkHub);
    }

    function getGlobalMilkBatchIds(address walletCheeseProducer) external view returns(uint256[]memory){
        // Solo il cheeseProducer può vedere questa Lista 
        // AccessControlProduct -> controlla se è il CheeseProducer 
        require(accessControlProduct.checkViewMilkBatchProduct(walletCheeseProducer),"Utente non autorizzato!");

        return milkhubInventoryStorage.getGlobalMilkBatchIds();
    }

    /**
     * Eliminare un MilkBatch attraverso l'id 
     * - ID 
     * - Verficare che l'utente che vuole eseguire la transazione sia presente.
     */
    function deleteMilkBatch(uint256 id,address walletMilkHub) external checkAddress(walletMilkHub) returns(bool value) {
        // Check if User is Present
        require(milkhubService.isUserPresent(walletMilkHub), "User is not present!");
        // Check if Product is present 
        require(this.isMilkBatchPresent(walletMilkHub, id),"MilkBatch not Present!");

        if(milkhubInventoryStorage.deleteMilkBatch(walletMilkHub,id)){
            emit MilkBatchDeleted(walletMilkHub,id,"Pezzo di Formaggio e' stato eleminato");
            return true;
        }else {
            return false;
        }
    }


// ----------------------------------------------------------- TransactionManager ------------------------------------//

    function checkProductToSell(address ownerMilkBatch, uint256 idMilkBatch, uint256 quantityToBuy) external view returns (bool){
        
        require(msg.sender != address(0),"Address not Valid!");
        require(ownerMilkBatch != address(0),"Address not Valid!");

        return milkhubInventoryStorage.checkProduct(ownerMilkBatch, idMilkBatch, quantityToBuy);
    }

//-------------------------------------------------------------------- Get Function --------------------------------------------------------------------//

    function getMilkBatchExpirationDate(address walletMilkHub, uint256 id) external view checkAddress(walletMilkHub) returns(string memory) {
        
        require(milkhubService.isUserPresent(walletMilkHub), "User is not present!");

        require(this.isMilkBatchPresent(walletMilkHub, id),"MilkBatch not Present!");

        return milkhubInventoryStorage.getExpirationDate(walletMilkHub,id);        
    }


    function getMilkBatchQuantity(address walletMilkHub, uint256 id) external view checkAddress(walletMilkHub) returns(uint256) {
        
        require(milkhubService.isUserPresent(walletMilkHub), "User is not present!");

        require(this.isMilkBatchPresent(walletMilkHub, id),"MilkBatch not Present!");
        
        return milkhubInventoryStorage.getQuantity(walletMilkHub,id);        
    }


    function getMilkBatchPrice(address walletMilkHub, uint256 id) external view checkAddress(walletMilkHub) returns(uint256) {
        require(milkhubService.isUserPresent(walletMilkHub), "User is not present!");

        require(this.isMilkBatchPresent(walletMilkHub, id),"MilkBatch not Present!");
        
        return milkhubInventoryStorage.getPrice(walletMilkHub,id);        
    }

    /**
    * Verifica che il MilkBatch è presente all'interno dell'inventario 
    * - Verifica che l'id non sia nullo e che sia maggiore di 0 e che coincida con l'elemento 
    */
    function isMilkBatchPresent(address walletMilkHub, uint256 id) external view checkAddress(walletMilkHub)  returns (bool){
        return milkhubInventoryStorage.isMilkBatchPresent(walletMilkHub, id);
    }


//---------------------------------------------------------------------- Set Function --------------------------------------------------------------------------//


    /**
    * Decremento della quantità del MilkBatch 
    * Verifica che la quantità sia maggiore di 0 -> altrimenti elimina
    */
    function updateMilkBatchQuantity(address ownerMilkHub, uint256 id, uint256 quantity) external checkAddress(ownerMilkHub) {

        require(milkhubService.isUserPresent(ownerMilkHub), "User is not present!");

        require(this.isMilkBatchPresent(ownerMilkHub, id),"MilkBatch not Present!");

        milkhubInventoryStorage.updateQuantity(ownerMilkHub, id, quantity);

        emit MilkBatchEdited(ownerMilkHub,"MilkBatch edited!", quantity);
    }



}