import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/request/product_model.dart';
import '../models/responses/product_response_model.dart';

class ProductDatasources {
  Future<ProductResponseModel> createProduct(ProductModel model) async {
    // try {
    final newMap = model.toMap();
    var headers = {'Content-Type': 'application/json'};
    print(model.toJson());
    final response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/products'),
      headers: headers,
      body: model.toJson(),
    );
    print('=====');
    print(response.body);
    return ProductResponseModel.fromJson(response.body);
    // } catch (e) {

    // }
  }

  Future<ProductResponseModel> updateProduct(ProductModel model, int id) async {
    var headers = {'Content-Type': 'application/json'};

    final response = await http.put(
      Uri.parse('https://api.escuelajs.co/api/v1/products/$id'),
      headers: headers,
      body: model.toJson(),
    );
    print(response.body);

    return ProductResponseModel.fromJson(response.body);
  }

  Future<ProductResponseModel> getProductById(int id) async {
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/products/$id'),
    );

    return ProductResponseModel.fromJson(response.body);
  }

  Future<List<ProductResponseModel>> getAllProduct() async {
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/products'),
    );

    final result = List<ProductResponseModel>.from(jsonDecode(response.body)
        .map((x) => ProductResponseModel.fromMap(x))).toList();

    return result;
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('https://api.escuelajs.co/api/v1/products/$id'),
    );

    print(response.body);

    return;
  }
}
