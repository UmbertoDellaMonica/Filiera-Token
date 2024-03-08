// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MilkHubInventoryStorage {

     // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;

    constructor(){
        MilkHubOrg = msg.sender;
    }

    struct MilkBatch {
        uint256 id;
        string expirationDate;
        uint256 quantity; 
        uint256 price; // Prezzo di vendita per un Litro di  ( Partita di Latte )
    }

    /// MilkHub -> Lista Prodotti 
    mapping(address => mapping( uint256 => MilkBatch )) private milkBatches; // Map of All product 
    
    mapping(address => uint256[] ) private userMilkBatchIds; // List of Id of Single User 

    uint256[] globalMilkBatchIds; // All MilkBatch to view for other user 

//----------------------------------------------------------------- Business Logic ------------------------------------------------------------------------------------------------//


    // Add function to add CheesePiece
    function addMilkBatch(address walletMilkHub, string memory expirationDate, uint256 quantity, uint256 price) external returns (uint256,string memory, uint256, uint256) {
        
        // Generazione dell'ID 
        uint256 id = uint256(keccak256(abi.encodePacked(
            expirationDate,
            quantity,
            price,
            walletMilkHub,
            block.timestamp
        )));

        //Crea una nuova Partita di Latte
        MilkBatch memory milkBatch = MilkBatch({
            id: id,
            expirationDate: expirationDate,
            quantity: quantity,
            price: price
        });

        // Inserisco L'id nell'Array relativo a tutti gli elementi 
        globalMilkBatchIds.push(id);
        // Inserisco l'id all'interno del mapping specifico per singolo autore
        userMilkBatchIds[walletMilkHub].push(id);

        //Inserisce la nuova Partita di Latte nella lista milkBatches
        milkBatches[walletMilkHub][id] = milkBatch;
        
        return (
                milkBatches[walletMilkHub][id].id,
                milkBatches[walletMilkHub][id].expirationDate,
                milkBatches[walletMilkHub][id].quantity,
                milkBatches[walletMilkHub][id].price
              );
    }

    // Ritorna un MilkBatch 
    function getMilkBatch(address walletMilkHub, uint256 id) external view returns (uint256, string memory, uint256, uint256) {

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][id];

        return (
            milkBatch.id,
            milkBatch.expirationDate,
            milkBatch.quantity,
            milkBatch.price
            );

    }

    /*
    * Restituisce la Lista di tutti gli ID dei prodotti di un determinato utente
    */
    function getUserMilkBatchIds(address walletMilkHub)external view returns (uint256[] memory){
        return userMilkBatchIds[walletMilkHub];
    }

    function getGlobalMilkBatchIds()external view returns(uint256[]memory){
        return globalMilkBatchIds;
    }

    // Delete Cheese piece 
    // We can delete a cheese piece with -> address of Consumer and id of CheesePiece
    function deleteMilkBatch(address walletMilkHub, uint256 id) external returns(bool value) {

        // Delete piece of Cheese
        delete milkBatches[walletMilkHub][id];

        
        // Check CheesePiece in the mapping 
        if(milkBatches[walletMilkHub][id].id  == 0 && deleteMilkBatchIdFromList(id) && deleteMilkBatchIdFromListSingleUser(id,walletMilkHub) ){
            return true;
        }else {
            return false;
        }
    }

    
    function checkProduct(address ownerMilkBatch, uint256 idMilkBatch, uint256 quantityToBuy) external view  returns (bool){

            require(milkBatches[ownerMilkBatch][idMilkBatch].id == idMilkBatch, "Product non presente!");

            MilkBatch storage milkBatchObj = milkBatches[ownerMilkBatch][idMilkBatch];
            
            require(milkBatchObj.quantity >= quantityToBuy, "Quantity not Valid!");
            return true;
    }

    /**
        - Funzione isMilkBatchPresent() funzione per verificare che il MilkBatch è presente 
        - Verifica tramite id e address del walletMilkHub se il Prodotto è presente 
        - ritorna TRUE se il confronto è vero 
        - ritorna FALSE se non è presente 
    */
    function isMilkBatchPresent(address walletMilkHub, uint256 id)external view returns(bool){
        require( id !=0 && id>0,"ID MilkBatch Not Valid!");

        return milkBatches[walletMilkHub][id].id == id;
    }

//---------------------------------------------------------- Get Function ----------------------------------------------------------------------//   

    function getExpirationDate(address walletMilkHub, uint256 id) external view returns(string memory) {

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][id];
        return milkBatch.expirationDate;        
    }

    function getQuantity(address walletMilkHub, uint256 id) external view returns(uint256) {

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][id];

        return milkBatch.quantity;        
    }

    function getPrice(address walletMilkHub, uint256 id) external view returns(uint256) {

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][id];
        
        return milkBatch.price;        
    }
    

//---------------------------------------------------------- Delete Function ----------------------------------------------------------------------//   


    function deleteMilkBatchIdFromList(uint256 id ) internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(globalMilkBatchIds[i] == id ){
                delete  globalMilkBatchIds[i];
                return true;
            }
        }
        return false;   
    }

    function deleteMilkBatchIdFromListSingleUser(uint256 id, address walletMilkHub)internal returns(bool){
        bool flag = false;
        for(uint256 j=0; ;j++){
            if(userMilkBatchIds[walletMilkHub][j] == id){
                delete userMilkBatchIds[walletMilkHub][j];
                flag = true;
                return flag;
            }
        }
        return flag;
    }

// ------------------------------------------------------------ Set Function ------------------------------------------------------------------//

    // - Funzione updateMilkBatchQuantity() aggiorna la quantità del MilkBatch 
    function updateQuantity(address walletMilkHub, uint256 id, uint256 newQuantity) external  {
        
        milkBatches[walletMilkHub][id].quantity = newQuantity;
    }

}