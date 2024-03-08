// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./CheeseProducerInventoryStorage.sol";
import "../CheeseProducerService.sol";
import "./CheeseProducerBuyerService.sol";

import "../../../Service/access-control-product/AccessControlProductCheese.sol";


// NOTA : implementare i controlli semplici e non di autorizzazione perchè i retailer possono vedere le varie info in merito ai prodotti dei CheeseProducer 
// NOTA : Nel service che gestisce lo storage di acquisto, bisogna implementare una logica più restrittiva che ci dà la possibilità di far visualizzare i prodotti acquistati a coloro che li acquistati.
// NOTA : Ricorda di implementare una logica di approvazione per il contratto che esegue l'aggiunta dell'oggetto acquistato ( TransactionManager deve essere approvato per poter eseguire una transazione del genere ) 

contract CheeseProducerInventoryService {

//--------------------------------------------------------------------- Address of Service Contract -----------------------------------------------//

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    // Address of Consumer Storage 
    CheeseProducerInventoryStorage private cheeseProducerInventoryStorage;

    CheeseProducerService private cheeseProducerService;

    CheeseProducerBuyerService private cheeseProducerBuyerService;

    // Address Access Control 
    AccessControlProductCheese private accessControlProduct;

//--------------------------------------------------------------------- Event of Service Contract -----------------------------------------------//

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event CheeseBlockAdded(address indexed userAddress,string message,uint256 id, string dop, uint256 quantity, uint256 price);

    // Eventi per notificare la rimozione di un CheeseBlock
    event CheeseBlockDeleted(address indexed userAddress, string message, uint256 _id);
    
    // Eventi per notificare la modifica di un Cheese Block 
    event CheeseBlockEdited(address indexed userAddress,string message, uint256 quantity);


//--------------------------------------------------------------------- Constructor of Service Contract -----------------------------------------------//


    constructor(
        address _cheeseProducerInventoryStorage,
        address _cheeseProducerService,
        address _cheeseProducerBuyerService,
        address _accessControlProduct) {
        
        cheeseProducerInventoryStorage = CheeseProducerInventoryStorage(_cheeseProducerInventoryStorage);
        
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);

        cheeseProducerBuyerService = CheeseProducerBuyerService(_cheeseProducerBuyerService);
        
        accessControlProduct = AccessControlProductCheese(_accessControlProduct);

        cheeseProducerOrg = msg.sender;
    }

//--------------------------------------------------------------------- Modifier of Service Contract -----------------------------------------------//

    modifier checkAddress(address caller) {
        require(caller != address(0),"Address Value is Zero!");
        require(caller != cheeseProducerOrg, "Address not valid!");
        require(caller != address(cheeseProducerInventoryStorage), "Address not valid of Inventory Storage");
        require(caller != address(cheeseProducerService),"Address not valid of Service");
        _;
    }

    // TODO : Aggiungere il controllo per l'organizzazione che può effettuare il cambio dei vari Address di Service di cui abbiamo bisogno

//--------------------------------------------------------------------- Business Function of Service Contract -----------------------------------------------//


    /* Questa funzione permette di aggiungere : 
       Un prodotto CheeseBlock all'inventario da poter mettere in vendita
       
       - Check da effettuare : 

       - Verifica che l'address dell'utente sia registrato 
       - Verifica che l'address dell'utente non sia l'organizzazione che ha deployato il contratto 
       - Aggiunta del blocco di formaggio in dipendenza dal milkbatch acquistato 

       - Evento : 
       - CheeseBlockAdded()
     */
    function addCheeseBlock(
        address walletCheeseProducer,
        string memory dop,
        uint256 quantity,
        uint256 price) internal  checkAddress(walletCheeseProducer) {
        
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present in data");
        
        (uint _idCheese,string memory _dop, uint256 _pricePerKg, uint256 _quantityToTal) = cheeseProducerInventoryStorage.addCheeseBlock(walletCheeseProducer, dop, quantity, price);

        emit CheeseBlockAdded(walletCheeseProducer,"MilkBatch convertito con successo ! Ecco il nuovo cheeseBlock!",_idCheese, _dop, _quantityToTal, _pricePerKg);
    }

    /**
     * Ottenere le informazioni del cheeseblock attraverso : 
     * - ID cheeseBlock
     * */  
    function getCheeseBlock(uint256 idCheeseBlock, address walletCheeseProducer) external view checkAddress(walletCheeseProducer) returns (uint256, string memory, uint256, uint256) {
        

        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present in data");

        require(this.isCheeseBlockPresent(walletCheeseProducer, idCheeseBlock), "CheeseBlock is not present in data");

        return cheeseProducerInventoryStorage.getCheeseBlock(walletCheeseProducer, idCheeseBlock);
    }

    /**
     * Eliminare un Cheese Block attraverso l'id 
     * - ID 
     * - Verficare che l'utente che vuole eseguire la transazione sia presente.
     */
    function deleteCheeseBlock(uint256 id,address walletCheeseProducer) external returns(bool){
        // Check if User is Present
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");
        // Check if Product is present 
        require(this.isCheeseBlockPresent(walletCheeseProducer, id),"Cheese Block not Present!");

        if(cheeseProducerInventoryStorage.deleteCheeseBlock(walletCheeseProducer,id)){
            emit CheeseBlockDeleted(walletCheeseProducer,"Cheese Block e' stato eleminato", id);
            return true;
        }else {
            return false;
        }
    }

