import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class APIService {
  // baseUrl = "https://api.exchangerate.host/latest";
  // https://exchangerate.host/#/

  static Map<String, dynamic> parseExchangeRate(String responseBody) {
    var data = json.decode(responseBody) as Map<String, dynamic>;
    return data["rates"];
  }

  static Future<Map<String, dynamic>> getExchangeRate() async {
    try {
      var url = Uri.https('api.apilayer.com', '/exchangerates_data/latest', {
        'symbols': '', // Thêm các ký hiệu tiền tệ bạn muốn truy vấn vào đây, ví dụ: 'USD,EUR,GBP'
        'base': '',    // Thêm đơn vị tiền tệ bạn muốn chuyển đổi từ, ví dụ: 'USD'
      });

      final response = await http.get(url, headers: {
        'apikey': '3VcgeIMhbdfFQfZgx8m92mnJ1i2ItT93', // Thay bằng khóa API của bạn
      });

      if (response.statusCode == 200) {
        // Xuất thông điệp debug về nội dung phản hồi
        print('Phản hồi API: ${response.body}');

        // Phân tích và trả về dữ liệu
        return compute(parseExchangeRate, response.body);
      } else {
        // Xuất thông điệp debug về lỗi
        print('Không thể tải dữ liệu JSON. Mã trạng thái: ${response.statusCode}');

        throw Exception('Không thể tải dữ liệu JSON');
      }
    } catch (error) {
      // Xuất thông điệp debug về bất kỳ ngoại lệ nào
      print('Ngoại lệ trong quá trình gọi API: $error');

      // Xử lý ngoại lệ một cách thích hợp
    }
    return {};
  }

  // https://gist.githubusercontent.com/ngoctienUIT/e81b1119d12c6dadfa3b7902a80e0928/raw/f621703926fc13be4f618fb4a058d0454177cceb/countries.json

  static Future<List<Map<String, dynamic>>> parseCountry(
      String responseBody) async {
    var data = json.decode(responseBody) as Map<String, dynamic>;
    var listSymbol = await getSymbolCurrency();
    List<Map<String, dynamic>> list =
        (data["countries"]["country"] as List<dynamic>).map((e) {
      Map<String, dynamic> item = {};
      var symbol = listSymbol
          .where((element) => element["abbreviation"] == e["currencyCode"])
          .toList();
      item["countryName"] = e["countryName"];
      item["currencyCode"] = e["currencyCode"];
      item["symbol"] = symbol.isNotEmpty ? symbol[0]["symbol"] : "";
      if (item["symbol"] == null) item["symbol"] = "";
      return item;
    }).toList();
    return list;
  }

  static Future<List<Map<String, dynamic>>> getCountry() async {
    try {
      var url = Uri.https(
        'gist.githubusercontent.com',
        '/ngoctienUIT/e81b1119d12c6dadfa3b7902a80e0928/raw/f621703926fc13be4f618fb4a058d0454177cceb/countries.json',
        {'q': '{https}'},
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return compute(parseCountry, response.body);
      } else {
        throw Exception('Failed to load json data');
      }
    } catch (_) {}
    return [];
  }

  // https://gist.githubusercontent.com/ngoctienUIT/dcc4088614d668816352eb1b2b16a5c8/raw/28d6e58f99ba242b7f798a27877e2afce75a5dca/currency-symbols.json

  static List<Map<String, dynamic>> parseSymbolCurrency(String responseBody) {
    var data = json.decode(responseBody) as List<dynamic>;
    List<Map<String, dynamic>> list =
        data.map((e) => e as Map<String, dynamic>).toList();
    return list;
  }

  static Future<List<Map<String, dynamic>>> getSymbolCurrency() async {
    try {
      var url = Uri.https(
        'gist.githubusercontent.com',
        'ngoctienUIT/dcc4088614d668816352eb1b2b16a5c8/raw/28d6e58f99ba242b7f798a27877e2afce75a5dca/currency-symbols.json',
        {'q': '{https}'},
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return compute(parseSymbolCurrency, response.body);
      } else {
        throw Exception('Failed to load json data');
      }
    } catch (_) {}
    return [];
  }
}
