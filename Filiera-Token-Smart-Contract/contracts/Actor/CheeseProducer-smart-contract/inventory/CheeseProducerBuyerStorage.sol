// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Smart Contract per lo storage dei MilkHub acquistati dal CheeseProducer
contract CheeseProducerBuyerStorage {

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    constructor() {
        cheeseProducerOrg = msg.sender;
    }

    struct MilkBatch {
        uint256 id; // Generato nuovo per il CheeseProducer 
        uint256 idMilkBatch; // id di riferimento del MilkBatch 
        address walletMilkHub; // Address del Wallet del MilkHub 
        string expirationDate; // Data di scadenza 
        uint256 quantity; // Quantità da acquistare 
    }

    mapping(address => mapping(uint256 => MilkBatch)) private purchasedMilkBatches; // map of all MilkBatches

    mapping(address => uint256[]) private userMilkBatchIds; // List of Product Purchased of CheeseProducer 


//--------------------------------------------------------------- Business Logic Service -----------------------------------------------------------------------------------------//


    /**
    *
    * Funzione addMilkBatch() -> Utilizzata dal Transaction Manager per poter inserire il MilkBatch Acquistato 
    * Scollego questa logica, ammettendo che il CheeseProducer può testare la logica di conversione 
    * params : 
    * - walletCheeseProducer -> mi serve per il mapping 
    * - walletMilkHub -> mi serve per creare il nuovo elemento  
    * - idmilkBatch -> mi serve per il riferimento all'elemento acquistato
    */
    function addMilkBatch( 
        
            address walletCheeseProducer, 
            address walletMilkHub, // Riferimento al wallet del MilkHub 
            uint256 idMilkBatch, // riferimento al prodotto di MilkBatch 
            string memory expirationDate,
            uint256 quantity
        
        ) external returns (uint256, string memory, uint256){

        uint256 id = uint256(keccak256(abi.encodePacked(
            expirationDate,
            quantity,
            walletCheeseProducer,
            walletMilkHub,
            idMilkBatch,
            block.timestamp // inserimento di questo attributo per rendere l'acquisto unico nel suo genere 
            // l'articolo in questo modo può essere riacquistato dallo stesso cheeseProducer un'altra volta 
        )));


        //Crea una nuova Partita di Latte
        MilkBatch memory milkBatch = MilkBatch({
            id: id,
            idMilkBatch: idMilkBatch,
            walletMilkHub: walletMilkHub,
            expirationDate: expirationDate,
            quantity: quantity
        });

        //Inserisce la nuova Partita di Latte nella lista purchasedMilkBatches
        purchasedMilkBatches[walletCheeseProducer][id] = milkBatch;
        // Inserisce la partita di latte acquistata nell'elenco delle singole partite di latte 
        userMilkBatchIds[walletCheeseProducer].push(id);

        return (purchasedMilkBatches[walletCheeseProducer][id].id, purchasedMilkBatches[walletCheeseProducer][id].expirationDate, purchasedMilkBatches[walletCheeseProducer][id].quantity);

    }


    function getMilkBatch(address walletCheeseProducer, uint256 idMilkBatch) external view returns (uint256, address, string memory, uint256) {

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][idMilkBatch];

        return (milkBatch.id, milkBatch.walletMilkHub, milkBatch.expirationDate, milkBatch.quantity);
    }

    function getUserMilkBatchIds(address walletCheeseProducer)external view returns (uint256[] memory){
        
        return userMilkBatchIds[walletCheeseProducer];
    }


    /**
    * Funzione per la verifica dell'esistenza del prodotto MilkBatch acquistato 
    * - ritorna TRUE se esiste 
    * - ritorna FALSe se non esiste 
    * - effettua il controllo sull'uguaglianza dell'id del MilkBatch Acquistato
    */
    function isMilkBatchPresent(address walletCheeseProducer, uint256 idMilkBatch)external view returns(bool){
        require( idMilkBatch !=0 && idMilkBatch>0,"ID MilkBatch Not Valid!");

        return purchasedMilkBatches[walletCheeseProducer][idMilkBatch].id == idMilkBatch;
    }

// -------------------------------------------------------------- Set Function ------------------------------------------------------------------------------------------//



    // - Funzione updateMilkBatchQuantity() aggiorna la quantità del MilkBatch 
    function updateMilkBatchQuantity(address walletCheeseProducer, uint256 id, uint256 newQuantity) external  {
        // Controllo sulla quantita' 
        require(newQuantity<=purchasedMilkBatches[walletCheeseProducer][id].quantity,"Controllo della Quantita' da utilizzare non andata a buon fine!");

        purchasedMilkBatches[walletCheeseProducer][id].quantity = newQuantity;
    }


// -------------------------------------------------------------- Get Function ------------------------------------------------------------------------------------------//



    function getExpirationDate(address walletCheeseProducer, uint256 id) external view returns(string memory) {

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][id];
        return milkBatch.expirationDate;
    }

    function getQuantity(address walletCheeseProducer, uint256 id) external view returns(uint256) {

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][id];
        return milkBatch.quantity;        
    }

    function getWalletMilkHub(address walletCheeseProducer, uint256 id) external view returns(address) {

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][id];
        return milkBatch.walletMilkHub;
    }


// -------------------------------------------------------------- Check Function ------------------------------------------------------------------------------------------//


    function checkMilkBatch(address walletCheeseProducer, uint256 id, uint256 quantityToTransform) external view returns(bool) {
        require(purchasedMilkBatches[walletCheeseProducer][id].id == id, "Partita di Latte non presente!");

        MilkBatch storage milkBatchObj = purchasedMilkBatches[walletCheeseProducer][id];
            
        require(milkBatchObj.quantity >= quantityToTransform, "Quantity not Valid!");
        return true;    
    }


    function checkQuantity(address walletCheeseProducer,  uint256 id, uint256 quantityToTransform ) external view returns(bool){
        
        MilkBatch storage milkBatchObj = purchasedMilkBatches[walletCheeseProducer][id];
            
        require(milkBatchObj.quantity >= quantityToTransform, "Quantity not Valid!");

        return true;    
    }
    
}