//--------------------------------------------------------------------- Get Function of Service Contract -----------------------------------------------//

    function getDop(address walletCheeseProducer, uint256 id) external view returns(string memory) {
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        require(this.isCheeseBlockPresent(walletCheeseProducer, id),"MilkBatch not Present!");

        return cheeseProducerInventoryStorage.getDop(walletCheeseProducer,id);        
    }

    function getPrice(address walletCheeseProducer, uint256 id) external view returns(uint256) {
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        require(this.isCheeseBlockPresent(walletCheeseProducer, id),"MilkBatch not Present!");

        return cheeseProducerInventoryStorage.getPrice(walletCheeseProducer,id);        
    }

    function getCheeseBlockQuantity(address walletCheeseProducer, uint256 id) external view returns(uint256) {
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        require(this.isCheeseBlockPresent(walletCheeseProducer, id),"MilkBatch not Present!");

        return cheeseProducerInventoryStorage.getQuantity(walletCheeseProducer,id);        
    }

    // Verifica se un determinato CheeseBlock è presente 
    function isCheeseBlockPresent(address walletCheeseProducer, uint256 idcheeseBlock) external view  checkAddress(walletCheeseProducer) returns(bool){

        return cheeseProducerInventoryStorage.isCheeseBlockPresent(walletCheeseProducer,idcheeseBlock);
    }


     function getUserCheeseBlockIds(address walletCheeseProducer) external checkAddress(walletCheeseProducer) view returns (uint256[] memory){
        // Check if exist 
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        return cheeseProducerInventoryStorage.getUserCheeseBlockIds(walletCheeseProducer);
    }

    /*
        - Recupera tutti i CheeseBlock presenti all'interno di Inventory 
        - Verifica che quel CheeseProducer sia all'interno del sistema 
    */
    function getGlobalCheeseBlockIds(address walleRetailer) view  external  returns (uint256[] memory){
        require(accessControlProduct.checkViewCheeseBlockProduct(walleRetailer),"User Not Authorized!");
        
        return cheeseProducerInventoryStorage.getGlobalCheeseBlockIds();
    }

//--------------------------------------------------------------------- Update Function of Service Contract -----------------------------------------------//

    // Funzione per trasformare i vari milkBatch in CheeseBlock 
    function transformMilkBatch(address walletCheeseProducer, uint256 idMilkBatch, uint256 quantityToTransform, uint256 pricePerKg, string memory dop) external  {
        
        //Verifico che il prodotto esiste, che la quantità richiesta da trasformare non ecceda il massimo consentito
        require(cheeseProducerBuyerService.isMilkBatchPresent(walletCheeseProducer,idMilkBatch),"Prodotto non presente!");
        // Verifico la quantità 
        // Verifico che quella che devo trasformare sia inferiore o uguale a quella che ho acquistato 
        require(quantityToTransform<=cheeseProducerBuyerService.getQuantity(walletCheeseProducer,idMilkBatch),"Quantita' da trasformare non valida!");

        uint256 newQuantity = cheeseProducerBuyerService.getQuantity(walletCheeseProducer,idMilkBatch) - quantityToTransform;

        //TODO: gestire data di scadenza nel frontend ( Verificare la data di Scadenza con quella Odierna ) 
        cheeseProducerBuyerService.updateMilkBatchQuantity(walletCheeseProducer,idMilkBatch, newQuantity);

        uint256 weight = quantityToTransform * 5;
        //TODO: gestire il prezzo con SafeMath
        addCheeseBlock(walletCheeseProducer, dop, weight, pricePerKg);
    }


// --------------------------------------------------------------------- SET function --------------------------------------------------------------------------------------------//


    /**
    * Decremento della quantità del CheeseBlock 
    * Verifica che la quantità sia maggiore di 0 -> altrimenti rimani 
    */
    function updateCheeseBlockQuantity(address ownerCheeseProducer, uint256 id, uint256 quantity) external checkAddress(ownerCheeseProducer) {

        require(cheeseProducerService.isUserPresent(ownerCheeseProducer), "User is not present!");

        require(this.isCheeseBlockPresent(ownerCheeseProducer, id),"MilkBatch not Present!");

        cheeseProducerInventoryStorage.updateCheeseBlockQuantity(ownerCheeseProducer, id, quantity);

        emit CheeseBlockEdited(ownerCheeseProducer,"CheeseBlock edited!", quantity);
    }

}
