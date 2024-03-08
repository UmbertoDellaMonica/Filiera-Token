// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./CheeseProducerBuyerStorage.sol";
import "../CheeseProducerService.sol";


contract CheeseProducerBuyerService {

//------------------------------------------------------------------------ Address of other Contract Service -----------------------------------------------------------//

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;
    // Address of MilkBatchStorage 
    CheeseProducerBuyerStorage private cheeseProducerBuyerStorage;

    CheeseProducerService private cheeseProducerService;

//------------------------------------------------------------------------ Event of Service  -----------------------------------------------------------//

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event CheeseProducerMilkBatchAdded(address indexed userAddress,string message,uint256 id, string expirationDate, uint256 quantity);
    // Evento per notificare che un MilkBatch è stato eliminato 
    event CheeseProducerMilkBatchDeleted(address indexed userAddress, string message);
    // Evento per notificare che un MilkBatch è stato Editato
    event CheeseProducerMilkBatchEdited(address indexed userAddress,string message, uint256 quantity);

//------------------------------------------------------------------------ Constructor of other Contract Service -----------------------------------------------------------//

    constructor(address _cheeseProducerBuyerStorage, address _cheeseProducerService) {
        cheeseProducerBuyerStorage = CheeseProducerBuyerStorage(_cheeseProducerBuyerStorage);
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
        cheeseProducerOrg = msg.sender;
    }

//------------------------------------------------------------------------ Modifier Logic of Contract Service -----------------------------------------------------------//

    modifier checkAddress(address caller){
        
        require(caller!=address(0),"Address value is 0!");
        require(caller!=address(cheeseProducerBuyerStorage),"Address is cheeseProducerBuyerStorage!");
        require(caller!=address(cheeseProducerService),"Address is CheeseProducerService!");
        require(caller!=address(cheeseProducerOrg),"Address is Organization!");
        _;
    }

//------------------------------------------------------------------------ Business Logic of Contract Service -----------------------------------------------------------//

    // Prodotti Acquistati devono essere visualizzati solo dal CheeseProducer che li detiene 
    // TODO : Controllo del msg.sender sulle funzioni di GET 


    /**
    * Tale funzione viene chiamata dal TransactionManager per inserire il MilkBatch venduto dal MilkHub al CheeseProducer 
    * I controlli vengono fatti tutti all'interno del TransactionManager per la verifica dell'esistenza dei due interessati 
    * - Ammettiamo che i controlli sul prodotto vengono già fatti a monte 
    * - verifichiamo che il CheeseProducer e il MilkHub esistono 
    * - verifichiamo che il MilkBatch associato al MilkHub esiste 
    * - Aggiungiamo questi dati all'interno del Inventory 
    */
    function addMilkBatch(
            
            address walletMilkHub,
            address walletCheeseProducer,
            uint256 idMilkBatch,
            string memory expirationDate,
            uint256 quantity

        ) external checkAddress(walletCheeseProducer) checkAddress(walletMilkHub) {
        
        // Verifico che CheeseProducer e MilkHub address non sono identici
        require(address(walletCheeseProducer)!=address(walletMilkHub),"Address uguali CheeseProducer e MilkHub!");

        // Verfico che il CheeseProducer è presente 
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "Utente non trovato!");

        // Aggiungo il MilkBatch all'interno dell'Inventario del CheeseProducer 
        (uint256 _idMilkBatch, string memory _expDate,uint256 _quantity) = cheeseProducerBuyerStorage.addMilkBatch(walletCheeseProducer, walletMilkHub,idMilkBatch, expirationDate, quantity);

        // Invio dell'Evento 
        emit CheeseProducerMilkBatchAdded(walletCheeseProducer,"MilkBatch Acquistato!", _idMilkBatch ,  _expDate, _quantity);
    }

    
    //TODO : Controllo sull'owner del MilkBatch Acquistato 
    function getMilkBatch(address walletCheeseProducer, uint256 idMilkBatch) external view checkAddress(walletCheeseProducer) returns (uint256, address, string memory, uint256) {
        

        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "Utente non trovato!");

        require(this.isMilkBatchPresent(walletCheeseProducer,idMilkBatch),"Prodotto non Presente!");

        return cheeseProducerBuyerStorage.getMilkBatch(walletCheeseProducer, idMilkBatch);
    }

    
    function getExpirationDate(address walletCheeseProducer, uint256 idMilkBatch) external view checkAddress(walletCheeseProducer) returns(string memory) {
        
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "Utente non trovato!");

        require(this.isMilkBatchPresent(walletCheeseProducer,idMilkBatch),"Prodotto non Presente!");
        
        return cheeseProducerBuyerStorage.getExpirationDate(walletCheeseProducer,idMilkBatch);        
    }

    
    function getQuantity(address walletCheeseProducer, uint256 idMilkBatch) external view checkAddress(walletCheeseProducer) returns(uint256) {
        
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "Utente non trovato!");

        require(this.isMilkBatchPresent(walletCheeseProducer,idMilkBatch),"Prodotto non Presente!");
        
        return cheeseProducerBuyerStorage.getQuantity(walletCheeseProducer,idMilkBatch);        
    }

    
    function getWalletMilkHub(address walletCheeseProducer, uint256 idMilkBatch) external view checkAddress(walletCheeseProducer) returns(address) {
        
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "Utente non trovato!");

        require(this.isMilkBatchPresent(walletCheeseProducer,idMilkBatch),"Prodotto non Presente!");
        
        return cheeseProducerBuyerStorage.getWalletMilkHub(walletCheeseProducer,idMilkBatch);        
    }

    /**
    * Verifica che il MilkBatch è presente all'interno dell'inventario 
    * - Verifica che l'id non sia nullo e che sia maggiore di 0 e che coincida con l'elemento 
    */
    function isMilkBatchPresent(address walletCheeseProducer, uint256 idMilkBatch) external view checkAddress(walletCheeseProducer)  returns (bool){
        
        require(cheeseProducerService.isUserPresent(walletCheeseProducer),"Utente non presente!");

        return cheeseProducerBuyerStorage.isMilkBatchPresent(walletCheeseProducer, idMilkBatch);
    }

    /*
        - Recupera la Lista di Prodotti Acquistati di un  CheeseProducer 
        - Verifica che questo esista 
    */
    function getUserMilkBatchIds(address walletCheeseProducer)external view checkAddress(walletCheeseProducer) returns (uint256[]memory ){
        // Verifica che l'utente sia presente all'interno del sistema e sia solo il CheeseProducer
        require(cheeseProducerService.isUserPresent(walletCheeseProducer),"User not Authorized!");

        return cheeseProducerBuyerStorage.getUserMilkBatchIds(walletCheeseProducer);
    }



