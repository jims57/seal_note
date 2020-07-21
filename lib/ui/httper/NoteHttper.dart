import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:retry/retry.dart';

Future<List<NoteEntry>> fetchPhotos({@required http.Client client}) async {
  final r = RetryOptions(maxAttempts: 5);
  int tryTimes = 0;

  try {
    final response = await r.retry(
      () {
        tryTimes++;

        return client
            .get('https://jsonplaceholder.typicode.com/photos')
            .timeout(Duration(seconds: 10));
      },
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    return compute(parsePhotos, response.body);
  } on TimeoutException catch (e) {
    int tr = tryTimes;
    String s = 'd';
    throw ('timeout: $tryTimes. err:$e');
  } on SocketException catch (e) {
    int tr = tryTimes;
    String s = 'd';
    throw ('err:$e');
  } finally {
    int tr = tryTimes;
    client.close();
  }
}

List<NoteEntry> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  List<NoteEntry> noteEntryList =
      parsed.map<NoteEntry>((json) => NoteEntry.fromJson(json)).toList();

  return noteEntryList;
}
