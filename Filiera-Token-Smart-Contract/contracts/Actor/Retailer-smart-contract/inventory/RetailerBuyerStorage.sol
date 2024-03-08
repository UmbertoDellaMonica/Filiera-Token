// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Smart Contract per lo storage dei MilkHub acquistati dal CheeseProducer
contract RetailerBuyerStorage {

    // Address of Organization che gestisce gli utenti
    address private RetailerOrg;

    constructor() {
        RetailerOrg = msg.sender;
    }

    struct Cheese {
        uint256 id; // Generato nuovo per il Retailer 
        uint256 idCheeseBlock; // id di riferimento del CheeseBlock 
        address walletCheeseProducer; // Address del Wallet del CheeseProducer
        string dop; 
        uint256 quantity; // Quantità da acquistare 
    }

    mapping(address => mapping(uint256 => Cheese)) private purchasedCheeseBlocks;

    mapping(address => uint256[]) private userCheeseBlockIds;



//--------------------------------------------------------------- Business Logic Service -----------------------------------------------------------------------------------------//


    /**
    *
    * Funzione addCheese() -> Utilizzata dal Transaction Manager per poter inserire il Cheese Acquistato 
    * Scollego questa logica, ammettendo che il CheeseProducer può testare la logica di conversione 
    * params : 
    * - walletCheeseProducer -> mi serve per il mapping 
    * - walletCheeseProducer -> mi serve per creare il nuovo elemento  
    * - idcheese -> mi serve per il riferimento all'elemento acquistato
    */
    function addCheeseBlock( 
        
            address walletRetailer, 
            address walletCheeseProducer, // Riferimento al wallet del Cheeseproducer 
            uint256 idCheeseBlock, // riferimento al prodotto di Cheese
            string memory dop, // attributo del formaggio  
            uint256 quantity //Quantità acquisita
        
        ) external returns (uint256,string memory,uint256){

        uint256 id = uint256(keccak256(abi.encodePacked(
            quantity,
            dop,
            walletRetailer,
            walletCheeseProducer,
            idCheeseBlock,
            block.timestamp // inserimento di questo attributo per rendere l'acquisto unico nel suo genere 
            // l'articolo in questo modo può essere riacquistato dallo stesso cheeseProducer un'altra volta 
        )));


        Cheese storage cheeseControl = purchasedCheeseBlocks[walletRetailer][id];
        require( cheeseControl.id == 0, "Partita di Latte gia' presente!");

        //Crea una nuova Partita di Latte
        Cheese memory cheese = Cheese({
            id: id,
            dop:dop,
            idCheeseBlock: idCheeseBlock,
            walletCheeseProducer: walletCheeseProducer,
            quantity: quantity
        });

        //Inserisce la nuova Partita di Latte nella lista purchasedCheeseBlocks
        purchasedCheeseBlocks[walletRetailer][id] = cheese;

        //Inserisci l'id all'interno della Lista
        userCheeseBlockIds[walletRetailer].push(id);

        return (cheese.id, cheese.dop, cheese.quantity);

    }


    function getCheeseBlock(address walletRetailer, uint256 idCheeseBlock) external view returns (uint256, address,string memory, uint256) {

        Cheese memory cheese = purchasedCheeseBlocks[walletRetailer][idCheeseBlock];

        return (cheese.id, cheese.walletCheeseProducer, cheese.dop, cheese.quantity);
    }


    /**
    * Funzione per la verifica dell'esistenza del prodotto Cheese acquistato 
    * - ritorna TRUE se esiste 
    * - ritorna FALSe se non esiste 
    * - effettua il controllo sull'uguaglianza dell'id del Cheese Acquistato
    */
    function isCheeseBlockPresent(address walletRetailer, uint256 idCheeseBlock)external view returns(bool){
        require( idCheeseBlock !=0 && idCheeseBlock>0,"ID Cheese Not Valid!");

        return purchasedCheeseBlocks[walletRetailer][idCheeseBlock].id == idCheeseBlock;
    }

// -------------------------------------------------------------- Set Function ------------------------------------------------------------------------------------------//



    // - Funzione updateCheeseQuantity() aggiorna la quantità del Cheese 
    function updateCheeseQuantity(address walletRetailer, uint256 id, uint256 newQuantity) external  {
        // Controllo sulla quantita' 
        require(newQuantity<=purchasedCheeseBlocks[walletRetailer][id].quantity,"Controllo della Quantita' da utilizzare non andata a buon fine!");

        purchasedCheeseBlocks[walletRetailer][id].quantity = newQuantity;
    }


// -------------------------------------------------------------- Get Function ------------------------------------------------------------------------------------------//

    function getDop(address walletRetailer, uint256 idcheeseBlock) external view returns(string memory) {

        Cheese memory cheese = purchasedCheeseBlocks[walletRetailer][idcheeseBlock];
        return cheese.dop;
    }


    function getQuantity(address walletRetailer, uint256 id) external view returns(uint256) {

        Cheese memory cheese = purchasedCheeseBlocks[walletRetailer][id];
        return cheese.quantity;        
    }

    function getWalletCheeseProducer(address walletRetailer, uint256 id) external view returns(address) {

        Cheese memory cheese = purchasedCheeseBlocks[walletRetailer][id];
        return cheese.walletCheeseProducer;
    }

    function getId(address walletRetailer, uint256 id) external view returns(uint256) {

        return purchasedCheeseBlocks[walletRetailer][id].id;
    }

    /*
    * Restituisce la Lista di tutti gli ID dei prodotti di un determinato utente
    */
    function getUserCheeseBlockIds(address walletRetailer)external view returns (uint256[] memory){
        return userCheeseBlockIds[walletRetailer];
    }


// -------------------------------------------------------------- Check Function ------------------------------------------------------------------------------------------//


    function checkCheese(address walletRetailer, uint256 id, uint256 quantityToTransform) external view returns(bool) {
        require(purchasedCheeseBlocks[walletRetailer][id].id == id, "Partita di Latte non presente!");

        Cheese storage cheeseObj = purchasedCheeseBlocks[walletRetailer][id];
            
        require(cheeseObj.quantity >= quantityToTransform, "Quantity not Valid!");
        return true;    
    }


    function checkQuantity(address walletRetailer,  uint256 id, uint256 quantityToTransform ) external view returns(bool){
        
        Cheese storage cheeseObj = purchasedCheeseBlocks[walletRetailer][id];
            
        require(cheeseObj.quantity >= quantityToTransform, "Quantity not Valid!");

        return true;    
    }
    
}