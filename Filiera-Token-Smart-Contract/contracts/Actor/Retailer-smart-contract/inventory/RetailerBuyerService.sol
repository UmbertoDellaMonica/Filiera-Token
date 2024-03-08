// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./RetailerBuyerStorage.sol";
import "../RetailerService.sol";


contract RetailerBuyerService {

//------------------------------------------------------------------------ Address of other Contract Service -----------------------------------------------------------//

    // Address of Organization che gestisce gli utenti
    address private retailerOrg;
    // Address of CheeseBlockStorage 
    RetailerBuyerStorage private retailerBuyerStorage;

    RetailerService private retailerService;

//------------------------------------------------------------------------ Event of Service  -----------------------------------------------------------//

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event RetailerCheeseBlockAdded(address indexed userAddress,string message,uint256 id, string expirationDate, uint256 quantity);
    // Evento per notificare che un CheeseBlock è stato eliminato 
    event RetailerCheeseBlockDeleted(address indexed userAddress, string message);
    // Evento per notificare che un CheeseBlock è stato Editato
    event RetailerCheeseBlockEdited(address indexed userAddress,string message, uint256 quantity);

//------------------------------------------------------------------------ Constructor of other Contract Service -----------------------------------------------------------//

    constructor(
        address _retailerBuyerStorage, 
        address _retailerService) {
        retailerBuyerStorage = RetailerBuyerStorage(_retailerBuyerStorage);
        retailerService = RetailerService(_retailerService);
        retailerOrg = msg.sender;
    }

//------------------------------------------------------------------------ Modifier Logic of Contract Service -----------------------------------------------------------//

    modifier checkAddress(address caller){
        
        require(caller!=address(0),"Address value is 0!");
        require(caller!=address(retailerBuyerStorage),"Address is retailerBuyerStorage!");
        require(caller!=address(retailerService),"Address is RetailerService!");
        require(caller!=address(retailerOrg),"Address is Organization!");
        _;
    }

//------------------------------------------------------------------------ Business Logic of Contract Service -----------------------------------------------------------//

    // Prodotti Acquistati devono essere visualizzati solo dal Retailer che li detiene 
    // TODO : Controllo del msg.sender sulle funzioni di GET 


    /**
    * Tale funzione viene chiamata dal TransactionManager per inserire il CheeseBlock venduto dal MilkHub al Retailer 
    * I controlli vengono fatti tutti all'interno del TransactionManager per la verifica dell'esistenza dei due interessati 
    * - Ammettiamo che i controlli sul prodotto vengono già fatti a monte 
    * - verifichiamo che il Retailer e il MilkHub esistono 
    * - verifichiamo che il CheeseBlock associato al MilkHub esiste 
    * - Aggiungiamo questi dati all'interno del Inventory 
    */
    function addCheeseBlock(
            
            address walletCheeseProducer,
            address walletRetailer,
            uint256 idCheeseBlock,
            string memory dop,
            uint256 quantity

        ) external checkAddress(walletRetailer) checkAddress(walletCheeseProducer) {
        
        // Verifico che Retailer e MilkHub address non sono identici
        require(address(walletRetailer)!=address(walletCheeseProducer),"Address uguali Retailer e MilkHub!");

        // Verfico che il Retailer è presente 
        require(retailerService.isUserPresent(walletRetailer), "Utente non trovato!");

        // Aggiungo il CheeseBlock all'interno dell'Inventario del Retailer 
        (uint256 _idCheeseBlock, string memory _dopCheese,uint256 _quantity) = retailerBuyerStorage.addCheeseBlock(walletRetailer, walletCheeseProducer, idCheeseBlock, dop, quantity);

        // Invio dell'Evento 
        emit RetailerCheeseBlockAdded(walletRetailer,"CheeseBlock Acquistato!", _idCheeseBlock ,  _dopCheese, _quantity);
    }

    
    //TODO : Controllo sull'owner del CheeseBlock Acquistato 
    function getCheeseBlock(address walletRetailer,uint256 idCheeseBlock) external view checkAddress(walletRetailer) returns (uint256, address, string memory, uint256) {
        
        require(retailerService.isUserPresent(walletRetailer), "Utente non trovato!");

        require(this.isCheeseBlockPresent(walletRetailer,idCheeseBlock),"Prodotto non Presente!");

        return retailerBuyerStorage.getCheeseBlock(walletRetailer, idCheeseBlock);
    }


    
    function getDop(address walletRetailer, uint256 idCheeseBlock) external view checkAddress(walletRetailer) returns(string memory) {
        
        require(retailerService.isUserPresent(walletRetailer), "Utente non trovato!");

        require(this.isCheeseBlockPresent(walletRetailer,idCheeseBlock),"Prodotto non Presente!");
        
        return retailerBuyerStorage.getDop(walletRetailer,idCheeseBlock);        
    }

    
    function getQuantity(address walletRetailer, uint256 idCheeseBlock) external view checkAddress(walletRetailer) returns(uint256) {
        
        require(retailerService.isUserPresent(walletRetailer), "Utente non trovato!");

        require(this.isCheeseBlockPresent(walletRetailer,idCheeseBlock),"Prodotto non Presente!");
        
        return retailerBuyerStorage.getQuantity(walletRetailer,idCheeseBlock);        
    }

    
    function getWalletCheeseProducer(address walletRetailer, uint256 idCheeseBlock) external view checkAddress(walletRetailer) returns(address) {
        
        require(retailerService.isUserPresent(walletRetailer), "Utente non trovato!");

        require(this.isCheeseBlockPresent(walletRetailer,idCheeseBlock),"Prodotto non Presente!");
        
        return retailerBuyerStorage.getWalletCheeseProducer(walletRetailer,idCheeseBlock);        
    }

    /**
    * Verifica che il CheeseBlock è presente all'interno dell'inventario 
    * - Verifica che l'id non sia nullo e che sia maggiore di 0 e che coincida con l'elemento 
    */
    function isCheeseBlockPresent(address walletRetailer, uint256 idCheeseBlock) external view checkAddress(walletRetailer)  returns (bool){
        
        require(retailerService.isUserPresent(walletRetailer),"Utente non presente!");

        return retailerBuyerStorage.isCheeseBlockPresent(walletRetailer, idCheeseBlock);
    }

    
    
    function getUserCheeseBlockIds(address walletRetailer) external checkAddress(walletRetailer) view returns (uint256[] memory){
        // Check if exist 
        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        return retailerBuyerStorage.getUserCheeseBlockIds(walletRetailer);
    }


//-------------------------------------------------------------------- Set Function ------------------------------------------------------------------------//

    /**
    * 
    * - Decremento della quantità del CheeseBlockAcquistato per la trasformazione in Cheese 
    */
    function updateCheeseBlockQuantity(address walletRetailer, uint256 idCheeseBlock, uint256 quantity) external checkAddress(walletRetailer) {

        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        require(retailerBuyerStorage.isCheeseBlockPresent(walletRetailer, idCheeseBlock),"CheeseBlock not Present!");

        retailerBuyerStorage.updateCheeseQuantity(walletRetailer, idCheeseBlock, quantity);

        emit RetailerCheeseBlockEdited(walletRetailer,"CheeseBlock edited!", quantity);
    }




// -------------------------------------------------- Change Address Function Contract Service ---------------------------------------------------//


    // TODO: insert modifier onlyOrg(address sender) {}
    function changeRetailerBuyerStorage(address _retailerBuyerStorage)external {
        require(msg.sender == retailerOrg,"Address is not the organization");
        retailerBuyerStorage = RetailerBuyerStorage(_retailerBuyerStorage);
    }

    // TODO: insert modifier onlyOrg(address sender) {}
    function changeRetailerService(address _retailerService) external {
        retailerService = RetailerService(_retailerService);
    }

}