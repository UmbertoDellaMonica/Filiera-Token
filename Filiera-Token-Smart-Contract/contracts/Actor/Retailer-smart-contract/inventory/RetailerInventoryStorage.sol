// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RetailerInventoryStorage {

    // Address of the organization managing the users
    address private retailerOrg;

    constructor() {
        retailerOrg = msg.sender;
    }

    struct CheesePiece {
        uint256 id; // Cheese Piece ID 
        uint256 price;
        uint256 weight;
    }

    mapping(address => mapping(uint256 => CheesePiece)) private cheesePieces;

    mapping(address => uint256[]) userCheesePieceIds;

    uint256 [] private globalCheesePieceIds;

    // --------------------------------------------------- Business Function --------------------------------------------------------------------------------------//

    function addCheesePiece(
        address walletRetailer,
        uint256 price,
        uint256 weight) external returns (uint256, uint256, uint256) {

        uint256 id = uint256(keccak256(abi.encodePacked(
            price,
            weight,
            walletRetailer,
            block.timestamp
        )));

        // Crea un nuovo Pezzo di formaggio
        CheesePiece memory cheesePiece = CheesePiece({
            id: id,
            price: price,
            weight: weight
        });

        // Inserisce il riferimento all'interno della lista
        globalCheesePieceIds.push(id);

        // Inserisce il nuovo pezzo di formaggio nella Lista dell'utente 
        userCheesePieceIds[walletRetailer].push(id);

        // Inserisce il nuovo Pezzo di formaggio nella lista cheesePieces
        cheesePieces[walletRetailer][id] = cheesePiece;

        return (cheesePiece.id, cheesePiece.price, cheesePiece.weight);
    }

    function getCheesePiece(address walletRetailer, uint256 id) external view returns (uint256, uint256, uint256) {

        CheesePiece memory cheesePiece = cheesePieces[walletRetailer][id];

        return (cheesePiece.id, cheesePiece.price, cheesePiece.weight);
    }

    // Elimina il CheesePiece 
    function deleteCheesePiece(address walletRetailer, uint256 id) external returns (bool value) {

        delete cheesePieces[walletRetailer][id];
        // Check CheesePiece in the mapping 
        if (cheesePieces[walletRetailer][id].id == 0 && 
        deleteCheesePieceIdFromList(id) && 
        deleteCheesePieceIdFromSingleRetailerList(id, walletRetailer)) {
            return true;
        } else {
            return false;
        }
    }

    // Verifica che il CheesePiece è già presente 
    function isCheesePiecePresent(address walletRetailer, uint256 idCheesePiece) external view returns (bool) {

        require(idCheesePiece != 0 && idCheesePiece > 0, "ID CheesePiece Non Valido!");

        return cheesePieces[walletRetailer][idCheesePiece].id == idCheesePiece;
    }

// --------------------------------------------------- Set Function --------------------------------------------------------------------------------------//

    function updateWeight(
        address walletRetailer,
        uint256 idCheese,
        uint256 newQuantity
    ) external  {
        
        // Controllo sulla quantita' 
        require(newQuantity<=cheesePieces[walletRetailer][idCheese].weight,"Controllo della Quantita' da utilizzare non andata a buon fine!");

        cheesePieces[walletRetailer][idCheese].weight = newQuantity;
    }

    function deleteCheesePieceIdFromSingleRetailerList(uint256 id, address walletRetailer) internal returns (bool) {
        
        for (uint256 i = 0; ; i++) {
            if (userCheesePieceIds[walletRetailer][i] == id) {
                delete userCheesePieceIds[walletRetailer][i];
                return true;
            }
        }
        return false;
    }

    function deleteCheesePieceIdFromList(uint256 id) internal returns (bool) {
        for (uint256 i = 0; i < globalCheesePieceIds.length; i++) {
            if (globalCheesePieceIds[i] == id) {
                delete globalCheesePieceIds[i];
                return true;
            }
        }
        return false;
    }


// --------------------------------------------------- Get Function --------------------------------------------------------------------------------------//

    function getPrice(address walletRetailer, uint256 id) external view returns (uint256) {

        CheesePiece memory cheesePiece = cheesePieces[walletRetailer][id];
        return cheesePiece.price;
    }

    function getWeight(address walletRetailer, uint256 id) external view returns (uint256) {

        CheesePiece memory cheesePiece = cheesePieces[walletRetailer][id];
        return cheesePiece.weight;
    }

    /*
        - Funzione per recuperare tutti i MilKBatchPurchased di un determinato walletCheeseProducer
    */
    function getUserCheesePieceIds(address walletRetailer) external view returns (uint256[] memory) {
        return userCheesePieceIds[walletRetailer];
    }

    function getGlobalCheesePieceIds() external view returns (uint256[] memory) {
        return  globalCheesePieceIds;
    }


}
