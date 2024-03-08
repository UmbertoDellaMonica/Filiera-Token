// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Smart Contract per lo storage dei MilkHub acquistati dai ConsumerBuyer
contract ConsumerBuyerStorage {

    // Address of Organization che gestisce gli utenti
    address private consumerBuyerOrg;

    constructor() {
        consumerBuyerOrg = msg.sender;
    }

    struct CheesePiece {
        uint256 id; // Generato nuovo per il ConsumerBuyer
        address walletRetailer; // Address del Wallet del Retailer
        uint256 price;
        uint256 weight;
    }

    mapping(address => mapping(uint256 => CheesePiece)) private purchasedCheesePieces; // Map of Alla CheesePiece Buyed 

    mapping(address => uint256[]) private userCheesePieceIds;



    //--------------------------------------------------------------- Business Logic Service -----------------------------------------------------------------------------------------//

    function addCheesePiece(
        address walletConsumerBuyer,
        address walletRetailer, // Riferimento al wallet del Retailer
        uint256 id,
        uint256 price,
        uint256 weight
    ) external returns (uint256, uint256, uint256) {

        CheesePiece storage cheesePieceControl = purchasedCheesePieces[walletConsumerBuyer][id];

        require(cheesePieceControl.id == 0, "CheesePiece gia' presente!");

        // Crea un nuovo CheesePiece
        CheesePiece memory cheesePiece = CheesePiece({
            id: id,
            walletRetailer: walletRetailer,
            price: price,
            weight: weight
        });

        // Inserisce il nuovo CheesePiece nella lista purchasedCheesePieces
        purchasedCheesePieces[walletConsumerBuyer][id] = cheesePiece;

        //Inserisci l'id all'interno della Lista
        userCheesePieceIds[walletConsumerBuyer].push(id);

        return (
            purchasedCheesePieces[walletConsumerBuyer][id].id,
            purchasedCheesePieces[walletConsumerBuyer][id].price,
            purchasedCheesePieces[walletConsumerBuyer][id].weight
            );
    }

    function getCheesePiece(address walletConsumerBuyer, uint256 idCheesePiece) external view returns (uint256, address, uint256, uint256) {
        CheesePiece memory cheesePiece = purchasedCheesePieces[walletConsumerBuyer][idCheesePiece];

        
        return (cheesePiece.id, cheesePiece.walletRetailer, cheesePiece.price, cheesePiece.weight);
    }

    function isCheesePiecePresent(address walletConsumerBuyer, uint256 idCheesePiece) external view returns(bool) {
        require(idCheesePiece != 0 && idCheesePiece > 0, "ID CheesePiece Not Valid!");
        
        return purchasedCheesePieces[walletConsumerBuyer][idCheesePiece].id != 0;
    }

    function getWeight(address walletConsumerBuyer, uint256 id) external view returns (uint256) {
        return purchasedCheesePieces[walletConsumerBuyer][id].weight;
    }

    function getPrice(address walletConsumerBuyer, uint256 id) external view returns (uint256) {
        return purchasedCheesePieces[walletConsumerBuyer][id].price;
    }

    function getWalletRetailer(address walletConsumerBuyer, uint256 id) external view returns (address) {
        return purchasedCheesePieces[walletConsumerBuyer][id].walletRetailer;

    }
    
    /*
    * Restituisce la Lista di tutti gli ID dei prodotti di un determinato utente
    */
    function getUserCheesePieceIds(address walletConsumer)external view returns (uint256[] memory){
        return userCheesePieceIds[walletConsumer];
    }
}
