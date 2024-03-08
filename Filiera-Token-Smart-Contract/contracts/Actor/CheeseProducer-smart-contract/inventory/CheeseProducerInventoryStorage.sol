// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CheeseProducerInventoryStorage {

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    constructor() {
        cheeseProducerOrg = msg.sender;
    }

    struct Cheese {
        uint256 id; // Cheese ID 
        string dop;
        uint256 price;
        uint256 quantity;
    }

    mapping(address => mapping(uint256 => Cheese)) private cheeseBlocks; // map of CheeseBlock 

    mapping( address => uint256[] ) userCheeseBlockIds; // List of id of Single User CheeseProducer 

    uint256 [] private globalCheeseBlockIds; // All CheeseBlock 

// --------------------------------------------------- Business Function --------------------------------------------------------------------------------------//



    function addCheeseBlock(
            address walletCheeseProducer,
            string memory dop,
            uint256 quantity,
            uint256 price
        ) external returns (uint256 , string memory , uint256 , uint256 ){

        uint256 id = uint256(keccak256(abi.encodePacked(
            dop,
            price,
            quantity,
            walletCheeseProducer,
            block.timestamp
        )));


        // Crea un nuovo Blocco di formaggio
        Cheese memory cheeseBlock = Cheese({
            id: id,
            dop: dop,
            price: price,
            quantity: quantity
        });

        // Inserisci l'id all'interno della Lista 
        globalCheeseBlockIds.push(id);
        // Inserisce l'id all'interno della Lista del CheeseProducer 
        userCheeseBlockIds[walletCheeseProducer].push(id);
        // Inserisce il nuovo Blocco di formaggio nella lista cheeseBlocks
        cheeseBlocks[walletCheeseProducer][id] = cheeseBlock;

        return (cheeseBlock.id,cheeseBlock.dop,cheeseBlock.price,cheeseBlock.quantity);
    }

    function getCheeseBlock(address walletCheeseProducer, uint256 id) external view returns (uint256, string memory, uint256, uint256) {

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][id];

        return (cheeseBlock.id, cheeseBlock.dop, cheeseBlock.price, cheeseBlock.quantity);
    }

    // Elimina il CheeseBlock 
    function deleteCheeseBlock(address walletCheeseProducer, uint256 id) external returns(bool value) {

        delete cheeseBlocks[walletCheeseProducer][id];
        // Check CheesePiece in the mapping 
        if(cheeseBlocks[walletCheeseProducer][id].id  == 0 && 
        deleteCheeseBlockIdFromList(id) && 
        deleteCheeseBlockIdFromListSingleUser(id, walletCheeseProducer) ){
            return true;
        }else {
            return false;
        }
    }


    // Verifica che il CheeseBlock è già presente 
    function isCheeseBlockPresent(address walletCheeseProducer,uint256 idCheeseBlock) external view returns(bool){
        
        require( idCheeseBlock !=0 && idCheeseBlock>0, "ID MilkBatch Not Valid!");

        return cheeseBlocks[walletCheeseProducer][idCheeseBlock].id == idCheeseBlock;
    }
    

// --------------------------------------------------- Get Function --------------------------------------------------------------------------------------//
    
    function getDop(address walletCheeseProducer, uint256 id) external view returns(string memory) {

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][id];
        return cheeseBlock.dop;
    }

    function getPrice(address walletCheeseProducer, uint256 id) external view returns(uint256) {

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][id];
        return cheeseBlock.price;
    }

    function getQuantity(address walletCheeseProducer, uint256 id) external view returns(uint256) {

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][id];
        return cheeseBlock.quantity;
    }


    /*
    * Restituisce la Lista di tutti gli ID dei prodotti di un determinato utente
    */
    function getUserCheeseBlockIds(address walletCheeseProducer)external view returns (uint256[] memory){
        return userCheeseBlockIds[walletCheeseProducer];
    }
    
    // Restituisce tutti i CheeseBlock per i Retailer 
    function getGlobalCheeseBlockIds()external view returns(uint256[]memory){
        return globalCheeseBlockIds;
    }
// --------------------------------------------------- Set Function --------------------------------------------------------------------------------------//


    // - Funzione updateCheeseBlockQuantity() aggiorna la quantità del CheeseBlock 
    function updateCheeseBlockQuantity(
        address walletCheeseProducer,
        uint256 idCheese,
        uint256 newQuantity) external  {
        
        // Controllo sulla quantita' 
        require(newQuantity<=cheeseBlocks[walletCheeseProducer][idCheese].quantity,"Controllo della Quantita' da utilizzare non andata a buon fine!");

        cheeseBlocks[walletCheeseProducer][idCheese].quantity = newQuantity;
    }

    function deleteCheeseBlockIdFromList(uint256 id)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(globalCheeseBlockIds[i] == id ){
                delete  globalCheeseBlockIds[i];
                return true;
            }
        }
        return false;
    }

    function deleteCheeseBlockIdFromListSingleUser(uint256 id, address walletCheeseProducer)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(userCheeseBlockIds[walletCheeseProducer][i] == id){
                delete userCheeseBlockIds[walletCheeseProducer][i];
                return true;
            }
        }
        return false;
    }

}
