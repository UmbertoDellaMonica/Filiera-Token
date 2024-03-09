
import 'package:filiera_token_front_end/utils/enums.dart';

/// Classe astratta per i Prodotti.
/// il parametro seller è da impostare solo per i valori restituiti dal Buyer, per il resto delle chiamate rimane inutilizzato.

// Product Inventory 
abstract class Product {

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.seller
  });

  final String id;
  final String name;
  final String description;
  final String seller;

  String getBarcode();

  double getUnitPrice();
  
  Asset getAsset();

  /*
   *  Metodi necessari per frontend
   */
  String getExpirationDate();
  double getQuantity();

  @override
  String toString() => 'Prodotto(id: $id)';

  void updateQuantity(int quantityChange);

}



/// Classe astratta per i Prodotti.
/// il parametro seller è da impostare solo per i valori restituiti dal Buyer, per il resto delle chiamate rimane inutilizzato.
// Product Purchased 
abstract class ProductPurchased {

  const ProductPurchased({
    required this.id,
    required this.name,
    required this.description,
    required this.seller
  });

  final String id;
  final String name;
  final String description;
  final String seller;

  String getBarcode();
  
  Asset getAsset();

  /*
   *  Metodi necessari per frontend
   */
  String getExpirationDate();
  double getQuantity();

  @override
  String toString() => 'Prodotto(id: $id)';

  void updateQuantity(int quantityChange);

}

class MilkBatch extends Product {

  MilkBatch({
    required String id,
    required String name,
    required String description,
    required String seller,
    required this.expirationDate,
    required this.quantity,
    required this.pricePerLitre,
  }) : super(id: id, name: name, description: description, seller: seller);

  final String expirationDate;
  int quantity;
  final double pricePerLitre;

  @override
  String getBarcode() => 'MilkBatch-$id';

  @override
  double getUnitPrice() => pricePerLitre;

  @override
  String toString() => 'MilkBatch(id: $id, scadenza: $expirationDate, '
      'quantità: $quantity, prezzo al litro: $pricePerLitre)';
  
  @override
  Asset getAsset() => Asset.MilkBatch;

  @override
  String getExpirationDate() => expirationDate;

  @override
  double getQuantity() => quantity.toDouble();
  
  @override
  void updateQuantity(int quantityChange) {
    quantity -= quantityChange;
  }
  
  static Product fromJson(Map<String, dynamic> milkBatchData, String wallet) {
    String name = "Partita di Latte";
    String description = "Silos contenente latte, disponibile all'acquisto immediato.";
    
    String id = milkBatchData['output'];
    String expirationDate = milkBatchData['output1'];
    String seller = wallet;
    String quantity = milkBatchData['output2'];
    double pricePerLitre = double.parse(milkBatchData['output3']);

    return MilkBatch(
            id: id, 
            name: name, 
            description: description, 
            seller: seller, 
            expirationDate: expirationDate, 
            quantity: int.parse(quantity), 
            pricePerLitre: pricePerLitre);
  }
}


class MilkBatchPurchased extends ProductPurchased {

  MilkBatchPurchased({
    required String id,
    required String name,
    required String description,
    required String seller,
    required this.expirationDate,
    required this.quantity,
  }) : super(id: id, name: name, description: description, seller: seller);

  final String expirationDate;
  int quantity;

  @override
  String getBarcode() => 'MilkBatch-$id';

  @override
  String toString() => 'MilkBatch(id: $id, scadenza: $expirationDate, '
      'quantità: $quantity)';
  
  @override
  Asset getAsset() => Asset.MilkBatch;

  @override
  String getExpirationDate() => expirationDate;

  @override
  double getQuantity() => quantity.toDouble();
  
  @override
  void updateQuantity(int quantityChange) {
    quantity -= quantityChange;
  }
  
  static ProductPurchased fromJson(Map<String, dynamic> milkBatchData) {
    String name = "Partita di Latte";
    String description = "Silos contenente latte, disponibile all'acquisto immediato.";
    String id = milkBatchData['output'];
    String seller = milkBatchData["output1"];
    String expirationDate = milkBatchData['output2'];
    String quantity = milkBatchData['output3'];

    return MilkBatchPurchased(
            id: id, 
            name: name, 
            description: description, 
            seller: seller, 
            expirationDate: expirationDate, 
            quantity: int.parse(quantity)
            );
  }


}




class CheeseBlock extends Product {

  CheeseBlock({
    required String id,
    required String name,
    required String description,
    required String seller,
    required this.dop,
    required this.price,
    required this.quantity,
  }) : super(id: id, name: name, description: description, seller: seller);

  final String dop;
  final double price;
  int quantity;

  @override
  String getBarcode() => 'Cheese-$id';

  @override
  double getUnitPrice() => price;

  @override
  String toString() => 'Cheese(id: $id, dop: $dop, prezzo: $price, '
      'quantità: $quantity)';

  @override
  Asset getAsset() => Asset.CheeseBlock;

