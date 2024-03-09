import 'dart:async' show Future;
import 'package:filiera_token_front_end/Actor/CheeseProducer/service/CheeseProducerService.dart';
import 'package:filiera_token_front_end/Actor/MilkHub/service/MilkHubService.dart';
import 'package:filiera_token_front_end/Actor/Retailer/service/RetailerService.dart';
import 'package:filiera_token_front_end/models/User.dart';

import 'package:filiera_token_front_end/Actor/Consumer/service/ConsumerService.dart';


class UserSerivce {

  final MilkHubService _milkHubService = MilkHubService();

  final CheeseProducerService _cheeseProducerService = CheeseProducerService();

  final ConsumerService _consumerService = ConsumerService();

  final RetailerService _retailerService = RetailerService();


  Future<bool> registrationUser(String email, String fullName, String password, String walletMilkHub, String typeUser) async {
    
    switch(typeUser){
      
      case "MilkHub":{
        return _milkHubService.registerMilkHub(email, fullName, password, walletMilkHub);
      }
      case "CheeseProducer":{
        return  _cheeseProducerService.registerCheeseProducer(email, fullName, password, walletMilkHub);
      }
      case "Retailer":{
        return _retailerService.registerRetailer(email, fullName, password, walletMilkHub);
      }
      case "Consumer":{
        return _consumerService.registerConsumer(email, fullName, password, walletMilkHub);
      }
      default:{
        return false;
      }
    }
  }


  Future<User?> getData(String typeUser, String wallet) async{
    switch(typeUser){
      
      case "MilkHub":{
        /// Recover ID
        String id = await _milkHubService.getMilkHubId(wallet);
        return await _milkHubService.getMilkHubData(id,wallet);
      }
      case "CheeseProducer":{
        /// Recover ID
        String id = await _cheeseProducerService.getCheeseProducerId(wallet);
        return await _cheeseProducerService.getCheeseProducerData(id,wallet);
      }
      case "Retailer":{
        /// Recover ID
        String id = await _retailerService.getRetailerId(wallet);
        return await _retailerService.getRetailerData(id,wallet);
      }
      case "Consumer":{
        /// Recover ID
        String id = await _consumerService.getConsumerId(wallet);
        return await _consumerService.getConsumerData(id,wallet);
      }
      
      default:{
        return null;
      }
    }
    
  }


  Future<bool> login(String email, String password, String walletMilkHub, String typeUser) async {

    switch(typeUser){
      
      case "MilkHub":{
        return _milkHubService.loginMilkHub(email, password, walletMilkHub);
      }
      case "CheeseProducer":{
        return  _cheeseProducerService.loginCheeseProducer(email, password, walletMilkHub);
      }
      case "Retailer":{
        return  _retailerService.loginRetailer(email, password, walletMilkHub);
      }
      case "Consumer":{
        return _consumerService.loginConsumer(email, password, walletMilkHub);
      }
      default:{
        return false;
      }
    }
  }

}


