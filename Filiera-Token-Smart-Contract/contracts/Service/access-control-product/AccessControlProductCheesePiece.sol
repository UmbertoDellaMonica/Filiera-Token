//SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "../../Actor/Consumer-smart-contract/ConsumerService.sol";

contract AccessControlProductCheesePiece{


    ConsumerService private consumerService;

    constructor(
        address _consumerService
    ){
        consumerService = ConsumerService(_consumerService);
    }

    function checkViewCheesePieceProduct(address walletConsumer)external view returns (bool){
        require(consumerService.isUserPresent(walletConsumer),"Utente non autorizzato!");
        return true;
    }
}