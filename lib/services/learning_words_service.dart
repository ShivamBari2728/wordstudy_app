import 'dart:convert';
import 'package:dio/dio.dart';
import '../Models/learningWordsModel.dart';

class LearningWordsService {
  final Dio _dio = Dio();

  Future<List<LearningWord>> fetchSimpleWords() async {
    final response = await _dio.get(
      'https://raw.githubusercontent.com/ShivamBari2728/tempstorage/refs/heads/main/learningwordsdata', // your real URL
      options: Options(
        responseType: ResponseType.plain, 
      ),
    );
    final Map<String, dynamic> jsonMap =
        jsonDecode(response.data as String);


    final List<dynamic> list = jsonMap['simpleWords'];


    return list
        .map((e) => LearningWord.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
