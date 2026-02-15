import 'package:books_discovery_app/core/network/dio_client.dart';
import 'package:books_discovery_app/feature/home/data/datasources/book_remote_datasource.dart';

import 'dart:developer';

void main() async {
  log('Testing Google Books API...');

  final dioClient = DioClient();
  final dataSource = BookRemoteDataSourceImpl(dioClient: dioClient);

  try {
    log('Searching for "author"...');
    final books = await dataSource.searchBooks('author');
    log('Success! Found ${books.length} books');

    if (books.isNotEmpty) {
      log('First book: ${books.first.title}');
      log('Authors: ${books.first.authors}');
    }
  } catch (e) {
    log('Error: $e');
  }
}
