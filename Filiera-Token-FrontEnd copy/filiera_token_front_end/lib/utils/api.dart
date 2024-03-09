class API {

  /**
   * URL API
   */
  static const String MilkHubNodePort = "5000";
  static const String CheeseProducerNodePort = "5001";
  static const String RetailerNodePort = "5002";
  static const String ConsumerNodePort = "5003";
  static const String IP = "http://127.0.0.1:";
  static const String URL = "/api/v1/namespaces/default/apis/";

  static const String Invoke = "invoke/";
  static const String Query = "query/";

  /**
   * Costanti MilkHub
   */
  static const String MilkHubService = "MilkHubService";
  static const String MilkHubInventoryService = "MilkHubInventoryService";

  /**
   * Costanti CheeseProducer
   */
  static const String CheeseProducerService = "CheeseProducerService";
  static const String CheeseProducerInventoryService = "CheeseProducerInventoryService";
  static const String CheeseProducerBuyerService = "CheeseProducerBuyerService";

  /**
   * Costanti Retailer
   */
  static const String RetailerService = "RetailerService";
  static const String RetailerInventoryService = "RetailerInventoryService";
  static const String RetailerBuyerService = "RetailerBuyerService";


  /**
   * Costanti Consumer
   */
  static const String ConsumerService = "ConsumerService";
  static const String ConsumerBuyerInventoryService = "ConsumerBuyerService"; 


  static const String TransactionBuyMilkBatchService = "TransactionBuyMilkBatchService";
  static const String TransactionBuyCheeseService = "TransactionBuyCheeseService";
  static const String TransactionBuyCheesePieceService = "TransactionBuyCheesePieceService";

  /**
   * Questa funzione permette di costruire l'URL per la chiamata di un metodo dell'API utilizzando le costanti offerte dalla classe api.dart
   * 
   * @param interface: definisce il nome dell'interfaccia da richiamare (per esempio un Service).
   * @param callType: per scrittura URL.Invoke, per lettura URL.Query.
   * @param methodName: nome del metodo all'interno dell'interfaccia.
   */
  static String buildURL(String port, String interface, String callType, String methodName) => ("${API.IP}$port${API.URL}$interface/$callType$methodName");

  static Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',
    };
  }

//Payload (Get) ---------------------------------------------------------------------------------------------------------------------------------------

  static Map<String, dynamic> getMilkHubPayload(String wallet){
    return {
      'input': {
        'walletMilkHub': wallet,
      }
    };
  }

  static Map<String, dynamic> getMilkBatchPayload(String wallet, String id){
    return {
      'input': {
        'id': id,
        'walletMilkHub': wallet
      }
    };
  }

  static Map<String, dynamic> getCheeseProducerPayload(String wallet){
    return {
      'input': {
        'walletCheeseProducer': wallet,
      }
    };
  }  

  static Map<String, dynamic> getCheeseBlockPayload(String wallet, String id){
    return {
      'input': {
        'idCheeseBlock': id,
        'walletCheeseProducer': wallet
      }
    };
  }

  static Map<String, dynamic> getRetailerPayload(String wallet){
    return {
      'input': {
        'walletRetailer': wallet,
      }
    };
  }  

  static Map<String, dynamic> getCheesePieceRetailerPayload(String wallet, String id){
    return {
      'input': {
        'idCheesePiece': id,
        'walletRetailer': wallet
      }
    };
  }

  static Map<String, dynamic> getConsumerPayload(String wallet){
    return {
      'input': {
        'walletConsumer': wallet,
      }
    };
  }

  static Map<String, dynamic> getCheesePieceConsumerPayload(String wallet, String id){
      return {
        "input": {
      "idCheesePiece": id,
      "walletConsumerBuyer": wallet
        }
      };
  }

  static Map<String, dynamic> getCheesePiecePayload(String wallet,String id){
    return {
      'input': {
        '_id_CheesePieceAcquistato': id,
        'walletConsumerBuyer': wallet,
      },
    };
  }
  

