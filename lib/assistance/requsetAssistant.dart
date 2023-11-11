import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RequsetAssistant {
  static Future<dynamic> receiveRequest(String url) async{
    http.Response httpResponse = await http.get(Uri.parse(url));
    try {
      if (httpResponse.statusCode == 200) {
        String responseData = httpResponse.body;
        var decodeResponseData = jsonDecode(responseData);
        return decodeResponseData;
      }else{
        return "Erreur !!!!!!!!!!!!!!!!!!";
      }
    } catch (exp) {
        return "Erreur !!!!!!!!!!!!!!!!!!";
 
    }
  }
}