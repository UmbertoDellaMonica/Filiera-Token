//SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "../Actor/CheeseProducer-smart-contract/CheeseProducerService.sol";
import "../Actor/Consumer-smart-contract/ConsumerService.sol";
import "../Actor/Retailer-smart-contract/RetailerService.sol";

contract AccessControlProduct{

    CheeseProducerService private cheeseProducerService;

    RetailerService private retailerService;

    ConsumerService private consumerService;

    constructor(
        address _cheeseProducerService,
        address _retailerService,
        address _consumerService
    ){
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
        retailerService = RetailerService(_retailerService);
        consumerService = ConsumerService(_consumerService);
    }


    function checkViewMilkBatchProduct(address walletCheeseProducer) external view returns (bool){
        require(cheeseProducerService.isUserPresent(walletCheeseProducer),"Utente non autorizzato!");
        return true;
    }
    
    function checkViewCheeseBlockProduct(address walletRetailer)external view returns (bool){
        require(retailerService.isUserPresent(walletRetailer),"Utente non autorizzato!");
        return true;
    }

    function checkViewCheesePieceProduct(address walletConsumer)external view returns (bool){
        require(consumerService.isUserPresent(walletConsumer),"Utente non autorizzato!");
        return true;
    }
}