//Body (Add) ---------------------------------------------------------------------------------------------------------------------------------------

  static Map<String, dynamic> getMilkBatchBody(String wallet, String price, String quantity, String expirationDate){
    return {
      'input': {
        'price': price,
        'quantity': quantity,
        'expirationDate': expirationDate,
        'walletMilkHub': wallet
      }
    };
  } 

  static Map<String, dynamic> getCheeseBlockBody(String wallet, String milkBatchId, String dop, String quantity, String price) {
    return {
      'input': {
        'id_MilkBatchAcquistato': milkBatchId,
        'dop': dop,
        'quantity': quantity,
        'price': price,
        'walletCheeseProducer': wallet,
      }
    };
  }

  static Map<String, dynamic> getCheesePieceBody(String wallet,String walletRetailer, String cheeseBlockId, String price, String weight) {
    return {
        "input": {
        "_id": cheeseBlockId,
        "_price": price,
        "_walletConsumerBuyer": wallet,
        "_walletRetailer": wallet,
        "_weight": weight
      }
    };
  }

  static Map<String, dynamic> getTransformCheeseProducerBody(String dop, String idMilkBatch, String pricePerKg, String quantityToTransform, String walletCheeseProducer) {
    return {
      "input": {
        "dop": dop,
        "idMilkBatch": idMilkBatch,
        "pricePerKg": pricePerKg,
        "quantityToTransform": quantityToTransform,
        "walletCheeseProducer": walletCheeseProducer
      }
    };
  }



//----------------------------------------------------------- Get Body Product for Buyer --------------------------------------------------------------------------



  static Map<String,dynamic> getCheesePieceForConsumerBody(String cheeseId,String walletConsumerBuyer){
    return {
          "input": {
        "idCheesePiece": cheeseId,
        "walletConsumer": walletConsumerBuyer
      },
    };
  }

    static Map<String,dynamic> getCheeseBlockForRetailerBody(String cheeseId,String _walletRetailer){
    return {
      'input': {
        'idCheeseBlock': cheeseId,
        'walletRetailer': _walletRetailer,
      },
    };
  }

  static Map<String,dynamic> getMilkBatchForCheeseProducerBody(String milkBatchId, String walletCheeseProducer) {
    return 
    {
      "input": {
        "idMilkBatch":milkBatchId,
        "walletCheeseProducer": walletCheeseProducer
      }
    };
  }

  static Map<String, dynamic> getTransformRetailerBody(String idCheeseBlock, String price, String quantityToTransform, String walletRetailer) {
    return {
      "input": {
        "idCheeseBlock": idCheeseBlock,
        "price": price,
        "quantityToTransform": quantityToTransform,
        "walletRetailer": walletRetailer
      }
    };
  }


// -------------------------------------------------------------------------------------------- Buying Service ------------------------------------------------

  static buyMilkBatchProductBody(String milkBatchId, String quantityToBuy, String buyer, String ownerMilkBatch, String totalPrice){

    return {
      "input": {
      "_id_MilkBatch": milkBatchId,
      "_quantityToBuy": quantityToBuy,
      "buyer": buyer,
      "ownerMilkBatch": ownerMilkBatch,
      "totalPrice": totalPrice
    }
    };
  }

  static buyCheeseBlockProductBody(String cheeseBlockId, String quantityToBuy, String buyer, String ownerCheese, String totalPrice)
  {
    return {
        "input": {
        "_id_Cheese": cheeseBlockId,
        "_quantityToBuy": quantityToBuy,
        "buyer": buyer,
        "ownerCheese": ownerCheese,
        "totalPrice": totalPrice
      }
    };
  }

  static  buyCheesePieceProductBody(String cheesePieceId, String quantityToBuy, String buyer, String ownerCheesePiece, String totalPrice) {
    return {
      "input": {
        "_id_CheesePiece": cheesePieceId,
        "_quantityToBuy": quantityToBuy,
        "buyer": buyer,
        "ownerCheesePiece": ownerCheesePiece,
        "totalPrice": totalPrice
      },
    };
  }

}