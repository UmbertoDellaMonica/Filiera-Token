//SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "../../Actor/CheeseProducer-smart-contract/CheeseProducerService.sol";

contract AccessControlProductMilkBatch{

    CheeseProducerService private cheeseProducerService;

    constructor(
        address _cheeseProducerService
    ){
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
    }

    function checkViewMilkBatchProduct(address walletCheeseProducer) external view returns (bool){
        require(cheeseProducerService.isUserPresent(walletCheeseProducer),"Utente non autorizzato!");
        return true;
    }
}