  @override
  String getExpirationDate() => '';

  @override
  double getQuantity() => quantity.toDouble();
  
  @override
  void updateQuantity(int quantityChange) {
    quantity -= quantityChange;
  }
  
  static Product fromJson(Map<String, dynamic> cheeseBlockData,String wallet) {
    
    String name = "Blocco di Formaggio"; // Changed name
    String description = "Blocco di Formaggio intero di qualità certificata DOP."; // Changed description
    String id = cheeseBlockData['output'];
    String dop = cheeseBlockData['output1'];
    double price = double.parse(cheeseBlockData['output2']); // Parsing price as double
    int quantity = int.parse(cheeseBlockData['output3']); // Parsing quantity as int
    String seller = wallet; // TODO: Replace with function that returns the name of the CheeseProducer from CheeseProducerServiceù

    return CheeseBlock(
      id: id, 
      name: name, 
      description: description, 
      seller: seller, 
      dop: dop, 
      price: price, 
      quantity: quantity);
  }
}


class CheeseBlockPurchased extends ProductPurchased {

  CheeseBlockPurchased({
    required String id,
    required String name,
    required String description,
    required String seller,
    required this.dop,
    required this.quantity,
  }) : super(id: id, name: name, description: description, seller: seller);

  final String dop;
  int quantity;

  @override
  String getBarcode() => 'Cheese-$id';


  @override
  String toString() => 'Cheese(id: $id, dop: $dop,'
      'quantità: $quantity)';

  @override
  Asset getAsset() => Asset.CheeseBlock;

  @override
  String getExpirationDate() => '';

  @override
  double getQuantity() => quantity.toDouble();
  
  @override
  void updateQuantity(int quantityChange) {
    quantity -= quantityChange;
  }
  
  static ProductPurchased fromJson(Map<String, dynamic> cheeseBlockData) {
    String name = "Blocco di Formaggio"; // Changed name
    String description = "Blocco di Formaggio intero di qualità certificata DOP."; // Changed description
    
    String id = cheeseBlockData['output'];
    String seller = cheeseBlockData['output1']; // TODO: Replace with function that returns the name of the CheeseProducer from CheeseProducerServiceù
    String dop = cheeseBlockData['output2'];
    int quantity = int.parse(cheeseBlockData['output3']); // Parsing quantity as int

    return CheeseBlockPurchased(
      id: id, 
      name: name, 
      description: description, 
      seller: seller, 
      dop: dop, 
      quantity: quantity);
  }
}








class CheesePiece extends Product {

  const CheesePiece({
    required String id,
    required String name,
    required String description,
    required String seller,
    required this.price,
    required this.weight
  }) : super(id: id, name: name, description: description, seller: seller);

  final double price;
  final double weight;

  @override
  String getBarcode() => 'CheesePiece-$id';

  @override
  double getUnitPrice() => price;

  @override
  String toString() => 'CheesePiece(id: $id, prezzo: $price, peso: $weight)';

  @override
  Asset getAsset() => Asset.CheesePiece;

  @override
  String getExpirationDate() => '';

  @override
  double getQuantity() => weight;
  
  @override
  void updateQuantity(int quantityChange) {}
  
  static Product fromJson(Map<String, dynamic> cheesePiece, String wallet) {

    String id = cheesePiece['output'];
    String name = "Pezzo di Formaggio";
    String description = "Pezzo di formaggio di alta qualità.";
    double price = double.parse(cheesePiece['output1'] as String); // Parsing price as double
    double weight = double.parse(cheesePiece['output2'] as String);

    return CheesePiece(
      id: id, 
      name: name, 
      description: description, 
      seller: wallet, 
      price: price, 
      weight: weight);

  }
}



class CheesePiecePurchased extends ProductPurchased {

  const CheesePiecePurchased({
    required String id,
    required String name,
    required String description,
    required String seller,
    required this.price,
    required this.weight
  }) : super(id: id, name: name, description: description, seller: seller);

  final double price;
  final double weight;

  @override
  String getBarcode() => 'CheesePiece-$id';

  @override
  double getUnitPrice() => price / weight;

  @override
  String toString() => 'CheesePiece(id: $id, prezzo: $price, peso: $weight)';

  @override
  Asset getAsset() => Asset.CheesePiece;

  @override
  String getExpirationDate() => '';

  @override
  double getQuantity() => weight;
  
  @override
  void updateQuantity(int quantityChange) {}
  
  static ProductPurchased fromJson(Map<String, dynamic> cheesePiece) {
    String name = "Pezzo di Formaggio";
    String description = "Pezzo di formaggio di alta qualità.";

    String id = cheesePiece['output'];
    String seller = cheesePiece["output1"];
    double price = int.parse(cheesePiece['output2'] as String) as double; // Parsing price as double
    double weight = int.parse(cheesePiece['output3'] as String) as double;

    return CheesePiecePurchased(
      id: id, 
      name: name, 
      description: description, 
      seller: seller, 
      price: price, 
      weight: weight);

  }

}
