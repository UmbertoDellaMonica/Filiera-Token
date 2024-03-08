// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "./Filieratoken.sol";

import "../Actor/Retailer-smart-contract/inventory/RetailerInventoryService.sol";
import "../Actor/Consumer-smart-contract/inventory/ConsumerBuyerService.sol";
import "../Actor/Consumer-smart-contract/ConsumerService.sol";
import "../Actor/Retailer-smart-contract/RetailerService.sol";




contract TransactionCheesePieceProductService {

    
    // **Main Services**

    // Address of the FilieraToken contract.
    Filieratoken private filieraTokenService;

    RetailerService private retailerService;   // Address of the RetailerService contract.
    ConsumerService private consumerService;   // Address of the ConsumerService contract.


        // Retailer - Contains CheesePiece (product sold by Retailer).
    RetailerInventoryService private retailerInventoryService;

    // Consumer - Contains CheesePiece (product bought by Consumer).
    ConsumerBuyerService private consumerBuyerService;


        /**
     * @dev Costruttore del contratto TransactionManager.
     * 
     * @param _filieraToken Indirizzo del contratto FilieraToken.
     * @param _retailerService Indirizzo del contratto RetailerService.
     * @param _consumerService Indirizzo del contratto ConsumerService.
     * 
     * @param _retailerInventoryService Indirizzo del contratto RetailerInventoryService.
     * @param _consumerBuyerService Indirizzo del contratto ConsumerBuyerService.
     */
    constructor(
        address _filieraToken,

        address _retailerService,
        address _consumerService,
        address _retailerInventoryService,
        address _consumerBuyerService

        ){
        // Filiera Token Service 
        filieraTokenService = Filieratoken(_filieraToken);

        
        retailerService = RetailerService(_retailerService);
        consumerService = ConsumerService(_consumerService);
    
        retailerInventoryService = RetailerInventoryService(_retailerInventoryService);
        consumerBuyerService = ConsumerBuyerService(_consumerBuyerService);
    }



    /**
     * @dev Funzione per acquistare un CheesePiece da un Retailer. Questa funzione può essere chiamata solo da un Consumer.
     *
     * @param ownerCheesePiece Indirizzo del Retailer che vende il CheesePiece.
     * @param _id_CheesePiece Identificativo del CheesePiece da acquistare.
     * @param _quantityToBuy Quantità di CheesePiece da acquistare (espressa in grammi).
     * @param totalPrice Prezzo totale del CheesePiece da acquistare (espresso in FilieraToken).
     */ 
    function BuyCheesePieceProduct(
        address buyer,
        address ownerCheesePiece,
        uint256 _id_CheesePiece,
        uint256 _quantityToBuy,
        uint256 totalPrice) external {
        
        // Verifica degli address con controlli generici 
        require(buyer != address(0), "Invalid sender address");
        require(ownerCheesePiece != address(0), "Invalid owner address");
        require(buyer != ownerCheesePiece, "Cannot buy from yourself");
        // Verfica della presenza del Prodotto 
        require(retailerInventoryService.isCheesePiecePresent(ownerCheesePiece, _id_CheesePiece), "Product not found");
        // Verifica della quantità da acquistare rispetto alla quantità totale 
        require(_quantityToBuy <= retailerInventoryService.getWeight(ownerCheesePiece, _id_CheesePiece), "Invalid quantity");
        // Verifica del saldo dell'acquirente 
        require(filieraTokenService.balanceOf(buyer) >= totalPrice, "Insufficient balance");

        // Acquisto 
        require(filieraTokenService.transferTokenBuyProduct(buyer, ownerCheesePiece, totalPrice),"Acquisto non andato a buon fine!");

        // Aggiornamento del saldo del Retailer
        uint256 newRetailerBalance = filieraTokenService.balanceOf(ownerCheesePiece);
        retailerService.updateRetailerBalance(ownerCheesePiece, newRetailerBalance);
        // Aggiornamento del saldo del Consumer 
        uint256 newConsumerBalance = filieraTokenService.balanceOf(buyer);
        consumerService.updateConsumerBalance(buyer, newConsumerBalance);

        // Riduzione della quantità nel MilkHubInventory
        uint256 currentQuantity = retailerInventoryService.getWeight(ownerCheesePiece, _id_CheesePiece);
        retailerInventoryService.updateWeight(ownerCheesePiece, _id_CheesePiece, currentQuantity - _quantityToBuy);


        // Aggiunta del MilkBatch nell'inventario del CheeseProducer
        consumerBuyerService.addCheesePiece(
            ownerCheesePiece,
            buyer, 
            _id_CheesePiece,
            retailerInventoryService.getPrice(ownerCheesePiece, _id_CheesePiece),
            _quantityToBuy);
    }
}