//-------------------------------------------------------------------- Set Function ------------------------------------------------------------------------//

    /**
    * 
    * - Decremento della quantità del MilkBatchAcquistato per la trasformazione in Cheese 
    */
    function updateMilkBatchQuantity(address walletCheeseProducer, uint256 idMilkBatch, uint256 quantity) external checkAddress(walletCheeseProducer) {

        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        require(cheeseProducerBuyerStorage.isMilkBatchPresent(walletCheeseProducer, idMilkBatch),"MilkBatch not Present!");

        cheeseProducerBuyerStorage.updateMilkBatchQuantity(walletCheeseProducer, idMilkBatch, quantity);

        emit CheeseProducerMilkBatchEdited(walletCheeseProducer,"MilkBatch edited!", quantity);
    }




// -------------------------------------------------- Change Address Function Contract Service ---------------------------------------------------//


    // TODO: insert modifier onlyOrg(address sender) {}
    function changeCheeseProducerBuyerStorage(address _cheeseProducerBuyerStorage)external {
        require(msg.sender == cheeseProducerOrg,"Address is not the organization");
        cheeseProducerBuyerStorage = CheeseProducerBuyerStorage(_cheeseProducerBuyerStorage);
    }

    // TODO: insert modifier onlyOrg(address sender) {}
    function changeCheeseProducerService(address _cheeseProducerService) external {
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
    }

}