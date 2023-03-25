import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/image_item.dart';

class KakaoApis {
  final _kakaoApiUrl = "dapi.kakao.com";
  final _imageSearchPath = "/v2/search/image";

  final _restAPIKey = dotenv.env['KAKAO_REST_KEY'];

  Map<String, String> getHeader() {
    Map<String, String> headers = {};
    headers["X-NCP-APIGW-API-KEY-ID"] = "92tjl5ggwl";
    headers["Authorization"] = "KakaoAK $_restAPIKey";

    return headers;
  }

  Future<ImageSearchResponse?> getImageItems(Map<String, dynamic> params) async {
    var url = Uri.https(_kakaoApiUrl, _imageSearchPath, params);

    // debugPrint("url $url");

    var response = await http.get(url, headers: getHeader());
    var jsonResponse = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      if (jsonResponse == null) {
        return null;
      }

      // debugPrint("getImageItems() ${jsonResponse.toString()}");

      ImageSearchResponse result = ImageSearchResponse.fromJson(jsonResponse);
      return result;
    } else {
      debugPrint('[Error] getImageItems() response Error $jsonResponse');
    }

    return null;
  }
}
