import 'dart:async';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'locator.dart';

class CRUDModel extends ChangeNotifier {
  Api _api = locator<Api>();

  List<Persona> products;


  /*Future<List<Persona>> fetchProducts() async {
    
    var result = await _api.getDataCollection();
    products = result.documents
        .map((doc) => Persona.fromMap(doc.data, doc.documentID))
        .toList();
    return products;
  } 

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Persona> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Persona.fromMap(doc.data, doc.documentID) ;
  }*/


  Future removeProduct(String id) async{
     await _api.removeDocument(id) ;
     return ;
  }
  Future updateProduct(Persona data,String id) async{
   // await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addProduct(Persona data) async{
   // var result  = await _api.addDocument(data.toJson()) ;

    return ;

  }


}