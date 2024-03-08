//SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "../../Actor/Retailer-smart-contract/RetailerService.sol";

contract AccessControlProductCheese{

    RetailerService private retailerService;

    constructor(
        address _retailerService
    ){
        retailerService = RetailerService(_retailerService);
    }
    
    function checkViewCheeseBlockProduct(address walletRetailer)external view returns (bool){
        require(retailerService.isUserPresent(walletRetailer),"Utente non autorizzato!");
        return true;
    }

}