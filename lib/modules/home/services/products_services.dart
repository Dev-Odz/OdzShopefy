import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductServices {
  Future<List<dynamic>> getAllProducts() async {
    try {
      var url = Uri.https('fakestoreapi.com', '/products');

      // API REQUEST
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      List<dynamic> parsedData = jsonDecode(response.body);

      return parsedData;
    } catch (e) {
      List<dynamic> errorResponse = [
        {"status": 500, "message": "Something went wrong"}
      ];
      return errorResponse;
    }
  }

  Future<Map<String, dynamic>> getProduct({required int? productId}) async {
    try {
      var url =
          Uri.https('fakestoreapi.com', '/products/${productId.toString()}');

      // API REQUEST
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      print(response.body);

      Map<String, dynamic> parsedData = jsonDecode(response.body);

      return parsedData;
    } catch (e) {
      print(e);
      Map<String, dynamic> errorResponse = {
        "status": 500,
        "message": "Something went wrong"
      };
      return errorResponse;
    }
  }
}
