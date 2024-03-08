// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./RetailerInventoryStorage.sol";
import "../RetailerService.sol";
import "./RetailerBuyerService.sol";

import "../../../Service/access-control-product/AccessControlProductCheesePiece.sol";

contract RetailerInventoryService {


//------------------------------------------------------------------------ Address of other Contract Service -----------------------------------------------------------//

    // Address of the organization managing the users
    address private retailerOrg;

    RetailerInventoryStorage private retailerInventoryStorage;

    RetailerService private retailerService;

    RetailerBuyerService private retailerBuyerService;

    AccessControlProductCheesePiece private accessControlProduct;


//------------------------------------------------------------------------ Event of Service  -----------------------------------------------------------//

    event CheesePieceAdded(address indexed userAddress, string message, uint256 id, uint256 price, uint256 weight);

    event CheesePieceDeleted(address indexed userAddress, string message, uint256 _id);

    event CheesePieceEdited(address indexed userAddress, string message, uint256 weight);

//------------------------------------------------------------------------ Modifier Logic of Contract Service -----------------------------------------------------------//
    modifier checkAddress(address caller) {
        require(caller != address(0), "Address Value is Zero!");
        require(caller != retailerOrg, "Address not valid!");
        require(caller != address(retailerInventoryStorage), "Address not valid of Inventory Storage");
        require(caller != address(retailerService), "Address not valid of Service");
        _;
    }

//------------------------------------------------------------------------ Constructor Contract Service -----------------------------------------------------------//


    constructor(
        address _retailerInventoryStorage,
        address _retailerService,
        address _retailerBuyerService,
        address _accessControlProduct
    ) {
        retailerInventoryStorage = RetailerInventoryStorage(_retailerInventoryStorage);
        retailerService = RetailerService(_retailerService);
        retailerBuyerService = RetailerBuyerService(_retailerBuyerService);
        accessControlProduct = AccessControlProductCheesePiece(_accessControlProduct);
        retailerOrg = msg.sender;
    }


//------------------------------------------------------------------------ Business Logic of other Contract Service -----------------------------------------------------------//


    function addCheesePiece(
        address walletRetailer,
        uint256 price,
        uint256 weight) external checkAddress(walletRetailer) {
        require(retailerService.isUserPresent(walletRetailer), "User is not present in data");

        (uint256 _idCheesePiece, uint256 _price, uint256 _weight) = retailerInventoryStorage.addCheesePiece(
            walletRetailer,
            price,
            weight
        );

        emit CheesePieceAdded(walletRetailer, "CheeseBlock convertito con successo! Ecco il nuovo CheesePiece!", _idCheesePiece, _price, _weight);
    }

    function getCheesePiece(uint256 idCheesePiece, address walletRetailer) external view checkAddress(walletRetailer) returns (uint256, uint256, uint256) {

        require(retailerService.isUserPresent(walletRetailer), "User is not present in data");

        require(this.isCheesePiecePresent(walletRetailer, idCheesePiece), "CheesePiece is not present in data");

        return retailerInventoryStorage.getCheesePiece(walletRetailer, idCheesePiece);
    }

    function deleteCheesePiece(uint256 id, address walletRetailer) external returns (bool) {

        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        require(this.isCheesePiecePresent(walletRetailer, id), "CheesePiece not Present!");

        if (retailerInventoryStorage.deleteCheesePiece(walletRetailer, id)) {
            emit CheesePieceDeleted(walletRetailer, "CheesePiece e' stato eliminato", id);
            return true;
        } else {
            return false;
        }
    }

    function transformCheeseBlock(
        address walletRetailer,
        uint256 idCheeseBlock,
        uint256 quantityToTransform,
        uint256 price) external {


            require(retailerBuyerService.isCheeseBlockPresent(walletRetailer, idCheeseBlock), "Prodotto non presente!");

            require(quantityToTransform <= 3, "Quantita' da trasformare non valida!");

            require(quantityToTransform <= retailerBuyerService.getQuantity(walletRetailer, idCheeseBlock), "Quantita' da trasformare non valida!");

            uint256 newQuantity = retailerBuyerService.getQuantity(walletRetailer, idCheeseBlock) - quantityToTransform;

            retailerBuyerService.updateCheeseBlockQuantity(walletRetailer, idCheeseBlock, newQuantity);

            this.addCheesePiece(walletRetailer, price, quantityToTransform);
    }



//------------------------------------------------------------------------ Get Function -----------------------------------------------------------//


    function getPrice(address walletRetailer, uint256 id) external view returns (uint256) {
        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        require(this.isCheesePiecePresent(walletRetailer, id), "CheesePiece not Present!");

        return retailerInventoryStorage.getPrice(walletRetailer, id);
    }

    function getWeight(address walletRetailer, uint256 id) external view returns (uint256) {
        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        require(this.isCheesePiecePresent(walletRetailer, id), "CheesePiece not Present!");

        return retailerInventoryStorage.getWeight(walletRetailer, id);
    }

    function isCheesePiecePresent(address walletRetailer, uint256 idcheesePiece) external view checkAddress(walletRetailer) returns (bool) {
        return retailerInventoryStorage.isCheesePiecePresent(walletRetailer, idcheesePiece);
    }

    function getUserCheesePieceIds(address walletRetailer) external checkAddress(walletRetailer) view returns (uint256[] memory) {
    // Check if exist 
        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        return retailerInventoryStorage.getUserCheesePieceIds(walletRetailer);
    }

    /*
        - Recupera tutti i CheesePiece presenti all'interno dell'inventario del Retailer
        - Verifica che quel Consumer sia autorizzato
    */
    function getGlobalCheesePieceIds(address walletConsumer) view external returns (uint256[] memory) {
        require(accessControlProduct.checkViewCheesePieceProduct(walletConsumer), "User Not Authorized!");

        return retailerInventoryStorage.getGlobalCheesePieceIds(); 
    }



//------------------------------------------------------------------------  Set Function -----------------------------------------------------------//


    /**
    * Decremento della quantità del MilkBatch 
    * Verifica che la quantità sia maggiore di 0 -> altrimenti elimina
    */
    function updateWeight(
        address onwerCheesePiece,
        uint256 id,
        uint256 quantity ) external checkAddress(onwerCheesePiece) {

        require(retailerService.isUserPresent(onwerCheesePiece), "User is not present!");

        require(this.isCheesePiecePresent(onwerCheesePiece, id),"MilkBatch not Present!");

        retailerInventoryStorage.updateWeight(onwerCheesePiece, id, quantity);

        emit CheesePieceEdited(onwerCheesePiece,"MilkBatch edited!", quantity);
    }
}
