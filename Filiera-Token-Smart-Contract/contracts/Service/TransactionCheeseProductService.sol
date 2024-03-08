// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "./Filieratoken.sol";

// Service 
import "../Actor/CheeseProducer-smart-contract/CheeseProducerService.sol";
import "../Actor/Retailer-smart-contract/RetailerService.sol";

import "../Actor/CheeseProducer-smart-contract/inventory/CheeseProducerInventoryService.sol";
import "../Actor/Retailer-smart-contract/inventory/RetailerInventoryService.sol";


contract TransactionCheeseProductService {


    // **Main Services**

    // Address of the FilieraToken contract.
    Filieratoken private filieraTokenService;

    // Addresses of the service contracts for each actor in the supply chain.
    CheeseProducerService private cheeseProducerService; // Address of the CheeseProducerService contract.
    RetailerService private retailerService;   // Address of the RetailerService contract.

    // **Inventory Services**

    // Service contracts for managing inventory for each actor and product stage.

    // CheeseProducer - Contains Cheese (product sold by CheeseProducer).
    CheeseProducerInventoryService private cheeseProducerInventoryService;

    // Retailer - Contains CheeseBlock (product bought by Retailer).
    RetailerBuyerService private retailerBuyerService;


    /**
     * @dev Costruttore del contratto TransactionManager.
     * 
     * @param _filieraToken Indirizzo del contratto FilieraToken.
     * @param _cheeseProducerService Indirizzo del contratto CheeseProducerService.
     * @param _retailerService Indirizzo del contratto RetailerService.
     * 
     * 
     * @param _cheeseProducerInventoryService Indirizzo del contratto CheeseProducerInventoryService.
     * @param _retailerBuyerService Indirizzo del contratto RetailerBuyerService.
     * 
     */
    constructor(
        address _filieraToken,

        address _cheeseProducerService,
        address _retailerService,


        address _cheeseProducerInventoryService,
        address _retailerBuyerService
        ){
        // Filiera Token Service 
        filieraTokenService = Filieratoken(_filieraToken);

        

        // Main Service 

        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
        
        retailerService = RetailerService(_retailerService);

        // Inventory Service 
        cheeseProducerInventoryService = CheeseProducerInventoryService(_cheeseProducerInventoryService);
        retailerBuyerService = RetailerBuyerService(_retailerBuyerService);
    }



    /**
    * @dev Funzione per acquistare un CheeseBlock da un CheeseProducer. Questa funzione può essere chiamata solo da un Retailer.
    *
    * @param ownerCheese Indirizzo del CheeseProducer che vende il CheeseBlock.
    * @param _id_Cheese Identificativo del CheeseBlock da acquistare.
    * @param _quantityToBuy Quantità di CheeseBlock da acquistare.
    * @param totalPrice Prezzo totale del CheeseBlock da acquistare (espresso in FilieraToken).
    */ 
    function BuyCheeseProduct(
            address buyer, 
            address ownerCheese,
            uint256 _id_Cheese,
            uint256 _quantityToBuy,
            uint256 totalPrice // Effettuare il calcolo dal front-End 
        ) external {
       // Verifica degli address con controlli generici 
        require(buyer != address(0), "Invalid sender address");
        require(ownerCheese != address(0), "Invalid owner address");
        require(buyer != ownerCheese, "Cannot buy from yourself");
        // Verfica della presenza del Prodotto 
        require(cheeseProducerInventoryService.isCheeseBlockPresent(ownerCheese, _id_Cheese), "Product not found");
        // Verifica della quantità da acquistare rispetto alla quantità totale 
        require(_quantityToBuy <= cheeseProducerInventoryService.getCheeseBlockQuantity(ownerCheese, _id_Cheese), "Invalid quantity");
        // Verifica del saldo dell'acquirente 
        require(filieraTokenService.balanceOf(buyer) >= totalPrice, "Insufficient balance");

        // Acquisto 
        require(filieraTokenService.transferTokenBuyProduct(buyer, ownerCheese, totalPrice),"Acquisto non andato a buon fine!");

        // Aggiornamento del saldo del MilkHub 
        uint256 newCheeseProducerBalance = filieraTokenService.balanceOf(ownerCheese);
        cheeseProducerService.updateCheeseProducerBalance(ownerCheese, newCheeseProducerBalance);
        // Aggiornamento del saldo del CheeseProducer 
        uint256 newRetailerBalance = filieraTokenService.balanceOf(buyer);
        retailerService.updateRetailerBalance(buyer, newRetailerBalance);

        // Riduzione della quantità nel MilkHubInventory
        uint256 currentQuantity = cheeseProducerInventoryService.getCheeseBlockQuantity(ownerCheese, _id_Cheese);
        cheeseProducerInventoryService.updateCheeseBlockQuantity(ownerCheese, _id_Cheese, currentQuantity - _quantityToBuy);

        // Aggiunta del MilkBatch nell'inventario del CheeseProducer
        retailerBuyerService.addCheeseBlock(
            ownerCheese,
            buyer, 
            _id_Cheese,
            cheeseProducerInventoryService.getDop(ownerCheese, _id_Cheese),
            _quantityToBuy);
    }
}