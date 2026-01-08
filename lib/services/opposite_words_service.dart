import 'dart:convert';
import 'package:dio/dio.dart';
import '../Models/oppositeWordsModel.dart';

class OppositeWordsService {
  final Dio _dio = Dio();

  Future<List<OppositeWord>> fetchOppositeWords() async {
    final response = await _dio.get(
      'https://raw.githubusercontent.com/ShivamBari2728/tempstorage/refs/heads/main/oppositeWordsData', 
      options: Options(responseType: ResponseType.plain),
    );

    final Map<String, dynamic> jsonMap =
        jsonDecode(response.data as String);

    final List<dynamic> list = jsonMap['oppositeWords'];

    return list
        .map((e) => OppositeWord.fromJson(e))
        .toList();
  }
}
